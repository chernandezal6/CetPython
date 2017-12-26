<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsCambioCuentaMadre.aspx.vb" Inherits="Novedades_sfsCambioCuentaMadre" title="Cambio Cuenta de la Madre" %>
<%@ Register src="../Controles/ucInfoEmpleado.ascx" tagname="ucInfoEmpleado" tagprefix="uc1" %>
<%@ Register src="../Controles/ucGridNovPendientes.ascx" tagname="ucGridNovPendientes" tagprefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<script language="javascript" type="text/javascript">

function numeralsOnly(evt) 
{
    evt = (evt) ? evt : event;
    var charCode = (evt.charCode) ? evt.charCode : ((evt.keyCode) ? evt.keyCode : ((evt.which) ? evt.which : 0));
    
    if (charCode > 31 && (charCode < 48 || charCode > 57)) 
    {
        alert("Este campo solo permite valores numericos.");
        return false;
    }
    
    return true;
    
}
function checkNum()
	    {
            var carCode = event.keyCode;
            
            if ((carCode < 48) || (carCode > 57))
                {
                    event.cancelBubble = true	
                    event.returnValue = false;	
                 }
         }
   function checkItNoPaste(evt)
   {
       evt = (evt) ? evt : window.event;
       input= evt.target || evt.srcElement;
       input.setAttribute('maxLength', input.value.length + 1); 
   }
</script>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
             <fieldset style="width: 585px; margin-left: 60px">
                <legend class="header" style="font-size: 14px">Cambio de Cuenta Madre</legend>
                <br />
                <table class="td-content" id="Table1" style="margin-left: 17px; width: 550px"  cellspacing="0" cellpadding="0">
				        <tr>
					        <td style="width: 550px">
					        <br />
					            <span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">
                                Afiliada</span>
						        <table style="margin-left: 60px">
							        <tr>
								        <td>Cédula o NSS:</td>
								        <td><asp:textbox id="txtCedulaNSS" runat="server" Width="100px" MaxLength="11"></asp:textbox><asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtCedulaNSS" Display="Dynamic">*</asp:requiredfieldvalidator></td>
								        <td align="right"><asp:button id="btnConsultar" runat="server" Text="Buscar"></asp:button>
									        <asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button></td>
							        </tr>
							        <tr>
								        <td align="center" colspan="2">
                          <asp:regularexpressionvalidator id="regExpRncCedula" runat="server" 
                            ControlToValidate="txtCedulaNSS" Display="Dynamic"
										        ValidationExpression="^[0-9]+$" ErrorMessage="NSS o Cédula invalido." Font-Bold="True"></asp:regularexpressionvalidator></td>
							        </tr>
						        </table>
					        </td>
				        </tr>
			        </table>
		        <br />
		        <asp:label id="lblMsg" cssclass="error" style="margin-left: 17px" EnableViewState="False" Runat="server"></asp:label>
		        <div id="divConsulta" visible="false" runat="server">
                    <table cellspacing="0" cellpadding="0" style="margin-left: 17px" width="550px">
					        <tr>
						        <td>
                                    <br />
        							
                                    <uc1:ucInfoEmpleado ID="ucInfoEmpleado1" runat="server" />
        							
                                    <br />
						        </td>
					        </tr>
				        </table>
			        <br />
                </div>
                
                <div class="td-content" id="dInfoActual" runat="server" visible="false" style="width: 545px; margin-left: 17px">
                    <br />
                    <span style="margin-left: 17px; font-weight: bold; font-size: 12px">Informacion Actual</span>
                    <br />
                    <br />
                    
                    <span style="margin-left: 36px">Numero Cuenta:</span>
                    <asp:Label ID="lblNumCuentaActual" cssclass="labelData" style="margin-left: 8px" runat="server" />
									        &nbsp;
                    
                </div>
                <br />
                <div class="td-content" id="fiedlsetDatos" runat="server" visible="false" style="width: 545px; margin-left: 17px">
                    <br />
                    
                    <span style="margin-left: 36px">Numero Cuenta:</span>
                    <asp:TextBox ID="tbNumCuenta" style="margin-left: 9px" onkeypress="return numeralsOnly(event)" runat="server" />
                    <asp:requiredfieldvalidator id="RequiredFieldValidator2" runat="server" 
                        ControlToValidate="tbNumCuenta" Display="Dynamic" ValidationGroup="Cuenta" 
                        ErrorMessage="El número de cuenta es requerido">*</asp:requiredfieldvalidator>
                         <br />
                    Confirmar Nro de Cuenta:&nbsp;
                    <asp:TextBox ID="txtNumeroCuenta2" runat="server" CssClass="input" 
                        MaxLength="1" onkeydown="checkItNoPaste(event);"></asp:TextBox>
                    <asp:CompareValidator ID="CompareValidator1" runat="server" 
                        ControlToCompare="tbNumCuenta" ControlToValidate="txtNumeroCuenta2" 
                        Display="Dynamic" 
                        
                        ErrorMessage="La cuenta de confirmación no coincide con el número de cuenta digitado" 
                        ValidationGroup="Cuenta">*</asp:CompareValidator>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                        ControlToValidate="txtNumeroCuenta2" 
                        ErrorMessage="La confirmación de la cuenta es requerida" Font-Bold="True" 
                        ValidationGroup="Cuenta">*</asp:RequiredFieldValidator>
                         <br/>
                    <span style="margin-left: 36px">Comentario:</span>
                    <asp:TextBox ID="txtComentario" style="margin-left: 28px"  runat="server" 
                        Height="87px" TextMode="MultiLine" Width="236px" />
                    <asp:requiredfieldvalidator id="RequiredFieldValidator3" runat="server" 
                        ControlToValidate="txtComentario" Display="Dynamic" 
                        ValidationGroup="Cuenta" ErrorMessage="El comentario es requerido">*</asp:requiredfieldvalidator><br/>
                    <asp:button 
                        id="btnGuardar" style="margin-left: 36px" runat="server" Text="Aplicar" ValidationGroup="Cuenta" 
                        Width="90px"></asp:button>
									        &nbsp;
                    <br />
                    <br />    
                </div>
                 <br />
                 <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
                     HeaderText="Por favor corregir lo siguiente:" ValidationGroup="Cuenta" />
                <br />
            </fieldset>
            <br />
          
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

