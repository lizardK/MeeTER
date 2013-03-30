function dateToString(date){
    var m = date.getMonth() + 1;
    return [date.getDate(),(m / 10 < 1)?"0"+m:m,date.getFullYear()].join(" / ");
}
