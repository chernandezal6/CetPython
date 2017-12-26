<%@ Page Language="VB" AutoEventWireup="false" CodeFile="popRoles.aspx.vb" Inherits="Seguridad_popRoles" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Agregar Roles al Usuario</title>
</head>
<body>
	<form id="Form1" method="post" runat="server">
		<asp:Button id="btAgregar" runat="server" Text="Agregar"></asp:Button>&nbsp;
		<asp:Button id="btCerrar" runat="server" Text="Cerrar" ToolTip="Cerrar Esta Ventana"></asp:Button><br />
		<asp:Label id="lblMensajeError" runat="server" CssClass="error" Visible="False"></asp:Label><br />
		<asp:gridview id="dgRoles" runat="server" AutoGenerateColumns="False">
			<Columns>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:CheckBox id="chkBox" runat="server" BorderWidth="0px"></asp:CheckBox>
						<asp:Label id="lblID" runat="server" Text='<%# Eval("ID_Role") %>' Visible="False">
						</asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:BoundField DataField="Roles_des" HeaderText="Descripción"></asp:BoundField>
			</Columns>
		</asp:gridview>
		<br />
		<asp:Label id="lblUserName" runat="server" Visible="False"></asp:Label>&nbsp;
		<asp:Label id="lblIDPermiso" runat="server" Visible="False"></asp:Label>&nbsp;
		<asp:Label id="lblUsrResponsable" runat="server" Visible="False"></asp:Label>
	</form>
</body>
</html>