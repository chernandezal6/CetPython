<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConfirmarDatosAcuerdoDePago.aspx.vb" Inherits="Legal_ConfirmarDatosAcuerdoDePago" title="Confirmar Acuerdo de Pago" %>

<%@ Register Src="../Controles/Legal/ucAcuerdoPagoLeyFacilidades.ascx" TagName="ucAcuerdoPagoLeyFacilidades"
    TagPrefix="uc1" %>
    <%@ Register Src="../Controles/Legal/ucAcuerdoPagoEmbajadas.ascx" TagName="ucAcuerdoPagoEmbajadas"
    TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="header">
Favor confirmar la siguiente información para proceder a Generar el Acuerdo de Pago.
    <br />
</div>
    <asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False"
        Font-Size="11pt" Visible="False"></asp:Label><br />
    <table border="0" cellpadding="0" cellspacing="0" width="700">
        <tr>
            <td class="subHeader">
                </td>
        </tr>
        <tr>
            <td style="text-align: left;" >
                <br />
                <uc1:ucAcuerdoPagoLeyFacilidades ID="UcAcuerdoPagoLeyFacilidades1" runat="server" />
                <uc2:ucAcuerdoPagoEmbajadas ID="UcAcuerdoPagoLeyFacilidades2" runat="server" />
            </td>
        </tr>
        <tr>
            <td style="width: 694px; text-align: center;">
                &nbsp;
                <asp:Button ID="btGenerar" runat="server" Text="Proceder a Generar el Acuerdo de Pago" UseSubmitBehavior="False" />
                &nbsp; &nbsp;<asp:Button ID="btCancelar" runat="server" Text="Cancelar" /></td>
        </tr>
    </table>
</asp:Content>

