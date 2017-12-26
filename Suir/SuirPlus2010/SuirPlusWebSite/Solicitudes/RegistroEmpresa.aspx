<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="RegistroEmpresa.aspx.vb" Inherits="Solicitudes_RegistroEmpresa" title="Registro de Empresas" %>
<%@ Register TagPrefix="uc1" TagName="UCTelefono" Src="../Controles/UCTelefono.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
					<br />
	                  <div align="center" class="header">Solicitud de servicios</div>
                    <br />
			<table align="center" class="td-content" id="table1" cellSpacing="0" cellPadding="0" width="550" border="0">
				<tr>
					<td>

						<table cellSpacing="2" cellPadding="1" width="100%">
							<tr>
								<td align="right" width="25%">Solicitud</td>
								<td>&nbsp;<asp:label class="labelData" id="lblSolicitud" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td align="right">RNC/Cédula</td>
								<td>&nbsp;<asp:label cssClass="labelData" id="lblRnc" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td align="right">Permítame la Razon Social de la empresa:</td>
								<td>&nbsp;<asp:textbox id="txtRazonSocial" runat="server" Width="200px"></asp:textbox>
									<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ErrorMessage="*" ControlToValidate="txtRazonSocial"></asp:RequiredFieldValidator></td>
							</tr>
							<tr>
								<td align="right">Permítame el Nombre Comercial:</td>
								<td>&nbsp;<asp:textbox id="txtNombreComercial" runat="server" Width="200px"></asp:textbox>
									<asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ErrorMessage="*" ControlToValidate="txtNombreComercial"></asp:RequiredFieldValidator></td>
							</tr>
							<tr>
								<td align="right">Ced. Representante</td>
								<td>&nbsp;<asp:label cssClass="labelData" id="lblCedRepresentante" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td align="right">Representante</td>
								<td>&nbsp;<asp:label cssClass="labelData" id="lblRepresentante" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td align="right">Un teléfono donde contactarle:</td>
								<td>
                                    &nbsp;<uc1:uctelefono id="ctrlTelefono1" runat="server"></uc1:uctelefono></td>
							</tr>
							<tr>
								<td align="right">Tiene otro número de teléfono:</td>
								<td>
                                    &nbsp;<uc1:uctelefono id="ctrlTelefono2" runat="server"></uc1:uctelefono></td>
							</tr>
							<TR>
								<TD align="right">Comentario</TD>
								<TD>
									<asp:TextBox id="txtComentario" runat="server" Width="200px" Height="35px"></asp:TextBox></TD>
							</TR>
							<TR align="center">
								<TD align="center" colSpan="2" height="5">
									<asp:Label class="label-Resaltado" id="lblMensaje" runat="server" EnableViewState="False"></asp:Label></TD>
							</TR>
							<TR align="center">
								<TD align="center" colSpan="2">
                                    <br />
                                    <asp:button id="btnCrear" runat="server" Text="Crear Solicitud"></asp:button>&nbsp;<INPUT id="btnCancelar" onclick="javascript:location.href='Solicitudes.aspx'" type="button"
										value="Cancelar" class="Button"></TD>
							</TR>
						</table>
					</td>
				</tr>
			</table>
</asp:Content>

