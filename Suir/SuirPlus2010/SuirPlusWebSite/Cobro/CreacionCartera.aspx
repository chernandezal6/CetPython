<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CreacionCartera.aspx.vb" Inherits="Cobro_CreacionCartera" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
     <div class="header">
        Creacion de Carteras
    </div>
    <table style="width: 50%">
        <tr>
            <td>
                <b>Cantidad Empleadores con notificaciones vencidas:</b></td>
            <td>
                <asp:Label ID="lblCantidad" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <b>Cantidad de Carteras a crear:</b></td>
            <td>
                <asp:TextBox ID="txtCantidadCrear" runat="server"></asp:TextBox>
                <asp:Button ID="Button1" runat="server" Text="Crear" />
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="ID_Cartera" HeaderText="No. Cartera" />
                        <asp:BoundField DataField="Fecha_Generacion" HeaderText="Fecha Generación" />
                        <asp:BoundField DataField="Status" HeaderText="Estado" />
                    </Columns>
                </asp:GridView>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
    </table>
</asp:Content>

