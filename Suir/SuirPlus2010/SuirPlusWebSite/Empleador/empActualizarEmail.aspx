<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false"
    CodeFile="empActualizarEmail.aspx.vb" Inherits="Empleador_empActualizarEmail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <div id="divprincipal" runat="server" align="center">    <br />
    <div id="divTitulo" class="header">
        <asp:Label ID="lblTitulo" runat="server" Text="Actualizar Correo Electrónico"></asp:Label>
    </div>
    <div id="divPantalla" runat="server">
    <fieldset style="width: 380px; height: 150px;">
        <table width="350px">
            <tr>
                <td valign="middle" colspan="2" align="center">
                    &nbsp;<asp:Image ID="Image1" runat="server" 
                        ImageUrl="~/images/logoTSShorizontalsmaller.gif" />
<br />
                </td>
            </tr>
            <tr>
                <td nowrap="nowrap" valign="top" align="right">
                    &nbsp;</td>
                <td valign="top">
                    &nbsp;</td>
            </tr>
            <tr>
                <td nowrap="nowrap" valign="top" align="right">
                    Email Actual:</td>
                <td valign="top">
                    <asp:TextBox ID="txtEmail" runat="server" Width="240px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="reqFieldEmail" runat="server"
                        ControlToValidate="txtEmail" ErrorMessage="El campo de Email es requerido" 
                        Display="Dynamic">*</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Correo electrónico erróneo." SetFocusOnError="True" 
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                        Display="Dynamic">*</asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td nowrap="nowrap" valign="top" align="right">
                    Confirmar Email:
                </td>
                <td valign="top">
                    <asp:TextBox ID="txtConfirmarEmail" runat="server" Width="240px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                    ControlToValidate="txtConfirmarEmail" ErrorMessage="La confirmación del Email es requerida"
                        Display="Dynamic">*</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtConfirmarEmail"
                        ErrorMessage="Correo electrónico erróneo." SetFocusOnError="True" 
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                        Display="Dynamic">*</asp:RegularExpressionValidator>
                    <asp:CompareValidator ID="CompareValidator1" runat="server" 
                        ControlToCompare="txtEmail" ControlToValidate="txtConfirmarEmail" 
                        Display="Dynamic" 
                        ErrorMessage="El email actual debe ser igual al email de confirmación">*</asp:CompareValidator>
                </td>
            </tr>
            <tr>
                <td align="center" colspan="2">
                    <br />
                    <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" CssClass="Button" />
                    &nbsp;<asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="Button"
                        CausesValidation="False" />
                </td>
            </tr>
        </table>
    </fieldset>
    </div>
    <br />
    <asp:Label ID="lblMsg" runat="server" Visible="False" ForeColor="Red"></asp:Label>
    <br /><br />
    <asp:LinkButton ID="lbRegresar" runat="server" Visible="false" Font-Size="Medium" Font-Underline="True">Regresar</asp:LinkButton>
    <asp:ValidationSummary ID="valSum" runat="server" 
        HeaderText="* Datos Requeridos"></asp:ValidationSummary>
    </div>

</asp:Content>
