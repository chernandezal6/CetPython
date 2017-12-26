//Enciende el boton de preview
function ActivarPreviewBoton() {
    $(".buttonPrevious").css("visibility", "visible");
    $(".buttonPrevious").css("display", "block");
    $(".buttonPrevious").show();
    $(".buttonPrevious").removeClass("buttonDisabled");
    $(".buttonPrevious").addClass("buttonEnabled");
}

//Apaga el boton de preview
function ApagarPreviewBoton() {
    $(".buttonPrevious").css("visibility", "hidden");
    $(".buttonPrevious").css("display", "none");
    $(".buttonPrevious").removeClass("buttonEnabled");
    $(".buttonPrevious").addClass("buttonDisabled");
    $(".buttonPrevious").hide();
}

//Enciende el boton de next
function ActivarNextBoton() {
    $(".buttonNext").css("visibility", "visible");
    $(".buttonNext").css("display", "block");
    $(".buttonNext").show();
    $(".buttonNext").removeClass("buttonDisabled");
    $(".buttonNext").addClass("buttonEnabled");
}

//Apaga el boton de next
function ApagarNextBoton() {
    $(".buttonNext").css("visibility", "hidden");
    $(".buttonNext").css("display", "none");
    $(".buttonNext").removeClass("buttonEnabled");
    $(".buttonNext").addClass("buttonDisabled");
    $(".buttonNext").hide();
}

//Enciende el boton de Finish
function ActivarFinishBoton() {
    $(".buttonFinish").css("visibility", "visible");
    $(".buttonFinish").css("display", "block");
    $(".buttonFinish").show();
    $(".buttonFinish").removeClass("buttonDisabled");
    $(".buttonFinish").addClass("buttonEnabled");
}

//Apaga el boton de Finish
function ApagarFinishBoton() {
    $(".buttonFinish").css("visibility", "hidden");
    $(".buttonFinish").css("display", "none");
    $(".buttonFinish").removeClass("buttonEnabled");
    $(".buttonFinish").addClass("buttonDisabled");
    $(".buttonFinish").hide();
}

//Se limpian y se bloquean o inhanabilitan los controles una vez registrados
function limpiarYbloquear() {
    LimpiarCampos();
    document.getElementById("btnBuscar").disabled = true;
    document.getElementById("ddlSectorSalarial").disabled = true;
    document.getElementById("ddlSectorEconomico").disabled = true;
    document.getElementById("ddlActividad").disabled = true;
    document.getElementById("ddlProvincia").disabled = true;
    document.getElementById("ddlMunicipio").disabled = true;
    document.getElementById("ddlTipoZonaFranca").disabled = true;
    document.getElementById("ddlParque").disabled = true;
    document.getElementById("Continuar").innerHTML = "Solicitud generada correctamente, en la siguiente pantalla usted podra cargar los requisitos para el tipo de empresa que esta registrando.";
    ActivarNextBoton();
}

//Se Desbloquean y se habilitan los controles del formulario
function desbloquearYhabilitar() {
    document.getElementById("btnBuscar").disabled = false;
    document.getElementById("ddlSectorSalarial").disabled = false;
    document.getElementById("ddlSectorEconomico").disabled = false;
    document.getElementById("ddlActividad").disabled = false;
    document.getElementById("ddlProvincia").disabled = false;
    document.getElementById("ddlMunicipio").disabled = false;
    document.getElementById("ddlTipoZonaFranca").disabled = false;
    document.getElementById("ddlParque").disabled = false;
}

//Se limpian los campos
function LimpiarCampos() {
    $("#txtRNC_O_Cedula").val("");
    $("#txtRazonSocial").val("");
    $("#trMensaje").hide();
    $("#txtNombreComercial").val("");
    $("#ddlSectorSalarial").val("0");
    $("#ddlSectorEconomico").val("0");
    $("#ddlActividad").val("0");
    $("#ddlTipoZonaFranca").val("0");
    $("#txtRepresentante").val("");
    $("#lblNombreRepresentante").html("");
    $("#lblErrorRepresentante").html("");
    $("#ddlParque").val("0");
    $("#txtCalle").val("");
    $("#txtNumero").val("");
    $("#txtEdificio").val("");
    $("#txtPiso").val("");
    $("#txtApartamento").val("");
    $("#txtSector").val("");
    $("#ddlProvincia").val("0");
    $("#ddlMunicipio").val("0");
    $("#txtTel1").val("");
    $("#txtExt1").val("");
    $("#txtTel2").val("");
    $("#txtExt2").val("");
    $("#Fax").val("");
    $("#txtEmail").val("");
}

//Validaciones para registrar empleador
function RegistrarEmpleador() {
    if ($("#txtRNC_O_Cedula").val() == "") {
        mensajeCompletarDatos.html("Debe introducir Rnc/Cedula de la Empresa");

    } else if ($("#txtRazonSocial").val() == "") {
        mensajeCompletarDatos.html("La Razón Social no debe estar en Blanco");
    }
    else if ($("#txtNombreComercial").val() == "") {
        mensajeCompletarDatos.html("El Nombre Comercial no debe estar en Blanco");
    } else if ($("#ddlSectorSalarial").val() == "") {
        mensajeCompletarDatos.html("Debe seleccionar el Sector Salarial");
    }
    else if ($("#ddlSectorEconomico").val() == "") {
        mensajeCompletarDatos.html("Debe seleccionar el Sector Economico");
    }
    else if ($("#ddlActividad").val() == "") {
        mensajeCompletarDatos.html("Debe seleccionar la Actividad Comercial");
    }
    else if ($("#EsZonaFranca").val() == "S") {
        if ($("#ddlTipoZonaFranca").val() == "") {
            mensajeCompletarDatos.html("Debe seleccionar el tipo de Zona Franca");
        }
        if ($("#ddlParque").val() == "") {
            mensajeCompletarDatos.html("Debe seleccionar el Parque para la Zona Franca");
        }
    }
    else if ($("#lblNombreRepresentante").val() == "") {
        mensajeCompletarDatos.html("Debe introducir un Representante completar el Registro");
    }
    else if ($("#txtRepTel1").val() == "" && $("#txtRepTel2").val() == "") {
        mensajeCompletarDatos.html("Al menos un Teléfono es Requerido");
    }
    else if ($("chkboxNotificacionMail").val() == "S") {
        if ($("#txtRepEmail").val() == "") {
            mensajeCompletarDatos.html("Debe introducir un Correo Electrónico para el Representante");
        }
    }
    else if ($("txtCalle").val() == "") {
        mensajeCompletarDatos.html("Debe introducir la calle");
    }
    else if ($("txtNumero").val() == "") {
        mensajeCompletarDatos.html("Debe introducir el numero");
    }
    else if ($("txtSector").val() == "") {
        mensajeCompletarDatos.html("Debe introducir el Sector");
    }
    else if ($("ddlProvincia").val() == "") {
        mensajeCompletarDatos.html("Debe seleccionar la provincia");
    }
    else if ($("ddlMunicipio").val() == "") {
        mensajeCompletarDatos.html("Debe seleccionar el municipio");
    }
}

//Función que devuelve la cantidad de requisitos por la clase de empresa
function ClaseEmpresa(valor) {
    switch (valor) {
        case "1":
            FlujoPrimario = 4;
            break;
        case "2":
            FlujoPrimario = 5;
            break;
        case "3":
            FlujoPrimario = 7;
            break;
        case "4":
            FlujoPrimario = 5;
            break;
        case "5":
            FlujoPrimario = 4;
            break;
        case "6":
            FlujoPrimario = 3;
            break;
    }
}

//Se ajusta el estilo a la pagina (contenido)
function CargarEstilo(MenuHorizontal, MenuVertical1, MenuVertical2) {
    //Paso a Activar Menu Vertical
    $("#" + MenuHorizontal).css('display', 'block');
    setTimeout(function () {
        $("#" + MenuVertical1).removeClass("disabled");
        $("#" + MenuVertical1).addClass("selected");

        $("#" + MenuVertical2).removeClass("selected");
        $("#" + MenuVertical2).addClass("done");
        /*AQUI PODEMOS COLOCAR LA LLAMADA DEL EVENTO*/
    }, 400);
}

//Se carga el DIV del formulario
function CargarFormulario(formulario) {
    $("#contenidoFormulario").load(formulario);
}

//Se carga el DIV del formulario para editarlo
function EditarFormulario(formulario) {
    $("#PanelEditar").load(formulario);
}

//Cargar Cuadro de Solicitudes
function CargarSolPen(SolPendientes) {
    $("#SolPendientes").load(SolPendientes);
}

//Se carga el DIV de la carga de archivos
function CargarCA(cargaArc) {
    $("#Cuerpo").load(cargaArc);
}

//Se carga el DIV del resumen
function CargarResumen(Resumen) {
    $("#Final").load(Resumen);
}

//Accion del boton cancelar del formulario
function CancelarBu() {
    LimpiarCampos();
    document.getElementById("ddlSectorSalarial").disabled = true;
    document.getElementById("ddlSectorEconomico").disabled = true;
    document.getElementById("ddlActividad").disabled = true;
    document.getElementById("ddlProvincia").disabled = true;
    document.getElementById("ddlMunicipio").disabled = true;
    document.getElementById("ddlTipoZonaFranca").disabled = true;
    document.getElementById("ddlParque").disabled = true;
}

//Validar solo numeros en los campos
function SoloNumeros(e) {
    this.value = this.value.replace(/([^0-9].*)/g, "");
}

//Para validar el boton siguiente!
function validaciones() {
    var Resultado = "";
    debugger;
    if (($.trim($("#txtNombreComercial").val()) == "") || ($.trim($("#txtNombreComercial").val()).length == 0)) {
        Resultado += "* El nombre comercial es requerido.</br>";
    }

    if ($("#ddlSectorSalarial").val() == "0") {
        Resultado += "* El Sector Salarial es requerido.</br>";
    }

    if ($('#ddlSectorEconomico').val() == "0") {
        Resultado += "* El Sector Economico es requerido.</br>";
    }

    if ($('#ddlActividad').val() == "0") {
        Resultado += "* La Actividad es requerido.</br>";
    }

    if ($('#ddlProvincia').val() == "0") {
        Resultado += "* La Provincia es requerido.</br>";
    }

    if ($('#ddlMunicipio').val() == "0") {
        Resultado += "* El Municipio es requerido.</br>";
    }
    if ($.trim($("#txtCalle").val()) == "") {
        Resultado += "* La calle es requerida.</br>";
    }
    if ($.trim($("#txtNumero").val()) == "") {
        Resultado += "* El número es requerida.</br>";
    }

    if ($.trim($("#txtTel1").val()) == "") {
        Resultado += "* El Telefono 1 es requerido.</br>";
    }

    if ($.trim($("#txtRepresentante").val()) == "") {
        Resultado += "* La Cédula del representante es requerido.</br>";
    }

    if ($.trim($("#txtRepTel1").val()) == "") {
        Resultado += "* El Telefono 1 del representante es requerido.</br>";
    }

    if ($.trim($("#txtEmail").val()) == "") {
        Resultado += "* El Email es requerido.</br>";
    }

    if (Resultado != "") {
        $(".buttonNext").attr("validar", "1");
        $(".buttonPrevious").attr("validar", "1");
    } else {
        GenerarSolicitud();
        Registrar();
        $(".buttonNext").attr("validar", "0");
        $(".buttonPrevious").attr("validar", "0");
    }
    return Resultado;
}

//Para validar el boton Guardar!
function validaciones2() {
    var Resultado = "";

    if (($.trim($("#txtNombreComercial").val()) == "") || ($.trim($("#txtNombreComercial").val()).length == 0)) {
        Resultado += "* El nombre comercial es requerido.</br>";
    }

    if ($("#ddlSectorSalarial").val() == "0") {
        Resultado += "* El Sector Salarial es requerido.</br>";
    }

    if ($('#ddlSectorEconomico').val() == "0") {
        Resultado += "* El Sector Economico es requerido.</br>";
    }

    if ($('#ddlActividad').val() == "0") {
        Resultado += "* La Actividad es requerido.</br>";
    }

    if ($('#ddlProvincia').val() == "0") {
        Resultado += "* La Provincia es requerido.</br>";
    }

    if ($('#ddlMunicipio').val() == "0") {
        Resultado += "* El Municipio es requerido.</br>";
    }
    if ($.trim($("#txtCalle").val()) == "") {
        Resultado += "* La calle es requerida.</br>";
    }
    if ($.trim($("#txtNumero").val()) == "") {
        Resultado += "* El número es requerida.</br>";
    }

    if ($.trim($("#txtTel1").val()) == "") {
        Resultado += "* El Telefono 1 es requerido.</br>";
    }

    if ($.trim($("#txtRepresentante").val()) == "") {
        Resultado += "* La Cédula del representante es requerido.</br>";
    }

    if ($.trim($("#txtRepTel1").val()) == "") {
        Resultado += "* El Telefono 1 del representante es requerido.</br>";
    }

    if ($.trim($("#txtEmail").val()) == "") {
        Resultado += "* El Email es requerido.</br>";
    }

    if (Resultado != "") {
        $(".buttonPrevious").attr("validar", "1");
    } else {
        $(".buttonPrevious").attr("validar", "0");
    }
    return Resultado;
}

//Se cargan los datos al resumen
function CargaResumen(data) {
    $("#NO").html(data[0]);
    $("#RS").html(data[1]);
    $("#NC").html(data[2]);
    $("#TELR").html(data[5]);
    $("#RNombre").html(data[4]);
    $("#CorreoE").html(data[3]);
    setTimeout(function () {
        $("#NO").html($("#NO").html().replace('"', '').replace('"', ''));
        $("#RS").html($("#RS").html().replace('"', '').replace('"', ''));
        $("#NC").html($("#NC").html().replace('"', '').replace('"', ''));
        $("#TELR").html($("#TELR").html().replace('"', '').replace('"', ''));
        $("#RNombre").html($("#RNombre").html().replace('"', '').replace('"', ''));
        $("#CorreoE").html($("#CorreoE").html().replace('"', '').replace('"', ''));
    }, 200);
}