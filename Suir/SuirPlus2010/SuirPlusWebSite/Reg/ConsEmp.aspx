<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusNoAutenticado.master" AutoEventWireup="false" CodeFile="ConsEmp.aspx.vb" Inherits="Reg_ConsEmp" %>

<%--<%@ Register Src="../Controles/CaptchaImage.ascx" TagName="CaptchaImage" TagPrefix="uc1" %>--%>
<%@ Register TagPrefix="recaptcha" Namespace="Recaptcha" Assembly="Recaptcha" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <img alt="Tesoreria de la Seguridad Social" src="../images/logoTSShorizontal.gif" />
    <br />
    <br />
    <div class="header">
        Consulta de Solicitud
    </div>

    <table border="0" cellpadding="1" cellspacing="1" style="width: 350px;" class="td-content">
        <tr>
            <td>
                <img height="100" width="200" alt="" src="../images/formulario.jpg" />
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
            <%--<td style="text-align: center;" class="labelData">C&oacutedigo de Solicitud:<br />
                <asp:TextBox ID="txtNroSol" runat="server" MaxLength="7"></asp:TextBox>
            </td>--%>
        </tr>
        <tr> <td></td></tr>
        <tr>
            <td colspan="2"  style="height: 18px;" align="center" >
                <recaptcha:recaptchacontrol
                                ID="recaptcha"
                                runat="server"
                                PublicKey="6Ld-od0SAAAAAL-7eV_JbD8brOewzWcL0AMig-ar"
                                PrivateKey="6Ld-od0SAAAAAPmNITxMyGFHybQxFmewdLICP0lF" 
                                AllowMultipleInstances="True"
                                Theme="white"/>
            </td>
        </tr>
        <tr><td></td></tr>
        <tr><td></td></tr>
             
    </table>

    <asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="False"></asp:Label>

    <br />
    <div id="detalle_sol" visible="true">
        <asp:GridView ID="gvDetalle" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="600px">
            <Columns>                
                <asp:BoundField DataField="STATUS" HeaderText="Estatus">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle Wrap="False" HorizontalAlign="left" />
                </asp:BoundField>

                <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:d}" HtmlEncode="False">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle Wrap="False" HorizontalAlign="center" />
                </asp:BoundField>
            </Columns>
        </asp:GridView>
    </div>


</asp:Content>

