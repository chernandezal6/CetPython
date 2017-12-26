<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false"
    CodeFile="cambioTrabajadores.aspx.vb" Inherits="MDT_cambioTrabajadores" %>
    <%@ Register src="../Controles/ucNovedadesPendientes.ascx" tagname="ucNovedadesPendientes" tagprefix="uc2" %>
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
                            } catch (e) { console.info(e); }


                            $("#ddlLocalidades").val(data.d.id_localidad);
                            $("#ddlTurnos").val(data.d.id_turno);
                            $("#txtCategoriaPuesto").val(data.d.ocupacion_catalogo + "|" + data.d.id_ocupacion);
                            $("#PuestoValue").html(data.d.id_ocupacion);
                            //$("#txtCategoriaPuesto").val(data.d.id_ocupacion);
                            $("#txtPuesto").val(data.d.ocupacion_des);
                            try {
                                var vdesde = Util.formatJSONDate(data.d.vacaciones_desde, "dd/mm/yyyy");
                                $("#TxtVacacionDesde").val(vdesde);
                            } catch (e) { console.info(e); }

                            try {
                                var vhasta = Util.formatJSONDate(data.d.vacaciones_hasta, "dd/mm/yyyy");
                                $("#TxtVacacionHasta").val(vhasta);
                            } catch (e) { console.info(e); }



                            //$("#txtObservacion").val(data.d.observacion);
                            $("#txtSalario").val(data.d.salario);
                            // $("#ddlPeriodos").val(data.d.periodo_factura);
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
            $("#divFormulario").hide();
        }

        function HabilitarFormulario() {
            $("#divFormulario").show();
            //*********

        }

        function ProcesarTrabajador() {
            var Resultado = validaciones();

            if (Resultado != "") {

                Resultado = "Favor revisar los siguientes campos: <br>" + Resultado;

                $("#lblMensaje").html(Resultado);
                $("#lblMensaje").addClass("error");

                return;

            }
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
            Util.ProgressBarInicio();
            $("#btnGuardar").attr("disabled", true).css('color', '#888888');
            $("#btnCancelar").attr("disabled", true).css('color', '#888888');
    
            var ParamsTrabajador = {
                tipo: "C",
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
                fechaNovedad: '',
                ocupacion_des: $("#txtCategoriaPuesto").val(),
                ult_usuario_act: $("#UsuarioCreador").html()
            };

            Util.LlamarServicio('MDT.asmx', 'ProcesarTrabajadorMDT', ParamsTrabajador, function (data) {
            
                var info = data.d;
                if (info != "OK") {
                    Util.ProgressBarFin();
                    $("#lblMensaje").html(info);
                    $("#lblMensaje").addClass("error");
                    $("#btnGuardar").attr("disabled", false).css('color', '');
                    $("#btnCancelar").attr("disabled", false).css('color', '');
                } else {
                    Util.ProgressBarFin();
                    Limpiar();

                  //  Util.MostrarMensaje('OK', 'Registro procesado satisfactoriamente.');
                    reloadPage();
                    HabilitarConsulta();
                }

            });
        }

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
            //$("#txtObservacion").val('');

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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <span class="header">Cambio de datos de trabajadores MDT</span>
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
                    </select>
                </td>
                <td>
                    <input id="txtDocumento" maxlength="25" />&nbsp;
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
                    Fecha Ingreso:
                </td>
                <td>
                    <span id="lbFechaIngreso" class="labelData"></span>
                </td>
            </tr>
            <tr>
                <td>
                    Tipo de Formulario:
                </td>
                <td>
                    <select id="ddlPlanilla" class="dropDowns">
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
                    <input id="txtSalario" maxlength="11" type="text" value="" style="text-align: right;
                        width: 95px;" />
                </td>
            </tr>
            <tr>
                <td style="text-align: left;" nowrap="nowrap">
                    Vacaciones desde:
                </td>
                <td>
                    <input id="TxtVacacionDesde" type="text" value="" class="fecha" style="text-align: right;
                        width: 95px;" />
                </td>
            </tr>
            <tr>
                <td style="text-align: left;" nowrap="nowrap">
                    Vacaciones hasta:
                </td>
                <td>
                    <input id="TxtVacacionHasta" type="text" value="" class="fecha" style="text-align: right;
                        width: 95px;" />
                </td>
            </tr>
            <%--<tr>
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
                    <input type="button" id="btnGuardar" style="font-size: 8pt;" class="btnButton" onclick="ProcesarTrabajador();"
                        value="Guardar" />
                    &nbsp;
                    <input type="button" id="btnCancelar" style="font-size: 8pt;" class="btnButton" value="Cancelar" />
                </td>
            </tr>
        </table>
        <br />
        <div id="divMensaje">
            <span id="lblMensaje"></span>
        </div>


    </div>
             <div>
             <uc2:ucNovedadesPendientes ID="ucNovedadesPendientes1" runat="server" />
         </div>
</asp:Content>
