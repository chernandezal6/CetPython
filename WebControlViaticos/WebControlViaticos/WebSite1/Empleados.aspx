<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Empleados.aspx.cs" Inherits="WebControlViaticos.WebSite1.Empleados" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style4 {
            width: 100%;
        }
        .auto-style5 {
            height: 26px;
        }
    .auto-style6 {
        text-align: right;
    }
    .auto-style7 {
        height: 26px;
        text-align: right;
    }
    .auto-style8 {
        text-align: left;
    }
    .auto-style9 {
        height: 26px;
        text-align: left;
    }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphContenido1" runat="server">

    
    <table class="auto-style4">
        <tr>
            <td>&nbsp;</td>
            <td class="auto-style6">
                <asp:Label ID="Label1" runat="server" Text="Nro_Empleado:" ></asp:Label>
            </td>
            <td class="auto-style8">
                <asp:TextBox ID="txtNroEmpleado" runat="server" OnTextChanged="txtNroEmpleado_TextChanged"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="auto-style5"></td>
            <td class="auto-style7">
                <asp:Label ID="Label2" runat="server" Text="Nombres:"></asp:Label>
            </td>
            <td class="auto-style9">
                <asp:TextBox ID="txtNombres" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td class="auto-style6">
                <asp:Label ID="Label3" runat="server" Text="Apellidos:"></asp:Label>
            </td>
            <td class="auto-style8">
                <asp:TextBox ID="txtApellidos" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td class="auto-style6">
                <asp:Label ID="Label4" runat="server" Text="Cargo:"></asp:Label>
            </td>
            <td class="auto-style8">
                <asp:TextBox ID="txtCargo" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td class="auto-style6">
                <asp:Label ID="Label5" runat="server" Text="Departamento:"></asp:Label>
            </td>
            <td class="auto-style8">
                <asp:TextBox ID="txtDepartamento" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td class="auto-style6">
                <asp:Label ID="Label6" runat="server" Text="Fecha:"></asp:Label>
            </td>
            <td class="auto-style8">
                <asp:TextBox ID="txtFecha" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td class="auto-style6">
                <asp:Label ID="Label7" runat="server" Text="Categorias:"></asp:Label>
            </td>
            <td class="auto-style8">
                <asp:TextBox ID="txtCategoria" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td class="auto-style6">
                <asp:Label ID="Label8" runat="server" Text="Hora Salida:"></asp:Label>
            </td>
            <td class="auto-style8">
                <asp:TextBox ID="txtHoraSalida" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td class="auto-style6">
                <asp:Label ID="Label9" runat="server" Text="Hora Llegada:"></asp:Label>
            </td>
            <td class="auto-style8">
                <asp:TextBox ID="txtHoraLLegada" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>
                <asp:Button ID="Button1" runat="server" Text="Enviar" Width="77px" />
            </td>
        </tr>            
    </table>
            <div>
            <asp:GridView ID="GridView1" runat="server" Width="591px"></asp:GridView>
        </div>
    
</asp:Content>
