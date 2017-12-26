<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consCambioARS.aspx.vb" Inherits="Consultas_conCambioARS" Title="Consulta ARS" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script type="text/javascript">

        if (top != self) top.location.replace(location.href);

    </script>
    <img alt="Tesoreria de la Seguridad Social" src="../images/logoTSShorizontal.gif" />
    <div class="header">
        Consulta de Histórico Pagos ARS<br />
        <br />
    </div>

    <asp:UpdatePanel ID="udpBuscarDatosAFS" runat="server">
        <ContentTemplate>
            <table>
                <tr>
                    <td align="left">
                        <table cellpadding="1" cellspacing="0" class="td-content" align="left"
                            width="400px">
                            <tr>
                                <td colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="right" width="292px" style="margin-left: 40px" height="0px"
                                    valign="bottom">Cédula&nbsp;<asp:TextBox ID="txtNSSoCedula" runat="server" MaxLength="11"></asp:TextBox>
                                    &nbsp;&nbsp;</td>
                                <td width="158px" align="left" height="0px" valign="bottom">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2" height="0px"
                                    style="margin-left: 40px; width: 692px;" valign="bottom" width="292px">
                                    <asp:Label ID="lblMensaje" runat="server" CssClass="error"></asp:Label>
                                    <asp:RequiredFieldValidator ID="CedulaRequeridaValidator" runat="server"
                                        ControlToValidate="txtNSSoCedula" Display="Dynamic"
                                        ErrorMessage="RequiredFieldValidator" Font-Bold="True">El NSS o Cédula es 
                                    requerido</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="CedulaRegex" runat="server"
                                        ControlToValidate="txtNSSoCedula" Display="Dynamic" EnableViewState="False"
                                        ErrorMessage="RegularExpressionValidator" Font-Bold="True"
                                        SetFocusOnError="True" ValidationExpression="^[0-9]+$">NSS o Cédula inválida</asp:RegularExpressionValidator>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center"></td>
                            </tr>
                            <tr>
                                <td align="center" width="450px" colspan="2">&nbsp;<asp:Button ID="btnBuscar" runat="server" Text="Buscar" />
                                    <asp:Button ID="btnLimpiar" runat="server" CausesValidation="False"
                                        OnClick="btnLimpiar_Click" Text="Limpiar" />
                                </td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">

                                    <br />

                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div runat="server" id="divArs" visible="false">
                            <br />
                            <table style="width: 100%;">
                                <tr class="label-Blue">
                                    <td style="width: 340px" height="0px">
                                        <asp:Panel ID="pnlInfo" runat="server" Visible="False" Width="450px">
                                            <table id="TABLE2" runat="server" border="0" cellpadding="0" cellspacing="0"
                                                class="td-content" visible="true">
                                                <tr>
                                                    <td id="TD1" runat="server" class="subHeader" colspan="2">Datos del Afiliado<br />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="labelData" style="width: 186px">Nombre:</td>
                                                    <td style="width: 416px">
                                                        <asp:Label ID="lblNombre" runat="server" CssClass="labelData" Font-Bold="True"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="labelData" style="width: 186px">ARS:</td>
                                                    <td style="width: 416px">
                                                        <asp:Label ID="lblARS0" runat="server" CssClass="labelData" Font-Bold="True"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="labelData" style="width: 186px; height: 16px">Status:</td>
                                                    <td style="width: 416px; height: 16px;">
                                                        <asp:Label ID="lblStatus" runat="server" CssClass="labelData" Font-Bold="True"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="labelData" style="width: 186px; height: 16px">Tipo Afiliación:</td>
                                                    <td style="width: 416px; height: 16px">
                                                        <asp:Label ID="lblTipoAfiliacion" runat="server" CssClass="labelData"
                                                            Font-Bold="True"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="labelData" style="width: 186px; height: 16px">Fecha Afiliación:</td>
                                                    <td style="width: 416px; height: 16px">
                                                        <asp:Label ID="lblFechaAfiliacion" runat="server" CssClass="labelData"
                                                            Font-Bold="True"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                        <br />
                                    </td>
                                </tr>
                            </table>
                            <asp:Panel ID="divTitular" runat="server" Visible="False" Width="450px">
                                <table id="TABLE3" runat="server" border="0" cellpadding="0" cellspacing="0"
                                    class="td-content" visible="true">
                                    <tr>
                                        <td id="TD2" runat="server" class="subHeader" colspan="2">Datos del Titular</td>
                                    </tr>
                                    <tr>
                                        <td class="labelData" style="width: 186px">Nombre:</td>
                                        <td style="width: 416px" height="0px">
                                            <asp:Label ID="lblNombreTitular" runat="server" CssClass="labelData"
                                                Font-Bold="True"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="labelData" style="width: 186px">ARS:</td>
                                        <td style="width: 416px">
                                            <asp:Label ID="lblARSTitular" runat="server" CssClass="labelData"
                                                Font-Bold="True"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="labelData" style="width: 186px; height: 16px">Status:</td>
                                        <td style="width: 416px; height: 16px;">
                                            <asp:Label ID="lblStatusTitular" runat="server" CssClass="labelData"
                                                Font-Bold="True"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="labelData" style="width: 186px; height: 16px">Tipo Afiliación:</td>
                                        <td style="width: 416px; height: 16px">
                                            <asp:Label ID="lblTipoAfiliacionTitular" runat="server" CssClass="labelData"
                                                Font-Bold="True"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="labelData" style="width: 186px; height: 16px">Fecha Afiliación:</td>
                                        <td style="width: 416px; height: 16px">
                                            <asp:Label ID="lblFechaAfiliacionTitular" runat="server" CssClass="labelData"
                                                Font-Bold="True"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <br />
                            <table style="width: 100%;">
                                <tr>
                                    <td class="subHeader">Número de pagos:
                                        <asp:Label ID="lblPagos" runat="server"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <fieldset id="gridARS" style="width: 376px" runat="server" visible="false">
                                <legend>Histórico de Pagos ARS Ultimo Año</legend>
                                <br />
                                <asp:GridView ID="gvARS" runat="server" AutoGenerateColumns="False"
                                    EnableViewState="False" Width="348px">
                                    <Columns>
                                        <asp:BoundField DataField="periodo" HeaderText="Período">
                                            <ItemStyle HorizontalAlign="Center" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ars_des" HeaderText="ARS" />
                                    </Columns>
                                </asp:GridView>
                                <br />
                            </fieldset>
                        </div>
                        <br />
                        <br />
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>

    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator" style="left: 17px; bottom: 0%">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

</asp:Content>

