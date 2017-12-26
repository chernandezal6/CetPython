<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false"
    CodeFile="ingresoTrabajadores.aspx.vb" Inherits="MDT_ingresoTrabajadores" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc1" %>
<%@ Register src="../Controles/ucNovedadesPendientes.ascx" tagname="ucNovedadesPendientes" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
    <% If 1 = 2 Then
    %>
    <link href="../App_Themes/SP/StyleSheet.css" rel="stylesheet" type="text/css" />
    <script src="../Script/Util.js" type="text/javascript"></script>
    <script src="../Script/jquery-1.5.2-vsdoc.js" type="text/javascript"></script>
    <%
    End If
    %>

    <script type="text/javascript">

        $(function () {
            //pagaMDT();
            //agregamos los comentaros necesarios a los casos que ameriten

            Util.AgregarTip('txtFechaIngreso', 'Se indicará el día, mes y año en que el trabajador comenzó a laborar en la empresa, ejemplo: "El trabajador inicio su labor el 12 de mayo de 1980.(12/05/1980)"');
            Util.AgregarTip('txtCategoriaPuesto', 'Catálogo de puestos(ocupaciones) de uso internacional, debe elegir un puesto igual o relacionado a la labor que desempeña el trabajador.');
            Util.AgregarTip('txtPuesto', 'Es la labor principal que realiza el trabajador en la empresa. Ejemplo: Obrero que corta patrones, Ocupación: "Patronista"');
            Util.AgregarTip('TxtVacacionDesde', 'Las vacaciones deben iniciar el día y mes del inicio y el final de la vacaciones. Véase Art. 177 del Código de Trabajo y Ley No. 97-97 de fecha 30 de Mayo de 1997.');
            Util.AgregarTip('TxtVacacionHasta', 'Las vacaciones deben iniciar el día y mes del inicio y el final de la vacaciones. Véase Art. 177 del Código de Trabajo y Ley No. 97-97 de fecha 30 de Mayo de 1997.');
            Util.AgregarTip('ddlTurnos', 'Seleccionar el turno correspondiente al trabajador.');
            Util.AgregarTip('ddlLocalidades', 'Seleccionar el establecimiento correspondiente al trabajador.');
            //Util.AgregarTip('txtObservacion', 'Esta casilla soporta un maximo de 400 caracteres.');


            $("#divCrearNuevoPasaporte").hide();
            $("#divActualizarNacionalidad").hide();


            $("#btnLimpiarPasaporte").click(function () {
                Limpiar();
                HabilitarConsulta();
            });
            $("#btnCrearPasaporte").click(function () {

                insertarExtranjeroMDT();
            });

            $("#btnActualizarNacionalidad").click(function () {
                //llamar funcion que hara update en ciudadanos
                if ($("#ddlNacionalidadAct").val() > 0) {
                    actualizarExtranjeroMDT();
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

            $("#txtCategoriaPuesto").blur(function () {
                if ($("#txtCategoriaPuesto").val() == "") {
                    $("#txtPuesto").val('');
                }
            });
            //llenamos el dropdown de Localidades

            var Params2 = {
                idRegPatronal: $("#RegistroPatronal").html()
            };
            Util.LlenarDropDown('MDT.asmx', 'ListarLocalidades', Params2, 'ddlLocalidades', '0', '1', "Seleccione", null, function () { });

            //llenamos el dropdown de Periodos
            var ParamsPeriodos = {};
            Util.LlenarDropDown('MDT.asmx', 'listadoPeriodos', ParamsPeriodos, 'ddlPeriodos', '0', '1', "Seleccione", null, function () { });

            //llenamos el dropdown de Turnos
            var Params3 = {
                idRegPatronal: $("#RegistroPatronal").html()
            };
            Util.LlenarDropDown('MDT.asmx', 'ListarTurnos', Params3, 'ddlTurnos', '0', '1', "Seleccione", null, function () { });

            //llenamos el dropdown de Nacionalidades
            var Params4 = {};
            Util.LlenarDropDown('MDT.asmx', 'getNacionalidades', Params4, 'ddlNacionalidad', '0', '1', "Seleccione", null, function () { });

            //// -> #NoIdeaWhy
            var desde = $("#TxtVacacionHasta.ClientID").attr('id');

            //            var dates = $(".fecha").datepicker({
            //                dateFormat: 'dd/mm/yy',
            //                defaultDate: "+1w",
            //                changeMonth: true,                
            //                numberOfMonths: 3

            //            });

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

        //verificamos si el empresa logeada paga mdt

//        function pagaMDT() {
//            Params = {
//                idRegPatronal: $("#RegistroPatronal").html()
//            }
//            Util.LlamarServicio('MDT.asmx', 'pagaMDT', Params, function (data) {

//                if (data.d == "False") {
//                    var onerror = "window.location.href = '../Empleador/consNotificaciones.aspx'";
//                    Util.MostrarMensaje('ERROR', 'Este empleador no paga impuestos del Ministerio de Trabajo.', null, onerror);
//                }

//            });
//        }
        /////////////////////////////////////////////

        function Limpiar() {

            $("#txtNombre").val("");
            $("#txtApellido1").val("");
            $("#txtApellido2").val("");
            $("#ddlSexo").val("0");
            $("#ddlNacionalidad").val("0");
            $("#ddlNacionalidadAct").val("0");
            $("#txtFechanacimiento").val("");
            $("#divCrearNuevoPasaporte").hide();

            $("#txtDocumento").val("");
            $("#txtCategoriaPuesto").val("");
            $("#txtSalario").val("0.00");
            $("#ddlTipodoc").val("C");

            $("#nombreTrabajador").html("");
            $("#NSS").html("");
            $("#ddlPlanilla").val(0);
            $("#ddlLocalidades").val(0);
            $("#ddlTurnos").val(0);
            $("#txtFechaIngreso").val("");
            $("#ddlPeriodos").val(0);
            $("#PuestoValue").html("");
            $("#txtPuesto").val('');
            $("#TxtVacacionDesde").val('');
            $("#TxtVacacionHasta").val('');
            //$("#txtObservacion").val('');

            $('#ddlTipodoc').attr('disabled', false);
            $('#txtDocumento').attr('disabled', false);
            $("#btnBuscar").attr("disabled", false).css('color', '');
            $("#btnLimpiar").attr("disabled", false).css('color', '');


            $("#btnGuardar").attr("disabled", false).css('color', '');
            $("#btnCancelar").attr("disabled", false).css('color', '');
            $('#lblMensaje').html('');
        }


        function getCiudadano() {

            var ParamsCiudadano = {
               no_documento: $("#txtDocumento").val(),
               tipoDoc: $("#ddlTipodoc").val()
            };

            Util.LlamarServicio('MDT.asmx', 'getCiudadano', ParamsCiudadano, function (data) {

                var info = JSON.parse(data.d);
                if (info.rows[0] != "0") {
                    if ($("#ddlTipodoc").val() == "P") {
                        $("#nombreTrabajador").html('');
                        $("#divCrearNuevoPasaporte").show();
                        $('#ddlTipodoc').attr('disabled', true);
                        $('#txtDocumento').attr('disabled', true);
                        $("#btnBuscar").attr("disabled", true).css('color', '');
                        $("#btnLimpiar").attr("disabled", true).css('color', '');
                    } else {
                        $("#divCrearNuevoPasaporte").hide();
                        $('#ddlTipodoc').attr('disabled', false);
                        $('#txtDocumento').attr('disabled', false);
                        $("#btnBuscar").attr("disabled", false).css('color', '');
                        $("#btnLimpiar").attr("disabled", false).css('color', '');

                        $("#nombreTrabajador").html(info.rows[1]);
                        $("#nombreTrabajador").removeClass("labelSubtitulo");
                        $("#nombreTrabajador").addClass("error");

                    }
                } else {

                    $("#divCrearNuevoPasaporte").hide();
                    $("#nombreTrabajador").removeClass("error");
                    $("#nombreTrabajador").addClass("labelSubtitulo");

                    $("#nombreTrabajador").html(info.rows[1]);
                    $("#NSS").html(info.rows[2]);
                    //verificamos si el estranjero tiene nacionalidad
                    if (info.rows[3] != "") {
                        $("#divActualizarNacionalidad").hide();

                        if (info.rows[1] != "") {
                            HabilitarFormulario();
                            $('#ddlTipodoc').attr('disabled', true);
                            $('#txtDocumento').attr('disabled', true);
                            $("#btnBuscar").attr("disabled", true).css('color', '#888888');
                            $("#btnLimpiar").attr("disabled", false).css('color', '');
                        }
                    } else {
                        //habilitamos dropdown de actualizacion de ciudadanos
                        //llenamos el dropdown de Nacionalidades
                        var Params4 = {};
                        Util.LlenarDropDown('MDT.asmx', 'getNacionalidades', Params4, 'ddlNacionalidadAct', '0', '1', "Seleccione", null, function () { });
                        $("#divActualizarNacionalidad").show();
                  
                    }


                }

            });
        }

        function HabilitarConsulta() {
            $("#divConsultaCiudadano").show();
            $("#divFormulario").hide();
            //$("#ControlNovedadesPendientes").hide();
        }
        function HabilitarFormulario() {
            $("#divFormulario").show();
            //$("#ControlNovedadesPendientes").show();
            Util.LlamarAutoComplete("MDT.asmx", "getPuestoList", "txtCategoriaPuesto", "Puesto", function (e, i) {

                var item = i.item.val;

                if (item != "" && item != null) {

                    var Codigo = item.split('|')[1];
                    var Puesto = item.split('|')[0];

                    console.log(Codigo);
                    console.log(Puesto);

                    $("#PuestoValue").html(Codigo);
                    
                    $("#txtCategoriaPuesto").val(Puesto);
                    //$("#txtPuesto").val(Puesto);

                }

            });

        }

        function ProcesarTrabajador() {
            
            var Resultado = validaciones();

            if (Resultado != "") {

                Resultado = "Favor revisar los siguientes campos: <br>" + Resultado;

                $("#lblMensaje").html(Resultado);
                $("#lblMensaje").addClass("error");

                return;
            } else { $("#lblMensaje").html(""); }

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
                idTurno = "0";
            } else {
                idTurno = $("#ddlTurnos").val();
            }

            var ParamsTrabajador = {
                tipo: "I",
                id_nss: $("#NSS").html(),
                id_planilla: $("#ddlPlanilla").val(),
                id_localidad: $("#ddlLocalidades").val(),
                id_turno: $("#ddlTurnos").val(),
                id_ocupacion: idPuesto,
                segundo_puesto: $("#txtPuesto").val(),
                vacaciones_desde: $("#TxtVacacionDesde").val(),
                vacaciones_hasta: $("#TxtVacacionHasta").val(),
                observacion: '',
                salario: $("#txtSalario").val(),
                periodo: periodoFactura,
                fechaNovedad: $("#txtFechaIngreso").val(),
                ocupacion_des: $("#txtCategoriaPuesto").val(),
                ult_usuario_act: $("#UsuarioCreador").html()
            };

            Util.ProgressBarInicio();
            $("#btnGuardar").attr("disabled", true).css('color', '#888888');
            $("#btnCancelar").attr("disabled", true).css('color', '#888888');

            Util.LlamarServicio('MDT.asmx', 'ProcesarTrabajadorMDT', ParamsTrabajador, function (data) {

                var info = data.d;
                if (info != "OK") {

                    $("#lblMensaje").html(info);
                    $("#lblMensaje").addClass("error");

                    $("#btnGuardar").attr("disabled", false).css('color', '');
                    $("#btnCancelar").attr("disabled", false).css('color', '');
                    Util.ProgressBarFin();

                } else {
                    Util.ProgressBarFin();
                    Limpiar();
                  //  Util.MostrarMensaje('OK', 'Registro procesado satisfactoriamente.');
                    reloadPage();
                    HabilitarConsulta();
                }

            });
        }

        //************insertar extranjero
        function insertarExtranjeroMDT() {
          
            var Resultado = validacionesExtranjero();

            if (Resultado != "") {

                Resultado = "Favor revisar los siguientes campos: <br>" + Resultado;

                $("#lblMensaje").html(Resultado);
                $("#lblMensaje").addClass("error");
                return;
            } else { $("#lblMensaje").html(""); }
  
            var ParamsExtranjero = {
            nombres: $("#txtNombre").val(),
            primerApellido: $("#txtApellido1").val(),
            segundoApellido: $("#txtApellido2").val(),
            fechaNamimiento: $("#txtFechanacimiento").val(),
            sexo: $("#ddlSexo").val(),
            nroDocumento: $("#txtDocumento").val(),
            tipoDoc: $("#ddlTipodoc").val(),
            idNacionalidad: $("#ddlNacionalidad").val(),
            ult_usuario_act: $("#UsuarioCreador").html()
        };

        Util.LlamarServicio('MDT.asmx', 'ingresoExtranjeroMDT', ParamsExtranjero, function (data) {

            var info = data.d;
            if (info != "OK") {
                $("#lblMensaje").html(info);
                $("#lblMensaje").addClass("error");

            } else {

                Util.MostrarMensaje('OK', 'Extranjero creado satisfactoriamente.', 'getCiudadano();');
                //getCiudadano();
            }
        });
        }

      
        //************actualizar la nacionalidad del extranjero
        function actualizarExtranjeroMDT() {

            var ParamsExtranjero = {
                nroDocumento: $("#txtDocumento").val(),
                tipoDoc: "P",
                idNacionalidad: $("#ddlNacionalidadAct").val(),
                ult_usuario_act: $("#UsuarioCreador").html()
            };

            Util.LlamarServicio('MDT.asmx', 'actualizarExtranjeroMDT', ParamsExtranjero, function (data) {

                var info = data.d;
                if (info != "OK") {
                    $("#lblMensaje").html(info);
                    $("#lblMensaje").addClass("error");

                } else {

                    $("#divActualizarNacionalidad").hide();
                    HabilitarFormulario();
                    $('#ddlTipodoc').attr('disabled', true);
                    $('#txtDocumento').attr('disabled', true);
                    $("#btnBuscar").attr("disabled", true).css('color', '#888888');
                    $("#btnLimpiar").attr("disabled", false).css('color', '');
                }
            });
        }

        ///validaciones para el extranjero
        function validacionesExtranjero() {

            var Resultado = "";

            if ($("#txtNombre").val() == "") {
                Resultado += "* El nombre del extranjero es requerido.</br>";
            }

            if ($("#txtApellido1").val() == "") {
                Resultado += "* El 1er.Apellido del extranjero es requerido.</br>";
            }

//            if ($("#txtApellido2").val() == "") {
//                Resultado += "* El 2do. Apellido del extranjero es requerido.</br>";
//            }
            
            if ($("#ddlSexo").val() == 0) {
                Resultado += "* El sexo es requerido.</br>";
            }
            if ($("#ddlNacionalidad").val() == 0) {
                Resultado += "* La nacionalidad del extranjero es requerida.</br>";
            }

            if ($("#txtFechanacimiento").val() == "") {
                Resultado += "* La fecha de nacimiento del extranjero es requerida.</br>";
            } else {
                if (!Util.ValidarFecha($("#txtFechanacimiento").val())) {
                    Resultado += "* Debe ingresar una fecha de nacimiento válida.</br>";
                }
            }

            return Resultado;
        }
        ///validaciones para la novedad de ingreso al mdt
        function validaciones() {

            var Resultado = "";

            var Ano = new Date();

            if ($("#ddlPlanilla").val() == 0) {
                Resultado += "* Debe seleccionar un tipo de planilla.</br>";
            }
            if ($("#ddlLocalidades").val() == 0) {
                Resultado += "* Debe selecionar un establecimiento.</br>";
            }
            if ($("#ddlTurnos").val() == 0) {
                Resultado += "* Debe selecionar un turno.</br>";
            }
            if ($("#ddlPeriodos").val() == 0) {
                Resultado += "* Debe selecionar un período.</br>";
            }

            if ($("#txtCategoriaPuesto").val() == "") {
                Resultado += "* Debe ingresar una ocupación del catálago.</br>";
            }
            if ($("#txtPuesto").val() == "") {
                Resultado += "* Debe ingresar la ocupación real.</br>";
            }

            if ($("#txtSalario").val() == "" || $("#txtSalario").val() == 0.00) {
                Resultado += "* Debe ingresar el salario para el trabajador.</br>";
            }

            if (!($("#txtSalario").val() >= 0)) {
                Resultado += "* Debe ingresar un salario valido.</br>";
            }

            if ($("#txtFechaIngreso").val() == "") {
                Resultado += "* La fecha de ingreso es requerida.</br>";
                }else{
                if (!Util.ValidarFecha($("#txtFechaIngreso").val())) {
                    Resultado += "* Debe ingresar una fecha de ingreso válida.</br>";
                }
            }

            if ($("#TxtVacacionDesde").val() != "") {
                if (!Util.ValidarFecha($("#TxtVacacionDesde").val())) {
                    Resultado += "* Debe ingresar una fecha de inicio de vacaciones válida.</br>";
                }
            }
            if ($("#TxtVacacionHasta").val() != "") {
                if (!Util.ValidarFecha($("#TxtVacacionHasta").val())) {
                    Resultado += "* Debe ingresar una fecha de inicio de vacaciones válida.</br>";
                }
            }
            if (($("#TxtVacacionDesde").val() != "") && ($("#TxtVacacionHasta").val() != "")) {
                if (CompararFechas($("#TxtVacacionDesde").val(), $("#TxtVacacionHasta").val()) == true) {
                    Resultado += "* La fecha de fin de vacaciones no puede ser menor que la fecha de inicio de vacaciones.</br>";
                }
            }
            if (($("#TxtVacacionDesde").val() != "") && ($("#txtFechaIngreso").val() != "")) {
                if (CompararFechas($("#txtFechaIngreso").val(), $("#TxtVacacionDesde").val()) == true) {
                    Resultado += "* La fecha de ingreso no debe ser mayor que la fecha de vacaciones desde.</br>";
                }
            }
            if (($("#TxtVacacionHasta").val() != "") && ($("#txtFechaIngreso").val() != "")) {
                if (CompararFechas($("#txtFechaIngreso").val(), $("#TxtVacacionHasta").val()) == true) {
                    Resultado += "* La fecha de ingreso no debe ser mayor que la fecha de vacaciones hasta.</br>";
                }
            }

            if ($("#TxtVacacionDesde").val() != "" && $("#TxtVacacionHasta").val() == "") {
                  Resultado += "* La fecha de vacaciones hasta es requerida.</br>";

              }
              if ($("#TxtVacacionDesde").val() == "" && $("#TxtVacacionHasta").val() != "") {
                  Resultado += "* La fecha de vacaciones Desde es requerida.</br>";

              }


            return Resultado;
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

        function reloadPage() {
            document.location.href = document.location.href;
        }

    </script>
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <uc1:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
    <span class="header">Ingreso de trabajadores MDT</span>
    <div id="divConsultaCiudadano">
        <!-- Estos Span son Utilizados para los Autocomplete y los Dropdown-->
        <span id="RegistroPatronal" style="visibility: hidden"><%=UsrRegistroPatronal%></span> 
        <span id="NSS" style="visibility: hidden"></span>
        <span id="UsuarioCreador" style="visibility: hidden"><%=UsrUserName%></span>
        <span id="PuestoValue" style="visibility: hidden"></span>
        <!-- ---------------------------------------------------------------->
        <table class="td-content">
            <tr>
                <td>
                    <select id="ddlTipodoc" class="dropDowns">
                        <option selected="selected" value="C">Cédula</option>
                        <option value="P">Pasaporte</option>
                        <option value="N">NSS</option>
                    </select></td>
                <td>
                    <input id="txtDocumento" maxlength="25" />&nbsp; 
                    <input type="button" id="btnBuscar" style="font-size: 8pt;" class="btnButton" value="Buscar"/>&nbsp;
                    <input type="button" id="btnLimpiar" style="font-size: 8pt;" class="btnButton" value="Limpiar" onclick="reloadPage()"/>

                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <span id="nombreTrabajador" class="labelSubtitulo"></span>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div id="divActualizarNacionalidad">
                        <table width="100%">
                            <tr>
                                <td width="83px">
                                    Nacionalidad:</td>
                                <td>
                                    <select id="ddlNacionalidadAct" class="dropDowns">
                                    </select>&nbsp;
                                    <input type="button" id="btnActualizarNacionalidad" style="font-size: 8pt;" class="btnButton"
                                     value="Agregar" onclick="return btnActualizarNacionalidad_onclick()" /></td>
                            </tr>
                            <tr>
                                <td colspan="2" style="color: #FF0000">*La nacionalidad es requerida.</td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>

            <tr>
                <td colspan="2">
                    <div id="divCrearNuevoPasaporte">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    Nombres:
                                </td>
                                <td>
                                    <input id="txtNombre" maxlength="50" style="width: 320px" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    1er. Apellido:
                                </td>
                                <td>
                                    <input id="txtApellido1" maxlength="50" style="width: 320px" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    2do. Apellido:
                                </td>
                                <td>
                                    <input id="txtApellido2" maxlength="50" style="width: 320px" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Sexo:
                                </td>
                                <td>
                                    <select id="ddlSexo" class="dropDowns">
                                        <option value="0">Selecione</option>
                                        <option value="M">Masculino</option>
                                        <option value="F">Femenino</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Nacionalidad:
                                </td>
                                <td>
                                    <select id="ddlNacionalidad" class="dropDowns">
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left;" nowrap="nowrap">
                                    Fecha Nacimiento:
                                </td>
                                <td>
                                    <input id="txtFechanacimiento" type="text" value="" class="fecha"
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left;" nowrap="nowrap">
                                    &nbsp;</td>
                                <td>
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="2" align="right">
                                    <input type="button" id="btnCrearPasaporte" style="font-size: 8pt;" class="btnButton"
                                     value="Crear" onclick="return btnCrearPasaporte_onclick()" />&nbsp;
                                    <input type="button" id="btnLimpiarPasaporte" style="font-size: 8pt;" class="btnButton"
                                        value="Limpiar" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>

        </table>
    
    </div>
    <br />
    <br />
    <div id="divFormulario">
        <table class="td-content">
            <tr>
                <td colspan="2">
                    <br />
                    <span class="subHeader">Datos Complementarios</span>
                </td>
            </tr>
            <tr>
                <td>
                    Tipo de Formulario:
                </td>
                <td>
                    <select id="ddlPlanilla" class="dropDowns">
                        <option value="0">Selecione</option>
                        <option value="DGT3">DGT3</option>
                        <option value="DGT4">DGT4</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>
                    Establecimiento:
                </td>
                <td>
                    <select id="ddlLocalidades" class="dropDowns">
                        <option value="select">Selecione</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>
                    Turno:
                </td>
                <td>
                    <select id="ddlTurnos" class="dropDowns">
                        <option value="select">Selecione</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td style="text-align: left;" nowrap="nowrap">
                    Fecha Ingreso:
                </td>
                <td>
                    <input id="txtFechaIngreso" type="text" value="" class="fecha"
                </td>
            </tr>
            <tr>
                <td>
                    Período:
                </td>
                <td>
                    <select id="ddlPeriodos" class="dropDowns">
                    </select>
                </td>
            </tr>
            <tr>
                <td nowrap="nowrap">
                    Puesto (Catálogo de Puesto):
                </td>
                <td>
                    <input id="txtCategoriaPuesto" type="search" style="width: 300px;" />
                </td>
            </tr>
            <tr>
                <td>
                    Ocupación Real:
                </td>
                <td>
                    <input id="txtPuesto" type="text" style="width: 300px;" />
                </td>
            </tr>
            <tr>
                <td>
                    Salario:
                </td>
                <td>
                    <input id="txtSalario" maxlength="11" type="text" value="" 
                        style="text-align: right; width: 95px;" />
                </td>
            </tr>
            <tr>
                <td style="text-align: left;" nowrap="nowrap">
                    Vacaciones desde:
                </td>
                <td>
                    <input id="TxtVacacionDesde" type="text" value="" class="fecha"
                        style="text-align: right; width: 95px;" />
                </td>
            </tr>
            <tr>
                <td style="text-align: left;" nowrap="nowrap">
                    Vacaciones hasta:
                </td>
                <td>
                    <input id="TxtVacacionHasta" type="text" value="" class="fecha"
                        style="text-align: right; width: 95px;" />
                </td>
            </tr>
        <%--    <tr>
                <td style="text-align: left;">
                    Observación:
                </td>
                <td>
                    <textarea id="txtObservacion" onkeydown="Util.limitarTexto('txtObservacion', 399);"></textarea>
                </td>
            </tr>--%>
            <tr>
                <td colspan="2" align="right">
                    <br />
                    <input type="button" id="btnGuardar" style="font-size: 8pt;" class="btnButton" onclick="ProcesarTrabajador();" value="Guardar"/>
                    &nbsp; 
                  <input type="button" id="btnCancelar" style="font-size: 8pt;" class="btnButton" value="Cancelar"/>
                            
                </td>
            </tr>

        </table>

    </div>
        <br />
        <div id="divMensaje">
            <span id="lblMensaje"></span>
        </div>
        <div id="ControlNovedadesPendientes">
        
            <uc2:ucNovedadesPendientes ID="ucNovedadesPendientes1" runat="server" />
        
        </div>
</asp:Content>
