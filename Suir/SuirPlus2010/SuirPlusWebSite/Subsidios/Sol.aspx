<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false"
    CodeFile="Sol.aspx.vb" Inherits="Subsidios_Sol" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
    <uc3:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
    <%If "A" = "B" Then%>
    <%-- <script src="../Script/jquery-1.5.2-vsdoc.js" type="text/javascript"></script>--%>
    <%End If%>
    <script type="text/javascript">

        $(function () {

            var ModoMaternidad = Util.GetQueryStringByName("m");
            var ModoSubsidio = Util.GetQueryStringByName("p");
            var ModoNroSol = Util.GetQueryStringByName("n");


            if (ModoMaternidad == "r") {
                if (ModoSubsidio == "m") {
                    InvocarRecon(ModoNroSol);
                } else if (ModoSubsidio == "l") {
                    ReconLactancia(ModoNroSol);
                }
            }

            $("#buscar").button();
            $("#buscar").click(function () { buscarDatos(); });
       
            $("#cancelar").click(Cancelar);
            $("#cancelar").button();

            $(".Busqueda").hide();
            $("#nacimiento").html("");

            $(".fecha").live('keypress', Util.SoloFecha);
            $(".fecha").live('change', Util.EvitarPaste);

            var ced = $('#cedula');

            ced.keydown(KD);
            ced.keyup(Util.SoloNumeros);

        });

        function Exito(msg) {

            var m = "<br><div class='Titulo'>" + msg + "</div>"

            $("#Formulario").html(m);
            $("#ToDoList").html("");
        }

        function KD(e) {
            Util.StopSubmit(e, function () { $("#buscar").click(); });
        }

        function buscarDatos(llamadaLac) {

            var ced = $("#cedula");
            try {
                if (ced.val() != "") {

                    $("#buscar").attr("disabled", true);
                    ced.attr("disabled", true);

                    var Url = loc + "/ConsultaCedula";
                    var data = '{ cedula: "' + ced.val() + '", registropatronal: "' + $("#registropatronalregistro").val() + '", tiposubsidio: "M" }';

                    Util.llamarWS(Url, data, function (info) {
                        if (typeof info.d == "string") {
                            $("#msgPrincipal").addClass("error");
                            $("#msgPrincipal").html(info.d);

                            $("#buscar").attr("disabled", false);
                            $("#cedula").attr("disabled", false);
                            $("#cedula").val("");
                            $("#cedula").focus();
                        }
                        else {
                            $("#msgPrincipal").html("");
                            $(".Busqueda").show();
                            $("#nss").html(info.d.nss);
                            $("#sexo").html(info.d.sexo);
                            $("#nombre").html(info.d.nombres);
                            $("#nodocumento").html(info.d.cedula);
                            $("#FechaNacimiento").html(info.d.fechanacimiento);

                            $.get("TodoList.htm?C=" + info.d.cedula, function (dataTodo) {
                                $("#ToDoList").html("");
                                $("#ToDoList").append(dataTodo);

                                if (llamadaLac) {
                                    llamadaLac();
                                    $("#ToDoList").html("");
                                }
                            });
                        }

                    }, ajaxFailed);

                    $("#msgPrincipal").html("");
                }
                else {
                    $("#msgPrincipal").addClass("error");
                    $("#msgPrincipal").html("Debe de digitar la cédula para continuar.");
                    ced.val("");
                    ced.focus();
                }
            }
            catch (e) {
                $("#buscar").attr("disabled", false);
                ced.attr("disabled", false);
            }
        }

        function Cancelar() {
            $(".Busqueda").hide();
            $("#ToDoList").html("");
            $("#cedula").val("");
            $("#buscar").attr("disabled", false);

            $("#nss").html("");
            $("#sexo").html("");
            $("#nombre").html("");
            $("#nodocumento").html("");
            $("#FechaNacimiento").html("");

            $("#cedula").focus();
            $("#Formulario").html("");
            $("#cedula").attr("disabled", false);
            $("#msgPrincipal").html("");
        }
        function ajaxFailed(xhr, ajaxOptions, thrownError) {
            alert(xhr.status);
            alert(thrownError);
            $("#buscar").attr("disabled", false);
            $("#cedula").attr("disabled", false);
            $("#cedula").focus();
        }

        //Aqui se maneja la reconsideracion de lactancia
        function ReconLactancia(ModoNroSol) {
            var Params = {
                idlactancia: ModoNroSol,
                registropatronal: $("#registropatronalregistro").val()
            };

            Util.LlamarServicio('Subsidios.asmx', 'getLactancia', Params, function (data) {

                if (data) {

                    if (typeof (data.d) == "string") {
                        $("#msgPrincipal").html(data.d);
                    } else {
                        $("#cedula").val(data.d[0].NroDocumentoMadre);

                        $("#buscar").attr("disabled", true);
                        $("#cancelar").attr("disabled", true);
                        $("#cedula").attr("disabled", true);

                        /// Llenar datos de la madre
                        buscarDatos(function () {

                            //cargar datos registro lactancia
                            $.get('ReporteNacimiento.htm', function (dataNac) {

                                $("#Formulario").html(dataNac);

                                var cantidad = data.d[0].CantidadLactante;
                                $("#fechanacimiento").val(Util.formatJSONDate(data.d[0].FechaNacimiento, "dd/mm/yyyy"));
                                $("#nrosolicitudnacimiento").val(data.d[0].NroSolicitud);
                                $("#nrosolicitudmaternidad").val(data.d[0].NroSolicitudMaternidad);
                                $("#nrosolicitud2").val(data.d[0].NroSolicitud);
                                $("#modo").val("r");
                                $("#cantidadlactante").val(cantidad);

                                CantidadLactantes(function () {
                                    for (var i = 0; i < data.d.length; i++) {
                                        var basecount = i + 1;
                                        $("#nss" + basecount).val(data.d[i].NssLactante);
                                        $("#nombres" + basecount).val(data.d[i].Nombres);
                                        $("#papellido" + basecount).val(data.d[i].PrimerApellido);
                                        $("#sapellido" + basecount).val(data.d[i].SegundoApellido);
                                        $("#sexo" + basecount).val(data.d[i].Sexo);
                                        $("#nui" + basecount).val(data.d[i].Nui);
                                    }
                                });
                            });
                        });
                    }
                }
            });
        }

        //Aqui se maneja la reconsideracion de maternidad
        function InvocarRecon(ModoNroSol) {

            var Params = {
                maternidadId: ModoNroSol,
                registropatronal: $("#registropatronalregistro").val()
            };

            Util.LlamarServicio('Subsidios.asmx', 'getMaternidad', Params, function (data) {

                if (data) {

                    if (typeof (data.d) == "string") {
                        $("#msgPrincipal").html(data.d);
                    } else {

                        $("#buscar").attr("disabled", true);
                        $("#cancelar").attr("disabled", true);
                        $("#cedula").attr("disabled", true);

                        //Cargar los datos Iniciales
                        $(".Busqueda").show();
                        $("#cedula").val(data.d.NoDocumento);
                        $("#cedula").attr("enabled", false);
                        $("#nodocumento").html(data.d.NoDocumento);
                        $("#nss").html(data.d.NSSMadre);
                        $("#sexo").html(data.d.SexoMadre);
                        $("#nombre").html(data.d.NombreMadre);
                        $("#FechaNacimiento").html(data.d.FechaNacimiento);

                        buscarDatos();

                        //Cargar los datos del registro de embarazo//
                        $.get('RegistroEmbarazo.htm', function (dataLic) {

                            $("#Formulario").html("");
                            $("#Formulario").html(dataLic);

                            //Llenar datos de embarazo
                            $("#fechadiagnostico").val(data.d.FechaDiagnostico);
                            $("#fechaestimadaparto").val(data.d.FechaEstimadaParto);
                            $("#telefono").val(data.d.Telefono);
                            $("#celular").val(data.d.Celular);
                            $("#email").val(data.d.Correo);

                            //Datos del Tutor
                            $("#cedulatutor").val(data.d.NroDocumentoTutor);
                            $("#nombretutor").html(data.d.NombreTutor);
                            $("#nodocumentotutor").html(data.d.NroDocumentoTutor);
                            $("#nsstutorlabel").html(data.d.NSSTutor);
                            $("#sexotutor").html(data.d.SexoTutor);
                            $("#fechanacimientotutor").html(data.d.FechaNacimientoTutor);
                            $("#telefonotutor").val(data.d.TelefonoTutor);
                            $("#emailtutor").val(data.d.CorreoTutor);


                            $.get('ReporteRetroactivo.htm', function (dataretroactivo) {

                                //Controlar desde aqui la carga para reconsideracion en ReporteRetroactivo.htm
                                $("#mifieldset").html("");
                                $("#mifieldset").append(dataretroactivo);

                                //Llenar datos licencia
                                flagMedico = false;
                                $("#cedulamedico").val(data.d.NoDocumentoMedico);
                                $("#medicoexequatur").val(data.d.Exequatur);
                                $("#mediconombre").val(data.d.NombreMedico);
                                $("#direccionmedico").val(data.d.DireccionMedico);
                                $("#telefonomedico").val(data.d.TelefonoMedico);
                                $("#celularmedico").val(data.d.CelularMedico);
                                $("#correomedico").val(data.d.CorreoMedico);
                                flagPSS = false;
                                $("#buscarpss").val(data.d.NombreCentro);
                                $("#numeropss").val(data.d.PssCen);
                                $("#nombrepss").val(data.d.NombreCentro);
                                $("#direccionpss").val(data.d.DireccionCentro);
                                $("#telefonopss").val(data.d.TelefonoCentro);
                                $("#correopss").val(data.d.CorreoCentro);
                                $("#fechalicencia").val(data.d.FechaLicencia);
                                $("#fechadiagnosticolicencia").val(data.d.FechaDiagnosticoLicencia);
                                $("#diagnostico").val(data.d.Diagnostico);
                                $("#sintomas").val(data.d.Sintomas);
                                $("#procedimientos").val(data.d.Procedimientos);

                                $("#modo").val("r");
                                $("#nrosolicitudretroactivo").val(data.d.NroSolicitud);
                                $("#nrosolicitud2").val(data.d.NroSolicitud);
                                //Cambiar titulo de retroactivo
                                $("#tituloRetroactiva").html("Datos de la Licencia");

                                //Esconder botones procesar embarazo y divs novedades cierre
                                $(".btnRE").hide();
                                $(".noRecon").hide();

                            });

                        });
                    }

                }
            });
            /// Esconder el Todo

            $("#ToDoList").hide();
        }

        function mifuncion() {
            buscarFormulario('RegistroEmbarazo.htm', laotra);
        }
        function laotra() {
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
    <input type="hidden" name="nroformulario" id="nroformularioprincipal" />
    <input type="hidden" name="nrosolicitud" id="nrosolicitud" />
    <input type="hidden" name="nrosolicitud2" id="nrosolicitud2" />
    <input type="hidden" name="registropatronalregistro" id="registropatronalregistro"
        value="<%  Response.Write(UsrRegistroPatronal)%>" />
    <input type="hidden" name="fechaactual" id="fechaActual" value="<%Response.Write(String.Format("{0:dd/MM/yyyy}", DateTime.Now))%>" />
    <input type="hidden" name="usuarioregistro" id="usuarioregistro" value="<%  Response.Write(UsrRNC + UsrCedula)%>" />
    <input type="hidden" name="modo2" id="modo2" class="modo" value="n" />
    <span class="header">Subsidio de Maternidad & Lactancia</span>
    <br />
    <span class="Descripcion">Bienvenido al nuevo módulo del registro de los subsidios de
        Maternidad & Lactancia.</span>
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
