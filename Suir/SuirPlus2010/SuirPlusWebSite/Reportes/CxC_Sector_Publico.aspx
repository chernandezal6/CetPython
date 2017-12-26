<%@ Page Title="Cuentas x Cobrar Sector Público" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CxC_Sector_Publico.aspx.vb" Inherits="Reportes_CxC_Sector_Publico" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <div id="divTitulo" class="header">
        <asp:Label ID="lblTitulo" runat="server" Text="Cuentas x Cobrar Sector Público"> 
        </asp:Label>
    </div>

    <fieldset style="width: 550px">
        <table>
            <tr>
                <td colspan="6"></td>
            </tr>
            <tr>
                <td valign="middle" nowrap="nowrap">Tipo Empresa:</td>
                <td valign="middle">
                    <asp:DropDownList ID="dlTipoEmpresa" runat="server" CssClass="dropDowns">
                        <asp:ListItem Selected="True" Value="TODOS">Todos</asp:ListItem>
                        <asp:ListItem Value="PC">Pública Centralizada</asp:ListItem>
                        <asp:ListItem Value="PU">Pública</asp:ListItem>
                    </asp:DropDownList>

                </td>

                <td valign="middle" nowrap="nowrap">Tipo Referencia:</td>

                <td valign="middle">
                    <asp:DropDownList ID="dlTipoReferencia" runat="server" CssClass="dropDowns">
                    </asp:DropDownList>

                </td>

                <td valign="middle">Estatus:</td>

                <td valign="middle">
                    <asp:DropDownList ID="dlEstatus" runat="server" CssClass="dropDowns">
                        <asp:ListItem Selected="True" Value="TODOS">Todos</asp:ListItem>
                        <asp:ListItem Value="VI">Vigente</asp:ListItem>
                        <asp:ListItem Value="VE">Vencida</asp:ListItem>
                    </asp:DropDownList>

                </td>
            </tr>

            <tr>
                <td align="right" colspan="6" rowspan="1">
                    <br />
                    <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" CssClass="Button" />
                    &nbsp;<asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="Button"
                        CausesValidation="False" />
                    &nbsp;</td>
            </tr>
        </table>
    </fieldset>

    <br />
    <asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="False"></asp:Label>
    <br />
    <asp:Panel ID="pnlReporte" runat="server" Visible="false">
        <rsweb:ReportViewer ID="rvCxCSectorPublico" runat="server" Font-Names="Verdana"
            Font-Size="8pt" Height="600px" Width="100%" ZoomPercent="90" PageCountMode="Estimate">
            <LocalReport ReportPath="Reportes\CxC_Sector_Publico.rdlc">
            </LocalReport>
        </rsweb:ReportViewer>

    </asp:Panel>


</asp:Content>

