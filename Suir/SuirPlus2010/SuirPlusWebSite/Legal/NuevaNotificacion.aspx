<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="NuevaNotificacion.aspx.vb" Inherits="Legal_NuevaNotificacion" title="Notificación Legal" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    
    <div class="header">Notificación Legal</div>
    <br />    
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="error" />
    <asp:Label ID="lblMsg" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
    <asp:panel ID="pnlGeneral" runat="server" Visible="true">
    <table cellpadding="0" cellspacing="2" style="width: 550px" class="td-content">
        <tr>
            <td style="width: 20%">
                RNC</td>
            <td>
                <asp:TextBox ID="txtRnc" runat="server" MaxLength="11"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="error"
                    Display="Dynamic" ErrorMessage="El RNC es Requerido." ControlToValidate="txtRnc" SetFocusOnError="True">*</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtRnc"
                    CssClass="error" Display="Dynamic" ErrorMessage="RNC Inválido" ValidationExpression="^(\d{9}|\d{11})$">RNC Inválido</asp:RegularExpressionValidator></td>
        </tr>
        <tr>
            <td>
                Tipo Notificación</td>
            <td>
                <asp:DropDownList ID="drpTipoNot" runat="server" CssClass="dropDowns">
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="error"
                    Display="Dynamic" ErrorMessage="Elija un tipo de notificación" ControlToValidate="drpTipoNot" InitialValue="-1" SetFocusOnError="True">*</asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td>
                Comentario</td>
            <td>
                <asp:TextBox ID="txtComentario" runat="server" Height="58px" MaxLength="200" TextMode="MultiLine"
                    Width="363px" CssClass="textbox"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="error"
                    Display="Dynamic" ErrorMessage="El comentario es requerido." ControlToValidate="txtComentario">*</asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td>
            </td>
            <td align="right">
                &nbsp;<asp:Button ID="btnCrear" runat="server" Text="Crear Notificación" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False" /></td>
        </tr>
    </table>
    </asp:panel>
    <asp:Panel ID="pnlConfirmacion" runat="server" Visible="false">
    <table cellpadding="0" cellspacing="2" style="width: 550px" class="td-content">
        <tr>
            <td align="center" colspan="2" style="height: 12px">
                <span class="subHeader">Confirmación </span>
             </td>
        </tr>
        <tr>
            <td style="width: 20%;">
                RNC</td>
            <td>
                <asp:Label ID="lblRNC" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td style="width: 20%">
                Razón Social</td>
            <td>
                <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td>
                Tipo Notificación</td>
            <td>
                <asp:Label ID="lblTipoNot" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td>
                Documento</td>
            <td>
                <asp:FileUpload ID="fuDocument" runat="server" Width="228px" CssClass="textbox" />(Especificar
                Documento Aquí)</td>
        </tr>
        <tr>
            <td>
                Comentario</td>
            <td>
                <asp:Label ID="lblComentario" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td style="height: 18px">
            </td>
            <td align="right">
                &nbsp;<asp:Button ID="btnGuardar" runat="server" Text="Guardar" />
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False" /></td>
        </tr>
    </table>
    </asp:Panel>    
</asp:Content>

