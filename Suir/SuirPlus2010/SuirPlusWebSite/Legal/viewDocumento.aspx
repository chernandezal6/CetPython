<%@ Page Language="VB" AutoEventWireup="false" CodeFile="viewDocumento.aspx.vb" Inherits="Legal_viewDocumento" %>
<%@ register src="../Controles/Legal/ucDocumentosLeyFacPago.ascx" tagname="ucDocumentosLeyFacPago"
    tagprefix="uc1" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Ver Documento de Solicitud</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <uc1:ucdocumentosleyfacpago id="UcDocumentosLeyFacPago" runat="server" />    
    </div>
    </form>
</body>
</html>
