<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusOficinaVirtual.master" AutoEventWireup="false" CodeFile="CambiarContraseñaOFV.aspx.vb" Inherits="Oficina_Virtual_CambiarContraseñaOFV" %>

<%@ Register TagPrefix="recaptcha" Namespace="Recaptcha" Assembly="Recaptcha" %>

 <asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <link href="../css/Formulario.css" rel="stylesheet" />

    <script type="text/javascript">
        $(function () {
            if ($("#ctl00_ContentPlaceHolder1_hfMostrarPopUp").val() != "") {
                debugger;
                $("#myModal").modal('show');
                $("#divMensajeModal").html($("#ctl00_ContentPlaceHolder1_hfMostrarPopUp").val());
                $("#ctl00_ContentPlaceHolder1_hfMostrarPopUp").val("");
            }
            $("#ctl00_ContentPlaceHolder1_txtFechaNacimiento").datepicker();
            function CambiarBotones() {
                $("input[name='ctl00$ContentPlaceHolder1$btnAceptar']").removeClass("contact_form input, contact_form textarea");
                $("input[name='ctl00$ContentPlaceHolder1$btnAceptar']").removeClass("contact_form input");
                $("input[name='ctl00$ContentPlaceHolder1$btnCancelar']").removeClass();
                $("input[name='ctl00$ContentPlaceHolder1$btnCancelar']").removeClass();
            }
        });

        function SamePasswords(textObj1) {
            //alert('al menos entra a la funcion' + string1);
            var string1 = textObj1.value
            var string2 = document.getElementById('<%=txtNewPassword.ClientID%>').value;

            //alert('al menos entra a la funcion' + string1);
            if (string1 != string2) {

                alert("Las contraseñas no son iguales");
            };

            SendRequest();
        };
    </script>

         <!-- Nuevo panel de Registro-->
      <asp:HiddenField ID="hfMostrarPopUp" runat="server" Value="" />
     <div class="contact_form" id="Divcontact_form" visible="true" runat="server" align="center">
        <div>
            <h2 style="color: black; font: bold 16pt Tahoma,Verdana,Arial;">Cambio de contraseña de usuarios de la Oficina Virtual</h2>
        </div>  
        <div class="Raya"></div>
         <br \>
        <div id="divChangePassword" runat="server">
            <table>
              
                <tr id="OldPassword" runat="server">
                    <td class="lblRegUsuario">
                        <label for="txtOldPassword" class="letrasTexto">Contraseña (anterior):</label></td>
                    <td>
                         <asp:TextBox ID="txtOldPassword"
                            TextMode="Password"
                           
                            runat="server" Font-Size="15pt" CssClass="CampostxtAsp">
                        </asp:TextBox>                            
                    </td>
                </tr>
                <tr class="DownLine">
                    <td></td>
                    <td> </td>
                </tr>
                <tr id="NewPassword" runat="server" class="DownLine">
                    <td class="lblRegUsuario">
                        <label for="txtNewPassword" class="letrasTexto">Contraseña(nueva):</label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtNewPassword"
                            TextMode="Password"
                            onchange="javascript: return SamePasswords(this);"
                            runat="server" Font-Size="15pt" CssClass="CampostxtAsp">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr id="NewPasswordConf" runat="server" class="DownLine">
                    <td class="lblRegUsuario">
                        <label for="txtNewPasswordConf" class="letrasTexto">Confirmar Contraseña:</label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtNewPasswordConf"
                            TextMode="Password"
                            runat="server" Font-Size="15pt" CssClass="CampostxtAsp">
                        </asp:TextBox>
                        <br \>
                        <asp:CompareValidator ID="CompareValidator2" runat="server"
                            ControlToCompare="txtNewPassword" ControlToValidate="txtNewPasswordConf"
                            Display="Dynamic" SetFocusOnError="True" ForeColor="Red"
                            ErrorMessage="La constraseña nueva y la de confirmación deben ser iguales">
                        </asp:CompareValidator>
                    </td>
                </tr>
            </table>
            <div id="liCatcha" runat="server">
                                            <recaptcha:recaptchacontrol
                                            ID="recaptcha"
                                            runat="server"
                                            CssClass="CampostxtAsp"
                                            PublicKey="6Ld-od0SAAAAAL-7eV_JbD8brOewzWcL0AMig-ar"
                                            PrivateKey="6Ld-od0SAAAAAPmNITxMyGFHybQxFmewdLICP0lF" 
                                            AllowMultipleInstances="True"
                                            Theme="white"/>
            </div>
        </div>
        <div id="divRayaRegistro" class="Raya" runat="server" visible="false" ></div>
        <div id="divBtnPassword" runat="server">
            <table id="TblBotones" runat="server">
                <tr>
                    <td id="tblButton" runat="server" style="text-align: center;">
                        <asp:Button ID="btnProceder" runat="server" CssClass="btn-primary"
                                    Text="Proceder" BorderStyle="Solid"
                                    Style="font-size: 12px; border-radius: 4px; height: 35px; width: 90px;"
                                    Font-Bold="true" />
                        <asp:Button ID="btnCancelar" runat="server" CssClass="btn-primary"
                                    Text="Cancelar" BorderStyle="Solid"
                                    Style="font-size: 12px; border-radius: 4px; height: 35px; width: 90px;"
                                    Font-Bold="true" />
                    </td>
                </tr>
            </table>
        </div>

           <!--Inicio del Popo Up-->

    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" data-backdrop="">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="false">&times;</span></button>--%>
                    <h4 class="modal-title" id="myModalLabel">Mensaje</h4>
                </div>
                <div id="divMensajeModal" class="modal-body">
                    Su contraseña fue cambiada correctamente.
                </div>
                <div class="modal-footer">
                    <button id="btnOKPopUp" runat="server" type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                  <button id="btnMsjPopUp" runat="server" type="button" class="btn btn-primary" visible="false" data-dismiss="modal">OK</button>                  
                     </div>
            </div>
        </div>
    </div>
    
    <!--Fin del Pop Up-->

        <div id="divMsjError" runat="server" visible="false">
            <table>
                <tr>
                    <td colspan="2" id="tblmensaje" runat="server">
                        <asp:Label ID="lblMensaje" runat="server" CssClass="error" Font-Size="10pt"></asp:Label>
                    </td>
                 <%--   <td>
                        <asp:LinkButton ID="lbtnRegresar" runat="server" Font-Size="Medium" Visible="false"> << Regresar</asp:LinkButton>
                    </td>--%>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>



