<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ImprimirAcuerdoPagoPopUp.aspx.vb" Inherits="Legal_ImprimirAcuerdoPagoPopUp" %>

<%@ Register Src="../Controles/Legal/ucAcuerdoPagoLeyFacilidades.ascx" TagName="ucAcuerdoPagoLeyFacilidades"
    TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Acuerdo Pago</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <uc1:ucAcuerdoPagoLeyFacilidades ID="ucAcuerdo" runat="server" />
    
    </div>
    </form>
</body>
</html>
