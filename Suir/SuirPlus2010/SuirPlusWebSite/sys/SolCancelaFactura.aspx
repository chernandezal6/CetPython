<%@ Page Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false" CodeFile="SolCancelaFactura.aspx.vb" Inherits="sys_SolCancelaFactura" title="Solicitud de Cancelación de Recargos y/o Notificaciones de Pago" %>
<%@ Register TagPrefix="uc1" TagName="UCTelefono" Src="../Controles/UCTelefono.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
			<span class="header">Solicitud de Cancelación de Recargos y/o Notificaciones de Pago</span><br/><br/>
			<table class="td-content" id="table1" cellspacing="3" cellpadding="0" width="450" border="0">
				<tr>
					<td>
						<table cellspacing="2" cellpadding="1" width="350">
							<tr>
								<td>RNC/Cédula:</td>
								<td>&nbsp;<asp:textbox id="txtRNC" runat="server" MaxLength="11" Width="88px"></asp:textbox>
									<asp:requiredfieldvalidator id="Requiredfieldvalidator4" runat="server" Display="Dynamic" ErrorMessage="*" ControlToValidate="txtRnc"></asp:requiredfieldvalidator><asp:regularexpressionvalidator id="Regularexpressionvalidator2" runat="server" Display="Dynamic" ErrorMessage="*"
										ControlToValidate="txtRnc" ValidationExpression="^(\d{9}|\d{11})$">RNC o Cédula Inválida.</asp:regularexpressionvalidator></td>
							</tr>
							<tr>
								<td style="WIDTH: 55px">Cédula Representante:</td>
								<td>&nbsp;<asp:textbox id="txtCedula" runat="server" MaxLength="11" Width="88px"></asp:textbox>
									<asp:requiredfieldvalidator id="Requiredfieldvalidator5" runat="server" Display="Dynamic" ErrorMessage="*" ControlToValidate="txtCedula"></asp:requiredfieldvalidator><asp:regularexpressionvalidator id="Regularexpressionvalidator3" runat="server" Display="Dynamic" ErrorMessage="*"
										ControlToValidate="txtCedula" ValidationExpression="^(\d{9}|\d{11})$">Cédula Inválida.</asp:regularexpressionvalidator></td>
							</tr>
							<tr align="center">
								<td align="center" colspan="2">
									<asp:button id="btnConsultar" runat="server" Text="Consultar"></asp:button>
								</td>
							</tr>
						</table>
						<asp:panel id="pnlInfoGeneral" Visible="false" Runat="server">
							<table class="td-content" id="table2" cellspacing="3" cellpadding="0" width="100%" border="0">
								<tr>
									<td class="subHeader" align="left" colspan="4">Información General</td>
								</tr>
								<tr>
									<td align="right">Razón Social</td>
									<td colspan="3">
										<asp:label cssclass="labelData" id="lblRazonSocial" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td align="right">Nombre Comercial</td>
									<td colspan="3">
										<asp:label cssclass="labelData" id="lblNombreComercial" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td align="right">RNC&nbsp;</td>
									<td>
										<asp:label cssclass="labelData" id="lblRNC" runat="server"></asp:label></td>
									<td style="WIDTH: 46px" align="right">Contacto&nbsp;</td>
									<td>
										<asp:label cssclass="labelData" id="lblContacto" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td align="right">Teléfono</td>
									<td>
										<uc1:UCTelefono id="ctrltelefono1" runat="server"></uc1:UCTelefono></td>
									<td align="right">&nbsp;Fax</td>
									<td>
										<uc1:uctelefono id="ctrlfax" runat="server"></uc1:uctelefono></td>
								</tr>
								<tr>
									<td align="right">Email&nbsp;</td>
									<td style="WIDTH: 169px">
										<asp:textbox id="txtEmail" runat="server" Width="160px"></asp:textbox></td>
									<td style="WIDTH: 46px" align="right">&nbsp;Cargo</td>
									<td>
										<asp:textbox id="txtCargo" runat="server" Width="160px"></asp:textbox>
										<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtCargo" ErrorMessage="El cargo es requerido."
											Display="Dynamic" CssClass="error">*</asp:RequiredFieldValidator></td>
								</tr>
							</table>
						</asp:panel><asp:panel id="pnlfacturas" Visible="false" Runat="server">
							<table class="td-note" cellspacing="3" cellpadding="0" width="100%">
								<tr>
									<td class="subHeader" colspan="4">Notificación de pagos(facturas)</td>
								</tr>
								<tr>
									<td style="WIDTH: 126px" align="right">Nro. Notificación</td>
									<td>
										<asp:textbox id="txtNotificacion1" runat="server"></asp:textbox>
										<asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ControlToValidate="txtNotificacion1"
											ErrorMessage="El Nro. de notificación es requerido." Display="Dynamic" CssClass="error">*</asp:RequiredFieldValidator>
										<asp:radiobutton id="rbtnRecargos1" runat="server" Text="Cancelar Recargos" GroupName="Notificacion1"></asp:radiobutton>&nbsp;
										<asp:radiobutton id="rbtnFactura1" runat="server" Text="Cancelar Factura" GroupName="Notificacion1"></asp:radiobutton></td>
								</tr>
								<tr>
									<td style="WIDTH: 126px" align="right">Nro. Notificación</td>
									<td style="WIDTH: 761px">
										<asp:textbox id="txtNotificacion2" runat="server"></asp:textbox>&nbsp;
										<asp:radiobutton id="rbtnRecargos2" runat="server" Text="Cancelar Recargos" GroupName="Notificacion2"></asp:radiobutton>&nbsp;
										<asp:radiobutton id="rbtnFactura2" runat="server" Text="Cancelar Factura" GroupName="Notificacion2"></asp:radiobutton></td>
								</tr>
								<tr>
									<td style="WIDTH: 126px" align="right">Nro. Notificación</td>
									<td>
										<asp:textbox id="txtNotificacion3" runat="server"></asp:textbox>&nbsp;
										<asp:radiobutton id="rbtnRecargos3" runat="server" Text="Cancelar Recargos" GroupName="Notificacion3"></asp:radiobutton>&nbsp;
										<asp:radiobutton id="rbtnFactura3" runat="server" Text="Cancelar Factura" GroupName="Notificacion3"></asp:radiobutton></td>
								</tr>
								<tr>
									<td style="WIDTH: 126px" align="right">Nro. Notificación</td>
									<td>
										<asp:textbox id="txtNotificacion4" runat="server"></asp:textbox>&nbsp;
										<asp:radiobutton id="rbtnRecargos4" runat="server" Text="Cancelar Recargos" GroupName="Notificacion4"></asp:radiobutton>&nbsp;
										<asp:radiobutton id="rbtnFactura4" runat="server" Text="Cancelar Factura" GroupName="Notificacion4"></asp:radiobutton></td>
								</tr>
								<tr>
									<td style="WIDTH: 126px" align="right">Nro. Notificación</td>
									<td>
										<asp:textbox id="txtNotificacion5" runat="server"></asp:textbox>&nbsp;
										<asp:radiobutton id="rbtnRecargos5" runat="server" Text="Cancelar Recargos" GroupName="Notificacion5"></asp:radiobutton>&nbsp;
										<asp:radiobutton id="rbtnFactura5" runat="server" Text="Cancelar Factura" GroupName="Notificacion5"></asp:radiobutton></td>
								</tr>
								<tr>
									<td style="WIDTH: 126px" align="right">Nro. Notificación</td>
									<td>
										<asp:textbox id="txtNotificacion6" runat="server"></asp:textbox>&nbsp;
										<asp:radiobutton id="rbtnRecargos6" runat="server" Text="Cancelar Recargos" GroupName="Notificacion6"></asp:radiobutton>&nbsp;
										<asp:radiobutton id="rbtnFactura6" runat="server" Text="Cancelar Factura" GroupName="Notificacion6"></asp:radiobutton></td>
								</tr>
								<tr>
									<td style="WIDTH: 126px" align="right">Nro. Notificación</td>
									<td>
										<asp:textbox id="txtNotificacion7" runat="server"></asp:textbox>&nbsp;
										<asp:radiobutton id="rbtnRecargos7" runat="server" Text="Cancelar Recargos" GroupName="Notificacion7"></asp:radiobutton>&nbsp;
										<asp:radiobutton id="rbtnFactura7" runat="server" Text="Cancelar Factura" GroupName="Notificacion7"></asp:radiobutton></td>
								</tr>
								<tr>
									<td style="WIDTH: 126px" align="right">Nro. Notificación</td>
									<td>
										<asp:textbox id="txtNotificacion8" runat="server"></asp:textbox>&nbsp;
										<asp:radiobutton id="rbtnRecargos8" runat="server" Text="Cancelar Recargos" GroupName="Notificacion8"></asp:radiobutton>&nbsp;
										<asp:radiobutton id="rbtnFactura8" runat="server" Text="Cancelar Factura" GroupName="Notificacion8"></asp:radiobutton></td>
								</tr>
								<tr>
									<td class="subHeader" colspan="4">Motivo de la Solicitud</td>
								</tr>
								<tr>
									<td colspan="4">
										<asp:textbox id="txtMotivo" runat="server" Width="536px" TextMode="MultiLine" Height="56px"></asp:textbox></td>
								</tr>
								<tr>
									<td align="center" colspan="4">
										<asp:button id="btnAceptar" runat="server" Text="Aceptar"></asp:button>
										<asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button></td>
								</tr>
							</table>
							<asp:label cssclass="error" id="lblMensaje" runat="server" Visible="False" EnableViewState="False" Font-Size="Small"></asp:label>
						</asp:panel>
						<asp:ValidationSummary id="errorSumary" runat="server" Width="560px" CssClass="error" Font-Size="Small"></asp:ValidationSummary>
					</td>
				</tr>
			</table>
</asp:Content>

