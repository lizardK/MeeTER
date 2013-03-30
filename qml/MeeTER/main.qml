/****************************************************************************
**
** Copyright (C) 2013 Cyril Biencourt.
** Contact: Cyril Biencourt (c.biencourt@orange.fr)

**This file is part of MeeTER.

** MeeTER is free software: you can redistribute it and/or modify
** it under the terms of the GNU Lesser General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.

** Foobar is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU Lesser General Public License for more details.

**  You should have received a copy of the GNU Lesser General Public License
**  along with Foobar.  If not, see <http://www.gnu.org/licenses/>
**
****************************************************************************/
import QtQuick 1.1
import com.nokia.meego 1.1
import "ui" as Ui

PageStackWindow {
    id: appWindow

    initialPage: mainPage

    Ui.MainPage {
        id: mainPage
    }

    Component.onCompleted: {
        //theme.inverted = true;
    }

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon {
            id: toolButtonBack
            iconId: "toolbar-back";
            onClicked: { myMenu.close(); pageStack.pop(); }
        }
      /*  ToolIcon {
            id: toolButtonAddAlarm
            iconId: "toolbar-alarm";
            visible: false
            onClicked: {

            }
        }*/
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
           /* MenuItem {
                id: itParameters
                text: qsTr("Paramètres")
                onClicked:  pageStack.push(Qt.resolvedUrl("ui/ParametersPage.qml"));
            }*/
            MenuItem {
                id: itAbout
                text: qsTr("A propos")
                onClicked:  pageStack.push(Qt.resolvedUrl("ui/AboutPage.qml"));
            }

        }
    }
}
