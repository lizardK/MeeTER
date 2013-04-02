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
    id: about
    tools: commonTools

    Component.onCompleted: {
        toolButtonBack.visible = true;
    }

    PageHeader {
        id: headerAbout
        title: qsTr("A propos de MeeTER")
    }

    Rectangle {
        width: parent.width - 10; height: parent.height
        x: 5; y:5
        anchors.top: headerAbout.bottom
        color: "transparent"

        Column {
             width: parent.width; height: parent.height
            spacing: 10

            SectionHeader {
                id: sourcesHeader
                title: qsTr("Sources")
            }

            Text {
                id:txtSources
                width: parent.width
                text: "Les sources sont disponibles à <br /> <a href='https://github.com/lizardK/MeeTER'>https://github.com/lizardK/MeeTER</a>"
                font.pixelSize: 20
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                onLinkActivated: Qt.openUrlExternally(link);
                color: theme.inverted? "#fff" : "#000"
            }

            SectionHeader {
                id: licenseHeader
                title: qsTr("Licence")
            }

            Text {
                id:txtLicense
                width: parent.width
                text:  ["<p>Copyright (C) 2013 Cyril Biencourt.</p>",
                    "<p>Contact: Cyril Biencourt (<a href='mailto:c.biencourt@orange.fr'>c.biencourt@orange.fr</a>)</p>",

                    "<p>This file is part of MeeTER.</p>",

                    "<p>MeeTER is free software: you can redistribute it and/or modify",
                    "it under the terms of the GNU Lesser General Public License as published by",
                    "the Free Software Foundation, either version 3 of the License, or",
                    "(at your option) any later version.</p>",

                    "<p>MeeTER is distributed in the hope that it will be useful,",
                    "but WITHOUT ANY WARRANTY; without even the implied warranty of",
                    "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the",
                    "GNU Lesser General Public License for more details.</p>",

                    "<p>You should have received a copy of the GNU Lesser General Public License</p>",
                    "<p>along with MeeTER.  If not, see <a href='http://www.gnu.org/licenses/'>http://www.gnu.org/licenses/</a></p>"].join('');
                font.pixelSize: 20
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                onLinkActivated: Qt.openUrlExternally(link);
                color: theme.inverted? "#fff" : "#000"
            }
        }
    }
}

