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
import "../js/utils.js" as Utils

Page {
    id: favourites
    tools: commonTools

    property bool updateItemVisibleState:false

    Component.onCompleted: {
        toolButtonBack.visible = true;
    }

    ListModel{
       id: stationsModelFiltered
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
        Component.onCompleted: {
            var stations = eval ( appSettings.getArrayJson("FAVOURITES/station") );
            stationsModel.clear();
            for (var i=0; i<stations.length; i++) {
                stationsModel.append( {
                                         id:stations[i].id,
                                         name:stations[i].name,
                                         city:stations[i].city,
                                         country: stations[i].country,
                                         lat:stations[i].lat,
                                         lon: stations[i].lon
                                     });
                stationsModelFiltered.append( {
                                         id:stations[i].id,
                                         name:stations[i].name,
                                         city:stations[i].city,
                                         country: stations[i].country,
                                         lat:stations[i].lat,
                                         lon: stations[i].lon
                                     });
            }
            loading.visible = false;
            noResults.visible = stationsModel.count == 0;
        }
    }

    PageHeader {
        id: pageHeader
        title: qsTr("Mes gares favorites")
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
        id: listViewFavourites
        width: favourites.width; height: parent.height - pageHeader.height
        anchors.top: pageHeader.bottom
        clip: true
        model: stationsModelFiltered

        header:  TextField {
            id:searchField;
            width: favourites.width; height: 60
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
                        stationsModelFiltered.clear();
                        for (var i = 0; i < stationsModel.count; i++) {
                            stationsModelFiltered.append(stationsModel.get(i));
                        }
                    }
                }
            }

            onTextChanged: {
                stationsModelFiltered.clear();

                for (var i = 0; i < stationsModel.count; i++) {
                    if(stationsModel.get(i).name.toLowerCase().indexOf(searchField.text.toLowerCase()) !== -1)
                        stationsModelFiltered.append(stationsModel.get(i));
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
            if(listViewFavourites.contentY < -50){
                updateItemVisibleState = true
            }
        }
    }

    ScrollDecorator { flickableItem: listViewFavourites }
    SectionScroller { listView: listViewFavourites; }

    Component {
        id: listDelegate

        Item {
            id: menuItem
            width: listViewFavourites.width;height: 80
            MouseArea {
                id: mArea
                anchors.fill: parent
                onClicked:{
                    pageStack.push(Qt.resolvedUrl("StationPage.qml"),{stationID:id,stationName:name, stationLatitude: lat, stationLongitude: lon, stationCity:city, stationCountry: country});
                }
            }

            Rectangle {
                id: rect
                width:  listViewFavourites.width;height: parent.height

                color:  {
                    if(!mArea.pressed)
                        return "transparent";
                    if(theme.inverted)
                        return "#333" ;
                    return "#d2d2d2" ;
                }
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
                                 textColor: theme.inverted? "#999" :  "#333"
                                fontFamily: "Arial"
                                fontPixelSize: 18
                            }
                        }
                    }
                }

                Image {
                    id: imgNext
                    anchors{
                        right: parent.right
                        top: parent.top
                        topMargin: parent.height / 2 - imgNext.height / 2
                    }
                    source: Utils.handleIconSource("toolbar-next")
                }
            }
        }
    }
}
