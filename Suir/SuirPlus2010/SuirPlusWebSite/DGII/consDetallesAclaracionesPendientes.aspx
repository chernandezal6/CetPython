<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consDetallesAclaracionesPendientes.aspx.vb" Inherits="DGII_consDetallesAclaracionesPendientes" title="Consulta Detalle de Aclaraciones Pendientes por Banco" %>
<%@ Register TagPrefix="uc1" TagName="ucExportarExcel" Src="../Controles/ucExportarExcel.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<div>
<asp:label id="lblBanco" runat="server" CssClass="subHeader">Banco: </asp:label>
    <asp:Label ID="lbltxtBanco" runat="server" CssClass="subHeaderContrast"></asp:Label>
</div>			
			<TABLE id="tblDetalle" cellSpacing="1" cellPadding="1" border="0">
				<TR>
					<TD colSpan="3">
					<asp:GridView id="gvDetalle" runat="server" AutoGenerateColumns="False" Width="100%">

							<Columns>
								<asp:Boundfield DataField="envio" HeaderText="Env&#237;o">
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="lote_secuencia" HeaderText="L&#237;nea">
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="clave_transaccion" HeaderText="Clave Transacci&#243;n">
									<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="ref_isr" HeaderText="Referencia"></asp:Boundfield>
								<asp:Boundfield DataField="no_aut" HeaderText="No. Autorizaci&#243;n">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="monto" HeaderText="Monto" DataFormatString="{0:c}" HtmlEncode="False">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="status" HeaderText="Estatus">
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:Boundfield>
							</Columns>
							</asp:GridView>
						</TD>
				</TR>
									<tr>
        <td>
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
            Total Registros:
            <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
        </td>
    </tr>
				<tr>
					<TD align="right">
						<uc1:ucExportarExcel id="ucExpExcel" runat="server"></uc1:ucExportarExcel></TD>
				</tr>
			</TABLE>

</asp:Content>

