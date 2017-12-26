<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="DetSubsidiosSFS.aspx.vb" Inherits="Subsidios_DetSubsidiosSFS" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <br />
    <link href="../css/jquery-ui-1.8.11.custom.css" rel="stylesheet" type="text/css" />
    <script src="../Script/jquery-1.5.2.min.js" type="text/javascript"></script>
    <script src="../Script/jquery-ui-1.8.11.custom.min.js" type="text/javascript"></script>
    <script src="../Script/Util.js" type="text/javascript"></script>
    <link href="../css/jquery.fileupload-ui.css" rel="stylesheet" type="text/css" />
    <script src="../Script/jquery.fileupload.js" type="text/javascript"></script>
    <script src="../Script/jquery.fileupload-ui.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript">

        $(function () {

            $('#divCargarImagenMat').load('CargarImagen.htm');
            $('#divCargarImagenEnf').load('CargarImagen.htm');
            $("#nrosolicitud").val($('#ctl00_MainContent_lblNroSolicitud').html());
            $("#nrosolicitudEnf").val($('#ctl00_MainContent_lblNroSolicitudE').html());
            $("#tieneImagen").val($('#ctl00_MainContent_hfNombreImagen').val());
            $("#tieneImagenEnf").val($('#ctl00_MainContent_hfNombreImagenEnf').val());

            $('.trCargarMat').hide();
            $('.trVerMat').hide();
            $('.trCargarEnf').hide();
            $('.trVerEnf').hide();

            ValidarImagen();
            ValidarImagenEnf();

           

        });

       

        function MostrarImagen(TipoSubsidio) {
            if (TipoSubsidio == 'M') {
                window.location = 'verImagenSubsidiosSFS.aspx?idSolicitud=' + $("#nrosolicitud").val();
            } else {
                window.location = 'verImagenSubsidiosSFS.aspx?idSolicitud=' + $("#nrosolicitudEnf").val();
            }
        }

        function ValidarImagen() {

            var num = $("#tieneImagen").val();
            if (num == "1") {
                $('.trCargarMat').hide();
                $('.trVerMat').show();
            }
            else {
                $('.trCargarMat').show();
                $('.trVerMat').hide();
            }

        }

        function ValidarImagenEnf() {

            var num = $("#tieneImagenEnf").val();
            if (num == "1") {
                $('.trCargarEnf').hide();
                $('.trVerEnf').show();
            }
            else {
                $('.trCargarEnf').show();
                $('.trVerEnf').hide();
            }

        }

       

    </script>
    <div class="header">
        Detalle Subsidios SFS</div>
    <asp:Label ID="lblMensaje" runat="server" CssClass="error"></asp:Label>
    <br />
    <table cellspacing="0" cellpadding="0" border="0">
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0" border="0" width="500">
                    <tr>
                        <td>
                            <div>
                                <asp:Panel ID="pnlDetMaternidad" runat="server" Visible="false">
                                    <fieldset style="width: 500; height: auto;">
                                        <legend>Detalle Subsidio Maternidad</legend>
                                        <div style="text-align: right; width: 480px">
                                       
                                            Número solicitud:
                                            <asp:Label CssClass="labelData" ID="lblNroSolicitud" runat="server" Font-Size="Small"></asp:Label>
                                            <input type="hidden" name="nrosolicitud" id="nrosolicitud" />
                                            <input type="hidden" name="tieneImagen" id="tieneImagen" />
                                            <asp:HiddenField ID="hfNombreImagen" runat="server" />
                                        </div>
                                        <div style="text-align: right; width: 480px">
                                            Tipo subsidio:
                                            <asp:Label CssClass="labelData" ID="lblTipoSubsidio" runat="server" Font-Size="Small"></asp:Label>
                                        </div>
                                        <table width="480">
                                            <tr>
                                                <td colspan="4">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="subHeader" colspan="4" align="left">
                                                    Datos del Solicitante
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    Nombre:
                                                </td>
                                                <td colspan="3" align="left">
                                                    <asp:Label CssClass="labelData" ID="lblNombreSolicitante" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    Cédula:
                                                </td>
                                                <td>
                                                    <asp:Label CssClass="labelData" ID="lblCedulaSolicitante" runat="server"></asp:Label>
                                                </td>
                                                <td style="text-align: right">
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right" nowrap="nowrap">
                                                    Salario cotizable:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblSalarioCotizable" runat="server" CssClass="labelData"></asp:Label>
                                                </td>
                                                <td align="right">
                                                    &nbsp; Estatus:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblStatusMaternidad" runat="server" CssClass="error"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    Tipo licencia:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblTipoLicencia" runat="server" CssClass="labelData"></asp:Label>
                                                </td>
                                                <td align="right">
                                                    Fecha licencia:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblFechaLicencia" runat="server" CssClass="labelData"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    Diagnóstico:
                                                </td>
                                                <td>
                                                    <asp:Label CssClass="labelData" ID="lblFechaDiagnostico" runat="server"></asp:Label>
                                                </td>
                                                <td align="right" nowrap="nowrap">
                                                    Estimación parto:
                                                </td>
                                                <td>
                                                    <asp:Label CssClass="labelData" ID="lblFechaEstimadaParto" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                </td>
                                                <td colspan="3">
                                                </td>
                                            </tr>
                                            <tr id="trCargarImagenMat" class="trCargarMat" runat="server">
                                                <td align="right">
                                                    Imagen:
                                                </td>
                                                <td colspan="3">
                                                    <div id="divCargarImagenMat" style="width: 200px">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr id="trVerImagenMat" class="trVerMat">
                                                <td align="right">
                                                    Imagen:
                                                </td>
                                                <td colspan="3">
                                                    <a  class="subHeader" href="javascript:MostrarImagen('M');"><asp:Label ID="Label1" runat="server" CssClass="subHeader" Font-Underline="true" Text="Ver Imagen"/></a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="subHeader" colspan="4" align="left">
                                                    Datos del Tutor
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    Nombre:
                                                </td>
                                                <td colspan="3" align="left">
                                                    <asp:Label CssClass="labelData" ID="lblnombreTutor" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    Cédula:
                                                </td>
                                                <td colspan="3">
                                                    <asp:Label CssClass="labelData" ID="lblCedulaTutor" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    NSS:
                                                </td>
                                                <td colspan="3">
                                                    <asp:Label CssClass="labelData" ID="lblNssTutor" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="subHeader" colspan="4">
                                                    Reimprimir Formulario
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="1" style="text-align: right">
                                                    PIN
                                                </td>
                                                <td class="subHeader" colspan="3">
                                                    <a href="../sys/ImpFormMaternidad.aspx">
                                                        <asp:Label ID="lblPinMat" runat="server" CssClass="subHeader" Font-Underline="true"></asp:Label>
                                                    </a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="1" style="text-align: right">
                                                    &nbsp;
                                                </td>
                                                <td class="subHeader" colspan="3">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="1" style="text-align: right">
                                                    &nbsp;
                                                </td>
                                                <td class="subHeader" colspan="3">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                        <br />
                                    </fieldset>
                                </asp:Panel>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0" border="0" width="600">
                    <tr>
                        <td>
                            <asp:Panel ID="pnlDetLactancia" runat="server" Visible="false">
                                <fieldset style="height: auto;">
                                    <legend>Detalle Subsidio Lactancia</legend>
                                    <div style="text-align: right; width: 480px">
                                        Número solicitud:
                                        <asp:Label CssClass="labelData" ID="lblNroSolicitudL" runat="server" Font-Size="Small"></asp:Label>
                                    </div>
                                    <div style="text-align: right; width: 480px">
                                        Tipo subsidio:
                                        <asp:Label CssClass="labelData" ID="lblTipoSubsidioL" runat="server" Font-Size="Small"></asp:Label>
                                    </div>
                                    <table width="480">
                                        <tr>
                                            <td colspan="2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="subHeader" colspan="2" align="left">
                                                Datos del Solicitante
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="width: 50px">
                                                Nombre:
                                            </td>
                                            <td align="left">
                                                <asp:Label CssClass="labelData" ID="lblNombreSolicitanteL" runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="width: 50px">
                                                Cédula:
                                            </td>
                                            <td>
                                                <asp:Label CssClass="labelData" ID="lblCedulaSolicitanteL" runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="width: 50px">
                                                Lactantes:
                                            </td>
                                            <td>
                                                <asp:Label ID="lblCantLactantes" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                &nbsp;
                                            </td>
                                        </tr>
                                    </table>
                                    <table cellpadding="0" cellspacing="0" width="580">
                                        <tr>
                                            <td class="subHeader" colspan="2" align="left">
                                                Datos Lactantes
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:GridView ID="gvlactantes" runat="server" AutoGenerateColumns="False" CellPadding="0"
                                                    Style="width: 580px;">
                                                    <Columns>
                                                        <asp:BoundField DataField="NOMBRE_LACTANTE" HeaderText="Nombre">
                                                            <HeaderStyle HorizontalAlign="left" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="left" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="ID_NSS_LACTANTE" HeaderText="NSS">
                                                            <HeaderStyle HorizontalAlign="left" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="NUI" HeaderText="NUI">
                                                            <HeaderStyle HorizontalAlign="left" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="SEXO" HeaderText="Sexo">
                                                            <HeaderStyle HorizontalAlign="left" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="FECHA_NACIMIENTO" HeaderText="Nacimiento" DataFormatString="{0:d}"
                                                            HtmlEncode="False">
                                                            <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="center" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="FECHA_REGISTRO_NC" HeaderText="Registro" DataFormatString="{0:d}"
                                                            HtmlEncode="False">
                                                            <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="ESTATUS_LACTANTE" HeaderText="Estatus">
                                                            <HeaderStyle HorizontalAlign="left" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="left" Wrap="False" />
                                                        </asp:BoundField>
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0" border="0" width="500">
                    <tr>
                        <td>
                            <asp:Panel ID="pnlDetEnfComun" runat="server" Visible="false">
                                <fieldset style="width: 500; height: auto;">
                                    <legend>Detalle Subsidio Enfermedad Común</legend>
                                    <div style="text-align: right; width: 480px">
                                        Número solicitud:
                                        <asp:Label CssClass="labelData" ID="lblNroSolicitudE" runat="server" Font-Size="Small"></asp:Label>
                                        <input type="hidden" name="nrosolicitudEnf" id="nrosolicitudEnf" />
                                        <input type="hidden" name="tieneImagenEnf" id="tieneImagenEnf" />
                                        <asp:HiddenField ID="hfNombreImagenEnf" runat="server" />
                                    </div>
                                    <div style="text-align: right; width: 480px">
                                        Tipo subsidio:
                                        <asp:Label CssClass="labelData" ID="lblTipoSubsidioE" runat="server" Font-Size="Small"></asp:Label>
                                    </div>
                                    <table width="480">
                                        <tr>
                                            <td colspan="4">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="subHeader" colspan="4" align="left">
                                                Datos del Solicitante
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">
                                                Nombre:
                                            </td>
                                            <td colspan="3" align="left">
                                                <asp:Label CssClass="labelData" ID="lblNombreSolicitanteE" runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">
                                                Cédula:
                                            </td>
                                            <td>
                                                <asp:Label CssClass="labelData" ID="lblCedulaSolicitanteE" runat="server"></asp:Label>
                                            </td>
                                            <td align="right">
                                                Fecha registro:
                                            </td>
                                            <td>
                                                <asp:Label ID="lblFechaRegistro" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" nowrap="nowrap">
                                                Tipo discapacidad:
                                            </td>
                                            <td>
                                                <asp:Label ID="lblTipoDiscapacidad" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                            <td align="right">
                                                Estatus:
                                            </td>
                                            <td>
                                                <asp:Label ID="lblStatusE" runat="server" CssClass="error"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">
                                                PIN:
                                            </td>
                                            <td>
                                                <a  href="../sys/ImpEnfermedadComun.aspx">
                                                    <asp:Label ID="lblPin" runat="server" CssClass="subHeader" Font-Underline="true"></asp:Label>
                                            </td>
                                            <td align="right">
                                                Código CIE10:
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDescCodigoCIE" runat="server" TextMode="MultiLine" Enabled="false"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">
                                            </td>
                                            <td colspan="3">
                                            </td>
                                        </tr>
                                        <tr id="trCargarImagenEnf" class="trCargarEnf" runat="server">
                                            <td align="right">
                                                Imagen:
                                            </td>
                                            <td colspan="3">
                                                <div id="divCargarImagenEnf">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="trVerImagenEnf" class="trVerEnf">
                                            <td align="right">
                                                Imagen:
                                            </td>
                                            <td colspan="3">
                                                <a  href="javascript:MostrarImagen('E');"><asp:Label ID="Label2" runat="server" CssClass="subHeader" Font-Underline="true" Text="Ver Imagen"/></a>
                                            </td>
                                        </tr>
                                    </table>
                                    <table id="tblInfo" runat="server" width="480">
                                        <tr>
                                            <td align="right" style="width: 84px">
                                                &nbsp;
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td align="right">
                                                &nbsp;
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="width: 84px">
                                                Ambulatorio:
                                            </td>
                                            <td>
                                                <asp:LinkButton ID="lnkBtnASi" runat="server" Visible="false" Enabled="false">
                                                    <img src='../images/ok.gif' alt=''/></asp:LinkButton>
                                                <asp:LinkButton ID="lnkBtnANo" runat="server" Visible="false" Enabled="false">
                                                    <img src='../images/error.gif' alt=''/></asp:LinkButton>
                                            </td>
                                            <td align="right">
                                                Fecha inicio:
                                            </td>
                                            <td>
                                                <asp:Label ID="lblFechaIniAmbulatorio" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="width: 84px">
                                                &nbsp;
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td align="right" nowrap="nowrap">
                                                Dias calendario:
                                            </td>
                                            <td>
                                                <asp:Label CssClass="labelData" ID="lblDiasLicAmbulatoria" runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="width: 84px">
                                                &nbsp;
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td align="right">
                                                &nbsp;
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="width: 84px">
                                                Hospitalario:
                                            </td>
                                            <td>
                                                <asp:LinkButton ID="lnkBtnHSi" runat="server" Visible="false" Enabled="false">
                                                    <img src='../images/ok.gif' alt=''/></asp:LinkButton>
                                                <asp:LinkButton ID="lnkBtnHNo" runat="server" Visible="false" Enabled="false">
                                                    <img src='../images/error.gif' alt=''/></asp:LinkButton>
                                            </td>
                                            <td align="right">
                                                Fecha inicio:
                                            </td>
                                            <td>
                                                <asp:Label ID="lblFechaIniHospitalizacion" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="width: 84px">
                                                &nbsp;
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td align="right" nowrap="nowrap">
                                                Dias calendario:
                                            </td>
                                            <td>
                                                <asp:Label CssClass="labelData" ID="lblDiasLicHospitalizacion" runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 84px">
                                            </td>
                                            <td>
                                            </td>
                                            <td>
                                            </td>
                                            <td>
                                            </td>
                                        </tr>
                                        <tr id="trTituloReintegro" runat="server" visible="false">
                                            <td class="subHeader" align="left" colspan="4">
                                                Datos Reintegro
                                            </td>
                                        </tr>
                                        <tr id="trReintegro" runat="server" visible="false">
                                            <td align="right" style="width: 84px">
                                                Fecha Reintegro:
                                            </td>
                                            <td align="left" colspan="3">
                                                <asp:Label CssClass="labelData" ID="lblFechaReintegro" runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0" border="0">
                    <tr>
                        <td>
                            <div id="divCuotas" runat="server">
                                <asp:Panel ID="pnlCuotasSubsidios" runat="server">
                                    <br />
                                    <div class="subHeader">
                                        Detalle Cuotas</div>
                                    <asp:Label ID="lblmensajeCuotas" runat="server" CssClass="error"></asp:Label>
                                    <table cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td>
                                                <asp:GridView ID="gvCuotasSubsidios" runat="server" AutoGenerateColumns="False" Style="width: 620px;">
                                                    <Columns>
                                                        <asp:BoundField DataField="NRO_PAGO" HeaderText="Pago Nro.">
                                                            <HeaderStyle HorizontalAlign="center" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="PERIODO" HeaderText="Período">
                                                            <HeaderStyle HorizontalAlign="center" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="Tipo_Cuenta" HeaderText="Tipo Cuenta">
                                                            <HeaderStyle HorizontalAlign="center" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="center" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="cuenta_banco" HeaderText="Cuenta Nro.">
                                                            <HeaderStyle HorizontalAlign="left" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="left" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="entidad_recaudadora_des" HeaderText="Entidad Bancaria">
                                                            <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="left" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="NRO_REFERENCIA" HeaderText="Referencia">
                                                            <HeaderStyle HorizontalAlign="center" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="center" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="MONTO_SUBSIDIO" HeaderText="Monto" DataFormatString="{0:c}">
                                                            <HeaderStyle HorizontalAlign="center" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="right" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:TemplateField HeaderText="Estatus">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblEstatusPago" runat="server" Text='<%# Eval("id_status_pago") %>'
                                                                    Visible="False"></asp:Label>
                                                                <asp:LinkButton ID="lnkBtnSi" runat="server" Visible="false" Enabled="false">
                                                        <img src='../images/ok.gif' alt=''/></asp:LinkButton>
                                                                <asp:LinkButton ID="lnkBtnNo" runat="server" Visible="false" Enabled="false">
                                                        <img src='../images/error.gif' alt=''/></asp:LinkButton>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Center" />
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="STATUS_PAGO" HeaderText="Descripción">
                                                            <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="left" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="FECHA_PAGO" HeaderText="Fecha Pago" DataFormatString="{0:d}"
                                                            HtmlEncode="False">
                                                            <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundField>
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </div>
                            <div id="divDatosPreliminares" runat="server" visible="false">
                                <asp:Panel ID="pnlDatosPreliminares" runat="server">
                                    <br />
                                    <div class="subHeader">
                                        Detalle Preliminar Cuotas</div>
                                    <asp:Label ID="lblDatosPreliminares" runat="server" CssClass="error"></asp:Label>
                                    <table cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td>
                                                <asp:GridView ID="gvDatosPreliminares" runat="server" AutoGenerateColumns="False">
                                                    <Columns>
                                                        <asp:BoundField DataField="Cuota" HeaderText="Cuota">
                                                            <HeaderStyle HorizontalAlign="center" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="PERIODO" HeaderText="Período">
                                                            <HeaderStyle HorizontalAlign="center" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="MONTO" HeaderText="Monto" DataFormatString="{0:c}">
                                                            <HeaderStyle HorizontalAlign="center" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="right" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="STATUS" HeaderText="Estatus">
                                                            <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="left" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="Tipo_calculo" HeaderText="Tipo Cálculo">
                                                            <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundField>
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="text-align: left">
                <br />
                <asp:LinkButton ID="lbRegresar" runat="server"><span style="font-size: small">Regresar...</span></asp:LinkButton>
                <br />
            </td>
        </tr>
    </table>
</asp:Content>
