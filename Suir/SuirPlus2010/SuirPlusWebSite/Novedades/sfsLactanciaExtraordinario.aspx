<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsLactanciaExtraordinario.aspx.vb" Inherits="Novedades_sfsLactanciaExtraordinario" title="Subsidio Lactancia Extraordinario" %>
<%@ Register src="../Controles/ucInfoEmpleado.ascx" tagname="ucInfoEmpleado" tagprefix="uc1" %>
<%@ Register src="../Controles/ucGridNovPendientes.ascx" tagname="ucGridNovPendientes" tagprefix="uc2" %>
<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
      
      <script language="javascript" type="text/javascript">
      
       $(function pageLoad(sender, args)
            {     
                // Datepicker
                $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['es']));
                $(".fecha").datepicker($.datepicker.regional['es']); 

            });
    </script>
    
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <fieldset style="width: 585px; margin-left: 100px">
            <legend class="header" style="font-size: 14px">Solicitud de Subsidio Extraordinario 
                de Lactancia</legend>
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
								<td align="right"><asp:button id="btnConsultar" runat="server" Text="Buscar"></asp:button>
									<asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button></td>
							</tr>
							<tr>
								<td align="center" colspan="2"><asp:regularexpressionvalidator id="regExpRncCedula" 
                                        runat="server" ControlToValidate="txtCedulaNSS" Display="Dynamic"
										ValidationExpression="^[0-9]+$" ErrorMessage="NSS o Cédula invalido."></asp:regularexpressionvalidator></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		        <br />
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
            <div id="divEmbarazo"  runat="server" visible="false">
                <asp:Label ID="lblMsg1" Runat="server" cssclass="error" EnableViewState="False" 
                    style="margin-left: 17px">Esta afiliada no tiene un previo registro de 
                embarazo, por favor completar:</asp:Label>
                <div class="td-content" id="fiedlsetDatosNuevosMadre" runat="server" 
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
                <asp:TextBox ID="txtFeDiagno" runat="server" CssClass="fecha" onkeypress = "return false;"
                     style="margin-left: 7px"></asp:TextBox>
                
            </td>
        </tr>
        <tr>
            <td style="font-weight: bold">
                <span style="margin-left: 12px; font-weight: bold;">Fecha estimada parto:</span></td>
           
            <td>
             
                <asp:TextBox ID="txtFeParto" runat="server" CssClass="fecha" onkeypress="return false;"
                style="margin-left: 7px"></asp:TextBox>
                
            </td>
        </tr>
        <tr>
            <td style="font-weight: bold">
                <span style="margin-left: 12px; font-weight: bold;">Teléfono:</span></td>
            <td>
                <asp:TextBox ID="txtTelefono" runat="server" style="margin-left: 7px" 
                    MaxLength="12"></asp:TextBox>
                <asp:Label ID="lblMsg2" Runat="server" cssclass="error" EnableViewState="False">Ej: 
                809-555-5555</asp:Label>
                &nbsp;<asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                    ControlToValidate="txtTelefono" ErrorMessage="Teléfono incorrecto" 
                    ValidationExpression="((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4}" 
                    CssClass="error">Teléfono 
                incorrecto</asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td style="font-weight: bold">
                <span style="margin-left: 12px; font-weight: bold;">Celular:</span></td>
            <td>
                <asp:TextBox ID="txtCelular" runat="server" 
                    style="margin-left: 7px" MaxLength="12"></asp:TextBox>
                <asp:Label ID="lblMsg3" Runat="server" cssclass="error" EnableViewState="False">Ej: 
                809-555-5555</asp:Label>
                &nbsp;<asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                    ControlToValidate="txtCelular" ErrorMessage="Teléfono incorrecto" 
                    ValidationExpression="((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4}" 
                    CssClass="error">Celular 
                incorrecto</asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td style="font-weight: bold">
                <span style="margin-left: 12px; font-weight: bold;">Correo Electrónico</span></td>
            <td>
                <asp:TextBox ID="txtEmail" runat="server" 
                    style="margin-left: 7px" MaxLength="50"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" 
                    ControlToValidate="txtEmail" ErrorMessage="Teléfono incorrecto" 
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                    CssClass="error">Correo 
                electrónico incorrecto</asp:RegularExpressionValidator>
            </td>
        </tr>
    </table>
</div>
       <br />
        <span id="errorSta" runat="server" style="margin-left: 16px;"  class="error" visible="false"></span>	
          <br />
       <table ID="tblTutor" runat="server" cellpadding="0" cellspacing="0" class="td-content" style="margin-left: 17px; width: 94%" >
           <tr>          
               <td style="font-weight: 700">
                    <span id="tutor" runat="server" >Digite la cédula del Tutor o 
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
                               <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" 
                                   ControlToValidate="txtCeduNssTutor" Display="Dynamic" 
                                   ValidationGroup="embarazo">*</asp:RequiredFieldValidator>
                           </td>
                           <td align="right">
                               <asp:Button ID="btnTutor" runat="server" Text="Buscar" 
                                   ValidationGroup="embarazo" />
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
       <br />
                       
                <asp:Button ID="btnEmbarazo" runat="server" style="margin-left:430px; height: 19px;" 
                    Text="Registrar" Width="90px" ValidationGroup="embarazo" />
                
</div>
<div id="divLactancia" runat="server" visible="false">
            <div class="td-content" id="fiedlsetDatos" runat="server" visible="false" style="width: 543px; margin-left: 17px">
                <br />
                <br />
                <div ID="DivFecha" runat="server">
                    <span style="margin-left: 12px">Fecha de Nacimiento:</span>
                    <asp:TextBox ID="txtFechaNacimiento" runat="server" CssClass="fecha" onkeypress="return false;"
                     style="margin-left: 7px"></asp:TextBox>
                    <br />
                    <span style="margin-left: 44px">NSS Lactante:</span>
                    <asp:TextBox ID="tbnssLactante" runat="server" style="margin-left: 9px" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                        ControlToValidate="tbnssLactante" Display="Dynamic" ValidationGroup="Lactante">*</asp:RequiredFieldValidator>
                    <asp:Button ID="btnLactante" runat="server" style="margin-left:8px;" 
                        Text="Buscar" ValidationGroup="Lactante" Width="90px" />
                    &nbsp;
                    <br />
                    <span style="margin-left: 00px">Cantidada de Lactantes :</span>&nbsp;&nbsp;
                    <asp:DropDownList ID="ddlLactantes" runat="server" AutoPostBack="True" 
                        CssClass="dropDowns">
                        <asp:ListItem>1</asp:ListItem>
                        <asp:ListItem>2</asp:ListItem>
                        <asp:ListItem>3</asp:ListItem>
                        <asp:ListItem>4</asp:ListItem>
                        <asp:ListItem>5</asp:ListItem>
                        <asp:ListItem>6</asp:ListItem>
                        <asp:ListItem>7</asp:ListItem>
                        <asp:ListItem>8</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <br />  
                <div id="dinfoLactante" runat="server" visible="false" style="text-align: left;">
                    <table>
                        <tr>
                            <td align="right"><span>Nombre:</span></td>
                            <td style="width: 120px">
                                <asp:TextBox ID="lblNombreLact" cssclass="labelData"  runat="server" /><asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                                    ControlToValidate="lblNombreLact" Display="Dynamic" ValidationGroup="Guardar">*</asp:RequiredFieldValidator>
                            </td>
                            <td style="width: 91px"></td>
                            <td></td>
                            <td>
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td align="right"><span>Primer Apellido:</span></td>
                            <td style="width: 120px">
                                <asp:TextBox ID="lblpApellidoLact" cssclass="labelData"  runat="server" >
                                </asp:TextBox><asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                                    ControlToValidate="lblpApellidoLact" Display="Dynamic" 
                                    ValidationGroup="Guardar">*</asp:RequiredFieldValidator>
                            </td>
                            <td align="right" style="width: 91px"><span>Segundo Apellido:</span></td>
                            <td>
                                <asp:TextBox ID="lblsApellidoLact" cssclass="labelData"  runat="server" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" 
                                    ControlToValidate="lblNombreLact" Display="Dynamic" ValidationGroup="Guardar">*</asp:RequiredFieldValidator>
                            </td>
                            <td>
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td align="right"><span>Sexo:</span></td>
                            <td style="width: 97px">
                                <asp:DropDownList  ID="ddlSexoLact" cssclass="labelData"  runat="server" >
                                    <asp:ListItem Value="M">Masculino</asp:ListItem>
                                    <asp:ListItem Value="F">Femenino</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td align="right" style="width: 91px"><span>NUI:</span></td>
                            <td>
                                <asp:TextBox ID="lblNUILact" cssclass="labelData"  runat="server" />
                            </td>
                            <td>
                                <asp:Button ID="btnInsertLact" runat="server" Text="Guardar" ValidationGroup="Guardar" Width="90px" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right" colspan="5">
                            <div id="divConfirmarNombre" runat="server" visible="false">
                                <table ID="Table2" cellpadding="0" cellspacing="0" class="td-content" 
                                    style="width: 100%">
                                    <tr>
                                        <td style="width: 525px">
                                            <br />
                                            <asp:Label ID="lblMsg0" Runat="server" cssclass="error" EnableViewState="False" 
                                                style="margin-left: 17px">Nota: Ya existe un lactante registrado con este 
                                            nombre</asp:Label>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            <asp:Button ID="btnContinuar" runat="server" Text="Continuar" Width="68px" />
                                            <asp:Button ID="btnCancelar2" runat="server" Text="Cancelar" Width="68px" />
                                            <br />
                                        </td>
                                    </tr>
                                </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <br />
                <asp:GridView ID="gvLactantes" runat="server" AutoGenerateColumns="False"
                    style="margin-left: 45px">
                    <Columns>
                        <asp:BoundField DataField="NSS" HeaderText="NSS" />
                        <asp:BoundField DataField="nombres" HeaderText="Nombres" />
                        <asp:BoundField DataField="PrimerApellido" HeaderText="Primer Apellido" />
                        <asp:BoundField DataField="SegundoApellido" HeaderText="Segundo Apellido" />
                        <asp:BoundField DataField="Sexo" HeaderText="Sexo" />
                        <asp:BoundField DataField="NUI" HeaderText="NUI" />
                        <asp:CommandField ShowSelectButton="True" SelectImageUrl="~\images\error.gif" 
                            ButtonType="Image" CausesValidation="False" SelectText="" ShowHeader="True" />
                    </Columns>
                </asp:GridView>
                
                <asp:Button ID="btnGuardar" runat="server" style="margin-left:430px; height: 19px;" 
                    Text="Insertar" Width="90px" Visible="False" />
                <br />    
            </div>
            <asp:GridView ID="gvLactantesReportados" runat="server" AutoGenerateColumns="False" 
                    style="margin-left: 17px" Width="419px">
                    <Columns>
                        <asp:BoundField DataField="id_NSS_lactante" HeaderText="NSS" />
                        <asp:BoundField DataField="NOMBRELACTANTE" HeaderText="Nombres" />
                        <asp:BoundField DataField="Sexo" HeaderText="Sexo" />
                        <asp:BoundField DataField="NUI" HeaderText="NUI" />
                    </Columns>
                </asp:GridView>
                <br />
                <asp:Button ID="btnVolver" runat="server" style="margin-left:430px;" 
                    Text="Volver" Visible="False" Width="90px" />
                <br />
                
        </fieldset>
   
            </div>
            <br />
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



