<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="LoginMaster.aspx.vb" Inherits="Empleador_LoginMaster" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <p>
        <table cellpadding="0" cellspacing="0" class="tblWithImagen" style="width: 350px;">
            <tr>
                <td class="HeaderPopup">Impersonar Representante</td>
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
                            <td align="right">&nbsp;</td>
                            <td>&nbsp;</td>
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
                    &nbsp;</td>
            </tr>            
        </table> 
        <table>
            <tr>
                <td>
                    <div></div>
                </td>
            </tr>
        </table>
        <br />
    </p>
</asp:Content>

