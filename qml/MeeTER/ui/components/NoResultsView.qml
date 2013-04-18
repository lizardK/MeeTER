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

Rectangle {
    id: noResutsView
    width: parent.width;height: parent.height
    color: "transparent"
    opacity: 0.9
    visible: false
    Text{
        width: parent.width - 20
        x: 10
       anchors.centerIn: parent
       text: qsTr("Aucun résultat")
       wrapMode: Text.WordWrap
       horizontalAlignment: Text.AlignHCenter
       font.pointSize: 34
       color: theme.inverted? "#999" :  "#333"
    }
}
