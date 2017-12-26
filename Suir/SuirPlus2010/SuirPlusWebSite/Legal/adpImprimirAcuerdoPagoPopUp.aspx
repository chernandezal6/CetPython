<%@ Page Language="VB" AutoEventWireup="false" CodeFile="adpImprimirAcuerdoPagoPopUp.aspx.vb" Inherits="adpImprimirAcuerdoPagoPopUp" %>

<%@ Register Src="../Controles/Legal/adpucAcuerdoPago.ascx" TagName="adpucAcuerdoPago"
    TagPrefix="uc2" %>

<%@ Register Src="../Controles/Legal/ucAcuerdoPagoLeyFacilidades.ascx" TagName="ucAcuerdoPagoLeyFacilidades"
    TagPrefix="uc1" %>
    <%@ Register Src="../Controles/Legal/ucAcuerdoPagoEmbajadas.ascx" TagName="ucAcuerdoPagoEmbajadas"
    TagPrefix="uc3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Acuerdo Pago</title>
</head>
<body>
    <form id="form1" runat="server">
    <div id="divAcuerdoPagoOrdinario" visible="false " runat="server">
        &nbsp;<uc2:adpucAcuerdoPago ID="AdpucAcuerdoPago1"  runat="server" />
  
    </div>
    <div id="divAcuerdoPagoEmbajadas" visible="false " runat="server">
        &nbsp;<uc3:ucAcuerdoPagoEmbajadas ID="AdpucAcuerdoPago2"  runat="server" />
  
    </div>
    </form>
</body>
</html>
