<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucCuentaBancaria.ascx.vb" Inherits="Controles_ucCuentaBancaria" %>
       <div id="divActualizarCuenta" runat="server" style="FLOAT: left; WIDTH: 485px; MARGIN-RIGHT: 10px" >

   
    <fieldset id="fsCuentaBancaria" runat="server">
        <legend>Cuenta Bancaria</legend>
                <br />
                <asp:MultiView ID="mvNuevaCuenta" runat="server">
                    <asp:View ID="vwNuevaCuenta" runat="server">
                        <table>
                            <tr>
                                <td colspan="2">
                                <div ID="divCuentaBancariaActual" runat="server" style="FLOAT: left; WIDTH: 442px; MARGIN-RIGHT: 10px" visible="true">
                                    <br />
                                        <table cellpadding="1" cellspacing="0" class="td-content" width="400">
                                            <tr>
                                                <td >
                                                    <br />
                                                    Banco Múltiple</td>
                                                <td>
                                                    <br />
                                                    <asp:DropDownList ID="ddlEntidadRecaudadora"  runat="server" 
                                                        AutoPostBack="True" CssClass="dropDowns"  Width="215px" >
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                                                        ControlToValidate="ddlEntidadRecaudadora" 
                                                        ErrorMessage="Debe seleccionar un Banco Múltiple!!" Font-Bold="True" 
                                                        InitialValue="0">*</asp:RequiredFieldValidator>
                                                </td>
                                                <td>
                                                    <br />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td >
                                                    RNC/Cédula Titular de Cuenta</td>
                                                <td>
                                                    <asp:TextBox ID="txtRNCoCedulaTitular" runat="server" CssClass="input" 
                                                        Width="163px"></asp:TextBox>
                                                    &nbsp;
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                                        ControlToValidate="txtRNCoCedulaTitular" 
                                                        ErrorMessage="La cédula del titular es requerida" Font-Bold="True">*</asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                                                        ControlToValidate="txtRNCoCedulaTitular" Display="Dynamic" 
                                                        ErrorMessage="Formato de cédula o RNC inválido" 
                                                        ValidationExpression="^(\d{11}|\d{9})$">*</asp:RegularExpressionValidator>
                                                </td>
                                                <td>
                                                    &nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Nro de Cuenta</td>
                                                <td>
                                                    <asp:Label ID="lblPrefijo" runat="server"></asp:Label>
                                                    <asp:TextBox ID="txtNumeroCuenta" runat="server" CssClass="input" 
                                                        MaxLength="20" Width="163px"></asp:TextBox>
                                                    &nbsp;
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                                                        ControlToValidate="txtNumeroCuenta" 
                                                        ErrorMessage="El número de cuenta es requerido" Font-Bold="True">*</asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="regexNumber" runat="server" 
                                                        ControlToValidate="txtNumeroCuenta" Display="Dynamic" 
                                                        ErrorMessage="Formato de cuenta inválido" ValidationExpression="^[0-9]+$">*</asp:RegularExpressionValidator>
                                                </td>
                                                <td>
                                                    &nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Confirmar Nro de Cuenta</td>
                                                <td>
                                                    <asp:Label ID="lblPrefijo0" runat="server"></asp:Label>
                                                   <asp:TextBox ID="txtNumeroCuenta2" runat="server" MaxLength="20" CssClass="input nocopy" 
                                                         Width="163px"></asp:TextBox>
                                                    &nbsp;
                                                    <asp:CompareValidator ID="CompareValidator1" runat="server" 
                                                        ControlToCompare="txtNumeroCuenta" ControlToValidate="txtNumeroCuenta2" 
                                                        Display="Dynamic" 
                                                        ErrorMessage="La cuenta de confirmación no coincide con el número de cuenta digitado">*</asp:CompareValidator>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                                                        ControlToValidate="txtNumeroCuenta2" 
                                                        ErrorMessage="La confirmación de la cédula es requerida" Font-Bold="True">*</asp:RequiredFieldValidator>
                                                </td>
                                                <td>
                                                    &nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Tipo de Cuenta</td>
                                                <td>
                                                    <asp:DropDownList ID="ddTipo_Cuentas" runat="server" 
                                                        CssClass="dropDowns" Width="215px">
                                                        <asp:ListItem Value="2">Cuenta de Ahorro</asp:ListItem>
                                                        <asp:ListItem Value="1">Cuenta Corriente</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    &nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td align="center" colspan="2">
                                                    &nbsp;</td>
                                                <td>
                                                    &nbsp;</td>
                                            </tr>
                                        </table>
                                        <br />
                                    </div>
                                    
                                    <br />
                                    
                                </td>
                            </tr>
                             <tr>
                                <td style="text-align:left" colspan="2">
                                    <asp:Label ID="lblMensaje" runat="server" CssClass="error" 
                                        EnableViewState="False"></asp:Label>
                                 </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" Font-Bold="True" 
                                        HeaderText="Por favor revisar los siguientes errores:" />
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td class="style1" width="300">
                                    <asp:Button ID="btnCancelar0" runat="server" CausesValidation="False" 
                                        Text="Cancelar" />
                                </td>
                                <td width="100">
                                    <asp:Button  ID="btnActualizarCuenta" runat="server" Text="Actualizar" />
                                </td>
                            </tr>
                           
                        </table>
                    </asp:View>
                    <asp:View ID="vwConfirmacion" runat="server">
                        <table>
                        <tr>
                        <td >
                        <table>
                            <tr>
                                <td colspan="2" class="subHeader">
                                    <br />
                                    Por favor confirme los datos de la cuenta:<br />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" class="label-Resaltado">
                                    <br />
                                    <table cellpadding="1" cellspacing="0" class="td-content" width="400" 
                                        align="left">
                                        <tr>
                                            <td class="style3">
                                                <span style="font-weight: normal">
                                                <br />
                                                Banco Múltiple</span></td>
                                            <td style="margin-left: 40px" align="left">
                                                <br />
                                                <asp:Label ID="lblIdEntidadRecaudadora" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style3">
                                                <span style="font-weight: normal">Titular de Cuenta</span></td>
                                            <td>
                                                <asp:Label ID="lblRNCoCedulaDuenoCuenta" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style3">
                                                <span style="font-weight: normal">Nro de Cuenta</span></td>
                                            <td>
                                                <asp:Label ID="lblNroCuenta" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Tipo de Cuenta</td>
                                            <td>
                                                <asp:Label ID="lblTipoCuenta" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style3">
                                                &nbsp;</td>
                                            <td>
                                                &nbsp;</td>
                                        </tr>
                                    </table>
                        
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left" class="style2">
                                    <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" />
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                </td>
                                <td>
                                    <asp:Button ID="btnConfirmar" runat="server" Text="Confirmar" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <br />
                                    <br />
                                </td>
                            </tr>
                        </table>
                                                    </td>
                            </tr>
                         </table>
                    </asp:View>
                    <br />
                </asp:MultiView>
        </fieldset>              
     </div>
     
