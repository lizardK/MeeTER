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


Item {

    property string time
    property string timeServiceFormatted
    property alias placeholder: timeLabel.text
    height: 50

    Rectangle {
        border.width: 2
        border.color: "#d2d2d2"
        width: parent.width - 4; radius: 15
        x:2
        height: 50
        Label {
            id: timeLabel
            width: parent.width - iconTime.width
            x:15;y: 10
            platformStyle: LabelStyle {
                fontFamily: "Arial"
                fontPixelSize: 26
                textColor: "#aaa"
            }
        }

        Image {
            id: iconTime
            source: "qrc:/pix/time.png"
            anchors{
                right: parent.right
                rightMargin: 5
                top: parent.top
                topMargin: 10
            }
            width: 30;height: 30
        }

        MouseArea {
            anchors.fill: parent
            onClicked:  timePickerDialog.open()
        }
    }

    TimePickerDialog{
        id:timePickerDialog
        titleText: qsTr("Heure de départ")
        acceptButtonText:  qsTr("Valider")
        rejectButtonText: qsTr("Annuler")
        onAccepted: {
            var h =  timePickerDialog.hour + "",
                    m = timePickerDialog.minute + "",
                    s = timePickerDialog.second + "";

            if(h.length === 1)
                h = "0" + h;
            if(m.length === 1)
                m = "0" + m;
            if(s.length === 1)
                s = "0" + s;

            timeServiceFormatted = [h, m].join('|');
            time =   [h, m, s].join(':');
            timeLabel.text =  time
        }
    }
}
