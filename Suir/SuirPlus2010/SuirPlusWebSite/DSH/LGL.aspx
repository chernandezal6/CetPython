<%@ Page Language="VB" AutoEventWireup="false" CodeFile="LGL.aspx.vb" Inherits="LGL" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Legal</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table border="0" cellpadding="0" style="width: 100%">
            <tr>
                <td>
                    <br />
                    <asp:Label ID="Label2" runat="server" Font-Bold="True" Font-Names="Verdana" Font-Size="Small"
                        Text="Acuerdos de pago por status"></asp:Label><br />
                    <asp:GridView ID="gvAcuSts" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        Font-Names="Verdana" Font-Size="X-Small" ForeColor="#333333" GridLines="None"
                        ShowFooter="True" Width="380px">
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
                </td>
                <td>
                    <br />
                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Names="Verdana" Font-Size="Small"
                        Text="Acuerdos de pago por departamento"></asp:Label><br />
                    <asp:GridView ID="gvAcuDep" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        Font-Names="Verdana" Font-Size="X-Small" ForeColor="#333333" GridLines="None"
                        ShowFooter="True"  Width="380px">
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
                </td>
            </tr>
            <tr>
                <td>
                    <br />
                    <asp:Label ID="Label5" runat="server" Font-Bold="True" Font-Names="Verdana" Font-Size="Small"
                        Text="Ley 189-07 - Hoy"></asp:Label><br />
                    <asp:GridView ID="gvLeyHoy" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        Font-Names="Verdana" Font-Size="X-Small" ForeColor="#333333" GridLines="None"
                        ShowFooter="True" Width="380px">
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
                </td>
                <td>
                    <br />
                    <asp:Label ID="Label4" runat="server" Font-Bold="True" Font-Names="Verdana" Font-Size="Small"
                        Text="Ley 189-07 - Todos"></asp:Label><br />
                    <asp:GridView ID="gvLeyAll" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        Font-Names="Verdana" Font-Size="X-Small" ForeColor="#333333" GridLines="None"
                        ShowFooter="True" Width="380px">
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
                </td>
            </tr>
            <tr>
                <td>
                    <br />
                    <asp:Label ID="Label3" runat="server" Font-Bold="True" Font-Names="Verdana" Font-Size="Small"
                        Text="Solicitudes por Usuario - Hoy"></asp:Label><br />
                    <asp:GridView ID="gvSolUsrHoy" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        Font-Names="Verdana" Font-Size="X-Small" ForeColor="#333333" GridLines="None"
                        ShowFooter="True" Width="380px">
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
                </td>
                <td>
                    <br />
                    <asp:Label ID="Label6" runat="server" Font-Bold="True" Font-Names="Verdana" Font-Size="Small"
                        Text="Solicitudes por Usuario - Todos"></asp:Label><br />
                    <asp:GridView ID="gvSolUsrAll" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        Font-Names="Verdana" Font-Size="X-Small" ForeColor="#333333" GridLines="None"
                        ShowFooter="True" Width="380px">
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
                </td>
            </tr>
            <tr>
                <td>
                    <br />
                    <asp:Label ID="Label7" runat="server" Font-Bold="True" Font-Names="Verdana" Font-Size="Small"
                        Text="Acuerdos de Pago por Usuario - Hoy"></asp:Label><br />
                    <asp:GridView ID="gvAcuUsrHoy" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        Font-Names="Verdana" Font-Size="X-Small" ForeColor="#333333" GridLines="None"
                        ShowFooter="True" Width="380px">
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
                </td>
                <td>
                    <br />
                    <asp:Label ID="Label8" runat="server" Font-Bold="True" Font-Names="Verdana" Font-Size="Small"
                        Text="Acuerdos de Pago por Usuario - Todos"></asp:Label><br />
                    <asp:GridView ID="gvAcuUsrAll" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        Font-Names="Verdana" Font-Size="X-Small" ForeColor="#333333" GridLines="None"
                        ShowFooter="True" Width="380px">
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
                </td>
            </tr>


        </table>
    </div>
    </form>
</body>
</html>
