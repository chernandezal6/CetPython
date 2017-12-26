<%@ Page Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false" CodeFile="SolEstadoCuentaFax.aspx.vb" Inherits="sys_SolEstadoCuentaFax" title="Estado de Cuenta vía Fax" %>
<%@ Register TagPrefix="uc1" TagName="UCTelefono" Src="../Controles/UCTelefono.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
			<span class="header">Estado de Cuenta vía Fax</span><br/><br/>
			<table class="td-content" id="table1" cellspacing="0" cellpadding="0" width="420" border="0">
				<tr>
					<td>
						<table cellspacing="2" cellpadding="1" width="100%">
							<tr>
								<td align="right" style="WIDTH: 143px">RNC/Cédula:</td>
								<td>&nbsp;<asp:textbox id="txtRnc" runat="server" Width="88px" MaxLength="11"></asp:textbox>
									<asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ErrorMessage="*" ControlToValidate="txtRnc"
										Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="RegularExpressionValidator1" runat="server" ErrorMessage="*" ValidationExpression="^(\d{9}|\d{11})$"
										ControlToValidate="txtRnc" Display="Dynamic">RNC o Cédula Inválida.</asp:RegularExpressionValidator></td>
							</tr>
							<tr>
								<td align="right" style="WIDTH: 143px">Cédula Representante:</td>
								<td>&nbsp;<asp:textbox id="txtCedula" runat="server" Width="88px" MaxLength="11"></asp:textbox>
									<asp:RequiredFieldValidator id="Requiredfieldvalidator1" runat="server" ErrorMessage="*" ControlToValidate="txtCedula"
										Display="Dynamic"></asp:RequiredFieldValidator>
									<asp:RegularExpressionValidator id="Regularexpressionvalidator2" runat="server" ErrorMessage="*" ValidationExpression="^(\d{9}|\d{11})$"
										ControlToValidate="txtCedula" Display="Dynamic">Cédula Inválida.</asp:RegularExpressionValidator></td>
							</tr>
							<tr>
								<td colspan="2" align="center">&nbsp;
									<asp:button id="btBuscar" runat="server" Text="Consultar"></asp:button></td>
							</tr>
						</table>
						<asp:Panel ID="pnlEnviaFax" Runat="server" Visible="False">
							<table cellspacing="2" cellpadding="1" width="100%">
								<tr>
									<td style="HEIGHT: 14px" align="center" colspan="2">
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
									<td style="WIDTH: 143px" align="right">Número de Fax:</td>
									<td>&nbsp;
										<uc1:uctelefono id="ctrlFax" runat="server"></uc1:uctelefono></td>
								</tr>
								<tr align="center">
									<td align="center" colspan="2" height="8"></td>
								</tr>
								<tr align="center">
									<td align="center" colspan="2">
										<asp:button id="btnEnviar" runat="server" Text="Enviar"></asp:button>
										<asp:button id="btnCancelar" runat="server" Text="Cancelar"></asp:button></td>
								</tr>
							</table>
						</asp:Panel>
					</td>
				</tr>
			</table>
			<asp:Label id="lblMensaje" runat="server" CssClass="error" Visible="False"></asp:Label>
</asp:Content>

