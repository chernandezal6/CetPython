<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="EstadodeCuenta.aspx.vb" Inherits="Solicitudes_EstadodeCuenta" title="Estado de Cuenta" %>
<%@ Register TagPrefix="uc1" TagName="UCTelefono" Src="../Controles/UCTelefono.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<br />
	<br />
	       <div align="center" class="header">Estado de Cuenta</div>
	       <br />
	<table align="center" id="table4" cellSpacing="3" cellPadding="0" width="550" border="0">
		<TR>
		<TD>

			<TABLE class="td-content" id="Table1" cellSpacing="1" cellPadding="2" width="100%" border="0">
				<TR>
					<TD class="subHeader" align="left" width="22%" colSpan="2">Datos de la Empresa</TD>
				</TR>
				<TR>
					<TD align="right" width="22%"></TD>
					<TD></TD>
				</TR>
				<TR>
					<TD align="right" width="22%">Tipo Solicitud&nbsp;</TD>
					<TD><asp:label cssClass="labelData" id="lblSolicitud" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD align="right" width="22%">RNC&nbsp;</TD>
					<TD><asp:label cssClass="labelData" id="lblRNC" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD align="right" width="22%">Razón Social&nbsp;</TD>
					<TD><asp:label cssClass="labelData" id="lblRazonSocial" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD align="right">Nombre Comercial&nbsp;</TD>
					<TD><asp:label cssClass="labelData" id="lblNombreComercial" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD align="right">Ced. Representante&nbsp;</TD>
					<TD><asp:label cssClass="labelData" id="lblCedRepresentante" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD align="right">Representante&nbsp;</TD>
					<TD><asp:label cssClass="labelData" id="lblRepresentante" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD></TD>
					<TD><asp:label cssClass="error" id="lblMensaje" runat="server" EnableViewState="False"></asp:label></TD>
				</TR>
                <tr>
                    <td class="subHeader" colspan="2">
                    </td>
                </tr>
                <tr>
                    <td class="subHeader" colspan="2">
                    </td>
                </tr>
				<TR>
					<TD class="subHeader" colSpan="2">Deuda por Concepto de Seguridad Social</TD>
				</TR>
				<TR>
					<TD></TD>
					<TD></TD>
				</TR>
				<TR>
					<TD colSpan="2"><asp:GridView id="gvTSS" runat="server" Visible="False" AutoGenerateColumns="False" CssClass="list"
							Width="100%" ShowFooter="True">
							<Columns>
								<asp:BoundField DataField="PERIODO_FACTURA" HeaderText="Per&#237;odo">
									<HeaderStyle Width="100px" HorizontalAlign="Center"></HeaderStyle>
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="ID_REFERENCIA" HeaderText="Referencia">
									<HeaderStyle Width="150px" HorizontalAlign="Center"></HeaderStyle>
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="NOMINA_DES" HeaderText="N&#243;mina">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="TOTAL_GENERAL" HeaderText="Monto" DataFormatString="{0:c}" HtmlEncode="False">
									<HeaderStyle Width="150px" HorizontalAlign="Right"></HeaderStyle>
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:BoundField>
							</Columns>
						</asp:GridView></TD>
				</TR>
				<TR>
					<TD></TD>
					<TD></TD>
				</TR>
				<TR>
					<TD class="subHeader" colSpan="2">Deuda por Concepto de Retenciones de ISR</TD>
				</TR>
				<TR>
					<TD></TD>
					<TD></TD>
				</TR>
				<TR>
					<TD colSpan="2"><asp:GridView id="gvDGII" runat="server" AutoGenerateColumns="False" CssClass="list" Width="100%"
							ShowFooter="True">
							<Columns>
								<asp:BoundField DataField="PERIODO_FACTURA" HeaderText="Per&#237;odo">
									<HeaderStyle Width="100px" HorizontalAlign="Center"></HeaderStyle>
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="ID_REFERENCIA" HeaderText="Referencia">
									<HeaderStyle Width="150px" HorizontalAlign="Center"></HeaderStyle>
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="NOMINA_DES" HeaderText="Concepto">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="TOTAL_GENERAL" HeaderText="Monto" DataFormatString="{0:c}" HtmlEncode="False">
									<HeaderStyle Width="150px" HorizontalAlign="Right"></HeaderStyle>
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:BoundField>
							</Columns>
						</asp:GridView></TD>
				</TR>
				<TR>
					<TD></TD>
					<TD></TD>
				</TR>
				<TR>
					<TD class="subHeader" colSpan="2">Deuda por Concepto de Retenciones de IR17</TD>
				</TR>
				<TR>
					<TD></TD>
					<TD></TD>
				</TR>
				<TR>
					<TD colSpan="2"><asp:GridView id="gvIR17" runat="server" AutoGenerateColumns="False" CssClass="list" Width="100%"
							ShowFooter="True">
							<Columns>
								<asp:BoundField DataField="PERIODO_FACTURA" HeaderText="Per&#237;odo">
									<HeaderStyle Width="100px" HorizontalAlign="Center"></HeaderStyle>
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="ID_REFERENCIA" HeaderText="Referencia">
									<HeaderStyle Width="150px" HorizontalAlign="Center"></HeaderStyle>
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="NOMINA_DES" HeaderText="Concepto">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="TOTAL_GENERAL" HeaderText="Monto" DataFormatString="{0:c}" HtmlEncode="False">
									<HeaderStyle Width="150px" HorizontalAlign="Right"></HeaderStyle>
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:BoundField>
							</Columns>
						</asp:GridView></TD>
				</TR>
				<TR>
					<TD></TD>
					<TD></TD>
				</TR>
				<TR>
					<TD align="left" colSpan="2" style="height: 70px">
						
							<asp:Label id="lblTextoEmail" runat="server" Font-Bold="True">Desea recibir su estado de cuentas por:</asp:Label>&nbsp;<asp:button id="btEmail" runat="server" Text="Email"></asp:button>&nbsp;<STRONG>o</STRONG>&nbsp;<asp:button id="btFax" runat="server" Text="Fax"></asp:button>
                            <STRONG>?&nbsp;
							</STRONG>&nbsp;<asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button>
						<asp:Label id="lblDeseo" runat="server" EnableViewState="False"><P>Si no desea recibir su estado de cuentas, proceder con el cierre de la llamada de la siguiente forma:</p></asp:Label>
					</TD>
				</TR>
				<TR>
					<TD colSpan="2"><asp:panel id="pnlFax" runat="server" Visible="False" Width="100%">
							<TABLE id="Table2" cellSpacing="2" cellPadding="1" width="100%">

								<TR>
									<TD align="right" width="25%">Número de Fax:</TD>
									<TD>
										<uc1:UCTelefono id="ctrlFax" runat="server"></uc1:UCTelefono>
										<asp:TextBox id="txtFax" runat="server" Width="40px"></asp:TextBox></TD>
								</TR>
								<TR>
									<TD align="right" width="25%" style="height: 62px">Comentario</TD>
									<TD style="height: 62px">
										<asp:TextBox id="txtFaxComentario" runat="server" Width="312px" TextMode="MultiLine" Height="52px"></asp:TextBox></TD>
								</TR>
								<TR>
									<TD align="center" colSpan="2">
                                        <br />
										<asp:Button id="btActFax" runat="server" Text="Enviar Solicitud"></asp:Button></TD>
								</TR>
							</TABLE>
						</asp:panel><asp:panel id="pnlEmail" runat="server" Visible="False" Width="100%">
							<TABLE id="Table3" cellSpacing="2" cellPadding="1" width="100%">
								<TR>
									<TD align="left" width="25%" colSpan="2"><STRONG>El Correo Electrónico que tenemos 
											registrado es:</STRONG>
										<asp:label cssClass="labelData" id="lblCorreoActual" runat="server"></asp:label>, <STRONG>
											¿Desea cambiarlo?</STRONG></TD>
								</TR>
								<TR>
									<TD align="right" width="25%" colSpan="2">&nbsp;</TD>
								</TR>
								<TR>
									<TD align="left" width="25%" colSpan="2">Si desea cambiarlo digite el nuevo correo, 
										de lo contrario pulse el botón "Enviar Solicitud"</TD>
								</TR>
								<TR>
									<TD align="right" width="25%">Nuevo Correo Electrónico:</TD>
									<TD style="width: 321px">
										<asp:textbox id="txtNuevoCorreo" runat="server" width="200px"></asp:textbox>
										<asp:RegularExpressionValidator id="RegularExpressionValidator3" runat="server" Display="Dynamic" ControlToValidate="txtNuevoCorreo"
											ErrorMessage="Email Inválido" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator></TD>
								</TR>
								<TR>
									<TD align="right" width="25%">Confirmación Correo Electrónico:</TD>
									<TD style="width: 321px">
										<asp:textbox id="txtConfirmacion" runat="server" width="200px"></asp:textbox>
										<asp:CompareValidator id="CompareValidator1" runat="server" Display="Dynamic" ControlToValidate="txtConfirmacion"
											ErrorMessage="Debe ser igual al nuevo correo." ControlToCompare="txtNuevoCorreo"></asp:CompareValidator></TD>
								</TR>
								<TR>
									<TD align="right" width="25%">Comentario</TD>
									<TD style="width: 321px">
										<asp:TextBox id="txtEmailComentario" runat="server" Width="312px" TextMode="MultiLine" Height="52px"></asp:TextBox></TD>
								</TR>
								<TR>
									<TD align="center" colSpan="2">
                                        <br />
										<asp:Button id="btActEmail" runat="server" Text="Enviar Solicitud"></asp:Button></TD>
								</TR>
							</TABLE>
						</asp:panel>
						<P><STRONG>"Algo mas en lo que pueda ayudar?". </STRONG>
						</P>
						<P>Si la respuesta es sí, dar las informaciones de lugar, de lo contrario:</P>
						<P>
							<asp:Label id="lblAdios" runat="server" Font-Bold="True">_______________ le asistió tenga un feliz resto del día!</asp:Label></P>
					</TD>
				</TR>
			</TABLE>
			
	</TD>
	</TR>
	</TABLE>			
</asp:Content>

