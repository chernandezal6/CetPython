<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsMaternidadExtraordinario.aspx.vb" Inherits="Novedades_sfsMaternidadExtraordinario" title="Subsidio Maternidad Extraordinario" %>
<%@ Register src="../Controles/ucGridNovPendientes.ascx" tagname="ucGridNovPendientes" tagprefix="uc2" %>
<%@ Register src="../Controles/ucInfoEmpleado.ascx" tagname="ucInfoEmpleado" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<script language="javascript" type="text/javascript">


   $(function pageLoad(sender, args) {
       // Datepicker
       $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['es']));
       $(".fecha").datepicker($.datepicker.regional['es']);

   });

</script>
 <asp:UpdatePanel ID="UpdatePanel1" runat="server">
   <ContentTemplate>
   
    <fieldset style="width: 585px; margin-left: 60px">
       <legend class="header" style="font-size: 14px; font-weight: normal;">Solicitud 
           Extraordinaria de Subsidio de Maternidad</legend>
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
            </div>
            
            

<div class="td-content" id="fiedlsetDatosNuevosMadre" runat="server" visible="false" 
            style="width: 93%; margin-left: 17px">
    
    <table style="width: 100%">
        <tr>
            <td style="font-weight: bold" colspan="2">
                <span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">
                Registro de Maternidad </span>&nbsp;</td>
        </tr>
        <tr>
            <td style="font-weight: bold">
                <span style="margin-left: 12px; font-weight: bold;">Fecha de diagnóstico:</span><b>&nbsp;&nbsp;</b></td>
            <td>
                <asp:TextBox ID="txtFeDiagno" runat="server"  CssClass="fecha" onkeypress="return false;"
                     style="margin-left: 7px"></asp:TextBox>
                
            </td>
        </tr>
        <tr>
            <td style="font-weight: bold">
                <span style="margin-left: 12px; font-weight: bold;">Fecha estimada parto:</span></td>
           
            <td>
             
                <asp:TextBox ID="txtFeParto" runat="server"   CssClass="fecha" onkeypress="return false;"
                     style="margin-left: 7px"></asp:TextBox>
                
              </td>
        </tr>
        <tr>
            <td style="font-weight: bold">
                <span style="margin-left: 12px; font-weight: bold;">Teléfono:</span></td>
            <td>
                <asp:TextBox ID="txtTelefono" runat="server" style="margin-left: 7px"></asp:TextBox>
                &nbsp;<asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                    ControlToValidate="txtTelefono" ErrorMessage="Teléfono incorrecto" 
                    ValidationExpression="((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4}" 
                    Display="Dynamic">Teléfono 
                incorrecto</asp:RegularExpressionValidator>
                &nbsp;<asp:Label ID="lblMsg0" Runat="server" cssclass="error" 
                    EnableViewState="False">Ej: 809-555-5555</asp:Label>
            </td>
        </tr>
        <tr>
            <td style="font-weight: bold">
                <span style="margin-left: 12px; font-weight: bold;">Celular:</span></td>
            <td>
                <asp:TextBox ID="txtCelular" runat="server" 
                    style="margin-left: 7px"></asp:TextBox>
                &nbsp;<asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                    ControlToValidate="txtCelular" ErrorMessage="Teléfono incorrecto" 
                    ValidationExpression="((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4}" 
                    Display="Dynamic">Celular 
                incorrecto</asp:RegularExpressionValidator>
                &nbsp;<asp:Label ID="lblMsg1" Runat="server" cssclass="error" 
                    EnableViewState="False">Ej: 809-555-5555</asp:Label>
            </td>
        </tr>
        <tr>
            <td style="font-weight: bold">
                <span style="margin-left: 12px; font-weight: bold;">Correo Electrónico</span></td>
            <td>
                <asp:TextBox ID="txtEmail" runat="server" 
                    style="margin-left: 7px"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" 
                    ControlToValidate="txtEmail" ErrorMessage="Teléfono incorrecto" 
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">Correo 
                electrónico incorrecto</asp:RegularExpressionValidator>
            </td>
        </tr>
    </table>
</div>
        <div ID="fiedlsetDatosMadre" runat="server" 
            style="width: 93%; margin-left: 17px" visible="false">
            &nbsp;<table style="width: 100%" class="td-content">
                <tr>
                    <td style="text-align: left;" colspan="2">
                        <span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">
                        Maternidad Reportada</span>&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 141px; text-align: right;">
                        <span style="font-weight: normal">Fecha de diagnóstico:&nbsp;&nbsp;</span></td>
                    <td>
                        <asp:Label ID="lblFechaDiagnostico" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 141px; text-align: right;">
                        <span style="margin-left: 12px; font-weight: normal;">Fecha estimada parto:</span><span 
                            style="font-weight: normal">&nbsp;&nbsp;&nbsp;</span></td>
                    <td>
                        <asp:Label ID="lblFechaEstimadaParto" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 141px; text-align: right;">
                        <span style="font-weight: normal">Empresa <span style="font-weight: normal">
                        Reportó </span>Embarazo:&nbsp; &nbsp;</span>
                    </td>
                    <td>
                        <asp:Label ID="lblEmprezaReporteEmbarazo" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 141px; text-align: right;">
                        <span style="font-weight: normal">RNC Reportó Embarazo:&nbsp;&nbsp; </span>
                    </td>
                    <td>
                        <asp:Label ID="lblRNC" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 141px; text-align: right;">
                        <span style="margin-left: 12px; font-weight: normal;">Teléfono:</span><span 
                            style="font-weight: normal">&nbsp;&nbsp;</span></td>
                    <td>
                        <asp:Label ID="lblTelefono" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 141px; text-align: right;">
                        <span style="margin-left: 12px; font-weight: normal;">Celular:</span><span 
                            style="font-weight: normal">&nbsp;&nbsp;&nbsp;</span></td>
                    <td>
                        <asp:Label ID="lblCelular" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 141px; text-align: right;">
                        <span style="margin-left: 12px; font-weight: normal;">Correo Electrónico:</span><span 
                            style="font-weight: normal">&nbsp;&nbsp;&nbsp;</span></td>
                    <td>
                        <asp:Label ID="lblEmail" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
            </table>
            <br />
        </div>
        <asp:Label ID="lblErrorTutor" Runat="server" cssclass="error" 
            EnableViewState="False" style="margin-left: 17px"></asp:Label>
        </span>
    <span id="errorSta" runat="server" style="margin-left: 16px;"  class="error" visible="false"></span>	
          <br />
       <table ID="tblTutor" runat="server" 
           cellpadding="0" cellspacing="0" class="td-content" 
           style="margin-left: 17px; width: 94%" visible="false">
           <tr>          
               <td style="font-weight: 700">
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
       <br />
       <div ID="divInfoTutor" runat="server" visible="false">
           <table cellpadding="0" cellspacing="0" style="margin-left: 17px" width="93%">
               <tr>
                   <td>
                       <uc1:ucInfoEmpleado ID="UcInfoEmpleado2" runat="server" />
                   </td>
               </tr>
           </table>
        
       </div>
       <div ID="divInfoTutorActivo" runat="server" visible="false">
            <table cellpadding="1" cellspacing="0" class="td-content" style="margin-left: 17px;" >
                 <tr>
                     <td style="text-align: left;" colspan="2">
                         <asp:Label ID="lblTutorAC" runat="server" 
                             style="margin-left: 17px; font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial" 
                             Text="Tutor Activo"></asp:Label>
                     </td>
                 </tr>
                 <tr>
                     <td style="width: 128px; text-align: right;">
                         <span style="font-weight: normal">Nombres</span></td>
                     <td>
                         <asp:Label ID="lblNombreTutor" runat="server" CssClass="labelData"></asp:Label>
                     </td>
                 </tr>
                 <tr>
                     <td style="width: 128px; text-align: right;">
                         <span style="font-weight: normal">Apellidos</span></td>
                     <td>
                         <asp:Label ID="lblApellidoTutor" runat="server" CssClass="labelData"></asp:Label>
                     </td>
                 </tr>
                 <tr>
                     <td style="width: 128px; text-align: right;">
                         <span style="font-weight: normal">No. Documento</span></td>
                     <td>
                         <asp:Label ID="lblNoDocumentoTutor" runat="server" CssClass="labelData"></asp:Label>
                     </td>
                 </tr>
             </table>
       </div>
       <br />
        <div ID="divDatosLicencia" runat="server" class="td-content" 
            style="width: 93%; margin-left: 17px; font-weight: 700;" visible="False">
            <span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">
            Registro de Licencia</span>
            <br />
            <br />
            <table style="margin-left: 60px">
                <tr>
                    <td style="font-weight: bold">
                        <span font-weight: bold;">RNC:&nbsp;&nbsp; </span>
                    </td>
                    <td>
                        <asp:TextBox ID="txtRNCLicencia" runat="server" Width="140px"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server" 
                            ControlToValidate="txtRNCLicencia" Display="Dynamic" 
                            ErrorMessage="El RNC es requerido" ValidationGroup="rnc">*</asp:RequiredFieldValidator>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                            ControlToValidate="txtRNCLicencia" Display="Dynamic" 
                            ErrorMessage="El RNC es requerido" ValidationGroup="fecha">*</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" 
                            ControlToValidate="txtRNCLicencia" Display="Dynamic" EnableViewState="False" 
                            ErrorMessage="RNC o Cédula Inválido" SetFocusOnError="True" 
                            ValidationExpression="^(\d{9}|\d{11})$" ValidationGroup="rnc">*</asp:RegularExpressionValidator>
                    </td>
                    <td>
                        <asp:Button ID="btnLicencia" runat="server" Text="Buscar" 
                            ValidationGroup="rnc" />
                        <asp:Button ID="btnCancelLicencia" runat="server" CausesValidation="False" 
                            Text="Cancelar" />
                    </td>
                </tr>
            </table>
            <table id="tblNuevaLicencia" style="margin-left: 60px" visible="False" runat="server">
                <tr>
                    <td>
                        Fecha de licencia:</td>
                    <td valign="bottom">
                        <asp:TextBox ID="txtFeLi" runat="server"  CssClass="fecha" onkeypress="return false;" 
                            Width="140px"></asp:TextBox>
                       
                    </td>
                    <td align="right">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td>
                        Destinatario</td>
                    <td>
                        <asp:DropDownList ID="ddlDestinatario" runat="server" CssClass="dropDowns" 
                            Width="144px">
                            <asp:ListItem Value="M">Madre</asp:ListItem>
                            <asp:ListItem Value="T">Tutor</asp:ListItem>
                            <asp:ListItem Value="E">Empresa</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td align="right">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td>
                        Banco Múltiple</td>
                    <td>
                        <asp:DropDownList ID="ddlEntidadRecaudadora" runat="server" 
                            AutoPostBack="True" CssClass="dropDowns" Width="144px">
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" 
                            ControlToValidate="ddlEntidadRecaudadora" 
                            ErrorMessage="Debe seleccionar un Banco Múltiple!!" Font-Bold="True" 
                            InitialValue="0" ValidationGroup="fecha">*</asp:RequiredFieldValidator>
                    </td>
                    <td align="right" style="text-align: left">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td>
                        Nro de Cuenta</td>
                    <td>
                        <asp:Label ID="lblPrefijo" runat="server"></asp:Label>
                        <asp:TextBox ID="txtNumeroCuenta" runat="server" CssClass="input" 
                            MaxLength="20" Width="140px"></asp:TextBox>
                        &nbsp;<asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" 
                            ControlToValidate="txtNumeroCuenta" Display="Dynamic" 
                            ErrorMessage="El número de cuenta es requerido" Font-Bold="True" 
                            ValidationGroup="fecha">*</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="regexNumber" runat="server" 
                            ControlToValidate="txtNumeroCuenta" Display="Dynamic" 
                            ErrorMessage="Formato de cuenta inválido" ValidationExpression="^[0-9]+$" 
                            ValidationGroup="fecha">*</asp:RegularExpressionValidator>
                    </td>
                    <td>
                        &nbsp;</td>
                </tr>
                <tr>
                    <td>
                        Confirmar Nro de Cuenta</td>
                    <td>
                        <asp:Label ID="lblPrefijo0" runat="server"></asp:Label>
                        <asp:TextBox ID="txtNumeroCuenta0" runat="server" CssClass="input" 
                            onkeydown="checkItNoPaste(event);" Width="140px"></asp:TextBox>
                        <asp:CompareValidator ID="CompareValidator2" runat="server" 
                            ControlToCompare="txtNumeroCuenta" ControlToValidate="txtNumeroCuenta0" 
                            Display="Dynamic" 
                            ErrorMessage="La cuenta de confirmación no coincide con el número de cuenta digitado" 
                            ValidationGroup="fecha">*</asp:CompareValidator>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator15" runat="server" 
                            ControlToValidate="txtNumeroCuenta0" Display="Dynamic" 
                            ErrorMessage="La confirmación de la cédula es requerida" Font-Bold="True" 
                            ValidationGroup="fecha">*</asp:RequiredFieldValidator>
                    </td>
                    <td align="right">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td>
                        Tipo de Cuenta</td>
                    <td>
                        <asp:DropDownList ID="ddTipo_Cuentas" runat="server" AutoPostBack="True" 
                            CssClass="dropDowns" Width="144px">
                            <asp:ListItem Value="2">Cuenta de Ahorro</asp:ListItem>
                            <asp:ListItem Value="1">Cuenta Corriente</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td align="right">
                        &nbsp;</td>
                </tr>
            </table>
            <br />
        </div>
        <asp:Label ID="lblMensaje" Runat="server" cssclass="error" 
            EnableViewState="False" style="margin-left: 17px"></asp:Label>
       <div ID="divLicencia" runat="server" visible="false">
        <fieldset>
            <legend> Licencia Reportada </legend>
            <br />
            <asp:GridView ID="gvLicencias" runat="server" AutoGenerateColumns="False" 
                Width="469px">
                <Columns>
                    <asp:BoundField DataField="FECHA_LICENCIA" DataFormatString="{0:d}" 
                        HeaderText="Fecha Licencia" />
                    <asp:BoundField DataField="FECHA_REGISTRO" DataFormatString="{0:d}" 
                        HeaderText="Fecha Registro" />
                    <asp:BoundField DataField="razon_social" HeaderText="Razón Social" />
                </Columns>
            </asp:GridView>
        </fieldset>
        <br />
        </div>
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" Font-Bold="True" 
            HeaderText="Por favor revisar los siguientes errores:" 
            ValidationGroup="fecha" />
       <div id="fiedlsetDatos" runat="server" visible="false">
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnRegistrar" 
                 style="margin-left: 62px; width: 90px; " runat="server" 
                 ValidationGroup="fecha" Text="Insertar" />
                <asp:Button ID="btnCancelarGeneral" runat="server" 
                 style="margin-left: 4px; width: 90px" Text="Cancelar" />
       </div>
                   <asp:Button ID="btnVolver" runat="server" style="margin-left:430px;" 
                 Text="Volver" Visible="False" Width="90px" /> 
</fieldset>
       <br />
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

