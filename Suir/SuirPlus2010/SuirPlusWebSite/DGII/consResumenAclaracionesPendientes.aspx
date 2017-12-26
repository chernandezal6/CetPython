<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consResumenAclaracionesPendientes.aspx.vb" Inherits="DGII_consResumenAclaracionesPendientes" title="Consulta Resumen de Aclaraciones Pendientes por Banco" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">


		<script language="vb" runat="server">
			Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
				
		        'Me.PermisoRequerido = 68
				
			End Sub
		</script>
		
		<div class="header" align="left">Resumen de Aclaraciones Pendientes por Banco</div><br />

			<TABLE id="tblDetalle" cellSpacing="1" cellPadding="1" border="0">
				<TR>
					<TD colSpan="3">
					<asp:GridView id="gvDetalle" runat="server" AutoGenerateColumns="False" Width="100%">

							<Columns>
								<asp:Boundfield DataField="id_entidad_recaudadora" HeaderText="Entidad">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:Boundfield>
								<asp:Boundfield DataField="entidad_recaudadora_des" HeaderText="Nombre"></asp:Boundfield>
								<asp:Boundfield DataField="Periodo" HeaderText="Tiempo Comprendido" DataFormatString="{0:n}" HtmlEncode="False">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="monto" HeaderText="Monto" DataFormatString="{0:c}" HtmlEncode="False">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
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

			</TABLE>

</asp:Content>

