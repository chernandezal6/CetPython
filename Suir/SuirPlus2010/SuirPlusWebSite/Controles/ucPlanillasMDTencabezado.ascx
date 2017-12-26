<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucPlanillasMDTencabezado.ascx.vb"
    Inherits="Controles_ucPlanillasMDTencabezado" %>
<asp:Panel ID="pnlPlanilla" runat="server" Visible="False">
    <table class="td-content" width="580pt">
        <tr>
            <td colspan="4" style="text-align: center">
                <asp:Label ID="Label1" runat="server" CssClass="subHeader" Text="Formulario del Ministerio de Trabajo"></asp:Label><br />
                <br />
            </td>
        </tr>
        <tr>
            <td align="right">
                Referencia
            </td>
            <td>
                <asp:Label ID="lblReferencia" runat="server" CssClass="labelData"></asp:Label>
            </td>
            <td align="right">
                Estatus
            </td>
            <td>
                <asp:Label ID="lblEst" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">
                RNC/Cédula
            </td>
            <td>
                <asp:Label ID="lblCedulaRNC" runat="server" CssClass="labelData"></asp:Label>
            </td>
            <td align="right">
                Período
            </td>
            <td>
                <asp:Label ID="lblPeriodo" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">
                Razón Social
            </td>
            <td colspan="3">
                <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">
                Dirección
            </td>
            <td colspan="3">
                <asp:Label ID="lblDireccion" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">
                Total Trabajadores
            </td>
            <td>
                <asp:Label ID="lblTotalAsalariado" runat="server" CssClass="labelData"></asp:Label>
            </td>
            <td align="right">
                Total Establecimientos
            </td>
            <td>
                <asp:Label ID="lblToralLocalidades" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="lblItemFact" runat="server"></asp:Label>
            </td>
            <td>
                <asp:Label ID="lblTotalBonificacion" runat="server" CssClass="labelData"></asp:Label>
            </td>
            <td align="right">
                Tipo Formulario
            </td>
            <td>
                <asp:Label ID="lblIdPlanilla" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">
                Emisión
            </td>
            <td>
                <asp:Label ID="lblFechaEmision" runat="server" CssClass="labelData"></asp:Label>
            </td>
            <td align="right">
                Límite de Pago
            </td>
            <td>
                <asp:Label ID="lblFechaLimitePago" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">
                Teléfono
            </td>
            <td>
                <asp:Label ID="lblTelefono" runat="server" CssClass="labelData"></asp:Label>
            </td>
            <td align="right">
                Tipo Liquidación
            </td>
            <td>
                <asp:Label ID="lblTipoLiq" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td colspan="4" style="height: 6px">
            </td>
        </tr>
        <tr>
            <td colspan="4" align="center" style="height: 16px">
                <asp:HyperLink ID="hlnkDetalle" runat="server"><img src="../images/detalle.gif" alt="" />&nbsp;Detalle Empleados</asp:HyperLink>&nbsp;&nbsp;
                <asp:HyperLink ID="hlnkImprimir" runat="server" Target="_blank"><img src="../images/printv.gif" alt="" />&nbsp;Imprimir</asp:HyperLink>
            </td>
        </tr>
    </table>
    <asp:Panel ID="pnlEstatus" runat="server" Width="550">
        <asp:Label ID="lblEstatus" runat="server" CssClass="label-Resaltado"></asp:Label>
    </asp:Panel>
    <br />
    <table id="tblRenglones" class="tableLineasFinas" style="border-color: #4882ca" cellspacing="0"
        cellpadding="0" border="1" width="550" runat="server">
        <tr>
            <td colspan="2" style="height: 12px" class="listHeader">
                &nbsp;Totales
            </td>
        </tr>
        <tr class="listItem">
            <td style="width: 65%; font-weight: bold;">
                Total a pagar
            </td>
            <td align="right">
                &nbsp;
                <asp:Label ID="lblTotalGral" runat="server" Font-Bold="true"></asp:Label>
            </td>
        </tr>
    </table>
    <asp:Panel ID="pnlComentario" runat="server">
        <table style="width: 39%;">
            <tr>
                <td colspan="2" style="height: 12px;" class="listHeader">
                    Comentario:
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Label ID="lblComentario" runat="server"></asp:Label>
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Panel>
