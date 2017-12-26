<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="FacturasViaMail.aspx.vb" Inherits="Solicitudes_FacturasViaMail" title="Facturas Vía Mail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	    <div align="center" class="header">
            <br />
            Recibir su Factura por Mail</div>
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
								<TD align="right" colSpan="2">&nbsp;</TD>
							</TR>
							<TR>
								<TD align="right" colSpan="2">
									<P align="left">&nbsp;
										<asp:Label id="lblBefore" runat="server">El Correo electrónico que tenemos registrado es:</asp:Label>
										<asp:label cssClass="labelData" id="lblEmail" runat="server"></asp:label>
										<asp:Label id="lblAfter" runat="server">, desea cambiarlo?.</asp:Label></P>
								</TD>
							</TR>
							<TR>
								<TD align="right" colSpan="2">&nbsp;</TD>
							</TR>
							<TR>
								<TD align="right" colSpan="2">
									<P align="left">Si desea cambiarlo digite el nuevo correo, de lo contrario pulse el 
										botón "Crear Solicitud".</P>
								</TD>
							</TR>
							<TR>
								<TD align="right">Nuevo Correo</TD>
								<TD>
									<asp:TextBox id="txtEmail" runat="server" Width="200px"></asp:TextBox>
									<asp:RegularExpressionValidator id="RegularExpressionValidator1" runat="server" ErrorMessage="Correo inválido" Display="Dynamic"
										ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ControlToValidate="txtEmail"></asp:RegularExpressionValidator></TD>
							</TR>
							<TR>
								<TD align="right">Confirmación</TD>
								<TD>
									<asp:TextBox id="txtCfonfirmaEmail" runat="server" Width="200px"></asp:TextBox>
									<asp:RegularExpressionValidator id="RegularExpressionValidator2" runat="server" ErrorMessage="Correo inválido" Display="Dynamic"
										ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ControlToValidate="txtCfonfirmaEmail"></asp:RegularExpressionValidator>
									<asp:CompareValidator id="CompareValidator1" runat="server" ErrorMessage="Debe ser igual al nuevo correo."
										Display="Dynamic" ControlToValidate="txtCfonfirmaEmail" ControlToCompare="txtEmail"></asp:CompareValidator></TD>
							</TR>
							<TR>
								<TD align="right">Comentario</TD>
								<TD>
									<asp:TextBox id="txtComentario" runat="server" TextMode="MultiLine" MaxLength="400" Height="35px"
										Width="235px"></asp:TextBox></TD>
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

