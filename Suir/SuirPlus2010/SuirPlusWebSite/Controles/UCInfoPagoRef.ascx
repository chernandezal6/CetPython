<%@ Control Language="VB" AutoEventWireup="false" CodeFile="UCInfoPagoRef.ascx.vb" Inherits="Controles_UCInfoPagoRef" %>
<table class="tableLineasFinas" style="border-color: #4882ca;" cellspacing="0" cellpadding="0" border="1" id="tblRenglones" width="550" >
    <tr class="listHeader">
        <td colspan="2">&nbsp;Información de pago</td>
    </tr>
	<tr class="listItem">
		<td style="width: 45%">&nbsp;Estatus de la factura en Unipago</td>
		<td align="right" style="height: 12px"><asp:label id="lblEstatusFacUnipago" runat="server"></asp:label></td>
	</tr>
	<tr class="listAltItem">
		<td style="width: 45%">&nbsp;Codigo de error</td>
		<td align="right"><asp:label id="lblCodigoError" runat="server"></asp:label></td>
	</tr>
	<tr class="listItem">
		<td style="width: 45%">&nbsp;No. de Autorización</td>
		<td align="right" style="height: 13px"><asp:label id="lblNoAutorizacion" runat="server"></asp:label></td>
	</tr>
	<tr class="listAltItem">
		<td style="width: 45%">&nbsp;Entidad que realizó la autorización</td>
		<td align="right"><asp:label id="lblEntidadAutorizo" runat="server"></asp:label></td>
	</tr>
	<tr class="listItem">
		<td style="width: 45%">&nbsp;Usuario que realizó la autorización</td>
		<td align="right" style="height: 13px"><asp:label id="lblUsuarioAutorizo" runat="server"></asp:label></td>
	</tr>
	<tr class="listAltItem">
		<td style="width: 45%">&nbsp;Fecha de autorización</td>
		<td align="right"><asp:label id="lblFechaAut" runat="server"></asp:label></td>
	</tr>
	<tr class="listItem">
		<td style="width: 45%">&nbsp;Fecha de envio</td>
		<td align="right"><asp:label id="lblFechaEnvio" runat="server"></asp:label></td>
	</tr>
	<tr class="listAltItem">
		<td style="width: 45%">&nbsp;Fecha de pago</td>
		<td align="right"><asp:label id="lblFechaPago" runat="server"></asp:label></td>
	</tr>
	<tr class="listItem">
		<td style="width: 45%; height: 13px;">&nbsp;Fecha de Cancelación</td>
		<td align="right" style="height: 13px"><asp:label id="lblFechaCancela" runat="server"></asp:label></td>
	</tr>
	<tr class="listAltItem">
		<td style="width: 45%">&nbsp;Referencia Origen</td>
		<td align="right"><asp:label id="lblReferenciaOrigen" runat="server"></asp:label></td>
	</tr>
	<tr class="listItem">
		<td style="width: 45%; height: 13px;">&nbsp;Fecha Desautorización</td>
		<td align="right" style="height: 13px"><asp:label id="lblFechaDesautorizo" runat="server"></asp:label></td>
	</tr>
	<tr class="listAltItem">
		<td style="width: 45%">&nbsp;Usuario que realizó la Desautorización</td>
		<td align="right"><asp:label id="lblUsuarioDesautorizo" runat="server"></asp:label></td>
	</tr>
	<tr class="listItem">
		<td style="width: 45%">&nbsp;Fecha Reporte Pago</td>
		<td align="right"><asp:label id="lblFechaReportePago" runat="server"></asp:label></td>
	</tr>
</table>
<br />
<asp:label id="lblTituloEnvio" runat="server" CssClass="subHeader">Envios</asp:label>
<asp:GridView ID="DataGrid1" runat="server">
	<Columns>
		<asp:BoundField DataField="C_NO_REFERENCIA" HeaderText="Nro. de Referencia"></asp:BoundField>
		<asp:BoundField DataField="D_FECHA_ENVIO" HeaderText="Fecha de Envio"></asp:BoundField>
		<asp:BoundField DataField="C_STATUS_CARGA" HeaderText="Estatus en Unipago"></asp:BoundField>
		<asp:BoundField DataField="N_ERROR_CARGA" HeaderText="C&#243;digo de Error"></asp:BoundField>
	</Columns>
</asp:GridView>
