<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consEstatusNotLey189.aspx.vb" Inherits="Legal_consEstatusNotLey188" title="Consulta" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <br />
    <div class="header">
        Consulta de Estatus de Recalculo de las Notificaciones de Pago - Ley 189-07</div>
    <div class="subHeader">
        &nbsp;</div>
    <br />
    <table border="0" cellpadding="1" cellspacing="1" class="tblWithImagen">
        <tr>
            <td rowspan="3">
                <img alt="" src="../images/upcatriesgo.jpg" />
            </td>
            <td align="right">
                &nbsp;<asp:Label ID="lbltxtRNC" runat="server" Font-Bold="True" Text="RNC o Cédula:"></asp:Label>
            </td>
            <td style="width: 131px">
                &nbsp;<asp:TextBox ID="txtRNC" runat="server" EnableViewState="False" MaxLength="11"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtRNC"
                    Display="Dynamic" ErrorMessage="RNC o Cédula Inválido" SetFocusOnError="True"
                    ValidationExpression="^(\d{9}|\d{11})$" ValidationGroup="0"></asp:RegularExpressionValidator>&nbsp;
            </td>
        </tr>
        <tr>
            <td align="center" colspan="2" valign="middle">
                <asp:Button ID="btnBuscar" runat="server" CausesValidation="False" Text="Buscar" />&nbsp;
                <asp:Button ID="btnLimpiar" runat="server" CausesValidation="False" Text="Limpiar" />&nbsp;
            </td>
        </tr>
    </table>
    <br />
    <asp:Label ID="lblMensajeError" runat="server" CssClass="error" Visible="False"></asp:Label><br />
    <br />
    <asp:Label ID="lblTitulo" runat="server" CssClass="subHeader" Text="El proceso de recalculo de las notificaciones de pago puede tardar varios minutos."></asp:Label><br />
    <br />
    <asp:GridView ID="gvNotificaciones" runat="server" AutoGenerateColumns="False" Font-Size="Large" SkinID="hugeGrid" Width="303px">
        <Columns>
            <asp:BoundField DataField="tipo" />
            <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" >
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
        </Columns>

    </asp:GridView>
</asp:Content>

