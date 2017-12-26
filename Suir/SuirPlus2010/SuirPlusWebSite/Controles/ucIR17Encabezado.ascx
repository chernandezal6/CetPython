<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucIR17Encabezado.ascx.vb" Inherits="Controles_ucIR17Encabezado" %>
<asp:panel id="pnlLiquidacion" runat="server" Visible="False">

	<table class="td-content" width="550pt">
        <tr>
            <td colspan="4" style="text-align: center">
                <asp:Label ID="Label1" runat="server" CssClass="subHeader" Text="Declaración Jurada y/o Pago de Otras Retenciones Complementarias"></asp:Label>
                <br /><br />
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
			<td align="right">Periodo de Notificación</td>
			<td>
				<asp:label id="lblPeriodo" runat="server" CssClass="labelData"></asp:label>
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
		    <td align="right">Origen de Pago</td>
			<td colspan="3">
			    <asp:label id="lblOrigenPago" runat="server" Cssclass="labelData"></asp:label>
			</td>
		</tr>
		<tr>
		    <td colspan="4" style="height: 6px"></td>
		</tr>
		<tr>
		    <td colspan="4" align="center">
			    <asp:hyperlink id="hlnkImprimir" runat="server" Target="_blank"><img src="../images/printv.gif" alt="" />&nbsp;Imprimir Declaración</asp:hyperlink>
			</td>
		</tr>
	</table>

	<asp:panel id="pnlEstatus" width="550" visible="false" runat="server">
    	<asp:label id="lblEstatus" runat="server" CssClass="label-Resaltado"></asp:label>
	</asp:panel>

	<table class="tableLineasFinas" id="tblRenglones" style="border-color: #4882ca" cellspacing="0" cellpadding="0" width="550" border="1">
		<tr class="listHeader">
			<td colspan="2">&nbsp;Total Retenciones</td>
		</tr>
		<tr class="listItem">
			<td style="width: 70%;">&nbsp;Alquileres</td>
			<td align="right">
				<asp:label id="lblAlquileres" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listAltItem">
			<td>&nbsp;Honorarios por Servicios Independientes</td>
			<td align="right">
				<asp:label id="lblHonorarioServIndepen" runat="server"></asp:label></td>
		</tr>
		<tr class="listItem">
			<td>&nbsp;Premios</td>
			<td align="right">
				<asp:label id="lblPremios" runat="server"></asp:label>
		    </td>
		</tr>
		<tr class="listAltItem">
			<td>&nbsp;Transferencias de Titulos y Propiedades</td>
			<td align="right">
				<asp:label id="lblTransTituloPropiedades" runat="server"></asp:label>
		    </td>
		</tr>
		<tr class="listItem">
			<td>&nbsp;Dividendos</td>
			<td align="right">
				<asp:label id="lblDividendos" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listAltItem">
			<td>&nbsp;Intereses a Instituciones Crediticas del Exterior</td>
			<td align="right">
				<asp:label id="lblInteresesInstCredExt" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listItem">
			<td>&nbsp;Remesas al Exterior</td>
			<td align="right">
				<asp:label id="lblRemesasExterior" runat="server"></asp:label>
		    </td>
		</tr>
		<tr class="listAltItem">
			<td>&nbsp;Retenciones por Pagos a Proveedores del Estado</td>
			<td align="right">
				<asp:label id="lblRetencionesPagosProv" runat="server"></asp:label></td>
		</tr>
		<tr class="listItem">
			<td>&nbsp;Otras Rentas</TD>
			<td align="right">
				<asp:label id="lblOtrasRentas" runat="server"></asp:label>
			</td>
	    </tr>
        <tr class="listAltItem">
            <td>
                &nbsp;Otras Retenciones</td>
            <td align="right">
                <asp:Label ID="lblOtrasRet" runat="server"></asp:Label></td>
        </tr>
		<tr class="listItem">
			<td>&nbsp;<strong>Total Otras Retenciones</strong></td>
			<td align="right">
				<asp:label id="lblTotalOtrasRet" runat="server" Font-Bold="True"></asp:label>
			</td>
		</tr>
		<tr class="listAltItem"">
			<td>&nbsp;Retribuciones Complementarias</td>
			<td align="right">
				<asp:label id="lblRetribucionesComp" runat="server"></asp:label></td>
		</tr>
		<tr>
		    <td colspan="2">&nbsp;</td>
		</tr>
		<tr class="listAltItem">
			<td class="listHeader" style="width: 65%" colspan="2">&nbsp;Total Liquidación</td>
		</tr>
		<tr class="listItem">
			<td style="width: 357; font-weight:bold;">&nbsp;Impuesto a Pagar</td>
			<td align="right">
				<asp:label id="lblImpuestoPagar" runat="server" Font-Bold="True"></asp:label></td>
		</tr>
		<tr class="listAltItem">
			<td style="width: 357">&nbsp;Saldos Compensables Autorizados(Otros impuestos)</td>
			<td align="right">
				<asp:label id="lblSaldosCompensables" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listItem">
			<td style="width: 357">&nbsp;Saldo a Favor Anterior</td>
			<td align="right">
				<asp:label id="lblSaldoFavorAnterior" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listAltItem">
			<td style="width: 357">&nbsp;Pagos Computables a Cuenta</td>
			<td align="right">
				<asp:label id="lblPagosComputables" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listItem">
			<td style="width: 357; height: 13px;">&nbsp;Recargos</td>
			<td align="right" style="height: 13px">
				<asp:label id="lblRecargos" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listAltItem">
			<td style="width: 357">&nbsp;Intereses</td>
			<td align="right">
				<asp:label id="lblIntereses" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listItem">
			<td style="width: 65%; font-weight: bold;">&nbsp;Monto a Pagar</td>
			<td align="right">
				<asp:label id="lblMontoPagar" runat="server" font-bold="true"></asp:label></td>
		</tr>
		<tr class="listAltItem">
			<td style="width: 65%; font-weight: bold">&nbsp;Nuevo Saldo a Favor</td>
			<td align="right">
				<asp:label id="lblNuevoSaldoFavor" runat="server" font-bold="true"></asp:label>
			</td>
		</tr>
	</table>
</asp:panel>
<br />
<asp:Panel id="pnlInfoPago" runat="server" Width="550px" Visible="False">
	<table class="tableLineasFinas" id="Table8" style="border-color: #4882ca" cellspacing="0" cellpadding="0" border="1" width="100%">
		<tr class="listHeader">
			<td colspan="2">&nbsp;Información de pago</td>
		</tr>
		<tr class="listItem">
			<td style="width: 65%">&nbsp;No. de Autorización</td>
			<td align="right">
				<asp:label id="lblNoAutorizacion" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listAltItem">
			<td style="width: 65%">&nbsp;Entidad que realizó la autorización</td>
			<td align="right">
				<asp:label id="lblEntidadAutorizo" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listItem">
			<td style="width: 65%">&nbsp;Usuario que realizó la autorización</td>
			<td align="right">
				<asp:label id="lblUsuarioAutorizo" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listAltItem">
			<td style="width: 65%">&nbsp;Fecha de autorización</td>
			<td align="right">
				<asp:label id="lblFechaAut" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listItem">
			<td style="width: 65%; height: 13px;">&nbsp;Fecha de pago</td>
			<td align="right" style="height: 13px">
				<asp:label id="lblFechaPago" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listAltItem">
			<td style="width: 65%">&nbsp;Fecha de Cancelación</td>
			<td align="right">
				<asp:label id="lblFechaCancela" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listItem">
			<td style="width: 65%">&nbsp;Fecha Desautorización</td>
			<td align="right">
				<asp:label id="lblFechaDesautorizo" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listAltItem">
			<td style="width: 65%">&nbsp;Usuario que realizó la Desautorización</td>
			<td align="right">
				<asp:label id="lblUsuarioDesautorizo" runat="server"></asp:label>
			</td>
		</tr>
		<tr class="listItem">
			<td style="width: 65%">&nbsp;Fecha Reporte Pago</td>
			<td align="right">
				<asp:label id="lblFechaReportePago" runat="server"></asp:label>
			</td>
		</tr>
	</table>
</asp:Panel>
<asp:panel id="pnlError" runat="server" Visible="False" width="550">
	<asp:Label id="lblError" runat="server" CssClass="error" EnableViewState="False"></asp:Label></asp:panel>
