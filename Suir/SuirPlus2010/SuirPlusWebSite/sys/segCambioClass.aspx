<%@ Page Language="VB" MasterPageFile="~/SuirPlusNoAutenticado.master" AutoEventWireup="false" CodeFile="segCambioClass.aspx.vb" Inherits="sys_segCambioClass" Title="Cambio de CLASS" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
   
   
    <table id="Table2" cellspacing="1" cellpadding="1" align="center" border="0">
        <tr>
            <td>
                <table id="tblLoginUsuario" cellspacing="1" cellpadding="1" align="center" border="0" runat="server">
                    <tr>
                        <td>
                            <table id="Table1" cellspacing="0" cellpadding="0" width="330" border="0">
                                <tr>
                                    <td>
                                        <img height="1" alt="" src="../images/spacer.gif" width="38" border="0"></td>
                                    <td>
                                        <img height="1" alt="" src="../images/spacer.gif" width="251" border="0"></td>
                                    <td>
                                        <img height="1" alt="" src="../images/spacer.gif" width="41" border="0"></td>
                                    <td>
                                        <img height="1" alt="" src="../images/spacer.gif" width="1" border="0"></td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <img height="56" alt="" src="../images/SuirPLogin_r1_c1.gif" width="533" border="0"
                                            name="SuirPLogin_r1_c1"></td>
                                    <td>
                                        <img height="56" alt="" src="../images/spacer.gif" width="1" border="0"></td>
                                </tr>
                                <tr>
                                    <td valign="top" rowspan="2">
                                        <img height="94" alt="" src="../images/SuirPLogin_r2_c1.gif" width="38" border="0"
                                            name="SuirPLogin_r2_c1"></td>
                                    <td align="right">
                                        <table id="table7" cellspacing="1" width="100%" border="0">
                                            <tr>
                                                <td class="header" width="46%" colspan="2" style="text-align: center"><font size="4">Cambio de Class&nbsp;de 
																	Usuarios</font>&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="label" align="right" width="109" colspan="2" height="10"></td>
                                            </tr>
                                            <tr>
                                                <td>Usuario</td>
                                                <td style="text-align: left">
                                                    <asp:TextBox ID="txtUserName" runat="server" Width="128px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                                        ErrorMessage="Falta Usuario" ControlToValidate="txtUserName">*</asp:RequiredFieldValidator></td>
                                            </tr>
                                            <tr>
                                                <td>CLASS (anterior)&nbsp;</td>
                                                <td style="text-align: left">
                                                    <asp:TextBox ID="txtClassAnterior" runat="server" TextMode="Password" Width="128px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                                        ErrorMessage="Falta Class Anterior" ControlToValidate="txtClassAnterior">*</asp:RequiredFieldValidator></td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;</td>
                                                <td style="text-align: left">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td style="height: 35px">CLASS (nuevo)</td>
                                                <td style="text-align: left; height: 35px;">
                                                    <asp:TextBox ID="txtClassNuevo" runat="server" TextMode="Password"
                                                        Width="128px" MaxLength="22"></asp:TextBox>
                                                    <ajaxToolkit:PasswordStrength ID="PasswordStrength"
                                                        runat="server" TargetControlID="txtClassNuevo"
                                                        DisplayPosition="RightSide"
                                                        StrengthIndicatorType="Text"
                                                        PreferredPasswordLength="10"
                                                        PrefixText="Seguridad:"
                                                        HelpStatusLabelID="TextBox1_HelpLabel"
                                                        TextStrengthDescriptions="Muy débil; Débil; Regular; Buena; Excelente"
                                                        StrengthStyles="TextIndicator_TextBox1_Strength1;TextIndicator_TextBox1_Strength2;TextIndicator_TextBox1_Strength3;TextIndicator_TextBox1_Strength4;TextIndicator_TextBox1_Strength5"
                                                        MinimumNumericCharacters="0"
                                                        MinimumSymbolCharacters="0"
                                                        RequiresUpperAndLowerCaseCharacters="false" />
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Falta Class Nuevo" ControlToValidate="txtClassNuevo">*</asp:RequiredFieldValidator>
                                                    <br />

                                                </td>
                                            </tr>
                                            <tr>
                                                <td>CLASS (repetir)</td>
                                                <td style="text-align: left">
                                                    <asp:TextBox ID="txtClassRepetir" runat="server" TextMode="Password"
                                                        Width="128px" MaxLength="22"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                                                        ErrorMessage="Falta Repetir Class" ControlToValidate="txtClassRepetir">*</asp:RequiredFieldValidator></td>

                                            </tr>
                                            <tr>
                                              <%--  <td colspan="2" style="height: 18px;" align="center">
                                                    <recaptcha:recaptchacontrol
                                                        ID="recaptcha"
                                                        runat="server"
                                                        PublicKey="6Ld-od0SAAAAAL-7eV_JbD8brOewzWcL0AMig-ar"
                                                        PrivateKey="6Ld-od0SAAAAAPmNITxMyGFHybQxFmewdLICP0lF"
                                                        AllowMultipleInstances="True"
                                                        Theme="white" />
                                                </td>--%>
                                            </tr>

                                            <tr>
                                                <td align="center" colspan="2">
                                                    <font color="red">
                                                                <br />
                                                                <asp:Label ID="lblMensaje" runat="server" CssClass="error"></asp:Label>
                                                                <br />
																	<asp:button id="btLogin" runat="server" Text="Aceptar"></asp:button>&nbsp;&nbsp;&nbsp;&nbsp;
																	<asp:button id="Button1" runat="server" Text="Cancelar" CausesValidation="False"></asp:button>
                                                                <br />
                                                                </font>

                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 12px" align="left" colspan="2">
                                                    <asp:ValidationSummary ID="ValidationSummary0" runat="server" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" height="10">
                                                    <asp:ScriptManager EnableScriptGlobalization="True" ID="ScriptManager1" runat="server">
                                                    </asp:ScriptManager>
                                                </td>
                                            </tr>
                                        </table>
                                        &nbsp;&nbsp;&nbsp;</td>
                                    <td valign="top" rowspan="2">
                                        <img height="94" alt="" src="../images/SuirPLogin_r2_c3.gif" width="41" border="0"
                                            name="SuirPLogin_r2_c3"></td>
                                    <td>
                                        <img height="86" alt="" src="../images/spacer.gif" width="1" border="0"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <img height="8" alt="" src="../images/SuirPLogin_r2_c3.gif" width="251" border="0" name="SuirPLogin_r3_c2"></td>
                                    <td>
                                        <img height="8" alt="" src="../images/spacer.gif" width="1" border="0"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>


                <table id="tblRep" cellspacing="1" cellpadding="1" align="center" border="0" runat="server">

                    <tr>
                        <td>
                            <table id="Table3" cellspacing="0" cellpadding="0" width="330" border="0">
                                <tr>
                                    <td>
                                        <img height="1" alt="" src="../images/spacer.gif" width="38" border="0"></td>
                                    <td>
                                        <img height="1" alt="" src="../images/spacer.gif" width="251" border="0"></td>
                                    <td>
                                        <img height="1" alt="" src="../images/spacer.gif" width="41" border="0"></td>
                                    <td>
                                        <img height="1" alt="" src="../images/spacer.gif" width="1" border="0"></td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <img height="56" alt="" src="../images/SuirPLogin_r1_c1.gif" width="533" border="0"
                                            name="SuirPLogin_r1_c1"></td>
                                    <td>
                                        <img height="56" alt="" src="../images/spacer.gif" width="1" border="0"></td>
                                </tr>
                                <tr>
                                    <td valign="top" rowspan="2">
                                        <img height="94" alt="" src="../images/SuirPLogin_r2_c1.gif" width="38" border="0"
                                            name="SuirPLogin_r2_c1"></td>
                                    <td align="right">
                                        <table id="Table4" cellspacing="1" width="100%" border="0">
                                            <tr>
                                                <td class="header" width="46%" colspan="2" style="text-align: center"><font size="4">Cambio de Class 
																	de&nbsp;Representantes</font></td>
                                            </tr>
                                            <tr>
                                                <td align="right" width="109" colspan="2" height="10"></td>
                                            </tr>
                                            <tr>
                                                <td>RNC o Cédula</td>
                                                <td style="text-align: left">
                                                    <asp:TextBox ID="txtRncCedula" runat="server" Width="128px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                                                        ErrorMessage="Falta RNC o Cédula" ControlToValidate="txtRncCedula">*</asp:RequiredFieldValidator></td>
                                            </tr>
                                            <tr>
                                                <td>Cédula</td>
                                                <td style="text-align: left">
                                                    <asp:TextBox ID="txtRepresentante" runat="server" Width="128px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server"
                                                        ErrorMessage="Falta Cédula" ControlToValidate="txtRepresentante">*</asp:RequiredFieldValidator></td>
                                            </tr>
                                            <tr>
                                                <td>CLASS (anterior)&nbsp;</td>
                                                <td style="text-align: left">
                                                    <asp:TextBox ID="txtClassRepAnterior" runat="server" TextMode="Password" Width="128px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server"
                                                        ErrorMessage="Falta Class Anterior" ControlToValidate="txtClassRepAnterior">*</asp:RequiredFieldValidator></td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;</td>
                                                <td style="text-align: left">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>CLASS (nuevo)</td>
                                                <td style="text-align: left">
                                                    <asp:TextBox ID="txtClassRepNuevo" runat="server" TextMode="Password"
                                                        Width="128px" MaxLength="22"></asp:TextBox>
                                                    <ajaxToolkit:PasswordStrength ID="txtClassRepNuevo_PasswordStrength"
                                                        runat="server" TargetControlID="txtClassRepNuevo"
                                                        DisplayPosition="RightSide"
                                                        StrengthIndicatorType="Text"
                                                        PreferredPasswordLength="10"
                                                        PrefixText="Seguridad:"
                                                        HelpStatusLabelID="TextBox1_HelpLabel"
                                                        TextStrengthDescriptions="Muy débil; Débil; Regular; Buena; Excelente"
                                                        StrengthStyles="TextIndicator_TextBox1_Strength1;TextIndicator_TextBox1_Strength2;TextIndicator_TextBox1_Strength3;TextIndicator_TextBox1_Strength4;TextIndicator_TextBox1_Strength5"
                                                        MinimumNumericCharacters="0"
                                                        MinimumSymbolCharacters="0"
                                                        RequiresUpperAndLowerCaseCharacters="false" />
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server"
                                                        ErrorMessage="Falta Class Nuevo" ControlToValidate="txtClassRepNuevo">*</asp:RequiredFieldValidator></td>
                                            </tr>
                                            <tr>
                                                <td>CLASS (repetir)</td>
                                                <td style="text-align: left">
                                                    <asp:TextBox ID="txtClassRepRepetir" runat="server" TextMode="Password"
                                                        Width="128px" MaxLength="22"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server"
                                                        ErrorMessage="Falta Repetir Class" ControlToValidate="txtClassRepRepetir">*</asp:RequiredFieldValidator></td>

                                            </tr>
                                            <tr>
                                                <%--<td colspan="2" style="height: 18px;" align="center">
                                                    <recaptcha:recaptchacontrol
                                                        ID="recaptcha2"
                                                        runat="server"
                                                        PublicKey="6Ld-od0SAAAAAL-7eV_JbD8brOewzWcL0AMig-ar"
                                                        PrivateKey="6Ld-od0SAAAAAPmNITxMyGFHybQxFmewdLICP0lF"
                                                        AllowMultipleInstances="True"
                                                        Theme="white" />
                                                </td>--%>
                                            </tr>
                                            <tr>
                                                <td align="center" colspan="2">
                                                    <font color="red">
                                                                <br />
                                                                    <asp:Label ID="lblMensaje0" runat="server" CssClass="error"></asp:Label>
                                                                </font>
                                                    <br />
                                                    <asp:Button ID="btLoginRep" runat="server" Text="Aceptar"></asp:Button>&nbsp;&nbsp;&nbsp;&nbsp;
																<asp:Button ID="Button2" runat="server" Text="Cancelar" CausesValidation="False"></asp:Button></td>
                                            </tr>
                                            <tr>
                                                <td align="left" colspan="2">
                                                    <asp:ValidationSummary ID="ValidationSummary" runat="server" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" height="10"></td>
                                            </tr>
                                        </table>
                                        &nbsp;&nbsp;&nbsp;</td>
                                    <td valign="top" rowspan="2">
                                        <img height="94" alt="" src="../images/SuirPLogin_r2_c3.gif" width="41" border="0"
                                            name="SuirPLogin_r2_c3"></td>
                                    <td>
                                        <img height="86" alt="" src="../images/spacer.gif" width="1" border="0"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <img height="8" alt="" src="../images/SuirPLogin_r2_c3.gif" width="251" border="0" name="SuirPLogin_r3_c2"></td>
                                    <td>
                                        <img height="8" alt="" src="../images/spacer.gif" width="1" border="0"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                 <br>
                 <table id="tblMensajes" cellspacing="1" cellpadding="1" align="center" border="0" runat="server" width="500">
        <tr>
            <td align="center">
                <asp:Label ID="lblCambioMsg" runat="server" CssClass="error" ForeColor="Blue"></asp:Label>
                <asp:Label ID="lblError" runat="server" CssClass="error" Visible="False"></asp:Label>
                <asp:Label ID="lblMsg" runat="server" CssClass="error" ForeColor="Blue"></asp:Label>
            </td>
        </tr>
    </table>
            </td>
        </tr>
    </table>
    <br>
    <br>
    <br>
</asp:Content>

