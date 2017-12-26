<%@ Page Language="VB" AutoEventWireup="false" CodeFile="popUsuarios.aspx.vb" Inherits="Seguridad_popUsuarios"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Agregar Usuarios</title>
</head>
<body>
	<form id="Form1" method="post" runat="server">
	    <asp:button id="btAgregar" runat="server" Text="Agregar"></asp:button>
	    <asp:button id="btCerrar" runat="server" Text="Cerrar" ToolTip="Cerrar Esta Ventana">
	    </asp:button>
	    <br />
	    <asp:label id="lblMensajeError" runat="server" Visible="False" CssClass="error"></asp:label>
	    <br />
	    <asp:gridview id="dgUsuarios" runat="server" AutoGenerateColumns="False">
		    <Columns>
			    <asp:TemplateField>
				    <ItemStyle HorizontalAlign="Center"></ItemStyle>
				    <ItemTemplate>
					    <asp:CheckBox id="chkBox" runat="server" BorderWidth="0px"></asp:CheckBox>
					    <asp:Label id="lblID" runat="server" Visible="False" Text='<%# Eval("id_usuario") %>'>
					    </asp:Label>
				    </ItemTemplate>
			    </asp:TemplateField>
			    <asp:BoundField DataField="ID_Usuario" HeaderText="Usuario"></asp:BoundField>
			    <asp:BoundField DataField="Nombre" HeaderText="Nombre"></asp:BoundField>
		    </Columns>
	    </asp:gridview>
	    <br />
	    <asp:label id="lblUsrResponsable" runat="server" Visible="False"></asp:label>&nbsp;
	    <asp:label id="lblIDPermiso" runat="server" Visible="False"></asp:label>&nbsp;
	    <asp:label id="lblIDRoles" runat="server" Visible="False"></asp:label>
	</form>
</body>
</html>
