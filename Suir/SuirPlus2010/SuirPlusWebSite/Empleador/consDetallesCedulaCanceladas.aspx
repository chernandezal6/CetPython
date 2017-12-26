<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consDetallesCedulaCanceladas.aspx.vb" Inherits="Empleador_consDetallesCedulaCanceladas" title="Consulta Trabajadores Cédulas Canceladas" %>

<%@ Register Src="../Controles/ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="header">Detalle de trabajadores con cédulas canceladas</div><br />
 <asp:Label ID="lblMensaje" runat="server" CssClass="error" Font-Size="10pt"></asp:Label>
    <asp:Panel ID="pnlDetTrabCedCanceladas" runat="server" Visible="false">

			<TABLE id="tblDetalle1" cellSpacing="0" cellPadding="0" border="0" align="left">
				<TR>
					<TD style="width: 586px"><asp:Gridview id="gvDetalle" runat="server" CssClass="list" AutoGenerateColumns="False" Width="584px" CellPadding="1">
							<Columns>
								<asp:BoundField DataField="Nombre_Completo" HeaderText="Nombre">
                                    <ItemStyle Wrap="False" />
                                </asp:BoundField>
								<asp:TemplateField HeaderText="Documento">
									<ItemStyle HorizontalAlign="Center" Wrap="False"></ItemStyle>
									<ItemTemplate>
										<asp:Label id="Label1" runat="server" Text='<%# formateaDocumento(DataBinder.Eval(Container, "DataItem.no_documento")) %>'>
										</asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="NSS">
									<ItemStyle HorizontalAlign="Center" Wrap="False"></ItemStyle>
									<ItemTemplate>
										<asp:Label id="Label3" runat="server" Text='<%# formateaNSS(DataBinder.Eval(Container.DataItem, "id_nss")) %>'>
										</asp:Label>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:BoundField DataField="salario_ss" HeaderText="Sal. SS" DataFormatString="{0:n}" HtmlEncode="False">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="salario_isr" HeaderText="Sal. ISR" DataFormatString="{0:n}" HtmlEncode="False">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="salario_infotep" HeaderText="Sal. INF" DataFormatString="{0:n}" HtmlEncode="False">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="otras_remuneraciones" HeaderText="O. R" DataFormatString="{0:n}" HtmlEncode="False">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="saldo_a_favor_del_periodo" HeaderText="S.F" DataFormatString="{0:n}" HtmlEncode="False">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="ingresos_extentos_del_periodo" HeaderText="I.E" DataFormatString="{0:n}" HtmlEncode="False">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="remuneraciones_otros_agentes" HeaderText="R.O.A" DataFormatString="{0:n}" HtmlEncode="False">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="agente_retencion_isr" HeaderText="R.A.U.R.">
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:BoundField>
							</Columns>
						</asp:GridView>
						
						</TD>
				</TR>
			
				<tr>
					<TD align="left">
                        <br />
					    
                        <img alt="detalle.gif" border="0" src="../images/detalle.gif" width="15" height="12">&nbsp;<a href="javascript:history.back()">Encabezado</a>
                       
                        <uc1:ucExportarExcel ID="UcExp" runat="server" />
                     </TD>
				</tr>
			</TABLE>
			
    </asp:Panel>			
</asp:Content>

