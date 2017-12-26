<%@ Page Language="VB" AutoEventWireup="false" CodeFile="LoginPage.aspx.vb" Inherits="Reg_LoginPage" MasterPageFile="~/SuirPlusExterno.master" %>

<%@ Register Src="../Controles/CaptchaImage.ascx" TagName="CaptchaImage" TagPrefix="uc1" %>
<%@ Register Assembly="WebControlCaptcha" Namespace="WebControlCaptcha" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../css/Formulario.css" rel="stylesheet" />
    <script type="text/javascript">

        //var Ruta = "http://" + location.host + "/Reg/"

        function Ocultarlbl() {
            $("#ctl00_ContentPlaceHolder1_lblSucess").hide();
            $("#ctl00_ContentPlaceHolder1_lblError").hide();
            $("#ctl00_ContentPlaceHolder1_lblMensaje").hide();
        }


    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


            <div class="contact_form" id="contact_form" style="color: black; text-align: center; margin-left: 200px;">
                <ul style="border-bottom: 0px solid #777;">
                    <li>
                        <h2 class="Titulos">Acceso A Registro De Empresa
                        </h2>
                    </li>


                    <li>
                        <label for="txtCedula" class="letrasTexto">Usuario:</label>

                        <asp:TextBox ID="Usuario" runat="server" Placeholder="Correo Electronico" MaxLength="50" Font-Size="14px"></asp:TextBox>
                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Usuario es requerido" ControlToValidate="Usuario">*</asp:RequiredFieldValidator></li>--%>

                    <li id="licontraseña" runat="server">
                        <label for="Pass" class="letrasTexto">Contraseña:</label>

                        <asp:TextBox ID="Pass" runat="server" TextMode="Password"  Style="font-size: 19.2px"></asp:TextBox>
                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="La Contraseña es Requerida" ControlToValidate="Pass">*</asp:RequiredFieldValidator>--%>
                    </li>

                    <li style="border-bottom: 0px solid #777; border-top: 1px solid #777;">
                        <%--El Captcha esta comentado en el ambiente de desarrollo por fines de prueba!--%>
                        <%--  <cc1:CaptchaControl ID="CaptchaControl1" runat="server" ForeColor="Red" />--%>
                        <%--   </li>
            <li>--%>
                        <%--</li>--%>
                        <%-- <li> GuardarNoDocumento() --%>
                        <asp:Button ID="btLogin" runat="server" Text="     Aceptar" Font-Bold="true" CssClass="btnAceptar" Style="margin-left: 45px; padding-right: 24px;" OnClick="btLogin_Click"></asp:Button>
                        <%--</li>--%>
                        <br />
                        <br />
                        <asp:Label ID="lblMensaje" runat="server" style="color:blue; font-size:medium" Visible="false"></asp:Label>
                        
                        <asp:Label ID="lblError" Text="text" CssClass="error" runat="server" Visible="false"  Font-Size="9pt"/>
                        <asp:Label ID="lblSucess" CssClass="done" Text="text" runat="server" Visible="false" />
                        <br />
                        <asp:LinkButton ID="lbtnRecuperarClave" runat="server" Font-Size="Medium">¿No puedes acceder al Sistema?</asp:LinkButton><br />
                        <asp:Label id="lblMensajeRecuperar" Text="Introduzca su nombre de usuario (Correo) y recibirá una contraseña generada por el sistema" runat="server" Font-Size="8pt" visible="false" Font-Bold="true"/>
                    </li>
                </ul>

            </div>

</asp:Content>
