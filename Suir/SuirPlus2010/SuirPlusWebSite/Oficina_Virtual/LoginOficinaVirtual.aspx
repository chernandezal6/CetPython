<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusOficinaVirtual.master" AutoEventWireup="false" CodeFile="LoginOficinaVirtual.aspx.vb" Inherits="Oficina_Virtual_LoginOficinaVirtual" %>

<%@ Register Src="../Controles/CaptchaImage.ascx" TagName="CaptchaImage" TagPrefix="uc1" %>
<%@ Register Assembly="WebControlCaptcha" Namespace="WebControlCaptcha" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <%--<link href="../css/Formulario.css" rel="stylesheet" />--%>
    <script type="text/javascript">
        //$("#ctl00_ContentPlaceHolder1_RegularExpressionValidator1").hide()
        //var Ruta = "http://" + location.host + "/Reg/"
        //$(function () {
        //    $("#ctl00_ContentPlaceHolder1_lbtnRecuperarClave").click(function () {
        //        $("#ctl00_ContentPlaceHolder1_RegularExpressionValidator1").hide();
        //    });
        //});
        
        function Ocultarlbl() {
            $("#ctl00_ContentPlaceHolder1_lblSucess").hide();
            $("#ctl00_ContentPlaceHolder1_lblError").hide();
            $("#ctl00_ContentPlaceHolder1_lblMensaje").hide();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="contact_form" id="contact_form" style="text-align: -webkit-center;">
        <div id="divTituloWelcome" runat="server">
            <h2 class="Titulos">Iniciar Sessión en Oficina Virtual
            </h2>
        </div>
        <div id="divTituloRec" runat="server" visible="false">
            <h2 class="Titulos">Recuperación de contraseña de Usuario
            </h2>
        </div>
        <hr />
        <div style="width: 50%; margin-bottom: 10px; padding-bottom: 15px;">
            <!--Sección 1-->
            <div id="liusuario_cedula" runat="server">
                <div style="display: inline-flex; align-content: center;">
                    <label for="txtCedula" class="letrasTexto"
                        style="margin-right: 10px; float: left; padding-top: 5px; padding-left: 25px;">
                        Usuario:</label>

                    <asp:TextBox ID="Usuario" runat="server" Placeholder="Cédula o NSS" MaxLength="11"
                        Style="font-size: 14px; margin-bottom: 10px; height: 20px;"
                        CssClass="form-control">
                    </asp:TextBox>
                </div>
            </div>
            <!--Sección 2-->
            <div id="liusuario_correo" runat="server" visible="false">
                <div style="display: inline-flex; align-content: center;">
                    <label for="txtcorreo" class="letrasTexto"
                        style="margin-right: 10px; width:220px; padding-top: 5px;">
                        Correo electrónico:
                    </label>

                    <asp:TextBox ID="txtusuario_correo"
                        Style="margin-right: 48px; height: 20px;" runat="server"
                        Placeholder="Correo electrónico" MaxLength="50"
                        CssClass="form-control"
                        Font-Size="14px">
                    </asp:TextBox>
                </div>
            </div>
            <div>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                ControlToValidate="Usuario" ErrorMessage="Formato inválido"
                ForeColor="Red"
                SetFocusOnError="True"
                ValidationExpression="^[0-9]*">
            </asp:RegularExpressionValidator>
        </div>
            <!--Sección 3-->
            <div id="licontraseña" runat="server" style="margin-bottom: 15px;">
                <div style="display: inline-flex; align-content: center;">
                    <label for="Pass" class="letrasTexto"
                        style="margin-right: 10px; float: left; padding-top: 15px;">
                        Contraseña:</label>

                    <asp:TextBox ID="Pass" runat="server"
                        TextMode="Password"
                        Font-Size="14px"
                        Style="height: 20px; margin-top: 10px;"
                        CssClass="form-control">
                    </asp:TextBox>
                </div>
            </div>
            <asp:LinkButton ID="lbtnRecuperarClave" runat="server" Font-Size="Small" Visible="true">¿Has olvidado tu contraseña? Haz click aquí!</asp:LinkButton><br />
        </div>
        <div>
            <asp:Button ID="btnRegresar" Font-Bold="true" 
                Width="114px" runat="server" 
                CssClass="btn btn-primary" Text="Regresar" 
                Visible="false"/>
            <asp:Button ID="btLogin" runat="server" Text="Entrar"
                Font-Bold="true" CssClass="btn-primary"
                Style="margin-left: auto; border-radius: 4px;" Height="32px"
                Width="114px">
            </asp:Button>
            <hr />
            <asp:Label ID="lblMensaje" runat="server" Style="font-size: medium;" CssClass="error" Visible="false"></asp:Label>
            <asp:Label ID="lblError" Text="text" CssClass="error" runat="server" Visible="false" Font-Size="9pt" />
            <asp:Label ID="lblSucess" CssClass="done" Text="text" runat="server" Visible="false" />
            <asp:Label ID="lblMensajeRecuperar" Text="Introduzca su correo electrónico y recibirá una contraseña generada por el sistema" runat="server" Font-Size="8pt" Visible="false" Font-Bold="true" />
            <br />
            <asp:LinkButton ID="lbtnRegistrarUsuario" runat="server" Font-Size="Small">¿Es nuevo en la oficina virtual? Registrese aquí</asp:LinkButton>
        </div>
    </div>
</asp:Content>
