<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusOficinaVirtual.master" AutoEventWireup="false" CodeFile="ActualizarEmailOFV.aspx.vb" Inherits="Oficina_Virtual_ActualizarEmailOFV" %>
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

    </script>

         <!-- Nuevo panel de Registro-->
      <asp:HiddenField ID="hfMostrarPopUp" runat="server" Value="" />
     <div class="contact_form" id="Divcontact_form" visible="true" runat="server" align="center">
        <div>
            <h2 style="color: black; font: bold 16pt Tahoma,Verdana,Arial;">Cambio de Email de usuarios de la Oficina Virtual</h2>
        </div>  
        <div class="Raya"></div>
         <br \>
        <div id="divChangePassword" runat="server">
            <table>
                <tr id="LiEmail" runat="server" class="DownLine">
                    <td class="lblRegUsuario">
                        <label for="txtEmailAnterior" class="letrasTexto">Correo electrónico(anterior):</label></td>
                    <td>
                        <asp:TextBox ID="txtEmailAnterior"  runat="server" Font-Size="11pt" Style="margin-bottom: 10px" placeholder="Email"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                            ErrorMessage="Formato inválido" ControlToValidate="txtEmailAnterior"
                            SetFocusOnError="True"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
                        </asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr class="DownLine">
                    <td></td>
                    <td> </td>
                </tr>
                 <tr id="Tr1" runat="server" class="DownLine">
                    <td class="lblRegUsuario">
                        <label for="txtEmailNuevo" class="letrasTexto">Correo electrónico(Nuevo):</label></td>
                    <td>
                        <asp:TextBox ID="txtEmailNuevo"  runat="server" Font-Size="11pt" Style="margin-bottom: 10px" placeholder="Email"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server"
                            ErrorMessage="Formato inválido" ControlToValidate="txtEmailNuevo"
                            SetFocusOnError="True"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
                        </asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr class="DownLine">
                    <td></td>
                    <td> </td>
                </tr>
                 <tr id="Tr2" runat="server" class="DownLine">
                    <td class="lblRegUsuario">
                        <label for="txtConfEmail" class="letrasTexto">Confirmar Correo:</label></td>
                    <td>
                        <asp:TextBox ID="txtConfEmail"  runat="server" Font-Size="11pt" Style="margin-bottom: 10px" placeholder="Email"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server"
                            ErrorMessage="Formato inválido" ControlToValidate="txtConfEmail"
                            SetFocusOnError="True"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
                        </asp:RegularExpressionValidator>
                        <br \>
                            <asp:CompareValidator ID="CompareValidator2" runat="server"
                            ControlToCompare="txtEmailNuevo" ControlToValidate="txtConfEmail"
                            Display="Dynamic" SetFocusOnError="True" ForeColor="Red"
                            ErrorMessage="El correo electrónico nuevo y el de confirmación deben ser iguales">
                        </asp:CompareValidator>
                    </td>
                </tr>
                <tr class="DownLine">
                    <td></td>
                    <td> </td>
                </tr>
            </table>
          </div>
        <div id="divRayaRegistro" class="Raya" runat="server" visible="false" ></div>

              <div id="DivCaptchaButtons" runat="server">
                                              <recaptcha:recaptchacontrol
                                            ID="recaptcha"
                                            runat="server"
                                            CssClass="CampostxtAsp"
                                            PublicKey="6Ld-od0SAAAAAL-7eV_JbD8brOewzWcL0AMig-ar"
                                            PrivateKey="6Ld-od0SAAAAAPmNITxMyGFHybQxFmewdLICP0lF" 
                                            AllowMultipleInstances="True"
                                            Theme="white"/>
            
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
                    Su correo electronico fue cambiado correctamente.
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
             <table style="width:800px">
                 <tr>
                     <td colspan="2" id="Td1" align="center" runat="server">
                         <asp:Label ID="lblMsjOk" runat="server" ForeColor="Blue" Font-Size="Medium"></asp:Label>
                         <br\>
                          <br\>
                           <br />
                           <asp:LinkButton ID="lbtnRegresar" runat="server" Font-Size="Medium" Visible="false"> <<== Volver Atrás</asp:LinkButton>
                     </td>
                 </tr>
                 <tr>
                     <td colspan="2" id="Td2" align="center" runat="server">
                         <asp:Label ID="lblMensaje" runat="server" CssClass="error" Font-Size="10pt"></asp:Label>
                     </td>
                     </tr>
             </table>
        </div>
    </div>
</asp:Content>
