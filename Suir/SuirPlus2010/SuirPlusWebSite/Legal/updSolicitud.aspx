<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="updSolicitud.aspx.vb" Inherits="Legal_updSolicitud" title="Scaneo de Documentos" %>

<%@ register src="../Controles/Legal/ucDocumentosLeyFacPago.ascx" tagname="ucDocumentosLeyFacPago"
    tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	<script language="javascript" type="text/javascript">
	    function checkNum()
	    {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57))
                {
                    event.cancelBubble = true	
                    event.returnValue = false;	
                 }
        }
        
		function modelesswin(url)
		{
			//window.showModalDialog(url,"Imagen","help:0;status:0;toolbar:0;scrollbars:0;dialogwidth:800px:dialogHeight:100px");
			window.open(url,"_blank","height=250, width=250, toolbar=no, scrollbars=no, menubar=no");
		}
    </script>

    <div id="divHeader" class="header" runat="server">Anexar Imagen de Solicitud Para Acogerse a la Ley No. 189-07</div>
    <br />
    <table id="tblRnc" class="tblWithImagen" cellspacing="1" cellpadding="0" border="0" runat="server">
        <tr>
            <td colspan="3" align="center">
                <asp:label id="lblHeader" cssclass="error" runat="server" text="Digite el RNC ó el Número de la Solicitud, sólo uno a la vez."></asp:label>
            </td>
        </tr>
        <tr>
            <td rowspan="4" >
                <img src="../images/upcatriesgo.jpg" alt="" />
            </td>
            <td align="right">
                &nbsp;<asp:Label ID="lbltxtRNC" runat="server" Font-Bold="True" Text="RNC o Cédula:"></asp:Label>
            </td>
            <td style="width: 131px">
                &nbsp;<asp:TextBox ID="txtRNC" onKeyPress="checkNum()" runat="server" EnableViewState="False" MaxLength="11"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtRNC"
                    Display="Dynamic" ErrorMessage="RNC o Cédula Inválido" SetFocusOnError="True"
                    ValidationExpression="^(\d{9}|\d{11})$" validationgroup="0"></asp:RegularExpressionValidator>&nbsp;
            </td>
        </tr>
        <tr>
            <td align="right">
                <asp:label ID="lblSolicitud" runat="server" Text="Nro. Solicitud:" font-bold="true" />
            </td>
            <td style="width: 131px">
                &nbsp;<asp:textbox ID="txtSolicitud" onKeyPress="checkNum()" runat="server" />
            </td>
        </tr>
        <tr>
            <td colspan="2" valign="middle" align="center">
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" />&nbsp;
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" causesvalidation="False" />&nbsp;
            </td>
        </tr>
    </table>
      
    <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
    <br />
    <asp:hyperlink id="hlImage" runat="server" visible="False">[hlImage]</asp:hyperlink>
    &nbsp;&nbsp;&nbsp;
    <br />
    <table cellpadding="1" cellspacing="1" id="tblInfoEmpleador" runat="server" visible="false" class="tblWithImagen" width="437px">
        <tr class="listheadermultiline">
            <td align="right" style="text-align: left" colspan="4" >
                <asp:Label ID="lbltitulo1" runat="server" Text="Datos Generales del Empleador"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 99px">
                <asp:Label ID="lbltxtRazonSocial" runat="server" Text="Razón Social:"></asp:Label>
            </td>
            <td colspan="3">
                <asp:Label ID="lblRazonSocial" runat="server" Font-Bold="True"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 99px">
                    <asp:Label ID="lbltxtNombreComercial" runat="server" Text="Nombre Comercial:"></asp:Label>
            </td>
            <td colspan="3">
                <asp:Label ID="lblNombreComercial" runat="server" Font-Bold="True"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 99px;">
                <asp:Label ID="lblrnc1" runat="server" Text="R.N.C.:"></asp:Label>
            </td>
            <td>
                <asp:Label ID="lblRnc2" runat="server" Font-Bold="True"></asp:Label>
            </td>            
            <td align="right">
                <asp:Label ID="lbltxtTelefono" runat="server" Text="Teléfono:"></asp:Label>            
            </td>
            <td>
                <asp:Label ID="lblTelefono" runat="server" Font-Bold="True"></asp:Label>
            </td>            
        </tr>
    </table>
    <br />
    
    <table cellpadding="1" cellspacing="1" id="tblInfoSolicitud" runat="server" visible="false" class="tblWithImagen" width="437px">
        <tr class="listheadermultiline">
            <td align="right" style="text-align: left" colspan="4" >
                <asp:Label id="lblTitulo2" runat="server" Text="Datos de la Solicitud"></asp:Label>
            </td>
        </tr>
        <tr>
            <td style="width: 80px" align="right">
                <asp:label id="lblNro" runat="server" Text="Nro. Solicitud:"></asp:label>            
            </td>
            <td style="width: 130px">
                <asp:label id="lblNroSol" runat="server" font-bold="true"></asp:label>
            </td>
            <td style="width: 80px" align="right">
                <asp:label id="lblFecha" runat="server" text="Fecha Solicitud:"></asp:label>
            </td>
            <td style="width: 130px">
                <asp:label id="lblFechaSol" runat="server" font-bold="true"></asp:label>
            </td>
        </tr>
        <tr>
            <td style="width: 80px" align="right">
                <asp:label id="lblSolicitante" runat="server" Text="Solicitante:"></asp:label>            
            </td>
            <td colspan="3">
                <asp:label id="lblNombre" runat="server" font-bold="true"></asp:label>
            </td>
        </tr>
    </table>
    <br />

    <table cellpadding="1" cellspacing="1" id="tblEscaneo" runat="server" visible="false" class="tblWithImagen" width="437px">
        <tr class="listheadermultiline">
            <td align="right" style="text-align: left" colspan="4" >
                <asp:Label id="Label1" runat="server" Text="Documento de la Solicitud"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:label id="lblreq" runat="server" text="*" cssclass="error"></asp:label>
                <asp:fileupload id="FileUpload" runat="server" cssclass="Button" width="420px" enableviewstate="False" />
                <asp:requiredfieldvalidator id="RequiredFieldValidator3" runat="server" controltovalidate="FileUpload"
                    display="Dynamic" errormessage="Debes subir el documento escaneado como soporte de la solicitud" CssClass="label-Resaltado"></asp:requiredfieldvalidator></td>
        </tr>
        <tr>
            <td align="right" style="height: 20px">
                <asp:button id="btnSubir" text="Anexar Imagen" runat="server"/>
                <asp:button id="btncancelar" text="Limpiar" runat="server" causesvalidation="False"/>
            </td>
        </tr>
    </table> 

    <asp:updatepanel runat="server" updatemode="Conditional" id="updTimer">
        <contentTemplate>
            <asp:timer id="Timer1" runat="server" ontick="displayMessage" interval="2000" enabled="false">
            </asp:timer>
        </contentTemplate>             
    </asp:updatepanel>
        
</asp:Content>