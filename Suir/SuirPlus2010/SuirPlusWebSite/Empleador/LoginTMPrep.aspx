<%@ Page Language="VB" Title="Login Representante" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="LoginTMPrep.aspx.vb" Inherits="Empleador_LoginTMPrep" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
   
   <div class="centered">
        <table cellpadding="0" cellspacing="0" class="tblWithImagen" style="width: 350px;">
            <tr>
                <td class="HeaderPopup">Validación de Representantes</td>
            </tr>
            <tr>
                <td>
                    <div style="height:5px;">
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <table cellpadding="1" cellspacing="1" style="width: 100%;">
                        <tr>
                            <td align="right" style="width: 25%">RNC/Cédula</td>
                            <td><asp:TextBox ID="txtRncCedula" MaxLength="11" runat="server">
                                </asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtRncCedula"
                                    CssClass="error" Display="Dynamic" ErrorMessage="Introduzca RNC/Cédula" SetFocusOnError="True">*</asp:RequiredFieldValidator></td>
                        </tr>
                        <tr>
                            <td align="right">Cédula/Pasaporte</td>
                            <td>
                                <asp:TextBox ID="txtRepresentante" runat="server" MaxLength="25"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtRepresentante"
                                    CssClass="error" Display="Dynamic" ErrorMessage="Introduzca Cédula/Pasaporte"
                                    SetFocusOnError="True">*</asp:RequiredFieldValidator></td>
                        </tr>
                        <tr>
                            <td align="right">CLASS</td>
                            <td><asp:TextBox ID="txtClass" runat="server" TextMode="Password">
                                </asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtClass"
                                    CssClass="error" Display="Dynamic" ErrorMessage="Introduzca CLASS" SetFocusOnError="True">*</asp:RequiredFieldValidator></td>
                        </tr>
                        <tr>
                            <td align="right"></td>
                            <td>
                                &nbsp;<asp:Button ID="btLogin" runat="server" Text="Validar" />
                                <input id="Reset1" type="reset" value="Limpiar" runat="server" class="Button" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False" />
                </td>
            </tr>            
        </table> 
        <table>
            <tr>
                <td>
                    <div></div>
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="error" DisplayMode="List" />                    
                </td>
            </tr>
        </table>
   </div>
     
</asp:Content>

