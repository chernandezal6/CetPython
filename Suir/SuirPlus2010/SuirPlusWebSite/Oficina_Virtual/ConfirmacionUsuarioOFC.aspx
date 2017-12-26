<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusOficinaVirtual.master" AutoEventWireup="false" CodeFile="ConfirmacionUsuarioOFC.aspx.vb" Inherits="Oficina_Virtual_ConfirmacionUsuarioOFC" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <div align="center">
        <fieldset style="width: 600px">
            <table width="600px">
                <tr>
                    <td align="center">
                         <br />
                        <br />
                        <asp:Label ID="lblMsgOk" runat="server" ForeColor="Blue" Font-Size="Medium" Visible="false"></asp:Label>
                        <asp:Label ID="lblMsgErr" runat="server" ForeColor="Red" Font-Size="Medium" Visible="false"></asp:Label>
                        <br />
                        <br />
                        <asp:LinkButton ID="lbContinuar" runat="server" Font-Size="Medium" Font-Underline="True" Visible ="false">Continuar</asp:LinkButton>
                    </td>
                </tr>
            </table>
        </fieldset>
    </div>
</asp:Content>
