<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="RegistroCiudadanoTitular.aspx.vb" Inherits="Mantenimientos_RegistroCiudadanoTitular" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">

    <script language="javascript" type="text/javascript">
        function checkNum() {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false;
            }
        }

    </script>
    <div class="header">Registro Ciudadano Titular</div>
    <div>
        <br />
        <fieldset style="width: 350px;border-width: thin;"><legend style="text-align: left">Datos del Centro</legend>
            <table border="0" cellpadding="5" cellspacing="0" style="width: 350px" class="td-content">
            <tr><td colspan="2"></td></tr>

            <tr>
                <td align="right">Rnc:
                </td>
                <td>
                    <asp:TextBox ID="txtNombrePadre" runat="server" Width="200px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtNombrePadre"
                        Display="Dynamic" ErrorMessage="*Requerido" ForeColor="Red"></asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td align="right">Razón Social:</td>
                <td>
                    <asp:TextBox ID="txtNombres" runat="server" Width="200px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtNombres"
                        Display="Dynamic" ErrorMessage="*Requerido" ForeColor="Red"></asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td colspan="2"></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center">
                    <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" />
                    &nbsp;
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False" />
                </td>
            </tr>
        </table>

        </fieldset>
        <br />
        <asp:Label ID="lblMsg" runat="server" ForeColor="Red" Font-Size="10pt" Text="lblMsg" Visible="False"></asp:Label><br />
    </div>

</asp:Content>

