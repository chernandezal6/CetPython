<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="DesmarcarIR13.aspx.vb" Inherits="DesmarcarIR13" title="Desmarcado de Periodos IR-13" %>

<%@ Register Src="../Controles/UCCiudadano.ascx" TagName="UCCiudadano" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <div class="header">
        Generación de desmarcado de IR-13</div>
        <table cellpadding="1" cellspacing="0" class="td-content">
            <tr>
                <td rowspan="9" >
                    <img src="../images/DesmarcadoIR-13.jpg" height="113" width="150" /></td>
                <td align="right" style="width: 60px" >
                    </td>
                <td style="width: 273px" >
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right" style="width: 60px" >
                    </td>
                <td style="width: 273px" >
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right" style="width: 60px" >
                    <asp:Label ID="lbltxtRNC" runat="server" Font-Bold="True" Text="RNC:"></asp:Label></td>
                <td style="width: 273px" >
                    &nbsp;<asp:TextBox ID="txtRNC" runat="server" EnableViewState="False" MaxLength="11"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtRNC"
                        Display="Dynamic" ErrorMessage="RegularExpressionValidator" SetFocusOnError="True"
                        ValidationExpression="^(\d{9}|\d{11})$">RNC o Cédula Inválido</asp:RegularExpressionValidator>
                    &nbsp;&nbsp;
                </td>
            </tr>
            <tr>
                <td align="right" style="width: 60px" >
                    </td>
                <td style="width: 273px" >
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right" style="width: 60px" >
                </td>
                <td style="width: 273px" >
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right" style="width: 60px" >
                </td>
                <td style="width: 273px" >
                    <asp:Button ID="btnBuscar" runat="server" Text="Buscar" />&nbsp;
                    <asp:Button ID="btnLimpiar" runat="server" Text="Cancelar" /></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: left">
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: left">
                </td>
            </tr>
            <tr>
                <td style="text-align: left;" colspan="2">
                    <asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False" Visible="False"></asp:Label></td>
            </tr>
        </table>
    <br />
    <br />
    <table class="td-content" cellpadding="3" cellspacing="0" id="tblInfoAcuerdo" runat="server" visible="false" style="width: 488px">
        <tr>
            <td align="right" style="width: 104px; height: 18px; text-align: left">
                <asp:Label ID="Label3" runat="server" CssClass="subHeader" Text="Datos Generales:" Width="104px"></asp:Label></td>
            <td style="height: 18px">
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 104px; height: 18px; text-align: left;">
                    <asp:Label ID="lbltxtRazonSocial" runat="server" Text="Razón Social:"></asp:Label></td>
            <td style="height: 18px">
                <asp:Label ID="lblRazonSocial" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        <tr>
            <td align="right" style="width: 104px; height: 18px; text-align: left;">
                    <asp:Label ID="lbltxtNombreComercial" runat="server" Text="Nombre Comercial:"></asp:Label></td>
            <td style="height: 18px">
                <asp:Label ID="lblNombreComercial" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        <tr>
            <td align="right" style="height: 18px; width: 104px; text-align: left;">
                    <asp:Label ID="lbltxtTelefono" runat="server" Text="Teléfono:"></asp:Label></td>
            <td style="height: 18px">
                <asp:Label ID="lblTelefono" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        <tr>
            <td align="right" colspan="2" style="text-align: center; height: 18px;">
                </td>
        </tr>
    </table>
    &nbsp;<br />
               <br />
         <div style="text-align:center"> 
                <br />
	            <asp:Button id="btDeclarar" runat="server" Text="Continuar" Enabled="False" Visible="False"></asp:Button>
                <br />
            </div>

</asp:Content>

