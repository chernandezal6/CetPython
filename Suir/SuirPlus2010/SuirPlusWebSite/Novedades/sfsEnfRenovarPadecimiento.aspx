<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsEnfRenovarPadecimiento.aspx.vb" Inherits="Novedades_sfsEnfRenovarPadecimiento" %>
<%@ Register src="../Controles/ucInfoEmpleado.ascx" tagname="ucInfoEmpleado" tagprefix="uc1" %>
<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc3" %>
<%@ Register src="../Controles/ucTelefono2.ascx" tagname="ucTelefono2" tagprefix="uc4" %>
<%@ Register src="../Controles/ucGridNovPendientes.ascx" tagname="ucGridNovPendientes" tagprefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<script language="javascript" type="text/javascript">

    function modelesswin(url) {
        window.open(url, "", "width=840px,height=5000px").print();
    }	
 
 </script>
 
 <asp:UpdatePanel ID="UpdatePanel1" runat="server">

    <ContentTemplate>
        <uc3:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
        <span class="header">Renovar Padecimiento</span>
        <div id="general" style="width: 750px; margin-left: 60px">
        <br />
            <fieldset class="label-Blue">
                <legend class="header" style="font-size: 14px; font-weight: normal;">Solicitud de Subsidio por Enfermedad</legend>
				<br />
                <div id="divConsulta" class="td-content" style="margin-left: 17px; width: 550px">
                    <span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">Empleado(a):</span>
                    <table style="margin-left: 60px">
                        <tr>
                            <td>
                                Cédula:</td>
                            <td>
                                <asp:TextBox ID="txtCedula" runat="server" MaxLength="11" Width="100px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtCedula" Display="Dynamic" 
                                    ValidationGroup="consultar">*</asp:RequiredFieldValidator>
                            </td>
                            <td align="right">
                                <asp:Button ID="btnConsultar" runat="server" Text="Buscar" ValidationGroup="consultar" />
                                <asp:Button ID="btnCancelar" runat="server" CausesValidation="False" 
                                    Text="Cancelar" />
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                                <asp:RegularExpressionValidator ID="regExpRncCedula" runat="server" ControlToValidate="txtCedula" Display="Dynamic" 
                                ErrorMessage="Cédula inválida." ValidationExpression="^[0-9]+$"></asp:RegularExpressionValidator>
                            </td>
                        </tr>
                    </table>
                </div>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
                    HeaderText="Por favor corregir lo siguiente:" style="margin-left: 17px" forecolor="Red" 
                    ValidationGroup="completar" DisplayMode="List" />
                <asp:Label ID="lblMsg" Runat="server" EnableViewState="False" style="margin-left: 17px" ForeColor="Red"></asp:Label>
                <br />
                <asp:Label ID="lblCompletar" Runat="server" ForeColor="#FF3300" 
                    style="margin-left: 17px"></asp:Label>
                
                <br />
                <div ID="divInfoEmpleado" runat="server" style="margin-left: 17px" visible="false">
                    <uc1:ucInfoEmpleado ID="ucInfoEmpleado1" runat="server" />
                    <asp:HiddenField ID="hidInfoEmpleado" runat="server" Value="false" Visible="False" />
                    <br />
                </div>
                
                
                
                <div ID="divDatosIniciales" runat="server"  visible="false">
                <table class="td-content" style="width: 550px; margin-left: 17px; ">
                            <tr>
                                <td colspan="2" width="100%">
                                    <span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">
                                    Datos Generales del Empleado(a)</span>
                                    <br />
                                </td>
                            </tr>
                                    <tr>
                                        <td width="20%">
                                            <span style="margin-left: 5px">Dirección(*):</span>&nbsp;&nbsp;&nbsp;<br />
                                        </td>
                                        <td width="80%">
                                            <asp:TextBox ID="txtTrabajadorDireccion" runat="server" 
                                                Height="44px" TextMode="MultiLine" Width="260px" MaxLength="200" 
                                                	style="border: 1px solid #B8D7FF; margin-left: 0px;"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" 
                                                ControlToValidate="txtTrabajadorDireccion" Display="Dynamic" 
                                                ValidationGroup="DatosIniciales">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                            <tr>
                                <td width="20%">
                                    <span style="margin-left: 5px">Teléfono(*):</span>&nbsp;&nbsp;&nbsp;<br />
                                </td>
                                <td width="80%">
                                    <uc4:ucTelefono2 ID="txtTrabajadorTelefono" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td width="20%">
                                    <span style="margin-left: 5px">Celular:</span>&nbsp;&nbsp;&nbsp;<br />
                                </td>
                                <td align="left" width="80%">
                                    <uc4:ucTelefono2 ID="txtTrabajadorCelular" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td width="20%">
                                    <span style="margin-left: 5px">Correo Electrónico:</span>&nbsp;&nbsp;&nbsp;<br />
                                </td>
                                <td width="80%">
                                    <asp:TextBox ID="txtTrabajadorCorreo" runat="server" MaxLength="100" 
                                        Width="256px" ></asp:TextBox>
                                    &nbsp;<br />
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" 
                                        ControlToValidate="txtTrabajadorCorreo" ErrorMessage="Teléfono incorrecto" 
                                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">Correo 
                                    electrónico incorrecto</asp:RegularExpressionValidator>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" colspan="2" width="100%">
                                  <div id="divBotonesDatosIniciales" runat="server" >
                                    <asp:Button ID="btnRegistrarDatosIniciales" runat="server" Height="19px" 
                                        style="width: 90px;" Text="Registrar" ValidationGroup="DatosIniciales" />
                                      <asp:Button ID="btnCompletar" runat="server" 
                                          style="margin-left: 4px; width: 90px; height: 19px;" Text="Completar Datos" 
                                          ValidationGroup="DatosIniciales" Visible="False" />
                                      <br />
                                      &nbsp;<br />
                                  
                                        <div ID="divSolicitudRegistrada" runat="server" style="text-align: right" visible="false">
                                            <table style="width: 100%;">
                                                <tr>
                                                    <td align="center">
                                                        <span class="label-Blue" style="margin-left: 17px">
                                                        Formulario generado exitosamente, ahora debe 
                                                        imprimirlo y entregarlo al trabajador(a) afectado por licencia médica para que 
                                                        su médico tratante lo complete. Una vez completado vuelva a esta pantalla para 
                                                        digitar los datos llenados por el médico. Para reimprimir el formulario puede 
                                                        entregarle el siguiente PIN al trabajador(a)</span>
                                            <asp:Label ID="lblPin" runat="server" CssClass="label-Blue"></asp:Label>
                                                        <br />
                                                        <br />
                                                        <asp:Button ID="btnVerFormulario" runat="server" Text="Imprimir Formulario" 
                                                            ValidationGroup="DatosIniciales" Width="104px" />
                                                    </td>
                                                </tr>
                                            </table>
                                        <br />
                                        </div>     
                                      </div>
                                      </td>
                                     </tr>
                                   </table>
                                   <br />
                                  </div> 
                                  
                                  
<div ID="divPadecimientos" runat="server" visible="false">
           <table class="td-content" style="width: 688px; margin-left: 17px; ">
            <tr>
            <td>
                <span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">
                        Licencias Reportadas</span>
                   <br />
                   <br />
                <table  >
                    <tr>
                        <td style="text-align: right; width: 18px" >
                            &nbsp;</td>
                        <td>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td style="width: 18px">
                        </td>
                        <td>
                            <asp:GridView ID="gvPadecimientos" runat="server" AutoGenerateColumns="False" 
                                Width="640px" >
                                <Columns>
                                    <asp:BoundField DataField="NroSolicitud" HeaderText="Número Formulario" >
                                        <ItemStyle Width="135px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Fecha_Registro" HeaderText="Fecha Registro" 
                                        DataFormatString="{0:d}" >
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="65px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Diagnostico" HeaderText="Diagnóstico" >
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle Width="300px" Wrap="True" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Estatus" HeaderText="Status">
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Width="100px" />
                                    </asp:BoundField>
                                    <asp:CommandField CausesValidation="False" SelectText="Renovar" 
                                        ShowHeader="True" ShowSelectButton="True">
                                        <ItemStyle HorizontalAlign="Center" Width="50px" />
                                    </asp:CommandField>
                                </Columns>
                            </asp:GridView>
                            <br />
                        </td>
                    </tr>
                </table>
            </td>
            </tr>
           </table>
           <br />
           </div>                                  
                                  
                                  
                                  <div ID="divCompletar" runat="server" visible="false">
                                   <table class="td-content" style="width: 80%; margin-left: 17px; " >
                                    <tr>
                                        <td>
                                            <table style="width: 100%; ">
                                               <tr>
                                                   <td valign="top">
                                                       <table style="width: 100%; height: 47px;">
                                                           <tr>
                                                               <td colspan="2">
                                                                   <span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; 

                        font-family: Arial">
                                           Detalle de la Discapacidad</span>
                                           <br />
                                       </td>
                                   </tr>
                                   <tr>
                                       <td style="width: 183px">
                                           <span style="margin-left: 5px">Nómina del Empleado:</span></td>
                                       <td>
                                           <asp:DropDownList ID="ddlNomina" runat="server" CssClass="dropDowns" 
                                               Width="226px">
                                           </asp:DropDownList>
                                       </td>
                                   </tr>
                                   <tr>
                                       <td style="width: 183px">
                                           <span style="margin-left: 5px">Modalidad :<br />
                                           (Marque ambas si aplican las dos)</span>&nbsp;&nbsp;&nbsp;</td>
                                       <td>
                                           <asp:CheckBox ID="ckAmbulatoria" runat="server" Text="Ambulatoria" 
                                               AutoPostBack="True" />
                                           &nbsp;<asp:CheckBox ID="ckHospitalaria" runat="server" Text="Hospitalaria" 
                                               AutoPostBack="True" />
                                       </td>
                                   </tr>
                               </table>
                               
                               <div id="divMedico" runat="server" visible = "false">
                               <br />
                               <span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: 

Arial">
                                   Identificación del Médico Tratante</span>
                                <br />
                                   <table style="width:100%;">
                                       <tr>
                                           <td>
                                               <table style="width: 100%; ">
                                                   <tr>
                                                       <td style="width: 141px; height: 1px;">
                                                           <span style="margin-left: 5px">Cédula Médico(*):</span>&nbsp;&nbsp;&nbsp;</td>
                                                       <td style="height: 1px">
                                                           <asp:TextBox ID="txtMedicoCedula" runat="server" MaxLength="11" 
                                                               CssClass="TDTotalGral"></asp:TextBox>
                                                           &nbsp;<asp:RequiredFieldValidator ID="RequiredFieldValidator2" 

runat="server" 
                                                               ControlToValidate="txtMedicoCedula" Display="Dynamic" 

ValidationGroup="completar" ErrorMessage="El médico es requerido">*</asp:RequiredFieldValidator>
                                                           &nbsp;<asp:Button ID="btnBuscarMedico" runat="server" Text="Buscar" 

ValidationGroup="medico" />
                                                           <asp:Button ID="btnCancelarMedico" runat="server" 

CausesValidation="False" 
                                                               Text="Cancelar" />
                                                           <br />
                                                           <asp:Label ID="lblMedico" Runat="server" cssclass="error"></asp:Label>
                                                       </td>
                                                   </tr>
                                               </table>
                                           </td>
                                       </tr>
                                       <tr>
                                           <td>
                                               <div id="divDatosMedico" runat="server" visible="false">
                                               <table style="width: 100%">
                                                   <tr>
                                                       <td style="width: 141px">
                                                           <span style="margin-left: 5px">Exequatur:</span></td>
                                                       <td>
                                                           <asp:TextBox ID="txtMedicoExequatur" runat="server" 
                                                               Width="130px" MaxLength="35"></asp:TextBox>
                                                       </td>
                                                   </tr>
                                                   <tr>
                                                       <td style="width: 141px">
                                                           <span style="margin-left: 5px">Nombre:</span></td>
                                                       <td>
                                                           <asp:TextBox ID="txtMedicoNombre" runat="server" 
                                                               Width="259px" Enabled="False" MaxLength="100"></asp:TextBox>
                                                       </td>
                                                   </tr>
                                                   <tr>
                                                       <td style="width: 141px">
                                                           <span style="margin-left: 5px">Dirección Consultorio(*):</span></td>
                                                       <td valign="middle">
                                                           <asp:TextBox ID="txtMedicoDireccion" runat="server" 
                                                               TextMode="MultiLine" Width="260px" Height="44px" MaxLength="200" 
                                                               CssClass="tblContact"></asp:TextBox>
                                                        
                                                           <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" 
                                                               ControlToValidate="txtMedicoDireccion" ValidationGroup="completar" 
                                                               Display="Dynamic" ErrorMessage="La dirección del consultorio es requerida">*</asp:RequiredFieldValidator>
                                                       </td>
                                                   </tr>
                                                   <tr>
                                                       <td style="width: 141px">
                                                           <span style="margin-left: 5px">Teléfono Consultorio(*):</span>&nbsp;</td>
                                                       <td>
                                                           <uc4:ucTelefono2 ID="txtMedicoTelefono" runat="server" />
                                                           &nbsp;</td>
                                                   </tr>
                                                   <tr>
                                                       <td style="width: 141px">
                                                           <span style="margin-left: 5px">Celular:</span>&nbsp;&nbsp;&nbsp;<br />
                                                       </td>
                                                       <td>
                                                           <uc4:ucTelefono2 ID="txtMedicoCelular" runat="server" />
                                                       </td>
                                                   </tr>
                                                   <tr>
                                                       <td style="width: 141px">
                                                           <span style="margin-left: 5px">Correo 

Electrónico:</span>&nbsp;&nbsp;&nbsp;<br />
                                                       </td>
                                                       <td>
                                                           <asp:TextBox ID="txtMedicoCorreo" runat="server" MaxLength="100" 
                                                               Width="255px"></asp:TextBox>
                                                           <br />
                                                           <asp:RegularExpressionValidator ID="RegularExpressionValidator6" 

runat="server" 
                                                               ControlToValidate="txtMedicoCorreo" ErrorMessage="Teléfono 

incorrecto" 
                                                               ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                                                               ValidationGroup="completar">Correo electrónico 

incorrecto</asp:RegularExpressionValidator>
                                                       </td>
                                                   </tr>
                                               </table>
                                             </div>
                                           </td>
                                       </tr>
                                   </table>
                               </div>
                           </td>
                       </tr>
                       <tr>
                        <td valign="top">
                            <div ID="divPSS" runat="server" visible="False"> 
                            <br />
                                <span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: 

Arial">
                                Identificación de la PSS (Clínica, Hospital, etc)</span><table style="width:100%; ">
                                    <tr>
                                        <td>
                                            <table style="width: 100%; ">
                                                <tr>
                                                    <td style="width: 142px; height: 1px;">
                                                        <span style="margin-left: 5px">Nombre PSS(*):</span>&nbsp;&nbsp;&nbsp;</td>
                                                    <td style="height: 1px">
                                                        <asp:TextBox ID="txtPSSNombre" runat="server" MaxLength="100" Width="221px" 
                                                            CssClass="TDTotalGral"></asp:TextBox>
                                                        &nbsp;<asp:RequiredFieldValidator ID="RequiredFieldValidator3" 

runat="server" 
                                                            ControlToValidate="txtPSSNombre" Display="Dynamic" 

ValidationGroup="completar" ErrorMessage="La Prestadora de Servicio de Salud es requerida">*</asp:RequiredFieldValidator>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator17" runat="server" 
                                                            ControlToValidate="txtPSSNombre" Display="Dynamic" 
                                                            ErrorMessage="La Prestadora de Servicio de Salud es requerida" 
                                                            ValidationGroup="PSS">*</asp:RequiredFieldValidator>
                                                        &nbsp;<asp:Button ID="btnBuscarPSS" runat="server" Text="Buscar" 
                                                            ValidationGroup="PSS" />
                                                        <asp:Button ID="btnCancelarPSS" runat="server" CausesValidation="False" 
                                                            Text="Cancelar" />
                                                        <br />
                                                        <asp:Label ID="lblPSS" Runat="server" cssclass="error"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div ID="divDatosPSS" runat="server" visible="false">
                                                <table style="width: 100%">
                                                    <tr>
                                                        <td style="width: 140px">
                                                            <span style="margin-left: 5px">Número PSS:</span></td>
                                                        <td>
                                                            <asp:TextBox ID="txtPSSNumero" runat="server" onkeypress="return false;"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 140px">
                                                            <span style="margin-left: 5px">Dirección(*):</span></td>
                                                        <td>
                                                            <asp:TextBox ID="txtPSSDireccion" runat="server" 
                                                              TextMode="MultiLine" Width="260px" Height="44px" MaxLength="200" 
                                                                CssClass="tblContact"></asp:TextBox>
                                                        
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator9" 

runat="server" 
                                                                ControlToValidate="txtPSSDireccion" 

ValidationGroup="completar" ErrorMessage="La dirección de la PSS es requerida">*</asp:RequiredFieldValidator>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 140px">
                                                            <span style="margin-left: 5px">Teléfono(*):</span>&nbsp;</td>
                                                        <td>
                                                            <uc4:ucTelefono2 ID="txtPssTelefono" runat="server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="height: 20px; width: 140px;">
                                                            <span style="margin-left: 5px">Fax:</span>&nbsp;&nbsp;&nbsp;</td>
                                                        <td style="height: 20px">
                                                            <uc4:ucTelefono2 ID="txtPssFax" runat="server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 140px">
                                                            <span style="margin-left: 5px">Correo 

Electrónico:</span>&nbsp;&nbsp;&nbsp;<br />
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtPSSCorreo" runat="server" MaxLength="50" 
                                                                 Width="255px"></asp:TextBox>
                                                            <br />
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator9" 

runat="server" 
                                                                ControlToValidate="txtPSSCorreo" ErrorMessage="Teléfono 

incorrecto" 
                                                                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                                                                ValidationGroup="completar">Correo 
                                                            electrónico incorrecto</asp:RegularExpressionValidator>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <br />
                                </div>
                                <div ID="divDiscapacidad" runat="server" visible="False">
                                    <span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">
                                    Datos Médicos que dan Origen a la Discapacidad Laboral</span>
                                    <table style="width:100%; ">
                                        <tr>
                                            <td>
                                                    <table style="width: 100%; height: 386px;">
                                                        <tr>
                                                            <td style="width: 135px">
                                                                <span style="margin-left: 5px">Tipo(*):</span></td>
                                                            <td>
                                                                <asp:RadioButton ID="rdEnfermedadComun" runat="server" 
                                                                    GroupName="rbTipoDiscapacidad" Text="Enfermedad Común" />
                                                                <br />
                                                                <asp:RadioButton ID="rdAccidente" runat="server" 

GroupName="rbTipoDiscapacidad" 
                                                                    Text="Accidente no Laboral" />
                                                                <br />
                                                                <asp:RadioButton ID="rdEmbarazo" runat="server" 

GroupName="rbTipoDiscapacidad" 
                                                                    Text="Discapacidad por Embarazo" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 135px">
                                                                <span style="margin-left: 5px">Código CIE-10:</span></td>
                                                            <td>
                                                                <asp:TextBox ID="txtDiscapCIE10" runat="server" MaxLength="4"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 135px">
                                                                <span style="margin-left: 5px">Diagnóstico Principal(*):</span></td>
                                                            <td>
                                                                <asp:TextBox ID="txtDiscapDiagnostico" runat="server" 
                                                                     TextMode="MultiLine" Width="332px" 

Height="69px" MaxLength="600" CssClass="tblContact"></asp:TextBox>
                                                               
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator11" 

runat="server" 
                                                                    ControlToValidate="txtDiscapDiagnostico" Display="Dynamic" 
                                                                    ValidationGroup="completar" 
                                                                    ErrorMessage="El Diagnóstico principal es requerido">*</asp:RequiredFieldValidator>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 135px">
                                                                <span style="margin-left: 5px">Signos y Síntomas:</span></td>
                                                            <td>
                                                                <asp:TextBox ID="txtDiscapSintomas" runat="server" Height="69px" 
                                                                    TextMode="MultiLine" 
                                                                    Width="332px" MaxLength="600" CssClass="tblContact"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 135px">
                                                                <span style="margin-left: 5px">Procedimientos&nbsp;Realizados:</span></td>
                                                            <td>
                                                                <asp:TextBox ID="txtDiscapProcedimientos" runat="server" 

Height="69px" 
                                                                     TextMode="MultiLine" 
                                                                    Width="332px" MaxLength="600" CssClass="tblContact"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 135px">
                                                                <span style="margin-left: 5px">Fecha de Diagnóstico(*):</span></td>
                                                            <td style="text-align: left">
                                                                <asp:TextBox ID="txtDiscapFechaDiagnostico" runat="server" 
                                                                    onKeyPress="return false;" AutoPostBack="False"></asp:TextBox>
                                                                <ajaxToolkit:CalendarExtender ID="txtDiscapFechaDiagnostico_CalendarExtender" 
                                                                    runat="server" Animated="true" CssClass="yui" Format="dd/MM/yyyy" 
                                                                    PopupButtonID="img1"  TargetControlID="txtDiscapFechaDiagnostico" />
                                                                <asp:ImageButton ID="img1" runat="server" 
                                                                    ImageUrl="~/App_Themes/SP/images/Calendar.png" />
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server" 
                                                                    ControlToValidate="txtDiscapFechaDiagnostico" Display="Dynamic" 
                                                                    ErrorMessage="La fecha de diagnóstico es requerida" ValidationGroup="completar">*</asp:RequiredFieldValidator>
                                                                <br />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <div id="divFechaDiasAmbulatorio" runat="server" visible="false">
                                                                    <table width="100%">
                                                                        <tr>
                                                                            <td class="span" colspan="2">
                                                                                <span style="font-size: 14px; font-weight: bold; 

color:#016BA5; font-family: Arial">
                                                                                Datos de Servicio Ambulatorio:</span></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td style="width: 139px">
                                                                                <span >Fecha Inicio Licencia(*):</span></td>
                                                                            <td>
                                                                                <asp:TextBox ID="txtDiscapFechaLicenciaAmb" 

runat="server" 
                                                                                    onKeyPress="return false;" ></asp:TextBox>
                                                                                <ajaxToolkit:CalendarExtender 

ID="txtDiscapFechaLicenciaAmb_CalendarExtender" 
                                                                                    runat="server" Animated="true" CssClass="yui" 

Format="dd/MM/yyyy" 
                                                                                    PopupButtonID="img2" 

TargetControlID="txtDiscapFechaLicenciaAmb" />
                                                                                <asp:ImageButton ID="img2" runat="server" 
                                                                                    ImageUrl="~/App_Themes/SP/images/Calendar.png" 

/>
                                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" 
                                                                                    ControlToValidate="txtDiscapFechaLicenciaAmb" Display="Dynamic" 
                                                                                    ErrorMessage="La fecha de inicio de licencia ambulatoria es requerida" 
                                                                                    ValidationGroup="completar">*</asp:RequiredFieldValidator>
                                                                                <asp:RangeValidator ID="RangeValidator1" runat="server" 
                                                                                    ControlToValidate="txtDiscapFechaLicenciaAmb" Display="Dynamic" 
                                                                                    ErrorMessage="La fecha de inicio la licencia ambulatoria debe ser posterior al 1ero de Septiembre del 2009" 
                                                                                    MaximumValue="01/01/3000" MinimumValue="01/09/2009" Type="Date" 
                                                                                    ValidationGroup="completar">*</asp:RangeValidator>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td style="width: 139px; height: 1px;">
                                                                                <span >Días Calendario Licencia(*)</span></td>
                                                                            <td style="height: 1px">
                                                                                <asp:TextBox ID="txtDiscapDiasAmb" runat="server" 

MaxLength="3"></asp:TextBox>
                                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" 
                                                                                    ControlToValidate="txtDiscapDiasAmb" Display="Dynamic" 
                                                                                    ErrorMessage="La cantidad de días calendario de servicio ambulatorio es requerido" 
                                                                                    ValidationGroup="completar">*</asp:RequiredFieldValidator>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <div id="divFechaDiasHospitalizacion" runat="server" 

visible="false">
                                                                    <table width="100%">
                                                                        <tr>
                                                                            <td colspan="2">
                                                                                <span style="font-size: 14px; font-weight: bold; 

color:#016BA5; font-family: Arial">
                                                                                Datos de Servicio Hospitalario:</span></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td style="width: 140px">
                                                                                <span >Fecha Inicio Licencia(*):</span></td>
                                                                            <td>
                                                                                <asp:TextBox ID="txtDiscapFechaLicenciaHosp" 

runat="server" 
                                                                                    onKeyPress="return false;" ></asp:TextBox>
                                                                                <ajaxToolkit:CalendarExtender 

ID="txtDiscapFechaLicenciaHosp_CalendarExtender" 
                                                                                    runat="server" Animated="true" CssClass="yui" 

Format="dd/MM/yyyy" 
                                                                                    PopupButtonID="img3" 

TargetControlID="txtDiscapFechaLicenciaHosp" />
                                                                                <asp:ImageButton ID="img3" runat="server" 
                                                                                    ImageUrl="~/App_Themes/SP/images/Calendar.png" 

/>
                                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" 
                                                                                    ControlToValidate="txtDiscapFechaLicenciaHosp" Display="Dynamic" 
                                                                                    ErrorMessage="La fecha de inicio de licencia hospitalaria es requerida" 
                                                                                    ValidationGroup="completar">*</asp:RequiredFieldValidator>
                                                                                <asp:RangeValidator ID="RangeValidator2" runat="server" 
                                                                                    ControlToValidate="txtDiscapFechaLicenciaHosp" Display="Dynamic" 
                                                                                    ErrorMessage="La fecha de inicio la licencia hospitalaria debe ser posterior al 1ero de Septiembre del 2009" 
                                                                                    MaximumValue="01/01/3000" MinimumValue="01/09/2009" Type="Date" 
                                                                                    ValidationGroup="completar">*</asp:RangeValidator>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td style="width: 140px; height: 1px;">
                                                                                <span >Días Calendario Licencia(*)</span></td>
                                                                            <td style="height: 1px">
                                                                                <asp:TextBox ID="txtDiscapDiasHosp" runat="server" 

MaxLength="3"></asp:TextBox>
                                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator15" runat="server" 
                                                                                    ControlToValidate="txtDiscapDiasHosp" Display="Dynamic" 
                                                                                    ErrorMessage="La cantidad de días calendario de servicio hospitalario es requerido" 
                                                                                    ValidationGroup="completar">*</asp:RequiredFieldValidator>
                                                                            </td>
                                                                        </tr>
                                                                    </table>                                                       

 
                                                                </div>                                                    
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right" colspan="2">
                                                                <br />
                                                                <asp:Button ID="btnRegistrar" runat="server" 
                                                                    style="margin-left: 62px; width: 90px; " Text="Registrar" 
                                                                    ValidationGroup="completar" />
                                                                <asp:Button ID="btnCancelarCompletado" runat="server" 
                                                                    style="margin-left: 4px; width: 90px" Text="Cancelar" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                           
                        </td>
                       </tr>
                   </table>
                            
                </td>
            </tr>
           </table>
       </div>
                
                
                
                
                 <div ID="divConfirmar" runat="server" visible="false">
           &nbsp;<table style="width: 90%; ">
               <tr>
                   <td colspan="2" >
                   <span style="font-size: x-large; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">
                                   Confirmar los Datos de la Licencia</span>
                                   <br />
                                   <br />
                       <table align="left" cellpadding="0" cellspacing="0" 
                           style="margin-left:17px; width: 530px;" border="0" class="td-content">
                           <tr>
                               <td style="width: 134px" class="td-content">
                                  <span style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444; height: 66px;"> Dirección Empleado:</span></td>
                               <td align="left" style="margin-left: 40px; width: 396px;">
                                   <asp:Label ID="lblConfTrabDireccion" runat="server" CssClass="labelData"></asp:Label>
                               </td>
                           </tr>
                           <tr>
                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444; width: 134px;" 
                                   class="td-content">
                                   Telefono Empleado:</td>
                               <td align="left" style="margin-left: 40px; width:396 ;">
                                   <asp:Label ID="lblConfTrabTelefono" runat="server" CssClass="labelData"></asp:Label>
                               </td>
                           </tr>
                           <tr>
                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444; width: 134px;" 
                                   class="td-content">
                                   Celular:</td>
                               <td align="left" style="margin-left: 40px; width: 396px;">
                                   <asp:Label ID="lblConfTrabCelular" runat="server" CssClass="labelData"></asp:Label>
                               </td>
                                   </tr>
                               <tr>
                                   <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444; width: 134px;" 
                                       class="td-content">
                                       Correo:</td>
                               <td align="left" style="margin-left: 40px; width: 396px;">
                                   <asp:Label ID="lblConfTrabCorreo" runat="server" CssClass="labelData"></asp:Label>
                                   </td>
                           </tr>
                           <tr>
                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444; width: 134px;" 
                                   class="td-content">
                                   Nómina del Empleado:</td>
                               <td align="left" style="margin-left: 40px; width: 396px;">
                                   <asp:Label ID="lblConfNomina" runat="server" CssClass="labelData"></asp:Label>
                               </td>
                           </tr>
                            <!--<tr>
                              <td  
                                   style="font-weight: normal; text-align: right; width: 109px;">
                                   Modalidad:</td>
                               <td align="left" style="margin-left: 40px">
                                   <asp:Label ID="lblConfModalidad" runat="server" CssClass="labelData"></asp:Label>
                               </td>
                           </tr>-->
                           <tr>
                               <td  colspan="2">
                                   <div id="divConfMedico" runat="server" visible="false">
                                       <table style="width:100%;" border="0" cellpadding="0" cellspacing="0" 
                                           frame="void">
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 160px;" 
                                                   class="td-content">
                                                   Cédula Médico: </td>
                                               <td style="text-align: left; width: 396px;">
                                                   <asp:Label ID="lblConfMedicoCedula" runat="server" 

CssClass="labelData"></asp:Label>
                                               </td>
                                           </tr>
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 160px;" 
                                                   class="td-content">
                                                   Nombre Médico:</td>
                                               <td style="text-align: left; width: 396px;">
                                                   <asp:Label ID="lblConfMedicoNombre" runat="server" CssClass="labelData"></asp:Label>
                                               </td>
                                           </tr>
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 160px;" 
                                                   class="td-content">
                                                   Exequatur:</td>
                                               <td style="text-align: left; width: 396px;">
                                                   <asp:Label ID="lblConfMedicoExequatur" runat="server" 

CssClass="labelData"></asp:Label>
                                               </td>
                                           </tr>
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 160px; " 
                                                   class="td-content">
                                                   Dirección Médico</td>
                                               <td style="text-align: left; width: 396px;">
                                                   <asp:Label ID="lblConfMedicoDireccion" runat="server" CssClass="labelData"></asp:Label>
                                               </td>
                                           </tr>
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 160px;" 
                                                   class="td-content">
                                                   Teléfono Consultorio:</td>
                                               <td style="text-align: left; width: 396px;">
                                                   <asp:Label ID="lblConfMedicoTelefono" runat="server" 

CssClass="labelData"></asp:Label>
                                               </td>
                                           </tr>
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 160px;" 
                                                   class="td-content">
                                                   Celular:</td>
                                               <td style="text-align: left; width: 396px;">
                                                   <asp:Label ID="lblConfMedicoCelular" runat="server" 

CssClass="labelData"></asp:Label>
                                               </td>
                                           </tr>
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 160px;" 
                                                   class="td-content">
                                                   Correo:</td>
                                               <td style="text-align: left; width: 396px;">
                                                   <asp:Label ID="lblConfMedicoCorreo" runat="server" 

CssClass="labelData"></asp:Label>
                                               </td>
                                           </tr>
                                       </table>
                                   </div>
                               </td>
                           </tr>
                           <tr>
                               <td colspan="2">
                                   <div id="divConfPSS" runat="server" visible="false">
                                       <table style="width:100%;" border="0" cellpadding="0" cellspacing="0" 
                                           frame="void">
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 160px;" 
                                                   class="td-content">
                                                   Nombre PSS:
                                               </td>
                                               <td style="text-align: left; width: 396px;"> 
                                                   <asp:Label ID="lblConfPSSNombre" runat="server" 

CssClass="labelData"></asp:Label>
                                               </td>
                                           </tr>
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 160px;" 
                                                   class="td-content">
                                                   Número PSS:</td>
                                                   <td style="text-align: left; width: 396px;">
                                                       <asp:Label ID="lblConfPSSNumero" runat="server" 

CssClass="labelData"></asp:Label>
                                               </td>
                                           </tr>
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 160px; " 
                                                   class="td-content">
                                                   Dirección:</td>
                                                   <td style="text-align: left; width: 396px;">
                                                       <asp:Label ID="lblConfPSSDireccion" runat="server" CssClass="labelData"></asp:Label>
                                               </td>
                                           </tr>
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 160px;" 
                                                   class="td-content">
                                                   Teléfono:</td>
                                                   <td style="text-align: left; width: 396px;">
                                                       <asp:Label ID="lblConfPSSTelefono" runat="server" 

CssClass="labelData"></asp:Label>
                                               </td>
                                           </tr>
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 160px;" 
                                                   class="td-content">
                                                   Fax:</td>
                                                   <td style="text-align: left; width: 396px;">
                                                       <asp:Label ID="lblConfPSSFax" runat="server" 

CssClass="labelData"></asp:Label>
                                               </td>
                                           </tr>
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 160px;" 
                                                   class="td-content">
                                                   Correo:</td>
                                                   <td style="text-align: left; width: 396px;">
                                                       <asp:Label ID="lblConfPSSCorreo" runat="server" 

CssClass="labelData"></asp:Label>
                                               </td>
                                           </tr>
                                           
                                       </table>
                                   </div>
                               </td>
                           </tr>
                           <tr>
                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 134px;" 
                                   class="td-content">
                                   Tipo Discapacidad:</td>
                               <td align="left" style="margin-left: 40px; width: 396px;">
                                   <asp:Label ID="lblConfDiscapTipo" runat="server" CssClass="labelData"></asp:Label>
                               </td>
                           </tr>
                           <tr>
                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 134px;" 
                                   class="td-content">
                                   Código CIE-10:</td>
                               <td align="left" style="margin-left: 40px; width: 396px;">
                                   <asp:Label ID="lblConfDiscapCIE10" runat="server" CssClass="labelData"></asp:Label>
                               </td>
                           </tr>
                           <tr>
                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 134px; " 
                                   class="td-content">
                                   Diagnóstico Principal<span>:</span></td>
                               <td style="width: 396px;">
                                   <asp:Label ID="lblConfDiscapDiagnostico" runat="server" CssClass="labelData"></asp:Label>
                                   <br />
                               </td>
                           </tr>
                           <tr>
                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 134px; " 
                                   class="td-content">
                                   Signos y Síntomas<span>:</span></td>
                               <td style="width: 396px;" >
                                   <asp:Label ID="lblConfDiscapSintomas" runat="server" CssClass="labelData"></asp:Label>
                                   <br />
                               </td>
                           </tr>
                           <tr>
                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 164px; " 
                                   class="td-content">
                                   Procedimientos Realizados:</td>
                               <td style="width: 396px;">
                                   <asp:Label ID="lblConfDiscapProcedimientos" runat="server" CssClass="labelData"></asp:Label>
                                   <br />
                               </td>
                           </tr>
                           <tr>
                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 134px;" 
                                   class="td-content">
                                   Fecha de Diagnóstico:</td>
                               <td style="width: 396">
                                   <asp:Label ID="lblConfDiscapFechaDiagnostico" runat="server" 
                                       CssClass="labelData"></asp:Label>
                               </td>
                           </tr>
                           <tr>
                               <td  colspan="2" height="0">
                                   <div id="divConfAmbulatoria" runat="server" visible="false">
                                       <table style="width:100%;" border="0" cellpadding="0" cellspacing="0" 
                                           frame="void">
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 164px;" 
                                                   class="td-content">
                                                   Fecha Inicio Licencia (Ambulatoria):</td>
                                               <td style="text-align: left; width: 396px;">
                                                   <asp:Label ID="lblConfDiscapLicenciaAmb" runat="server" CssClass="labelData"></asp:Label>
                                               </td>
                                           </tr>
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 164px;" 
                                                   class="td-content">
                                                   Días Calendario (Ambulatoria)</td>
                                               <td style="text-align: left; width: 396px;">
                                                   <asp:Label ID="lblConfDiscapDiasAmb" runat="server" CssClass="labelData"></asp:Label>
                                                   <br />
                                               </td>
                                           </tr>
                                       </table>
                                   </div>
                               </td>
                           </tr>
                           <tr>
                               <td  colspan="2" height="0">
                                   <div id="divConfHospitalaria" runat="server" visible="false">
                                       <table style="width:100%;" border="0" cellpadding="0" cellspacing="0" 
                                           frame="void">
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 164px;" 
                                                   class="td-content">
                                                   Fecha Inicio Licencia (Hospitalaria):</td>
                                               <td style="text-align: left; width: 396px;">
                                                   <asp:Label ID="lblConfDiscapLicenciaHosp" runat="server" CssClass="labelData"></asp:Label>
                                               </td>
                                           </tr>
                                           <tr>
                                               <td style="font-weight: normal; font-family:Tahoma, Verdana, Arial; font-size:10px; color: #444444;width: 164px;" 
                                                   class="td-content">
                                                   Días Calendario (Hospitalaria)</td>
                                               <td style="text-align: left; width: 396px;">
                                                   <asp:Label ID="lblConfDiscapDiasHosp" runat="server" CssClass="labelData"></asp:Label>
                                               </td>
                                           </tr>
                                       </table>
                                   </div>
                               </td>
                           </tr>
                       </table>
                   </td>
               </tr>
               <tr>
                   <td>
                       &nbsp;</td>
                   <td style="text-align: left">
                       <asp:Label ID="lblConfirmar" Runat="server" cssclass="error"></asp:Label>
                   </td>
               </tr>
               <tr>
                   <td>
                       &nbsp;</td>
                   <td style="text-align: right">
                       <br />
                       <br />
                       <asp:Button ID="btnContinuar" runat="server" Height="19px" 
                           style="margin-left: 62px; width: 90px;" Text="Continuar" 
                           ValidationGroup="fecha" />
                       <asp:Button ID="btnVolver" runat="server" style="margin-left: 4px; width: 90px" 
                           Text="Volver atrás" />
                   </td>
               </tr>
           </table>
           
           <br />
       </div>
                <div ID="divImagen" runat="server" visible="false">
        <table width="585px">
            <tr>
                <td>
                <table class="td-content" style="margin-left:17px;" visible="False">
               <tr>
                   <td colspan="2">
                       <span>¿Desea anexar una imagen de documento?</span>
                       <asp:CheckBox ID="ckImagen" runat="server" Text="Anexar" />
                   </td>
               </tr>
               <tr>
                   <td style="width: 124px">
                       <span>Imagen Documento:</span></td>
                   <td>
                       <asp:FileUpload ID="upLImagenCiudadano" runat="server" Width="296px" />
                   </td>
               </tr>
               <tr>
                   <td style="width: 124px">
                       &nbsp;</td>
                   <td>
                       &nbsp;</td>
               </tr>
           </table>
                    <br />
                    <asp:Label ID="lblTerminar" Runat="server" cssclass="error"></asp:Label>
                </td>
            </tr>
            <tr>
                                   <td style="text-align: right">
                       <br />
                       <br />
                       <asp:Button ID="btnConfirmar" runat="server" Height="19px" 
                           style="margin-left: 62px; width: 90px;" Text="Terminar" 
                           ValidationGroup="fecha" />
                       <asp:Button ID="btnCancelarConfirmacion" runat="server" style="margin-left: 4px; width: 90px; height: 19px;" 
                           Text="Volver atrás" />
                </td>
            </tr>
        </table>
            
       </div>               
            </fieldset>
        </div>
        <br />
            <div id="divNovedades" runat="server" visible="false">
                <fieldset style="width: 1024px" >
                    <legend class="header" style="font-size: 14px">Aplicar Novedades</legend>
                    <asp:Button ID="btnAplicar" ValidationGroup="n" runat="server"  style="margin-left: 360px;" Text="Aplicar novedades" />
                    <br />
                    <br />
                    <uc2:ucGridNovPendientes ID="ucGridNovPendientes1" runat="server" />
                </fieldset>
            </div>
    <ajaxToolkit:AutoCompleteExtender ID="acNombrePSS" runat="server" CompletionListCssClass="autocomplete_completionListElement"
        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem"           
        CompletionListItemCssClass="autocomplete_listItem"
        MinimumPrefixLength="2" ServiceMethod="getPSSList" ServicePath="~/Services/AutoComplete.asmx"
        TargetControlID="txtPSSNombre">
    </ajaxToolkit:AutoCompleteExtender>
    </ContentTemplate>
    <Triggers>
        <asp:PostBackTrigger ControlID="btnVerFormulario" />
        <asp:PostBackTrigger ControlID="btnContinuar" />
        <asp:PostBackTrigger ControlID="btnConfirmar" />
    </Triggers>
</asp:UpdatePanel>

</asp:Content>

