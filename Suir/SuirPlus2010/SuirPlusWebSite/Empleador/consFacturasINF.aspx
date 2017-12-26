<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consFacturasINF.aspx.vb" Inherits="Empleador_consFacturasINF" title="Consulta de Liquidaciones de Pago - INF" %>

<%@ Register Src="../Controles/ucLiquidacionInfotepDet.ascx" TagName="ucLiquidacionInfotepDet"
    TagPrefix="uc3" %>

<%@ Register Src="../Controles/UCEncabezadoInfotep.ascx" TagName="UCEncabezadoInfotep"
    TagPrefix="uc1" %>
<%@ Register Src="../Controles/ucLiquidacionInfotepEnc.ascx" TagName="ucLiquidacionInfotepEnc"
    TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <br />
    <uc1:UCEncabezadoInfotep ID="UCEncabezadoInfotep" runat="server" />
    <uc2:ucLiquidacionInfotepEnc id="ucLiqEncINF" runat="server">
    </uc2:ucLiquidacionInfotepEnc>
    <uc3:ucLiquidacionInfotepDet ID="UcLiquidacionInfotepDet" runat="server" Visible="false" />
</asp:Content>

