<%@ Page Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false" CodeFile="SolicitudInformacion.aspx.vb" Inherits="sys_SolicitudInformacion" Title="Solicitud de Información" %>

<%@ Register TagPrefix="uc1" TagName="UCTelefono" Src="../Controles/UCTelefono.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <style>
        #idSpan {
            font-size: 9px;
        }
    </style>
    <span class="header">Formulario de Solicitud de Información Pública<br />
    </span>
    <br />
    <asp:Label ID="lblNroFormulario" runat="server" Font-Bold="True" Text="OAI-FO-001"></asp:Label>
    <br />
    <asp:Label ID="lblVersion" runat="server" Font-Bold="True" Text="Versión 3.0"></asp:Label>
    <br />
    <asp:Label ID="lblMensaje" runat="server" CssClass="error" Visible="False"></asp:Label>
    <asp:ValidationSummary ID="errorSumary" runat="server" CssClass="error"></asp:ValidationSummary>
    <table class="td-content" id="table1" cellspacing="2" cellpadding="1" border="0">

        <tr>
            <td align="right" class="labelData" width="30%">Nombre Completo:
            </td>
            <td>
                <asp:TextBox ID="txtNombreCompleto" runat="server" Width="290px"></asp:TextBox>&nbsp;<asp:RequiredFieldValidator ID="Requiredfieldvalidator1" runat="server" ControlToValidate="txtNombreCompleto" Display="Dynamic" ErrorMessage="El nombre del solicitante es requerido.">*</asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td align="right" class="labelData">Cédula o Pasaporte:</td>
            <td>
                <asp:TextBox ID="txtNroDocumento" runat="server" MaxLength="25" Width="200px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td align="right" class="labelData">Dirección:
            </td>
            <td>
                <asp:TextBox ID="txtDireccion" runat="server" BorderStyle="Groove" Height="70px" TextMode="MultiLine" Width="300px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td align="right" class="labelData">Teléfono:
            </td>
            <td>
                <uc1:UCTelefono ID="ctrlTelefono" runat="server" />
            </td>
        </tr>
        <tr>
            <td align="right" class="labelData">Celular:
            </td>
            <td>
                <uc1:UCTelefono ID="ctrlCelular" runat="server" />
            </td>
        </tr>
        <tr>
            <td align="right" class="labelData">Fax:
            </td>
            <td>
                <uc1:UCTelefono ID="ctrlFax" runat="server" />
            </td>
        </tr>
        <tr>
            <td align="right" class="labelData" nowrap="nowrap">Correo Electrónico:
            </td>
            <td>
                <asp:TextBox ID="txtEmail" runat="server" Width="290px"></asp:TextBox>
                &nbsp;<asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail"
                    Display="Dynamic" ErrorMessage="Correo Electrónico Inválido" SetFocusOnError="True" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">*</asp:RegularExpressionValidator><br />
            </td>
        </tr>

        <tr>
            <td align="right" class="labelData">Nombre de la Persona Física o Jurídica:</td>
            <td>
                <asp:TextBox ID="txtInstitucion" runat="server" Width="300px"></asp:TextBox>
            </td>
        </tr>
        <%-- <tr>
            <td align="right" class="labelData">Cargo:
            </td>
            <td>
                <asp:TextBox ID="txtCargo" runat="server" Width="300px"></asp:TextBox>
                <br />
            </td>
        </tr>--%>
        <tr>
            <td align="right" class="labelData">Información Solicitada:
            </td>
            <td>
                <asp:TextBox ID="txtinfosolicitada" runat="server" BorderStyle="Groove" Height="70px" TextMode="MultiLine" Width="300px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="Requiredfieldvalidator2" runat="server" ControlToValidate="txtInfoSolicitada" Display="Dynamic" ErrorMessage="La información solicitada es requerida.">*</asp:RequiredFieldValidator>
                <br />
                <span id="idSpan">Especifique si son fotografías, grabaciones, soportes magnéticos o digitales</span>
            </td>
        </tr>
        <tr>
            <td align="right" class="labelData">Motivo Solicitud:
            </td>
            <td>
                <asp:TextBox ID="txtMotivo" runat="server" BorderStyle="Groove" Height="70px" TextMode="MultiLine" Width="300px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="Requiredfieldvalidator6" runat="server" ControlToValidate="txtMotivo" Display="Dynamic" ErrorMessage="El motivo de la solicitud es requerido.">*</asp:RequiredFieldValidator>
            </td>
        </tr>

        <tr>
            <td align="right" class="labelData">Autoridad pública que posee la información:
            </td>
            <td>
                <asp:TextBox ID="txtAutoridad" runat="server" Width="300px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td align="right" class="labelData">Medio para recibir la información:
            </td>
            <td>
                <asp:CheckBoxList ID="cblMedio" runat="server" RepeatColumns="3">
                    <asp:ListItem Text="Personal" Value="Personal"></asp:ListItem>
                    <asp:ListItem Text="Teléfono" Value="Teléfono"></asp:ListItem>
                    <asp:ListItem Text="Fascimil" Value="Fascimil"></asp:ListItem>
                    <asp:ListItem Text="Correo Certificado" Value="Correo Certificado"></asp:ListItem>
                    <asp:ListItem Text="Correo Electrónico" Value="Correo Electrónico"></asp:ListItem>
                    <asp:ListItem Text="Correo Ordinario" Value="Correo Ordinario"></asp:ListItem>
                    <asp:ListItem Text="Páginas de Internet" Value="Páginas de Internet"></asp:ListItem>
                </asp:CheckBoxList>
            </td>
        </tr>
        <tr>
            <td align="right" class="labelData">Persona que retirará la información:
            </td>
            <td>
                <asp:TextBox ID="txtLugar" runat="server" Width="300px"></asp:TextBox>
            </td>
        </tr>

        <tr>
            <td colspan="2"></td>
        </tr>
        <tr align="center">
            <td align="center" colspan="2">
                <asp:Button ID="btnEnviar" runat="server" Text="Enviar" />
                &nbsp;<asp:Button ID="btnCancelar" runat="server" CausesValidation="False" Text="Cancelar" />
            </td>
        </tr>
    </table>

</asp:Content>

