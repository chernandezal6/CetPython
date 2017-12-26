<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConsultaAfiliacion.aspx.vb" Inherits="Afiliacion_ConsultaAfiliacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="header" align="left">Consulta de Pensionados de la SEH<br /></div><br />
<table class="td-content" style="width: 385px" cellpadding="1" cellspacing="0">
    <tr><td></td></tr>
        <tr>
            <td align="right" style="width: 21%" nowrap="nowrap">
                Cedula:
            </td>
            <td>
                <asp:TextBox ID="txtCedula" runat="server"></asp:TextBox>
                 <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" ControlToValidate="txtCedula"
                                                Display="Dynamic" ErrorMessage="*" ValidationExpression="^(\d{11})$">Cédula Inválida.</asp:RegularExpressionValidator>
            </td>
         </tr>
        <tr>
            <td align="right" style="width: 21%">
                No. Pensionado:</td>
            <td>
                <asp:TextBox ID="txtNoPensionado" runat="server"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator6" runat="server" 
                    ControlToValidate="txtNoPensionado" ErrorMessage="No. Pensionado Invalido." 
                    ValidationExpression="^[0-9]*$"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 21%">
                &nbsp;</td>
            <td>
                <asp:Button ID="btnBuscar" runat="server" 
                    Text="Buscar" />
                &nbsp;<asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" 
                    CausesValidation="False" />
            </td>
        </tr>
        <tr>
            <td colspan="2" style="height: 15px">
                <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
            </td>
        </tr>
    </table> 
    <asp:Panel ID="pnlDatos" runat="server" Visible="False">
        <table style="width: 600px">
            <tr>
                <td class="labelData" style="width: 106px">
                    Nombre:</td>
                <td>
                    <asp:Label ID="lblNombre" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="labelData" style="width: 106px">
                    Estatus:</td>
                <td>
                    <asp:Label ID="lblEstatus" runat="server"></asp:Label>
                </td>
            </tr>
             <tr runat="server" id="trMotivo" visible="false">
                <td class="labelData" style="width: 106px">
                    Motivo de Baja:</td>
                <td>
                    <asp:Label ID="lblDesc" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="labelData" style="width: 106px">
                    Fecha Afiliación:</td>
                <td>
                    <asp:Label ID="lblFechaAfiliacion" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="labelData" style="width: 106px">
                    Fecha Desafiliacion:</td>
                <td>
                    <asp:Label ID="lblFechaDesafiliacion" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="labelData" style="width: 106px">
                    Fecha Registro:</td>
                <td>
                    <asp:Label ID="lblFechaRegistro" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="labelData" style="width: 106px">
                    ARS:</td>
                <td>
                    <asp:Label ID="lblARS" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="labelData" style="width: 106px">
                    Direccion ARS:</td>
                <td>
                    <asp:Label ID="lblDireccionARS" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="labelData" style="width: 106px">
                    Telefono ARS:</td>
                <td>
                    <asp:Label ID="lblTelefonoARS" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 106px">
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
        </table>
            
            
    </asp:Panel>

</asp:Content>

