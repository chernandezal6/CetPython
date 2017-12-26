<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="novBajas.aspx.vb" Inherits="Novedades_novBajas" title="Novedades - Salida Trabajadores" %>

<%@ Register Src="../Controles/ucGridNovPendientes.ascx" TagName="ucGridNovPendientes" TagPrefix="uc4" %>
<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc3" %>
<%@ Register Src="../Controles/UCCiudadano.ascx" TagName="UCCiudadano" TagPrefix="uc1" %>
<%@ Register Src="../Controles/UC_DatePicker.ascx" TagName="UC_DatePicker" TagPrefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
        <script language="vb" runat="server">
			Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
				
		        Me.RoleRequerido = 31
				
			End Sub
		</script>
        <uc3:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
    <table id="table4" width="620">
				<tr>
					<td valign="bottom"><asp:label id="lblTitulo1" runat="server" CssClass="header" EnableViewState="False">Salida de Trabajadores</asp:label></td>
					<td align="right"><asp:panel id="pnlPendiente" Runat="server" Visible="False">
							<table class="td-note" id="table5">
								<tr>
									<td class="subHeader">Tiene Novedades Pendientes</td>
								</tr>
							</table>
						</asp:panel></td>
				</tr>
			</table>
			<br />
			<table class="td-content" id="table1" runat="server" cellspacing="0" cellpadding="0" 
            width="700" border="0">
				<tr>
					<td class="error" align="left" colspan="2" height="7"></td>
				</tr>
				
				<tr>
					<td align="left" colspan="2">Nómina&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <asp:dropdownlist id="ddNomina" runat="server" CssClass="dropDowns" AutoPostBack="True"></asp:dropdownlist></td>
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
				<tr>
					<td align="right" colspan="2">
						<table id="table3" cellspacing="1" cellpadding="1" width="100%" border="0">
							<tr>
								<td style="WIDTH: 180px; text-align: left;">Fecha de Egreso</td>
								<td style="text-align: left">&nbsp;&nbsp;<uc2:uc_datepicker id="ucFechaEgresos" runat="server"></uc2:uc_datepicker></td>
							</tr>
							<tr>
								<td class="subHeader" colspan="2" style="HEIGHT: 30px; text-align: left;"><font color="red">&nbsp;Los 
										datos numéricos sin coma. Ej. 99999.99&nbsp;&nbsp; <a onclick="window.open('ayudanovedades.aspx', 'Argumento1', 'height: 450px; width: 590px; top: 200px;left: 300px;')"
											href="#"><img src="../images/help.gif" border="0" width="24" height="24" alt="" /></a> </font>
								</td>
							</tr>
							<tr>
								<td class="subHeader" colspan="2" style="text-align: left">&nbsp;- - - Aplicables al cálculo de aportes al 
									SDSS - - -</td>
							</tr>
							<tr>
								<td style="WIDTH: 180px; text-align: left;">Salario cotizable para la Seg. Social</td>
								<td style="text-align: left">
                                    &nbsp;<asp:textbox id="txtSalarioSS" runat="server" MaxLength="15"></asp:textbox>&nbsp;<font color="red">&nbsp;</font><a onclick="window.open('ayudasalario.aspx', 'Argumento1', 'height: 580px; width: 380px; top: 200px; left: 300px;')"
										href="#"><img src="../images/smallhelp.gif" border="0" width="18" height="18" alt="" /></a>
									<asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" CssClass="error" ErrorMessage="*" ControlToValidate="txtSalarioSS"></asp:requiredfieldvalidator><asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" CssClass="error" ErrorMessage="Formato Invalido"
										ControlToValidate="txtSalarioSS" ValidationExpression="\d*./?\d*"></asp:regularexpressionvalidator></td>
							</tr>
							<tr>
								<td style="WIDTH: 180px; text-align: left;">Aporte Voluntario Ordinario</td>
								<td style="text-align: left">
                                    &nbsp;<asp:textbox id="txtAporteVoluntario" runat="server" MaxLength="15"></asp:textbox>&nbsp;<font color="red">
										<asp:requiredfieldvalidator id="RequiredFieldValidator2" runat="server" CssClass="error" ErrorMessage="*" ControlToValidate="txtAporteVoluntario"></asp:requiredfieldvalidator></font><asp:regularexpressionvalidator id="RegularExpressionValidator2" runat="server" CssClass="error" ErrorMessage="Formato Invalido"
										ControlToValidate="txtAporteVoluntario" ValidationExpression="\d*./?\d*"></asp:regularexpressionvalidator></td>
							</tr>
							<tr>
								<td style="WIDTH: 180px; text-align: left;">Tipo de Remuneración</td>
								<td style="text-align: left">
                                    <asp:dropdownlist id="ddTipoIngreso" runat="server" CssClass="dropDowns" 
                    AutoPostBack="True" Enabled="True"></asp:dropdownlist></td>
							</tr>
							<tr>
								<td class="subHeader" colspan="2" style="text-align: left">&nbsp;- - - Aplicables al cálculo de retenciones 
									del ISR - - -</td>
							</tr>
							<tr>
								<td style="WIDTH: 180px; text-align: left;">Salario&nbsp; cotizable para el ISR</td>
								<td style="text-align: left">
                                    &nbsp;<asp:textbox id="txtSalarioISR" runat="server" MaxLength="15"></asp:textbox>&nbsp;<font color="#ff0000"><font color="red">*
											<asp:requiredfieldvalidator id="RequiredFieldValidator3" runat="server" CssClass="error" ErrorMessage="*" ControlToValidate="txtSalarioISR"></asp:requiredfieldvalidator></font></font><asp:regularexpressionvalidator id="RegularExpressionValidator3" runat="server" CssClass="error" ErrorMessage="Formato Invalido"
										ControlToValidate="txtSalarioISR" ValidationExpression="\d*./?\d*"></asp:regularexpressionvalidator><br />
									Nota: Si es igual al de Seg. Social puede dejar en cero.</td>
							</tr>
							
				            <tr>
						        <td class="subHeader" colspan="2" style="text-align: left">&nbsp;- - - Aplicables al cálculo de aportes al INFOTEP&nbsp;-&nbsp;- -</td>
					        </tr>
					        <tr>
						        <td style="width: 180px; text-align: left;" >Salario&nbsp; cotizable para el INFOTEP</td>
						        <td style="text-align: left">
                                    &nbsp;<asp:textbox id="txtSalarioINF" runat="server" MaxLength="15"></asp:textbox>&nbsp;<font color="#ff0000"><font color="red">*
									        <asp:requiredfieldvalidator id="RequiredFieldValidator7" runat="server" CssClass="error" ControlToValidate="txtSalarioISR"
										        ErrorMessage="*"></asp:requiredfieldvalidator></font></font><asp:regularexpressionvalidator id="RegularExpressionValidator8" runat="server" CssClass="error" ControlToValidate="txtSalarioINF"
								        ErrorMessage="Formato Inválido" ValidationExpression="^\d+(\.\d\d)?$"></asp:regularexpressionvalidator><br/>
							        Nota: Si es igual al de Seg. Social puede dejar en cero.</td>
					        </tr>			
							<tr>
								<td class="subHeader" colspan="2" style="text-align: left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <font color="red">
										Campos aplicables al periodo</font>
									<asp:label id="lblPeriodo" runat="server" font-Bold="True" ForeColor="Red"></asp:label></td>
							</tr>
							<tr>
								<td style="WIDTH: 180px; text-align: left;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Otras 
									remuneraciones</td>
								<td style="text-align: left">
                                    &nbsp;<asp:textbox id="txtOtrasRemuneraciones" runat="server" MaxLength="15"></asp:textbox>&nbsp;(Si 
									Aplica)&nbsp;<font color="red">
										<asp:requiredfieldvalidator id="RequiredFieldValidator4" runat="server" CssClass="error" ErrorMessage="*" ControlToValidate="txtOtrasRemuneraciones"></asp:requiredfieldvalidator></font><asp:regularexpressionvalidator id="RegularExpressionValidator4" runat="server" CssClass="error" ErrorMessage="Formato Invalido"
										ControlToValidate="txtOtrasRemuneraciones" ValidationExpression="\d*./?\d*"></asp:regularexpressionvalidator></td>
							</tr>
							<tr>
								<td style="WIDTH: 180px; text-align: left;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Saldo a Favor</td>
								<td style="text-align: left">
                                    &nbsp;<asp:textbox id="txtSaldoFavor" runat="server" MaxLength="15"></asp:textbox>&nbsp;(Si 
									Aplica)&nbsp;<font color="red">
										<asp:requiredfieldvalidator id="Requiredfieldvalidator6" runat="server" CssClass="error" ErrorMessage="*" ControlToValidate="txtSaldoFavor"></asp:requiredfieldvalidator></font><asp:regularexpressionvalidator id="Regularexpressionvalidator7" runat="server" CssClass="error" ErrorMessage="Formato Invalido"
										ControlToValidate="txtSaldoFavor" ValidationExpression="\d*./?\d*"></asp:regularexpressionvalidator></td>
							</tr>
							<tr>
								<td style="WIDTH: 180px; text-align: left;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Ingresos 
									Exentos ISR&nbsp;</td>
								<td style="text-align: left">
                                    &nbsp;<asp:textbox id="txtIngresoExento" runat="server" MaxLength="15"></asp:textbox>&nbsp;(Si 
									Aplica)&nbsp;<font color="red">
										<asp:requiredfieldvalidator id="Requiredfieldvalidator8" runat="server" CssClass="error" ErrorMessage="*" ControlToValidate="txtIngresoExento"></asp:requiredfieldvalidator></font><asp:regularexpressionvalidator id="Regularexpressionvalidator9" runat="server" CssClass="error" ErrorMessage="Formato Invalido"
										ControlToValidate="txtIngresoExento" ValidationExpression="\d*./?\d*"></asp:regularexpressionvalidator></td>
							</tr>
							<tr>
								<td style="WIDTH: 180px" colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td style="WIDTH: 180px; text-align: left;">RNC Agente de Retención Único</td>
								<td style="text-align: left">
                                    &nbsp;<asp:textbox id="txtAgenteRetencionISR" runat="server" MaxLength="11"></asp:textbox>&nbsp;(Si 
									Aplica)&nbsp;&nbsp;<asp:regularexpressionvalidator id="RegularExpressionValidator5" runat="server" CssClass="error" ErrorMessage="Formato Invalido"
										ControlToValidate="txtAgenteRetencionISR" ValidationExpression="\d*"></asp:regularexpressionvalidator></td>
							</tr>
							<tr>
								<td style="WIDTH: 180px; text-align: left;">Remuneración en otros empleadores</td>
								<td style="text-align: left">
                                    &nbsp;<asp:textbox id="txtRemuneracionesOtroEmp" runat="server" MaxLength="15"></asp:textbox>&nbsp;(Si 
									Aplica)&nbsp; <font color="red">
										<asp:requiredfieldvalidator id="Requiredfieldvalidator5" runat="server" CssClass="error" ErrorMessage="*" ControlToValidate="txtRemuneracionesOtroEmp"></asp:requiredfieldvalidator></font><asp:regularexpressionvalidator id="RegularExpressionValidator6" runat="server" CssClass="error" ErrorMessage="Formato Invalido"
										ControlToValidate="txtRemuneracionesOtroEmp" ValidationExpression="\d*./?\d*"></asp:regularexpressionvalidator></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<hr size="1" />
			</td>
				</tr>
				<tr>
					<td colspan="2">
						<table id="table2" width="100%">
							<tr>
								<td valign="top" align="left" width="60%">
									<font color="red">*</font>Información obligatoria.
								</td>
								<td align="right" width="40%"><asp:button id="btnAceptar" runat="server" Text="Insertar"></asp:button>&nbsp;
									<asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button>&nbsp; 
									&nbsp;<br />
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
    <asp:label id="lblMsg" runat="server" CssClass="error" EnableViewState="False"></asp:label>
			<br />
			<table id="table6" width="620">
				<tr>
					<td><asp:label id="lblPendientes" runat="server" CssClass="header">Bajas Pendientes de Aplicar</asp:label></td>
					<td align="right"><asp:button id="lbtnAplicar" runat="server" Text="Aplicar Novedades" CausesValidation="False"></asp:button></td>
				</tr>
			</table>
    <uc4:ucGridNovPendientes ID="UcGridNovPendientes1" runat="server" />
</asp:Content>