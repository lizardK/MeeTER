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

    property string date
    property string dateServiceFormatted
    property alias placeholder: dateLabel.text
    height: 50

    Rectangle {
        border.width: 2
        border.color: "#d2d2d2"
        width: parent.width - 4; height: 50
        x:2
        radius: 15
        Label {
            id: dateLabel
            width: parent.width - iconCalendar.width
            x:15;y: 10
            platformStyle: LabelStyle {
                fontFamily: "Arial"
                fontPixelSize: 26
                textColor: "#aaa"
            }
        }

        Image {
            id: iconCalendar
            source: "qrc:/pix/calendar.png"
            anchors{
                right: parent.right
                rightMargin: 8
                top: parent.top
                topMargin: 10
            }
            width: 30;height: 30
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var d = new Date();
                datePickerDialog.year = d.getFullYear();
                datePickerDialog.month = d.getMonth();
                datePickerDialog.day = d.getDate();
                datePickerDialog.open();
            }
        }

    }
    DatePickerDialog{
        id:datePickerDialog
        titleText: qsTr("Jour de départ")
        onAccepted: {
            var d = datePickerDialog.day + "",
                    m = datePickerDialog.month + "";

            if(m.length === 1)
                m = "0" + m;
            if(d.length === 1)
                d = "0" + d;

            dateServiceFormatted = [datePickerDialog.year, m, d].join('|');

            date =  [d, m, datePickerDialog.year].join(' / ');
            dateLabel.text =  date
        }
    }
}
