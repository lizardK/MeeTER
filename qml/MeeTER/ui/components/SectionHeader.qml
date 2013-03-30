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
    property string title

    id: sectionHeader

    width: parent.width - 20
    height: txt.height

    x: 10

    color: "transparent"

    Label  {
        id: txt
        text:  sectionHeader.title
        anchors.left: line.right
        anchors.leftMargin: 10
        font.bold: true
        font.pixelSize: 16
        color: "#777"
    }

    Rectangle {
        id: line
        height: 1;width: parent.width - txt.width - 20
        anchors {
            topMargin: - txt.height / 2
            leftMargin: 10
            top: txt.bottom
        }
        border {
            color: "#fff"
            width: 1
        }
    }
}
