<%@ Page Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false"
    CodeFile="VerificarCertificacion.aspx.vb" Inherits="VerificarCertificacion" Title="Verficar Certificación" %>
<%@ Register TagPrefix="recaptcha" Namespace="Recaptcha" Assembly="Recaptcha" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script src="../Script/jquery-1.5.2.min.js" type="text/javascript"></script>
    <script src="../Script/Util.js" type="text/javascript"></script>
    <script type="text/javascript">

        //if (top != self) top.location.replace(location.href);

    </script>
    <img alt="Tesoreria de la Seguridad Social" src="../images/logoTSShorizontal.gif" />
    <div class="header">
        Verificar Certificación
    </div>
    <br />
    <script type="text/javascript">
        function checkNum() {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false;
            }
        }
    </script>

    <script type="text/javascript">
        $(function () {

            $("#btVerformulario").hide();
            $("#<%=btBuscarRef.ClientID %>").show();

            var p = $("#<%=hfNumeroFormulario.ClientID %>").val();
            if (p) {

                $("#btVerformulario").show();
                $("#<%=btBuscarRef.ClientID %>").hide();
            }

            $("#btVerformulario").click(ReimprimirFormulario);

        });

        function ReimprimirFormulario() {
            var page = "ImpCertificacion.aspx?B=GtIFyg&A=" + $("#<%=hfNumeroFormulario.ClientID %>").val();
            window.open(page,"", "help:0;status:0;toolbar:0;scrollbars:0;dialogwidth:840px:dialogHeight:5000px");
        }

    </script>

    <asp:HiddenField ID="hfNumeroFormulario" runat="server" />

    <table border="0" cellpadding="1" cellspacing="1" class="tblContact" style="font-size: 13pt; color: #006699; font-family: Verdana"
        width="400px">
        <tr>
            <td>
                <table id="Table1" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td valign="top" style="text-align: right;">Codigo: &nbsp;
                        </td>
                        <td valign="top" style="text-align: left;">
                            <asp:TextBox ID="txtcodigo" runat="server" MaxLength="22"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="height: 12px; text-align: right;" valign="top">PIN: &nbsp;
                        </td>
                        <td style="height: 12px; text-align: left;" valign="top">
                            <asp:TextBox ID="txtPin" runat="server" MaxLength="4"></asp:TextBox>
                            <br />
                            &nbsp;
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtPin"
                                Display="Dynamic" ErrorMessage="El valor debe ser numérico." ValidationExpression="\d*"></asp:RegularExpressionValidator>
                        </td>
                    </tr>                             
                    <tr>
                        <td align="center" colspan="2">&nbsp;&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <input id="btVerformulario" type="button" class="button" value="Reimprimir Certificacion" />
                            <asp:Button ID="btBuscarRef" runat="server" Enabled="True" EnableViewState="False"
                                Text="Buscar" />
                            &nbsp;<asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="false" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>&nbsp;
                        </td>
                    </tr>
                </table>
                
            </td>
        </tr>
    </table>
    <asp:Label ID="lblError" runat="server" CssClass="error" Font-Size="8pt" Visible="False"></asp:Label>
</asp:Content>
