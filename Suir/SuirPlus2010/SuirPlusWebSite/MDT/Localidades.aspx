<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false"
    CodeFile="Localidades.aspx.vb" Inherits="MDT_Localidades" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc1" %>
<%@ Register Src="../Controles/ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
    <% If 1 = 2 Then
    %>
    <script src="../Script/Util.js" type="text/javascript"></script>
    <script src="../Script/jquery-1.5.2-vsdoc.js" type="text/javascript"></script>
    <%
    End If
    %>
    <script type="text/javascript" src="../Script/json2.js"></script>
    <script type="text/javascript">

        function formatCurrency(num) {

            num = isNaN(num) || num === '' || num === null ? 0.00 : num;
            return parseFloat(num).toFixed(2);
        }

        $(function () {
            $("#dialog-warning").hide();
            //  pagaMDT();
            CargarProvincias();
            CargarActividad();
            CargarParqueZonaFranca();

            $(".telefono").mask("999-999-9999");
            $("#operacionesano").keyup(Util.SoloNumeros);
            $('#txtValorInstalacion').live("keyup", function () { Util.Solo_Numeros_o_Decimales($(this), 'float'); });
            $('#cbEs_Zona_Franca').change(function () {
                if ($('#cbEs_Zona_Franca').attr('checked')) {
                    $("#trTipoZonaFranca").show();
                    $("#trParqueZonaFranca").show();
                } else {
                    $("#ddlTipoZonaFranca").val(0);
                    $("#ddlParqueZonaFranca").val(0);
                    $("#trTipoZonaFranca").hide();
                    $("#trParqueZonaFranca").hide();
                }
            });

            HabilitarListado();

            $("#btnAgregar").click(function () {
                HabilitarFormulario();
            });

            $("#btnAgregar1").click(function () {
                HabilitarFormulario();
            });

            $("#btnAgregar").button();
            $("#btnAgregar1").button();

            $('#btnRegistrar').click(function () {
                ProcLocalidad($("#hfIdLocalidad").val());
            });


            $('#btnActualizar').click(function () {
                var id = $("#hfIdLocalidad").val();
                ProcLocalidad(id);
            });

            $("#btnCancelar").click(function () {
                limpiarFormulario();
                HabilitarListado();
            });

            $("#btnLimpiarDatosContacto").click(function () {

                $("#txtDocumento").val("");
                $("#ddlTipodoc").val("C");
                $("#nombreTrabajador").html("");
                $("#txtEmail").val("");
                $("#txtTelefono").val("");
                $("#txtFax").val("");
                $("#trEmail").hide();
                $("#trTel").hide();
                $("#trFax").hide();

                $('#ddlTipodoc').attr('disabled', false);
                $('#txtDocumento').attr('disabled', false);
                $('#btnBuscar').attr('disabled', false);

            });

            $("#btnLimpiarDatosRep").click(function () {

                $("#txtDocumentoRep").val("");
                $("#ddlTipodocRep").val("C");
                $("#nombreRepresentante").html("");

                $('#ddlTipodocRep').attr('disabled', false);
                $('#txtDocumentoRep').attr('disabled', false);
                $('#btnBuscarRep').attr('disabled', false);

            });

            $("#btnBuscar").click(function () {
                getContactoLocalidad();
            });

            $("#btnBuscarRep").click(function () {
                getRepresentanteLocalidad();
            });



        });

        //Bloque de Funciones Generales de JavaScript//////////////////////////////////////

        //verificamos si el empresa logeada paga mdt

        //        function pagaMDT() {
        //            Params = {
        //                idRegPatronal: $("#RegistroPatronal").html()
        //            }
        //            Util.LlamarServicio('MDT.asmx', 'pagaMDT', Params, function (data) {

        //                if (data.d == "False") {
        //                    $("#divListado").hide();
        //                    $("#divExportarExcel").hide();
        //                    $("#btnAgregar").hide();
        //                    var onerror = "window.location.href = '../Empleador/consNotificaciones.aspx'";
        //                    Util.MostrarMensaje('ERROR', 'Este empleador no paga impuestos del Ministerio de Trabajo.',null, onerror);
        //                                    
        //                }

        //            });
        //        }
        /////////////////////////////////////////////

        function LlamarGrid() {
            //Bloque de Implementacion del JQGrid/////////////////////////////////////////
            var Params = {
                pPageSize: 25,
                pCurrentPage: 1,
                pCriterio: $("#RegistroPatronal").html(),
                pSortColumn: '',
                pSortOrder: ''
            };

            var ColNames = ['', 'Id', 'RNL', 'Establecimiento', 'Dirección', 'Contacto', 'Inicio Op.', 'Estatus'];
            var ColModel = [
                { name: '0', index: '0', sortable: false, width: 8, align: "center", key: true, formatter: formatColumnImage },
                { name: '1', index: '1', sortable: false, width: 8, align: "center" },
                { name: '2', index: '2', sortable: false, width: 18, align: "center" },
                { name: '3', index: '3', sortable: false, width: 42, align: "left" },
                { name: '4', index: '4', sortable: false, width: 42, align: "left" },
                { name: '5', index: '5', sortable: false, width: 40, align: "left" },
                { name: '6', index: '6', sortable: false, width: 12, align: "center" },
                { name: '7', index: '7', sortable: false, width: 12, align: "center"}];



            Util.Grid('MDT.asmx', 'getLocalidades', 'Localidades', 'LocalidadesPager', ColNames, ColModel, Params, 'Listado de Localidades', 25, function (id) {
                HabilitarFormulario(id);
            });
            //Fin del JQGrid/////////////////////////////////////////
        }


        function formatColumnImage(cellvalue, options, rowObject) {
            $(".colimg").css('cursor', 'pointer');
            return "<img class='colimg' src='../images/edit-icon.png' />";

        }

        function HabilitarListado() {
            $("#btnAgregar").button();
            $("#btnAgregar").show();
            $("#btnAgregar1").button();
            $("#btnAgregar1").show();
            $("#divListado").show();
            $("#divFormulario").hide();
            LlamarGrid();
            $("#msg").html('');

        }
        function HabilitarFormulario(valor) {
            $("#ddlProvincias").find("option[value='99']").remove();
            $("#trTipoZonaFranca").hide();
            $("#trParqueZonaFranca").hide();
            $("#trMunicipio").hide();
            $("#msg").html('');
            $("#hfIdLocalidad").val(valor);

            $("#btnAgregar").hide();
            $("#btnAgregar1").hide();
            $("#divListado").hide();
            $("#divFormulario").show();
            $("#btnCancelar").button();
            $("#btnRegistrar").button();
            $("#btnActualizar").button();
            $("#btnBuscar").button();
            $('#btnBuscar').attr('disabled', false);
            $("#btnLimpiarDatosContacto").button();
            $("#trEmail").hide();
            $("#trTel").hide();
            $("#trFax").hide();
            $("#btnBuscarRep").button();
            $('#btnBuscarRep').attr('disabled', false);
            $("#btnLimpiarDatosRep").button();

            if (valor > 0) {
                $("#btnActualizar").show();
                $("#btnRegistrar").hide();
                $("#trRnl").show();
                $("#trEstatus").show();
            }
            else {

                $("#btnActualizar").hide();
                $("#btnRegistrar").show();
                $("#trRnl").hide();
                $("#trEstatus").hide();
            }

            if (valor > 0) {

                /// Cargar localidad by Id
                Params = {
                    IdLocalidad: valor
                };
                Util.LlamarServicio('MDT.asmx', 'getLocalidad', Params, function (data) {

                    $("#operacionesano").val(data.d.ano_ini_operaciones);

                    $("#ddlActividad").val(data.d.id_actividad);
                    $("#txtA_que_se_dedica").val(data.d.a_que_se_dedica);
                    if (data.d.es_zona_franca == "S") {
                        $('#cbEs_Zona_Franca').attr('checked', true);
                        $("#trTipoZonaFranca").show();
                        $("#trParqueZonaFranca").show();

                        $("#ddlTipoZonaFranca").val(data.d.tipo_zona_franca);
                        $("#ddlParqueZonaFranca").val(data.d.id_zona_franca);
                    } else {
                        $('#cbEs_Zona_Franca').attr('checked', false);
                        $("#trTipoZonaFranca").hide();
                        $("#trParqueZonaFranca").hide();
                    }

                    $("#nombreEstablecimiento").val(data.d.nombre_localidad);
                    $("#calle").val(data.d.calle);
                    $("#Sector").val(data.d.sector);
                    $("#lblRNL").html(data.d.rnl);
                    $("#lblCodigoLocalidad").val(data.d.cod_localidad);
                    $("#ddlProvincias").val(data.d.id_provincia);

                    if (data.d.id_provincia > 0) {
                        $("#trMunicipio").show();
                        CargarMunicipio(data.d.id_provincia, data.d.id_municipio);
                    }
                    $("#ddlStatus").val(data.d.status);

                    if (data.d.valor_instalacion > 0) {
                        $("#txtValorInstalacion").val(formatCurrency(data.d.valor_instalacion));
                    } else {
                        $("#txtValorInstalacion").val('0.00');
                    }

                    $("#Edificio").val(data.d.edificio);

                    if (data.d.no_documento != "") {

                        $("#txtDocumento").val(data.d.no_documento);
                        if (data.d.no_documento.length == 11) {
                            $("#ddlTipodoc").val('C')
                        } else { $("#ddlTipodoc").val('P') }

                        getContactoLocalidad();
                    }

                    if (data.d.no_documento_representante != "") {

                        $("#txtDocumentoRep").val(data.d.no_documento_representante);
                        if (data.d.no_documento_representante.length == 11) {
                            $("#ddlTipodocRep").val('C')
                        } else { $("#ddlTipodocRep").val('P') }
                        getRepresentanteLocalidad();
                    }

                });

            } else {
                limpiarFormulario();
            }

            $("#ddlProvincias").change(function () {

                var pro = $("#ddlProvincias").val();

                if (pro != '0') {
                    $("#trMunicipio").show();
                    CargarMunicipio(pro);
                }
                else {
                    $("#trMunicipio").hide();
                }
            });

        }
        //llenamos los dropdowns


        // dropdown de actividad economica
        function CargarActividad() {
            var Params3 = {};
            Util.LlenarDropDown('MDT.asmx', 'listarActividad', Params3, 'ddlActividad', '0', '1', "Seleccione", null, null);

        }

        // dropdown de Parque Zona Franca
        function CargarParqueZonaFranca() {
            var Params4 = {};
            Util.LlenarDropDown('MDT.asmx', 'listarParqueZonaFranca', Params4, 'ddlParqueZonaFranca', '0', '1', "Seleccione", null, null);

        }
        // dropdown de provincias
        function CargarProvincias() {

            var Params2 = {};
            Util.LlenarDropDown('MDT.asmx', 'getProvincias', Params2, 'ddlProvincias', '0', '1', "Seleccione", null, function () {

                var pro = $("#ddlProvincias").val();

                if (pro != '0') {
                    $("#trMunicipio").show();
                    CargarMunicipio(pro);
                }
                else {
                    $("#trMunicipio").hide();
                }

            });

        }
        function CargarMunicipio(Provincia, Municipio) {
            var Params3 = {
                idProvincia: Provincia
            };
            Util.LlenarDropDown('MDT.asmx', 'getMunicipios', Params3, 'ddlMunicipios', '0', '1', "Seleccione", Municipio, function () {
                $("#ddlMunicipios").find("option[value='777']").remove();
            },
            function () {
                CargarProvincias();
            });


        }

        function limpiarFormulario() {

            $("#ddlActividad").val(0);
            $("#txtA_que_se_dedica").val("");
            $('#cbEs_Zona_Franca').attr('checked', false);
            $("#ddlTipoZonaFranca").val(0);
            $("#ddlParqueZonaFranca").val(0);
            $("#operacionesano").val('');
            $("#nombreEstablecimiento").val('');
            $("#calle").val('');
            $("#Sector").val('');
            $("#lblRNL").html('');
            $("#lblCodigoLocalidad").val('');
            $("#ddlProvincias").val(0);
            $("#ddlMunicipios").val(0);
            $("#txtValorInstalacion").val("0.00");
            $("#Edificio").val('');

            //Datos representante
            $('#btnBuscarRep').attr('disabled', false);
            $("#nombreRepresentante").html("");
            $('#ddlTipodocRep').attr('disabled', false);
            $('#txtDocumentoRep').attr('disabled', false);
            $('#btnBuscarRep').attr('disabled', false);
            $("#txtDocumentoRep").val("");
            $("#ddlTipodocRep").val("C");
            $("#nombreRepresentante").html("");

            //Datos contacto
            $('#ddlTipodoc').attr('disabled', false);
            $('#txtDocumento').attr('disabled', false);
            $('#btnBuscar').attr('disabled', false);
            $("#txtDocumento").val("");
            $("#ddlTipodoc").val("C");
            $("#nombreTrabajador").html("");
            $("#txtEmail").val("");
            $("#txtTelefono").val("");
            $("#txtFax").val("");
            $("#trEmail").hide();
            $("#trTel").hide();
            $("#trFax").hide();

        }

        function getContactoLocalidad() {

            var ParamsContactoLocalidad = {

                // idRegPatronal: $("#RegistroPatronal").html(),
                documento: $("#txtDocumento").val(),
                id_localidad: $("#hfIdLocalidad").val(),
                tipoDoc: $("#ddlTipodoc").val()
            };

            Util.LlamarServicio('MDT.asmx', 'getContactoLocalidad', ParamsContactoLocalidad, function (data) {
                if ($('#txtDocumento').val() != "") {

                    var info = JSON.parse(data.d);
                    if (info.rows[0] != "0") {

                        $("#nombreTrabajador").html(info.rows[1]);
                        $("#nombreTrabajador").removeClass("labelSubtitulo");
                        $("#nombreTrabajador").addClass("error");
                        $("#trEmail").hide();
                        $("#trTel").hide();
                        $("#trFax").hide();

                        $("#btnBuscar").attr('disabled', false);

                        $('#ddlTipodoc').attr('disabled', false);
                        $('#txtDocumento').attr('disabled', false);
                    } else {

                        $("#nombreTrabajador").removeClass("error");
                        $("#nombreTrabajador").addClass("labelSubtitulo");
                        $("#nombreTrabajador").html(info.rows[1]);
                        $("#txtEmail").val(info.rows[2]);
                        $("#txtTelefono").val(info.rows[3]);
                        $("#txtFax").val(info.rows[4]);

                        $("#trEmail").show();
                        $("#trTel").show();
                        $("#trFax").show();
                        $("#btnBuscar").attr('disabled', true);

                        $('#ddlTipodoc').attr('disabled', true);
                        $('#txtDocumento').attr('disabled', true);

                    }
                } else {
                    $("#trEmail").hide();
                    $("#trTel").hide();
                    $("#trFax").hide();
                    $("#btnBuscar").attr('disabled', false);
                }
            });

        }


        function getRepresentanteLocalidad() {

            var ParamsRepresentanteLocalidad = {

                idRegPatronal: $("#RegistroPatronal").html(),
                documento: $("#txtDocumentoRep").val(),
                id_localidad: $("#hfIdLocalidad").val(),
                tipoDoc: $("#ddlTipodocRep").val()
            };

            Util.LlamarServicio('MDT.asmx', 'getContactoLocalidad', ParamsRepresentanteLocalidad, function (data) {
                if ($('#txtDocumentoRep').val() != "") {
                    var info = JSON.parse(data.d);
                    if (info.rows[0] != "0") {

                        $("#nombreRepresentante").html(info.rows[1]);
                        $("#nombreRepresentante").removeClass("labelSubtitulo");
                        $("#nombreRepresentante").addClass("error");

                        $("#btnBuscarRep").attr('disabled', false);

                        $('#ddlTipodocRep').attr('disabled', false);
                        $('#txtDocumentoRep').attr('disabled', false);
                    } else {

                        $("#nombreRepresentante").removeClass("error");
                        $("#nombreRepresentante").addClass("labelSubtitulo");
                        $("#nombreRepresentante").html(info.rows[1]);

                        $("#btnBuscarRep").attr('disabled', true);

                        $('#ddlTipodocRep').attr('disabled', true);
                        $('#txtDocumentoRep').attr('disabled', true);

                    }
                } else {
                    $("#btnBuscarRep").attr('disabled', false);
                }
            });

        }
        function ProcLocalidad(id_loc) {
            var cbZonaFranca;
            var idTipoZonaFranca;
            var idParqueZonaFranca;
            if ($('#cbEs_Zona_Franca').attr('checked')) {
                cbZonaFranca = "S";
                idTipoZonaFranca = $("#ddlTipoZonaFranca").val();
                idParqueZonaFranca = $("#ddlParqueZonaFranca").val();
            } else {
                cbZonaFranca = "N";
                idTipoZonaFranca = null;
                idParqueZonaFranca = null;
            }
            var ParamsLocalidad = {
                id_localidad: id_loc,
                id_registro_patronal: $("#RegistroPatronal").html(),
                descripcion: $("#nombreEstablecimiento").val(),
                status: $("#ddlStatus").val(),
                calle: $("#calle").val(),
                edificio: $("#Edificio").val(),
                sector: $("#Sector").val(),
                id_provincia: $("#ddlProvincias").val(),
                id_municipio: $("#ddlMunicipios").val(),
                correo_electronico: $("#txtEmail").val(),
                fax_contacto: $("#txtFax").val(),
                telefono_contacto: $("#txtTelefono").val(),
                no_documento: $('#txtDocumento').val(),
                ini_operaciones: $("#operacionesano").val(),
                valor_instalacion: $("#txtValorInstalacion").val(),
                ult_usuario_act: $("#UsuarioLog").html(),
                id_actividad: $("#ddlActividad").val(),
                a_que_se_dedica: $("#txtA_que_se_dedica").val(),
                es_zona_franca: cbZonaFranca,
                tipo_zona_franca: idTipoZonaFranca,
                id_zona_franca: idParqueZonaFranca,
                no_documento_rep: $("#txtDocumentoRep").val()

            };

            //set de validaciones
            var Resultado = validaciones();

            if (Resultado != "") {

                Resultado = "Favor revisar los siguientes campos: <br>" + Resultado;

                $("#msg").html(validaciones());
                $("#msg").removeClass("labelSubtitulo");
                $("#msg").addClass("error");
                return
            }

            Util.LlamarServicio('MDT.asmx', 'procesarLocalidad', ParamsLocalidad, function (data) {
                var info = data.d;
                if (info == 0) {

                    // Mensaje();
                    limpiarFormulario();

                    Util.MostrarMensaje('OK', 'Registro procesado satisfactoriamente.', null, null);

                    // HabilitarFormulario();
                    HabilitarListado();
                }
                else {

                    $("#msg").html(info);
                    $("#msg").removeClass("labelSubtitulo");
                    $("#msg").addClass("error");

                }

            });
        }

        //set de validaciones

        function validaciones() {

            var Resultado = "";

            var Ano = new Date();
            if (($("#operacionesano").val().length != 4) || (!($("#operacionesano").val() > 1900 && $("#operacionesano").val() <= Ano.getFullYear()))) {
                Resultado += "* Año de inicio de operaciones inválido.</br>";
            }
            if ($("#ddlActividad").val() == 0) {
                Resultado += "* La actividad del establecimiento es requerida.</br>";
            }
            if (($("#txtA_que_se_dedica") == "") || ($.trim($("#txtA_que_se_dedica").val()).length == 0)) {
                Resultado += "* Debe especificar a que se dedica el establecimiento.</br>";
            }
            if ($('#cbEs_Zona_Franca').attr('checked')) {
                if ($("#ddlTipoZonaFranca").val() == 0) {
                    Resultado += "* El tipo de zona franca es requerido.</br>";
                }
                if ($("#ddlParqueZonaFranca").val() == 0) {
                    Resultado += "* El parque es requerido.</br>";
                }
            }

            if (($("#nombreEstablecimiento").val() == "") || ($.trim($("#nombreEstablecimiento").val()).length == 0)) {
                Resultado += "* La descripción del establecimiento es requerida.</br>";
            }

            if (($("#calle").val() == "") || ($.trim($("#calle").val()).length == 0)) {
                Resultado += "* La calle del establecimiento es requerida.</br>";
            }

            if (($("#Sector").val() == "") || ($.trim($("#Sector").val()).length == 0)) {
                Resultado += "* El sector del establecimiento es requerido.</br>";
            }

            if ($("#ddlProvincias").val() == 0) {
                Resultado += "* La provincia del establecimiento es requerida.</br>";
            }

            if ($("#ddlProvincias").val() > 0) {
                if ($("#ddlMunicipios").val() == 0) {
                    Resultado += "* El municipio del establecimiento es requerido.</br>";
                }
            }



            var ValorIns = $("#txtValorInstalacion").val();
            if ((ValorIns == "") || (ValorIns <= 0)) {
                Resultado += "* El valor de instalación es inválido y es requerido.</br>";
            }

            if (($('#txtDocumento').val() == "") || ($("#nombreTrabajador").html() == "")) {
                Resultado += "* Debe buscar un contacto válido.</br>";
            }

            if ($("#nombreTrabajador").html() != "") {
                if ($("#txtEmail").val() == "") {
                    Resultado += "* El correo electrónico del contacto es requerido.</br>";
                }

                var Email = $("#txtEmail").val();
                if (!Util.IsValidEmail(Email)) {
                    Resultado += "* El correo electrónico del contacto es inválido.</br>";
                }

                if ($("#txtTelefono").val() == "") {
                    Resultado += "* El número de teléfono del contacto es requerido.</br>";
                }

            }

            if (($('#txtDocumentoRep').val() == "") || ($('#txtDocumentoRep').val() == "00000000000") || ($("#nombreRepresentante").html() == "")) {
                Resultado += "* Debe buscar un representante válido.</br>";
            }

            return Resultado;
        }
      
    </script>
    <style type="text/css">
        .style1
        {
            width: 103px;
        }
        .buttonSize
        {
            font-size: 8pt;
        }
        .Selector
        {
            font-size: 8pt;
        }
        
        .tooltip
        {
            position: absolute;
            top: 0;
            left: 0;
            z-index: 3;
            display: none;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <span class="header">Establecimientos</span>
    <br />
    <input type="hidden" id="hfIdLocalidad" />
    <uc1:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
    <div style="text-align: right; width: 860px;">
        <span id="btnAgregar1" class="buttonSize">Agregar</span>
    </div>
    <br />
    <div id="divListado">
        <table id="Localidades">
        </table>
        <div id="LocalidadesPager">
        </div>
        <div id="divExportarExcel">
            <br />
            <uc2:ucExportarExcel ID="ucExportarExcel1" runat="server" />
        </div>
    </div>
    <div id="divFormulario">
        <table class="td-content">
            <tr>
                <td colspan="2">
                    <br />
                    <span style="font-size: 13px; font-weight: bold; color: #016BA5; font-family: Arial">
                        Datos Generales del Establecimiento</span> <span id="RegistroPatronal" style="visibility: hidden;">
                            <%=UsrRegistroPatronal%></span> <span id="UsuarioLog" style="visibility: hidden;"><%=UsrUserName%></span>
                    <br />
                </td>
            </tr>
            <tr>
                <td id="trRnl">
                    RNL:
                </td>
                <td>
                    <span id="lblRNL" class="labelSubtitulo" />
                </td>
            </tr>
            <tr>
                <td>
                    Inicio Operaciones:
                </td>
                <td>
                    <input name="" id="operacionesano" maxlength="4" style="width: 40px" />
                </td>
            </tr>
            <tr>
                <td maxlength="15">
                    Establecimiento:
                </td>
                <td>
                    <textarea name="" id="nombreEstablecimiento" rows="2" class="input textboxmedico"
                        style="width: 250px"></textarea>
                </td>
            </tr>
            <tr>
                <td>
                    Actividad:
                </td>
                <td>
                    <select id="ddlActividad" class="dropDowns" />
                </td>
            </tr>
            <tr>
                <td>
                    A que se dedica:
                </td>
                <td>
                    <textarea name="" id="txtA_que_se_dedica" rows="2" class="input textboxmedico" style="width: 250px"></textarea>
                </td>
            </tr>
            <tr>
                <td>
                    Es zona Franca:
                </td>
                <td>
                    <input id="cbEs_Zona_Franca" type="checkbox" />
                </td>
            </tr>
            <tr id="trTipoZonaFranca">
                <td>
                    Tipo:
                </td>
                <td>
                    <select id="ddlTipoZonaFranca" class="dropDowns">
                        <option value="0" selected="selected">Seleccione</option>
                        <option value="1">Comercial</option>
                        <option value="2">Normal</option>
                    </select>
                </td>
            </tr>
            <tr id="trParqueZonaFranca">
                <td>
                    Parque:
                </td>
                <td>
                    <select id="ddlParqueZonaFranca" class="dropDowns" />
                </td>
            </tr>
            <tr>
                <td>
                    Edificio:
                </td>
                <td>
                    <input name="" id="Edificio" style="width: 250px" />
                </td>
            </tr>
            <tr>
                <td>
                    Calle:
                </td>
                <td>
                    <input name="" id="calle" style="width: 250px" />
                </td>
            </tr>
            <tr>
                <td>
                    Sector:
                </td>
                <td>
                    <input name="" id="Sector" style="width: 250px" />
                </td>
            </tr>
            <tr>
                <td>
                    Provincia:
                </td>
                <td>
                    <select id="ddlProvincias" class="dropDowns" />
                </td>
            </tr>
            <tr id="trMunicipio">
                <td>
                    Municipio:
                </td>
                <td>
                    <select id="ddlMunicipios" class="dropDowns" />
                </td>
            </tr>
            <tr id="trEstatus">
                <td>
                    Estatus:
                </td>
                <td>
                    <select id="ddlStatus" class="dropDowns">
                        <option value="A" selected="selected">Activo</option>
                        <option value="I">Inactivo</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td nowrap="nowrap">
                    Valor de Instalación:
                </td>
                <td>
                    <input name="" id="txtValorInstalacion" style="width: 150px; text-align: right;"
                        value="0.00" maxlength="18" />
                </td>
            </tr>
            <tr>
                <td>
                    <br />
                </td>
            </tr>
        </table>
        <br />
        <table class="td-content">
            <tr>
                <td colspan="2">
                    <span style="font-size: 13px; font-weight: bold; color: #016BA5; font-family: Arial">
                        Datos del Representante</span>
                    <br />
                </td>
            </tr>
            <tr>
                <td class="style1">
                    <select id="ddlTipodocRep" class="dropDowns">
                        <option selected="selected" value="C">Cédula</option>
                        <option value="P">Pasaporte</option>
                    </select>
                </td>
                <td>
                    <input id="txtDocumentoRep" />&nbsp; <span id="btnBuscarRep" style="font-size: 8pt;"
                        class="btnButton">Buscar</span> &nbsp; <span id="btnLimpiarDatosRep" style="font-size: 8pt;"
                            class="btnButton">Limpiar</span>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <span id="nombreRepresentante" class="labelSubtitulo"></span>
                </td>
            </tr>
        </table>
        <br />
        <table class="td-content">
            <tr>
                <td colspan="2">
                    <span style="font-size: 13px; font-weight: bold; color: #016BA5; font-family: Arial">
                        Datos del Contacto</span>
                    <br />
                </td>
            </tr>
            <tr>
                <td class="style1">
                    <select id="ddlTipodoc" class="dropDowns">
                        <option selected="selected" value="C">Cédula</option>
                        <option value="P">Pasaporte</option>
                    </select>
                </td>
                <td>
                    <input id="txtDocumento" />&nbsp; <span id="btnBuscar" style="font-size: 8pt;" class="btnButton">
                        Buscar</span> &nbsp; <span id="btnLimpiarDatosContacto" style="font-size: 8pt;" class="btnButton">
                            Limpiar</span>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <span id="nombreTrabajador" class="labelSubtitulo"></span>
                </td>
            </tr>
            <tr id="trEmail">
                <td>
                    Email:
                </td>
                <td>
                    <input name="" id="txtEmail" />
                </td>
            </tr>
            <tr id="trTel">
                <td>
                    Teléfono:
                </td>
                <td>
                    <input name="" id="txtTelefono" class="telefono" />
                </td>
            </tr>
            <tr id="trFax">
                <td>
                    Fax:
                </td>
                <td>
                    <input name="" id="txtFax" class="telefono" />
                </td>
            </tr>
        </table>
        <br />
        <div style="width: 416px; text-align: right">
            <span id="btnRegistrar" class="buttonSize">Registrar</span> <span id="btnActualizar"
                class="buttonSize">Actualizar</span> &nbsp; <span id="btnCancelar" class="buttonSize">
                    Cancelar</span>
        </div>
    </div>
    <br />
    <div style="text-align: right; width: 860px;">
        <%--<input type="button" id="bntAgregar" value="Agregar"/>--%>
        <span id="btnAgregar" class="buttonSize">Agregar</span>
    </div>
    <div id="dialog-warning" title="Información">
        <div id="TextoMsg" class="ui-dialog-title" style="float: left; margin: 0 7px 0px 0;
            font-size: small; color: Red;">
        </div>
    </div>
    <span id="msg" class="labelSubtitulo"></span>
    <br />
</asp:Content>
