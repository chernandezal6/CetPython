<%@ Page Title="Cuentas x Cobrar Sector Privado" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CxC_Sector_Privado.aspx.vb" Inherits="Reportes_CxC_Sector_Privado" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <div id="divTitulo" class="header">
        <asp:Label ID="lblTitulo" runat="server" Text="Cuentas x Cobrar Sector Privado"> 
        </asp:Label>
    </div>

    <br />

    <fieldset style="width: 250px">
        <table>
            <tr>
                <td class="labelData" colspan="4">
                    <asp:Label ID="lblEncabezadoParam" runat="server" Text="Rango de Cantidad de Facturas Vencidas"></asp:Label>
                    <br />
                    <br />
                </td>
            </tr>

            <tr>
                <td valign="middle">Desde:</td>
                <td valign="middle">
                    <asp:TextBox ID="txtDesde" Text="1" runat="server" Width="51px">1</asp:TextBox>
                    &nbsp;</td>

                <td valign="middle">Hasta:</td>
                <td valign="middle">
                    <asp:TextBox ID="txtHasta" Text="3" runat="server" Width="51px">3</asp:TextBox>
                    &nbsp;</td>
            </tr>

            <tr>
                <td align="center" colspan="4" rowspan="1">
                    <br />
                    <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" CssClass="Button" />
                    &nbsp;<asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="Button"
                        CausesValidation="False" />
                </td>
            </tr>
        </table>
    </fieldset>

    <asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="False"></asp:Label>
    <br />
    <asp:Panel ID="pnlCxCSectroPrivado" runat="server" Visible="false">
        <rsweb:ReportViewer ID="rvCxCSectroPrivado" runat="server" Font-Names="Verdana"
            Font-Size="8pt" Height="600px" Width="100%" ZoomPercent="90" PageCountMode="Estimate">
            <LocalReport ReportPath="Reportes\CxC_Sector_Privado.rdlc">
            </LocalReport>
        </rsweb:ReportViewer>

    </asp:Panel>

</asp:Content>

