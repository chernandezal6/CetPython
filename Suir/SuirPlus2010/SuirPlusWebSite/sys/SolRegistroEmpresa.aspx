<%@ Page Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false" CodeFile="SolRegistroEmpresa.aspx.vb" Inherits="sys_SolRegistroEmpresa" title="Registro de Empresa" %>
<%@ Register TagPrefix="uc1" TagName="UCTelefono" Src="../Controles/UCTelefono.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
			<span class="header">Registro de Empresa</span><br/><br/>
			<table class="td-content" id="table1" cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td>
						<asp:Panel ID="pnlPrincipal" Runat="server" visible="True">
							<table cellspacing="2" cellpadding="1">
								<tr>
									<td align="right">RNC/Cédula:</td>
									<td>&nbsp;
										<asp:textbox id="txtRnc" runat="server" Width="88px" MaxLength="11"></asp:textbox>
										<asp:requiredfieldvalidator id="RequiredFieldValidator2" runat="server" ErrorMessage="*" ControlToValidate="txtRnc"
											Display="Dynamic"></asp:requiredfieldvalidator>
										<asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" ErrorMessage="*" ControlToValidate="txtRnc"
											Display="Dynamic" ValidationExpression="^(\d{9}|\d{11})$">RNC o Cédula Inválida.</asp:regularexpressionvalidator></td>
								</tr>
								<tr>
									<td align="right">Cédula Representante:</td>
									<td>&nbsp;
										<asp:textbox id="txtCedula" runat="server" Width="88px" MaxLength="11"></asp:textbox>
										<asp:requiredfieldvalidator id="Requiredfieldvalidator1" runat="server" ErrorMessage="*" ControlToValidate="txtCedula"
											Display="Dynamic"></asp:requiredfieldvalidator>
										<asp:regularexpressionvalidator id="Regularexpressionvalidator2" runat="server" ErrorMessage="*" ControlToValidate="txtCedula"
											Display="Dynamic" ValidationExpression="^(\d{9}|\d{11})$">Cédula Inválida.</asp:regularexpressionvalidator></td>
								</tr>
								<tr align="center">
									<td align="center" colspan="2">
											<asp:button id="btnConsultar" runat="server" Text="Consultar"></asp:button>
									</td>
								</tr>
							</table>
						</asp:Panel>
						<asp:panel id="pnlRegistroEmp" Visible="false" Runat="server">
							<table cellspacing="2" cellpadding="1">
								<tr>
									<td align="right">Representante:</td>
									<td>&nbsp;
										<asp:label cssclass="labelData" id="lblRepresentante" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td align="right">Razon Social:</td>
									<td>&nbsp;
										<asp:textbox id="txtRazonSocial" runat="server" Width="200px" TextMode="MultiLine"></asp:textbox>
										<asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" ErrorMessage="Razón Socila Requerida"
											ControlToValidate="txtRazonSocial" Display="Dynamic"></asp:RequiredFieldValidator></td>
								</tr>
								<tr>
									<td align="right">Nombre Comercial:</td>
									<td>&nbsp;
										<asp:textbox id="txtNombreComercial" runat="server" Width="200px" TextMode="MultiLine"></asp:textbox>
										<asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" ErrorMessage="Nombre Comercial Requerido"
											ControlToValidate="txtNombreComercial" Display="Dynamic"></asp:RequiredFieldValidator></td>
								</tr>
								<tr>
									<td align="right">Primer Telefono:</td>
									<td>&nbsp;
										<uc1:uctelefono id="ctrlTelefono1" runat="server"></uc1:uctelefono></td>
								</tr>
								<tr>
									<td align="right">Segundo Telefono:</td>
									<td>&nbsp;
										<uc1:uctelefono id="ctrlTelefono2" runat="server"></uc1:uctelefono></td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr align="center">
									<td align="center" colspan="2">
										<asp:button id="btnProcesar" runat="server" Text="Procesar"></asp:button>
										<asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button></td>
								</tr>
							</table>
						</asp:panel>
						<asp:Panel ID="pnlconfirmacion" Runat="server" Visible="False">
							<table cellspacing="2" cellpadding="1">
								<tr>
									<td align="center" colspan="2">
										<b>Datos de la Empresa</b>
									</td>
								</tr>
								<tr>
									<td align="right">Rnc/Cédula:</td>
									<td>&nbsp;
										<asp:label cssclass="labelData" id="lblRncRegistro" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td align="right">Razón Social:</td>
									<td>&nbsp;
										<asp:label cssclass="labelData" id="lblRazonSocialRegistro" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td align="right">Nombre Comercial:</td>
									<td>&nbsp;
										<asp:label cssclass="labelData" id="lblNombreComercialRegistro" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td align="right">Representante:</td>
									<td>&nbsp;
										<asp:label cssclass="labelData" id="lblRepresentanteRegistro" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td align="right">Primer Teléfono:</td>
									<td>&nbsp;
										<asp:label cssclass="labelData" id="lblTelefono1Registro" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td align="right">Segundo Teléfono:</td>
									<td>&nbsp;
										<asp:label cssclass="labelData" id="lblTelefono2Registro" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td align="center" colspan="2">
										<asp:button id="btnAceptarRegistro" runat="server" Text="Aceptar"></asp:button>
                                        <INPUT id="btnCancelarRegistro" onclick="javascript:history.back();" type="button" value="Cancelar" class="Button"></td>
								</tr>
							</table>
						</asp:Panel>
					</td>
				</tr>
			</table>
			<asp:label id="lblMensaje" runat="server" Visible="False" CssClass="error"></asp:label>
</asp:Content>

