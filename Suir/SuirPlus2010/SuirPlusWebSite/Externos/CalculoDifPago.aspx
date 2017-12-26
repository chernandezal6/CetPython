<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CalculoDifPago.aspx.vb" Inherits="Externos_CalculoDifPago" title="Cálculo Diferencia en Pago - TSS" %>
<%@ Register TagPrefix="uc1" TagName="ucExportarExcel" Src="../Controles/ucExportarExcel.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

		<script language="vb" runat="server">
				Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
					
					'Me.PermisoRequerido = 136
					
				End Sub
		</script>

			<TABLE id="Table1">
				<TR>
					<TD class="header">Cálculo de&nbsp;Diferencia en Pago</TD>
				</TR>
				<TR>
					<TD style="height: 5px"></TD>
				</TR>
			</TABLE>
			<TABLE class="td-content" id="Table2" cellSpacing="0" cellPadding="0">
				<TR>
					<TD rowSpan="4">&nbsp;<IMG src="../images/calcfactura.jpg" width="167" height="90"></TD>
					<TD style="width: 232px">
						<TABLE id="Table3" cellSpacing="1" cellPadding="0">
							<TR>
								<TD nowrap="noWrap">
									No. de referencia:
								</TD>
								<TD><asp:textbox id="txtReferencia" runat="server" MaxLength="16"></asp:textbox><asp:requiredfieldvalidator id="reqTxtReferencia" runat="server" Display="Dynamic" ControlToValidate="txtReferencia">*</asp:requiredfieldvalidator><br />
			<asp:regularexpressionvalidator id="regExpReferencia" runat="server" Display="Dynamic" ControlToValidate="txtReferencia"
				ValidationExpression="^(\d{16})$" ErrorMessage="No. de referencia inválido."></asp:regularexpressionvalidator></TD>
							</TR>
							<TR>
								<TD>
									Cédula o NSS:
								</TD>
								<TD><asp:textbox id="txtCedula" runat="server" MaxLength="11" Width="88px"></asp:textbox><asp:requiredfieldvalidator id="reqTxtCedula" runat="server" Display="Dynamic" ControlToValidate="txtReferencia">*</asp:requiredfieldvalidator><br />
			<asp:regularexpressionvalidator id="regExpRncCedula" runat="server" Display="Dynamic" ControlToValidate="txtCedula"
				ValidationExpression="^(\d{9}|\d{11})$" ErrorMessage="No. de cédula o nss  inválido."></asp:regularexpressionvalidator></TD>
							</TR>
							<TR>
								<TD>
									Salario pagado:
								</TD>
								<TD><asp:textbox id="txtSalario" runat="server" MaxLength="10" Width="88px"></asp:textbox><asp:requiredfieldvalidator id="reqTxtSalario" runat="server" Display="Dynamic" ControlToValidate="txtSalario">*</asp:requiredfieldvalidator><br />
			<asp:regularexpressionvalidator id="regTxtSalario" runat="server" Display="Dynamic" ControlToValidate="txtSalario"
				ValidationExpression="^\d*\.{0,1}\d+$" ErrorMessage="Formato de salario inválido intente: 9999.99"></asp:regularexpressionvalidator></TD>
							</TR>
							<TR>
								<TD nowrap="noWrap">
									Aporte Voluntario:
								</TD>
								<TD><asp:textbox id="txtAporte" runat="server" MaxLength="10" Width="88px"></asp:textbox><asp:requiredfieldvalidator id="reqTxtAporteVol" runat="server" Display="Dynamic" ControlToValidate="txtAporte">*</asp:requiredfieldvalidator><br />
			<asp:regularexpressionvalidator id="Regularexpressionvalidator1" runat="server" Display="Dynamic" ControlToValidate="txtAporte"
				ValidationExpression="^\d*\.{0,1}\d+$" ErrorMessage="Formato del aporte inválido intente: 9999.99"></asp:regularexpressionvalidator></TD>
							</TR>
							<TR>
								<TD align="center" colSpan="2"><asp:button id="btnConsultar" runat="server" Text="Recalcular"></asp:button>&nbsp;<asp:button id="btnCancelar" runat="server" Text="Cancelar"></asp:button></TD>
							</TR>
							<TR>
								<TD align="center" colSpan="2"></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
			
			<asp:label id="lblError" runat="server" CssClass="error"></asp:label><asp:panel id="pnlDatagrid" runat="server" Visible="False"><BR>
				
				<TABLE class="td-content" id="table4" cellSpacing="0" cellPadding="0" width="550" border="0">
					<TR>
						<TD width="15%">Trabajador</TD>
						<TD colSpan="5">
							<asp:Label id="lblTrabajador" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="15%">Razón Social</TD>
						<TD colSpan="5">
							<asp:Label id="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="15%">RNC</TD>
						<TD>
							<asp:Label id="lblRNC" runat="server" CssClass="labelData"></asp:Label></TD>
						<TD width="8%">Período</TD>
						<TD>
							<asp:Label id="lblPeriodo" runat="server" CssClass="labelData"></asp:Label></TD>
						<TD width="8%">Nómina</TD>
						<TD>
							<asp:Label id="lblNomina" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
				</TABLE>
				<BR>
				<TABLE>
					<TR>
						<TD>
							<DIV class="subHeader">Detalle notificación en el SUIR</DIV>
							<asp:GridView id="gvDetalleReal" runat="server" Width="500px" Visible="False" AutoGenerateColumns="False">
								<Columns>
									<asp:Boundfield DataField="DET_SALARIO_SS" HeaderText="Salario" DataFormatString="{0:N}" HtmlEncode="false" >
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="DET_APORTE_AFILIADOS_SFS" HeaderText="R.S.F.S" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="DET_APORTE_EMPLEADOR_SFS" HeaderText="C.S.F.S" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="DET_APORTE_AFILIADOS_SVDS" HeaderText="R.P" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="DET_APORTE_EMPLEADOR_SVDS" HeaderText="C.P" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="DET_APORTE_SRL" HeaderText="S.R.L" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="DET_APORTE_VOLUNTARIO" HeaderText="A.V" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="DET_PER_CAPITA_ADICIONAL" HeaderText="P.C.A" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="DET_TOTAL_GENERAL" HeaderText="Total" DataFormatString="{0:c}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
								</Columns>
							</asp:GridView></TD>
					</TR>
					<TR>
						<TD>
							<DIV class="subHeader">Detalle cálculo según salario a rectificar</DIV>
							<asp:GridView id="gvDetalleRecalculado" runat="server" Width="500px" Visible="False" AutoGenerateColumns="False">

								<Columns>
									<asp:Boundfield DataField="CON_SALARIO_SS" HeaderText="Salario" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="CON_APORTE_AFILIADOS_SFS" HeaderText="R.S.F.S" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="CON_APORTE_EMPLEADOR_SFS" HeaderText="C.S.F.S" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="CON_APORTE_AFILIADOS_SVDS" HeaderText="R.P" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="CON_APORTE_EMPLEADOR_SVDS" HeaderText="C.P" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="CON_APORTE_SRL" HeaderText="S.R.L" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="CON_APORTE_VOLUNTARIO" HeaderText="A.V" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="CON_PER_CAPITA_ADICIONAL" HeaderText="P.C.A" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="CON_TOTAL_GENERAL" HeaderText="Total" DataFormatString="{0:c}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
								</Columns>
							</asp:GridView></TD>
					</TR>
					<TR>
						<TD>
							<DIV class="subHeader">Detalle de la diferencia en la notificación</DIV>
							<asp:GridView id="gvDetalleDiferencia" runat="server" Width="500px" Visible="False" AutoGenerateColumns="False">

								<Columns>
									<asp:Boundfield DataField="DIF_SALARIO_SS" HeaderText="Salario" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="DIF_APORTE_AFILIADOS_SFS" HeaderText="R.S.F.S" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="DIF_APORTE_EMPLEADOR_SFS" HeaderText="C.S.F.S" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="DIF_APORTE_AFILIADOS_SVDS" HeaderText="R.P" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="DIF_APORTE_EMPLEADOR_SVDS" HeaderText="C.P" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="DIF_APORTE_SRL" HeaderText="S.R.L" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="DIF_APORTE_VOLUNTARIO" HeaderText="A.V" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="DIF_PER_CAPITA_ADICIONAL" HeaderText="P.C.A" DataFormatString="{0:N}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
									<asp:Boundfield DataField="DIF_TOTAL_GENERAL" HeaderText="Total" DataFormatString="{0:c}" HtmlEncode="false">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:Boundfield>
								</Columns>
							</asp:GridView></TD>
					</TR>
				</TABLE>
				
					<TABLE id="Table5">
						<TR>
							<TD>
								<TABLE class="td-note" id="Table6" cellSpacing="0" cellPadding="0" width="325">
									<TR>
										<TD>
											<SPAN class="LabelDataGreen">Leyenda</SPAN>
										</TD>
									</TR>
									<TR>
										<TD>
											<TABLE id="Table7" cellSpacing="0" cellPadding="0" width="100%">
												<TR>
													<TD width="20%">R.S.F.S</TD>
													<TD>Retención Seguro Familiar de Salud.</TD>
												</TR>
												<TR>
													<TD width="20%">C.S.F.S</TD>
													<TD>Contribución Seguro Familiar de Salud.</TD>
												</TR>
												<TR>
													<TD width="20%">R.P</TD>
													<TD>Retención Pensión.</TD>
												</TR>
												<TR>
													<TD width="20%">C.P</TD>
													<TD>Contribución Pensión.</TD>
												</TR>
												<TR>
													<TD width="20%">S.R.L</TD>
													<TD>Seguro de Riesgo Laboral.</TD>
												</TR>
												<TR>
													<TD width="20%">A.V</TD>
													<TD>Aporte Voluntarios.</TD>
												</TR>
												<TR>
													<TD width="20%">P.C.A</TD>
													<TD>Per Cápita Adicional.</TD>
												</TR>
												<TR>
													<TD width="20%">Total</TD>
													<TD>Total General</TD>
												</TR>
												<TR>
													<TD></TD>
													<TD></TD>
												</TR>
											</TABLE>
										</TD>
									</TR>
								</TABLE>
							</TD>
							<TD vAlign="middle" nowrap="noWrap">
								
									<uc1:ucExportarExcel id="ExportaExcel" runat="server"></uc1:ucExportarExcel><BR>
                                <br />
									<a href="javascript:print();"><IMG src="../images/printv.gif" border="0" width="15" height="12">&nbsp;Imprimir</a>
							
							</TD>
						</TR>
					</TABLE>
				
			</asp:panel>

</asp:Content>

