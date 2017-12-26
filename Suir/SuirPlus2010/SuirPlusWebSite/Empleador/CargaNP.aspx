<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CargaNP.aspx.vb" Inherits="Empleador_CargaNP" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:Label ID="lblTitulo" runat="server" CssClass="header">Carga Notificación de Pago</asp:Label>
    <br />
    <br />
    <table class="tblWithImagen" id="tblInicio" runat="server" style="BORDER-COLLAPSE: collapse" cellspacing="1" cellpadding="1">
        <tr>
            <td rowspan="4">
                <img src="../images/calcfactura.jpg" alt="" />
            </td>
            <td>
                <br />
                &nbsp;
                        <asp:Label ID="Label1" runat="server" CssClass="labelData" 
                    Text="Digite el monto que desea aportar:"></asp:Label>
            </td>
            <td>
                <br />
                &nbsp;<asp:TextBox onKeyPress="checkNum()" OnKeyUp="Sel()" onChange="Sel()" ID="txtMonto" runat="server" MaxLength="16"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="text-align: right" colspan="2">&nbsp;</td>
        </tr>
        <tr>
            <td style="text-align: center" colspan="2">
                <asp:Button ID="btnAceptar" runat="server" Text="Aceptar"></asp:Button>&nbsp;&nbsp;&nbsp;
            </td>
        </tr>
        <tr>

            <td colspan="2" style="text-align: center; height: 18px;">
                <asp:RequiredFieldValidator ID="RequiredFieldValidator" runat="server" Display="Dynamic" ErrorMessage="El monto es requerido"
                    ControlToValidate="txtMonto" Font-Bold="True"></asp:RequiredFieldValidator><br />
                <asp:Label CssClass="error" ID="lblMensaje" runat="server" EnableViewState="False" />&nbsp;
            </td>
        </tr>
    </table>
    <asp:Label ID="lblinfo" runat="server" CssClass="labelSubtitulo" Visible="False">Gracias por introducir el monto dentro de unos minutos su factura sera generada..</asp:Label>

</asp:Content>

