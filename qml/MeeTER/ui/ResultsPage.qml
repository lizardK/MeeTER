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
import "../js/utils.js" as Utils
import "../services/services.js" as Services

Page {
    id: stationPage
    tools: commonTools
    property string from
    property string to
    property string dateService
    property string date
    property string startTime
    property string endTime

    Component.onCompleted: {
        toolButtonBack.visible = true;
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
        id:trainsModel
        Component.onCompleted: Services.fetchTrains(trainsModel, from,to,dateService,startTime,endTime)
        function onFetch(data){

            for ( var index in data  )
            {
                 var dt = new Date(date.split(" / ")[2], parseInt(date.split(" / ")[1]) - 1, date.split(" / ")[0], data[index].st.split(":")[0], data[index].st.split(":")[1]);
                trainsModel.append( {
                                       id:data[index].id,
                                       routeName:data[index].rn,
                                       from:data[index].from.replace("gare de ",""),
                                       to:data[index].to.replace("gare de ",""),
                                       startTime:data[index].st,
                                       endTime: data[index].et,
                                       duration: data[index].duration,
                                       dateTime: dt
                                   });
            }
            loading.visible = false;
            noResults.visible = trainsModel.count == 0;
        }
        function onFetchError(msg){
            loading.visible = false;
            noResults.visible = false;
            errorView.visible = true;
        }
    }

    PageHeader {
        id: pageHeader
        title: qsTr("Résultats")
    }

    ListView {
        id: listTravels
        anchors.top: pageHeader.bottom
        model: trainsModel
        width: parent.width; height: parent.height - pageHeader.height
        delegate: listDelegate
    }

    //#04AEDA
    Component {
        id: listDelegate

        Item {
            id: menuItem
            width: listTravels.width; height: 130

            MouseArea {
                id: mArea
                anchors.fill: parent
                onClicked: {
                    onClicked: pageStack.push(Qt.resolvedUrl("TrainDetailsPage.qml"),{travelID: id,from:stationPage.from, to: stationPage.to,date:dateTime,duration:duration})
                }
            }

            SectionHeader {
                id: listHeader
                title: "durée " + duration
            }

            Column {
                id: rect
                width:  listTravels.width - 10; height: parent.height
                x: 5
                anchors.top: listHeader.bottom
                spacing: 10

                Label {
                    text: qsTr("le ") + date
                    platformStyle: LabelStyle {
                        fontFamily: "Arial"
                        fontPixelSize: 18
                    }
                }

                Rectangle {
                    id: x
                    width: parent.width - 90; height: parent.height
                    color:  {
                        if(!mArea.pressed)
                            return "transparent";
                        if(theme.inverted)
                            return "#333" ;
                        return "#d2d2d2" ;
                    }

                    Image {
                        id: columnImage
                        anchors.top: parent.top
                        y: 20
                        width: 40; height:80
                        source: "qrc:/pix/route.png"
                    }

                    Column {
                        id:c
                        anchors{
                            top: parent.top
                            left: columnImage.right
                        }

                        spacing: 20

                        Row {
                            spacing: 20
                            Label {
                                id: lblStartTime
                                x: 10
                                text: startTime
                                platformStyle: LabelStyle {
                                    fontFamily: "Arial"
                                    fontPixelSize: 22
                                    textColor: "#04AEDA"
                                }
                            }
                            Label {
                                id: lblFrom
                                x: 10
                                text:  from
                                platformStyle: LabelStyle {
                                    fontFamily: "Arial"
                                    fontPixelSize: 22
                                    textColor: "#333"
                                }
                            }
                        }
                        Row {
                            spacing: 20
                            Label {
                                id: lblEndTime
                                x: 10;y:5
                                text: endTime
                                platformStyle: LabelStyle {
                                    fontFamily: "Arial"
                                    fontPixelSize: 22
                                    textColor: "#04AEDA"
                                }
                            }
                            Label {
                                id: lblTo
                                x: 10; y:5
                                text:  to
                                platformStyle: LabelStyle {
                                    fontFamily: "Arial"
                                    fontPixelSize: 22
                                    textColor: "#333"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
