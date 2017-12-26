<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="RecuperaClave.aspx.vb" Inherits="Solicitudes_RecuperaClave" title="Recupera Clave" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
					<br />
	                  <div align="center" class="header">Recuperación de class</div>
                    <br />
			<TABLE align="center" class="td-content" id="table1" cellSpacing="0" cellPadding="0" width="550" border="0">
				<TR>
					<TD>

						<TABLE id="Table2" cellSpacing="2" cellPadding="1" width="100%">
							<TR>
								<TD align="right" width="25%">Solicitud&nbsp;</TD>
								<TD>
									<asp:label cssClass="labelData" id="lblSolicitud" runat="server"></asp:label></TD>
							</TR>
							<TR>
								<TD align="right">RNC/Cédula&nbsp;</TD>
								<TD>
									<asp:label cssClass="labelData" id="lblRnc" runat="server"></asp:label></TD>
							</TR>
							<TR>
								<TD align="right">Razon Social&nbsp;</TD>
								<TD>
									<asp:label cssClass="labelData" id="lblRazonSocial" runat="server"></asp:label>
								</TD>
							</TR>
							<TR>
								<TD align="right">Nombre Comercial&nbsp;</TD>
								<TD>
									<asp:label cssClass="labelData" id="lblNombreComercial" runat="server"></asp:label>
								</TD>
							</TR>
							<TR>
								<TD align="right">Ced. Representante&nbsp;</TD>
								<TD>
									<asp:label cssClass="labelData" id="lblCedRepresentante" runat="server"></asp:label></TD>
							</TR>
							<TR>
								<TD align="right">Representante&nbsp;</TD>
								<TD>
									<asp:label cssClass="labelData" id="lblRepresentante" runat="server"></asp:label></TD>
							</TR>
							<TR>
								<TD align="right">Comentario&nbsp;</TD>
								<TD>
									<asp:TextBox id="txtComentario" runat="server" Width="235px" Height="35px" MaxLength="400" TextMode="MultiLine"></asp:TextBox></TD>
							</TR>
							<TR align="center">
								<TD align="center" colSpan="2" height="5">
									<asp:Label cssClass="label-Resaltado" id="lblMensaje" runat="server" EnableViewState="False"></asp:Label></TD>
							</TR>
							<TR align="center">
								<TD align="center" colSpan="2">
                                    <br />
									<asp:button id="btnCrear" runat="server" Text="Crear Solicitud"></asp:button>&nbsp;<INPUT id="btnCancelar" onclick="javascript:location.href='Solicitudes.aspx'" type="button"
										value="Cancelar" name="btnCancelar" class="Button"></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>

</asp:Content>

