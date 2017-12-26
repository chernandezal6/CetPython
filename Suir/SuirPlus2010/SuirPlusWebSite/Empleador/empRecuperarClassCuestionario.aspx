<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="empRecuperarClassCuestionario.aspx.vb" Inherits="Empleador_empRecuperarClassCuestionario" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <table>
        <tr>
            <td>
                <fieldset style="width: 300px;">
                    <legend>Datos del Representante </legend>
                    <table cellspacing="1" width="300px" border="0" cellpadding="0">
                        <tr>
                            <td colspan="2">
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                RNC o Cédula
                            </td>
                            <td style="text-align: left">
                                <asp:TextBox ID="txtRncCedula" runat="server" Width="128px" MaxLength="11"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="Regularexpressionvalidator1" runat="server" Display="Dynamic"
                                    CssClass="error" ErrorMessage="RNC inválido" ValidationExpression="^(\d{9}|\d{11})$"
                                    ControlToValidate="txtRncCedula">*</asp:RegularExpressionValidator>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="El RNC o Cédula es requerido"
                                    ControlToValidate="txtRncCedula" Display="Dynamic">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                Cédula
                            </td>
                            <td style="text-align: left">
                                <asp:TextBox ID="txtCedulaRep" runat="server" Width="128px" MaxLength="11"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="regCedula" runat="server" Display="Dynamic" CssClass="error"
                                    ErrorMessage="Cédula inválida." ValidationExpression="^(\d{11})$" ControlToValidate="txtCedulaRep">*</asp:RegularExpressionValidator>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="La cédula del representante es requerida"
                                    ControlToValidate="txtCedulaRep" Display="Dynamic">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                                <br />
                                <asp:Button ID="btnAceptarRep" runat="server" Text="Aceptar"></asp:Button>&nbsp;&nbsp;
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
                            <td colspan="2">
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </td>
            <td>
                <table id="tblInfoRepresentante" runat="server" visible="false">
                    <tr>
                        <td align="right">Representante:</td>
                        <td>
                            <asp:Label ID="lblRepresentante" runat="server" CssClass="labelData"></asp:Label><br />
                        </td>
                    </tr>
                    <tr>
                        <td align="right">Razón Social:</td>
                        <td>
                            <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label><br />
                        </td>
                    </tr>
                    <tr>
                        <td align="right">Nombre Comercial:</td>
                        <td>
                            <asp:Label ID="lblNombreComercial" runat="server" CssClass="labelData"></asp:Label><br />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    
    <div>
        <asp:Label ID="lblMensaje" runat="server" CssClass="error"></asp:Label>
    </div>
    <br />
    <br />
    <asp:Panel ID="pnlCuestionario" runat="server" Visible="false">
        <fieldset style="width: 400px" >
            <legend>
                    Custionario para recuperación de class
            </legend>
            <asp:DataList ID="dlCuestionario" runat="server" RepeatColumns="0">
                <ItemTemplate>
                    <table cellpadding="0" cellspacing="0">
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label runat="server" Text='<%# eval("ID_PREGUNTA")%>' ID="lblId" Visible="false"></asp:Label>
                                <asp:Label runat="server" Text='<%# eval("PREGUNTA_DES") %>' ID="lblPregunta" 
                                    CssClass="labelData" Font-Bold="True" Font-Size="10pt"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox ID="txtRespuesta" runat="server" Width="200px"></asp:TextBox>
                                <asp:LinkButton ID="lnkBtnSi" runat="server" Visible="false" Enabled="false">
                                                    <img src='../images/ok.gif' alt=''/></asp:LinkButton>
                                <asp:LinkButton ID="lnkBtnNo" runat="server" Visible="false" Enabled="false">
                                                    <img src='../images/error.gif' alt=''/></asp:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" Text='<%# eval("COMENTARIO") %>' ID="lblComentario" 
                                    Width="200px" Font-Italic="True"></asp:Label>
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>
                </ItemTemplate>
                <FooterTemplate><br />                
               <div align="right">
                <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" CommandName="A" />&nbsp;
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CommandName="C" CausesValidation="False" />
               </div>
                </FooterTemplate>
            </asp:DataList>

                            

        </fieldset>
    </asp:Panel>
    <br />
    <br />
    <asp:Panel ID="pnlEmailRegistrado" runat="server" Visible="false">
        <fieldset style="width: 400px;">
            <legend>Enviar email con un nuevo class temporal</legend>
            <table>
                <tr>
                    <td style="text-align: right">
                        Email Registrado
                    </td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtEmailRep" runat="server" Width="200px"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="El email del representante registrado en TSS es requerido"
                            Display="Dynamic" ControlToValidate="txtEmailRep">*</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtEmailRep"
                            ErrorMessage="Correo electrónico erróneo." ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                            Display="Dynamic">*
                        </asp:RegularExpressionValidator>
                        &nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: right">
                        <asp:Button ID="btnAceptarEmail" runat="server" Text="Aceptar" />
                        &nbsp;<asp:Button ID="btnCancelarEmail" runat="server" Text="Cancelar" CausesValidation="False"/>
                    </td>
                </tr>
            </table>
            <asp:Label ID="lblMsg" runat="server" CssClass="error"></asp:Label>
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
        </fieldset>
    </asp:Panel>

</asp:Content>

