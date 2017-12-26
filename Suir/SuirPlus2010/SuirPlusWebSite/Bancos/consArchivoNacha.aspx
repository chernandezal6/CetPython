<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consArchivoNacha.aspx.vb" Inherits="Bancos_consArchivoNacha" title="Untitled Page" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <br />

<TABLE class="consultaTabla" id="tblConsReferencia" cellSpacing="1" cellPadding="1" width="470"
					align="center" border="0">
					<TR>
						<TD class="consultaHeader" colSpan="2">
                            <asp:Label ID="Label3" runat="server" CssClass="header" Text="Consulta Archivos Nacha"></asp:Label></TD>
					</TR>
					<TR>
						<TD>
							<TABLE id="Table2" cellSpacing="0" cellPadding="0" align="center" border="0">
								<TR>
									<TD><asp:label id="Label1" runat="server">No. Referencia</asp:label>&nbsp;
									</TD>
									<TD><asp:textbox id="txtReferencia" runat="server" MaxLength="16"></asp:textbox></TD>

									<TD  colSpan="2"><asp:button id="btBuscar" runat="server" Text="Buscar"></asp:button>
									</TD>
								</TR>
							</TABLE>
                            <asp:Label ID="lblMsg" runat="server" CssClass="error"></asp:Label></TD>
					</TR>
				</TABLE>

				<BR>
				<TABLE id="tblDetalle1" cellSpacing="1" cellPadding="1" border="0" align="center">
					<TR>
						<TD>
    <asp:GridView ID="dgDetalle" AutoGenerateColumns=False runat="server">
    <Columns>
									<asp:BoundField DataField="id_recepcion" HeaderText="No. Envío">
										<HeaderStyle Width="100px"></HeaderStyle>
										<ItemStyle HorizontalAlign="Center"></ItemStyle>
									</asp:BoundField>
									<asp:BoundField DataField="nombre_archivo_nacha" HeaderText="Nombre Archivo Nacha">
										<HeaderStyle Width="150px"></HeaderStyle>
										<ItemStyle HorizontalAlign="Left"></ItemStyle>
									</asp:BoundField>
									<asp:BoundField DataField="fecha_carga" HeaderText="Fecha Carga">
										<HeaderStyle Width="150px"></HeaderStyle>
										<ItemStyle HorizontalAlign="Center"></ItemStyle>
									</asp:BoundField>
									<asp:BoundField DataField="entidad_recaudadora_des" HeaderText="Entidad Recaudo">
										<HeaderStyle Width="150px"></HeaderStyle>
										<ItemStyle HorizontalAlign="Left"></ItemStyle>
									</asp:BoundField>
									<asp:BoundField DataField="id_tipo_movimiento" HeaderText="Tipo Envío">
										<HeaderStyle Width="150px"></HeaderStyle>
										<ItemStyle HorizontalAlign="Left"></ItemStyle>
									</asp:BoundField>
									<asp:BoundField DataField="Referencia" HeaderText="Referencia">
										<HeaderStyle Width="150px"></HeaderStyle>
										<ItemStyle HorizontalAlign="Center"></ItemStyle>
									</asp:BoundField>
									<asp:BoundField DataField="no_autorizacion" HeaderText="No. Autorización">
										<HeaderStyle Width="150px"></HeaderStyle>
										<ItemStyle HorizontalAlign="Center"></ItemStyle>
									</asp:BoundField>
									<asp:BoundField DataField="monto" HeaderText="Monto" HtmlEncode=false DataFormatString="{0:n}">
										<HeaderStyle Width="150px"></HeaderStyle>
										<ItemStyle HorizontalAlign="Center"></ItemStyle>
									</asp:BoundField>
									<asp:BoundField DataField="status" HeaderText="Status">
										<HeaderStyle Width="150px"></HeaderStyle>
										<ItemStyle HorizontalAlign="Center"></ItemStyle>
									</asp:BoundField>
									<asp:BoundField DataField="id_error" HeaderText="Error">
										<HeaderStyle Width="150px"></HeaderStyle>
										<ItemStyle HorizontalAlign="Center"></ItemStyle>
									</asp:BoundField>
									<asp:BoundField DataField="error_des" HeaderText="Descrición Error">
										<HeaderStyle Width="150px"></HeaderStyle>
										<ItemStyle HorizontalAlign="Center"></ItemStyle>
									</asp:BoundField>
								</Columns>
    </asp:GridView>						
						
						</TD>
					</TR>
				</TABLE>
</asp:Content>

