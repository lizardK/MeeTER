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
import com.nokia.extras 1.1
import QtMobility.organizer 1.1
import "components"
import "../services/services.js" as Services
import "../js/utils.js" as Utils

Page {
    id: trainDetails
    tools: toolBarTrainDetails
    property string travelID
    property string from
    property string to
    property string routeName
    property string duration
    property date date

    ToolBar{
        id:toolBarTrainDetails
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        tools:  ToolBarLayout {
            id: trainDetailsTool
            visible: true
            ToolIcon {
                id: toolButtonBack
                iconId: "toolbar-back";
                onClicked: { myMenu.close(); pageStack.pop(); }
            }
            ToolIcon {
                id: toolButtonAddAlarm
                iconId: "toolbar-add";
                visible: true
                onClicked: {
                    dlgQueryAddToOrganizer.open()
                }
            }
            ToolIcon {
                platformIconId: "toolbar-view-menu"
                anchors.right: (parent === undefined) ? undefined : parent.right
                onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
            }
        }
    }

    Event {
      id: myEvent
      startDateTime: date.toISOString() //"2013-03-28T23:35:00Z"
      endDateTime:date.toISOString()
      displayLabel: qsTr("Train ") + routeName

    }

    OrganizerModel {
        id: orgaModel
    }

    QueryDialog {
        id: dlgQueryAddToOrganizer
        titleText:  qsTr("Agenda")
        message: qsTr("Voulez-vous ajouter ce voyage à l'agenda ?")
        acceptButtonText: qsTr("Ajouter")
        rejectButtonText: qsTr("Annuler")
        onAccepted:  {
            orgaModel.saveItem(myEvent)
            orgaModel.update()
        }
    }


    LoadingView{
        id: loading
    }

    ErrorView{
        id: errorView
    }

    ListModel {
        id:travelModel
        Component.onCompleted: Services.fetchTrain(travelModel,travelID, from, to)
        function onFetch(data){
            for ( var index in data  )
            {
                routeName = data[index].rn;
                var t1, t2;
                for ( var i in data[index].stops  )
                {
                    travelModel.append( {
                                           name: data[index].stops[i].n,
                                           time: data[index].stops[i].t,
                                           isFirstItem: (i == 0),
                                           isLastItem: (i == data[index].stops.length - 1)
                                       });
                }
            }
            loading.visible = false;
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
        title: qsTr("Détails du voyage")
    }

    Rectangle {
        id: lblInfos
        anchors{
            top: pageHeader.bottom
            topMargin: 10
        }
        width:parent.width -10; height: 70
        x: 5;y:10
        color: "transparent"
        Column {
            spacing: 10
            Label {
                text: qsTr("Ligne : ") + routeName
            }
            Row {
                spacing:  20
                Label {
                    text: qsTr("le ") + Utils.dateToString(date)
                }
                Label {
                    text: qsTr("Durée : ") + duration
                }
            }
        }
        Rectangle {
            width: parent.width;  height: 1
            anchors{
                topMargin: 5
                top: parent.bottom
            }
            border{
                width: 1
                color: "#fff"
            }
        }
    }

    ListView {
        id: listViewTrain
        anchors{
            top: lblInfos.bottom
            topMargin: 20
        }

        width: parent.width;  height: parent.height - pageHeader.height - lblInfos.height
        x: parent.x; y: 10
        model: travelModel
        delegate: listDelegate
        clip: true
    }

    ScrollDecorator { flickableItem: listViewTrain }

    Component {
        id: listDelegate

        Item {
            id: menuItem
            width: listViewTrain.width; height: 70

            Column {
                id: rect
                width:  listViewTrain.width - 10;height: parent.height
                x: 5
                spacing: 10

                Rectangle {
                    id: x
                    width: parent.width - 90; height: parent.height
                    color: "transparent"

                    Image {
                        id: mage
                        anchors.top: parent.top
                        y: 20
                        source: isFirstItem?"qrc:/pix/walk.png":"qrc:/pix/walk_invert.png"
                        width: 40; height:30
                        visible: isFirstItem || isLastItem
                    }

                    Column {
                        id: colImgCourse
                        anchors {
                            left: mage.right
                            top: parent.top
                            topMargin: 5
                        }

                        Image {
                            id: imgCourse
                            x: (!isFirstItem && !isLastItem)?10:0; y: (!isFirstItem && !isLastItem)?10:0
                            source:  (isFirstItem || isLastItem)?"qrc:/pix/station.png":"qrc:/pix/circle.png"
                            width:  (isFirstItem || isLastItem)?40:20; height: (isFirstItem || isLastItem)?26:20
                        }

                        Rectangle {
                            id: line
                            x: 20; y: 20
                            width: 1; height:48
                            visible: !isLastItem
                            border.width: 5
                            border.color:"#04AEDA"
                        }
                    }

                    Rectangle {
                        width: parent.width; height: x.height
                        color: "transparent"

                        anchors {
                            top: parent.top
                            left: colImgCourse.right
                            leftMargin: (!isFirstItem && !isLastItem)?20:0
                        }

                        Label {
                            id: lblFrom
                            text:  name
                            platformStyle: LabelStyle {
                                fontFamily: "Arial"
                                fontPixelSize: 22
                                textColor: theme.inverted?"#fff" : "#333"
                            }
                        }

                        Label {
                            id: lblStartTime
                            anchors {
                                right: parent.right
                            }
                            x: 10
                            text: time
                            platformStyle: LabelStyle {
                                fontFamily: "Arial"
                                fontPixelSize: 22
                                textColor: "#04AEDA"
                            }
                        }
                    }
                }
            }
        }
    }
}
