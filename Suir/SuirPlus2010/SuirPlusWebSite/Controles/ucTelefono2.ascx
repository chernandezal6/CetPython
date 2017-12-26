<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucTelefono2.ascx.vb" Inherits="Controles_ucTelefono2" %>
<asp:TextBox ID="txtTelefono" runat="server" MaxLength="10"></asp:TextBox><ajaxToolkit:MaskedEditValidator
    ID="ValidatePhone" runat="server" ControlExtender="MaskPhone" ControlToValidate="txtTelefono"
    Display="Dynamic" InvalidValueMessage="Teléfono inválido" TooltipMessage="Ej: 555-555-5555" SetFocusOnError="True">*</ajaxToolkit:MaskedEditValidator>&nbsp;
<ajaxToolkit:MaskedEditExtender ID="MaskPhone" runat="server" ErrorTooltipEnabled="True"
    Mask="999-999-9999" MaskType="Number" TargetControlID="txtTelefono">
</ajaxToolkit:MaskedEditExtender>
