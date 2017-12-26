<%@ Page Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false" CodeFile="SolEstadoCuentasRnc.aspx.vb" Inherits="sys_SolEstadoCuentasRnc" title="Estado de Cuentas por RNC" %>
<%@ Register TagPrefix="uc1" TagName="UCTelefono" Src="../Controles/UCTelefono.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
			<span class="header">Estado de Cuentas por RNC</span><br/><br/>
			<table class="td-content" id="table1" cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td>
						<table cellspacing="2" cellpadding="1">
							<tr>
								<td align="right">RNC/Cédula:</td>
								<td>&nbsp;<asp:textbox id="txtRnc" runat="server" Width="88px" MaxLength="11"></asp:textbox>
									<asp:requiredfieldvalidator id="RequiredFieldValidator2" runat="server" ErrorMessage="*" ControlToValidate="txtRnc"
										Display="Dynamic"></asp:requiredfieldvalidator><asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" ErrorMessage="*" ControlToValidate="txtRnc"
										Display="Dynamic" ValidationExpression="^(\d{9}|\d{11})$">RNC o Cédula Inválida.</asp:regularexpressionvalidator></td>
							</tr>
							<tr>
								<td  align="right">Cédula Representante:</td>
								<td>&nbsp;<asp:textbox id="txtCedula" runat="server" Width="88px" MaxLength="11"></asp:textbox>
									<asp:requiredfieldvalidator id="Requiredfieldvalidator1" runat="server" ErrorMessage="*" ControlToValidate="txtCedula"
										Display="Dynamic"></asp:requiredfieldvalidator><asp:regularexpressionvalidator id="Regularexpressionvalidator2" runat="server" ErrorMessage="*" ControlToValidate="txtCedula"
										Display="Dynamic" ValidationExpression="^(\d{9}|\d{11})$">Cédula Inválida.</asp:regularexpressionvalidator></td>
							</tr>
							<tr align="center">
								<td align="center" colspan="2">
									<asp:button id="btnConsultar" runat="server" Text="Consultar"></asp:button>
								</td>
							</tr>
						</table>
						<asp:panel id="pnlInfo" runat="server" Visible="False">
							<table cellspacing="2" cellpadding="1">
								<tr>
									<td align="left" colspan="2">
										<b>Datos de la Empresa</b>
									</td>
								</tr>
								<tr>
									<td align="right">Razón Social:</td>
									<td>&nbsp;
										<asp:label cssclass="labelData" id="lblRazonSocial" runat="server" Visible="False"></asp:label></td>
								</tr>
								<tr>
									<td align="right">Nombre Comercial:</td>
									<td>&nbsp;
										<asp:label cssclass="labelData" id="lblNombreComercial" runat="server" Visible="False"></asp:label></td>
								</tr>
								<tr>
									<td align="right">Representante:</td>
									<td>&nbsp;
										<asp:label cssclass="labelData" id="lblRepresentante" runat="server" Visible="False"></asp:label></td>
								</tr>
							</table>
							<asp:panel id="pnlEstadoCuenta" Visible="false" Runat="server">
								<table cellspacing="2" cellpadding="1">
									<tr>
										<td align="center"><b>Deuda por Concepto de Seguridad Social</b><br/>
											<asp:gridview id="dgTSS" runat="server" Visible="False" ShowFooter="True" AutoGenerateColumns="False" CssClass="list">
												<Columns>
													<asp:BoundField DataField="PERIODO_FACTURA" HeaderText="Per&#237;odo">
														<HeaderStyle Width="100px"></HeaderStyle>
														<ItemStyle HorizontalAlign="Center"></ItemStyle>
													</asp:BoundField>
													<asp:BoundField DataField="ID_REFERENCIA" HeaderText="Referencia">
														<HeaderStyle Width="150px"></HeaderStyle>
														<ItemStyle HorizontalAlign="Left"></ItemStyle>
													</asp:BoundField>
													<asp:BoundField DataField="NOMINA_DES" HeaderText="N&#243;mina">
														<HeaderStyle Width="150px"></HeaderStyle>
														<ItemStyle HorizontalAlign="Left"></ItemStyle>
													</asp:BoundField>
													<asp:BoundField DataField="TOTAL_GENERAL" HeaderText="Monto" DataFormatString="{0:c}" HtmlEncode="false">
														<HeaderStyle Width="150px"></HeaderStyle>
														<ItemStyle HorizontalAlign="Right"></ItemStyle>
													</asp:BoundField>
												</Columns>
											</asp:gridview></td>
									</tr>
								</table>
								<table cellspacing="2" cellpadding="1">
									<tr>
										<td align="center"><b><br/>
												Deuda por Concepto de Retenciones de ISR<br/>
											</b>
											<asp:gridview id="dgDGII" runat="server" Visible="False" ShowFooter="True" AutoGenerateColumns="False" CssClass="list">
												<Columns>
													<asp:BoundField DataField="PERIODO_FACTURA" HeaderText="Per&#237;odo">
														<HeaderStyle Width="100px"></HeaderStyle>
														<ItemStyle HorizontalAlign="Center"></ItemStyle>
													</asp:BoundField>
													<asp:BoundField DataField="ID_REFERENCIA" HeaderText="Referencia">
														<HeaderStyle Width="150px"></HeaderStyle>
														<ItemStyle HorizontalAlign="Left"></ItemStyle>
													</asp:BoundField>
													<asp:BoundField DataField="NOMINA_DES" HeaderText="Concepto">
														<HeaderStyle Width="150px"></HeaderStyle>
														<ItemStyle HorizontalAlign="Left"></ItemStyle>
													</asp:BoundField>
													<asp:BoundField DataField="TOTAL_GENERAL" HeaderText="Monto" DataFormatString="{0:c}" HtmlEncode="false">
														<HeaderStyle Width="150px"></HeaderStyle>
														<ItemStyle HorizontalAlign="Right"></ItemStyle>
													</asp:BoundField>
												</Columns>
											</asp:gridview></td>
									</tr>
									<tr>
										<td align="center"><b><br/>
												Deuda por Concepto de Retenciones del IR17</b><br/>
											<asp:gridview id="dgIR17" runat="server" Visible="False" ShowFooter="True" AutoGenerateColumns="False" CssClass="list">
												<Columns>
													<asp:BoundField DataField="PERIODO_FACTURA" HeaderText="Per&#237;odo">
														<HeaderStyle Width="100px"></HeaderStyle>
														<ItemStyle HorizontalAlign="Center"></ItemStyle>
													</asp:BoundField>
													<asp:BoundField DataField="ID_REFERENCIA" HeaderText="Referencia">
														<HeaderStyle Width="150px"></HeaderStyle>
														<ItemStyle HorizontalAlign="Left"></ItemStyle>
													</asp:BoundField>
													<asp:BoundField DataField="NOMINA_DES" HeaderText="Concepto">
														<HeaderStyle Width="150px"></HeaderStyle>
														<ItemStyle HorizontalAlign="Left"></ItemStyle>
													</asp:BoundField>
													<asp:BoundField DataField="TOTAL_GENERAL" HeaderText="Monto" DataFormatString="{0:c}" HtmlEncode="false">
														<HeaderStyle Width="150px"></HeaderStyle>
														<ItemStyle HorizontalAlign="Right"></ItemStyle>
													</asp:BoundField>
												</Columns>
											</asp:gridview></td>
									</tr>
								</table>
							</asp:panel>
						</asp:panel><asp:panel id="pnlSeleccion" runat="server" Visible="False">
							<table cellspacing="2" cellpadding="1" >
								<tr>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align="center">
											<asp:Button id="btEmail" runat="server" Text="Enviar Por Email"></asp:Button>
											<asp:Button id="btFax" runat="server" Text="Enviar por Fax"></asp:Button>
											<asp:Button id="btnCancelar" runat="server" Text="Cancelar Operación" CausesValidation="False"></asp:Button>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
								</tr>
							</table>
						</asp:panel><asp:panel id="pnlFax" runat="server" Visible="False">
							<table cellspacing="2" cellpadding="1" >
								<tr>
									<td colspan="2">
										&nbsp;
									</td>
								</tr>
								<tr>
									<td align="right">Número de Fax:</td>
									<td>&nbsp;
										<uc1:UCTelefono id="ctrlFax" runat="server"></uc1:UCTelefono></td>
								</tr>
								<tr>
									<td align="center" colspan="2">
										<asp:Button id="btActFax" runat="server" Text="Enviar Solicitud"></asp:Button>
										<asp:Button id="btnCancelarFax" runat="server" Text="Cancelar" CausesValidation="False"></asp:Button>
									</td>
								</tr>
							</table>
						</asp:panel><asp:panel id="pnlEmail" runat="server" Visible="False">
							<table cellspacing="2" cellpadding="1" >
								<tr>
									<td colspan="2">
										&nbsp;
									</td>
								</tr>
								<tr>
									<td align="right">Correo Electrónico Actual:</td>
									<td>&nbsp;
										<asp:label cssclass="labelData" id="lblCorreoActual" runat="server"></asp:label></td>
								</tr>
								<tr>
									<td style="HEIGHT: 49px" align="right">Nuevo Correo Electrónico:</td>
									<td style="HEIGHT: 49px">&nbsp;
										<asp:textbox id="txtNuevoCorreo" runat="server" width="200px"></asp:textbox>
										<asp:RegularExpressionValidator id="RegularExpressionValidator3" runat="server" Display="Dynamic" ControlToValidate="txtNuevoCorreo"
											ErrorMessage="Email Inválido" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
										<asp:CompareValidator id="CompareValidator1" runat="server" Display="Dynamic" ControlToValidate="txtNuevoCorreo"
											ErrorMessage="Los correos electrónicos deben ser iguales" ControlToCompare="txtConfirmacion"></asp:CompareValidator></td>
								</tr>
								<tr>
									<td align="right">Confirmación Correo Electrónico:</td>
									<td>&nbsp;
										<asp:textbox id="txtConfirmacion" runat="server" width="200px"></asp:textbox>
										<asp:RegularExpressionValidator id="RegularExpressionValidator4" runat="server" Display="Dynamic" ControlToValidate="txtConfirmacion"
											ErrorMessage="Email inválido" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
										<asp:CompareValidator id="CompareValidator2" runat="server" Display="Dynamic" ControlToValidate="txtConfirmacion"
											ErrorMessage="Los correos electrónicos deben ser iguales" ControlToCompare="txtNuevoCorreo"></asp:CompareValidator></td>
								</tr>
								<tr>
									<td align="center" colspan="2">
										<asp:Button id="btActEmail" runat="server" Text="Enviar Solicitud"></asp:Button>
										<asp:Button id="btnCancelarEmail" runat="server" Text="Cancelar" CausesValidation="False"></asp:Button></td>
								</tr>
							</table>
						</asp:panel></td>
				</tr>
			</table>
			<asp:label id="lblError" runat="server" Visible="False" CssClass="error"></asp:label>
</asp:Content>

