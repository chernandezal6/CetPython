<%@ Page Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false" CodeFile="SolEnvioFacturasEmail.aspx.vb" Inherits="sys_SolEnvioFacturasEmail" title="Solicitud de Envío de Notificaciones de Pago" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
			<span class="header">Solicitud de Envío de Notificaciones de Pago por E-mail</span>
			<table class="td-content" id="table1" cellspacing="0" cellpadding="0" width="400" border="0">
				<tr>
					<td>
						<table cellspacing="2" cellpadding="1" width="350">
							<tr>
								<td align="right">RNC/Cédula:</td>
								<td>&nbsp;<asp:textbox id="txtRnc" runat="server" MaxLength="11" Width="88px"></asp:textbox>
									<asp:requiredfieldvalidator id="RequiredFieldValidator2" runat="server" Display="Dynamic" ControlToValidate="txtRnc"
										ErrorMessage="*"></asp:requiredfieldvalidator><asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" Display="Dynamic" ControlToValidate="txtRnc"
										ErrorMessage="*" ValidationExpression="^(\d{9}|\d{11})$">RNC o Cédula Inválida.</asp:regularexpressionvalidator></td>
							</tr>
							<tr>
								<td align="right">Cédula Representante:</td>
								<td>&nbsp;<asp:textbox id="txtCedula" runat="server" MaxLength="11" Width="88px"></asp:textbox>
									<asp:requiredfieldvalidator id="Requiredfieldvalidator1" runat="server" Display="Dynamic" ControlToValidate="txtCedula"
										ErrorMessage="*"></asp:requiredfieldvalidator><asp:regularexpressionvalidator id="Regularexpressionvalidator2" runat="server" Display="Dynamic" ControlToValidate="txtCedula"
										ErrorMessage="*" ValidationExpression="^(\d{9}|\d{11})$">Cédula Inválida.</asp:regularexpressionvalidator></td>
							</tr>
							<tr align="center">
								<td align="center" colspan="2">
									<asp:button id="btnConsultar" runat="server" Text="Consultar"></asp:button>
								</td>
							</tr>
						</table>
						<asp:panel id="pnlFacturasEmail" Visible="false" Runat="server">
							<table cellspacing="2" cellpadding="1" width="100%">
								<tr>
									<td align="right">
										<b>Datos de la Empresa</b>
									</td>
								</tr>
								<tr>
									<td align="right">Razón Social:</td>
									<td>&nbsp;
										<asp:label cssclass="labelData" id="lblRazonSocial" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td align="right">Nombre Comercial:</td>
									<td>&nbsp;
										<asp:label cssclass="labelData" id="lblNombreComercial" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td align="right">Representante:</td>
									<td>&nbsp;
										<asp:label cssclass="labelData" id="lblRepresentante" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td align="right">Correo Electrónico Actual:</td>
									<td>&nbsp;
										<asp:label cssclass="labelData" id="lblCorreoActual" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td align="right">Nuevo Correo Electrónico:</td>
									<td>&nbsp;
										<asp:textbox id="txtNuevoCorreo" runat="server" width="200px"></asp:textbox>
										<asp:RegularExpressionValidator id="RegularExpressionValidator5" runat="server" ErrorMessage="Email Inválido" ControlToValidate="txtNuevoCorreo"
											Display="Dynamic" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
										<asp:CompareValidator id="CompareValidator1" runat="server" ErrorMessage="Los correos electrónicos deben ser iguales"
											ControlToValidate="txtNuevoCorreo" Display="Dynamic" ControlToCompare="txtConfirmacion"></asp:CompareValidator></td>
								</tr>
								<tr>
									<td align="right">Confirmación Correo Electrónico:</td>
									<td>&nbsp;
										<asp:textbox id="txtConfirmacion" runat="server" width="200px"></asp:textbox>
										<asp:RegularExpressionValidator id="RegularExpressionValidator6" runat="server" ErrorMessage="Email Inválido" ControlToValidate="txtConfirmacion"
											Display="Dynamic" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
										<asp:CompareValidator id="CompareValidator3" runat="server" ErrorMessage="Los correos electrónicos deben ser iguales"
											ControlToValidate="txtConfirmacion" Display="Dynamic" ControlToCompare="txtNuevoCorreo"></asp:CompareValidator></td>
								</tr>
								<tr align="center">
									<td align="center" colspan="2" height="8"></td>
								</tr>
								<tr align="center">
									<td align="center" colspan="2">
											<asp:button id="btnActualizarEmail" runat="server" Text="Enviar"></asp:button>
											<asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button>
									</td>
								</tr>
							</table>
						</asp:panel>
					</td>
				</tr>
			</table>
			<asp:Label id="lblMensaje" runat="server" Visible="False" CssClass="error"></asp:Label>
</asp:Content>

