<%@ Control Language="VB" AutoEventWireup="false" CodeFile="UCArchivosDetalleAuditoria.ascx.vb" Inherits="Controles_UCArchivosDetalleAuditoria" %>

<asp:panel id="pnlDetalle" runat="server" Visible="False">
	<TABLE id="Table1" cellSpacing="0" cellPadding="0" width="700" border="0">
		<TR>
			<TD>
				<asp:GridView id="gvDetalleArchivo" runat="server" Width="100%" Cellpadding="0" AutoGenerateColumns="False" >
					<Columns>
						<asp:BoundField DataField="tipo_documento" HeaderText="Tipo Documento">
                            <HeaderStyle Wrap="False" />
                        </asp:BoundField>
						<asp:BoundField DataField="no_documento" HeaderText="Documento"></asp:BoundField>
						<asp:BoundField DataField="Nombre" HeaderText="Nombres">
                            <ItemStyle Wrap="False" />
                        </asp:BoundField>
						<asp:BoundField DataField="periodo_aplicacion" HeaderText="Per&#237;odo">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
						</asp:BoundField>
                        <asp:BoundField DataField="salario_ss" HeaderText="Salario">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="right"></ItemStyle>
						</asp:BoundField>
                        <%--<asp:TemplateField HeaderText="Salario">
                                            <ItemStyle HorizontalAlign="right"></ItemStyle>
                                            <ItemTemplate>
                                            <asp:Label id="lblsalarioFormateado" runat="server"/>                           
                                            </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
						</asp:TemplateField> 
--%>
						<asp:BoundField DataField="error_des" HeaderText="Error">
                            <ItemStyle Wrap="False" HorizontalAlign="center" />
                        </asp:BoundField>
					</Columns>
					</asp:GridView>	
			  </TD>
		</TR>
        <tr>
		    <td style="height: 12px">
                <asp:LinkButton ID="btnLnkFirstPage" runat="server" CommandName="First" CssClass="linkPaginacion"
                    OnCommand="NavigationLink_Click" Text="<< Primera"></asp:LinkButton>&nbsp;|
                <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CommandName="Prev" CssClass="linkPaginacion"
                    OnCommand="NavigationLink_Click" Text="< Anterior"></asp:LinkButton>&nbsp; Página
                [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>] de
                <asp:Label ID="lblTotalPages" runat="server"></asp:Label>&nbsp;
                <asp:LinkButton ID="btnLnkNextPage" runat="server" CommandName="Next" CssClass="linkPaginacion"
                    OnCommand="NavigationLink_Click" Text="Próxima >"></asp:LinkButton>&nbsp;|
                <asp:LinkButton ID="btnLnkLastPage" runat="server" CommandName="Last" CssClass="linkPaginacion"
                    OnCommand="NavigationLink_Click" Text="Última >>"></asp:LinkButton>&nbsp;
                <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
            </td>
		</tr>
        <tr>
            <td>
                Total de Registros
                <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
            </td>
        </tr>		
	</TABLE>
 </asp:panel>
   <asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="False" Font-Size="Small"></asp:Label>

