<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucSolicitudByRNC.ascx.vb" Inherits="Controles_ucSolicitudByRNC" %>
<asp:Panel ID="pnlMostrar" runat="server" Visible="false" Width="550px">
<div class="subHeader"></div>
<fieldset>
    <legend>Solicitudes</legend>
    <br />
            <table width="100%">
                 <tr>
                   <td>
            <asp:GridView id="gvSolicitudes" runat="server" Width="100%" AutoGenerateColumns="False">
	            <Columns>
		            <asp:BoundField DataField="ID_SOLICITUD" HeaderText="Solicitud">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
		            <asp:BoundField DataField="TIPO_SOLICITUD" HeaderText="Tipo"></asp:BoundField>
		            <asp:BoundField DataField="DESCRIPCION_STATUS" HeaderText="Estatus"></asp:BoundField>
		            <asp:BoundField DataField="FECHA_REGISTRO" HeaderText="Fecha Solicitud"></asp:BoundField>
		            <asp:BoundField DataField="ULT_USUARIO" HeaderText="Modificado Por"></asp:BoundField>		
    	            <asp:hyperlinkfield datanavigateurlfields="ID_SOLICITUD" datanavigateurlformatstring="../Solicitudes/ConsultaSolicitud.aspx?IdSolicitud={0}" text="[Ver]">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:hyperlinkfield>
	            </Columns>
            </asp:GridView>

            </td>
                </tr>
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
                        <br />
                        Total Registros:
                        <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                    </td>
                </tr>

                         <asp:TextBox id="txtRNC" runat="server" Visible="False" Width="24px"></asp:TextBox>
                         
            </table>
    </fieldset>
</asp:Panel>