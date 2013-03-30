/****************************************************************************
**
** Copyright (C) 2013 Cyril Biencourt.
** Contact: Cyril Biencourt (c.biencourt@orange.fr)

**This file is part of MeeTER.

** MeeTER is free software: you can redistribute it and/or modify
** it under the terms of the GNU Lesser General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.

** MeeTER is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU Lesser General Public License for more details.

**  You should have received a copy of the GNU Lesser General Public License
**  along with MeeTER.  If not, see <http://www.gnu.org/licenses/>
**
****************************************************************************/
import QtQuick 1.1
import com.nokia.meego 1.1
import "components"
import "../services/services.js" as Services

Page {
    id: allStations
    tools: commonTools

    property bool updateItemVisibleState:false

    Component.onCompleted: {
        toolButtonBack.visible = true;
    }

    ListModel {
        id: filterStationsModel
    }

    LoadingView{
        id: loading
    }

    NoResultsView{
        id: noResults
    }

    ErrorView{
        id: errorView
    }

    ListModel {
        id:stationsModel
        Component.onCompleted: Services.fetchAllStations(stationsModel)
        function onFetch(data){

            for ( var index in data  ){
                stationsModel.append( {
                                         id:data[index].id,
                                         name:data[index].n,
                                         city:data[index].ct,
                                         country: data[index].c,
                                         lat:data[index].coords.lat,
                                         lon: data[index].coords.lon,
                                         alphabet: data[index].ct.substring(0,1)
                                     });

                filterStationsModel.append( {
                                               id:data[index].id,
                                               name:data[index].n,
                                               city:data[index].ct,
                                               country: data[index].c,
                                               lat:data[index].coords.lat,
                                               lon: data[index].coords.lon,
                                               alphabet: data[index].ct.substring(0,1)
                                           });
            }
            loading.visible = false;
            noResults.visible = stationsModel.count == 0;
        }
        function onFetchError(msg){
            console.log(msg);
            loading.visible = false;
            noResults.visible = false;
            errorView.visible = true;
        }
    }

    PageHeader {
        id: pageHeader
        title: qsTr("Toutes les gares")
    }

    Timer{
        id:searchTimer
        interval: 5000
        repeat:false
        onTriggered: {
            updateItemVisibleState = false
        }
    }

    ListView {
        id: listViewAllStations
        width: allStations.width; height: parent.height - pageHeader.height
        anchors.top: pageHeader.bottom
        clip: true
        model: filterStationsModel

        header:  TextField {
            id:searchField;
            width: allStations.width; height: 60
            visible:updateItemVisibleState?true:false
            inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
            placeholderText: (searchField.state == "visible")?qsTr("Recherche"):""
            onActiveFocusChanged: (searchField.activeFocus) ? searchTimer.restart() : searchTimer.stop()
            Image {
                id: searchButton
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                source: (searchField.text == "") ? "image://theme/icon-m-common-search" : "image://theme/icon-m-input-clear"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        searchField.text = "";
                        filterStationsModel.clear();
                        for (var i = 0; i < stationsModel.count; i++) {
                            filterStationsModel.append(stationsModel.get(i));
                        }
                    }
                }
            }

            onTextChanged: {
                filterStationsModel.clear();

                for (var i = 0; i < stationsModel.count; i++) {
                    if(stationsModel.get(i).name.toLowerCase().indexOf(searchField.text.toLowerCase()) !== -1)
                        filterStationsModel.append(stationsModel.get(i));
                }
                searchField.focus = true
            }
        }
        delegate: listDelegate
        section.property: "city"
        section.criteria: ViewSection.FullString
        section.delegate: SectionHeader {
            height: childrenRect.height
            title: section
        }

        onMovementEnded: {
            searchTimer.start()
        }
        onContentYChanged: {
            if(listViewAllStations.contentY < -50){
                updateItemVisibleState = true
            }
        }
    }

    ScrollDecorator { flickableItem: listViewAllStations }
    SectionScroller { listView: listViewAllStations; }

    Component {
        id: listDelegate

        Item {
            id: menuItem
            width: listViewAllStations.width;height: 80
            MouseArea {
                anchors.fill: parent
                onClicked:{
                    pageStack.push(Qt.resolvedUrl("StationPage.qml"),{stationID:id,stationName:name, stationLatitude: lat, stationLongitude: lon, stationCity:city, stationCountry: country});
                }
            }

            Rectangle {
                id: rect
                width:  listViewAllStations.width;height: parent.height
                color: "transparent"

                Rectangle {
                    id: x
                    width: parent.width - 90
                    x: 10
                    Column {
                        id:c
                        y: 15
                        spacing: 10
                        Label {
                            id: lblTitle
                            x: 10; y: 25
                            text: name
                            platformStyle: LabelStyle {
                                fontFamily: "Arial"
                                fontPixelSize: 26
                            }
                        }
                        Label {
                            id: lblDesc
                            x: 10;y: 15
                            text:  city + " - " + country
                            platformStyle: LabelStyle {
                                textColor: "#333"
                                fontFamily: "Arial"
                                fontPixelSize: 18
                            }
                        }
                    }
                }

                Image {
                    anchors{
                        left: x.right
                        top: parent.top
                        topMargin: -25

                    }
                    source:  "qrc:/pix/arraow_next.png"
                }
            }
        }
    }
}
