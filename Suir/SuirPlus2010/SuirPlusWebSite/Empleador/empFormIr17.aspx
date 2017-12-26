<%@ Page Language="VB" AutoEventWireup="false" CodeFile="empFormIr17.aspx.vb" Inherits="Empleador_empFormIr17" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Formulario IR-17</title>
    <script src="../Script/Calculos.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function wrapBlur(control)
        {
            maskBlur(control);
            calc();
        }
    </script>    
</head>
<body>
    <form id="form1" runat="server">        
        <div>
            <table class="td-note" style="width: 653px">
		       <tr class="LabelDataGreen">
		            <td>
		                La fecha limite para reportar y pagar&nbsp;IR-17 en este periodo es: 
                        <asp:Label ID="lblFechaLimite" runat="server" CssClass="LabelDataGreen"></asp:Label>
		            </td>
		       </tr>
		       <tr>
		        <td align="center">
                    <asp:Label ID="lblDeclaracionVigente" runat="server" CssClass="label-Resaltado"></asp:Label>
                    <asp:Label ID="lblPagaAutorizada" runat="server" Text="Esta declaración esta paga o autorizada."
                        Visible="False" CssClass="label-Resaltado"></asp:Label>
		        </td>
		       </tr>
		       <tr>
		        <td align="right">
                    <asp:LinkButton ID="lkbtnImprimir" runat="server"><img border="0" src="../images/printv.gif" width="15" height="12" alt="" /> Imprimir Declaración</asp:LinkButton>
		        </td>
		       </tr>
	        </table>
	        <br />
	        <span class="subHeader">Datos Informativos</span>
	        <table class="tableTotales" id="tblRenglones" style="WIDTH: 653px;"
		        cellspacing="0" cellpadding="0" border="0" runat="server">
		        <tr>
			        <td class="listheadermultiline" style="WIDTH: 327px; HEIGHT: 13px">RETENCIONES</td>
			        <td class="listheadermultiline" style="WIDTH: 148px; HEIGHT: 13px" align="center">
                        Monto Imponible</td>
			        <td class="listheadermultiline" style="WIDTH: 187px; HEIGHT: 13px" align="center">
                        Tasa</td>
			        <td class="listheadermultiline" style="HEIGHT: 13px" align="center">
                        Impuesto</td>
		        </tr>
		        <tr>
			        <td class="TDTotales" style="WIDTH: 327px">&nbsp;Alquileres</td>
			        <td class="TDTotales" style="WIDTH: 148px" align="right" valign="middle">+&nbsp;<asp:textbox id="txtAlquileres" runat="server" Width="88px" CssClass="NumericInput">0.00</asp:textbox>&nbsp;&nbsp;</td>
			        <td class="TDTotales" style="WIDTH: 187px" align="center"><asp:label id="lblTazaAlq" runat="server"></asp:label></td>
			        <td class="TDTotales" align="right">
                        &nbsp;<asp:textbox id="txtAlquileresI" runat="server" Width="88px" CssClass="NumericInput" ReadOnly="True">0.00</asp:textbox>&nbsp;&nbsp;</td>
		        </tr>
		        <tr>
			        <td style="WIDTH: 327px">&nbsp;Honorarios por Servicios Independientes</td>
			        <td style="WIDTH: 148px" align="right">+&nbsp;<asp:textbox id="txtHpsi" runat="server" Width="88px" CssClass="NumericInput">0.00</asp:textbox>&nbsp;&nbsp;</td>
			        <td style="WIDTH: 187px" align="center"><asp:label id="lblTasaHSI" runat="server"></asp:label></td>
			        <td align="right"><asp:textbox id="txtHpsiI" runat="server" Width="88px" CssClass="NumericInput" ReadOnly="True">0.00</asp:textbox>&nbsp;&nbsp;</td>
		        </tr>
		        <tr>
			        <td class="TDTotales" style="WIDTH: 327px">&nbsp;Premios</td>
			        <td class="TDTotales" style="WIDTH: 148px" align="right">+&nbsp;<asp:textbox id="txtPremios" runat="server" Width="88px" CssClass="NumericInput">0.00</asp:textbox>&nbsp;&nbsp;</td>
			        <td class="TDTotales" style="WIDTH: 187px" align="center"><asp:label id="lblTasaPremios" runat="server"></asp:label></td>
			        <td class="TDTotales" align="right"><asp:textbox id="txtPremiosI" runat="server" Width="88px" CssClass="NumericInput" ReadOnly="True">0.00</asp:textbox>&nbsp;&nbsp;</td>
		        </tr>
		        <tr>
			        <td style="WIDTH: 327px">&nbsp;Transferencia de Títulos y Propieades</td>
			        <td style="WIDTH: 148px" align="right">+&nbsp;<asp:textbox id="txtTTP" runat="server" Width="88px" CssClass="NumericInput">0.00</asp:textbox>&nbsp;&nbsp;</td>
			        <td style="WIDTH: 187px" align="center"><asp:label id="lblTasaTTP" runat="server"></asp:label></td>
			        <td align="right"><asp:textbox id="txtTTPI" runat="server" Width="88px" CssClass="NumericInput" ReadOnly="True">0.00</asp:textbox>&nbsp;&nbsp;</td>
		        </tr>
		        <tr>
			        <td style="WIDTH: 327px" class="TDTotales">&nbsp;Dividendos</td>
			        <td style="WIDTH: 148px" align="right" class="TDTotales">+&nbsp;<asp:textbox id="txtDividendos" runat="server" Width="88px" CssClass="NumericInput">0.00</asp:textbox>&nbsp;&nbsp;</td>
			        <td style="WIDTH: 187px" align="center" class="TDTotales"><asp:label id="lblTasaDiv" runat="server"></asp:label></td>
			        <td align="right" class="TDTotales"><asp:textbox id="txtDividendosI" runat="server" Width="88px" CssClass="NumericInput" ReadOnly="True">0.00</asp:textbox>&nbsp;&nbsp;</td>
		        </tr>
		        <tr>
			        <td style="WIDTH: 327px">&nbsp;Intereses a Instituciones Crediticias del Exterior</td>
			        <td style="WIDTH: 148px" align="right">+&nbsp;<asp:textbox id="txtIICE" runat="server" Width="88px" CssClass="NumericInput">0.00</asp:textbox>&nbsp;&nbsp;</td>
			        <td style="WIDTH: 187px" align="center"><asp:label id="lblTasaIICE" runat="server"></asp:label></td>
			        <td align="right"><asp:textbox id="txtIICEI" runat="server" Width="88px" CssClass="NumericInput" ReadOnly="True">0.00</asp:textbox>&nbsp;&nbsp;</td>
		        </tr>
		        <tr>
			        <td style="WIDTH: 327px; height: 20px;" class="TDTotales">&nbsp;Remesas al Exterior</td>
			        <td style="WIDTH: 148px; height: 20px;" align="right" class="TDTotales">+&nbsp;<asp:textbox id="txtRemesasExt" runat="server" Width="88px" CssClass="NumericInput">0.00</asp:textbox>&nbsp;&nbsp;</td>
			        <td style="WIDTH: 187px; height: 20px;" align="center" class="TDTotales"><asp:label id="lblTasaRE" runat="server"></asp:label></td>
			        <td align="right" style="height: 20px" class="TDTotales"><asp:textbox id="txtRemesasExtI" runat="server" Width="88px" CssClass="NumericInput" ReadOnly="True">0.00</asp:textbox>&nbsp;&nbsp;</td>
		        </tr>
		        <tr>
			        <td style="WIDTH: 327px">&nbsp;Retenciones por Pagos a Proveedores del Estado</td>
			        <td style="WIDTH: 148px" align="right">+&nbsp;<asp:textbox id="txtRPPP" runat="server" Width="88px" CssClass="NumericInput">0.00</asp:textbox>&nbsp;&nbsp;</td>
			        <td style="WIDTH: 187px" align="center"><asp:label id="lblTasaRPAE" runat="server"></asp:label></td>
			        <td align="right"><asp:textbox id="txtRPPPI" runat="server" Width="88px" CssClass="NumericInput" ReadOnly="True">0.00</asp:textbox>&nbsp;&nbsp;</td>
		        </tr>
		        <tr>
			        <td style="WIDTH: 327px" class="TDTotales">&nbsp;Otras Rentas</td>
			        <td style="WIDTH: 148px" align="right" class="TDTotales">+&nbsp;<asp:textbox id="txtOtrasRentas" runat="server" Width="88px" CssClass="NumericInput">0.00</asp:textbox>&nbsp;&nbsp;</td>
			        <td style="WIDTH: 187px" align="center" class="TDTotales"><asp:label id="lblTasaOtrasRentas" runat="server"></asp:label></td>
			        <td align="right" class="TDTotales"><asp:textbox id="txtOtrasRentastImp" runat="server" Width="88px" CssClass="NumericInput" ReadOnly="True">0.00</asp:textbox>&nbsp;&nbsp;</td>
		        </tr>
                <tr>
                    <td style="width: 327px">
                        &nbsp;Otras Retenciones</td>
                    <td align="right" style="width: 148px">
                        +
                        <asp:TextBox ID="txtOtrasRet" runat="server" Width="88px" CssClass="NumericInput">0.00</asp:TextBox>
                        &nbsp;
                    </td>
                    <td align="center" style="width: 187px">
                        <asp:Label ID="lblTasaOtrasRet" runat="server"></asp:Label></td>
                    <td align="right">
                        <asp:TextBox ID="txtOtrasRetImp" runat="server" CssClass="NumericInput" ReadOnly="True"
                            Width="88px">0.00</asp:TextBox>
                        &nbsp;</td>
                </tr>
		        <tr>
			        <td style="WIDTH: 327px" class="TDTotales">&nbsp;<strong>TOTAL OTRAS RETENCIONES</strong></td>
			        <td style="WIDTH: 148px" align="right" class="TDTotales">&nbsp;&nbsp;</td>
			        <td style="WIDTH: 187px" align="center" class="TDTotales">=</td>
			        <td align="right" class="TDTotales"><asp:textbox id="txtTotalORetenciones" runat="server" Width="88px" CssClass="NumericInput" ReadOnly="True">0.00</asp:textbox>&nbsp;&nbsp;</td>
		        </tr>
		        <tr>
			        <td style="WIDTH: 327px">&nbsp;Retribuciones Complementarias</td>
			        <td style="WIDTH: 148px" align="right">+&nbsp;<asp:textbox id="txtRetComp" runat="server" Width="88px" CssClass="NumericInput">0.00</asp:textbox>&nbsp;&nbsp;</td>
			        <td style="WIDTH: 187px" align="center"><asp:label id="lblTasaRC" runat="server"></asp:label></td>
			        <td align="right"><asp:textbox id="txtRetCompI" runat="server" Width="88px" CssClass="NumericInput" ReadOnly="True">0.00</asp:textbox>&nbsp;&nbsp;</td>
		        </tr>
		        <tr>
			        <td class="listheadermultiline" style="WIDTH: 334px" colspan="4">LIQUIDACION</td>
		        </tr>
		        <tr>
			        <td style="WIDTH: 327px; height: 19px;"><strong>&nbsp;Impuesto a Pagar</strong></td>
			        <td align="right">&nbsp;</td>
			        <td align="right">=
			        </td>
			        <td align="right"><asp:textbox id="txtImpuesto" runat="server" Width="88px" CssClass="NumericInput" ReadOnly="True">0.00</asp:textbox>&nbsp;</td>
		        </tr>
		        <tr>
			        <td class="TDTotales">&nbsp;Saldos Compensables Autorizados (otros impuestos)</td>
			        <td class="TDTotales" align="right">&nbsp;</td>
			        <td class="TDTotales" align="right">-</td>
			        <td class="TDTotales" align="right"><asp:textbox id="txtSCA" runat="server" Width="88px" CssClass="NumericInput" ReadOnly="True">0.00</asp:textbox>&nbsp; 
                    </td>
		        </tr>
		        <tr>
			        <td>&nbsp;Saldo a Favor Anterior</td>
			        <td align="right">&nbsp;</td>
			        <td align="right">-</td>
			        <td align="right">
                        &nbsp;<asp:textbox id="txtSFA" runat="server" Width="88px" CssClass="NumericInput">0.00</asp:textbox>&nbsp;</td>
		        </tr>
		        <tr>
			        <td class="TDTotales">&nbsp;Pagos Computables a Cuenta</td>
			        <td class="TDTotales" align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			        <td class="TDTotales" align="right">-</td>
			        <td class="TDTotales" align="right">
                        &nbsp;<asp:textbox id="txtTORI" runat="server" Width="88px" CssClass="NumericInput">0.00</asp:textbox>&nbsp;</td>
		        </tr>
		        <tr>
			        <td class="TDTotalGral">&nbsp;MONTO A PAGAR</td>
			        <td class="TDTotalGral" align="right">&nbsp;</td>
			        <td class="TDTotalGral" align="right">=</td>
			        <td class="TDTotalGral" align="right">
                        &nbsp;<asp:textbox id="txtMP" runat="server" Width="88px" CssClass="NumericInput" ReadOnly="True">0.00</asp:textbox>&nbsp;</td>
		        </tr>
		        <tr>
			        <td class="TDTotalGral">&nbsp;NUEVO SALDO A FAVOR</td>
			        <td class="TDTotalGral" align="right">&nbsp;</td>
			        <td class="TDTotalGral" align="right">=
			        </td>
			        <td class="TDTotalGral" align="right">
                        &nbsp;<asp:textbox id="txtNuevoSaldoFavor" runat="server" Width="88px" CssClass="NumericInput" ReadOnly="True">0.00</asp:textbox>&nbsp;</td>
		        </tr>
	        </table>
           <br />
	        <table id="table2" style="WIDTH: 653px" cellspacing="0" cellpadding="0"
		        width="653" border="0" runat="server">
		        <tr>
			        <td align="right"><asp:button id="btnEdit" runat="server" Text="Actualizar Declaración"></asp:button><asp:button id="btnNew" runat="server" Text="Declarar"></asp:button><br />
			        </td>
		        </tr>
	        </table>        
        </div>
        <asp:Label ID="lblMensajeError" runat="server" CssClass="error" Visible="False"></asp:Label>
    </form>
</body>
</html>