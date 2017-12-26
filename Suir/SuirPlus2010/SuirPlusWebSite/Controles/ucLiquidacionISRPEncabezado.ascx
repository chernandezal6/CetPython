<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucLiquidacionISRPEncabezado.ascx.vb" Inherits="Controles_ucLiquidacionISRPEncabezado" %>
<asp:panel id="pnlLiquidacion" Visible="False" runat="server">
	<table class="td-content" width="550pt">
        <tr>
            <td colspan="4" style="text-align: center">
                <asp:Label ID="Label1" runat="server" CssClass="subHeader" Text="Liquidación de Retenciones del ISR"></asp:Label><br /><br />
            </td>
        </tr>
		<tr>
    		<td align="right">Tipo Liquidación</td>
	    	<td>
			    <asp:Label ID="lblTipoLiqu" runat="server" CssClass="labelData"></asp:Label>
			</td>
			<td align="right">Período</td>
			<td>
				<asp:Label ID="lblPeriodo" runat="server" CssClass="labelData"></asp:Label>
			</td>
		</tr>
		<tr>
            <td align="right">
                RNC/Cédula</td>
            <td>
                <asp:Label ID="lblCedulaRNC" runat="server" Cssclass="labelData"></asp:Label>
            </td>
            <td align="right">
                &nbsp;</td>
            <td>
                &nbsp;</td>
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
			<td align="right">Oficina DGII</td>
			<td>
			    <asp:label id="lblAdministracionLocal" runat="server" Cssclass="labelData"></asp:label>
			</td>
			<td align="right">Teléfono</td>
			<td>
			    <asp:label id="lblTelefono" runat="server" Cssclass="labelData"></asp:label>
			</td>
		</tr>
		<tr>
		    <td colspan="4" style="height: 6px"></td>
		</tr>
		<tr>
		    <td colspan="4" align="center">
			    <asp:HyperLink id="hlnkDetalle" runat="server"><img src="../images/detalle.gif" alt="" />&nbsp;Detalle Empleados</asp:HyperLink>&nbsp;&nbsp;
				<asp:HyperLink id="hlnkImprimir" runat="server" Target="_blank"><img src="../images/printv.gif" alt="" />&nbsp;Imprimir Notificación</asp:HyperLink>
			</td>
		</tr>
	</table>	
	<asp:panel id="pnlEstatus" runat="server" visible="false" width="550">
    	<asp:Label id="lblEstatus" runat="server" CssClass="label-Resaltado"></asp:Label>
	</asp:panel>
	<br />
	<table class="tableLineasFinas" id="tblRenglones" style="border-color: #4882ca" cellspacing="0" cellpadding="0"
		width="550" border="1" runat="server">
		<tr class="listHeader">
			<td colspan="2">&nbsp;Totales</td>
		</tr>
		<tr class="listItem">
			<td style="width: 65%">&nbsp;Total Asalariados</td>
			<td align="right">
				<asp:label id="lblTotalAsalariado" runat="server"></asp:label>
		    </td>
		</tr>
		<tr class="listItem">
			<td style="width: 65%">&nbsp;Sueldos Pagados por el Agente de Retención</td>
			<td align="right">
				<asp:label id="lblSueldosPagadosAgenteRetencion" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listAltItem">
			<td style="width: 65%">&nbsp;Ingresos Exentos ISR</td>
			<td align="right">
				<asp:label id="lblIngresosExentosISR" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listItem">
			<td style="width: 65%">&nbsp;Remuneraciones Otros Agentes</td>
			<td align="right">
				<asp:label id="lblRemOtrosAgentes" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listAltItem">
			<td style="width: 65%">&nbsp;Otras Remuneraciones</td>
			<td align="right">
				<asp:label id="lblOtrasRemuneracion" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listItem">
			<td style="width: 65%">&nbsp;Total Pagado</td>
			<td align="right">
				<asp:label id="lblTotalPagado" runat="server"></asp:label>
		    </td>
		</tr>
		<tr class="listAltItem">
			<td style="width: 65%">&nbsp;Retención SS</td>
			<td align="right">
				<asp:Label ID="lblTotalRetencionSS" runat="server"></asp:Label>
            </td>
		</tr>
		<tr class="listItem">
            <td style="width: 65%">
                &nbsp;Pago Total Sujeto a Retención</td>
            <td align="right">
                <asp:Label ID="lblTotalSujetoRetencion" runat="server"></asp:Label>
            </td>
        </tr>
	</table>
</asp:panel>
<br />
<asp:panel id="pnlError" Visible="False" width="550" runat="server">
	<asp:Label id="lblError" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label></asp:panel>
