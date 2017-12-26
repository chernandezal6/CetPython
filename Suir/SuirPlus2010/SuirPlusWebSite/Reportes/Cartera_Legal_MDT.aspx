<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="Cartera_Legal_MDT.aspx.vb" Inherits="Reportes_Cartera_Legal_MDT" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <div id="divTitulo" class="header">
        <asp:Label ID="lblTitulo" runat="server" Text="Cartera de Cobros Legal"> 
        </asp:Label>
    </div>
    <br />
    <table width="500px">
        <tr>
            <td>
                <fieldset>
                    <legend>Generar Reporte</legend>
                    <table width="350px">
                        <tr>
                            <td valign="middle" align="right" style="width: 93px">Período:
                            </td>
                            <td valign="middle">
                                <asp:DropDownList ID="ddlPeriodos" runat="server" CssClass="dropDowns">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td valign="middle" align="right" style="width: 93px">Provincia:</td>
                            <td valign="middle">
                                <asp:DropDownList ID="ddlProvincia" runat="server" CssClass="dropDowns">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td valign="middle" align="right" style="width: 93px">Tipo Empresa:</td>
                            <td valign="middle">
                                <asp:DropDownList ID="ddlTipoEmpresa" runat="server" CssClass="dropDowns">
                                    <asp:ListItem Selected="True" Value="-1">Todos</asp:ListItem>
                                    <asp:ListItem Value="PR">Privada</asp:ListItem>
                                    <asp:ListItem Value="PU">P&#250;blica</asp:ListItem>
                                    <asp:ListItem Value="PC">P&#250;blica Centralizada</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td valign="middle" align="right" colspan="1" style="width: 93px">Tipo Reporte:</td>
                            <td valign="middle" align="left">
                                <asp:RadioButtonList ID="rblTipoReporte" runat="server">
                                    <asp:ListItem Value="N">En Cartera</asp:ListItem>
                                    <asp:ListItem Value="S">Enviados al MDT</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2" rowspan="1">
                                <br />
                                <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" CssClass="Button" />
                                &nbsp;<asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="Button"
                                    CausesValidation="False" />
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </td>
            <td>
                <fieldset style="width: auto;">
                    <legend>Datos Estadísticos Período Vigente</legend>
                    <table width="398px">
                        <tr>
                            <td valign="middle">Total Empresas en Cartera:
                            </td>
                            <td valign="middle">
                                <asp:Label CssClass="labelData" ID="lblTotalEmpCartera" runat="server"
                                    Font-Size="Small"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td valign="middle" nowrap="nowrap">Monto Total en RD$ de las empresas en cartera:
                            </td>
                            <td valign="middle">
                                <asp:Label CssClass="labelData" ID="lblMontoCartera" runat="server" Font-Size="Small"></asp:Label>
                            </td>
                        </tr>

                        <tr>
                            <td valign="middle" nowrap="nowrap">Total Empresa Enviadas al MDT:
                            </td>
                            <td valign="middle">
                                <asp:Label CssClass="labelData" ID="lblEmpresasEnviadasMDT" runat="server" Font-Size="Small"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td valign="middle">Monto Total en RD$ de las empresas enviadas al MDT:
                            </td>
                            <td valign="middle">
                                <asp:Label CssClass="labelData" ID="lblMontoEmpresasEnviadasMDT" runat="server" Font-Size="Small"></asp:Label>
                            </td>
                        </tr>

                        <tr>
                            <td valign="middle" colspan="2">
                                <br />
                                <asp:Label CssClass="labelData" ID="lblTituloGV" runat="server"
                                    Font-Size="Smaller">Total Empresas Contactadas Por Resultados</asp:Label>
                                <asp:GridView ID="gvGestionCobros" runat="server" AutoGenerateColumns="False">
                                    <Columns>
                                        <asp:BoundField DataField="Resultado" HeaderText="Resultado">
                                            <ItemStyle HorizontalAlign="left" Wrap="False" />
                                            <FooterStyle Wrap="False" />
                                            <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="total_Empresas" HeaderText="Total Empresas"
                                            DataFormatString="{0:N0}" HtmlEncode="False">
                                            <ItemStyle HorizontalAlign="right" Wrap="False" />
                                            <FooterStyle Wrap="False" />
                                            <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                                <asp:Label ID="lblMsgGV" runat="server" CssClass="error" Visible="false"></asp:Label>
                            </td>
                        </tr>

                    </table>
                </fieldset>
            </td>
        </tr>
    </table>

    <br />

    <asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="False"></asp:Label>
    <br />

    <asp:Panel ID="pnlCarteraLegalMDT" runat="server" Visible="false">
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Font-Names="Verdana"
            Font-Size="8pt" Height="600px" Width="100%" ZoomPercent="90" PageCountMode="Estimate">
            <LocalReport ReportPath="Reportes\Cartera_Legal_MDT.rdlc"></LocalReport>

        </rsweb:ReportViewer>

    </asp:Panel>

</asp:Content>

