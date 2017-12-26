<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="EditarAcuerdoPago.aspx.vb" Inherits="Legal_EditarAcuerdoPago" title="Untitled Page" %>
<%@ Register Src="../Controles/UCCiudadano.ascx" TagName="UCCiudadano" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<script language="javascript" type="text/javascript">
	    function ValidateAcuerdo()
	    {

            var valor =  document.getElementById('ctl00_MainContent_txtAcuerdo').value
            var carCode = event.keyCode;
            
            if(valor.substring(0,1).toUpperCase() == "A")
	        {
	        	       
	        	if(valor.length >= 7)
               {
                    event.cancelBubble = true	
                    event.returnValue = false;	
               }
	        	        
	            if ((carCode < 48) || (carCode > 57))
                {
                    event.cancelBubble = true	
                    event.returnValue = false;	
                 }        
	        
	        }
	        else
	        {
	             if(valor.length >= 4)
              {
                    event.cancelBubble = true	
                    event.returnValue = false;	
              }
                 
                if (carCode == 97)
                {
                      document.getElementById('ctl00_MainContent_txtAcuerdo').value = 'AO-'
                      event.cancelBubble = true	
                      event.returnValue = false;          
              	
                }
            
                if ((carCode < 48) || (carCode > 57))
                {
                    event.cancelBubble = true	
                    event.returnValue = false;	
                 }        
	        
	        }
            
        }
    </script>
 <div class="header">Editar Acuerdo de Pago</div><br>
  <table class="td-content" style="width: 221px" cellpadding="1" cellspacing="0">
                <tr>
                    <td align="right">
                        <br />
                        Nro. Acuerdo:
                    </td>
                    <td>
                        &nbsp;<br />
                        <asp:TextBox ID="txtAcuerdo" onKeyPress="ValidateAcuerdo()" runat="server" EnableViewState="False" width="88px"></asp:TextBox></td>
                </tr>
                 <tr>
                    <td align="right" style="text-align: center;" colspan="2">
                        <br />
                        &nbsp;<asp:Button ID="btnBuscar" runat="server" Text="Buscar" CausesValidation="False" />
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" /><br />
                        <br />
                    </td>
                </tr>
                </table>
                <asp:Label ID="lblMensajeError" runat="server" CssClass="error" EnableViewState="False"></asp:Label><br />
    
     <table id="tblInfoAcuerdo" runat="server" cellpadding="3" cellspacing="0" visible="false">
        <tr>
            <td align="right" colspan="2" style="text-align: left">
                <asp:Label ID="Label3" runat="server" CssClass="subHeader" Text="Datos Generales:"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="lbltxtRazonSocial" runat="server" Text="Razón Social:"></asp:Label></td>
            <td>
                <asp:Label ID="lblRazonSocial" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="lbltxtNombreComercial" runat="server" Text="Nombre Comercial:" Visible="False"></asp:Label></td>
            <td>
                <asp:Label ID="lblNombreComercial" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="lbltxtTelefono" runat="server" Text="Teléfono:"></asp:Label></td>
            <td>
                <asp:Label ID="lblTelefono" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="Label2" runat="server" Text="Representante Legal:"></asp:Label></td>
            <td>
                <uc1:ucciudadano id="ucCiudadano" runat="server"></uc1:ucciudadano>
            </td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="Label4" runat="server" Text="Cargo:"></asp:Label>&nbsp;</td>
            <td>
                <asp:TextBox ID="txtCargo" runat="server" Width="140px">Presidente</asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtCargo"
                    Display="Dynamic" ErrorMessage="El Cargo es requerido" ValidationGroup="grupo"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="Label1" runat="server" Text="Dirección:"></asp:Label></td>
            <td>
                <asp:TextBox ID="txtDireccion" runat="server" Width="471px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtDireccion"
                    Display="Dynamic" ErrorMessage="La Dirección es requerida" ValidationGroup="grupo"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="Label11" runat="server" Text="Nacionalidad:"></asp:Label></td>
            <td>
                <asp:TextBox ID="txtNacionalidad" runat="server" Width="140px">Dominicano</asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtNacionalidad"
                    Display="Dynamic" ErrorMessage="La nacionalidad es requerida" ValidationGroup="grupo"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="Label12" runat="server" Text="Estado Civil:"></asp:Label></td>
            <td>
                <asp:TextBox ID="txtEstadoCivil" runat="server" Width="140px">Casado</asp:TextBox>
                </td>
        </tr>
        <tr>
            <td align="right" colspan="2" style="text-align: left">
                &nbsp;</td>
        </tr>
        <tr>
            <td align="right" colspan="2" style="text-align: center">
                <asp:Button ID="btnGuardar" runat="server" Text="Guardar" ValidationGroup="grupo" />
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" ValidationGroup="grupo" /><br />
                &nbsp;<asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="grupo" />
                <br />
                </td>
        </tr>
    </table>
  
</asp:Content>

