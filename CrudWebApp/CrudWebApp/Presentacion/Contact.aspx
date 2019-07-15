<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="CrudWebApp.Presentacion.Contact" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
        .auto-style2 {
            width: 114px;
        }
    </style>
</head>
<body>
     <form id="form1" runat="server">
        <div >
            <table class="auto-style1">
                <tr>
                    <td class="auto-style2">
                        <asp:Label ID="Label1" runat="server" Text="Nombres:"></asp:Label></td>
                    <td>
                        <asp:TextBox ID="txtnombre" runat="server" Width="173px"></asp:TextBox></td>
                    
                </tr>
                 <tr>
                    <td class="auto-style2">
                        <asp:Label ID="Label2" runat="server" Text="Contacto:"></asp:Label></td>
                    <td>
                        <asp:TextBox ID="txtContacto" runat="server" Width="174px"></asp:TextBox></td>
                    
                </tr>
                 <tr>
                    <td class="auto-style2">
                        <asp:Label ID="Label3" runat="server" Text="Email:"></asp:Label></td>
                    <td>
                        <asp:TextBox ID="txtEmail" runat="server" Width="174px"></asp:TextBox></td>
                    
                </tr>
                 <tr>
                    <td class="auto-style2">
                        <asp:Label ID="Label4" runat="server" Text="Fecha Registro:"></asp:Label></td>
                    <td>
                        <asp:Calendar ID="dpFecha" runat="server" ></asp:Calendar></td>
                    
                </tr>
                <tr>
                   <td>
                       <asp:Button ID="Button1" runat="server" Text="Submit" OnClick="Button1_Click" />
                   </td>
                </tr>
                </table>
        </div>
    </form>
</body>
</html>
