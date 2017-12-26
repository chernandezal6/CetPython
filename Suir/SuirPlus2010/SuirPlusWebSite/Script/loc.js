var loc = "";

if ((location.port == 80) || (location.port.length == 0)) {
    loc = "http://" + location.host + "/Services/Subsidios.asmx"
}
else {
    loc = "http://" + location.host + "/SuirPlusWebSite/Services/Subsidios.asmx"
}