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


Item {

    property ListModel model
    property string value
    property alias textValue: searchField.text
    property alias placeholder: searchField.placeholderText

    height: 50

    ListModel {
        id: filterModel
    }

    TextField {
        id: searchField
        width: parent.width
        //enableSoftwareInputPanel: true
        inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase

        onTextChanged: {
            if(searchField.text === ""){
                filterModel.clear();
                autoCompleteListContainer.visible = false;
                return;
            }
            filterModel.clear();

            for (var i = 0; i < model.count; i++) {
                if(model.get(i).name.toLowerCase().indexOf(searchField.text.toLowerCase()) !== -1)
                    filterModel.append(model.get(i));
            }
            searchField.focus = true
            autoCompleteListContainer.visible = true
        }

        onActiveFocusChanged: {

        }
        Image {
            id: searchButton
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            source: (searchField.text === "") ? "image://theme/icon-m-common-search" : "image://theme/icon-m-input-clear"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    searchField.text = "";
                    filterModel.clear();
                    autoCompleteListContainer.visible = false;
                }
            }
        }
    }

    Rectangle {
        id: autoCompleteListContainer
        anchors {
            top: searchField.bottom
        }
        width: searchField.width; height: 500
        visible: false
        color:"#E0E1E2"
        z: 100
        ListView {
            id: autoCompleteList
            model: filterModel
            anchors.top: parent.top
            width: parent.width; height: parent.height
            visible: parent.visible
            clip: true
            delegate: Rectangle {
                width: autoCompleteList.width - 10; height: 70
                x: 5
                color: "transparent"
                Label{
                    id: lblName
                    text: name
                    anchors.top: parent.top
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            value = id;
                            searchField.text = name;
                            autoCompleteListContainer.visible = false;
                        }
                    }
                }
                Rectangle {
                    anchors.top: lblName.bottom
                    width: parent.width
                    height: 1
                    border.width: 1
                    border.color: "#fff"
                }
            }
        }

        ScrollDecorator { flickableItem: autoCompleteList }
    }
}
