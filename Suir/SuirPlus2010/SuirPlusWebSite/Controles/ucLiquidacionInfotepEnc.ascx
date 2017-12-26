<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucLiquidacionInfotepEnc.ascx.vb" Inherits="Controles_ucLiquidacionInfotepEnc" %>
<asp:panel id="pnlLiquidacion" Runat="server" Visible="False">
	<table class="td-content" width="550pt">
		<tr>
			<td colspan="4" style="text-align: center">
			   <asp:Label ID="Label1" runat="server" CssClass="subHeader" Text="Liquidación del INFOTEP"></asp:Label><br /><br />
			</td>
		</tr>
		<tr>
			<td align="right">Referencia</td>
			<td>
			    <asp:label id="lblReferencia" runat="server" Cssclass="labelData"></asp:label>
			</td>
			<td align="right">Estatus</td>
			<td>
			    <asp:label id="lblEst" runat="server" Cssclass="labelData"></asp:label>
			</td>
		</tr>
		<tr>
		    <td align="right">RNC/Cédula</td>
			<td>
			    <asp:label id="lblCedulaRNC" runat="server" Cssclass="labelData"></asp:label>
			</td>
			<td align="right">Período</td>
			<td>
				<asp:Label id="lblPeriodo" runat="server" CssClass="labelData"></asp:Label>
		    </td>
		</tr>
		<tr>
    		<td align="right">Razón Social</td>
			<td colspan="3">
			    <asp:label id="lblRazonSocial" runat="server" Cssclass="labelData"></asp:label>
			</td>
		</tr>
		<tr>
		    <td align="right">Dirección</td>
			<td colspan="3">
			    <asp:label id="lblDireccion" runat="server" Cssclass="labelData"></asp:label>
			</td>
		</tr>
		<tr>
			<td align="right">Fecha Emisión</td>
			<td>
			    <asp:label id="lblFechaEmision" runat="server" Cssclass="labelData"></asp:label>
			</td>
			<td align="right">Fecha Límite de Pago</td>
			<td>
			    <asp:label id="lblFechaLimitePago" runat="server" Cssclass="labelData"></asp:label>
			</td>
	    </tr>
	    <tr>
		    <td align="right">Teléfono</td>
			<td>
			    <asp:label id="lblTelefono" runat="server" Cssclass="labelData"></asp:label>
			</td>
			<td align="right">Tipo Liquidación</td>
			<td>
		    	<asp:label id="lblTipoLiq" runat="server" Cssclass="labelData"></asp:label>
		    </td>
		</tr>
		<tr>
		    <td colspan="4" style="height: 6px"></td>
		</tr>
		<tr>
		    <td colspan="4" align="center" style="height: 16px">
		        <asp:HyperLink id="hlnkDetalle" runat="server"><img src="../images/detalle.gif" alt="" />&nbsp;Detalle Empleados</asp:HyperLink>&nbsp;&nbsp;
			    <asp:HyperLink id="hlnkImprimir" runat="server" Target="_blank"><img src="../images/printv.gif" alt="" />&nbsp;Imprimir</asp:HyperLink>
		    </td>
		</tr>
	</table>
	<asp:panel id="pnlEstatus" runat="server" width="550">
    	<asp:Label id="lblEstatus" runat="server" CssClass="label-Resaltado"></asp:Label>
	</asp:panel>
	<br />
	<table id="tblRenglones" class="tableLineasFinas" style="border-color: #4882ca" cellspacing="0" cellpadding="0" border="1" width="550" runat="server">
		<tr>
			<td colspan="2" style="height: 12px" class="listHeader">&nbsp;Totales</td>
		</tr>
		<tr class="listItem">
			<td style="width: 65%; height: 13px;">Total Trabajadores</td>
			<td align="right" style="height: 13px">
				<asp:label id="lblTotalAsalariado" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listAltItem">
			<td style="width: 65%">
				<asp:Label id="lblItemFact" runat="server"></asp:Label>
			</td>
			<td align="right">
				<asp:label id="lblTotalBonificacion" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listItem">
			<td style="width: 65%; font-weight:bold;">Total a pagar</td>
			<td align="right">&nbsp;
				<asp:label id="lblTotalGral" runat="server" font-bold="true"></asp:label>
		    </td>
		</tr>
	</table>
	<br />
</asp:panel>