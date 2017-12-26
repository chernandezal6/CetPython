<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsReporteEmbarazo.aspx.vb" Inherits="Novedades_sfsReporteEmbarazo" title="Reporte registro de Embarazo" %>


<%@ Register src="../Controles/ucInfoEmpleado.ascx" tagname="ucInfoEmpleado" tagprefix="uc1" %>
<%@ Register src="../Controles/ucGridNovPendientes.ascx" tagname="ucGridNovPendientes" tagprefix="uc2" %>
<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc3" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
             
   <script language="javascript" type="text/javascript">
       $(function pageLoad(sender, args) {

           Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);

           function EndRequestHandler(sender, args) {
               $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['es']));
               $(".fecha").datepicker($.datepicker.regional['es']);
           }

       });
        
    </script> 

    <%--<span class="header">Consulta de embarazadas..</span>--%>
   <asp:UpdatePanel ID="UpdatePanel1" runat="server">
   <ContentTemplate>

   <uc3:ucImpersonarRepresentante 
           ID="ucImpersonarRepresentante1" runat="server" />
   <fieldset style="width: 585px; margin-left: 60px" class="label-Blue">
   <legend class="header" style="font-size: 14px; font-weight: normal;">Registro de Embarazo
       </legend>
   <br />
       
       
       
       
   <table class="td-content" id="tblAfiliada" style="margin-left: 17px; width: 550px"  
           cellspacing="0" cellpadding="0" runat="server">
				<tr>
					<%--<td rowspan="4"><img src="../images/deuda.jpg" alt="" width="220" height="89" />
					</td>--%>
					<td>
					<br />
					<span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">Afiliada</span>
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
										ValidationExpression="^[0-9]+$" ErrorMessage="NSS o Cédula invalido."></asp:regularexpressionvalidator></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			
			<asp:label id="lblMsg" cssclass="error" style="margin-left: 17px" EnableViewState="False" Runat="server"></asp:label>
			<div id="divConsulta" visible="false" runat="server">
            <table cellspacing="0" cellpadding="0" style="margin-left: 17px" width="93%">
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
            
            

<div class="td-content" id="fiedlsetDatos" runat="server" visible="false" style="width: 93%; margin-left: 17px">
    
    &nbsp;
    <table style="width: 100%">
        <tr>
            <td>
                <span style="margin-left: 12px">Fecha de diagnóstico:</span>&nbsp;&nbsp;</td>
            <td>
                <asp:TextBox ID="txtFeDiagno" runat="server" CssClass="fecha" onkeypress="return false;" style="margin-left: 7px"></asp:TextBox>
             </td>
        </tr>
        <tr>
            <td>
                <span style="margin-left: 12px">Fecha estimada parto:</span>&nbsp;&nbsp;&nbsp;<br />
            </td>
           
            <td>
             
                <asp:TextBox ID="txtFeParto" runat="server" CssClass="fecha" onkeypress="return false;" style="margin-left: 7px"></asp:TextBox>
                
            </td>
        </tr>
        <tr>
            <td>
                <span style="margin-left: 12px">Teléfono:</span>&nbsp;&nbsp;&nbsp;<br />
            </td>
            <td>
                <asp:TextBox ID="txtTelefono" runat="server" 
                     style="margin-left: 7px" MaxLength="12"></asp:TextBox>
                <asp:Label ID="lblMsg0" Runat="server" cssclass="error" EnableViewState="False" 
                    >Ej: 809-555-5555</asp:Label>
                &nbsp;<asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                    ControlToValidate="txtTelefono" ErrorMessage="Teléfono incorrecto" 
                    ValidationExpression="((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4}">Teléfono 
                incorrecto</asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td>
                <span style="margin-left: 12px">Celular:</span>&nbsp;&nbsp;&nbsp;<br />
            </td>
            <td>
                <asp:TextBox ID="txtCelular" runat="server" 
                    style="margin-left: 7px" MaxLength="12"></asp:TextBox>
                <asp:Label ID="lblMsg1" Runat="server" cssclass="error" EnableViewState="False">Ej: 
                809-555-5555</asp:Label>
                &nbsp;<asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                    ControlToValidate="txtCelular" ErrorMessage="Teléfono incorrecto" 
                    ValidationExpression="((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4}">Celular 
                incorrecto</asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td>
                <span style="margin-left: 12px">Correo Electrónico:</span>&nbsp;&nbsp;&nbsp;<br />
            </td>
            <td>
                <asp:TextBox ID="txtEmail" runat="server" 
                    style="margin-left: 7px" MaxLength="50"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" 
                    ControlToValidate="txtEmail" ErrorMessage="Teléfono incorrecto" 
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">Correo 
                electrónico incorrecto</asp:RegularExpressionValidator>
            </td>
        </tr>
    </table>
    
<br />
    
</div>
<span id="mensageFecha" runat="server" style="margin-left: 16px;"  class="error" visible="false"></span>
<span id="mensajeFecha1" runat="server" style="margin-left: 16px;"  class="error"  visible="false"></span>
	<span id="errorSexo" runat="server" style="margin-left: 16px;"  class="error" visible="false"><b></b></span>
    <span id="errorSta" runat="server" style="margin-left: 16px;"  class="error" visible="false"></span>	
    <span id="errorG" runat="server" style="margin-left: 16px;"  class="error" visible="false"></span>
          <br />
       <table ID="tblTutor" runat="server" 
           cellpadding="0" cellspacing="0" class="td-content" 
           style="margin-left: 17px; width: 94%" visible="false">
           <tr>          
               <td>
                    <span id="tutor" runat="server"  visible="false">Digite la cédula del Tutor o 
       Apoderado designado por la Embarazada:</span>
                    <br />
                   <br />
                   <span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">
                   Tutor</span>
                   <table style="margin-left: 60px">
                       <tr>
                           <td>
                               Cédula o NSS:</td>
                           <td>
                               <asp:TextBox ID="txtCeduNssTutor" runat="server" MaxLength="11" Width="100px"></asp:TextBox>
                               <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                                   ControlToValidate="txtCeduNssTutor" Display="Dynamic" ValidationGroup="tutor">*</asp:RequiredFieldValidator>
                           </td>
                           <td align="right">
                               <asp:Button ID="btnTutor" runat="server" Text="Buscar" 
                                   ValidationGroup="tutor" />
                               &nbsp;<asp:Button ID="btnCancel" runat="server" CausesValidation="False" 
                                   Text="Cancelar" />
                           </td>
                       </tr>
                       <tr>
                           <td align="center" colspan="2">
                               <%--<asp:regularexpressionvalidator id="Regularexpressionvalidator1" runat="server" ControlToValidate="txtCeduNssTutor" Display="Dynamic"
										ValidationExpression="^(\d{9}|\d{11})$" ErrorMessage="NSS o Cédula invalido."></asp:regularexpressionvalidator>--%></td>
                       </tr>
                   </table>
               </td>
           </tr>
       </table>
       <asp:Label ID="lblErrorTutor" Runat="server" cssclass="error" 
           EnableViewState="False" style="margin-left: 17px"></asp:Label>
       <br />
       <div ID="divInfoTutor" runat="server" visible="false">
           <table cellpadding="0" cellspacing="0" style="margin-left: 17px" width="93%">
               <tr>
                   <td>
                       <br />
                       <uc1:ucInfoEmpleado ID="UcInfoEmpleado2" runat="server" />
                       <br />
                   </td>
               </tr>
           </table>
        
       </div>
       <div id="fiedlsetDatosTutor" runat="server" visible="false">
             <br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnRegistrar" 
                 style="margin-left: 62px; width: 90px;" runat="server" 
                 ValidationGroup="fecha" Text="Insertar" />
                <asp:Button ID="btnCancelarGeneral" runat="server" 
                 style="margin-left: 4px; width: 90px" Text="Cancelar" />
                
       </div>
</fieldset>
<br />

<fieldset runat="server" id="fiedlsetDatos1" style="width: 1024px" 
           visible="false">
<legend class="header" style="font-size: 14px"><span style="font-size: 14px">Aplicar novedades</span> 

    </legend>
    <asp:Button ID="btnAplicar" runat="server" ValidationGroup="n" style="margin-left: 360px; float: left " Text="Aplicar novedades" />
    <br />
    <br />
    <fieldset>
<uc2:ucGridNovPendientes ID="ucGridNovPendientes1" runat="server" />
        </fieldset>
</fieldset>
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

