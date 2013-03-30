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
import QtWebKit 1.0

Item {
    id: mapItem
    property bool withGeolocation: false
    property variant stationInformations
    property Coordinate position

    signal loaded

    WebView {
        id: mapWebView
        width: parent.width;height:parent.height
        clip: true
        settings.javascriptEnabled: true
        settings.localContentCanAccessRemoteUrls : true
        settings.javascriptCanOpenWindows : true
        settings.autoLoadImages: true
        settings.linksIncludedInFocusChain: true
        pressGrabTime: 0

        url: "qrc:/html/map.html"

        javaScriptWindowObjects: [
            QtObject {
                WebView.windowObjectName: "qml"

                function qmlCall(data) {
                    var d = JSON.parse(data);
                    console.log("This call is in QML! : " + d.title);
                    stationInformations = d;
                }

                function selectStation(id, name, lat,lon) {
                    pageStack.push(Qt.resolvedUrl("../StationPage.qml"),{stationID:id,stationName:name, stationLatitude: lat, stationLongitude: lon});
                }
            }
        ]
        onLoadFinished: mapItem.loaded()
        onAlert: console.log(message)

    }

    function reload() {
        mapWebView.reload.trigger();
    }

    function setZoomLevel(zoomLevel){
        mapWebView.evaluateJavaScript(["MAP.setZoomLevel(", zoomLevel, ")"].join(''));
    }

    function findStation(name, coords){
        var s = ['MAP.findStation("', name , '", {',
                 'lat:', coords.lat , ',',
                 'long: ', coords.long , ',',
                 'alt: ', coords.alt ,
                 '})'].join('');
        console.log(s);
        mapWebView.evaluateJavaScript(s);
    }

    function setCenter(coords) {
        var s = ['MAP.setCenter({',
                 'lat:', coords.lat , ',',
                 'long: ', coords.long , ',',
                 'alt: ', coords.alt ,
                 '})'].join('');
        mapWebView.evaluateJavaScript(s);
    }

    function addMarker(marker) {
        var s = ['MAP.addMarker({',
                 'infos: {',
                 'title: "', marker.title ,'",',
                 'img: " ', marker.img , '",',
                 'text: "', marker.text ,'"',
                 '},',
                 'coords: {',
                 'lat:', marker.lat , ',',
                 'long: ', marker.long , ',',
                 'alt: ', marker.alt ,
                 '}',
                 '})'].join('');
        console.log(s);
        mapWebView.evaluateJavaScript(s);
    }

    function aroundMe(markers, radius) {
        var sMarkers = "";
        markers.forEach(function(m){
                            sMarkers +=   ['{',
                                           'infos: {',
                                           'id: "', m.id ,'",',
                                           'title: "', m.title ,'",',
                                           'img: " ', m.img , '",',
                                           'text: "', m.text ,'"',
                                           '},',
                                           'coords: {',
                                           'lat:', m.lat , ',',
                                           'long: ', m.long , ',',
                                           'alt: ', m.alt ,
                                           '}',
                                           '},'].join('');
                        });
        sMarkers = sMarkers.substring(0,sMarkers.length-1);
        var s =  ['MAP.aroundMe({markers:[', sMarkers, '],radius:',  radius * 1000, '})'].join('');
        console.log(s);
        mapWebView.evaluateJavaScript(s);
    }

    function removeMarker(marker) {
        var s = ['MAP.removeMarker({',
                 'lat:', marker.lat , ',',
                 'long: ', marker.lon , ',',
                 'alt: ', maker.alt ,
                 '})'].join('');
        mapWebView.evaluateJavaScript(s);
    }

    function removeAllMarkers() {
        mapWebView.evaluateJavaScript("MAP.removeAllMarkers()");
    }

    function setCurrentPosition(coords){
        var s = ["MAP.setCurrentPosition({lat:", coords.latitude , ", long: ", coords.longitude, ", alt: ", coords.altitude, "})"].join("");
        console.log(s)
        mapWebView.evaluateJavaScript(s);
    }


    PositionSource {
        id: positionSource
        updateInterval: 3000
        active:  mapItem.withGeolocation
        onPositionChanged: {
            if(positionSource.position.latitudeValid && positionSource.position.longitudeValid){
                mapItem.position = positionSource.position.coordinate;
                mapItem.setCurrentPosition(positionSource.position.coordinate);
            }
        }
    }
}

