/*
::    Validator Engine 1.0
::    JavaScript & Jquery
::    By Armando Martínez Dorville
*/

/*
::    Diccionario de Codigos de Validación
::    
::    CLI001 --> Campo Vacío
::    CLI002 --> Formato Invalido
::    CLI003 --> Dato Invalido
::    CLI004 --> Correo diferente
::    CLI005 --> Fecha Invalida
::    CLI006 --> Seleccionar una opción (ddl)
*/

function mensaje(codigo) {
    switch (codigo) {
        case "CLI002":
            return "El formato del campo es invalido.";
            break;
        case "CLI001":
            return "No puede dejar campos vacios.";
            break;
        case "CLI003":
            return "Los datos son invalidos";
            break;
        case "CLI004":
            return "Los correos deben ser iguales.";
            break;
        case "CLI006":
            return "Debe seleccionar una opción.";
            break;
        case "CLI005":
            return "La fecha es invalida.";
            break;
        default:
            return "√";
            break;
    }
}

function CampoVacio(texto) {
    if (texto != "") {
        return true;
    }
    else {
        return false;
    }
}

function FormatDocumento(element) {
    var re = /^\(?([0-9]{3})\)?[-. ]?([0-9]{7})[-. ]?([0-9]{1})$/;
    if (element.value.match(re))
        return true;
    else
        return false;
}

function FormatTelefono(element) {
    var re = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/;
    if (element.value.match(re))
        return true;
    else
        return false;
}

function FormatCorreo(element) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    if (element.value.match(re))
        return true;
    else
        return false;
}

function FormatFecha(element) {
    var re = /^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[1,3-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$/;
    if (element.value.match(re))
        return true;
    else
        return false;
}

function ValidarDdl(ddl) {
    if ($("#" + ddl).val() != "0")
        return true;
    else
        return false;
}

function ConfirmarCorreos(Correo1, correo2) {
    if ($("#" + Correo1).val() == $("#" + correo2).val())
        return true;
    else {
        return false;
    }
}

function labelmensajes(element, msj, TipoClass) {
    debugger;
    var msjelement = $("#" + element.id);
    msjelement = msjelement.parent().children("span");
    msjelement.removeClass();
    msjelement.html(msj);

    if (TipoClass != false) {
        msjelement.addClass("valmensaje");
    }
    else {
        msjelement.addClass("valmensaje2");
    }
}

function DoFocus(box) {
    //Esto funciona para el datepicker
    box.className = 'inputFocus';
}

function DoBlur(box) {
    //Esto funciona para el datepicker
    box.className = 'input';
}