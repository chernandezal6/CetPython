<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false"
    CodeFile="cambioTrabajadores2.aspx.vb" Inherits="MDT_cambioTrabajadores2" %>

<%@ Register Src="../Controles/ucNovedadesPendientesaCambiar.ascx" TagName="ucNovedadesPendientesaCambiar" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
    <script type="text/javascript">

        $(function () {
            // pagaMDT();

            //agregamos los comentaros necesarios a los casos que ameriten
            Util.AgregarTip('txtCategoriaPuesto', 'Catálogo de puestos(ocupaciones) de uso internacional, debe elegir un puesto igual o relacionado a la labor que desempeña el trabajador.');
            Util.AgregarTip('txtPuesto', 'Es la labor principal que realiza el trabajador en la empresa. Ejemplo: Obrero que corta patrones, Ocupación: "Patronista"');
            Util.AgregarTip('TxtVacacionDesde', 'Las vacaciones deben iniciar el día y mes del inicio y el final de la vacaciones. Véase Art. 177 del Código de Trabajo y Ley No. 97-97 de fecha 30 de Mayo de 1997.');
            Util.AgregarTip('TxtVacacionHasta', 'Las vacaciones deben iniciar el día y mes del inicio y el final de la vacaciones. Véase Art. 177 del Código de Trabajo y Ley No. 97-97 de fecha 30 de Mayo de 1997.');
            Util.AgregarTip('ddlTurnos', 'Seleccionar el turno correspondiente al trabajador.');
            Util.AgregarTip('ddlLocalidades', 'Seleccionar el establecimiento correspondiente al trabajador.');
            //Util.AgregarTip('txtObservacion', 'Esta casilla soporta un maximo de 400 caracteres.');

            $("#txtCategoriaPuesto").blur(function () {
                if ($("#txtCategoriaPuesto").val() == "") {
                    $("#txtPuesto").val('');
                }
            });

            HabilitarConsulta();

            $("#btnLimpiar").click(function () {
                Limpiar();
                HabilitarConsulta();
            });

            $("#btnBuscar").click(function () {
                getCiudadano();
            });

            $("#btnCancelar").click(function () {
                Limpiar();
                HabilitarConsulta();
            });

            $(".btnButton").button();
            //llenamos el dropdown de Localidades

            var Params2 = {
                idRegPatronal: $("#RegistroPatronal").html()
            };
            Util.LlenarDropDown('MDT.asmx', 'ListarLocalidades', Params2, 'ddlLocalidades', '0', '1', "Seleccione", null, function () { });

            //llenamos el dropdown de Periodos
            var ParamsPeriodos = {};
            Util.LlenarDropDown('MDT.asmx', 'listadoPeriodos', ParamsPeriodos, 'ddlPeriodos', '0', '0', "Seleccione", null, function () { });

            //llenamos el dropdown de Turnos
            var Params3 = {
                idRegPatronal: $("#RegistroPatronal").html()
            };
            Util.LlenarDropDown('MDT.asmx', 'ListarTurnos', Params3, 'ddlTurnos', '0', '1', "Seleccione", null, function () { });


            //// -> #NoIdeaWhy
            var desde = $("#TxtVacacionHasta.ClientID").attr('id');

            var curr_year = new Date().getFullYear();
            var dates = $(".fecha").datepicker({
                dateFormat: 'dd/mm/yy',
                defaultDate: "+1w",
                changeMonth: true,
                changeYear: true,
                yearRange: '1900:' + curr_year,
                numberOfMonths: 1

            });
            //// -> #NoIdeaWhy


        });


        function checkNum(e) {
            var carCode = (window.event) ? window.event.keyCode : e.which;
            if (carCode != 8) {
                if ((carCode < 48) || (carCode > 57)) {
                    if (window.event) //IE       
                        window.event.returnValue = null;
                    else //Firefox       
                        e.preventDefault();
                }

            }
        }


        function getCiudadano() {

            var ParamsCiudadano = {
                no_documento: $("#txtDocumento").val(),
                tipoDoc: $("#ddlTipodoc").val(),
                id_registro_patronal: $("#RegistroPatronal").html()
            };


            Util.LlamarServicio('MDT.asmx', 'getCiudadano', ParamsCiudadano, function (data) {
                var info = JSON.parse(data.d);


                if (info.rows[0] != "0") {


                    $('#ddlTipodoc').attr('disabled', false);
                    $('#txtDocumento').attr('disabled', false);
                    $("#btnBuscar").attr("disabled", false).css('color', '');
                    $("#btnLimpiar").attr("disabled", false).css('color', '');

                    $("#nombreTrabajador").html(info.rows[1]);
                    $("#nombreTrabajador").removeClass("labelSubtitulo");
                    $("#nombreTrabajador").addClass("error");
                } else {

                    $("#nombreTrabajador").removeClass("error");
                    $("#nombreTrabajador").addClass("labelSubtitulo");

                    $("#nombreTrabajador").html(info.rows[1]);
                    $("#NSS").html(info.rows[2]);



                    if (info.rows[1] != "") {

                        //HabilitarFormulario();
                        $('#ddlTipodoc').attr('disabled', true);
                        $('#txtDocumento').attr('disabled', true);
                        $("#btnBuscar").attr("disabled", true).css('color', '#888888');
                    }


                    /* Para Cargar la informacion del Trabajador de esta empresa*/

                    Util.LlamarServicio('MDT.asmx', 'getInformacionTrabajador', ParamsCiudadano, function (data) {
                        var info = data.d;



                        // debugger;

                        //    alert(info);
                        //CAMBIAR VALIDACION, FAVOR NO OLVIDAR. EN VEZ DE IR == VA =!, CON OBJETIVOS DE PRUEBA SE PUSO ASI.
                        if (info != "error") {

                            // preparamos el autocomplete para los puestos 
                            Util.LlamarAutoComplete("MDT.asmx", "getPuestoList", "txtCategoriaPuesto", "Puesto", function (e, i) {

                                var item = i.item.val;

                                if (item != "" && item != null) {

                                    var Codigo = item.split('|')[1];
                                    var Puesto = item.split('|')[0];

                                    console.log(Codigo);
                                    console.log(Puesto);

                                    $("#PuestoValue").html(Codigo);

                                    $("#txtCategoriaPuesto").val(Puesto);
                                    // $("#txtPuesto").val(Puesto);
                                }

                            });

                            try {

                                var fechaingreso = Util.formatJSONDate(data.d.fecha_ingreso, "dd/mm/yyyy");
                                $("#lbFechaIngreso").html(fechaingreso);
                            } catch (e) {
                                console.info(e);

                            }


                            $("#lbTipoFormulario").html(data.d.id_planilla);
                            $("#lbEstablecimiento").html(data.d.localidad_descripcion);
                            $("#lbTurno").html(data.d.turno_descripcion);
                            $("#lbPuesto").html(data.d.ocupacion_catalogo);
                            $("#lbOcupacion").html(data.d.ocupacion_des);

                            $("#lbPeriodo").html(data.d.periodo);
                            $("#PuestoValue").html(data.d.id_ocupacion);
                            $("#lbSalario").html(data.d.salario);
                            //$("#txtCategoriaPuesto").val(data.d.id_ocupacion);
                            try {
                                var vdesde = Util.formatJSONDate(data.d.vacaciones_desde, "dd/mm/yyyy");

                                if (vdesde != null) {
                                    //  alert("vacaciones desde " + vdesde);
                                    $("#lbVacacionesDesde").html(vdesde);

                                }
                                else {
                                    $("#lbVacacionesDesde").html("N/A");
                                }
                            } catch (e) { console.info(e); }

                            try {
                                var vhasta = Util.formatJSONDate(data.d.vacaciones_hasta, "dd/mm/yyyy");


                                if (vhasta != null) {
                                    $("#lbVacacionesHasta").html(vhasta);
                                }

                                else {
                                    $("#lbVacacionesHasta").html("N/A");
                                }
                            } catch (e) { console.info(e); }



                            //$("#txtObservacion").val(data.d.observacion);


                            $("#divFormulario").show();

                        } else {

                            $("#divFormulario").hide();
                            var onerror = "window.location.href = '../Empleador/consNotificaciones.aspx'";
                            Util.MostrarMensaje("ERROR", "Este trabajador no se encuentra registrado en un <b>DGT3</b> para el año en curso", null, onerror);
                        }

                    });
                    /*-----------------------------------------------------------*/

                }

            });
        }

        function HabilitarConsulta() {
            $("#divConsultaCiudadano").show();
            $('#ddlTipodoc').attr('visible', true);
            $("#divFormulario").hide();
            // $('#divNovedadesPendientes').hide();
        }

        function HabilitarFormulario() {
            $("#divFormulario").show();

            //*********

        }

        function tipodeCambio() {
            var tipos_cambio = new Array();

            var id_localidad = $("#ddlLocalidades").val()
            if (id_localidad != 0) {
                tipos_cambio.push("ES");
            }
            var id_turno = $("#ddlTurnos").val()
            if (id_turno != 0) {
                tipos_cambio.push("TU");

            }
            var ocupacion_des = $("#txtCategoriaPuesto").val()
            if (ocupacion_des != "") {
                tipos_cambio.push("OC");
            }
            var segundo_puesto = $("#txtPuesto").val()
            if (segundo_puesto != "") {
                tipos_cambio.push("PU");

            }
            var salario = $("#txtSalario").val()
            if (salario != "" && salario != "0.00") {
                tipos_cambio.push("SA");

            }
            var vacaciones_desd = $("#TxtVacacionDesde").val()
            if (vacaciones_desd != "") {
                tipos_cambio.push("VA");
            }
            var vacaciones_hasta = $("#TxtVacacionHasta").val()
            if (vacaciones_hasta != "") {
                tipos_cambio.push("VA");

            }

            return tipos_cambio;

        }



        function GetTxtNombre(tipo_cambio) {

            var nombre = "";
            if (tipo_cambio == "ES") {

                nombre = "txtFechaCambioEst";
            }
            if (tipo_cambio == "TU") {

                nombre = "txtFechaCambioTur";
            }

            if (tipo_cambio == "OC") {

                nombre = "txtFechaCambioPuesto";
            }

            if (tipo_cambio == "OC") {

                nombre = "txtFechaCambioPuesto";
            }

            if (tipo_cambio == "PU") {

                nombre = "txtFechaCambioOcupacion";
            }

            if (tipo_cambio == "SA") {

                nombre = "txtFechaCambioSal";
            }

            if (tipo_cambio == "VA") {

                nombre = "txtFechaCambioVD";
            }
            return nombre;
        }

        function ProcesarTrabajador() {
            var Resultado = validaciones();

            if (Resultado != "") {

                Resultado = "Favor revisar los siguientes campos: <br>" + Resultado;

                $("#lblMensaje").html(Resultado);
                $("#lblMensaje").addClass("error");

                return;

            }

            // Determinar los tipos o tipo de cambio que se realizo

            //limitamos a 400 caracteres el campo observación antes de guardar el registro...
            //Util.limitarTexto("txtObservacion", 399);

            var idPuesto;
            var periodoFactura;
            var idTurno;

            if ($("#PuestoValue").html() == "") {
                idPuesto = 0;
            } else {
                idPuesto = $("#PuestoValue").html();
            }

            if ($("#ddlPeriodos").val() == 0) {
                periodoFactura = "0";
            } else {
                periodoFactura = $("#ddlPeriodos").val();
            }

            if ($("#ddlTurnos").val() == "select") {
                idTurno = "";
            } else {
                idTurno = $("#ddlTurnos").val();
            }
            Util.ProgressBarInicio();
            //$("#btnGuardar").attr("disabled", true).css('color', '#888888');
            //$("#btnCancelar").attr("disabled", true).css('color', '#888888');


            for (i = 0; i <= tipodeCambio().length; i++) {

                var ParamsTrabajador = {
                    tipo: "C",
                    id_nss: $("#NSS").html(),
                    id_planilla: $("#lbTipoFormulario").html(),
                    id_localidad: $("#ddlLocalidades").val(),
                    id_turno: idTurno,//$("#ddlTurnos").val(),
                    id_ocupacion: idPuesto,
                    segundo_puesto: $("#txtPuesto").val(),
                    vacaciones_desde: $("#TxtVacacionDesde").val(),
                    vacaciones_hasta: $("#TxtVacacionHasta").val(),
                    observacion: ' ',
                    salario: $("#txtSalario").val(),
                    periodo: $("#lbPeriodo").html(),
                    fechaNovedad: ' ',
                    ocupacion_des: $("#txtCategoriaPuesto").val(),
                    tipo_cambio: tipodeCambio()[i],
                    fecha_cambio: $("#" + GetTxtNombre(tipodeCambio()[i])).val(),
                    ult_usuario_act: $("#UsuarioCreador").html()
                };
                try {
                    //debugger;
                    Util.LlamarServicio('MDT.asmx', 'ProcesarTrabajadorMDT2', ParamsTrabajador, function (data) {

                        var info = data.d;

                        if (info != "OK") {
                            Util.ProgressBarFin();
                            $("#lblMensaje").html(info);
                            $("#lblMensaje").addClass("error");
                            $("#btnGuardar").attr("disabled", false).css('color', '');
                            $("#btnCancelar").attr("disabled", false).css('color', '');
                        } else {
                           
                            HabilitarConsulta();
                            Limpiar();

                            setTimeout(function () {
                                Util.ProgressBarFin();
                                reloadPage();
                            }, 2000);
                        }
                    });

                    //  Util.MostrarMensaje('OK', 'Registro procesado satisfactoriamente.');
                }

                catch (e) {
                    alert("excepcion al llamar el web service" + e);
                }
            }
        }

        function validaciones() {

            var Resultado = "";

            var Ano = new Date();

            //DATOS DEL ESTABLECIMIENTO
            if ($("#ddlLocalidades").val() != 0 && $("#txtFechaCambioEst").val() == "") {
                Resultado += "* Favor completar los datos del establecimiento.</br>";
            }
            if ($("#ddlLocalidades").val() == 0 && $("#txtFechaCambioEst").val() != "") {
                Resultado += "* Favor completar los datos del establecimiento.</br>";
            }

            //DATOS DEL TURNO
            if ($("#ddlTurnos").val() == 0 && $("#txtFechaCambioTur").val() != "") {
                Resultado += "* Favor completar los datos del turno.</br>";
            }

            if ($("#ddlTurnos").val() != 0 && $("#txtFechaCambioTur").val() == "") {
                Resultado += "* Favor completar los datos del turno.</br>";
            }

            //DATOS DE LA OCUPACION DEL CATALOGO

            if ($("#txtCategoriaPuesto").val() == "" && $("#txtFechaCambioPuesto").val() != "") {
                Resultado += "* Favor completar los datos del puesto.</br>";
            }

            if ($("#txtCategoriaPuesto").val() != "" && $("#txtFechaCambioPuesto").val() == "") {
                Resultado += "* Favor completar los datos del puesto.</br>";
            }

            //DATOS DE LA OCUPACION REAL

            if ($("#txtPuesto").val() == "" && $("#txtFechaCambioOcupacion").val() != "") {
                Resultado += "* Favor completar los datos de la ocupacion .</br>";
            }

            if ($("#txtPuesto").val() != "" && $("#txtFechaCambioOcupacion").val() == "") {
                Resultado += "* Favor completar los datos de la ocupacion .</br>";
            }

            //DATOS DEL SALARIO

            if ($("#txtSalario").val() != 0.00 && $("#txtFechaCambioSal").val() == "") {
                Resultado += "* Favor completar los datos del salario .</br>";
            }

            if ($("#txtSalario").val() == 0.00 && $("#txtFechaCambioSal").val() != "") {
                Resultado += "* Favor completar los datos del salario .</br>";
            }


            if ($("#txtSalario").val() == "" && $("#txtFechaCambioSal").val() != "") {
                Resultado += "* Favor completar los datos del salario .</br>";
            }

            if ($("#txtSalario").val() != "" && $("#txtFechaCambioSal").val() == "") {
                Resultado += "* Favor completar los datos del salario .</br>";
            }

            ////DATOS DE LAS VACACIONES

            if ($("#TxtVacacionDesde").val() != "" && $("#TxtVacacionHasta").val() == "") {

                Resultado += "* Favor completar los datos de las vacaciones hasta .</br>";

            }
            if ($("#TxtVacacionDesde").val() == "" && $("#TxtVacacionHasta").val() != "") {

                Resultado += "* Favor completar los datos de las vacaciones desde .</br>";
            }

            if ($("#TxtVacacionDesde").val() != "") {
                if (!Util.ValidarFecha($("#TxtVacacionDesde").val())) {
                    Resultado += "* Debe ingresar una fecha de inicio de vacaciones válida.</br>";
                }
                if ($("#txtFechaCambioVD").val() == "") {
                    Resultado += "* Favor completar los datos de las vacaciones desde .</br>";
                }
            }
            if ($("#TxtVacacionHasta").val() != "") {
                if (!Util.ValidarFecha($("#TxtVacacionHasta").val())) {
                    Resultado += "* Debe ingresar una fecha de inicio de vacaciones válida.</br>";
                }

                if ($("#txtFechaCambioVH").val() == "") {
                    Resultado += "* Favor completar los datos de las vacaciones hasta .</br>";
                }
            }

            if ($("#TxtVacacionDesde").val() == "" && $("#TxtVacacionHasta").val() == "" && $("#txtFechaCambioVD").val() != "") {
                Resultado += "* Favor completar las vacaciones  .</br>";
            }

            if ($("#TxtVacacionDesde").val() != "" && $("#TxtVacacionHasta").val() == "" && $("#txtFechaCambioVD").val() != "") {
                Resultado += "* Favor completar las vacaciones  .</br>";
            }

            if ($("#TxtVacacionDesde").val() == "" && $("#TxtVacacionHasta").val() != "" && $("#txtFechaCambioVD").val() != "") {
                Resultado += "* Favor completar las vacaciones  .</br>";
            }

            if ($("#TxtVacacionDesde").val() != "" && $("#TxtVacacionHasta").val() != "" && $("#txtFechaCambioVD").val() == "") {
                Resultado += "* Favor completar las vacaciones  .</br>";
            }
            if (($("#TxtVacacionDesde").val() != "") && ($("#TxtVacacionHasta").val() != "")) {
                if (CompararFechas($("#TxtVacacionDesde").val(), $("#TxtVacacionHasta").val()) == true) {
                    Resultado += "* La fecha de fin de vacaciones no puede ser menor que la fecha de inicio de vacaciones.</br>";
                }
            }

            return Resultado;
            //  }
        }

        function CompararFechas(fecha1, fecha2) {
            var str1 = fecha1;
            var str2 = fecha2;
            var dt1 = parseInt(str1.substring(0, 2), 10);
            var mon1 = parseInt(str1.substring(3, 5), 10);
            var yr1 = parseInt(str1.substring(6, 10), 10);
            var dt2 = parseInt(str2.substring(0, 2), 10);
            var mon2 = parseInt(str2.substring(3, 5), 10);
            var yr2 = parseInt(str2.substring(6, 10), 10);
            var date1 = new Date(yr1, mon1, dt1);
            var date2 = new Date(yr2, mon2, dt2);

            if (date1 > date2) {
                return true;

            }
        }

        function Limpiar() {
            $("#txtDocumento").val("");
            $("#txtCategoriaPuesto").val("");
            $("#txtSalario").val("0.00");
            $("#ddlTipodoc").val("C");
            $("#nombreTrabajador").html("");
            $("#NSS").html("");
            $("#ddlPlanilla").val(0);
            $("#ddlLocalidades").val(0);
            $("#ddlTurnos").val(0);
            $("#ddlPeriodos").val(0);
            $("#PuestoValue").html("");
            $("#txtPuesto").val('');
            $("#TxtVacacionDesde").val('');
            $("#TxtVacacionHasta").val('');

            $('#ddlTipodoc').attr('disabled', false);
            $('#txtDocumento').attr('disabled', false);
            $("#btnBuscar").attr("disabled", false).css('color', '');
            $("#btnLimpiar").attr("disabled", false).css('color', '');


            $("#btnGuardar").attr("disabled", false).css('color', '');
            $("#btnCancelar").attr("disabled", false).css('color', '');
            $('#lblMensaje').html('');
        }

        function reloadPage() {
            document.location.href = document.location.href;
        }

    </script>
    <style type="text/css">
        .auto-style2 {
            height: 313px;
            width: 874px;
        }

        .auto-style3 {
            width: 310px;
        }

        .auto-style4 {
            width: 311px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <span class="header">Cambio de datos de trabajadores MDT</span>
    <div id="divConsultaCiudadano">
        <!-- Estos Span son Utilizados para los Autocomplete y los Dropdown-->
        <span id="RegistroPatronal" style="visibility: hidden"><%=UsrRegistroPatronal%></span>
        <span id="NSS" style="visibility: hidden"></span>
        <span id="UsuarioCreador" style="visibility: hidden"><%=UsrUserName%></span>
        <span id="PuestoValue" style="visibility: hidden"></span>
        <span id="lbTipoFormulario" class="labelData" style="visibility: hidden"></span>
        <span id="lbPeriodo" class="labelData" style="visibility: hidden"></span>
        <!-- ---------------------------------------------------------------->
        <table class="td-content">
            <tr>
                <td>
                    <select id="ddlTipodoc" class="dropDowns">
                        <option selected="selected" value="C">Cédula</option>
                        <option value="P">Pasaporte</option>
                        <option value="N">NSS</option>
                    </select>
                </td>
                <td>
                    <input id="txtDocumento" maxlength="25" onkeypress="checkNum(event)" />&nbsp;
                    <input type="button" id="btnBuscar" style="font-size: 8pt;" class="btnButton" value="Buscar" />&nbsp;
                    <input type="button" id="btnLimpiar" style="font-size: 8pt;" class="btnButton" value="Limpiar" onclick="reloadPage()" />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <span id="nombreTrabajador" class="labelSubtitulo"></span>
                </td>
            </tr>
        </table>
    </div>
    <br />
    <div id="divFormulario">
        <table>
            <tr>
                <td class="auto-style2">

                    <%-- TABLA DATOS ACTUALES--%>
                    <table class="td-content" style="width: 380px">
                        <tr>
                            <td colspan="2">
                                <br />
                                <span class="subHeader">Datos Actuales</span>
                                <br />
                                <br />

                            </td>
                            <td>
                                <span class="subHeader">&nbsp;Datos a cambiar</span>
                            </td>
                            <td class="auto-style4"><span class="subHeader">&nbsp;Fecha Cambio</span></td>
                        </tr>
                        <tr>
                            <td>Establecimiento:
                            </td>
                            <td class="auto-style3" nowrap="nowrap">
                                <span id="lbEstablecimiento" class="labelData"></span>
                            </td>
                            <td>
                                <select id="ddlLocalidades" class="dropDowns">
                                    <option value="select">Seleccione</option>
                                </select>
                            </td>
                            <td class="auto-style4">
                                <input id="txtFechaCambioEst" type="text" value="" class="fecha" style="text-align: right; width: 95px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>Turno:
                            </td>

                            <td class="auto-style3" nowrap="nowrap">
                                <span id="lbTurno" class="labelData"></span>
                            </td>

                            <td>
                                <select id="ddlTurnos" class="dropDowns">
                                    <option value="select">Seleccione</option>
                                </select>
                            </td>
                            <td class="auto-style4">
                                <input id="txtFechaCambioTur" type="text" value="" class="fecha" style="text-align: right; width: 95px;" />
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">Puesto (Catálogo de Puesto):
                            </td>

                            <td class="auto-style3" nowrap="nowrap">
                                <span id="lbPuesto" class="labelData"></span>
                            </td>
                            <td>
                                <input id="txtCategoriaPuesto" type="search" style="width: 300px;" />
                            </td>
                            <td class="auto-style4">
                                <input id="txtFechaCambioPuesto" type="text" value="" class="fecha" style="text-align: right; width: 95px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>Ocupación Real:
                            </td>

                            <td class="auto-style3" nowrap="nowrap">
                                <span id="lbOcupacion" class="labelData"></span>
                            </td>
                            <td>
                                <input id="txtPuesto" type="text" style="width: 300px;" />
                            </td>
                            <td class="auto-style4">
                                <input id="txtFechaCambioOcupacion" type="text" value="" class="fecha" style="text-align: right; width: 95px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>Salario:
                            </td>
                            <td class="auto-style3" nowrap="nowrap">
                                <span id="lbSalario" class="labelData"></span>
                            </td>
                            <td>
                                <input id="txtSalario" maxlength="11" type="text" value="" style="text-align: right; width: 95px;" />
                            </td>
                            <td class="auto-style4">
                                <input id="txtFechaCambioSal" type="text" value="" class="fecha" style="text-align: right; width: 95px;" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left;" nowrap="nowrap">Vacaciones desde:
                            </td>
                            <td class="auto-style3" nowrap="nowrap">
                                <span id="lbVacacionesDesde" class="labelData"></span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Vacaciones Hasta
                                  <span id="lbVacacionesHasta" class="labelData"></span>
                            </td>
                            <td nowrap="nowrap">
                                <input id="TxtVacacionDesde" type="text" value="" class="fecha" style="text-align: right; width: 95px;" />
                                Hasta:
                                  <input id="TxtVacacionHasta" type="text" value="" class="fecha" style="text-align: right; width: 95px;" />

                            </td>
                            <td class="auto-style4">
                                <input id="txtFechaCambioVD" type="text" value="" class="fecha" style="text-align: right; width: 95px;" />

                            </td>
                        </tr>

                        <tr>
                            <td colspan="4" style="text-align: right;">
                                <br />
                                <input type="button" id="btnGuardar" style="font-size: 8pt;" class="btnButton" onclick="ProcesarTrabajador();"
                                    value="Guardar" />
                                &nbsp;
                            <input type="button" id="btnCancelar" style="font-size: 8pt;" class="btnButton" value="Cancelar" />
                            </td>
                        </tr>
                    </table>
                </td>

            </tr>
        </table>
        <br />
        <div id="divMensaje">
            <span id="lblMensaje"></span>
        </div>
    </div>
    <div id="divNovedadesPendientes" runat="server" visible="false">
        <uc2:ucNovedadesPendientesaCambiar ID="ucNovedadesPendientesaCambiar" runat="server" />
    </div>
</asp:Content>
