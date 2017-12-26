//Selector de consultas según el tipo
function SelectCons(Cons) {
    switch (Cons) {
        case 'CIU':

            break;
        case 'NFA':
            CargarConsNucleoFamiliar("ConsultasInfEmpleo.aspx");
            break;
    }
}

//Se carga el contenido de la consulta de Afiliación a la ARS
function CargarConsNucleoFamiliar(contenido) {
    $("#PanelCons").load(contenido);
}

//Se carga el contenido de la consulta de Ciudadano
function CargarConsCiudadano(contenido) {
    $("#PanelCons").load(contenido);
}