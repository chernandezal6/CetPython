<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="Solicitudes.aspx.vb" Inherits="Solicitudes_Solicitudes" Title="Solicitudes - Tesoreria de la Seguridad Social" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <br />
    <div align="center" class="header">Solicitud de servicios</div>
    <br />
    <table align="center" class="td-content" id="table4" cellspacing="0" cellpadding="0" width="480" border="0">
        <tr>
            <td>
                <table id="Table1" width="100%" border="0">
                    <tr>
                        <td class="td-content">
                            <div class="header2" align="center">
                                <asp:Label ID="lblMensajeBienvenida" runat="server" Font-Bold="True">Buenas días/tardes __________ le asiste, en que puedo servirle? </asp:Label>
                            </div>
                            <br />
                            <br>
                            <table id="Table2" width="100%">
                                <tr>
                                    <td width="40%" align="right">Tipo de Solicitud:&nbsp;</td>
                                    <td style="width: 275px">
                                        <asp:DropDownList CssClass="dropDowns" ID="drpSolicitudes" runat="server" AutoPostBack="True"></asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <asp:Panel ID="pnlCertificaciones" Visible="False" runat="server" Width="100%" Wrap="False">
                                <table class="td-note" id="Table3" cellspacing="2" cellpadding="0" width="100%" border="0">
                                    <tr id="trCertificaciones">
                                        <td width="40%" align="right">Tipo Certificaciones:&nbsp;</td>
                                        <td>
                                            <asp:DropDownList CssClass="dropDowns" ID="drpTipoCertificacion" runat="server"></asp:DropDownList>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <asp:Panel ID="pnlOficinas" Visible="False" runat="server" Width="100%" Wrap="False">
                                <table class="td-note" id="Table5" cellspacing="2" cellpadding="0" width="100%" border="0">
                                    <tr id="trOficinas">
                                        <td width="40%" align="right">Oficina de entrega:&nbsp;</td>
                                        <td width="60%">
                                            <asp:DropDownList CssClass="dropDowns" ID="drpOficinas" runat="server"></asp:DropDownList>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <asp:Panel ID="pnlRNC" Visible="True" runat="server" Width="100%" EnableViewState="False" Wrap="False">
                                <table class="td-note" id="Table6" cellspacing="2" cellpadding="0" width="100%" border="0">
                                    <tr id="trRnc">
                                        <td width="40%" align="right">Por favor permítame el RNC de su &nbsp;empresa o negocio:&nbsp;</td>
                                        <td>
                                            <asp:TextBox ID="txtRnc" runat="server" Width="88px" MaxLength="11"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*" ControlToValidate="txtRnc"
                                                Display="Dynamic"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="*" ControlToValidate="txtRnc"
                                                Display="Dynamic" ValidationExpression="^(\d{9}|\d{11})$">RNC o Cédula Inválida.</asp:RegularExpressionValidator>
                                            <asp:Button ID="btAyudaRNC" runat="server" Text="?"></asp:Button></td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <asp:Panel ID="pnlCedula" Visible="True" runat="server" Width="100%" Wrap="False">
                                <table class="td-note" id="Table7" cellspacing="2" cellpadding="0" width="100%" border="0">
                                    <tr id="trCedula">
                                        <td width="40%" align="right">
                                            <asp:Label ID="lblCedula" runat="server" EnableViewState="False" Width="100%">Cual es la cédula del representante:&nbsp;</asp:Label>
                                            <asp:Label ID="lblNombreCedula" runat="server"></asp:Label></td>
                                        <td width="60%">
                                            <asp:TextBox ID="txtCedula" runat="server" Width="88px" MaxLength="25"></asp:TextBox>
                                            <%--<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ErrorMessage="*" ControlToValidate="txtCedula"
														Display="Dynamic"></asp:RequiredFieldValidator>
													<asp:RegularExpressionValidator id="RegularExpressionValidator2" runat="server" ErrorMessage="*" ControlToValidate="txtCedula"
														Display="Dynamic" ValidationExpression="^(\d{11})$">Cédula Inválida.</asp:RegularExpressionValidator>
													<asp:Button id="btAyudaCedula" runat="server" Text="?"></asp:Button>--%>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <asp:Panel ID="pnlProvincia" runat="server" Visible="False" Width="100%" Wrap="False">
                                <table class="td-note" id="Table8" cellspacing="2" cellpadding="0" width="100%" border="0">
                                    <tr>
                                        <td width="40%" align="right">Provincia donde se encuentra:&nbsp;</td>
                                        <td width="60%">
                                            <asp:DropDownList CssClass="dropDowns" ID="drpProvincia" runat="server"></asp:DropDownList>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <asp:Panel ID="pnlSalario" Visible="False" runat="server" Width="100%" Wrap="False">
                                <table class="td-note" id="Table9" cellspacing="2" cellpadding="0" width="100%" border="0">
                                    <tr>
                                        <td width="40%" align="right">Por favor permítame su salario mensual:&nbsp;</td>
                                        <td width="60%">
                                            <asp:TextBox ID="txtSalario" runat="server"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*" ControlToValidate="txtSalario"
                                                Display="Dynamic"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ErrorMessage="Salario inválido"
                                                ControlToValidate="txtSalario" Display="Dynamic" ValidationExpression="^(\d|,)*\.?\d*$"></asp:RegularExpressionValidator>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <table class="td-note" id="Table10" cellspacing="2" cellpadding="0" width="100%" border="0">
                                <tr>
                                    <td style="HEIGHT: 10px" colspan="2" height="10"></td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="2">
                                        <asp:Button ID="btnAceptar" runat="server" Text="Aceptar"></asp:Button>&nbsp;<input type="button" onclick="javascript: window.location.href = 'solicitudIntro.aspx'" value="Cancelar" class="Button"></td>
                                </tr>
                                <tr>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td align="center">
                                        <div class="header2">
                                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="ConsultaSolicitud.aspx">Consulta por ID Solicitud</asp:HyperLink>&nbsp;|
									            <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="ConsultaByRNC.aspx">Consulta por RNC</asp:HyperLink>
                                        </div>
                                    </td>
                                </tr>

                            </table>
                            <asp:Label CssClass="label-Resaltado" ID="lblMsg" runat="server" EnableViewState="False"></asp:Label>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Content>

