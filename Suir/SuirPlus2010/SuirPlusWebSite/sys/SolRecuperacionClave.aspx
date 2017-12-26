<%@ Page Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false" CodeFile="SolRecuperacionClave.aspx.vb" Inherits="sys_SolRecuperacionClave" title="Recuperación Clave de Acceso" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
			<span class="header">Recuperación Clave de Acceso</span><br/><br/>
			<table class="td-content" id="table1" cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td>
						<table cellspacing="2" cellpadding="1">
							<tr>
								<td align="right">RNC/Cédula:</td>
								<td>&nbsp;<asp:textbox id="txtRnc" runat="server" Width="88px" MaxLength="11"></asp:textbox>&nbsp;
									<asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ErrorMessage="*" ControlToValidate="txtRnc"
										Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="RegularExpressionValidator1" runat="server" ErrorMessage="*" ValidationExpression="^(\d{9}|\d{11})$"
										ControlToValidate="txtRnc" Display="Dynamic">RNC o Cédula Inválida.</asp:RegularExpressionValidator></td>
							</tr>
							<tr>
								<td align="right">Cédula Representante:</td>
								<td>&nbsp;<asp:textbox id="txtCedula" runat="server" Width="88px" MaxLength="11"></asp:textbox>&nbsp;
									<asp:RequiredFieldValidator id="Requiredfieldvalidator1" runat="server" ErrorMessage="*" ControlToValidate="txtCedula"
										Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="Regularexpressionvalidator2" runat="server" ErrorMessage="*" ValidationExpression="^(\d{9}|\d{11})$"
										ControlToValidate="txtCedula" Display="Dynamic">Cédula Inválida.</asp:RegularExpressionValidator></td>
							</tr>
							<tr align="center">
								<td align="center" colspan="2">
									<asp:button id="btnConsultar" runat="server" Text="Consultar"></asp:button>
								</td>
							</tr>
						</table>
						<asp:panel id="pnlRecuperaClass" Visible="false" Runat="server">
							<table cellspacing="2" cellpadding="1">
								<tr>
									<td align="center" colspan="2">
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
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr align="center">
									<td align="center" colspan="2">
											<asp:button id="btnProcesar" runat="server" Text="Procesar"></asp:button>
											<asp:button id="btnCancelar" runat="server" Text="Cancelar"></asp:button>
									</td>
								</tr>
							</table>
						</asp:panel>
					</td>
				</tr>
			</table>
			<asp:Label id="lblMensaje" runat="server" CssClass="error" Visible="False"></asp:Label>
</asp:Content>

