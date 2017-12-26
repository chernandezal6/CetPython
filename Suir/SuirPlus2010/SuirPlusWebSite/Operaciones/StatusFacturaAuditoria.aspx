<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="StatusFacturaAuditoria.aspx.vb" Inherits="StatusFacturaAuditoria" Title="Notificaciones por Nro. de Referencia" %>

<%@ Register Src="../Controles/ucNotificacionTSSEncabezado.ascx" TagName="ucNotificacionTSSEncabezado"
    TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script language="vb" runat="server">
        Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
            'Me.PermisoRequerido = 61
        End Sub
    </script>
    <script language="javascript" type="text/javascript">
        function checkNum() {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false;
            }
        }
         
    
    </script>
    <asp:UpdatePanel runat="server" ID="updPanel">
        <ContentTemplate>
            <asp:Label ID="lblTitulo" runat="server" CssClass="header">Notificaciones por Nro. de Referencia</asp:Label>
            <br />
            <br />
            <table class="tblWithImagen" style="border-collapse: collapse" cellspacing="1" cellpadding="1">
                <tr>
                    <td rowspan="4">
                        <img src="../images/calcfactura.jpg" alt="" />
                    </td>
                    <td>
                        <br />
                        &nbsp; Nro. Referencia
                    </td>
                    <td>
                        <br />
                        &nbsp;<asp:TextBox onKeyPress="checkNum()" ID="txtReferencia" runat="server" MaxLength="16"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right" colspan="2">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center" colspan="2">
                        <asp:Button ID="btBuscar" runat="server" Text="Buscar"></asp:Button>&nbsp;&nbsp;&nbsp;
                        <asp:Button ID="btLimpiar" runat="server" Text="Limpiar" EnableViewState="False"
                            CausesValidation="False"></asp:Button>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center; height: 18px;">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator" runat="server" Display="Dynamic"
                            ErrorMessage="Nro. de Referencia y/o Autorizacion es requerido." ControlToValidate="txtReferencia"
                            Font-Bold="True"></asp:RequiredFieldValidator><br />
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" Display="Dynamic"
                            ValidationExpression="0*[1-9][0-9]*" ErrorMessage="Referencia y/o Autorización Inválida"
                            ControlToValidate="txtReferencia" Font-Bold="True"></asp:RegularExpressionValidator><asp:Label
                                CssClass="error" ID="lblMensaje" runat="server" EnableViewState="False" />&nbsp;
                    </td>
                </tr>
            </table>
            <br />
            <asp:Button ID="btnMarcarEstatus" runat="server" OnClientClick="javascript:return confirm('Esta Seguro Marcar de manera definitiva esta notificación?');"
                Text="Marcar Definitivo" Font-Size="Medium" Visible="False" />
            <br />&nbsp;
            <uc1:ucNotificacionTSSEncabezado ID="ucNotTSS" runat="server" Visible="false" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
