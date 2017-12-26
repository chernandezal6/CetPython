<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsCambioCuentaTutor.aspx.vb" Inherits="Novedades_sfsCambioCuentaTutor" title="Reporte cambio cuenta de tutor" %>
<%@ Register src="../Controles/ucGridNovPendientes.ascx" tagname="ucGridNovPendientes" tagprefix="uc2" %>
<%@ Register src="../Controles/ucInfoEmpleado.ascx" tagname="ucInfoEmpleado" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<script language="javascript" type="text/javascript">
function numeralsOnly(evt) {
    evt = (evt) ? evt : event;
    var charCode = (evt.charCode) ? evt.charCode : ((evt.keyCode) ? evt.keyCode : 
        ((evt.which) ? evt.which : 0));
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        alert("Este campo solo permite valores numericos.");
        return false;
    }
    
    return true;
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
   <legend class="header" style="font-size: 14px">Reporte Cambio Cuenta de Tutor</legend>
   <br />
   <table class="td-content" id="Table1" style="margin-left: 17px; width: 550px"  cellspacing="0" cellpadding="0">
				<tr>
					
					<td>
					<br />
					<span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">Afiliada</span>
						<table style="margin-left: 60px">
							<tr>
							    
							    
								<td>Cédula o NSS:</td>
								<td><asp:textbox id="txtCedulaNSS" runat="server" Width="100px" MaxLength="11"></asp:textbox><asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtCedulaNSS" Display="Dynamic">*</asp:requiredfieldvalidator></td>
								<td align="right" colspan="2"><asp:button id="btnConsultar" runat="server" Text="Buscar"></asp:button>
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
			<div id="divConsulta" visible="false" runat="server" width="550px">
            <table cellspacing="0" cellpadding="0" style="margin-left: 17px" width="0px">
					<tr>
						<td>
                            <br />
							
                            <uc1:ucInfoEmpleado ID="UcEmpleado" runat="server" />
							
                            <br />
						</td>
					</tr>
				</table>
				<br />
            </div>
<table class="td-content" id="Table2" runat="server" visible="false" style="margin-left: 17px; width: 550px"  cellspacing="0" cellpadding="0">
				
				<tr>
					
					<td>
					<br />
					<span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">Validar cédula tutor</span>
						<table style="margin-left: 60px">
							<tr>
							    
							    
								<td>Cédula tutor:</td>
								<td><asp:textbox id="txtCedTutor" runat="server" Width="100px" MaxLength="11"></asp:textbox><asp:requiredfieldvalidator id="RequiredFieldValidator3" runat="server" ControlToValidate="txtCedTutor" ValidationGroup="tutor">*</asp:requiredfieldvalidator></td>
								<td align="right" colspan="2"><asp:button id="btnBuscar" ValidationGroup="tutor" runat="server" Text="Buscar"></asp:button>
									<asp:button id="btnCancel"  runat="server" Text="Cancelar" CausesValidation="False"></asp:button></td>
							</tr>
							<tr>
								<td align="center" colspan="2">
                  <asp:regularexpressionvalidator id="Regularexpressionvalidator1" runat="server" 
                    ControlToValidate="txtCedTutor" Display="Dynamic"
										ValidationExpression="^[0-9]+$" ErrorMessage="NSS o Cédula invalido." Font-Bold="True"></asp:regularexpressionvalidator></td>
							</tr>
							
						</table>
					</td>
				</tr>
			</table>
			<asp:Label ID="lblMsgTutor" Runat="server" cssclass="error" 
        EnableViewState="False" style="margin-left: 17px"></asp:Label>
			<br />
<div id="divConsultaTutor" class="td-content" style="margin-left: 16px; width: 546px" visible="false" runat="server" >
           <br />
            <span style="margin-left: 36px">Nombre tutor:</span>
            <span id="nombreTutor" class="labelData" style="margin-left: 15px" runat="server"></span>
            <br />
            <span style="margin-left: 36px">Cédula tutor:</span>
           <span id="cedTutor" class="labelData" style="margin-left: 19px" runat="server"></span>
				<br />
				 <span style="margin-left: 36px">Numero Cuenta:</span>
                    <asp:Label ID="lblNumCuentaActual" cssclass="labelData" style="margin-left: 5px" runat="server" />
            </div>			

            
<br />
<div class="td-content" id="fiedlsetDatos" runat="server" visible="false" style="width: 544px; margin-left: 17px">
<br />
<br />

<span style="margin-left: 12px">Número de cuenta:</span>
    <asp:TextBox ID="txtCuenta" style="margin-left: 21px;" onkeypress="return numeralsOnly(event)" runat="server"></asp:TextBox>
    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" 
        ValidationGroup="fecha" runat="server" ControlToValidate="txtCuenta" 
        ErrorMessage="El número de cuenta es requerido">*</asp:RequiredFieldValidator>
      <br />
    Confirmar Nro de Cuenta:&nbsp;
    <asp:TextBox ID="txtNumeroCuenta2" runat="server" 
        onkeydown="checkItNoPaste(event);"></asp:TextBox>
    <asp:CompareValidator ID="CompareValidator1" runat="server" 
        ControlToCompare="txtCuenta" ControlToValidate="txtNumeroCuenta2" 
        Display="Dynamic" 
        
        ErrorMessage="La cuenta de confirmación no coincide con el número de cuenta digitado" 
        ValidationGroup="fecha">*</asp:CompareValidator>
    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
        ControlToValidate="txtNumeroCuenta2" 
        ErrorMessage="La confirmación de la cuenta es requerida" Font-Bold="True" 
        ValidationGroup="fecha">*</asp:RequiredFieldValidator>
      <br/>
                    <span style="margin-left: 12px">Comentario:</span>
                    <asp:TextBox ID="txtComentario" style="margin-left: 52px"  
        runat="server" Height="87px" TextMode="MultiLine" Width="236px" />
                    <asp:requiredfieldvalidator id="RequiredFieldValidator4" runat="server" 
                        ControlToValidate="txtComentario" Display="Dynamic" 
        ValidationGroup="Cuenta" ErrorMessage="El comentario es requerido">*</asp:requiredfieldvalidator><br/>
 
    <asp:Button ID="btnSubmit" ValidationGroup="fecha" 
        style="margin-left: 12px;width: 90px" runat="server" Text="Aplicar" />
<asp:Button ID="btnCancelar1" style="margin-left: 8px; width: 90px" runat="server" Text="Cancelar" />
    
    <br />
    <br />
    
</div>

    <br />
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
        HeaderText="Por favor revisar los siguientes errores" ValidationGroup="fecha" />

<br />
	<div style="margin-left: 16px;">
	<span id="errorSexo" runat="server" style="margin-left: 1px;"  class="error" visible="false"></span>
    <span id="errorSta" runat="server" style="margin-left: 1px;"  class="error" visible="false"></span>	
    <span id="errorG" runat="server" style="margin-left: 1px;"  class="error" visible="false"></span>
    </div>
</fieldset>



</ContentTemplate>
</asp:UpdatePanel>
<asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Procesando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

