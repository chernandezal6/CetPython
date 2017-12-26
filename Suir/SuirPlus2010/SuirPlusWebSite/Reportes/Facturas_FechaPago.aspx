<%@ Page Title="Facturas Pagadas" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="Facturas_FechaPago.aspx.vb" Inherits="Reportes_Facturas_FechaPago" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script language="javascript" type="text/javascript">

        $(function () {

            // Datepicker
            $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));

            $("#ctl00_MainContent_txtFechaDesde").datepicker($.datepicker.regional['es']);
            $("#ctl00_MainContent_txtFechaHasta").datepicker($.datepicker.regional['es']);

        });
    </script>

    <div id="divTitulo" class="header">
        <asp:Label ID="lblTitulo" runat="server" Text="Facturas Pagadas"> 
        </asp:Label>
    </div>
    <br />
    <fieldset style="width: 350px">
        <table>
            <tr>
                <td class="labelData" colspan="4" align="center">
                    <asp:Label ID="lblEncabezadoParam" runat="server" Text="Rango Fechas Válidas"></asp:Label>
                    <br />
                    <br />
                </td>
            </tr>
            <tr>
                <td valign="middle">Desde:</td>
                <td valign="middle">
                    <asp:TextBox ID="txtFechaDesde" runat="server" Width="100px"></asp:TextBox>
                    &nbsp;</td>

                <td valign="middle">Hasta:</td>
                <td valign="middle">
                    <asp:TextBox ID="txtFechaHasta" runat="server" Width="100px"></asp:TextBox>
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
    <br />
    <asp:Panel ID="pnlFacturasPagadas" runat="server" Visible="false">
        <rsweb:ReportViewer ID="rvFacturasPagadas" runat="server" Font-Names="Verdana"
            Font-Size="8pt" Height="600px" Width="100%" ZoomPercent="100" PageCountMode="Estimate">
            <LocalReport ReportPath="Reportes\Facturas_FechaPago.rdlc">
            </LocalReport>
        </rsweb:ReportViewer>

    </asp:Panel>
</asp:Content>

