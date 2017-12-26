<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="EntregarFondos.aspx.vb" Inherits="Finanzas_EntregarFondos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <div style="vertical-align:middle; height: 400px;" align="center">
    <asp:Panel ID="pnlEntregarFondos" runat="server" Visible="false">
        <fieldset style="width: 350px; text-align:center">
    
    <legend>Entrega de Fondos</legend>
        <table>
            <tr>
            <td>&nbsp;</td>
            <td>
                &nbsp;</td>
            </tr>
            
            <tr>
            <td valign="top">Nro. de Cheque:</td>
            <td align="left">
                <asp:TextBox ID="txtCheque" runat="server" Width="200px"></asp:TextBox>
                <br />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="txtCheque" ErrorMessage="Nro. de cheque requerido."></asp:RequiredFieldValidator>
            </td>
            </tr>
            
            <tr>
            <td valign="top">Nro. Documento:</td>
            <td align="left">
                <asp:TextBox ID="txtDocumeto" runat="server" Width="200px"></asp:TextBox>
                <br />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ControlToValidate="txtDocumeto" ErrorMessage="Nro. de Documento requerido."></asp:RequiredFieldValidator>
            </td>
            </tr>
            <tr>
            <td align="center" colspan="2" nowrap="nowrap">
                &nbsp;<br />
                <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" />
                &nbsp;<asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"/>

            </td>
            </tr>
            
            <tr>
            <td align="left" colspan="2" style="text-align: center">
                <asp:Label ID="lblMensaje" runat="server" CssClass="error" Visible="false"></asp:Label>
            </td>
            </tr>                 
        </table>
    
    
    </fieldset>
    </asp:Panel>
    <asp:Panel ID="pnlConfirmacion" runat="server" Visible="false">
        <fieldset style="width: 350px">
    
    <legend>Confirmación</legend>
        <table>
            <tr>
            <td>&nbsp;</td>
            </tr> 
            
            <tr>
                <td class="label-Blue">
                    Información registrada satisfactoriamente!!!</td>
            </tr>
            
            <tr>
            <td align="center">
                &nbsp;<br />
                <asp:Button ID="btnConfirmar" runat="server" Text="   OK   " />
            </td>
            </tr>                         
        </table>
    
    
    </fieldset>
    </asp:Panel>    
    </div>
</asp:Content>

