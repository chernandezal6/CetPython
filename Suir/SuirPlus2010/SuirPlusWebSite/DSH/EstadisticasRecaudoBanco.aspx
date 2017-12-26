<%@ Page Language="VB" AutoEventWireup="false" CodeFile="EstadisticasRecaudoBanco.aspx.vb" Inherits="EstadisticasRecaudoBanco" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Estadísticas Recaudo Banco</title>
</head>
<body>
    <form id="form1" runat="server">
    <div align=center>
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                <asp:Label ID="lblTitulo" runat="server" Font-Bold="True" Font-Size="16pt" Text="Cuadro Estadístico Por  Banco" Font-Underline="True" Font-Names="Verdana"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <br />
                        <asp:Label ID="lblTitulo1" runat="server" Font-Bold="True" Font-Size="Medium" Text="Estadísticas de Recaudo Por Banco" Font-Names="Verdana"></asp:Label><br />
                        <asp:GridView ID="gvRecaudoPorBanco" runat="server" AutoGenerateColumns="False" CellPadding="4"
                Font-Names="Verdana" Font-Size="Smaller" ForeColor="#333333" GridLines="None" ShowFooter="True">
                <FooterStyle BackColor="ForestGreen" Font-Bold="True" ForeColor="White" />
                <Columns>
                    <asp:BoundField DataField="Banco" HeaderText="Banco" >
                        <ItemStyle HorizontalAlign="Left" Font-Names="verdana" Font-Size="Small" />
                        <FooterStyle HorizontalAlign="Right" />
                        <HeaderStyle HorizontalAlign="Left" Font-Names="verdana" Font-Size="Small" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Total" DataFormatString="{0:N2}" HtmlEncode="False" HeaderText="Autorizado" NullDisplayText="0" ReadOnly="True">
                        <ItemStyle HorizontalAlign="Right" Font-Names="verdana" Font-Size="Small" />
                        <FooterStyle HorizontalAlign="Right" />
                        <HeaderStyle HorizontalAlign="Right" Font-Names="verdana" Font-Size="Small" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Facturas" DataFormatString="{0:N0}" HeaderText="Facturas" ReadOnly="True" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right" Font-Names="verdana" Font-Size="Small" />
                        <FooterStyle HorizontalAlign="Right" />
                        <HeaderStyle HorizontalAlign="Right" Font-Names="verdana" Font-Size="Small" />
                    </asp:BoundField>
                </Columns>
                <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
                <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
                <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
                <HeaderStyle BackColor="ForestGreen" Font-Bold="True" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" BorderColor="White" />
            </asp:GridView>
                    <br />
                            <asp:Label ID="lblCantFact" runat="server" Font-Bold="True" Font-Size="Medium"
                                Text="Cantidad de Facturas Por Banco" Font-Names="Verdana"></asp:Label><br />
                    <img runat="server" id="chtCantFactBancos" title="Cantidad De Facturas por Banco" /><br />
                    <br />
                            <asp:Label ID="lblRecaudoPorBanco" runat="server" Font-Bold="True" Font-Size="Medium"
                                Text="Total Recaudado Por Banco" Font-Names="Verdana"></asp:Label><br />
                
                <img runat="server" id="chtRecaudoBancosLegend" title="Legenda Recaudo por Banco" />
                <img runat="server" id="chtRecaudoBancosBar" title="Total Recaudo por Banco" /></td>
            </tr>
            <tr>
                <td>
                </td>
            </tr>
            <tr>
                <td>
                <asp:Label ID="lblTitulo2" runat="server" Font-Bold="True" Font-Size="16pt" Text="Cuadro Estadístico Por  Hora" Font-Underline="True" Font-Names="Verdana"></asp:Label></td>
            </tr>
            <tr>
                <td>
                    <br />
                        <asp:Label ID="lblTitulo3" runat="server" Font-Bold="True" Font-Size="Medium" Text="Estadísticas de Recaudo Por Hora" Font-Names="Verdana"></asp:Label><br />
                        <asp:GridView ID="gvRecaudoPorHora" runat="server" AutoGenerateColumns="False" CellPadding="4"
                Font-Names="Verdana" Font-Size="Smaller" ForeColor="#333333" GridLines="None" ShowFooter="True">
                <FooterStyle BackColor="ForestGreen" Font-Bold="True" ForeColor="White" />
                <Columns>
                    <asp:BoundField DataField="Hora" HeaderText="Hora" >
                        <ItemStyle HorizontalAlign="Left" Font-Names="verdana" Font-Size="Small" />
                        <FooterStyle HorizontalAlign="Right" />
                        <HeaderStyle HorizontalAlign="Left" Font-Names="verdana" Font-Size="Small" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Total" DataFormatString="{0:N2}" HtmlEncode="False" HeaderText="Autorizado" NullDisplayText="0" ReadOnly="True">
                        <ItemStyle HorizontalAlign="Right" Font-Names="verdana" Font-Size="Small" />
                        <FooterStyle HorizontalAlign="Right" />
                        <HeaderStyle HorizontalAlign="Right" Font-Names="verdana" Font-Size="Small" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Facturas" DataFormatString="{0:N0}" HeaderText="Facturas" ReadOnly="True" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right" Font-Names="verdana" Font-Size="Small" />
                        <FooterStyle HorizontalAlign="Right" />
                        <HeaderStyle HorizontalAlign="Right" Font-Names="verdana" Font-Size="Small" />
                    </asp:BoundField>
                </Columns>
                <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
                <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
                <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
                <HeaderStyle BackColor="ForestGreen" Font-Bold="True" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" BorderColor="White" />
            </asp:GridView>
                    <br />
                            <asp:Label ID="lblCantFacHora" runat="server" Font-Bold="True" Font-Size="Medium"
                                Text="Cantidad de Facturas Por Hora" Width="318px" Font-Names="Verdana"></asp:Label>
                    <br />
                    <img runat="server" id="chtCantFactHoras" title="Cantidad De Facturas por Hora" /><br />
                    <br />
                            <asp:Label ID="lblRecaudoHora" runat="server" Font-Bold="True" Font-Size="Medium"
                                Text="Total Recaudado Por Hora" Font-Names="Verdana"></asp:Label>
                    <br />
                 <img runat="server" id="chtRecaudoHorasLegend" title="Total Recaudo por Hora" />
                <img runat="server" id="chtRecaudoHorasBar" title="Total Recaudo por Hora" /></td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
