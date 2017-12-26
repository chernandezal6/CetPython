<%@ Page Language="VB" Debug="true" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>
<%@ Register TagPrefix="web" Namespace="WebChart" Assembly="WebChart" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<html xmlns="http://www.w3.org/1999/xhtml" >

<head runat="server">
    <title>Estadisticas de Autorizaciones</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Panel ID="pnlTSS" runat="server" Height="213px" Width="1045px">
            <table>
                <tr>
                    <td align="center">
            <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Names="Verdana" Font-Size="Medium"
                Text="Estadisticas por Banco"></asp:Label></td>
                </tr>
                <tr>
                    <td align="center">
                        &nbsp;<asp:GridView ID="gvBancosTSS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                Font-Names="Verdana" Font-Size="Smaller" ForeColor="#333333" GridLines="None" ShowFooter="True">
                <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                <Columns>
                    <asp:BoundField DataField="Banco" HeaderText="Banco" >
                        <ItemStyle HorizontalAlign="Left" />
                        <FooterStyle HorizontalAlign="Right" />
                        <HeaderStyle HorizontalAlign="Left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Total" DataFormatString="{0:N2}" HtmlEncode=False HeaderText="Total Autorizado" NullDisplayText="0" ReadOnly="True">
                        <ItemStyle HorizontalAlign="Right" />
                        <FooterStyle HorizontalAlign="Right" />
                        <HeaderStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Facturas" DataFormatString="{0:N0}" HeaderText="Cantidad de Facturas" ReadOnly="True" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right" />
                        <FooterStyle HorizontalAlign="Right" />
                        <HeaderStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                </Columns>
                <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
                <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
                <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
                <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" />
            </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td align=center >
<web:chartcontrol runat="server" id="ChartControl2"
                    height="400px" width="600px" legend-position="Bottom" YValuesFormat="{0:c}" ChartPadding="30" HasChartLegend="False" ShowTitlesOnBackground="False" TopPadding="20" YCustomEnd="0" YCustomStart="0" YValuesInterval="0" ShowYValues="False" >
    <YAxisFont StringFormat="Far,Near,Word,LineLimit" Font="Tahoma, 8.25pt" />
    <XTitle StringFormat="Center,Far,Character,LineLimit" Font="Tahoma, 8pt, style=Bold" ForeColor="SteelBlue" />
    <ChartTitle Font="Tahoma, 10pt, style=Bold" StringFormat="Center,Near,Character,LineLimit"
        Text="Monto Total de las Facturas Autorizadas por Banco" ForeColor="White" />
    <XAxisFont StringFormat="Center,Near,Character,LineLimit" />
    <Background Color="CornflowerBlue" Angle="90" EndPoint="100, 400" ForeColor="#80FF80" Type="LinearGradient" />
    <Legend Position="Bottom"></Legend>
    <YTitle StringFormat="Near,Near,Character,DirectionVertical" Font="Tahoma, 8pt, style=Bold" ForeColor="SteelBlue" />
    <PlotBackground Angle="90" EndPoint="100, 400" ForeColor="#FFFFC0" Type="LinearGradient" />
    <Border Color="CornflowerBlue" />
</web:chartcontrol>
<web:chartcontrol runat="server" id="ChartControl1"
                    height="400px" width="362px" gridlines="None" legend-position="Bottom" ChartPadding="30" TopPadding="20" YCustomEnd="0" YCustomStart="0" YValuesInterval="0" >
    <YAxisFont StringFormat="Far,Near,Character,LineLimit" />
    <XTitle StringFormat="Center,Far,Character,LineLimit" Font="Tahoma, 8pt, style=Bold" ForeColor="SteelBlue" />
    <ChartTitle Font="Tahoma, 10pt, style=Bold" StringFormat="Center,Near,Character,LineLimit"
        Text="Cantidad de Facturas Autorizadas por Banco" ForeColor="White" />
    <XAxisFont StringFormat="Center,Near,Character,LineLimit" />
    <Background Color="CornflowerBlue" Angle="90" EndPoint="100, 400" ForeColor="#80FF80" Type="LinearGradient" />
    <Legend Position="Bottom" Font="Tahoma, 8.25pt"></Legend>
    <YTitle StringFormat="Near,Near,Character,DirectionVertical" Font="Tahoma, 8pt, style=Bold" ForeColor="SteelBlue" />
    <PlotBackground Angle="90" EndPoint="100, 400" ForeColor="#FFFFC0" Type="LinearGradient" />
    <Border Color="CornflowerBlue" />
</web:chartcontrol></td>

                </tr>
                <tr>
                    <td align="center">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td align="center">
                    </td>
                </tr>
                <tr>
                    <td align="center">
                        <asp:Label ID="Label2" runat="server" Font-Bold="True" Font-Names="Verdana" Font-Size="Medium"
                            Text="Estadisticas por Hora"></asp:Label></td>
                </tr>
                <tr>
                    <td align="center">
                        <asp:GridView ID="gvHora" runat="server" AutoGenerateColumns="False" CellPadding="4"
                Font-Names="Verdana" Font-Size="Smaller" ForeColor="#333333" GridLines="None" ShowFooter="True">
                <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                <Columns>
                    <asp:BoundField DataField="Hora" HeaderText="Hora" >
                        <ItemStyle HorizontalAlign="Center" />
                        <FooterStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Total" DataFormatString="{0:N2}" HtmlEncode=False HeaderText="Total Autorizado" NullDisplayText="0" ReadOnly="True">
                        <ItemStyle HorizontalAlign="Right" />
                        <FooterStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Facturas" DataFormatString="{0:N0}" HeaderText="Cantidad de Facturas" ReadOnly="True" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right" />
                        <FooterStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                </Columns>
                <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
                <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
                <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
                <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" />
            </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td align="center">
                        <web:chartcontrol runat="server" id="ChartControl3"
                    height="400px" width="362px" legend-position="Bottom" ChartPadding="30" ShowTitlesOnBackground="False" TopPadding="20" YCustomEnd="0" YCustomStart="0" YValuesInterval="0" ShowYValues="False" GridLines="None" >
                            <YAxisFont StringFormat="Far,Near,Word,LineLimit" Font="Tahoma, 8.25pt" />
                            <XTitle StringFormat="Center,Far,Character,LineLimit" Font="Tahoma, 8pt, style=Bold" ForeColor="SteelBlue" />
                            <ChartTitle Font="Tahoma, 10pt, style=Bold" StringFormat="Center,Near,Character,LineLimit"
        Text="Cantidad de Facturas Autorizadas por Hora" ForeColor="White" />
                            <XAxisFont StringFormat="Center,Near,Character,LineLimit" />
                            <Background Color="CornflowerBlue" Angle="90" EndPoint="100, 400" ForeColor="#80FF80" Type="LinearGradient" />
                            <Legend Position="Bottom"></Legend>
                            <YTitle StringFormat="Near,Near,Character,DirectionVertical" Font="Tahoma, 8pt, style=Bold" ForeColor="SteelBlue" />
                            <PlotBackground Angle="90" EndPoint="100, 400" ForeColor="#FFFFC0" Type="LinearGradient" />
                            <Border Color="CornflowerBlue" />
                        </web:chartcontrol>
                        <web:chartcontrol runat="server" id="ChartControl4"
                    height="400px" width="600px" legend-position="Bottom" ChartPadding="30" TopPadding="20" YCustomEnd="0" YCustomStart="0" YValuesInterval="0" HasChartLegend="False" ShowYValues="False" YValuesFormat="{0:c}" >
                            <YAxisFont StringFormat="Far,Near,None,LineLimit" />
                            <XTitle StringFormat="Center,Far,Character,LineLimit" Font="Tahoma, 8pt, style=Bold" ForeColor="SteelBlue" />
                            <PlotBackground Angle="90" EndPoint="100, 400" ForeColor="#FFFFC0" Type="LinearGradient" />
                            <ChartTitle Font="Tahoma, 10pt, style=Bold" StringFormat="Center,Near,Character,LineLimit"
        Text="Monto total autorizado por Hora" ForeColor="White" />
                            <Border Color="CornflowerBlue" />
                            <XAxisFont StringFormat="Center,Near,Character,LineLimit" />
                            <Background Color="CornflowerBlue" Angle="90" EndPoint="100, 400" ForeColor="#80FF80" Type="LinearGradient" />
                            <Legend Position="Bottom" Font="Tahoma, 8.25pt"></Legend>
                            <YTitle StringFormat="Near,Near,Character,DirectionVertical" Font="Tahoma, 8pt, style=Bold" ForeColor="SteelBlue" />
                        </web:chartcontrol>
                    </td>
                </tr>

            </table>
    

            
            </asp:Panel>
        &nbsp;</div>
    </form>
</body>
</html>
