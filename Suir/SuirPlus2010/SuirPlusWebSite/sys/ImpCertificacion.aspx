<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false"
    CodeFile="ImpCertificacion.aspx.vb" Inherits="ImpCertificacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:Panel ID="pnlPDF" runat="server">

        <table cellspacing="0" cellpadding="0" width="100%" border="0">
            <tr>
                <td valign="top" align="center">
                 <asp:Image ID="imgLogo" runat="server" />
                    <br />
                    <br />
                    <asp:Label ID="lblEslogan" Font-Bold="True" Font-Size="Medium" runat="Server"></asp:Label>
                    <br />
                    <br />
                    <font size="10pt"><a style="textdecorator: none" onclick="javascript:print()" href="#">CERTIFICACION No. <strong>
                        <asp:Label ID="lblNoCert" runat="server"></asp:Label></strong></a></font>
                    <br />
                    <br />
                    <font size="10pt">A QUIEN PUEDA INTERESAR</font>
                    <br />
                    <br />
                    <asp:Label ID="lblmsg" runat="server" CssClass="error" Visible="False"></asp:Label>
                    <br />
                </td>
            </tr>
        </table>
        <table cellspacing="0" cellpadding="0" width="100%" border="0">
            <tr>
                <td valign="top" style="text-align: justify">
                    <asp:Label ID="lblPrimerParafo" runat="server" EnableViewState="False" Font-Size="10pt"></asp:Label>
                </td>
            </tr>
        </table>

        <asp:Panel ID="pnlAportePorEmpleador" runat="server" Visible="False" EnableViewState="False">
        </asp:Panel>
        <asp:Panel ID="pnlAportePersonal" runat="server" Visible="False" EnableViewState="False">
        </asp:Panel>
        <asp:Panel ID="pnlIngresoTardio" runat="server" Visible="False" EnableViewState="False">
        </asp:Panel>
        <asp:Panel ID="pnlDiscapacidad" runat="server" Visible="False" EnableViewState="False">
        </asp:Panel>
        <asp:Panel ID="PnlDeuda" runat="server" Visible="False" EnableViewState="False">
        </asp:Panel>

        <br />
        <table width="100%">
            <tr>
                <td style="text-align: justify;">
                    <asp:Label ID="lblSegundoParrafo" runat="server" EnableViewState="False" Font-Size="10pt"></asp:Label>
                </td>
            </tr>
        </table>

        <table id="tblimgFirma" runat="server" width="100%">
            <tr>
                <td>
                    <table>
                        <tr>
                            <td align="center">
                                <asp:Image ID="imgFirma" runat="server"/>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>                    
                    <table runat="server" border="1" width="100%">
                        <tr>
                            <td style="width: 70%" nowrap="nowrap">
                                <asp:Label Font-Size="10pt" ID="lblCodigoBarra" runat="server"></asp:Label>
                            </td>
                            <td style="width: 30%; text-align: center" align="center">
                                <asp:Image ID="imgCodigoBarra" runat="server"/>
                            </td>
                        </tr>
                    </table>
                </td>
                </tr>
        </table>

        <table id="tblimgFirmaPageBreak" runat="server" visible="false" width="100%" style="page-break-before: always;">
            <tr>
                <td>                    
                    <table>
                        <tr>
                            <td align="center">
                                <asp:Image ID="imgFirmaPageBreak" runat="server"/>
                            </td>
                        </tr>
                    </table>
                </td>
                </tr>
             <tr>
                 <td>
                     <table id="tblCodigoBarraPageBreak" runat="server" border="1" width="100%">
                         <tr>
                             <td style="width: 70%">
                                 <asp:Label Font-Size="10pt" ID="lblCodigoBarraPageBreak" runat="server"></asp:Label>
                             </td>
                             <td style="width: 30%; text-align: center" align="center">
                                 <asp:Image ID="imgCodigoBarraPageBreak" runat="server" />
                             </td>
                         </tr>
                     </table>
                 </td>
            </tr>
        </table>

        <table cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
            <tr>
                <td>
                    <hr style="width: 100%" />
                </td>
            </tr>
            <tr>
                <td align="center">
                    <strong>NO HAY NADA ESCRITO DEBAJO DE ESTA LINEA</strong>
                </td>
            </tr>
        </table>

    </asp:Panel>
</asp:Content>
