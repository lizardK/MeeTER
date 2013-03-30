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
import QtMobility.location 1.2
import "components"
import "../services/services.js" as Services

//50,60568190
//3,12320270

Page {
    id: aroundMePage
    tools: commonTools

    property int radius
    property Coordinate coords

    Component.onCompleted: {
        toolButtonBack.visible = true;
        map.reload();
    }

    ErrorView{
        id: errorView
    }

    function updateModel() {
        stationsNearModel.clear();
        if(map.position && radius > 0)
            Services.fetchAllStationsNearBy(stationsNearModel,map.position,radius);
    }

    Item {
        id:stationsNearModel
        ListModel {
            id: models
        }

        function clear() {
            models.clear();
        }

        function onFetch(data){
            var markers = new Array();
            for ( var index in data  ) {
                var id = data[index].id.toLowerCase();
               models.append( {
                                  id:data[index].id,
                                  name:data[index].n,
                                  city:data[index].ct,
                                  country: data[index].c,
                                  lat:data[index].coords.lat,
                                  lon: data[index].coords.lon
                              });

                markers.push({
                                 id:data[index].id,
                                 title:data[index].n,
                                 text: data[index].ct + " - " + data[index].c,
                                  img:"",
                                  lat: data[index].coords.lat,
                                  long: data[index].coords.lon,
                                  alt: "0"
                              });
            }
            map.aroundMe(markers,radius);
        }
        function onFetchError(msg){
            console.log(msg);
            errorView.visible = true;
        }
    }

    PageHeader {
        id: pageHeader
        title: "Autour de moi"
    }

    Rectangle {
        id: container
        anchors.top: pageHeader.bottom
        height: parent.height / 6; width: parent.width
        color: "transparent"

        Rectangle {
            id: infos
            width: container.width; height: 100
            color: "transparent"

            SectionHeader {
                id: infosHeader
                title: qsTr("Dans un rayon de ")
            }

            Row {
                id: row
                anchors{
                    top: infosHeader.bottom
                    topMargin: 50 - row.height / 2
                }
                x: parent.width/2 - row.width / 2
                y: parent.height/2 - row.height / 2
                spacing: 10

                Button {
                    id: btnLess
                    width: 60;height: 50
                    text: "-"
                    onClicked: {
                        if(radius > 0)radius--;
                        updateModel();
                    }
                }

                TextField {
                    id: txtRadiusEdit
                    width: 150; height: 50
                    text: radius+ " Km"

                }

                Button {
                    id: btnPlus
                    width: 60; height: 50
                    text: "+"
                    onClicked: {
                        radius++;
                        updateModel();
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.top: container.bottom
        width: parent.width; height: parent.height  - container.height
        color: "transparent"

        SectionHeader {
            id: mapHeader
            title: qsTr("Les gares trouvées")
        }

        MapWebView {
            id: map
            width: parent.width;  height: parent.height  - mapHeader.height
            anchors.top: mapHeader.bottom
            withGeolocation: true
            onLoaded: {
                map.setZoomLevel(10);
            }
            onPositionChanged: {
                updateModel();
            }
        }
    }
}

