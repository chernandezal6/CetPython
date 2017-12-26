<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Black.aspx.vb" Inherits="Black" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DashBoard - Recaudo</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Names="Calibri" Font-Size="Medium"
            Text="Estadísticas por Banco"></asp:Label><br />
        &nbsp;</div>
        <asp:DataList ID="DataList1" runat="server" CellPadding="4" ForeColor="#333333">
            <ItemTemplate>
                <asp:Label ID="lblBanco" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Banco") %>'></asp:Label><br />
                Total:
                <asp:Label ID="lblTotalAutorizado" runat="server"  Text='<%# DataBinder.Eval(Container.DataItem, "Total", "{0:N2}") %>'></asp:Label><br />
                Facturas:
                <asp:Label ID="lblCantidadFacturas" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Facturas", "{0:N0}") %>'></asp:Label>
            </ItemTemplate>
            <FooterStyle Font-Bold="False" ForeColor="Black" />
            <AlternatingItemStyle BackColor="White" ForeColor="#284775" />
            <ItemStyle BackColor="#F7F6F3" ForeColor="#333333" Font-Bold="False" Font-Italic="False" Font-Names="Calibri" Font-Overline="False" Font-Size="Small" Font-Strikeout="False" Font-Underline="False" />
            <SelectedItemStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <FooterTemplate>
                <span style="font-size: 10pt; font-family: Tahoma"><strong>Monto Total:</strong></span>
                <asp:Label ID="lblSumTotal" runat="server" Font-Names="Calibri" Font-Size="10pt"></asp:Label><br />
                <span style="font-size: 10pt; font-family: Tahoma"><strong>Total Facturas:</strong> </span>
                <asp:Label ID="lblSumFacturas" runat="server" Font-Names="Calibri" Font-Size="10pt"></asp:Label>
            </FooterTemplate>
        </asp:DataList><br />
        --------------------------------<br />
        <br />
        <asp:Label ID="Label2" runat="server" Font-Bold="True" Font-Names="Calibri" Font-Size="Medium"
            Text="Estadísticas por Hora"></asp:Label><br />
        <br />
        <asp:DataList ID="DataList2" runat="server" CellPadding="4" ForeColor="#333333">
            <ItemTemplate>
                <asp:Label ID="lblHora" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Hora") %>'></asp:Label><br />
                Total:
                <asp:Label ID="lblTotalAutorizado" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Total", "{0:N2}") %>'></asp:Label><br />
                Facturas:
                <asp:Label ID="lblCantidadFacturas" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Facturas", "{0:N0}") %>'></asp:Label>
            </ItemTemplate>
            <FooterStyle Font-Bold="False" ForeColor="Black" Font-Italic="False" 
                Font-Names="Calibri" Font-Overline="False" Font-Size="Medium" 
                Font-Strikeout="False" Font-Underline="False" />
            <AlternatingItemStyle BackColor="White" ForeColor="#284775" Font-Bold="False" 
                Font-Italic="False" Font-Names="Calibri" Font-Overline="False" 
                Font-Size="Small" Font-Strikeout="False" Font-Underline="False" />
            <ItemStyle BackColor="#F7F6F3" ForeColor="#333333" Font-Bold="False" 
                Font-Italic="False" Font-Names="Calibri" Font-Overline="False" 
                Font-Size="Small" Font-Strikeout="False" Font-Underline="False" />
            <SelectedItemStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <FooterTemplate>
                <span style="font-size: 10pt; font-family: Tahoma"><strong>Monto Total:</strong></span>
                <asp:Label ID="lblSumTotal" runat="server" Font-Names="Calibri" Font-Size="10pt"></asp:Label><br />
                <span style="font-size: 10pt; font-family: Tahoma"><strong>Total Facturas:</strong></span>
                <asp:Label ID="lblSumFacturas" runat="server" Font-Names="Calibri" Font-Size="10pt"></asp:Label>
            </FooterTemplate>
        </asp:DataList>
    </form>
</body>
</html>
