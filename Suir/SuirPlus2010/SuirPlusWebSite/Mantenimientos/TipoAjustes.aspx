<%@ Page Title="Tipos de Ajustes" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="TipoAjustes.aspx.vb" Inherits="Mantenimientos_TipoAjustes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="header">Lista de Tipo de Ajustes</div>
<br/>
    <asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="false"></asp:Label>
<table>
<tr>
    <td>
    <asp:gridview id="gvTipoAjustes" runat="server" AutoGenerateColumns="False">
		        <Columns>
			        <asp:BoundField DataField="ID_TIPO_AJUSTE" HeaderText="IdTipoAjuste" 
                        Visible="False"></asp:BoundField>
			        <asp:BoundField DataField="DESCRIPCION" HeaderText="Tipo de Ajuste">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Left" />
                    </asp:BoundField>
			        <asp:BoundField DataField="TIPO_MOVIMIENTO" HeaderText="Tipo Movimiento">
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
			        <asp:BoundField DataField="ESTATUS" HeaderText="Estatus">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
			        <asp:BoundField DataField="CUENTA_ORIGEN" HeaderText="Cuenta Origen">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                    </asp:BoundField>
			        <asp:BoundField DataField="CUENTA_DESTINO" HeaderText="Cuenta Destino">
				        <HeaderStyle HorizontalAlign="Center" />
				        <ItemStyle HorizontalAlign="Center"></ItemStyle>
			        </asp:BoundField>
			        <asp:BoundField DataField="Ult_Fecha_Act" HeaderText="Fecha Modificaci&#243;n" 
                        HtmlEncode="False">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
			        <asp:BoundField DataField="Ult_Usuario_Act" HeaderText="Usuario Modificaci&#243;n">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                
                      <asp:TemplateField HeaderText="Editar">
                          <FooterStyle Wrap="False" />
                          <HeaderStyle Wrap="False" />
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemTemplate>                        
                        <asp:HyperLink ID="hlEditar" runat="server" ImageUrl="../images/editar.gif" NavigateUrl=' <%# "~/Mantenimientos/UpdTipoAjuste.aspx?idTipo=" & eval("ID_TIPO_AJUSTE") %>'></asp:HyperLink>
                        </ItemTemplate>
                      </asp:TemplateField> 
		        </Columns>
	        </asp:gridview>
    </td>
</tr>
</table>

</asp:Content>

