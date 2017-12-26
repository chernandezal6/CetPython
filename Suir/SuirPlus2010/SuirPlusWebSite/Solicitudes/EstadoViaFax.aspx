<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="EstadoViaFax.aspx.vb" Inherits="Solicitudes_EstadoViaFax" title="Estado de Cuenta Vía Fax" %>
<%@ Register TagPrefix="uc1" TagName="UCTelefono" Src="../Controles/UCTelefono.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
					<br />
	                    <div align="center" class="header">Estado de cuenta vía fax</div>
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
									<asp:label cssClass="labelData" id="lblRazonSocial" runat="server"></asp:label></TD>
							</TR>
							<TR>
								<TD align="right">Nombre Comercial&nbsp;</TD>
								<TD>
									<asp:label cssClass="labelData" id="lblNombreComercial" runat="server"></asp:label></TD>
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
								<TD align="right">Fax&nbsp;</TD>
								<TD>
									<uc1:UCTelefono id="ctrlFax" runat="server"></uc1:UCTelefono></TD>
							</TR>
							<TR>
								<TD align="right">Comentario&nbsp;</TD>
								<TD>
									<asp:TextBox id="txtComentario" runat="server" MaxLength="400" Height="35px" Width="235px" TextMode="MultiLine"></asp:TextBox>
									<asp:TextBox id="txtFax" runat="server" Width="56px" Visible="False"></asp:TextBox></TD>
							</TR>
							<TR align="center">
								<TD align="center" colSpan="2" height="5">
									<asp:Label cssClass="label-Resaltado" id="lblMensaje" runat="server" EnableViewState="False"></asp:Label><br />
                                </TD>
							</TR>
							<TR align="center">
								<TD align="center" colSpan="2">
									<asp:button id="btnCrear" runat="server" Text="Crear Solicitud"></asp:button>&nbsp;<INPUT id="btnCancelar" onclick="javascript:location.href='Solicitudes.aspx'" type="button"
										value="Cancelar" name="btnCancelar" class="Button"></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
</asp:Content>

