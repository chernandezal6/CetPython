<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RegEditarArchivos.aspx.vb" Inherits="Reg_RegEditarArchivos" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

</head>
<body>
<form id="photoUpload" enctype="multipart/form-data" runat="server">
    <div>
        <input id="fileCharge" type="file" runat="server" />
        <input type="hidden" id="idSolicitudImagen" runat="server" />
        <input type="hidden" id="idRequisitoImagen" runat="server" /> 

        <input id="btnVer" type="button" value="Ver" OnClick=""/>
        <input id="btnCambiar" type="button" value="Cambiar" />
        <!--La propiedad Validar se cambiará si la tabla viene con el nombre del archivo o no!-->
        <input validar="0" id="btnUpload" type="button" value="Cargar" />
        <input type="hidden" id="hdPropiedad" runat="server" />      
    </div>
</form>
</body>
</html>
