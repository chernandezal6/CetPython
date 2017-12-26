<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consFacturasIR17.aspx.vb" Inherits="Empleador_consFacturasIR17" title="Consulta de Notificaciones de Pago - IR17" %>

<%@ Register Src="../Controles/ucEncabezadoDGII.ascx" TagName="ucEncabezadoDGII"
    TagPrefix="uc1" %>
<%@ Register Src="../Controles/ucIR17Encabezado.ascx" TagName="ucIR17Encabezado"
    TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <br />
    <uc1:ucEncabezadoDGII ID="UcEncabezadoDGII1" runat="server" />
    <uc2:ucIR17Encabezado id="ucLiqEncIR" runat="server">
    </uc2:ucIR17Encabezado>
</asp:Content>

