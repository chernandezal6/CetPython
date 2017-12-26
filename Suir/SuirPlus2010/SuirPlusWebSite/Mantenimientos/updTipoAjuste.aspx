<%@ Page Title="Actualización Tipo de Ajuste" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="updTipoAjuste.aspx.vb" Inherits="Mantenimientos_updTipoAjuste" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

<div class="header">Actualización Tipo de Ajuste</div><br />

<div>
<fieldset style="width: 450px">
<table>
<tr>
    <td>&nbsp;</td>
    <td colspan="3">
        &nbsp;</td>
       
</tr>

<tr>
    <td align="right" valign="top">Descripción:</td>
    <td colspan="3">
        <asp:TextBox ID="txtDescripcion" runat="server" 
            Width="305px"></asp:TextBox>
        <br />
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
            ControlToValidate="txtDescripcion" Display="Dynamic" ErrorMessage="Requerido."></asp:RequiredFieldValidator>
    </td>
       
</tr>

<tr>

        <td align="right" nowrap="nowrap">Cuenta Origen:</td>
    <td>
        <asp:TextBox ID="txtCuentaOrigen" runat="server"></asp:TextBox>
    </td>
    
        <td align="right" nowrap="nowrap">Cuenta Destino:</td>
    <td>
        <asp:TextBox ID="txtCuentaDestino" runat="server"></asp:TextBox>
    </td>
</tr>

<tr>

        <td align="right">Estatus:</td>
    <td>
        <asp:DropDownList ID="dlEstatus" runat="server" CssClass="dropDowns">
            <asp:ListItem Value="A">Activo</asp:ListItem>
            <asp:ListItem Value="I">Inactivo</asp:ListItem>
        
        </asp:DropDownList>
    </td>
    
        <td align="right" nowrap="nowrap">Tipo Movimiento:</td>
    <td>
        <asp:DropDownList ID="dlTipoMovimiento" runat="server" CssClass="dropDowns">
            <asp:ListItem Value="CR">Crédito</asp:ListItem>
        
            <asp:ListItem Value="DB">Débito</asp:ListItem>
        
        </asp:DropDownList>
    </td>
</tr>

<tr>

    
        <td>&nbsp;</td>
    <td>
        &nbsp;</td>    
        <td></td>
        <td></td>

</tr>
<tr>
    <td colspan="4" align="right">
        <asp:Button ID="btnGuardar" runat="server" Text="Guardar" />
        &nbsp;
        <asp:Button ID="btnRegresar" runat="server" Text="Regresar" 
            CausesValidation="False" />
    </td>
</tr>
</table>

</fieldset>
</div>        


<br />
<asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="False"></asp:Label>
</asp:Content>

