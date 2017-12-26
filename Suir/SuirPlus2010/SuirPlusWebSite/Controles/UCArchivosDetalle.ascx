<%@ Control Language="VB" AutoEventWireup="false" CodeFile="UCArchivosDetalle.ascx.vb" Inherits="Controles_UCArchivosDetalle" %>

<asp:Panel runat="server" ID="pnlDetalle" Visible="false">
	<table id="table1" cellspacing="0" cellpadding="0" width="750" border="0">
		<tr>
			<td>
				<asp:GridView id="gvDetalleArchivo" runat="server" Width="100%" Cellpadding="0" AutoGenerateColumns="False">
					<Columns>
						<asp:BoundField DataField="tipo_documento" HeaderText="Tipo Doc.">
							<HeaderStyle HorizontalAlign="Left"></HeaderStyle>
						</asp:BoundField>
						<asp:BoundField DataField="no_documento" HeaderText="Documento">
							<HeaderStyle HorizontalAlign="Left"></HeaderStyle>
						</asp:BoundField>
						<asp:BoundField DataField="Nombre" HeaderText="Nombres"></asp:BoundField>
						<asp:BoundField DataField="error_des" HeaderText="Error"></asp:BoundField>
					</Columns>
				</asp:GridView>
			</td>
		</tr>
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
	</table>
</asp:Panel>

