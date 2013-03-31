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

Page {
    tools: commonTools

    Component.onCompleted: {
        toolButtonBack.visible = true;
    }

    PageHeader {
        id: headerParameters
        title: "Paramètres"
    }

    Flickable {
        width: parent.width - 20
        x: 10
        anchors{
            top: headerParameters.bottom
            topMargin: 20
        }

        SectionHeader {
            id: headerApparence
            title: qsTr("Apparence")
            anchors {
                top:parent.top
                topMargin: 20
                bottomMargin: 20
            }
        }

        Label {
            id: lblStyle
            anchors.top: headerApparence.bottom
            text: qsTr("Style du thème :")
        }

        ButtonRow {
            id: btnsAppearance
            anchors {
                top: lblStyle.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            Button {
                text: "Clair"
                checked: appSettings.getValue("APPEARANCE/theme") === "clear";
                onClicked: {
                    theme.inverted = false;
                    appSettings.setValue("APPEARANCE/theme", "clear");
                }
            }
            Button {
                text: "Sombre"
                checked: appSettings.getValue("APPEARANCE/theme") === "dark";
                onClicked: {
                    theme.inverted = true;
                    appSettings.setValue("APPEARANCE/theme", "dark");
                }
            }
        }

        SectionHeader {
            id: headerMapStyle
            title: qsTr("Carte")
            anchors {
                top: btnsAppearance.bottom
                topMargin: 20
                bottomMargin: 20
            }
        }

        Label {
            id: lblMapStyle
            anchors.top: headerMapStyle.bottom
            text: qsTr("Style de la carte :")
        }

        ButtonRow {
            id: btnsMapStyle
            anchors {
                top: lblMapStyle.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            Button {
                text: "Carte"
                checked: appSettings.getValue("APPEARANCE/map") === "NORMAL";
                onClicked: {
                    appSettings.setValue("APPEARANCE/map", "NORMAL");
                }
            }
            Button {
                text: "Relief"
                checked: appSettings.getValue("APPEARANCE/map") === "TERRAIN";
                onClicked: {
                    appSettings.setValue("APPEARANCE/map", "TERRAIN");
                }
            }
            Button {
                text: "Satellite"
                checked: appSettings.getValue("APPEARANCE/map") === "SATELLITE";
                onClicked: {
                    appSettings.setValue("APPEARANCE/map", "SATELLITE");
                }
            }
        }
    }
}

