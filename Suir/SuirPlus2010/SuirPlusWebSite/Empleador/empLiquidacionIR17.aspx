<%@ Page Language="VB" AutoEventWireup="false" CodeFile="empLiquidacionIR17.aspx.vb" Inherits="Empleador_empLiquidacionIR17" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>empLiquidacionIR17</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
			<table id="table1" cellspacing="0" cellpadding="0" width="550" border="0">
				<tr>
					<td class="header" align="left" style="width:150px;">
					    <img src="../images/LogoNewDGII.jpg" width="150" height="69" alt="" />
					 </td>
					<td valign="bottom" class="header">
                        Formulario IR-17                  </td>
				</tr>               
			</table>
			 <br />
			<table class="td-content" id="tblHeader" cellspacing="0" cellpadding="0" width="550" border="0"
				runat="server">
				<tr>
					<td valign="top" width="65%">
						<table id="table2" width="100%" border="0">
                            <tr>
                                <td>
                                    Referencia</td>
                            </tr>
                            <tr>
                                <td>
                        <asp:Label ID="lblReferencia" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
							<tr>
								<td>Razón Social</td>
							</tr>
							<tr>
								<td><asp:label id="lblRazonSocial" runat="server" Cssclass="labelData"></asp:label></td>
							</tr>
							<tr>
								<td>RNC/Cédula</td>
							</tr>
							<tr>
								<td><asp:label id="lblCedulaRNC" runat="server" Cssclass="labelData"></asp:label></td>
							</tr>
							<tr>
								<td>Dirección</td>
							</tr>
							<tr>
								<td><asp:label id="lblDireccion" runat="server" Cssclass="labelData"></asp:label></td>
							</tr>
							<tr>
								<td>Oficina DGII</td>
							</tr>
							<tr>
								<td><asp:label id="lblAdministracionLocal" runat="server" Cssclass="labelData"></asp:label></td>
							</tr>
							<tr>
								<td></td>
							</tr>
						</table>
					</td>
					<td width="5%"></td>
					<td valign="top" width="30%">
						<table id="table3" width="100%" border="0">
                            <tr>
                                <td>
                                    Período</td>
                            </tr>
                            <tr>
                                <td>
                        <asp:Label ID="lblPeriodo" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
							<tr>
								<td>Fecha Emisión</td>
							</tr>
							<tr>
								<td><asp:label id="lblFechaEmision" runat="server" Cssclass="labelData"></asp:label></td>
							</tr>
							<tr>
								<td>Fecha Límite de Pago</td>
							</tr>
							<tr>
								<td><asp:label id="lblFechaLimite" runat="server" Cssclass="labelData"></asp:label></td>
							</tr>
							<tr>
								<td style="HEIGHT: 12px">Teléfono</td>
							</tr>
							<tr>
								<td><asp:label id="lblTelefono" runat="server" Cssclass="labelData"></asp:label></td>
							</tr>
							<tr>
								<td></td>
							</tr>
							<tr>
								<td style="HEIGHT: 24px"></td>
							</tr>
							<tr>
								<td>&nbsp;
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<table class="tableTotales" cellspacing="0" cellpadding="1" width="550"
				border="0">
				<tr>
					<td class="listheadermultiline">
						Retenciones</td>
					<td class="listheadermultiline" style="WIDTH: 105px" align="center">
                        Monto Imponible</td>
					<td class="listheadermultiline" align="center">
                        Tasa</td>
					<td class="listheadermultiline" align="right">
                        Impuesto</td>
				</tr>
				<tr>
					<td class="TDTotales" align="left">
                        Alquileres</td>
					<td class="TDTotales" style="WIDTH: 105px; height: 13px;" align="right">&nbsp;<asp:label id="lblAlquileres" runat="server"></asp:label></td>
					<td class="TDTotales" align="center">
							<asp:label id="lblTazaAlq" runat="server"></asp:label></td>
					<td class="TDTotales" style="height: 13px" align="right">
							<asp:label id="lblAlquileresI" runat="server"></asp:label>
					</td>
				</tr>
				<tr>
					<td>
                        Honorario por Servicios Independientes</td>
					<td style="WIDTH: 105px" align="right">&nbsp;<asp:label id="lblHpsi" runat="server"></asp:label></td>
					<td align="center">
							<asp:label id="lblTasaHSI" runat="server"></asp:label></td>
					<td align="right"><asp:label id="lblHpsiI" runat="server"></asp:label>
					</td>
				</tr>
				<tr>
					<td class="TDTotales">
                        Premios</td>
					<td class="TDTotales" style="WIDTH: 105px" align="right">&nbsp;<asp:label id="lblPremios" runat="server"></asp:label></td>
					<td class="TDTotales" align="center">
							<asp:label id="lblTasaPremios" runat="server"></asp:label>
					</td>
					<td class="TDTotales" align="right"><asp:label id="lblPremiosI" runat="server"></asp:label>
					</td>
				</tr>
				<tr>
					<td>
                        Transferencia de Títulos y Propiedades</td>
					<td style="WIDTH: 105px" align="right">&nbsp;
							<asp:label id="lblTTP" runat="server"></asp:label>
					</td>
					<td align="center">
							<asp:label id="lblTasaTTP" runat="server"></asp:label>
					</td>
					<td align="right">
							<asp:label id="lblTTPI" runat="server"></asp:label>
					</td>
				</tr>
				<tr>
					<td class="TDTotales">
                        Dividendos</td>
					<td class="TDTotales" style="WIDTH: 105px;" align="right">&nbsp;
							<asp:label id="lblDividendos" runat="server"></asp:label></td>
					<td class="TDTotales" align="center">
							<asp:label id="lblTasaDiv" runat="server"></asp:label>
					</td>
					<td class="TDTotales" align="right">
							<asp:label id="lblDividendosI" runat="server"></asp:label>
					</td>
				</tr>
				<tr>
					<td>
                        Intereses a Instituciones Crediticias del &nbsp;Exterior</td>
					<td style="WIDTH: 105px" align="right">&nbsp;
							<asp:label id="lblIICE" runat="server"></asp:label>
					</td>
					<td align="center">
							<asp:label id="lblTasaIICE" runat="server"></asp:label>
					</td>
					<td align="right">
							<asp:label id="lblIICEI" runat="server"></asp:label>
					</td>
				&nbsp;
				</tr>
				<tr>
					<td class="TDTotales">
                        Remesas al Exterior</td>
					<td align="right" class="TDTotales">&nbsp;
							<asp:label id="lblRemesasExt" runat="server"></asp:label>
					</td>
					<td align="center" class="TDTotales">
							<asp:label id="lblTasaRE" runat="server"></asp:label></td>
					<td align="right" class="TDTotales">
							<asp:label id="lblRemesasExtI" runat="server"></asp:label>
					</td>
				</tr>
				<tr>
					<td class="TDTotales">
                        Retenciones Por Pagos a Proveedores del Estado</td>
					<td style="WIDTH: 105px" align="right" class="TDTotales">&nbsp;
							<asp:label id="lblRPPP" runat="server"></asp:label>
					</td>
					<td align="center" class="TDTotales">
							<asp:label id="lblTasaRPAE" runat="server"></asp:label>
					</td>
					<td align="right" class="TDTotales">
							<asp:label id="lblRPPPI" runat="server"></asp:label>
					</td>
				</tr>
				<tr>
					<td style="height: 13px" class="TDTotales">
                        Otras Rentas</td>
					<td style="height: 13px" align="right" class="TDTotales">&nbsp;
							<asp:label id="lblOtrasRentas" runat="server"></asp:label>
					</td>
					<td align="center" class="TDTotales">
							<asp:label id="lblTasaORentas" runat="server"></asp:label>
					</td>
					<td align="right" class="TDTotales">
							<asp:label id="lblOtrasRentasI" runat="server"></asp:label>
					</td>
				</tr>
                <tr>
                    <td>
                        Otras Retenciones</td>
                    <td align="right">
                        <asp:Label ID="lblOtrasRet" runat="server"></asp:Label></td>
                    <td align="center">
                        <asp:Label ID="lblTasaOtrasRet" runat="server"></asp:Label></td>
                    <td align="right">
                        <asp:Label ID="lblOtrasRetI" runat="server"></asp:Label></td>
                </tr>
				<tr>
					<td class="TDTotales"><strong>Total Otras Retenciones</strong></td>
					<td style="WIDTH: 105px" class="TDTotales">&nbsp;</td>
					<td class="TDTotales">&nbsp;</td>
					<td align="right" class="TDTotales">&nbsp;<asp:label id="lblTotalORetenciones" runat="server"></asp:label>
					</td>
				</tr>
				<tr>
					<td>
                        Retribuciones Complementarias</td>
					<td style="WIDTH: 105px" align="right">&nbsp;
							<asp:label id="lblRetComp" runat="server"></asp:label>
					</td>
					<td align="center">&nbsp;
							<asp:label id="lblTasaRC" runat="server"></asp:label>
					</td>
					<td align="right">&nbsp;
							<asp:label id="lblRetCompI" runat="server"></asp:label>
					</td>
				</tr>
				<tr>
					<td class="listheadermultiline">Liquidación</td>
					<td class="listheadermultiline" colspan="3"></td>
				</tr>
				<tr>
					<td><strong>Impuesto a Pagar</strong></td>
					<td style="WIDTH: 105px">&nbsp;</td>
					<td>&nbsp;
					</td>
					<td align="right">&nbsp;<asp:label id="lblImpuesto" runat="server"></asp:label>
					</td>
				</tr>
				<tr>
					<td class="TDTotales">Saldos Compensables Autorizados (otros impuestos)</td>
					<td class="TDTotales" style="WIDTH: 105px">&nbsp;</td>
					<td class="TDTotales">&nbsp;</td>
					<td class="TDTotales" align="right">&nbsp;<asp:label id="lblSCA" runat="server"></asp:label>
					</td>
				</tr>
				<tr>
					<td>Saldo a Favor Anterior</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="right">&nbsp;<asp:label id="lblSFA" runat="server"></asp:label>
					</td>
				</tr>
				<tr>
					<td class="TDTotales">Pagos Computables a Cuenta</td>
					<td class="TDTotales" style="WIDTH: 105px">&nbsp;</td>
					<td class="TDTotales">&nbsp;</td>
					<td class="TDTotales" align="right">&nbsp;
							<asp:label id="lblTORI" runat="server"></asp:label>
					</td>
				</tr>
				<tr>
					<td class="TDTotalGral">Monto a Pagar</td>
					<td class="TDTotalGral" style="WIDTH: 105px">&nbsp;</td>
					<td class="TDTotalGral">&nbsp;</td>
					<td class="TDTotalGral" align="right">&nbsp;<asp:label id="lblMP" runat="server"></asp:label>
					</td>
				</tr>
				<tr>
					<td class="TDTotalGral">Nuevo Saldo a Favor</td>
					<td class="TDTotalGral" style="WIDTH: 105px">&nbsp;</td>
					<td class="TDTotalGral">&nbsp;</td>
					<td class="TDTotalGral" align="right">&nbsp;<asp:label id="lblNuevoSaldoFavor" runat="server"></asp:label>
					</td>
				</tr>
			</table>
			<table cellspacing="0" cellpadding="0" width="550" border="0">
				<tr>
					<td>
						<strong>
							<br />
							Notas: </strong>
						<ul>
							<li>
							Puede realizar el pago hasta&nbsp;la fecha límite en los bancos autorizados.</li>
							<li>
							Los pagos realizados después de la fecha límite, deben ser realizados 
							directamente en su Administración Local.</li>
							<li>
								No se aceptan pagos parciales.</li></ul>
					</td>
				</tr>
			</table>
        </div>
    </form>
</body>
</html>
