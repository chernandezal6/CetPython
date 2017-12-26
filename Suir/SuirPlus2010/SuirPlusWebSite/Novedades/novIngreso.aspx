<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="novIngreso.aspx.vb" Inherits="Novedades_novIngreso" Title="Novedades - Ingreso Trabajadores" %>

<%@ Register Src="../Controles/ucGridNovPendientes.ascx" TagName="ucGridNovPendientes" TagPrefix="uc4" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc1" %>
<%@ Register Src="../Controles/UCCiudadano.ascx" TagName="UCCiudadano" TagPrefix="uc2" %>
<%@ Register Src="../Controles/UC_DatePicker.ascx" TagName="UC_DatePicker" TagPrefix="uc3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script language="vb" runat="server">
        Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
            Me.RoleRequerido = 31
        End Sub
    </script>
    <uc1:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
    <table id="Table4" style="width: 620px">
        <tr>
            <td valign="bottom" style="width: 257px">
                <asp:Label ID="lblTitulo1" runat="server" CssClass="header">Ingreso de Trabajadores</asp:Label></td>
            <td style="text-align: right">
                <asp:Panel ID="pnlPendiente" runat="server" Visible="False">
                    <table class="td-note" id="Table5">
                        <tr>
                            <td class="subHeader">Tiene Novedades Pendientes</td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
    </table>
    <br />

    <table class="td-content" id="Table1" runat="server" cellspacing="0" cellpadding="0"
        border="0" width="700">
        <tr>
            <td class="error" align="left" colspan="2" height="7"></td>
        </tr>

        <tr>
            <td align="left" abbr="left" colspan="2">Nómina&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:DropDownList ID="ddNomina" runat="server" CssClass="dropDowns" AutoPostBack="True"></asp:DropDownList></td>
        </tr>
        <tr>
            <td align="left" colspan="2">&nbsp; </td>
        </tr>
        <tr>
            <td align="right"></td>
            <td class="subHeader">&nbsp;</td>
        </tr>
        <tr>
            <td style="HEIGHT: 16px" align="right">&nbsp;</td>
            <td class="subHeader" style="HEIGHT: 16px">Nuevo Empleado</td>
        </tr>
        <tr>
            <td align="right"></td>
            <td>
                <uc2:UCCiudadano ID="ucEmpleado" runat="server"></uc2:UCCiudadano>
            </td>
        </tr>
        <tr>
            <td align="right"></td>
            <td class="error">&nbsp;</td>
        </tr>
        <tr>
            <td align="left" colspan="2">
                <table id="Table3" cellspacing="1" cellpadding="1" border="0" width="100%">
                    <tr>
                        <td style="width: 210px">Fecha de Ingreso</td>
                        <td>&nbsp;<uc3:UC_DatePicker ID="ucFechaIngreso" runat="server"></uc3:UC_DatePicker>
                        </td>
                    </tr>
                    <tr>
                        <td class="subHeader" style="HEIGHT: 23px" colspan="2"><font color="red">&nbsp;Los 
								datos numéricos sin coma. Ej. 99999.99&nbsp;&nbsp; <a onclick="window.open('ayudanovedades.aspx', 'Argumento1', 'height: 450px; width: 590px; top: 200px; left: 300px;')"
									href="#"><img src="../images/help.gif" border="0" width="24" height="24" alt=""/></a>
							</font>
                        </td>
                    </tr>
                    <tr>
                        <td class="subHeader" colspan="2">&nbsp;- - - Aplicables al cálculo de aportes al 
							SDSS - - -</td>
                    </tr>
                    <tr>
                        <td style="width: 210px">Salario cotizable para la Seg. Social</td>
                        <td style="text-align: left">&nbsp;<asp:TextBox ID="txtSalarioSS" runat="server" MaxLength="15"></asp:TextBox>&nbsp;<font color="red">&nbsp;</font><a onclick="window.open('ayudasalario.aspx', 'Argumento1', 'height: 580px; width: 380px; top: 200px; left: 300px;')"
                            href="#"><img src="../images/smallhelp.gif" border="0" width="18" height="18" alt="" /></a>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="error" ControlToValidate="txtSalarioSS"
                                ErrorMessage="*"></asp:RequiredFieldValidator><asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" CssClass="error" ControlToValidate="txtSalarioSS"
                                    ErrorMessage="Formato Inválido" ValidationExpression="^\d+(\.\d\d)?$"></asp:RegularExpressionValidator></td>
                    </tr>
                    <tr>
                        <td style="width: 210px">Aporte Voluntario Ordinario</td>
                        <td style="text-align: left">&nbsp;<asp:TextBox ID="txtAporteVoluntario" runat="server" MaxLength="15"></asp:TextBox>&nbsp;<font color="red">
								<asp:requiredfieldvalidator id="RequiredFieldValidator2" runat="server" CssClass="error" ControlToValidate="txtAporteVoluntario"
									ErrorMessage="*"></asp:requiredfieldvalidator></font><asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" CssClass="error" ControlToValidate="txtAporteVoluntario"
                                        ErrorMessage="Formato Inválido" ValidationExpression="^\d+(\.\d\d)?$"></asp:RegularExpressionValidator></td>
                    </tr>
                    <tr>
                        <td style="width: 210px">Tipo de Ingreso</td>
                        <td style="text-align: left">
                            <asp:DropDownList ID="ddTipoIngreso" runat="server" CssClass="dropDowns"
                                AutoPostBack="True" Enabled="True">
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td class="subHeader" colspan="2">&nbsp;- - - Aplicables al cálculo de retenciones 
							del ISR&nbsp;-&nbsp;- -</td>
                    </tr>
                    <tr>
                        <td style="width: 210px">Salario&nbsp; cotizable para el ISR</td>
                        <td style="text-align: left">&nbsp;<asp:TextBox ID="txtSalarioISR" runat="server" MaxLength="15"></asp:TextBox>&nbsp;<font color="#ff0000"><font color="red">*
									<asp:requiredfieldvalidator id="RequiredFieldValidator3" runat="server" CssClass="error" ControlToValidate="txtSalarioISR"
										ErrorMessage="*"></asp:requiredfieldvalidator></font></font><asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" CssClass="error" ControlToValidate="txtSalarioISR"
                                            ErrorMessage="Formato Inválido" ValidationExpression="^\d+(\.\d\d)?$"></asp:RegularExpressionValidator><br />
                            Nota: Si es igual al de Seg. Social puede dejar en cero.</td>
                    </tr>


                    <tr>
                        <td class="subHeader" colspan="2">&nbsp;- - - Aplicables al cálculo de aportes al INFOTEP&nbsp;-&nbsp;- -</td>
                    </tr>
                    <tr>
                        <td style="width: 210px">Salario&nbsp; cotizable para el INFOTEP</td>
                        <td style="text-align: left">&nbsp;<asp:TextBox ID="txtSalarioINF" runat="server" MaxLength="15"></asp:TextBox>&nbsp;<font color="#ff0000"><font color="red">*
									<asp:requiredfieldvalidator id="RequiredFieldValidator7" runat="server" CssClass="error" ControlToValidate="txtSalarioISR"
										ErrorMessage="*"></asp:requiredfieldvalidator></font></font><asp:RegularExpressionValidator ID="RegularExpressionValidator8" runat="server" CssClass="error" ControlToValidate="txtSalarioINF"
                                            ErrorMessage="Formato Inválido" ValidationExpression="^\d+(\.\d\d)?$"></asp:RegularExpressionValidator><br />
                            Nota: Si es igual al de Seg. Social puede dejar en cero.</td>
                    </tr>

                    <tr>
                        <td class="subHeader" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <font color="red">
								Campos aplicables al periodo</font>
                            <asp:Label ID="lblPeriodo" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label></td>
                    </tr>
                    <tr>
                        <td style="width: 210px; height: 20px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Otras 
							remuneraciones</td>
                        <td style="text-align: left; height: 20px;">&nbsp;<asp:TextBox ID="txtOtrasRemuneraciones" runat="server" MaxLength="15"></asp:TextBox>&nbsp;(Si 
							Aplica)&nbsp;<font color="red">
								<asp:requiredfieldvalidator id="RequiredFieldValidator4" runat="server" CssClass="error" ControlToValidate="txtOtrasRemuneraciones"
									ErrorMessage="*"></asp:requiredfieldvalidator></font><asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" CssClass="error" ControlToValidate="txtOtrasRemuneraciones"
                                        ErrorMessage="Formato Inválido" ValidationExpression="^\d+(\.\d\d)?$"></asp:RegularExpressionValidator></td>
                    </tr>
                    <tr>
                        <td style="width: 210px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Saldo a Favor</td>
                        <td style="text-align: left">&nbsp;<asp:TextBox ID="txtSaldoFavor" runat="server" MaxLength="15"></asp:TextBox>&nbsp;(Si 
							Aplica)&nbsp;<font color="red">
								<asp:requiredfieldvalidator id="Requiredfieldvalidator6" runat="server" CssClass="error" ControlToValidate="txtSaldoFavor"
									ErrorMessage="*"></asp:requiredfieldvalidator></font><asp:RegularExpressionValidator ID="Regularexpressionvalidator7" runat="server" CssClass="error" ControlToValidate="txtSaldoFavor"
                                        ErrorMessage="Formato Inválido" ValidationExpression="^\d+(\.\d\d)?$"></asp:RegularExpressionValidator></td>
                    </tr>
                    <tr>
                        <td style="width: 210px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Ingresos 
							Exentos ISR&nbsp;</td>
                        <td style="text-align: left">&nbsp;<asp:TextBox ID="txtIngresoExento" runat="server" MaxLength="15"></asp:TextBox>&nbsp;(Si 
							Aplica)&nbsp;<font color="red">
								<asp:requiredfieldvalidator id="Requiredfieldvalidator8" runat="server" CssClass="error" ControlToValidate="txtIngresoExento"
									ErrorMessage="*"></asp:requiredfieldvalidator></font><asp:RegularExpressionValidator ID="Regularexpressionvalidator9" runat="server" CssClass="error" ControlToValidate="txtIngresoExento"
                                        ErrorMessage="Formato Inválido" ValidationExpression="^\d+(\.\d\d)?$"></asp:RegularExpressionValidator></td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="width: 210px">RNC Agente de Retención Único</td>
                        <td style="text-align: left">&nbsp;<asp:TextBox ID="txtAgenteRetencionISR" runat="server" MaxLength="11"></asp:TextBox>&nbsp;(Si 
							Aplica)&nbsp;&nbsp;<asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" CssClass="error" ControlToValidate="txtAgenteRetencionISR"
                                ErrorMessage="Formato Inválido" ValidationExpression="\d*"></asp:RegularExpressionValidator></td>
                    </tr>
                    <tr>
                        <td style="width: 210px">Remuneración en otros empleadores</td>
                        <td style="text-align: left">&nbsp;<asp:TextBox ID="txtRemuneracionesOtroEmp" runat="server" MaxLength="15"></asp:TextBox>&nbsp;(Si 
							Aplica)&nbsp; <font color="red">
								<asp:requiredfieldvalidator id="Requiredfieldvalidator5" runat="server" CssClass="error" ControlToValidate="txtRemuneracionesOtroEmp"
									ErrorMessage="*"></asp:requiredfieldvalidator></font>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator6" runat="server" CssClass="error" ControlToValidate="txtRemuneracionesOtroEmp"
                                ErrorMessage="Formato Inválido" ValidationExpression="^\d+(\.\d\d)?$"></asp:RegularExpressionValidator></td>
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
                <table width="100%" id="Table2">
                    <tr>
                        <td valign="top" align="left" width="60%">
                            <font color="red">*</font>Información obligatoria.
                        </td>
                        <td align="right">
                            <asp:Button ID="btnAceptar" runat="server" Text="Insertar"></asp:Button>&nbsp;
							<asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:Button>&nbsp; 
							&nbsp;<br />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:Label ID="lblMsg" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
    <br />
    <table id="Table6" width="620">
        <tr>
            <td>
                <asp:Label ID="lblPendientes" runat="server" CssClass="header">Ingresos Pendientes de Aplicar</asp:Label></td>
            <td align="right">
                <asp:Button ID="btnAplicar" runat="server" Text="Aplicar Novedades" CausesValidation="False"></asp:Button></td>
        </tr>
    </table>

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<br />
    <uc4:ucGridNovPendientes ID="UcGridNovPendientes1" runat="server" />
</asp:Content>
