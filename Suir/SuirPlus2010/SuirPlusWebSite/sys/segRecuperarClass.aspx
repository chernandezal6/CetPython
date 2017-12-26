<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusNoAutenticado.master" AutoEventWireup="false"
    CodeFile="segRecuperarClass.aspx.vb" Inherits="sys_segRecuperarClass" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <table id="table2" cellspacing="1" cellpadding="1" align="center" border="0">
        <tr>
            <td>
                <table id="tblLoginUsuario" cellspacing="1" cellpadding="1" align="center" border="0"
                    runat="server">
                    <tr>
                        <td>
                            <table id="table1" cellspacing="0" cellpadding="0" width="330" border="0">
                                <tr>
                                    <td>
                                        <img height="1" alt="" src="../images/spacer.gif" width="38" border="0">
                                    </td>
                                    <td>
                                        <img height="1" alt="" src="../images/spacer.gif" width="251" border="0">
                                    </td>
                                    <td>
                                        <img height="1" alt="" src="../images/spacer.gif" width="41" border="0">
                                    </td>
                                    <td>
                                        <img height="1" alt="" src="../images/spacer.gif" width="1" border="0">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <img height="56" alt="" src="../images/SuirPLogin_r1_c1.gif" width="533" border="0"
                                            name="SuirPLogin_r1_c1">
                                    </td>
                                    <td>
                                        <img height="56" alt="" src="../images/spacer.gif" width="1" border="0">
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" rowspan="2">
                                        <img height="94" alt="" src="../images/SuirPLogin_r2_c1.gif" width="38" border="0"
                                            name="SuirPLogin_r2_c1">
                                    </td>
                                    <td align="right">
                                        <table id="table7" cellspacing="1" width="100%" border="0">
                                            <tr>
                                                <td class="header" width="46%" colspan="2" style="text-align: center">
                                                    <font size="4">Recuperar Class de Usuarios</font>&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label" align="right" width="109" colspan="2" height="10">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: right">
                                                    Usuario
                                                </td>
                                                <td style="text-align: left">
                                                    <asp:TextBox ID="txtUsuario" runat="server" Width="128px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="El usuario es requerido"
                                                        ControlToValidate="txtUsuario">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: right">
                                                    Email Registrado
                                                </td>
                                                <td style="text-align: left">
                                                    <asp:TextBox ID="txtEmailUsuario" runat="server" Width="128px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="El email del usuario registrado en TSS es requerido"
                                                        ControlToValidate="txtEmailUsuario">*</asp:RequiredFieldValidator>
                                                     <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmailUsuario"
                                                        ErrorMessage="Correo electrónico erróneo." SetFocusOnError="True" 
                                                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                                                        Display="Dynamic">*
                                                     </asp:RegularExpressionValidator>
                                                </td>
                                            </tr>                                         
    
                                            <tr>
                                                <td align="center" colspan="2">
                                                    <font color="red">
                                                        <br />
                                                        <asp:Label ID="lblMensaje" runat="server" CssClass="error"></asp:Label>
                                                        <br />
                                                        <br/>
                                                        <asp:Button ID="btLogin" runat="server" Text="Aceptar"></asp:Button>&nbsp;&nbsp;&nbsp;&nbsp;
                                                        <asp:Button ID="btnCancelarUsr" runat="server" Text="Cancelar" CausesValidation="False">
                                                        </asp:Button></font>
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
                                        &nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td valign="top" rowspan="2">
                                        <img height="94" alt="" src="../images/SuirPLogin_r2_c3.gif" width="41" border="0"
                                            name="SuirPLogin_r2_c3" />
                                    </td>
                                    <td>
                                        <img height="86" alt="" src="../images/spacer.gif" width="1" border="0" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <img height="8" alt="" src="../images/SuirPLogin_r2_c3.gif" width="251" border="0"
                                            name="SuirPLogin_r3_c2"/>
                                    </td>
                                    <td>
                                        <img height="8" alt="" src="../images/spacer.gif" width="1" border="0"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <table id="tblRep" cellspacing="1" cellpadding="1" align="center" border="0" runat="server">
                    <tr>
                        <td>
                            <table id="table3" cellspacing="0" cellpadding="0" width="330" border="0">
                                <tr>
                                    <td>
                                        <img height="1" alt="" src="../images/spacer.gif" width="38" border="0"/>
                                    </td>
                                    <td>
                                        <img height="1" alt="" src="../images/spacer.gif" width="251" border="0"/>
                                    </td>
                                    <td>
                                        <img height="1" alt="" src="../images/spacer.gif" width="41" border="0"/>
                                    </td>
                                    <td>
                                        <img height="1" alt="" src="../images/spacer.gif" width="1" border="0"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <img height="56" alt="" src="../images/SuirPLogin_r1_c1.gif" width="533" border="0"
                                            name="SuirPLogin_r1_c1"/>
                                    </td>
                                    <td>
                                        <img height="56" alt="" src="../images/spacer.gif" width="1" border="0"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" rowspan="2">
                                        <img height="94" alt="" src="../images/SuirPLogin_r2_c1.gif" width="38" border="0"
                                            name="SuirPLogin_r2_c1"/>
                                    </td>
                                    <td align="right">
                                        <table id="table4" cellspacing="1" width="100%" border="0">
                                            <tr>
                                                <td class="header" width="46%" colspan="2" style="text-align: center">
                                                    <font size="4">Recuperar Class de Representantes</font>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right" width="109" colspan="2" height="10">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: right">
                                                    RNC o Cédula
                                                </td>
                                                <td style="text-align: left">
                                                    <asp:TextBox ID="txtRncCedula" runat="server" Width="128px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="El RNC o Cédula es requerido"
                                                        ControlToValidate="txtRncCedula">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: right">
                                                    Cédula
                                                </td>
                                                <td style="text-align: left">
                                                    <asp:TextBox ID="txtCedulaRep" runat="server" Width="128px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="La cédula del representante es requerida"
                                                        ControlToValidate="txtCedulaRep">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: right">
                                                    Email Registrado
                                                </td>
                                                <td style="text-align: left">
                                                    <asp:TextBox ID="txtEmailRep" runat="server" Width="128px"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="El email del representante registrado en TSS es requerido"
                                                        ControlToValidate="txtEmailRep">*</asp:RequiredFieldValidator>
                                                     <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtEmailRep"
                                                        ErrorMessage="Correo electrónico erróneo." SetFocusOnError="True" 
                                                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                                                        Display="Dynamic">*
                                                     </asp:RegularExpressionValidator>
                                                </td>
                                            </tr>                                                                            
    
                                            <tr>
                                                <td align="center" colspan="2">
                                                    <font color="red">
                                                        <br />
                                                        <asp:Label ID="lblMensaje0" runat="server" CssClass="error"></asp:Label>
                                                    <br />
                                                    </font>
                                                    <br />
                                                    <asp:Button ID="btLoginRep" runat="server" Text="Aceptar"></asp:Button>&nbsp;&nbsp;&nbsp;&nbsp;
                                                    <asp:Button ID="btnCancelarRep" runat="server" Text="Cancelar" CausesValidation="False">
                                                    </asp:Button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" colspan="2">
                                                    <asp:ValidationSummary ID="ValidationSummary" runat="server" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" height="10">
                                                </td>
                                            </tr>
                                        </table>
                                        &nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td valign="top" rowspan="2">
                                        <img height="94" alt="" src="../images/SuirPLogin_r2_c3.gif" width="41" border="0"
                                            name="SuirPLogin_r2_c3"/>
                                    </td>
                                    <td>
                                        <img height="86" alt="" src="../images/spacer.gif" width="1" border="0"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <img height="8" alt="" src="../images/SuirPLogin_r2_c3.gif" width="251" border="0"
                                            name="SuirPLogin_r3_c2"/>
                                    </td>
                                    <td>
                                        <img height="8" alt="" src="../images/spacer.gif" width="1" border="0"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
        <td align="center">
        <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="error"></asp:Label>
        </td>
        </tr>
    </table>
    <br/>
    <br/>   
</asp:Content>
