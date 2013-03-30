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
import "components"
import "../services/services.js" as Services


Page {
    id: search
    tools: commonTools
    property string stationID

    Component.onCompleted: {
        toolButtonBack.visible = true;
    }

    ListModel {
        id:stationsModel
        Component.onCompleted: Services.fetchAllStations(stationsModel)
        function onFetch(data){
            for ( var index in data  )
            {
                stationsModel.append( {
                                         id:data[index].id,
                                         name:data[index].n,
                                         city:data[index].ct,
                                         country: data[index].c,
                                         lat:data[index].coords.lat,
                                         lon: data[index].coords.lon
                                     });
                if(stationID === data[index].id) {
                    textFieldDeparture.placeholder = data[index].n;
                    textFieldDeparture.value = stationID;
                }
            }
            loading.visible = false;

        }
        function onFetchError(msg){
            console.log(msg);
            loading.visible = false;
            errorView.visible = true;
        }
    }

    PageHeader {
        id: pageHeader
        title: "Rechercher un train"
    }

    SectionHeader {
        id: infosHeader
        title: qsTr("Départ - Arrivée")
        anchors {
            top: pageHeader.bottom
            topMargin: 20
            bottomMargin: 20
        }
    }

    SectionHeader {
        id: dateHeader
        title: qsTr("Date")
        anchors {
            top: columnStations.bottom
            topMargin: 20
            bottomMargin: 20
        }
    }

    DateSelector {
        id: dateSelector
        anchors {
            top: dateHeader.bottom
            topMargin: 20
            bottomMargin: 20
        }
        width: parent.width
        placeholder: qsTr("le ")
    }

    SectionHeader {
        id: timeHeader
        title: qsTr("Heure")
        anchors {
            top: dateSelector.bottom
            topMargin: 20
            bottomMargin: 20
        }
    }

    Column {
        id: columnTime
        anchors {
            top: timeHeader.bottom
            topMargin: 20
            bottomMargin: 20
        }
        width: parent.width
        spacing: 5

        TimeSelector {
            id: startTime
            width: parent.width
            placeholder: qsTr("entre ")
        }

        TimeSelector {
            id: endTime
            width: parent.width
            placeholder: qsTr("et ")
        }

    }

    Button {
        id: btnSearch
        x: parent.width / 2 - btnSearch.width / 2
        anchors {
            top: columnTime.bottom
            topMargin: 20
        }

        onClicked: {
            if(textFieldDeparture.value !== "" && textFieldArrival.value !== "") {
                stationID = textFieldDeparture.value;
                pageStack.push(Qt.resolvedUrl("ResultsPage.qml"),{from:stationID,
                                   to:textFieldArrival.value,
                                   date: dateSelector.date,
                                   dateService: dateSelector.dateServiceFormatted,
                                   startTime: startTime.timeServiceFormatted,
                                   endTime:endTime.timeServiceFormatted
                               });
            }
        }

        text: qsTr("Rechercher")
    }

    Column {
        id: columnStations
        anchors {
            top: infosHeader.bottom
            topMargin: 20
            bottomMargin: 20
        }
        width: parent.width
        spacing: 5

        TextFieldCompleter {
            id: textFieldDeparture
            width: parent.width
            model: stationsModel
            placeholder: qsTr("Départ")
            visible: true// (stationID === undefined || stationID === "" )
        }

        TextFieldCompleter {
            id: textFieldArrival
            width: parent.width
            model: stationsModel
            placeholder: qsTr("Arrivée")
            z: -1
        }
    }

    LoadingView{
        id: loading
        z: 100
    }

    ErrorView{
        id: errorView
        z: 101
    }
}
