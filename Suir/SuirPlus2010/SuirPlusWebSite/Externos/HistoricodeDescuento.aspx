<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="HistoricodeDescuento.aspx.vb" Inherits="Externos_HistoricodeDescuento" title="Historico de Descuento - TSS" %>

<%@ Register Src="../Controles/ucInfoEmpleado.ascx" TagName="ucInfoEmpleado" TagPrefix="uc2" %>
<%@ Register TagPrefix="uc1" TagName="ucExportarExcel" Src="../Controles/ucExportarExcel.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

		<script language="vb" runat="server">
			Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
		        'PermisoRequerido = 89
			End Sub
		</script>


<div class="header">Histórico de descuentos por afiliado</div>
<br />

						<TABLE class="td-content" id="Table1">
							<TR>
								<TD style="text-align: right">Cédula o NSS:</TD>
								<TD style="width: 232px"><asp:textbox id="txtCedulaNSS" runat="server" MaxLength="11"></asp:textbox><asp:requiredfieldvalidator id="reqTxtRef" runat="server" ControlToValidate="txtCedulaNSS">*</asp:requiredfieldvalidator><br />
                                    <asp:regularexpressionvalidator id="regExpRncCedula" runat="server" ControlToValidate="txtCedulaNSS" Display="Dynamic"
										ValidationExpression="^(\d{9}|\d{11})$" ErrorMessage="NSS o Cédula invalido."></asp:regularexpressionvalidator></TD>
								
							</TR>
							<TR>
								<TD style="text-align: right">RNC Empleador:</TD>
								<TD style="width: 232px"><asp:textbox id="txtEmpleador" runat="server" MaxLength="11"></asp:textbox>&nbsp;<asp:regularexpressionvalidator id="Regularexpressionvalidator1" runat="server" ControlToValidate="txtEmpleador"
										Display="Dynamic" ValidationExpression="^(\d{9}|\d{11})$" ErrorMessage="RNC o Cédula invalido."></asp:regularexpressionvalidator></TD>
								
							</TR>
							<TR>
								<TD style="text-align: right">Año del Descuento:</TD>
								<TD style="width: 232px"><asp:textbox id="txtAno" runat="server" MaxLength="4" Width="64px"></asp:textbox>&nbsp;<asp:regularexpressionvalidator id="RegularExpressionValidator2" runat="server" ControlToValidate="txtAno" Display="Dynamic"
										ValidationExpression="^(\d{4})$" ErrorMessage="El año debe ser númerico"></asp:regularexpressionvalidator></TD>
								
							</TR>
							<TR>
								<TD colSpan="2" style="text-align: center"><asp:button id="btnConsultar" runat="server" Text="Consultar"></asp:button>
                                    <asp:Button ID="btnLimpiar" runat="server" CausesValidation="False" Text="Limpiar" /><br />
                                </TD>
							</TR>
						</TABLE>
    <asp:Label ID="lblMsg" runat="server" CssClass="error"></asp:Label><br />
                            <asp:panel id="pnlConsulta" Runat="server" Width="500px">
							<TABLE class="td-content" id="Table2" cellSpacing="0" cellPadding="0" width="500">
                                <tr>
                                    <td align="right" style="height: 12px" width="10%">
                                        Empleado:</td>
                                    <td style="height: 12px; width: 81px;" colspan="3" nowrap="noWrap">
                                        <asp:label cssclass="labelData" id="lblEmpleado" runat="server" Width="547%"></asp:label></td>
                                </tr>
								<TR>
									<TD style="HEIGHT: 12px" align="right" width="10%">
                                        NSS:</TD>
									<TD style="HEIGHT: 12px; width: 99px;"><asp:label cssclass="labelData" id="lblNSS" runat="server"></asp:label></TD>
									<TD style="HEIGHT: 12px; width: 18%;" align="right"></TD>
									<TD style="HEIGHT: 12px"></TD>
								</TR>
								<TR>
									<TD align="right" width="10%">Cédula:</TD>
									<TD style="width: 99px"><asp:label cssclass="labelData" id="lblCedula" runat="server"></asp:label></TD>
									<TD align="right" style="width: 18%">Fecha Nacimiento:</TD>
									<TD><asp:label cssclass="labelData" id="lblFechaNacimiento" runat="server"></asp:label></TD>
								</TR>
							</TABLE>
                                <br />
							<TABLE cellSpacing="0" cellPadding="0" width="100%">
								<TR>
									<TD><BR>
										<asp:GridView id="gvHistorico" runat="server" Width="100%" EnableViewState="False" AutoGenerateColumns="False">
	
											<Columns>
												<asp:Boundfield DataField="id_referencia" HeaderText="Referencia">
													<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                    <ItemStyle HorizontalAlign="Center" />
												</asp:Boundfield>
												<asp:Boundfield DataField="periodo_factura" HeaderText="Per&#237;odo">
													<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
													<ItemStyle HorizontalAlign="Center"></ItemStyle>
												</asp:Boundfield>
												<asp:Boundfield DataField="id_tipo_factura" HeaderText="Tipo">
													<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
													<ItemStyle HorizontalAlign="Center"></ItemStyle>
												</asp:Boundfield>
												<asp:Boundfield DataField="fecha_limite_pago" HeaderText="L&#237;mite" DataFormatString="{0:d}" HtmlEncode="False">
													<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
													<ItemStyle HorizontalAlign="Center"></ItemStyle>
												</asp:Boundfield>
												<asp:Boundfield DataField="fecha_pago" HeaderText="Pagada" DataFormatString="{0:d}" HtmlEncode="False">
													<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
													<ItemStyle HorizontalAlign="Center"></ItemStyle>
												</asp:Boundfield>
												<asp:Boundfield DataField="Pago_retrasado" HeaderText="Retrasado">
													<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
													<ItemStyle HorizontalAlign="Center"></ItemStyle>
												</asp:Boundfield>
												<asp:Boundfield DataField="rnc_o_cedula" HeaderText="RNC">
													<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                    <ItemStyle HorizontalAlign="Center" />
												</asp:Boundfield>
												<asp:Boundfield DataField="razon_social" HeaderText="Raz&#243;n Social" >
													<HeaderStyle HorizontalAlign="Center" Wrap="False"></HeaderStyle>
                                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
												</asp:Boundfield>
												<asp:Boundfield DataField="salario_ss" HeaderText="Salario" DataFormatString="{0:c}" HtmlEncode="False">
													<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
													<ItemStyle HorizontalAlign="Right"></ItemStyle>
												</asp:Boundfield>
											</Columns>
										</asp:GridView></TD>
								</TR>
							</TABLE>
                                <br />

									<TABLE class="td-content" id="Table4" cellSpacing="0" cellPadding="0" width="400">
										<TR>
											<TD align="center" style="width: 247px; height: 12px;" colspan="2"><SPAN class="LabelDataGreen">Leyenda tipo de Referencia</SPAN>
											</TD>
										</TR>
										<TR>
											<TD style="width: 247px; height: 86px">
												<TABLE id="Table5" cellSpacing="0" cellPadding="0" width="100%">
													<TR>
														<TD style="HEIGHT: 12px" width="5%">O</TD>
														<TD style="HEIGHT: 12px">Ordinaria</TD>
													</TR>
													<TR>
														<TD width="5%">A</TD>
														<TD>Autodeterminada</TD>
													</TR>
													<TR>
														<TD width="5%">N</TD>
														<TD>Por novedad atrasada</TD>
													</TR>
													<TR>
														<TD width="5%">U</TD>
														<TD>Por auditoría</TD>
													</TR>
													<TR>
														<TD style="HEIGHT: 3px" width="5%">R</TD>
														<TD style="HEIGHT: 3px">Recalculada por novedades</TD>
													</TR>
													<TR>
														<TD width="5%">C</TD>
														<TD>Por cancelación de recargos</TD>
													</TR>
													<TR>
													</TR>
													<TR>
													</TR>
													<TR>
													</TR>
												</TABLE>
											</TD>
											<TD style="height: 86px"><uc1:ucexportarexcel id="Ucexportarexcel" runat="server"></uc1:ucexportarexcel></TD>
										</TR>
									</TABLE>
					</asp:panel>
		
</asp:Content>

