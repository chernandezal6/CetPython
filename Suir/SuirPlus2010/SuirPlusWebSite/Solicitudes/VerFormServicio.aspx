<%@ Page Language="VB" AutoEventWireup="false" CodeFile="VerFormServicio.aspx.vb"
    Inherits="VerFormServicio" %>

<%@ Register Src="../Controles/UCTelefono.ascx" TagName="UCTelefono" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
        
        .style3
        {
            width: 186px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <!--Encabezado de la certificacion-->
    <table cellspacing="0" cellpadding="0" width="100%" border="0">
        <tr>
            <td valign="top" align="center" height="86">
                <asp:Label ID="lblEslogan" Font-Bold="True" Font-Size="Medium" runat="Server"></asp:Label>
                <br />
                <br />
                <br />
                <font size="3pt"><a style="textdecorator: none" onclick="javascript:print()" href="#">
                    Solicitud de Servicio</a></font>
                <br />
                <div style="text-align: right">
                    <font size="1pt">
                        No: <strong>
                            <asp:Label ID="lblNoSolicitud" runat="server"></asp:Label></strong></font>
                            <br />
                             <font size="1pt">
                        Fecha: <strong>
                            <asp:Label ID="lblFecha" runat="server"></asp:Label></strong></font>
                </div>
                <br />
                <font size="2pt"><a style="textdecorator: none" onclick="javascript:print()" href="#">
                    Tipo de Servicio: <strong>
                        <asp:Label ID="lblTipoServicio" runat="server"></asp:Label></strong></a></font><br>
                <br />
                <br />
                <br />
                <br />
            </td>
        </tr>
    </table>
    <table cellspacing="2" cellpadding="0" width="500px" align="center">
        <tr>
            <td nowrap="nowrap">
                <table class="style1" runat="server" id="tblEmpleador">
                    <tr>
                        <td class="subHeader" colspan="3">
                            Datos de la empresa
                        </td>
                    </tr>
                    <tr>
                        <td class="style2" width="115">
                            Razon Social:
                        </td>
                        <td colspan="2">
                            <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="style2">
                            RNC:
                        </td>
                        <td class="style3">
                            <asp:Label ID="lblRNC" runat="server" CssClass="labelData"></asp:Label>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="style2">
                            &nbsp;
                        </td>
                        <td class="style3">
                            &nbsp;&nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                </table>
                <table id="tblCiudadano" runat="server" class="style1">
                    <tr>
                        <td class="subHeader" colspan="2">
                            Datos del Solicitante
                        </td>
                    </tr>
                    <tr>
                        <td class="style2" width="115px">
                            Nombre del Solicitante:
                        </td>
                        <td>
                            <asp:Label CssClass="labelData" ID="lblNombre" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="style2">
                            No. Documento:
                        </td>
                        <td>
                            <asp:Label CssClass="labelData" ID="lblNoDocumento" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="text-align: center">
                <asp:Panel ID="pnlFirmas" runat="server" style="text-align: right">
                    <table cellspacing="0" cellpadding="0" width="520px">
                        <tr>
                            <td style="text-align: left">
                                <asp:Label ID="lblTituloMotivo" runat="server" CssClass="labelData">Observación de la solicitud:</asp:Label>
                                <br />
                                <br />
                                <asp:Label ID="lblMotivo" runat="server"></asp:Label>
                                <br />
                                <br />

                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <table cellspacing="0" cellpadding="0" width="520px">
                        <tr>
                            <td>
                                <table cellspacing="0" cellpadding="0" width="250px" align="left" border="0">
                                    <tr>
                                        <td align="center">
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td  style="width: 9; text-align: center;">
                                            _______________________________________
                                            <br />
                                            <strong>
                                            <asp:Label ID="lblSolicitante" runat="server" CssClass="labelData">Solicitante</asp:Label>
                                            <br />
                                            &nbsp;</strong></td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="width: 9">
                                            <br />
                                            <asp:Label ID="lblCedula" runat="server">Cédula:</asp:Label>
                                            _______________________________________
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                <table cellspacing="0" cellpadding="0" width="250px" align="left" border="0">
                                    <tr>
                                        <td align="center">
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td  style="width: 9;text-align: center;">
                                            _______________________________________
                                            <br />
                                            <strong>
                                            <asp:Label ID="lblRepresentate" runat="server" CssClass="labelData">Representante</asp:Label>
                                            <br />
                                            &nbsp;</strong></td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="width: 9">
                                            <br />
                                            <asp:Label ID="lblCedulaRep" runat="server">Cédula:</asp:Label>
                                            _______________________________________
                                        </td>
                                    </tr>
                                </table>
                                
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <table cellspacing="0" cellpadding="0" width="520px">
                        <tr>
                            <td style="text-align: right">
                                <asp:Label ID="lblUsuario" runat="server" Font-Italic="True"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center">
                                <strong style="text-align: center">NO HAY NADA ESCRITO DEBAJO DE ESTA LINEA</strong>&nbsp;
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
