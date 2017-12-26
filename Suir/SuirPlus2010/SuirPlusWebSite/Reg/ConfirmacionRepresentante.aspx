<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusNoAutenticado.master" AutoEventWireup="false" CodeFile="ConfirmacionRepresentante.aspx.vb" Inherits="Reg_ConfirmacionRepresentante" %>


<%--<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
   </asp:Content>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">


    <div align="center">
        <fieldset style="width: 600px">
            <table width="600px">
                <tr>
                    <td align="center">
  <%--                      <asp:Image ID="Image1" runat="server" ImageUrl="~/images/logoTSShorizontal.gif" />--%>
                        <br />
                        <br />
                        <asp:Label ID="lblMsgOk" runat="server" ForeColor="Blue" Font-Size="Medium" Visible="false"></asp:Label>
                        <asp:Label ID="lblMsgErr" runat="server" ForeColor="Red" Font-Size="Medium" Visible="false"></asp:Label>
                        <br />
                        <br />
                        <asp:LinkButton ID="lbContinuar" runat="server" Font-Size="Medium" Font-Underline="True">Continuar</asp:LinkButton>
                    </td>
                </tr>
            </table>
        </fieldset>
    </div>
</asp:Content>

