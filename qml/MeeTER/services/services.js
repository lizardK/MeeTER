//var WS_URL = "http://192.168.0.11/ws/index.php";
var WS_URL = "http://app.testsimon.fr/ws/index.php";

function fetchAllStations(model) {
    if(model === null)
        return;
    model.clear();
    var xhr = new XMLHttpRequest();
    console.log([WS_URL,"stations"].join("/"));
    xhr.open("GET",[WS_URL,"stations"].join("/"),true);
    xhr.onreadystatechange = function() {
                if ( xhr.readyState == xhr.DONE)  {
                    if ( xhr.status == 200)  {
                        var jsonObject = JSON.parse(xhr.responseText)
                        model.onFetch(jsonObject)
                    }
                    else {
                        model.onFetchError ("Erreur")
                    }
                }
            }

    xhr.send();
}

function fetchAllStationsNearBy(model, coords,radius) {
    if(model === null || coords.latitude === null || coords.longitude === null  || radius <= 0)
        return;

    model.clear();
    var xhr = new XMLHttpRequest();
    xhr.open("GET",[WS_URL,"aroundme", coords.latitude, coords.longitude , radius].join("/"),true);
    xhr.onreadystatechange = function() {
                if ( xhr.readyState == xhr.DONE)  {
                    if ( xhr.status == 200)  {
                        var jsonObject = JSON.parse(xhr.responseText)
                        model.onFetch(jsonObject)
                    }
                    else {
                        model.onFetchError ("Erreur")
                    }
                }
            }

    xhr.send();
}

function fetchAllTrainsOfDay(model, stationID, page,append) {
    if(model === null || stationID === null)
        return;

    if(page === null)
        page = 0;

    if(!append)
        model.clear();

    var xhr = new XMLHttpRequest();
    xhr.open("GET",[WS_URL, "trainsOfDay", stationID , page].join("/") ,true);
    console.log([WS_URL, "trainsOfDay", stationID , page].join("/"));
    xhr.onreadystatechange = function() {
                if ( xhr.readyState == xhr.DONE)  {
                    if ( xhr.status == 200) {
                        var jsonObject = JSON.parse(xhr.responseText)
                        model.onFetch(jsonObject)
                    }
                    else {
                        model.onFetchError ("Erreur")
                    }
                }
            }

    xhr.send();
}

function fetchTrains(model, from, to, date, startTime, endTime, page,append) {
    if(model === null || from === null || to === null || date === null || startTime === null || endTime === null)
        return;

    if(page === null)
        page = 0;

    if(!append)
        model.clear();

    var xhr = new XMLHttpRequest();
    console.log([WS_URL, "find", from, to, date ,startTime, endTime].join('/'))
    xhr.open("GET",[WS_URL, "find", from, to, date ,startTime, endTime].join('/') ,true);
    xhr.onreadystatechange = function() {
                if ( xhr.readyState == xhr.DONE)  {
                    if ( xhr.status == 200)  {
                        var jsonObject = JSON.parse(xhr.responseText)
                        model.onFetch(jsonObject)
                    }
                    else   {
                        model.onFetchError ("Erreur")
                    }
                }
            }

    xhr.send();
}

function fetchTrain(model, id,from, to) {
    if(model === null || id === null)
        return;

    model.clear();

    var xhr = new XMLHttpRequest();
    console.log([WS_URL,"train", id, from, to].join('/'))
    xhr.open("GET",[WS_URL,"train", id, from, to].join('/') ,true);
    xhr.onreadystatechange = function()   {
                if ( xhr.readyState == xhr.DONE)  {
                    if ( xhr.status == 200)  {
                        var jsonObject = JSON.parse(xhr.responseText)
                        model.onFetch(jsonObject)
                    }
                    else   {
                        model.onFetchError ("Erreur")
                    }
                }
            }

    xhr.send();
}
