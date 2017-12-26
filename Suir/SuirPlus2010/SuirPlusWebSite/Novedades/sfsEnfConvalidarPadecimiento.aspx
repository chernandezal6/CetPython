<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsEnfConvalidarPadecimiento.aspx.vb" Inherits="Novedades_sfsEnfConvalidarPadecimiento" %>
<%@ Register src="../Controles/ucInfoEmpleado.ascx" tagname="ucInfoEmpleado" tagprefix="uc1" %>
<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc3" %>
<%@ Register src="../Controles/ucTelefono2.ascx" tagname="ucTelefono2" tagprefix="uc4" %>
<%@ Register src="../Controles/ucGridNovPendientes.ascx" tagname="ucGridNovPendientes" tagprefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<script language="javascript" type="text/javascript">

    function modelesswin(url) {
        //window.showModalDialog(url, "", "help:0;status:0;toolbar:0;scrollbars:0;dialogwidth:840px:dialogHeight:5000px")
        window.open(url, "", "width=840px,height=5000px").print();
    }	
 
 </script>
 
 <asp:UpdatePanel ID="UpdatePanel1" runat="server">

    <ContentTemplate>
        <uc3:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
        <span class="header">Convalidar Padecimiento</span>
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
                                    &nbsp;</td>
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
                                    <asp:CommandField CausesValidation="False" SelectText="Convalidar" 
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
                       <br />
                       <asp:Label ID="lblTerminar" Runat="server" cssclass="error"></asp:Label>
                   </td>
               </tr>
               <tr>
                   <td>
                       &nbsp;</td>
                   <td style="text-align: right">
                       <br />
                       <br />
                       <asp:Button ID="btnProcesar" runat="server" Height="19px" 
                           style="margin-left: 62px; width: 90px;" Text="Procesar" 
                           ValidationGroup="fecha" />
                       <asp:Button ID="btnVolver" runat="server" style="margin-left: 4px; width: 90px" 
                           Text="Volver atrás" />
                   </td>
               </tr>
           </table>
           
           <br />
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
    </ContentTemplate>
</asp:UpdatePanel>

</asp:Content>

