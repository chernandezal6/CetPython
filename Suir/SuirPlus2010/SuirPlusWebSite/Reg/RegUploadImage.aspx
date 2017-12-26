<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RegUploadImage.aspx.vb" Inherits="Reg_RegUploadImage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

</head>
<body>
<form id="photoUpload" enctype="multipart/form-data" runat="server">
    <div>
        <input id="filPhoto" type="file" runat="server" />
        <input type="hidden" id="idSolicitudImagen" runat="server" />
        <input type="hidden" id="idRequisitoImagen" runat="server" /> 

        <input validar="0" id="btnUpload" type="button" value="Cargar" />
        <input type="hidden" id="hdPropiedad" runat="server" />
        
    </div>
</form>
</body>
</html>
