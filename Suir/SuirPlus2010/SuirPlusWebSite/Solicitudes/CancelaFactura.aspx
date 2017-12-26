<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CancelaFactura.aspx.vb" Inherits="Solicitudes_CancelaFactura" title="Solicitud de Cancelación de Recargos y/o Notificaciones de Pago" %>
<%@ Register TagPrefix="uc1" TagName="UCTelefono" Src="../Controles/UCTelefono.ascx" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<br />

	       <div align="center" class="header">Solicitud de Cancelación de Recargos y/o Notificaciones de Pago</div>
	       <br />
	<table align="center" class="td-content" id="table2" cellSpacing="3" cellPadding="0" width="550" border="0">
		<TR>
		<TD>

			<table class="td-content" id="table1" cellSpacing="3" cellPadding="0" width="550" border="0">
				<TR>
					<TD align="right" width="15%">Solicitud</TD>
					<TD colSpan="3"><asp:label cssClass="labelData" id="lblSolicitud" runat="server"></asp:label></TD>
				</TR>
				<tr>
					<td align="right" width="15%">Razón Social</td>
					<td colSpan="3"><asp:label cssClass="labelData" id="lblRazonSocial" runat="server"></asp:label></td>
				</tr>
				<tr>
					<td align="right">RNC&nbsp;</td>
					<td width="40%"><asp:label cssClass="labelData" id="lblRNC" runat="server"></asp:label></td>
					<td align="right" width="10%">&nbsp;Teléfono</td>
					<td><uc1:uctelefono id="ctrlTelefono" runat="server"></uc1:uctelefono></td>
				</tr>
				<tr>
					<td align="right">Email&nbsp;</td>
					<td><asp:textbox id="txtEmail" runat="server" Width="175px"></asp:textbox><asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" Display="Dynamic" ErrorMessage="Email inválido"
							ControlToValidate="txtEmail" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">*</asp:regularexpressionvalidator><asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtEmail" Display="Dynamic"
							ErrorMessage="El email es requerido.">*</asp:requiredfieldvalidator></td>
					<td align="right">&nbsp;Fax</td>
					<td><uc1:uctelefono id="ctrlFax" runat="server"></uc1:uctelefono></td>
				</tr>
				<tr>
					<td align="right">Contacto</td>
					<td><asp:label cssClass="labelData" id="lblContacto" runat="server"></asp:label></td>
					<td align="right">&nbsp;Cargo</td>
					<td><asp:textbox id="txtCargo" runat="server" Width="150px"></asp:textbox><asp:requiredfieldvalidator id="RequiredFieldValidator2" runat="server" ControlToValidate="txtCargo" Display="Dynamic"
							ErrorMessage="El cargo es requerido.">*</asp:requiredfieldvalidator></td>
				</tr>
				<TR>
					<TD height="15"></TD>
					<TD height="15"></TD>
					<TD height="15"></TD>
					<TD height="15"></TD>
				</TR>
				<TR>
					<TD class="subHeader" colSpan="4">Notificación de pagos(facturas)</TD>
				</TR>
				<TR>
					<TD></TD>
					<TD></TD>
					<TD></TD>
					<TD></TD>
				</TR>
				<TR>
					<td colSpan="4">
						<table class="td-note" cellSpacing="3" cellPadding="0" width="100%">
							<TR>
								<TD align="right">Nro. Notificación</TD>
								<TD><asp:textbox id="txtNotificacion1" runat="server"></asp:textbox>&nbsp;<asp:requiredfieldvalidator id="RequiredFieldValidator3" runat="server" ControlToValidate="txtNotificacion1"
										Display="Dynamic" ErrorMessage="El Nro. de notificación es requerido.">*</asp:requiredfieldvalidator>
									<asp:RadioButton id="rbtnRecargos1" runat="server" Text="Cancelar Recargos" GroupName="Notificacion1"></asp:RadioButton>&nbsp;
									<asp:RadioButton id="rbtnFactura1" runat="server" Text="Cancelar Factura" GroupName="Notificacion1"></asp:RadioButton></TD>
							</TR>
							<TR>
								<TD align="right">Nro. Notificación</TD>
								<TD><asp:textbox id="txtNotificacion2" runat="server"></asp:textbox>&nbsp;
									<asp:RadioButton id="rbtnRecargos2" runat="server" Text="Cancelar Recargos" GroupName="Notificacion2"></asp:RadioButton>&nbsp;
									<asp:RadioButton id="rbtnFactura2" runat="server" Text="Cancelar Factura" GroupName="Notificacion2"></asp:RadioButton></TD>
							</TR>
							<TR>
								<TD align="right">Nro. Notificación</TD>
								<TD><asp:textbox id="txtNotificacion3" runat="server"></asp:textbox>&nbsp;
									<asp:RadioButton id="rbtnRecargos3" runat="server" Text="Cancelar Recargos" GroupName="Notificacion3"></asp:RadioButton>&nbsp;
									<asp:RadioButton id="rbtnFactura3" runat="server" Text="Cancelar Factura" GroupName="Notificacion3"></asp:RadioButton></TD>
							</TR>
							<TR>
								<TD align="right">Nro. Notificación</TD>
								<TD><asp:textbox id="txtNotificacion4" runat="server"></asp:textbox>&nbsp;
									<asp:RadioButton id="rbtnRecargos4" runat="server" Text="Cancelar Recargos" GroupName="Notificacion4"></asp:RadioButton>&nbsp;
									<asp:RadioButton id="rbtnFactura4" runat="server" Text="Cancelar Factura" GroupName="Notificacion4"></asp:RadioButton></TD>
							</TR>
							<TR>
								<TD align="right">Nro. Notificación</TD>
								<TD><asp:textbox id="txtNotificacion5" runat="server"></asp:textbox>&nbsp;
									<asp:RadioButton id="rbtnRecargos5" runat="server" Text="Cancelar Recargos" GroupName="Notificacion5"></asp:RadioButton>&nbsp;
									<asp:RadioButton id="rbtnFactura5" runat="server" Text="Cancelar Factura" GroupName="Notificacion5"></asp:RadioButton></TD>
							</TR>
							<TR>
								<TD align="right">Nro. Notificación</TD>
								<TD><asp:textbox id="txtNotificacion6" runat="server"></asp:textbox>&nbsp;
									<asp:RadioButton id="rbtnRecargos6" runat="server" Text="Cancelar Recargos" GroupName="Notificacion6"></asp:RadioButton>&nbsp;
									<asp:RadioButton id="rbtnFactura6" runat="server" Text="Cancelar Factura" GroupName="Notificacion6"></asp:RadioButton></TD>
							</TR>
							<TR>
								<TD align="right">Nro. Notificación</TD>
								<TD><asp:textbox id="txtNotificacion7" runat="server"></asp:textbox>&nbsp;
									<asp:RadioButton id="rbtnRecargos7" runat="server" Text="Cancelar Recargos" GroupName="Notificacion7"></asp:RadioButton>&nbsp;
									<asp:RadioButton id="rbtnFactura7" runat="server" Text="Cancelar Factura" GroupName="Notificacion7"></asp:RadioButton></TD>
							</TR>
							<TR>
								<TD align="right">Nro. Notificación</TD>
								<TD><asp:textbox id="txtNotificacion8" runat="server"></asp:textbox>&nbsp;
									<asp:RadioButton id="rbtnRecargos8" runat="server" Text="Cancelar Recargos" GroupName="Notificacion8"></asp:RadioButton>&nbsp;
									<asp:RadioButton id="rbtnFactura8" runat="server" Text="Cancelar Factura" GroupName="Notificacion8"></asp:RadioButton></TD>
							</TR>
						</table>
					</td>
				</TR>
				<TR>
					<TD class="subHeader" colSpan="4" height="10"></TD>
				</TR>
				<TR>
					<TD class="subHeader" colSpan="4">Motivo de la Solicitud</TD>
				</TR>
				<TR>
					<TD></TD>
					<TD></TD>
					<TD></TD>
					<TD></TD>
				</TR>
				<TR>
					<TD colSpan="4"><asp:textbox id="txtMotivo" runat="server" Width="408px" Height="56px" TextMode="MultiLine" EnableViewState="False"></asp:textbox></TD>
				</TR>
				<TR>
					<TD colSpan="4"><asp:label cssClass="error" id="lblMensaje" runat="server" EnableViewState="False"></asp:label></TD>
				</TR>
				<TR>
					<TD colSpan="4"><asp:validationsummary id="ValidationSummary1" runat="server" EnableViewState="False" Width="100%"></asp:validationsummary></TD>
				</TR>
				<TR>
					<TD align="center" colSpan="4"><asp:button id="btnAceptar" runat="server" Text="Aceptar"></asp:button>&nbsp;<INPUT onclick="javascript:location.href='Solicitudes.aspx'" type="button" value="Cancelar" class="Button"></TD>
				</TR>
			</table>
		</TD>
		</TR>
		</table>			
</asp:Content>

