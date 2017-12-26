<%@ Page Language="VB" AutoEventWireup="false" CodeFile="documentUpload.aspx.vb" Inherits="Legal_documentUpload" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
<script language="javascript" type="text/javascript">
// <!CDATA[

function btnUpload_onclick() {

}

// ]]>
</script>
</head>
<body style="margin:0px">
    <form id="photoUpload" enctype="multipart/form-data" runat="server">
        <div>
            <input id="filPhoto" type="file" runat="server"/>
        </div>
        <div id="divUpload" style="padding-top:4px">
            <input id="btnUpload" type="button" value="Cargar Documento" class="Button" onclick="return btnUpload_onclick()" />
        </div>
    </form>
</body>
</html>
