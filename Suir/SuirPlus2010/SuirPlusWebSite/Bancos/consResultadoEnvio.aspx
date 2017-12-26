<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consResultadoEnvio.aspx.vb" Inherits="Bancos_consResultadoEnvio" title="Consulta Resultado Envío Pagos y Aclaraciones" %>
<%@ Register TagPrefix="uc1" TagName="ucExportarExcel" Src="../Controles/ucExportarExcel.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

		<script language="vb" runat="server">
			Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
				
		        'Me.PermisoRequerido = 134
				
			End Sub
		</script>
		
		<div class="header" align="left">Consulta Archivo de Respuesta</div>
    <br />

						<TABLE id="Table1" cellSpacing="0" cellPadding="0" style="width: 286px; text-align: left;" class="td-content">
							<TR>
								<TD style="text-align: right">
                                    &nbsp;<asp:label id="Label3" runat="server" CssClass="labelData">No. Envío : </asp:label></TD>
								<TD style="text-align: justify">
                                    <br />
                                    <asp:textbox id="txtEnvio" runat="server" MaxLength="16"></asp:textbox><BR>
									<asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" ValidationExpression="\d*" ControlToValidate="txtEnvio"
										ErrorMessage="Debe ser numérico el valor"></asp:regularexpressionvalidator>&nbsp;</TD>
							</TR>
							<TR>
								<TD colSpan="2" style="text-align: center">
                                    <asp:button id="btBuscarRef" runat="server" Text="Buscar" Enabled="True" EnableViewState="False"></asp:button>&nbsp;
                                    <asp:button id="btnLimpiar" runat="server" Text="Limpiar" Enabled="True" EnableViewState="False"></asp:button>&nbsp;
							        <uc1:ucExportarExcel id="UcExportarExcel1" runat="server" Visible="false"></uc1:ucExportarExcel>
                                    <br />
                                    <br />
								</TD>
							</TR>
						</TABLE>
	
	            <asp:label id="lblFormError" runat="server" CssClass="error" Font-Size="10pt"></asp:label><br />
    <asp:Panel ID="pnlInfo" runat="server" Visible="false">
    <table id="Table2" border="0" cellpadding="0" cellspacing="3" class="td-note" width="600">
        <tr>
            <td align="right" class="LabelDataGreen" style="width: 109px">
                Archivo:</td>
            <td>
                <asp:Label ID="lblArchivo" runat="server" CssClass="LabelDataGris" EnableViewState="False"></asp:Label></td>
            <td align="right" class="LabelDataGreen" nowrap="noWrap">
                Usuario Carga:</td>
            <td>
                <asp:Label ID="lblUsrCarga" runat="server" CssClass="LabelDataGris" EnableViewState="False"></asp:Label></td>
        </tr>
        <tr>
            <td class="LabelDataGreen" align="right" style="width: 109px; height: 12px">
                Tipo Archivo:</td>
            <td>
                <asp:Label ID="lbltipo" runat="server" CssClass="LabelDataGris" EnableViewState="False"></asp:Label></td>
            <td class="LabelDataGreen" align="right" style="width: 70px; height: 12px">
                Fecha Carga:</td>
            <td style="height: 12px">
                <asp:Label ID="lblFechaCarga" runat="server" CssClass="LabelDataGris" EnableViewState="False"></asp:Label></td>
        </tr>
        <tr>
            <td class="LabelDataGreen" align="right" style="width: 109px">
                Entidad Recaudadora:</td>
            <td align="left" colspan="3">
                <asp:Label ID="lblEntidadRecaudadora" runat="server" CssClass="LabelDataGris" EnableViewState="False"></asp:Label></td>
        </tr>
    </table>
    </asp:Panel>
	
	            <asp:Panel ID="pnlPagos" runat="server" Visible="false">
			            <TABLE id="tblDetalle1" cellSpacing="1" cellPadding="1" border="0" width="550px">
				<TR>
					<TD>
                        &nbsp;<asp:label id="lblPagos" runat="server" CssClass="subHeader">Pagos: </asp:label>&nbsp;
					</TD>
				</TR>
				<TR>
					<TD><asp:GridView id="gvPagos" runat="server" AutoGenerateColumns="False">

							<Columns>
								<asp:Boundfield DataField="TIPO_DE_REGISTRO" HeaderText="Tipo Registro">
									<HeaderStyle Width="100px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="ID_RECEPCION" HeaderText="No. Recepci&#243;n">
									<HeaderStyle Width="100px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="CLAVE_TRANSACCION" HeaderText="Clave Trasacci&#243;n">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="SUCURSAL_BANCO" HeaderText="Sucursal Banco">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="ID_REFERENCIA" HeaderText="No. Referencia">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="FECHA_PAGO" HeaderText="Fecha Pago">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="HORA_PAGO" HeaderText="Hora Pago">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="MONTO" HeaderText="Monto">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="NO_AUTORIZACION" HeaderText="No. Autorizaci&#243;n">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="MEDIO_PAGO" HeaderText="Medio Pago">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="STATUS" HeaderText="Status">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="ID_ERROR" HeaderText="No. Error">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="SECUENCIA_MOV_RECAUDO" HeaderText="Secuencia Mov. Recaudo">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="ID_REFERENCIA_REAL" HeaderText="No. Referencia Real">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="NO_AUTORIZACION_REAL" HeaderText="No. Autorizacion Real">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
							</Columns>
							
						</asp:GridView>
						</TD>
				</TR>
			</TABLE>
                </asp:Panel>
                
                <asp:Panel ID="pnlAclaraciones" runat="server" Visible="false">
			            <TABLE id="tblDetalle2" cellSpacing="1" cellPadding="1" border="0" width="550px">
				<TR>
					<TD>
                        &nbsp;<asp:label id="lblAclaraciones" runat="server" CssClass="subHeader">Aclaraciones:</asp:label></TD>
				</TR>
				<TR>
					<TD><asp:GridView id="gvAclaraciones" runat="server"  AutoGenerateColumns="False">
							<Columns>
								<asp:Boundfield DataField="TIPO_DE_REGISTRO" HeaderText="Tipo Registro">
									<HeaderStyle Width="100px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="MODO_PAGO" HeaderText="Modo Pago">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="ENVIO_A_ACLARAR" HeaderText="Envio a Aclarar">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="LINEA_A_ACLARAR" HeaderText="L&#237;nea a Aclarar">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="FECHA_ENVIO_ORIGINAL" HeaderText="Fecha Env&#237;o Original">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="ID_REFERENCIA_ACLARAR" HeaderText="No. Referencia Aclarar">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="ID_REFERENCIA_ACLARADA" HeaderText="No. Referencia Aclarara">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="MONTO_A_ACLARAR" HeaderText="Monto a Aclarar">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="MONTO_ACLARADO" HeaderText="Monto Aclararado">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="NO_AUT_A_ACLARAR" HeaderText="No. Autorizaci&#243;n a Aclarar">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="NO_AUT_ACLARADO" HeaderText="No. Autorizaci&#243;n Aclararado">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="MOTIVO_ERROR" HeaderText="Motivo Error">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="STATUS" HeaderText="Status">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="ID_ERROR" HeaderText="No. Error">
									<HeaderStyle Width="150px"></HeaderStyle>
									<ItemStyle HorizontalAlign="Left"></ItemStyle>
								</asp:Boundfield>
							</Columns>
							
						</asp:GridView>
						</TD>
				</TR>
			</TABLE>
                </asp:Panel>
    <br />
</asp:Content>

