<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="adpConfirmarDatosAcuerdoDePago.aspx.vb" Inherits="adpSolicitarAcuerdoPago" title="Confirmar Acuerdo de Pago" %>

<%@ Register Src="../Controles/Legal/adpucAcuerdoPago.ascx" TagName="adpucAcuerdoPago"
    TagPrefix="uc2" %>

<%@ Register Src="../Controles/Legal/ucAcuerdoPagoLeyFacilidades.ascx" TagName="ucAcuerdoPagoLeyFacilidades"
    TagPrefix="uc1" %>
<%@ Register src="../Controles/Legal/ucAcuerdoPagoEmbajadas.ascx" tagname="ucAcuerdoPagoEmbajadas" tagprefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="header">
Favor confirmar la siguiente información para proceder a Generar el Acuerdo de Pago.
</div>
    <uc3:ucAcuerdoPagoEmbajadas ID="ucAcuerdoPagoEmbajadas1" runat="server" />
    <br />
    <br />
    <table border="0" cellpadding="0" cellspacing="0" width="700">
        <tr>
            <td class="subHeader">
                </td>
        </tr>
        <tr>
            <td style="text-align: left;" >
                <uc2:adpucAcuerdoPago ID="AdpucAcuerdoPago1" runat="server" />
                <br />
                &nbsp;</td>
        </tr>
        <tr>
            <td style="width: 694px; text-align: center;">
                &nbsp;
                <asp:Button ID="btGenerar" runat="server" Text="Proceder a Generar el Acuerdo de Pago" UseSubmitBehavior="False" />
                &nbsp; &nbsp;<asp:Button ID="btCancelar" runat="server" Text="Cancelar" />
                <asp:Label ID="Label1" runat="server"></asp:Label>
            </td>
        </tr>
    </table>

</asp:Content>

