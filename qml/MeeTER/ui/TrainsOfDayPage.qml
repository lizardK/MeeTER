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
    id: trainsOfDay
    tools: commonTools
    property string stationID
    property int page: -1

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
        id: filterTrainsOfDayModel
    }

    ListModel {
        id:trainsOfDayModel
        Component.onCompleted: Services.fetchAllTrainsOfDay(trainsOfDayModel,stationID,0, false)
        function onFetch(data){
            page = data.np;
            for ( var index in data.t  )
            {
                var dt = new Date();
                dt.setHours(data.t[index].st.split(":")[0]);
                dt.setMinutes(data.t[index].st.split(":")[1]);
                trainsOfDayModel.append( {
                                            id:data.t[index].id,
                                            routeName:data.t[index].rn,
                                            from:data.t[index].from.replace("gare de ",""),
                                            fromID:data.t[index].fromID,
                                            to:data.t[index].to.replace("gare de ",""),
                                            toID:data.t[index].toID,
                                            startTime:data.t[index].st,
                                            endTime: data.t[index].et,
                                            duration:   data.t[index].duration,
                                            date: dt
                                        });
            }
            loading.visible = false;
            noResults.visible = trainsOfDayModel.count === 0;
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
        title: qsTr("Prochains départs")
    }

    ListView {
        id: listTravels
        anchors.top: pageHeader.bottom
        model: trainsOfDayModel
        width: parent.width; height: parent.height - pageHeader.height
        delegate: listDelegate
        onAtYEndChanged: {
            if (listTravels.atYEnd && page !== -1) {
                loading.visible = true;
                Services.fetchAllTrainsOfDay(trainsOfDayModel,stationID,page,true);
            }
        }
    }
    ScrollDecorator { flickableItem: listTravels }

    Component {
        id: listDelegate
        Item {
            id: menuItem
            width: listTravels.width;  height: 130

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    onClicked: pageStack.push(Qt.resolvedUrl("TrainDetailsPage.qml"),{travelID: id, from: fromID, to:toID,date:date,duration:duration})
                }
            }

            SectionHeader {
                id: listHeader
                title: "durée " + duration
            }

            Column {
                id: rect
                width:  listTravels.width - 10;height: parent.height
                x: 5
                anchors.top: listHeader.bottom
                spacing: 10

                Label {
                    text: qsTr("le ") +  Utils.dateToString(date)
                    platformStyle: LabelStyle {
                        fontFamily: "Arial"
                        fontPixelSize: 18
                    }
                }

                Rectangle {
                    id: x
                    width: parent.width - 90; height: parent.height
                    color: "transparent"

                    Image {
                        id: columnImage
                        anchors.top: parent.top
                        y: 20
                        source: "qrc:/pix/route.png"
                        width: 40; height:80
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
                                     textColor: theme.inverted? "#fff" :  "#777"
                                    fontFamily: "Arial"
                                    fontPixelSize: 22
                                }
                            }
                        }
                        Row {
                            spacing: 20
                            Label {
                                id: lblEndTime
                                x: 10; y:5
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
                                     textColor: theme.inverted? "#fff" :  "#777"
                                    fontFamily: "Arial"
                                    fontPixelSize: 22
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
