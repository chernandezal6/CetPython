<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Op.aspx.vb" Inherits="Op" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<html xmlns="http://www.w3.org/1999/xhtml" >

<head runat="server">
    <title>Operaciones</title>
</head>
<body>
  <form id="form1" runat="server">
    <div>
        <table border="0" cellpadding="0" style="width: 100%">
            <tr>
                <td >
                    <asp:Label ID="Label4" runat="server" Font-Bold="True" Font-Names="Verdana" Font-Size="Medium"
                        Text="Archivos Enviados" ></asp:Label><br />
                    <asp:GridView ID="gvArcEnv" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        Font-Names="Verdana" Font-Size="Smaller" ForeColor="#333333" GridLines="None"
                        ShowFooter="True" Width="350px">
                        <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                        <Columns>
                            <asp:BoundField DataField="Descripcion" HeaderText="Descripci&#243;n" HtmlEncode="False"
                                NullDisplayText="0" ReadOnly="True">
                                <ItemStyle HorizontalAlign="Left" />
                                <FooterStyle HorizontalAlign="Right" />
                                <HeaderStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Cantidad" DataFormatString="{0:N0}" HeaderText="Cantidad"
                                ReadOnly="True" HtmlEncode="False">
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
                    <br />
                </td>
                <td>
                    <asp:Label ID="Label3" runat="server" Font-Bold="True" Font-Names="Verdana" Font-Size="Medium"
                        Text="Movimientos" ></asp:Label><br />
                    <asp:GridView ID="gvMov" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        Font-Names="Verdana" Font-Size="Smaller" ForeColor="#333333" GridLines="None"
                        ShowFooter="True" Width="350px">
                        <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                        <Columns>
                            <asp:BoundField DataField="Descripcion" HeaderText="Descripci&#243;n" HtmlEncode="False"
                                NullDisplayText="0" ReadOnly="True">
                                <ItemStyle HorizontalAlign="Left" />
                                <FooterStyle HorizontalAlign="Right" />
                                <HeaderStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Cantidad" DataFormatString="{0:N0}" HeaderText="Cantidad"
                                ReadOnly="True" HtmlEncode="False">
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
                    <br />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="Label5" runat="server" Font-Bold="True" Font-Names="Verdana" Font-Size="Medium"
                        Text="Empresas Registradas"></asp:Label><br />
                    <asp:GridView ID="gvEmp" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        Font-Names="Verdana" Font-Size="Smaller" ForeColor="#333333" GridLines="None"
                        ShowFooter="True" Width="350px">
                        <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                        <Columns>
                            <asp:BoundField DataField="Descripcion" HeaderText="Descripci&#243;n" HtmlEncode="False"
                                NullDisplayText="0" ReadOnly="True">
                                <ItemStyle HorizontalAlign="Left" />
                                <FooterStyle HorizontalAlign="Right" />
                                <HeaderStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Cantidad" DataFormatString="{0:N0}" HeaderText="Cantidad"
                                ReadOnly="True" HtmlEncode="False">
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
                    <br />
                </td>
                <td>
                    <asp:Label ID="Label6" runat="server" Font-Bold="True" Font-Names="Verdana" Font-Size="Medium"
                        Text="Certificaciones Emitidas"></asp:Label><br />
                    <asp:GridView ID="gvCer" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        Font-Names="Verdana" Font-Size="Smaller" ForeColor="#333333" GridLines="None"
                        ShowFooter="True" Width="350px">
                        <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                        <Columns>
                            <asp:BoundField DataField="Descripcion" HeaderText="Descripci&#243;n" HtmlEncode="False"
                                NullDisplayText="0" ReadOnly="True">
                                <ItemStyle HorizontalAlign="Left" />
                                <FooterStyle HorizontalAlign="Right" />
                                <HeaderStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Cantidad" DataFormatString="{0:N0}" HeaderText="Cantidad"
                                ReadOnly="True" HtmlEncode="False">
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
                    <br />
                </td>
            </tr>
        </table>
    
    </div>
    </form>

</body>
</html>
