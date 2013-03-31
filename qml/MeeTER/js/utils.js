function dateToString(date){
    var m = date.getMonth() + 1;
    return [date.getDate(),(m / 10 < 1)?"0"+m:m,date.getFullYear()].join(" / ");
}

function handleIconSource(iconId) {
    var prefix = "icon-m-";

    if (iconId.indexOf(prefix) !== 0)
        iconId =  prefix.concat(iconId).concat(theme.inverted ? "-white" : "");

    return "image://theme/" + iconId;

}
