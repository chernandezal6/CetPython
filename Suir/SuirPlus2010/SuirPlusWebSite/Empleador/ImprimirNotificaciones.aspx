<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ImprimirNotificaciones.aspx.vb"
    Inherits="Empleador_ImprimirNotificaciones" %>

<%@ Register Src="../Controles/ucLiquidacionInfotepEnc.ascx" TagName="ucLiquidacionInfotepEnc"
    TagPrefix="uc4" %>
<%@ Register Src="../Controles/ucNotificacionTSSEncabezado.ascx" TagName="ucNotificacionTSSEncabezado"
    TagPrefix="uc1" %>
<%@ Register Src="../Controles/ucIR17Encabezado.ascx" TagName="ucIR17Encabezado"
    TagPrefix="uc2" %>
<%@ Register Src="../Controles/ucLiquidacionISREncabezado.ascx" TagName="ucLiquidacionISREncabezado"
    TagPrefix="uc3" %>
<%@ Register Src="../Controles/ucPlanillasMDTencabezado.ascx" TagName="ucPlanillasMDTencabezado"
    TagPrefix="uc5" %>
<%@ Register Src="../Controles/ucLiquidacionISRPEncabezado.ascx" TagName="ucLiquidacionISRPEncabezado"
    TagPrefix="uc6" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Tesoreria de la Seguridad Social - SuirPlus</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <uc1:ucNotificacionTSSEncabezado ID="ucNotTSS" runat="server" Visible="false" />
        <uc2:ucIR17Encabezado ID="ucDecIR17" runat="server" Visible="false" />
        <uc3:ucLiquidacionISREncabezado ID="ucLiqISR" runat="server" Visible="false" />
        <uc4:ucLiquidacionInfotepEnc ID="ucLiqINF" runat="server" Visible="false" />
        <uc5:ucPlanillasMDTencabezado ID="ucPlanillasMDTencabezado1" runat="server" />
        <uc6:ucLiquidacionISRPEncabezado ID="ucLiqISRP" Visible="false"
            runat="server" />
    </div>
    </form>
</body>
</html>
