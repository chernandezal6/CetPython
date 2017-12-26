<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="segUsuariosOnline.aspx.vb" Inherits="Seguridad_segUsuariosOnline" title="Usuarios Onlines" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	<script language="vb" runat="server">
	    Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
			
	        Me.RoleRequerido = 10
			
	    End Sub
	</script>
	
	<div class="header">Estado del Sistema:&nbsp;
	<asp:Button id="btAdmin" runat="server" Text="Colocar en Modo de Administración" Enabled="False"></asp:Button>
	<asp:Button id="btNormal" runat="server" Text="Colocar en Modo Normal" Enabled="False"></asp:Button>
	</div>
	<br /><br />
	<div class="subHeader">Usuarios Online:&nbsp;
	<asp:label id="lblCount" runat="server" CssClass="header"></asp:label>
	</div>
	<br /><br />
	<asp:gridview id="dgUsuariosOnline" runat="server" AutoGenerateColumns="False">
		<Columns>
			<asp:BoundField DataField="Usuario" HeaderText="Usuario"></asp:BoundField>
			<asp:BoundField DataField="Page" HeaderText="URL"></asp:BoundField>
			<asp:BoundField DataField="IP" HeaderText="IP"></asp:BoundField>
		</Columns>
	</asp:gridview>
</asp:Content>