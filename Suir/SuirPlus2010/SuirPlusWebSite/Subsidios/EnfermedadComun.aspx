<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false"
    CodeFile="EnfermedadComun.aspx.vb" Inherits="Subsidios_EnfermedadComun" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
    <uc3:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
    <%If "A" = "B" Then%>
    <script src="../Script/jquery-1.5.2-vsdoc.js" type="text/javascript"></script>
    <%End If%>
    <script type="text/javascript">
        var cedula = $("#cedula");
        var btnBuscar = $("#buscar");
        var btnCancelar = $("#cancelar");
        var mensaje = $("#msgPrincipal");
        var msgTituloEC = "";

        $(function () {
            var btnBuscar = $("#buscar");
            var btnCancelar = $("#cancelar");
            var cedula = $("#cedula");

            var ModoEnfComun = Util.GetQueryStringByName("m");
            var ModoNroSol = Util.GetQueryStringByName("n");

            if (ModoEnfComun == "r") {
                Simular(ModoNroSol);
            }

            btnBuscar.button();
            btnBuscar.click(function () { buscarDatos(); });

            btnCancelar.click(Cancelar);
            btnCancelar.button();

            $(".Busqueda").hide();

            $(".fecha").live('keypress', Util.SoloFecha);
            $(".fecha").live('change', Util.EvitarPaste);

            cedula.keydown(KD);
            cedula.keyup(Util.SoloNumeros);
        });

        //====Funciones Generales=======\\
        function Exito(msg) {

            var m = "<br><div class='Titulo'>" + msg + "</div>"

            $("#Formulario").html(m);
            $("#ToDoList").html("");
        }
        function KD(e) {
            Util.StopSubmit(e, function () { $("#buscar").click(); });
        }
        function ajaxFailed(xhr, ajaxOptions, thrownError) {
            var cedula = $("#cedula");
            alert(xhr.status);
            alert(thrownError);
            $("#buscar").attr("disabled", false);
            cedula.attr("disabled", false);
            cedula.focus();
        }
        //====Funciones Generales=======\\

        function buscarDatos(llamada) {
            var cedula = $("#cedula");
            var btnBuscar = $("#buscar");

            try {
                if (cedula.val() != "") {

                    btnBuscar.attr("disabled", true);
                    cedula.attr("disabled", true);

                    var Url = loc + "/ConsultaCedula";
                    var data = '{ cedula: "' + cedula.val() + '", registropatronal: "' + $("#registropatronal").val() + '", tiposubsidio: "E" }';

                    console.info("Inicio de llamada a: " + Url);

                    Util.llamarWS(Url, data, function (info) {
                        var mensaje = $("#msgPrincipal");
                        try {
                            if (typeof info.d == "string") {
                                var cedula = $("#cedula");
                                mensaje.addClass("error");
                                mensaje.html(info.d);

                                $("#buscar").attr("disabled", false);
                                cedula.attr("disabled", false);
                                cedula.val("");
                                cedula.focus();
                            }
                            else {
                                mensaje.html("");
                                $(".Busqueda").show();
                                $("#nss").html(info.d.nss);
                                $("#sexo").html(info.d.sexo);
                                $("#nombre").html(info.d.nombres);
                                $("#nodocumento").html(info.d.cedula);
                                $("#FechaNacimiento").html(info.d.fechanacimiento);

                                $.get("TodoListEC.htm?C=" + info.d.cedula, function (data) {
                                    $("#ToDoList").html("");
                                    $("#ToDoList").append(data);
                                    if (llamada) {
                                        llamada();
                                    }
                                });
                            }
                        }
                        catch (e) {
                            mensaje.html(e);
                        }
                    }, ajaxFailed);

                    mensaje.html("");
                }
                else {
                    mensaje.addClass("error");
                    mensaje.html("Debe de digitar la cédula para continuar.");
                    cedula.val("");
                    cedula.focus();
                }
            }
            catch (e) {
                mensaje.addClass("error");
                mensaje.html(e);

                btnBuscar.attr("disabled", false);
                cedula.attr("disabled", false);
            }
        }
        function Cancelar() {
            $(".Busqueda").hide();
            $("#cedula").val("");
            $("#buscar").attr("disabled", false);
            $("#cedula").attr("disabled", false);

            $("#nss").html("");
            $("#sexo").html("");
            $("#nombre").html("");
            $("#nodocumento").html("");
            $("#FechaNacimiento").html("");

            $("#cedula").focus();
            $("#Formulario").html("");
            $("#ToDoList").html("");
            $("#msgPrincipal").html("");
        }
        function recibirResultado(info) {

            alert('alguno se llevo la llamada inline, revisen........');

        }

        function Simular(ModoNroSol) {
            
            var Params = {
                idenfermedadcomun: ModoNroSol,
                registropatronal: $("#registropatronal").val()
            };

            Util.LlamarServicio('Subsidios.asmx', 'getEnfermedadComun', Params, function (data) {

                if (data) {

                    if (typeof data.d == "string") {
                        $("#msgPrincipal").addClass("error");
                        $("#msgPrincipal").html(data.d);
                    } else {

                        /// Llenar el TXT 
                        $("#cedula").val(data.d.NoDocumento);

                        /// Darle click a Buscar & Completar datos
                        buscarDatos(function () {

                            buscarFormulario('CompletarDatos.htm', data.d.NroSolicitud, function () {

                                /// Llenar los campos
                                var Amb = false;
                                var Hosp = false;

                                if (data.d.Ambulatorio == "S") {
                                    $("#ambulatoria").attr("checked", true);
                                    $("#fechalicenciaamb").val(Util.formatJSONDate(data.d.FechaInicioAmbulatorio, "dd/mm/yyyy"));
                                    $("#diasamb").val(data.d.DiasCalendarioAmbulatorio);
                                    Amb = true;
                                }
                                if (data.d.Hospitalizado == "S") {
                                    $("#hospitalaria").attr("checked", true);
                                    $("#fechalicenciahosp").val(Util.formatJSONDate(data.d.FechaInicioHospitalizado, "dd/mm/yyyy"));
                                    $("#diashosp").val(data.d.DiasCalendarioHospitalizado);
                                    Hosp = true;
                                }
                                RecalcularDivs(Amb, Hosp);
                                flagMedico = false;
                                flagPSS = false;
                                
                              

                                $("#celulartrabajador").val(data.d.Celular);
                                $("#diasamb").val(data.d.DiasCalendarioAmbulatorio);
                                $("#cedulamedico").val(data.d.NoDocumentoMedico);
                                $("#medicoexequatur").val(data.d.Exequatur);
                                $("#mediconombre").val(data.d.NombreMedico);
                                $("#direccionmedico").val(data.d.DireccionMedico);
                                $("#telefonomedico").val(data.d.TelefonoMedico);
                                $("#celularmedico").val(data.d.CelularMedico);
                                $("#correomedico").val(data.d.CorreoMedico);
                                $("#buscarpss").val(data.d.NombreCentro);
                                $("#numeropss").val(data.d.PssCen);
                                $("#rncpss").val("");
                                $("#direccionpss").val(data.d.DireccionCentro);
                                $("#telefonopss").val(data.d.TelefonoCentro);
                                $("#faxpss").val(data.d.FaxCentro);
                                $("#correopss").val(data.d.CorreoCentro);
                                $("#cie10").val(data.d.CodigoCie10);
                                $("#fechadiagnostico").val(Util.formatJSONDate(data.d.FechaDiagnostico, "dd/mm/yyyy"));
                                $("#diagnostico").val(data.d.Diagnostico);
                                $("#sintomas").val(data.d.Sintomas);
                                $("#procedimientos").val(data.d.Procedimientos);

                                /// Cambiar las variables para el submit
                                $("#modo").val("r");
                                $("#numerosolicitudcompletado").val(data.d.NroSolicitud);
                                $("#nrosolicitud").val(data.d.NroSolicitud);
                                console.log(data.d.TipoDiscapacidad);
                                switch (data.d.TipoDiscapacidad) {
                                    case "E":
                                        $("#rdenfermedadcomun").attr("checked", true);
                                        $("#tipodiscapacidad").val("E");
                                        break;
                                    case "A":
                                        $("#rdaccidente").attr("checked", true);
                                        $("#tipodiscapacidad").val("A");
                                        break;
                                    case "D":
                                        $("#rdembarazo").attr("checked", true);
                                        $("#tipodiscapacidad").val("D");
                                        break;
                                }


                            });

                        });

                        /// Esconder el Todo
                        $("#ToDoList").hide();
                    }

                }
            });
        }
    </script>
    <style type="text/css">
        .Columna
        {
            width: 100px;
        }
        .Titulo
        {
            font-size: 14px;
            font-weight: bold;
            color: #016BA5;
            font-family: Arial;
        }
        .searchBox
        {
            width: 80%;
            border: 2px solid #E4EDF9;
            background-image: url('../images/zoom.png');
            background-repeat: no-repeat;
            background-position: left center;
            padding-left: 20px;
            font-size: 12pt;
            font-weight: bold;
            display: inline;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <input type="hidden" name="nroformularioprincipal" id="nroformularioprincipal" />
    <input type="hidden" name="nrosolicitud" id="nrosolicitud" />
    <input type="hidden" name="nrosolicitud2" id="nrosolicitud2" />
    <input type="hidden" name="tiposolicitudprincipal" id="tiposolicitudprincipal" />
    <input type="hidden" name="registropatronal" id="registropatronal" value="<%  Response.Write(UsrRegistroPatronal)%>" />
    <input type="hidden" name="usuarioprincipal" id="usuarioprincipal" value="<%  Response.Write(UsrRNC + UsrCedula)%>" />
    <span class="header">Subsidio por Enfermedad Común</span>
    <br />
    <span class="Descripcion">Bienvenido al nuevo módulo del registro de los subsidios por
        Enfermedad Común.</span>
    <br />
    <br />
    <table>
        <tr>
            <td>
                <table class="td-content">
                    <tr>
                        <td colspan="2">
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            Cedula:
                        </td>
                        <td>
                            <input type="text" name="cedula" id="cedula" value="" maxlength="11" />
                            <input type="button" name="buscar" id="buscar" value="Buscar" />
                            <input type="button" name="cancelar" id="cancelar" value="Cancelar" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table>
                                <tr class="Busqueda">
                                    <td align="right">
                                        Nombre:
                                    </td>
                                    <td>
                                        <span id="nombre"></span>
                                    </td>
                                </tr>
                                <tr class="Busqueda">
                                    <td align="right">
                                        Cédula:
                                    </td>
                                    <td>
                                        <span id="nodocumento"></span>
                                    </td>
                                </tr>
                                <tr class="Busqueda">
                                    <td align="right">
                                        NSS:
                                    </td>
                                    <td>
                                        <span id="nss"></span>
                                    </td>
                                </tr>
                                <tr class="Busqueda">
                                    <td align="right">
                                        Sexo:
                                    </td>
                                    <td>
                                        <span id="sexo"></span>
                                    </td>
                                </tr>
                                <tr class="Busqueda">
                                    <td align="right">
                                        Fecha de Nacimiento:
                                    </td>
                                    <td>
                                        <span id="FechaNacimiento"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" align="right">
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
            <td>
                <div id="ToDoList" />
            </td>
        </tr>
    </table>
    <br />
    <span id="msgPrincipal" class="error"></span>
    <div id="Formulario">
    </div>
    <br />
</asp:Content>
