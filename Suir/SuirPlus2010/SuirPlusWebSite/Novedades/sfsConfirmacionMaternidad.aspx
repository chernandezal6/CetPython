<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsConfirmacionMaternidad.aspx.vb" Inherits="Novedades_sfsConfirmacionMaternidad" title="Confirmacion Solicitud Maternidad" %>
<%@ Register src="../Controles/ucGridNovPendientes.ascx" tagname="ucGridNovPendientes" tagprefix="uc2" %>
<%@ Register src="../Controles/ucInfoEmpleado.ascx" tagname="ucInfoEmpleado" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent"  Runat="Server">
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
   <ContentTemplate>
   
    <fieldset style="width: 585px; margin-left: 60px">
        </span>
       <legend class="header" style="font-size: 14px; font-weight: normal;">Confirmar los 
           datos de la Solicitud </legend>
       <br />
            <table style="width: 100%">
                <tr>
                    <td>
                        <table cellpadding="0" cellspacing="0" style="margin-left: 17px" width="93%">
                            <tr>
                                <td>
                                    <br />
                                    <uc1:ucInfoEmpleado ID="ucInfoEmpleado1" runat="server" />
                                    <br />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table class="td-content" style="margin-left:17px;">
                            <tr>
                                <td colspan="2" style="text-align: left;">
                                    <span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">
                                    Maternidad Reportada</span>&nbsp;</td>
                            </tr>
                            <tr>
                                <td style="width: 141px; text-align: right;">
                                    <span style="font-weight: normal">Fecha de diagnóstico:</span></td>
                                <td>
                                    <asp:Label ID="lblFechaDiagnostico" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 141px; text-align: right;">
                                    <span style="margin-left: 12px; font-weight: normal;">Fecha estimada parto:</span></td>
                                <td>
                                    <asp:Label ID="lblFechaEstimadaParto" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 141px; text-align: right;">
                                    <span style="font-weight: normal">Empresa <span style="font-weight: normal">
                                    Reportó </span>Embarazo:</span>
                                </td>
                                <td>
                                    <asp:Label ID="lblEmprezaReporteEmbarazo" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 141px; text-align: right;">
                                    <span style="font-weight: normal">RNC Reportó Embarazo: </span>
                                </td>
                                <td>
                                    <asp:Label ID="lblRNC" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 141px; text-align: right;">
                                    <span style="margin-left: 12px; font-weight: normal;">Teléfono:</span></td>
                                <td>
                                    <asp:Label ID="lblTelefono" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 141px; text-align: right;">
                                    <span style="margin-left: 12px; font-weight: normal;">Celular:</span></td>
                                <td>
                                    <asp:Label ID="lblCelular" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 141px; text-align: right;">
                                    <span style="margin-left: 12px; font-weight: normal;">Correo Electrónico:</span></td>
                                <td>
                                    <asp:Label ID="lblEmail" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                    <br />
                        <table cellpadding="1" cellspacing="0" class="td-content" 
                            style="margin-left: 17px;">
                            <tr>
                                <td colspan="2" style="text-align: left;">
                                    <asp:Label ID="lblTutorAC" runat="server" 
                                        style="margin-left: 17px; font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial" 
                                        Text="Tutor Activo"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 128px; text-align: right;">
                                    <span style="font-weight: normal">Nombres:</span></td>
                                <td>
                                    <asp:Label ID="lblNombreTutor" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 128px; text-align: right;">
                                    <span style="font-weight: normal">Apellidos:</span></td>
                                <td>
                                    <asp:Label ID="lblApellidoTutor" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 128px; text-align: right;">
                                    <span style="font-weight: normal">No. Documento</span></td>
                                <td>
                                    <asp:Label ID="lblNoDocumentoTutor" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                    <br />
                        <table align="left" cellpadding="1" cellspacing="0" class="td-content" 
                            style="margin-left:17px;" width="400">
                            <tr>
                                <td class="style3" colspan="2" style="font-weight: normal; text-align: left">
                                    <span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">
                                    Datos de Licencia</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="style3" 
                                    style="font-weight: normal; text-align: right; width: 130px;">
                                    Fecha de Licencia:</td>
                                <td align="left" style="margin-left: 40px">
                                    <asp:Label ID="lblFechaLicencia" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="style3" 
                                    style="font-weight: normal; text-align: right; width: 130px;">
                                    RNC:</td>
                                <td align="left" style="margin-left: 40px">
                                    <asp:Label ID="lblRNCLicencia" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="style3" 
                                    style="font-weight: normal; text-align: right; width: 130px;">
                                    Razón Social:</td>
                                <td align="left" style="margin-left: 40px">
                                    <asp:Label ID="lblEmpresaLicencia" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="style3" 
                                    style="text-align: right; font-weight: normal; width: 130px;">
                                    <span>Banco Múltiple:</span></td>
                                <td align="left" style="margin-left: 40px">
                                    <asp:Label ID="lblIdEntidadRecaudadora" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="style3" 
                                    style="text-align: right; font-weight: normal; width: 130px;">
                                    <span>Titular de Cuenta:</span></td>
                                <td>
                                    <asp:Label ID="lblTitular" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="style3" 
                                    style="text-align: right; font-weight: normal; width: 130px;">
                                    <span>Nro de Cuenta:</span></td>
                                <td>
                                    <asp:Label ID="lblNroCuenta" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right; width: 130px;">
                                    <span style="font-weight: normal">Tipo de Cuenta:</span></td>
                                <td>
                                    <asp:Label ID="lblTipoCuenta" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="style3" style="width: 130px">
                                    &nbsp;</td>
                                <td>
                                    &nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblMsg" Runat="server" cssclass="error" EnableViewState="False" 
                            style="margin-left: 17px"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div ID="fiedlsetDatos" runat="server">
                            <br />
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button 
                                ID="btnRegistrar" runat="server" 
                                style="margin-left: 62px; width: 90px; height: 19px;" Text="Confirmar" 
                                ValidationGroup="fecha" />
                            <asp:Button ID="btnCancelarGeneral" runat="server" 
                                style="margin-left: 4px; width: 90px; height: 19px;" Text="Cancelar" />
                        </div>
                    </td>
                </tr>
        </table>
       <br />
</fieldset>
       <br />
<br />

</ContentTemplate>
</asp:UpdatePanel>
<asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Procesando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

</asp:Content>

