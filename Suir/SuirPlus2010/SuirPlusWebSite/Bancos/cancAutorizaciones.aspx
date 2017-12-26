<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="cancAutorizaciones.aspx.vb" Inherits="Bancos_cancAutorizaciones" title="Cancelación de Autorizaciones" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	
	<script language="javascript" type="text/javascript">
		function limpiarCampos()
		{
			document.aspnetForm.ctl00$MainContent$txtReferencia.value = "";
		}
	</script>
	
	<script language="vb" runat="server">
		Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
			
			Me.PermisosOpcionales = New String() {"50", "49"}
			
		End Sub		
	</script>

    <span class="header">Cancelación de Autorizaciones</span><br />
    <asp:Label id="lblMensajeError" runat="server" CssClass="label-Resaltado" Visible="False" EnableViewState="False"></asp:Label><br /><br />

    <table class="td-content" id="tblBusqueda" cellspacing="1" cellpadding="1" border="0">
	    <tr>
		    <td>
			    <asp:Label id="Label1" runat="server">Búsqueda por Referencia:</asp:Label></td>
		    <td>
			    <asp:TextBox id="txtReferencia" runat="server" MaxLength="16"></asp:TextBox></td>
		    <td rowspan="2">
		        <img id="imgLogo" runat="server" src="" alt="" />
		    </td>
		    <td rowspan="2">
			    <asp:LinkButton id="lnkExportar" runat="server" CssClass="subheader">Exportar Archivo</asp:LinkButton></td>
	    </tr>
	    <tr>
		    <td colspan="2">
		        <asp:Button id="btBuscar" runat="server" Text="Buscar"></asp:Button>&nbsp;
		        <input class="Button" id="btLimpiarCampos" onclick="limpiarCampos()" type="button" value="Limpiar Campos" />
			    <asp:Button id="btnCancelar" Text="Cancelar" Runat="server"></asp:Button>
		    </td>
	    </tr>
    </table>
    <br />
    <asp:Label id="lblMens" runat="server" CssClass="label-Resaltado" Font-Bold="True">Para cancelar una autorización, debe digitar el número arriba y pulsar el botón BUSCAR.</asp:Label><br /><br />
    <asp:Label id="Label2" runat="server" CssClass="label-Resaltado" Font-Bold="True">Cuando aparezca en pantalla, proceda con la cancelación haciendo click en CANCELAR.</asp:Label><br /><br />
    <asp:GridView ID="dgAutorizaciones" AutoGenerateColumns="false" runat="server" cellpadding="4">
        <Columns>
		    <asp:BoundField DataField="no_autorizacion" HeaderText="Autorizaci&#243;n">
			    <ItemStyle HorizontalAlign="Center"></ItemStyle>
		    </asp:BoundField>
		    <asp:BoundField DataField="id_referencia" HeaderText="Referencia">
			    <ItemStyle HorizontalAlign="Center"></ItemStyle>
		    </asp:BoundField>
		    <asp:BoundField DataField="RNC_O_CEDULA" HeaderText="RNC"></asp:BoundField>
		    <asp:BoundField DataField="fecha_autorizacion" HeaderText="Fecha Autorizaci&#243;n">
			    <ItemStyle HorizontalAlign="Center"></ItemStyle>
		    </asp:BoundField>
		    <asp:BoundField DataField="ID_USUARIO_AUTORIZA" HeaderText="Usuario"></asp:BoundField>
		    <asp:BoundField DataField="total_general" HeaderText="Total" HtmlEncode="False" DataFormatString="{0:C}">
			    <ItemStyle HorizontalAlign="Right"></ItemStyle>
		    </asp:BoundField>
		    <asp:TemplateField>
			    <ItemStyle HorizontalAlign="Center"></ItemStyle>
			    <ItemTemplate>
				    <asp:Label id="lblID" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.id_referencia") %>' Visible="False">
				    </asp:Label>
				    <asp:LinkButton id="lnkImprimir" runat="server" CommandName="Imprimir" CommandArgument='<%# DataBinder.Eval(Container, "DataItem.id_referencia") %>'>Imprimir</asp:LinkButton>
			    </ItemTemplate>
		    </asp:TemplateField>
		    <asp:TemplateField>
			    <ItemStyle HorizontalAlign="Center"></ItemStyle>
			    <ItemTemplate>
				    <asp:LinkButton id="lnkCancelar" runat="server" CommandName="Cancelar" CommandArgument='<%# DataBinder.Eval(Container, "DataItem.id_referencia") %>'>Cancelar</asp:LinkButton>
			    </ItemTemplate>
		    </asp:TemplateField>
	    </Columns>
    </asp:GridView>				
</asp:Content>