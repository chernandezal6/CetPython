<%@ Page Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false" CodeFile="ConsultaDeSolicitudes.aspx.vb" Inherits="sys_ConsultaDeSolicitudes" title="Solicitudes en Linea" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
			<span class="header">Solicitudes en Linea</span><br/><br/>
				<table class="td-content" id="tblConsReferencia" cellspacing="1" cellpadding="1"	border="0">
					<tr>
						<td><img height="110" src="../images/CallCenter.jpg" alt="Call Center" width="170" /></td>
						<td>
							<table id="Table2" cellspacing="0" cellpadding="0" width="275" border="0">
								<tr>
									<td colspan="2"></td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td style="HEIGHT: 50px">
										<span style="text-align:right"><asp:label id="Label1" runat="server">Nro. de Solicitud:</asp:label>&nbsp;</span>
									</td>
									<td style="HEIGHT: 50px"><asp:textbox id="txtNroSolicitud" runat="server" Width="147px"></asp:textbox>
										<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ErrorMessage="Nro. de Solicitud Requerido"
											ControlToValidate="txtNroSolicitud" Display="Dynamic"></asp:RequiredFieldValidator></td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td style="HEIGHT: 17px;" align="center" colspan="2">
										<asp:button id="btBuscar" runat="server" Text="Buscar"></asp:button></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<br/>
				<asp:panel id="pnlSolicitudes" Visible="False" Runat="server">
					<table class="td-content" id="Table3" cellspacing="1" cellpadding="1" width="450" border="0">
						<tr>
							<td style="WIDTH: 116px">
								<asp:label id="lblRS" runat="server">Nro. de Solicitud</asp:label></td>
							<td>
								<asp:label id="lblNroSolicitud" runat="server" Font-Bold="True"></asp:label></td>
						</tr>
						<tr>
							<td style="WIDTH: 116px">
								<asp:label id="lblNC" runat="server">Tipo de Solicitud:</asp:label></td>
							<td>
								<asp:label id="lblTipoSolicitud" runat="server" Font-Bold="True"></asp:label></td>
						</tr>
						<tr>
							<td style="WIDTH: 116px">
								<asp:label id="Label2" runat="server">Empresa:</asp:label></td>
							<td>
								<asp:label id="lblRazonSocial" runat="server" Font-Bold="True"></asp:label></td>
						</tr>
						<tr>
							<td style="WIDTH: 116px">
								<asp:label id="Label3" runat="server">Solicitante:</asp:label></td>
							<td>
								<asp:label id="lblSolicitante" runat="server" Font-Bold="True"></asp:label></td>
						</tr>
						<tr>
							<td style="WIDTH: 116px">
								<asp:label id="Label4" runat="server">Comentarios:</asp:label></td>
							<td>
								<asp:label id="lblComentarios" runat="server" Font-Bold="True"></asp:label></td>
						</tr>
					</table>
				</asp:panel>
			<asp:Label id="lblMensaje" runat="server" Visible="False" CssClass="error"></asp:Label>
</asp:Content>

