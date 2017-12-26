<%@ Page Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false" CodeFile="SolCancelaRNC.aspx.vb" Inherits="sys_SolCancelaRNC" title="Solicitud de Cancelación de Registro" %>
<%@ Register TagPrefix="uc1" TagName="UCTelefono" Src="../Controles/UCTelefono.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
			<span class="header">Solicitud de Cancelación de Registro</span>
			<br />
			<table class="td-content" id="table0" cellspacing="2" cellpadding="1" width="450" border="0">
				<tr>
					<td>
						<table cellspacing="1" cellpadding="1" width="350">
							<tr>
								<td align="right">RNC/Cédula:</td>
								<td>&nbsp;<asp:textbox id="txtRNC" runat="server" MaxLength="11" Width="88px"></asp:textbox>
									<asp:requiredfieldvalidator id="Requiredfieldvalidator3" runat="server" Display="Dynamic" ErrorMessage="*" ControlToValidate="txtRnc"></asp:requiredfieldvalidator><asp:regularexpressionvalidator id="Regularexpressionvalidator2" runat="server" Display="Dynamic" ErrorMessage="*"
										ControlToValidate="txtRnc" ValidationExpression="^(\d{9}|\d{11})$">RNC o Cédula Inválida.</asp:regularexpressionvalidator></td>
							</tr>
							<tr>
								<td align="right">Cédula Representante:</td>
								<td>&nbsp;<asp:textbox id="txtCedula" runat="server" MaxLength="11" Width="88px"></asp:textbox>
									<asp:requiredfieldvalidator id="Requiredfieldvalidator4" runat="server" Display="Dynamic" ErrorMessage="*" ControlToValidate="txtCedula"></asp:requiredfieldvalidator><asp:regularexpressionvalidator id="Regularexpressionvalidator3" runat="server" Display="Dynamic" ErrorMessage="*"
										ControlToValidate="txtCedula" ValidationExpression="^(\d{9}|\d{11})$">Cédula Inválida.</asp:regularexpressionvalidator></td>
							</tr>
							<tr align="center">
								<td align="center" colspan="2">
									<asp:button id="btnConsultar" runat="server" Text="Consultar"></asp:button>
								</td>
							</tr>
						</table>
						<asp:panel id="pnlCancelacionRNC" Runat="server" Visible="false">
							<table class="td-content" id="table2" cellspacing="3" cellpadding="0" width="100%" border="0">
								<tr>
									<td class="subHeader" align="left" width="20%" colspan="4">Información General</td>
								</tr>
								<tr>
									<td style="WIDTH: 125px" align="right" width="125" height="5"></td>
									<td colspan="3" height="5"></td>
								</tr>
								<tr>
									<td style="WIDTH: 125px" align="right" width="125">Razón Social</td>
									<td colspan="3">
										<asp:label cssclass="labelData" id="lblRazonSocial" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td style="WIDTH: 125px" align="right" width="125">Nombre Comercial</td>
									<td colspan="3">
										<asp:label cssclass="labelData" id="lblNombreComercial" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td style="WIDTH: 125px" align="right">RNC&nbsp;</td>
									<td style="WIDTH: 210px">
										<asp:label cssclass="labelData" id="lblRNC" runat="server"></asp:label></td>
									<td style="WIDTH: 58px" align="right" width="58">&nbsp;Teléfono</td>
									<td>
										<uc1:uctelefono id="ctrlTelefono" runat="server"></uc1:uctelefono></td>
								</tr>
								<tr>
									<td style="WIDTH: 125px" align="right">Contacto</td>
									<td style="WIDTH: 210px">
										<asp:label cssclass="labelData" id="lblContacto" runat="server"></asp:label></td>
									<td style="WIDTH: 58px" align="right">&nbsp;Fax</td>
									<td>
										<uc1:uctelefono id="ctrlFax" runat="server"></uc1:uctelefono></td>
								</tr>
								<tr>
									<td style="WIDTH: 125px" align="right">Email&nbsp;</td>
									<td style="WIDTH: 210px">
										<asp:textbox id="txtEmail" runat="server" Width="180px"></asp:textbox></td>
									<td style="WIDTH: 58px" align="right">&nbsp;Cargo</td>
									<td>
										<asp:textbox id="txtCargo" runat="server" Width="150px"></asp:textbox>
										<asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ControlToValidate="txtCargo" ErrorMessage="El cargo es requerido"
											Display="Dynamic"></asp:RequiredFieldValidator></td>
								</tr>
								<tr>
									<td class="labelData" style="WIDTH: 125px" align="right">RNC a Cancelar&nbsp;</td>
									<td style="WIDTH: 210px">
										<asp:textbox id="txtRncCancelar" runat="server" Width="180px" MaxLength="11"></asp:textbox>
										<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtRncCancelar" ErrorMessage="RNC a cancelar requerido"></asp:RequiredFieldValidator></td>
									<td style="WIDTH: 58px"></td>
									<td></td>
								</tr>
								<tr>
									<td class="subHeader" colspan="4" height="10"></td>
								</tr>
								<tr>
									<td class="subHeader" colspan="4">Motivo de la Solicitud</td>
								</tr>
								<tr>
									<td colspan="4">
										<asp:textbox id="txtMotivo" runat="server" Width="408px" TextMode="MultiLine" Height="56px"></asp:textbox>
										<asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" ControlToValidate="txtMotivo" ErrorMessage="El Motivo es requerido"
											Display="Dynamic"></asp:RequiredFieldValidator></td>
								</tr>
								<tr>
									<td align="center" colspan="4">
										<asp:button id="btnAceptar" runat="server" Text="Aceptar"></asp:button>
										<asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button></td>
								</tr>
							</table>
						</asp:panel>
						<table class="td-content" id="table6" cellspacing="3" cellpadding="0" width="550" border="0">
							<tr>
								<td colspan="4"><asp:label cssclass="error" id="lblMensaje" runat="server" EnableViewState="False"></asp:label></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
</asp:Content>

