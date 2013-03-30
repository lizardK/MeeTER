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

Rectangle{
    id: header
    property string title

    anchors.top:parent.top; anchors.left: parent.left; anchors.right: parent.right
    width: parent.width ; height: parent.height/10
    color: "#04AEDA"
    z: 10
    Row {
        x: 10
        spacing: 10
        Image {
            id: logo
            x: 10; y: 5
            source:  "qrc:/pix/MeeTER-80.png"
            width: header.height - 10;height: header.height - 10
        }

        Text {
            id: titleText
           // height: header.height - 20
            y: header.height / 2 - titleText.height / 2
            font.bold: true
            font.pointSize: 22
            text: header.title
            wrapMode: Text.WordWrap
            color: "#fff"
        }

    }
}


