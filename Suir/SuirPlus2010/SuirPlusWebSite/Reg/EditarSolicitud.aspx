<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusNoAutenticado.master" AutoEventWireup="false" CodeFile="EditarSolicitud.aspx.vb" Inherits="Reg_EditarSolicitud" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
</asp:Content>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <img alt="Tesoreria de la Seguridad Social" src="../images/logoTSShorizontal.gif" />
    <br />
    <div class="header">
        Modificacion de Solicitud
    </div>

    <table border="0" cellpadding="1" cellspacing="1" style="width: 350px;" class="td-content">
        <tr>
            <td>
                <img alt="" src="../images/borradores.jpg" style="height: 130px; width: 259px" />
            </td>
            <td>
                <table cellspacing="0" cellpadding="0" width="275" border="0">
                    <tr>
                        <td colspan="2"></td>
                    </tr>
                    <tr>
                        <td colspan="2"></td>
                    </tr>
                    <tr>
                        <td class="labelData">Código de Solicitud
                        </td>
                        <td style="HEIGHT: 40px" >
                            <asp:TextBox ID="txtNroSol" runat="server" Width="120px" MaxLength="7"></asp:TextBox>
                            <br />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Código de Solicitud Requerido"
                                ControlToValidate="txtNroSol" Display="Dynamic"></asp:RequiredFieldValidator></td>
                    </tr>
                    <tr> <td></td></tr>
                    <tr style ="text-align:center">
            <td colspan="2" >
                <asp:Button ID="btnAceptar" runat="server" Text="Buscar" />&nbsp;
                <asp:Button ID="btnCancelar" runat="server" Text="Limpiar" /><br />
            </td>
        </tr>   

                    <tr>
                        <td colspan="2">&nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>


    </table>
    <br />
    <br />

    <asp:Panel ID="pnlResumen" runat="server" Visible="true">
        <table border="0" cellpadding="0" cellspacing="2" class="td-content" width="600">
            <%--<tr>
                <td align="left" class="subHeader" colspan="2">
                    Empleador Registrado
                </td>
            </tr>--%>
            <%--<tr>
                <td colspan="2" style="height: 5px;">
                </td>
            </tr>
            <tr>
                <td colspan="2" valign="top">
                    <span class="error">El empledor fue registrado satisfactoriamente.</span>
                </td>
            </tr>--%>
            <tr>
                <td class="error" colspan="2" style="height: 5px;">
                </td>
            </tr>
            <tr>
                <td class="subHeader" colspan="2">
                    Información del Empleador
                </td>
            </tr>
            <tr>
                <td class="error" colspan="2" style="height: 5px;">
                </td>
            </tr>
            <tr>
                <td style="width: 16%">
                    RNC o Cédula
                </td>
                <td align="left" valign="top">
                    <asp:Label ID="lblFRncCedula" runat="server" CssClass="labelData"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    Razón Social
                </td>
                <td>
                    <asp:Label ID="lblFinRazonSocial" runat="server" CssClass="labelData"></asp:Label>
                </td>
            </tr>
            <tr>
                <td nowrap="nowrap">
                    Nombre Comercial
                </td>
                <td>
                    <asp:Label ID="lblFinNombreComercial" runat="server" CssClass="labelData"></asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="height: 5px;">
                </td>
            </tr>
            <tr>
                <td class="subHeader" colspan="2">
                    Información del Representante
                </td>
            </tr>
            <tr>
                <td colspan="2" style="height: 5px;">
                </td>
            </tr>
            <tr>
                <td>
                    Documento
                </td>
                <td>
                    <asp:Label ID="lblFinCedula" runat="server" CssClass="labelData"></asp:Label>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    NSS
                </td>
                <td>
                    <asp:Label ID="lblFinNSS" runat="server" CssClass="labelData"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    Nombre
                </td>
                <td>
                    <asp:Label ID="lblFinNombre" runat="server" CssClass="labelData"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    CLASS
                </td>
                <td>
                    <asp:Label ID="lblFinCLASS" runat="server" CssClass="labelData">El class se le envio al la dirección de correo registrado.</asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="height: 3px;">
                    &nbsp;
                </td>
            </tr>
        </table>
        <div style="width: 415px">
            <div class="subHeader">
                <br />
                Completar Solicitud<br />
            </div>
            <table width="415px">
                <tr>
                    <td nowrap="nowrap">
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td nowrap="nowrap" valign="top">
                        Nro. Solicitud
                    </td>
                    <td valign="top">
                        <asp:Label ID="lblNroSolicitud" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        Comentario
                    </td>
                    <td>
                        <asp:TextBox ID="txtComentarioSolicitud" runat="server" Height="50px" TextMode="MultiLine"
                            Width="340px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ControlToValidate="txtComentarioSolicitud"
                            Display="Dynamic" ErrorMessage="El comentario es requerido." ValidationGroup="vgCierreSolicitud"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="right">
                        <asp:Button ID="btnCerrarSolRegistroEmpresa" runat="server" Text="Cerrar Solicitud"
                            ValidationGroup="vgCierreSolicitud" />
                    </td>
                </tr>
                <tr>
                    <td align="left" colspan="2">
                        <asp:Label ID="lblMensajeSol" runat="server" CssClass="error"></asp:Label>
                    </td>
                </tr>
            </table>
        </div>
        <br />
        <br />
        <br />
        <div style="width: 415px">
            <asp:Button ID="btnFinal" runat="server" Text="Registrar otro empleador" />&nbsp;
            <asp:Button ID="btnImpersonar" runat="server" Text="Ingresar Como Representante" />
        </div>
    </asp:Panel>


   <%-- <div id="resumen_sol" visible="true">
        <asp:GridView ID="gvDetalle" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="600px">
           
        </asp:GridView>
    </div>--%>

</asp:Content>