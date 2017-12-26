<%@ Page Language="VB" AutoEventWireup="false" CodeFile="popPermisos.aspx.vb" Inherits="Seguridad_popPermisos" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Agregar Permisos al Usuario</title>
    
    <script language="vb" runat="server">
	    Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
    		
            If Not Me.IsInRole("10") Then

                Response.Redirect(Application("urlLogin") & "?mensajeerror=Usted no tiene los permisos requeridos para acceder a este recurso")

            End If
    		
	    End Sub
    </script>	
    
</head>
<body>
	<form id="Form1" method="post" runat="server">
		<asp:Button id="btAgregar" runat="server" Text="Agregar"></asp:Button>&nbsp;
		<asp:Button id="btCerrar" runat="server" Text="Cerrar" ToolTip="Cerrar Esta Ventana"></asp:Button><br />
		<asp:Label id="lblMensajeError" runat="server" CssClass="error" Visible="False"></asp:Label><br />
		<asp:gridview id="dgPermisos" runat="server" AutoGenerateColumns="False">
			<Columns>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:CheckBox id="chkBox" runat="server" BorderWidth="0px"></asp:CheckBox>
						<asp:Label id="lblID" runat="server" Text='<%# Eval("ID_Permiso") %>' Visible="False">
						</asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:BoundField DataField="permiso_des" HeaderText="Descripci&#243;n"></asp:BoundField>
				<asp:BoundField DataField="seccion_des" HeaderText="Secci&#243;n"></asp:BoundField>
				<asp:BoundField DataField="direccion_electronica" HeaderText="URL"></asp:BoundField>
			</Columns>
		</asp:gridview>
		<br />
		<asp:Label id="lblUsrResponsable" runat="server" Visible="False"></asp:Label>&nbsp;
		<asp:Label id="lblUserName" runat="server" Visible="False"></asp:Label>&nbsp;
		<asp:Label id="lblIDRoles" runat="server" Visible="False"></asp:Label>
	</form>
</body>
</html>