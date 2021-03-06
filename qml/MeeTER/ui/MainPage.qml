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
import "../js/utils.js" as Utils
import "components"

Page {
    id: home
    tools: commonTools

    Component.onCompleted: {}

    onVisibleChanged: {
        toolButtonBack.visible = !visible;
    }

    PageHeader {
        id: pageHeader
        title: "MeeTER"
    }

    ListView {
        id: listMenu
        width: parent.width -20 ; height: parent.height;
        z:-1; y: 50;x:10
        anchors{
            top: pageHeader.bottom
            topMargin: 20
        }
        clip: true

        model: ListModel{
            id: listMenuModel
            Component.onCompleted: {
                 if(appSettings.contains("FAVOURITES/station/size") && appSettings.getValue("FAVOURITES/station/size") > 0) {
                   listMenuModel.append( {
                                             name: "Favoris",
                                             desc: "Mes gares favorites",
                                             page: "FavouritesPage.qml"
                                         });
                }
            }

            ListElement {
                name: "Autour de moi"
                desc: "Rechercher des gares à proximité"
                page: "AroundMePage.qml"
            }
            ListElement {
                name: "Toutes les gares"
                desc: "Afficher la liste des gares"
                page: "AllStationsPage.qml"
            }
            ListElement {
                name: "Rechercher un train"
                desc: "Recherche avancée"
                page: "SearchPage.qml"
            }

        }
        delegate: menuItemDelegate
        interactive:false
    }

    Component {
        id: menuItemDelegate
        Item {
            id: menuItem
            width: listMenu.width;height: 80

            MouseArea {
                id: mArea
                anchors.fill: parent
                onClicked:{
                    pageStack.push(Qt.resolvedUrl(page))
                }
            }

            Rectangle {
                id: rect
                width:  listMenu.width
                height: parent.height
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
                    x: 10;y: 10
                    Column {
                        id:c
                        Label {
                            id: lblTitle
                            x: 10;  y: 15
                            text: name
                            font.bold: true
                            platformStyle: LabelStyle {
                                fontFamily: "Arial"
                                fontPixelSize: 26
                            }
                        }
                        Label {
                            id: lblDesc
                            x: 10;  y: 15
                            text:  desc
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
            Rectangle {
                width: listMenu.width; height: 1
                anchors.top: menuItem.bottom
                border.width: 1
                border.color: "#fff"
            }

        }
    }
}

