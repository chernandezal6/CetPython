<%@ Page AutoEventWireup="false" CodeFile="consFacturaRNCDetalle.aspx.vb" Inherits="Consultas_consFacturaRNCDetalle"
    Language="VB" MasterPageFile="~/SuirPlus.master" Title="Resumen de Notificación" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="header">
        Resumen de Notificación
    </div>
    <br />
    <table id="Table3" border="0" cellpadding="1" cellspacing="1" class="td-content"
        width="550">
        <tr>
            <td style="width: 116px">
                RNC/Cédula</td>
            <td>
                <asp:Label ID="lblRNC" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td style="width: 116px">
                Razón Social</td>
            <td>
                <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td style="width: 116px">
                Nombre Comercial</td>
            <td>
                <asp:Label ID="lblNombreComercial" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
    </table>
    <br>
    <table id="Table4" border="0" cellpadding="0" cellspacing="0" class="listheadermultiline"
        width="550">
        <tr>
            <td>
                &nbsp;Detalle Resumido de la Notificación</td>
        </tr>
    </table>
    <table id="tblRenglones" runat="server" border="0"  cellpadding="0"
        cellspacing="1" class="tableTotales" width="550">
        <tr>
            <td class="TDTotales" style="width: 25%">
                &nbsp;Referencia</td>
            <td align="left" class="TDTotales">
                <asp:Label ID="lblReferencia" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td>
                &nbsp;Estatus</td>
            <td align="left">
                <asp:Label ID="lblEstatus" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td class="TDTotales">
                &nbsp;Nómina</td>
            <td align="left" class="TDTotales">
                <asp:Label ID="lblNomina" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td>
                &nbsp;Tipo de Nómina</td>
            <td align="left">
                <asp:Label ID="lblTipoNomina" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td class="TDTotales">
                &nbsp;Periodo</td>
            <td align="left" class="TDTotales">
                <asp:Label ID="lblPeriodo" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td>
                &nbsp;Fecha Emisión</td>
            <td align="left">
                <asp:Label ID="lblFechaEmision" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td class="TDTotales">
                &nbsp;Fecha Pago</td>
            <td align="left" class="TDTotales">
                <asp:Label ID="lblFechaPago" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td align="left" class="listheadermultiline" colspan="2" style="height: 10px">
                &nbsp;TOTALES</td>
        </tr>
        <tr>
            <td class="TDTotales">
                &nbsp;Aporte Empleador SVDS</td>
            <td align="right" class="TDTotales">
                <asp:Label ID="lblAporteEmpSVDS" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td>
                &nbsp;Aporte Afiliado SVDS</td>
            <td align="right">
                <asp:Label ID="lblAporteAfilSVDS" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td class="TDTotales">
                &nbsp;Aporte Voluntario</td>
            <td align="right" class="TDTotales">
                <asp:Label ID="lblAporteVoluntario" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td>
                &nbsp;Aporte Empleador SFS</td>
            <td align="right">
                <asp:Label ID="lblAporteEmpSFS" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td class="TDTotales">
                &nbsp;Aporte Afiliado SFS</td>
            <td align="right" class="TDTotales" style="height: 12px">
                <asp:Label ID="lblAporteAfilSFS" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td>
                &nbsp;Total SRL Total</td>
            <td align="right">
                <asp:Label ID="lblTotalSRL" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td class="TDTotales">
                &nbsp;Recargos Total</td>
            <td align="right" class="TDTotales">
                <asp:Label ID="lblRecargos" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td>
                &nbsp;Intereses Total</td>
            <td align="right">
                <asp:Label ID="lblInteresesTotal" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td class="TDTotalGral">
                &nbsp;Total General</td>
            <td align="right" class="TDTotalGral">
                <asp:Label ID="lblTotalGral" runat="server"></asp:Label></td>
        </tr>
    </table>
    <asp:Label ID="lblMsg" runat="server" CssClass="error"></asp:Label>   
    <table width="550">
        <tr>
            <td align="right">
                <asp:HyperLink ID="hlnkAtras" runat="server"><-- Volver atrás</asp:HyperLink></td>
        </tr>
    </table>
</asp:Content>

