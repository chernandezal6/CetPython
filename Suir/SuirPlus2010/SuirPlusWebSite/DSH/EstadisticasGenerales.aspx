<%@ Page Language="VB" AutoEventWireup="false" CodeFile="EstadisticasGenerales.aspx.vb" Inherits="EstadisticasGenerales" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Estadisticas Generales</title>
</head>
<body>
    <form id="form1" runat="server" >

    <div style="text-align:left">
    <table id="InfoGeneral" border="0" cellpadding="0" cellspacing="0" width="600" >
    <tr><td>
            
            <asp:Label ID="Label4" runat="server" Font-Bold="True" Font-Names="Verdana" Font-Size="14pt"
            Text="Estadísticas Generales" ></asp:Label><br />
            
        <table border="0" cellpadding="5" cellspacing="0" width="100%">
            <tr>

                <td style="font-weight: bold; font-size: 12pt; color: white; background-color: #990000; text-align: left; width: 470px;" valign="middle">
                    <span style="font-size: 10pt; font-family: Verdana; border-right-style: none">
                        <asp:Label ID="lblDescripcion" runat="server" Font-Bold="True" Text="Descripción"
                            Width="101px"></asp:Label>
                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                        &nbsp; &nbsp; &nbsp;</span></td>
                <td style="font-weight: bold; font-size: 12pt; width: 130px; color: white; background-color: #990000;
                    text-align: right" valign="middle">
                        <asp:Label ID="lblCantidad" runat="server" Text="Cantidad" Width="69px"></asp:Label></td>
            </tr>
            <tr>            
                <td  style="width: 470px" align="left">
                    <br />
                    <asp:Label ID="lblDescripcionSFS" runat="server" Font-Bold="False" Font-Names="Verdana" Font-Size="10pt"></asp:Label><br />
                    <br />
                </td>
                <td align="right" style="width: 130px">
                    <br />
                    <asp:Label ID="lblAfiliadosSFS" runat="server" Font-Bold="False" Font-Names="Verdana" Font-Size="10pt"></asp:Label><br />
                    <br />
                </td>
            </tr>
            <tr style="background-color:#FFFBD6">
                <td style="width: 470px" align="left">
                    <br />
                    <asp:Label ID="lblDescripcionTrab" runat="server" Font-Bold="False" Font-Names="Verdana" Font-Size="10pt"></asp:Label><br />
                    <br />
                </td>
                <td align="right" style="width: 130px">
                    <br />
                    <asp:Label ID="lblTrabajadores" runat="server" Font-Bold="False" Font-Names="Verdana" Font-Size="10pt"></asp:Label><br />
                    <br />
                </td>
            </tr>
            <tr>
                <td style="width: 470px" align="left">
                    <br />
                    <asp:Label ID="lblDescripcionEmp" runat="server" Font-Bold="False" Font-Names="Verdana" Font-Size="10pt"></asp:Label><br />
                    <br />
                </td>
                <td align="right" style="width: 130px">
                    <br />
                    <asp:Label ID="lblEmpresas" runat="server" Font-Bold="False" Font-Names="Verdana" Font-Size="10pt"></asp:Label><br />
                    <br />
                </td>
            </tr>
            <tr  style="background-color:#FFFBD6">
                <td style="width: 470px" align="left">
                    <br />
                    <asp:Label ID="lblDescripcionEmpAp" runat="server" Font-Bold="False" Font-Names="Verdana" Font-Size="10pt"></asp:Label><br />
                    <br />
                </td>
                <td align="right" style="width: 130px">
                    <br />
                    <asp:Label ID="lblEmpresasAP" runat="server" Font-Bold="False" Font-Names="Verdana" Font-Size="10pt"></asp:Label><br />
                    <br />
                </td>
            </tr>
            <tr>
                <td align="left" style="font-weight: bold; font-size: 12pt; color: white; background-color: #990000; text-align: left; width: 470px;" valign="middle" colspan="2">
                    <span style="font-size: 10pt; font-family: Verdana">&nbsp;</span></td>
            </tr>
            <tr>
                <td align="left" style="width: 470px">
                </td>
                <td align="right" style="width: 130px">
                </td>
            </tr>
        </table>
        &nbsp; &nbsp;
        <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" Font-Names="Verdana" Font-Size="8pt"></asp:Label><br />
    </td></tr>
    </table>  
    </div>
        <br />
        &nbsp;
    </form>
</body>
</html>
