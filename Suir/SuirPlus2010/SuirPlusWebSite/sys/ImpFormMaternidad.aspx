<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false" CodeFile="ImpFormMaternidad.aspx.vb" Inherits="sys_ImpFormMaternidad" %>
<%--<%@ Register TagPrefix="recaptcha" Namespace="Recaptcha" Assembly="Recaptcha" %>--%>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script src="../Script/jquery-1.5.2.min.js" type="text/javascript"></script>
    <script src="../Script/Util.js" type="text/javascript"></script>
   
     <script type="text/javascript">

         if (top != self) top.location.replace(location.href); 
    
    </script>

    <img alt="Tesoreria de la Seguridad Social" 
        src="../images/logoTSShorizontal.gif" />
    <div class="header">Reimpresión Formulario Licencia por Maternidad</div><br />
    
      
<%--    <script language="javascript" type="text/javascript">
        function checkNum() {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false; 
            }
        }


//        function modelesswin(url) {
//            window.showModalDialog(url, "", "help:0;status:0;toolbar:0;scrollbars:0;dialogwidth:840px:dialogHeight:5000px")
//        }

	</script>--%>

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

            var page = "../Subsidios/FormularioLicencia.aspx?nss="+ $("#<%=hfnss.ClientID %>").val() +  "&nombre=" + $("#<%=hfnombre.ClientID %>").val() + "&cedula=" + $("#<%=hfcedula.ClientID %>").val() + "&hash="+ $("#<%=hfhash.ClientID %>").val() + "&numero=" + $("#<%=hfNumeroFormulario.ClientID %>").val();

            //window.showModalDialog(page, "", "help:0;status:0;toolbar:0;scrollbars:0;dialogwidth:840px:dialogHeight:5000px");
            window.open(page, "", "help:0;status:0;toolbar:0;scrollbars:0;dialogwidth:840px:dialogHeight:5000px");
        }

    </script>
    <asp:HiddenField ID="hfNumeroFormulario" runat="server" />
    <asp:HiddenField ID="hfnombre" runat="server" />
    <asp:HiddenField ID="hfcedula" runat="server" />
    <asp:HiddenField ID="hfnss" runat="server" />
    <asp:HiddenField ID="hfsexo" runat="server" />
    <asp:HiddenField ID="hftipoSolicitud" runat="server" />
    <asp:HiddenField ID="hfhash" runat="server" />
    <asp:HiddenField ID="HiddenField8" runat="server" />


    <table border="0" cellpadding="1" cellspacing="1" class="tblContact" style="font-size: 13pt;
        color: #006699; font-family: Verdana" width="370">
        <tr>
            <td>
                <table id="Table1" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td style="">
                            &nbsp;
                        </td>
                        <td style="">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" style="text-align: right;">Nro. Cédula:&nbsp;
                            
                        </td>
                        <td valign="top" style="text-align: left;">
                            &nbsp;
                            <asp:TextBox ID="txtnodocumento" runat="server" MaxLength="11"></asp:TextBox>&nbsp;(sin guiones)
                            <br />
                            &nbsp;
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtnodocumento"
                                Display="Dynamic" ErrorMessage="El valor debe ser numérico." ValidationExpression="\d*"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 12px; text-align: right;" valign="top">PIN:&nbsp;
                        </td>
                        <td style="height: 12px; text-align: left;" valign="top">
                            &nbsp;
                            <asp:TextBox ID="txtPin" runat="server" MaxLength="4"></asp:TextBox>
                            <br />
                            &nbsp;
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtPin"
                                Display="Dynamic" ErrorMessage="El valor debe ser numérico." ValidationExpression="\d*"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 12px; text-align: center;" valign="top">
                            &nbsp;
                        </td>
                        <td style="height: 12px; text-align: center;" valign="top">
                            &nbsp;
                        </td>
                    </tr>
	              <%--  <tr>
                        <td colspan="2"  style="height: 18px;" align="center" >
                            <recaptcha:recaptchacontrol
                                            ID="recaptcha"
                                            runat="server"
                                            PublicKey="6Ld-od0SAAAAAL-7eV_JbD8brOewzWcL0AMig-ar"
                                            PrivateKey="6Ld-od0SAAAAAPmNITxMyGFHybQxFmewdLICP0lF" 
                                            AllowMultipleInstances="True"
                                            Theme="white"/>
                        </td>
                    </tr>--%>
                    <tr>
                        <td align="center" colspan="2">
                            &nbsp;&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                        <input id="btVerformulario" type="button" class="button" value="Reimprimir Formulario" />
                            <asp:Button ID="btBuscarRef" runat="server" Enabled="True" EnableViewState="False"
                                Text="Buscar" />
                            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="false" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                </table>
               
            </td>
        </tr>
    </table>
 <asp:Label ID="lblError" runat="server" CssClass="error" Font-Size="8pt" Visible="False"></asp:Label>
</asp:Content>

