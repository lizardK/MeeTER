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
    id: stationPage
    tools: commonTools

    property string stationID
    property string stationName
    property double stationLatitude
    property double stationLongitude
    property string stationCity
    property string stationCountry

    Component.onCompleted: {
        map.reload();
        toolButtonBack.visible = true;
    }

    LoadingView{
        id: loading
        z: 100
    }


    PageHeader {
        id: pageHeader
        title: qsTr("Chercher un train")
    }

    MapWebView {
        id: map
        width: parent.width; height: parent.height / 2
        anchors.top: pageHeader.bottom
        withGeolocation: false
        onLoaded: {
            loading.visible = false;
            if(stationLatitude != 0 && stationLongitude != 0) {
                map.findStation(stationName,{
                                    lat: stationLatitude,
                                    long: stationLongitude,
                                    alt: "0"
                                });
            }
        }
    }

    Rectangle {
        id: container
        anchors.top: map.bottom
        height: parent.height /2; width: parent.width
        color: "transparent"

        Rectangle {
            id: infos
            width: container.width; height: 100
            color: "transparent"

            SectionHeader {
                id: infosHeader
                title: qsTr("informations")            }

            Row {
                anchors.top: infosHeader.bottom
                width: parent.width
                x: 10
                spacing: 20

                Image {
                    id: trainIcon
                    source:  "qrc:/pix/Logo_train_transilien.svg"
                    width: 80;height:80
                }

                Column {
                    spacing: 5
                    width: parent.width - trainIcon.width -btnTel.width - 60
                    Text {
                        id: txtName
                        text: stationName
                        font.bold: true
                        font.pixelSize: 20
                        wrapMode: Text.WordWrap
                    }
                    Text {
                        id: txtAddr
                        width: parent.width
                        text:  (map.stationInformations) ? map.stationInformations.address.text : ""
                        font.bold: false
                        font.pixelSize: 16
                        color: "#333"
                        wrapMode: Text.WordWrap
                    }
                }
                Button {
                    id: btnTel
                    width: 130;  height: 70
                    y:5
                    iconSource: "qrc:/pix/phone.png"
                    visible: ( map.stationInformations && map.stationInformations.contacts && map.stationInformations.contacts.phone[0]) ?true : false
                    onClicked: Qt.openUrlExternally("tel:" + map.stationInformations.contacts.phone[0].value);
                }
            }
        }

        Rectangle {
            id: options
            width: parent.width; height: parent.height - infos.height
            anchors.top: infos.bottom
            color: "transparent"

            SectionHeader {
                id: optionsHeader
                title: qsTr("Trains")
            }

            ListView {
                id: listMenu
                anchors.top: optionsHeader.bottom
                width: parent.width; height: parent.height
                clip:true
                model: ListModel{
                    ListElement {
                        desc: "Les prochains départs"
                        page: "TrainsOfDayPage.qml"
                    }
                    ListElement {
                        desc: "Rechercher un train"
                        page: "SearchPage.qml"
                    }
                }
                delegate: menuItemDelegate
            }

            Component {
                id: menuItemDelegate
                Item {
                    id: menuItem
                    width: listMenu.width; height: 80

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            pageStack.push(Qt.resolvedUrl(page),{stationID: stationPage.stationID})
                        }
                    }

                    Rectangle {
                        id: rect
                        width:  listMenu.width;  height: parent.height
                        color: "transparent"

                        Rectangle {
                            id: x
                            width: parent.width - 90
                            y:20
                            Column {
                                id:c
                                Label {
                                    id: lblDesc
                                    x: 10; y: 15
                                    text:  desc
                                    platformStyle: LabelStyle {
                                        fontFamily: "Arial"
                                        fontPixelSize: 26
                                    }
                                }
                            }
                        }

                        Image {
                            anchors.left: x.right
                            anchors.top: parent.top
                            anchors.topMargin: -25
                            source:  "qrc:/pix/arraow_next.png"
                        }

                    }
                    Rectangle {
                        width: listMenu.width -10;height: 1
                        x: 5
                        anchors.top: menuItem.bottom
                        border.width: 1
                        border.color: "#fff"
                    }
                }
            }
        }
    }
}
