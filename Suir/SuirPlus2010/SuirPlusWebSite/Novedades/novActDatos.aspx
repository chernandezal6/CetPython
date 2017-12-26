<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="novActDatos.aspx.vb" Inherits="Novedades_novActDatos" title="Novedades - Actualización de Datos" %>

<%@ Register Src="../Controles/ucGridNovPendientes.ascx" TagName="ucGridNovPendientes" TagPrefix="uc3" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc2" %>
<%@ Register TagPrefix="uc1" TagName="UC_DatePicker" Src="../Controles/UC_DatePicker.ascx" %>
<%@ Register TagPrefix="uc1" TagName="UCCiudadano" Src="../Controles/UCCiudadano.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script language="vb" runat="server">
		Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
			
	        Me.RoleRequerido = 31
			
		End Sub
	</script>
<uc2:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
    <table width="620">
        <tr>
            <td valign="bottom">
                <asp:Label ID="lblTitulo1" runat="server" CssClass="header">Cambio de salario y otros</asp:Label></td>
            <td align="right">
                <asp:Panel ID="pnlPendiente" runat="server" Visible="False">
                    <table class="td-note">
                        <tr>
                            <td class="subHeader">
                                Tiene Novedades Pendientes</td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
    </table>
    &nbsp;<table class="td-content" id="table1" runat="server" cellspacing="0" cellpadding="0" width="620" border="0">
		<tr>
			<td class="error" align="left" colspan="2" height="7"></td>
		</tr>		
		<tr>
			<td align="left" colspan="2">Nómina&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <asp:dropdownlist id="ddNomina" runat="server" CssClass="dropDowns" AutoPostBack="True"></asp:dropdownlist></td>
		</tr>
		<tr>
			<td align="left" colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="right"></td>
			<td class="subHeader">&nbsp;</td>
		</tr>
		<tr>
			<td style="HEIGHT: 16px" align="right">&nbsp;</td>
			<td class="subHeader" style="HEIGHT: 16px">Empleado</td>
		</tr>
		<tr>
			<td align="right"></td>
			<td><uc1:ucciudadano id="ucEmpleado" runat="server"></uc1:ucciudadano></td>
		</tr>
		<tr>
			<td align="right"></td>
			<td class="error">&nbsp;</td>
		</tr>
	</table>
    <br />
    <asp:UpdatePanel ID="UpdCiudadano" runat="server" updateMode="Conditional">
        <ContentTemplate>
        
        <asp:Panel ID="pnlActualizaSalario" runat="server" Width="620px" Visible="False">
	   <table id="table3" cellspacing="1" cellpadding="1" width="620" border="0">
						<tr>
							<td style="WIDTH: 286px; height: 32px;">Fecha de Aplicación</td>
							<td style="WIDTH: 114px; height: 32px;" colspan="3">
								<uc1:uc_datepicker id="ucFechaAplicacion" runat="server"></uc1:uc_datepicker></td>
						</tr>
						<tr>
							<td class="subHeader" colspan="4"><font color="black">&nbsp;Los datos numéricos sin coma. 
									Ej. 99999.99&nbsp;&nbsp; <a onclick="window.open('ayudanovedades.aspx', 'Argumento1', 'height: 450px; width: 590px; top: 200px; left: 300px;').print()"
										href="#"><img height="24" src="../images/help.gif" width="24" border="0" alt="" id="IMG1"/></a>
								</font>
							</td>
						</tr>
						<tr>
							<td class="subHeader" colspan="4">&nbsp;- - - Aplicables al cálculo de aportes al 
								SDSS - - -</td>
						</tr>
						<tr>
							<td style="WIDTH: 286px; HEIGHT: 14px"></td>
							<td style="WIDTH: 194px; HEIGHT: 14px; text-align: left;">Datos Actuales</td>
							<td style="WIDTH: 7px; HEIGHT: 14px"></td>
							<td style="HEIGHT: 14px; width: 608px;">
                                Datos <span style="color: #ff0000">Nuevos</span></td>
						</tr>
						<tr style="color: #ff0000">
							<td style="WIDTH: 286px" valign="top">
                                <span style="color: #ff0000">Salario cotizable para la Seg. Social</span></td>
							<td style="WIDTH: 194px; color: #ff0000;" valign="top" align="right">
								<asp:Label id="lblSalarioSS" runat="server">0.00</asp:Label></td>
							<td style="WIDTH: 7px" align="right"></td>
							<td align="left" style="width: 608px">
								<asp:textbox id="txtSalarioSS" runat="server" MaxLength="15"></asp:textbox>&nbsp;<font color="red">
									<a onclick="window.open('ayudasalario.aspx', 'Argumento1', 'height: 600px; width: 425px; top: 200px; left: 300px;').print()"
										href="#"><img height="18" src="../images/smallhelp.gif" width="18" border="0" alt=""/></a><span
                                            style="color: #000000"> </span>
									<asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" CssClass="error" ErrorMessage="*" ControlToValidate="txtSalarioSS"></asp:requiredfieldvalidator>
									<asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" CssClass="error" ErrorMessage="Formato Inválido"
										ControlToValidate="txtSalarioSS" ValidationExpression="^\d+(\.\d\d)?$"></asp:regularexpressionvalidator></font></td>
						</tr>						
						
						<tr>
							<td style="WIDTH: 286px" valign="top">
                                <span style="color: #ff0000">Aporte Voluntario Ordinario</span></td>
							<td style="WIDTH: 194px; color: #ff0000;" valign="top" align="right">
								<asp:Label id="lblAporteVoluntario" runat="server">0.00</asp:Label></td>
							<td style="WIDTH: 7px" align="right"></td>
							<td style="width: 608px">
								<asp:textbox id="txtAporteVoluntario" runat="server" MaxLength="15"></asp:textbox>&nbsp;<font color="red">
									<asp:requiredfieldvalidator id="RequiredFieldValidator2" runat="server" CssClass="error" ErrorMessage="*" ControlToValidate="txtAporteVoluntario"></asp:requiredfieldvalidator></font>
								<asp:regularexpressionvalidator id="RegularExpressionValidator2" runat="server" CssClass="error" ErrorMessage="Formato Inválido"
									ControlToValidate="txtAporteVoluntario" ValidationExpression="^\d+(\.\d\d)?$"></asp:regularexpressionvalidator></td>
						</tr>
						<tr>
                            <td valign="top" colspan="2">
                                <table style="width:100%;">
                                    <tr>
                                        <td style="width: 78px">
                                            <span style="color: #ff0000">Tipo de Ingreso: </span>
                                        </td>
                                        <td style="text-align: right">
                                            <asp:Label ID="lblTipoIngreso" runat="server" ForeColor="Red" 
                                                style="text-align: right"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td align="right" style="WIDTH: 7px">
                                &nbsp;</td>
                            <td style="width: 608px">
                                <asp:DropDownList ID="ddTipoIngreso" runat="server" AutoPostBack="True" 
                                    CssClass="dropDowns" Enabled="True">
                                </asp:DropDownList>
                            </td>
                        </tr>
						<tr>
							<td class="subHeader" colspan="4">&nbsp;- - - Aplicables al cálculo de retenciones 
								del ISR - - -</td>
						</tr>
						<tr>
							<td style="WIDTH: 286px" valign="top">
                                <span style="color: #ff0000">Salario&nbsp; cotizable para el ISR</span></td>
							<td style="WIDTH: 194px; color: #ff0000;" valign="top" align="right">
								<asp:Label id="lblSalarioISR" runat="server">0.00</asp:Label></td>
							<td style="WIDTH: 7px" align="right"></td>
							<td style="width: 608px">
								<asp:textbox id="txtSalarioISR" runat="server" MaxLength="15"></asp:textbox>&nbsp;<font color="red"><span
                                    style="color: #000000">* </span>
										<asp:requiredfieldvalidator id="RequiredFieldValidator3" runat="server" CssClass="error" ErrorMessage="*" ControlToValidate="txtSalarioISR"></asp:requiredfieldvalidator></font>
								<asp:regularexpressionvalidator id="RegularExpressionValidator3" runat="server" CssClass="error" ErrorMessage="Formato Inválido"
									ControlToValidate="txtSalarioISR" ValidationExpression="\d*./?\d*"></asp:regularexpressionvalidator><br/>
								Nota: Si es igual al de Seg. Social puede dejar en cero.</td>
						</tr>
						
						
						<tr>
							<td class="subHeader" colspan="4">&nbsp;- - - Aplicables al cálculo de aportes al INFOTEP - - -</td>
						</tr>
						<tr>
							<td style="WIDTH: 286px" valign="top">
                                <span style="color: #ff0000">Salario&nbsp; cotizable para el INFOTEP</span></td>
							<td style="WIDTH: 194px; color: #ff0000;" valign="top" align="right">
								<asp:Label id="lblSalarioINF" runat="server">0.00</asp:Label></td>
							<td style="WIDTH: 7px" align="right"></td>
							<td style="width: 608px">
								<asp:textbox id="txtSalarioINF" runat="server" MaxLength="15"></asp:textbox>&nbsp;<font color="red"><span
                                    style="color: #000000">* </span>
										<asp:requiredfieldvalidator id="RequiredFieldValidator7" runat="server" CssClass="error" ErrorMessage="*" ControlToValidate="txtSalarioINF"></asp:requiredfieldvalidator></font>
								<asp:regularexpressionvalidator id="RegularExpressionValidator8" runat="server" CssClass="error" ErrorMessage="Formato Inválido"
									ControlToValidate="txtSalarioINF" ValidationExpression="\d*./?\d*"></asp:regularexpressionvalidator><br/>
								Nota: Si es igual al de Seg. Social puede dejar en cero.</td>
						</tr>
						
						<tr>
							<td class="subHeader" colspan="4">
                                <span style="color: #ff0000">&nbsp; &nbsp; &nbsp; &nbsp; </span><font color="red"><span
                                    style="color: #000000">Campos 
									aplicables al período</span></font>
								<asp:label id="lblPeriodo" runat="server" ForeColor="Red" Font-Bold="True"></asp:label></td>
						</tr>
						<tr>
							<td style="WIDTH: 286px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Otras 
								remuneraciones</td>
							<td style="WIDTH: 194px" valign="top" align="right">
								<asp:Label id="lblOtrasRemuneraciones" runat="server">0.00</asp:Label></td>
							<td style="WIDTH: 7px" align="right"></td>
							<td style="width: 608px">
								<asp:textbox id="txtOtrasRemuneraciones" runat="server" MaxLength="15"></asp:textbox>&nbsp;(Si 
								Aplica)&nbsp;<font color="red"><span style="font-size: 12pt; color: #000000"> </span>
									<asp:requiredfieldvalidator id="RequiredFieldValidator4" runat="server" CssClass="error" ErrorMessage="*" ControlToValidate="txtOtrasRemuneraciones"></asp:requiredfieldvalidator></FONT><span
                                        style="color: #ff0000"> </span>
								<asp:regularexpressionvalidator id="RegularExpressionValidator4" runat="server" CssClass="error" ErrorMessage="Formato Inválido"
									ControlToValidate="txtOtrasRemuneraciones" ValidationExpression="^\d+(\.\d\d)?$"></asp:regularexpressionvalidator></td>
						</tr>
						<tr>
							<td style="WIDTH: 286px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Saldo a Favor</td>
							<td style="WIDTH: 194px" valign="top" align="right">
								<asp:Label id="lblSaldoFavor" runat="server">0.00</asp:Label></td>
							<td style="WIDTH: 7px" align="right"></td>
							<td style="width: 608px">
								<asp:textbox id="txtSaldoFavor" runat="server" MaxLength="15"></asp:textbox>&nbsp;(Si 
								Aplica)&nbsp;<font color="red">
									<asp:requiredfieldvalidator id="Requiredfieldvalidator6" runat="server" CssClass="error" ErrorMessage="*" ControlToValidate="txtSaldoFavor"></asp:requiredfieldvalidator></font>
								<asp:regularexpressionvalidator id="Regularexpressionvalidator7" runat="server" CssClass="error" ErrorMessage="Formato Inválido"
									ControlToValidate="txtSaldoFavor" ValidationExpression="^\d+(\.\d\d)?$"></asp:regularexpressionvalidator></td>
						</tr>
						<tr>
							<td style="WIDTH: 286px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Ingresos 
								Exentos ISR&nbsp;</td>
							<td style="WIDTH: 194px" valign="top" align="right">
								<asp:Label id="lblIngresoExento" runat="server">0.00</asp:Label></td>
							<td style="WIDTH: 7px" align="right"></td>
							<td style="width: 608px">
								<asp:textbox id="txtIngresoExento" runat="server" MaxLength="15"></asp:textbox>&nbsp;(Si 
								Aplica)&nbsp;<font color="red">
									<asp:requiredfieldvalidator id="Requiredfieldvalidator8" runat="server" CssClass="error" ErrorMessage="*" ControlToValidate="txtIngresoExento"></asp:requiredfieldvalidator></FONT>
								<asp:regularexpressionvalidator id="Regularexpressionvalidator9" runat="server" CssClass="error" ErrorMessage="Formato Inválido"
									ControlToValidate="txtIngresoExento" ValidationExpression="^\d+(\.\d\d)?$"></asp:regularexpressionvalidator></td>
						</tr>
						<tr>
							<td style="WIDTH: 322px" colspan="3">&nbsp;</td>
							<td style="WIDTH: 608px"></td>
						</tr>
						<tr>
							<td style="WIDTH: 286px">RNC Agente de Retención Único</td>
							<td style="WIDTH: 194px" align="right">
								<asp:Label id="lblAgenteRetencionISR" runat="server">0.00</asp:Label></td>
							<td style="WIDTH: 7px" align="right"></td>
							<td class="label" style="width: 608px">
								<asp:textbox id="txtAgenteRetencionISR" runat="server" MaxLength="11"></asp:textbox>&nbsp;(Si 
								Aplica)&nbsp;&nbsp;
								<asp:regularexpressionvalidator id="RegularExpressionValidator5" runat="server" CssClass="error" ErrorMessage="Formato Inválido"
									ControlToValidate="txtAgenteRetencionISR" ValidationExpression="\d*"></asp:regularexpressionvalidator></td>
						</tr>
						<tr>
							<td style="WIDTH: 286px" valign="top">Remuneración en otros empleadores</td>
							<td style="WIDTH: 194px" valign="top" align="right">
								<asp:Label id="lblRemuneracionesOtroEmp" runat="server">0.00</asp:Label></td>
							<td style="WIDTH: 7px" align="right"></td>
							<td style="width: 608px">
								<asp:textbox id="txtRemuneracionesOtroEmp" runat="server" MaxLength="15"></asp:textbox>&nbsp;(Si 
								Aplica)&nbsp;<font size="+0">
									<asp:requiredfieldvalidator id="Requiredfieldvalidator5" runat="server" CssClass="error" ErrorMessage="*" ControlToValidate="txtRemuneracionesOtroEmp"></asp:requiredfieldvalidator></font>
								<asp:regularexpressionvalidator id="RegularExpressionValidator6" runat="server" CssClass="error" ErrorMessage="Formato Inválido"
									ControlToValidate="txtRemuneracionesOtroEmp" ValidationExpression="^\d+(\.\d\d)?$"></asp:regularexpressionvalidator></td>
						</tr>
						<tr>
							<td colspan="4">
								<hr SIZE="1" style="width: 100%"/>
    <asp:label id="lblMsg" runat="server" CssClass="error" EnableViewState="False"></asp:label></td>
						</tr>
						<tr>
							<td colspan="4">
								<table id="table2" width="100%">
									<tr>
										<td valign="top" align="left" width="60%" style="height: 55px"><font color="red">*</font> Información 
											obligatoria.</td>
										<td align="right" style="height: 55px" width="40%">
											<asp:button id="btnAceptar" runat="server" Text="Insertar"></asp:button>&nbsp;
											<asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button>&nbsp; 
											&nbsp;<br/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
							
    </asp:Panel>	
    <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" Font-Size="9pt" enableviewstate="False"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>
    &nbsp;<br />
    <br />
	<table width="620">
		<tr>
			<td><asp:label id="lblPendientes" runat="server" CssClass="header">Actualizaciones Pendientes de Aplicar</asp:label></td>
			<td align="right"><asp:button id="btnAplicar" runat="server" Text="Aplicar Novedades" CausesValidation="False"></asp:button></td>
		</tr>
	</table>
	<br/>
    &nbsp;<uc3:ucGridNovPendientes ID="UcGridNovPendientes1" runat="server" />
</asp:Content>

