<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consRegimenSubsidiado.aspx.vb" Inherits="sfsRegimenSubsidiado" title="Consulta de Dispersión del Regimen Subsidiado" %>
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
             $(document).ready(function() {
                 $("#tabs").tabs();
             });
         </script>
    <div class="header">&nbsp;Consulta de Dispersión del Regimen Subsidiado </div><br>
    <table cellpadding="1" cellspacing="0" class="td-content" style="width: 400px">
        <tr>
            <td style="height:5px;" colspan="2">
                <asp:Label ID="lblMsg" runat="server" CssClass="error" EnableViewState="False"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">Nro. Documento:</td>
            <td><asp:TextBox ID="txtDocumento" onKeyPress="checkNum()" runat="server" 
                    MaxLength="11" EnableViewState="False" /></td>                          
        </tr>
        <tr>
            <td align="right">
                NSS:</td>
            <td>
                <asp:TextBox ID="txtNSS" runat="server"  onKeyPress="checkNum()" MaxLength="9" EnableViewState="False"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtNSS"
                    CssClass="error" ErrorMessage="RegularExpressionValidator" ValidationExpression="^(\d{9})$" ValidationGroup="Ciudadano" Enabled="False">NSS Inválido</asp:RegularExpressionValidator></td>
        </tr>
        <tr>
            <td align="right">
            </td>
            <td>
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" ValidationGroup="Ciudadano" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False" /></td>
        </tr>
        </table>
    <br />
     <div id="divConsecutivas" class="labelData" style="width: 400px" runat="server"
        visible="False">
         Nombre del afiliado:&nbsp;
        <asp:Label ID="lblNombreAfiliado" runat="server"></asp:Label>
    </div>
    <br /> 
    
<div id="tabs">
    <ul>       
        <asp:Literal ID="ltSpan" runat="server"></asp:Literal>  
    </ul>   
  
     <asp:Literal ID="ltDiv" runat="server"></asp:Literal>  
</div>


    
</asp:Content>

