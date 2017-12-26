<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusOficinaVirtual.master" AutoEventWireup="false" CodeFile="RegistroSolicitudUsuario.aspx.vb" Inherits="Oficina_Virtual_RegistroSolicitudUsuario" ViewStateEncryptionMode="Always" EnableViewStateMac="true" EnableSessionState="True" %>

<%@ Register TagPrefix="recaptcha" Namespace="Recaptcha" Assembly="Recaptcha" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <script type="text/javascript">
        $(function () {
            if ($("#ctl00_ContentPlaceHolder1_hfMostrarPopUp").val() != "") {
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
            if ($("#ctl00_ContentPlaceHolder1_statusU").val() == "R") {
                $("#divRegistroInicial").show();
                //ctl00_ContentPlaceHolder1_divRegistroInicial
            }
        });

        function SamePasswords(textObj1) {
            //alert('al menos entra a la funcion' + string1);
            var string1 = textObj1.value
            var string2 = document.getElementById('<%=txtClave3.ClientID%>').value;

            //alert('al menos entra a la funcion' + string1);
            if (string1 != string2) {

                alert("Las contraseñas no son iguales");
            };

            SendRequest();
        };
    </script>
    <style>
        table {
            border-collapse: collapse;
            width: 60%;
        }

        th, td {
            text-align: left;
            padding: 8px;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        th {
            background-color: #4CAF50;
            color: white;
        }

        .TituloTable {
            font-weight: bold;
            font-size: 14px;
            color: #006699;
        }

        .LetrasTable {
            font-size: 10pt;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <!--Segmento de Registro-->
    <asp:HiddenField ID="statusU" runat="server" />
    <asp:HiddenField ID="hfMostrarPopUp" runat="server" Value="" />
    <div class="contact_form" id="Divcontact_form" style="text-align: -webkit-center;" visible="true" runat="server" align="center">
        <div id="divTituloRegistro">
            <h2 class="Titulos">Registro de Usuario
            </h2>
            <hr />
        </div>

        <!--Segmento para validación de la cédula-->
        <div id="DivDocumento" runat="server" style="width: 50%;">
            <div id="seccion1">
                <div style="display: inline-flex; align-content: center;">
                    <label for="txTipoDocumento" class="letrasTexto" style="padding-top: 5px;">Nro. de Documento:</label>
                    <asp:DropDownList ID="ddlTipoDocumento"
                        runat="server"
                        Style="width: 95px; font-size: 14px; margin-left: 10px; margin-right: 10px;"
                        class="form-control">
                        <asp:ListItem Value="C">Cédula </asp:ListItem>
                        <asp:ListItem Value="N">Nss</asp:ListItem>
                    </asp:DropDownList>
                    <asp:TextBox ID="txtDocumento" runat="server"
                        MaxLength="11" Width="130px"
                        Font-Size="14px"
                        CssClass="form-control">
                    </asp:TextBox>

                </div>
            </div>
            <div id="seccion2">
                <div style="display: inline-flex; align-content: center;">
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server"
                        ControlToValidate="txtDocumento" ErrorMessage="Solo números permitidos"
                        ForeColor="Red" SetFocusOnError="True"
                        ValidationExpression="^[0-9]*">
                    </asp:RegularExpressionValidator>
                </div>
            </div>
            <div id="seccion3">
                <div style="display: inline-flex; align-content: center; margin-bottom: 10px;">
                    <asp:Button ID="btnBuscar" Font-Bold="true"
                        Width="114px" runat="server"
                        CssClass="btn btn-primary" Text="Buscar"
                        Visible="True" />
                    <%--<asp:ImageButton ID="ImgDocumento" runat="server" ImageUrl="../images/boton-buscar.gif" CssClass="imgBuscar" AlternateText="Buscar" />--%>
                    <asp:HiddenField ID="ValidarLupa" runat="server" Value="0" />
                </div>
            </div>
            <div>
                <asp:Label ID="lblNombreCiudadano" runat="server" CssClass="label-Blue" Style="align-content: center"></asp:Label>
            </div>
            <div id="divMensajeBuscar">
                <asp:Label ID="lblMensajeBuscar" runat="server" CssClass="error" Font-Size="10pt" Visible="false"></asp:Label>
                <asp:LinkButton Text="<< Regresar"
                    Font-Underline="true"
                    Font-Bold="true" ForeColor="Blue"
                    Font-Size="12px" ID="LnkRegresar"
                    runat="server" Visible="false" />
            </div>
            <hr />
        </div>
        <!--Fin del segmento-->

        <!--Segmento de Campos del Registro-->
        <div id="divRegistroInicial" visible="false" runat="server" style="width: 50%;">
            <!-- Prueba -->
            <ul class="media-list">
                <li class="media">
                    <div class="media-left">
                        <label for="txtEmail1" style="width: 180px; padding-top: 5px; margin-right: 15px;" class="letrasTexto">Correo Electrónico:</label>
                    </div>
                    <div class="media-body">
                        <asp:TextBox ID="txtEmail1" runat="server" Style="margin-bottom: 10px; font-size: 14px;" CssClass="form-control" placeholder="Email"></asp:TextBox>
                        <div class="media">
                            <div class="media-left">
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                                    ErrorMessage="Formato inválido" ControlToValidate="txtEmail1"
                                    SetFocusOnError="True"
                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
                                </asp:RegularExpressionValidator>
                            </div>
                        </div>
                    </div>
                </li>
                <li class="media">
                    <div class="media-left">
                        <label for="LiConfEmail1" style="width: 180px; padding-top: 5px; margin-right: 15px;" class="letrasTexto">Confirmar Correo:</label>
                    </div>
                    <div class="media-body">
                        <asp:TextBox ID="LiConfEmail2" runat="server" Style="margin-bottom: 10px; font-size: 14px;" CssClass="form-control"></asp:TextBox>
                        <div class="media">
                            <div class="media-left">
                                <asp:RegularExpressionValidator ID="LiConfEmail3" runat="server"
                                    ErrorMessage="Formato inválido" ControlToValidate="LiConfEmail2"
                                    SetFocusOnError="True"
                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
                                </asp:RegularExpressionValidator>
                                <asp:CompareValidator ID="CompareValidator1" runat="server"
                                    ControlToCompare="txtEmail1" ControlToValidate="LiConfEmail2"
                                    Display="Dynamic" SetFocusOnError="True" ForeColor="Red"
                                    ErrorMessage="El email actual debe ser igual al email de confirmación">
                                </asp:CompareValidator>
                            </div>
                        </div>
                    </div>
                </li>
                <li class="media">
                    <div class="media-left">
                        <label for="txtClave" style="width: 180px; padding-top: 5px; margin-right: 15px;" class="letrasTexto">Contraseña:</label>
                    </div>
                    <div class="media-body">
                        <asp:TextBox ID="txtClave3"
                            TextMode="Password"
                            onchange="javascript: return SamePasswords(this);"
                            runat="server" Style="margin-bottom: 10px; font-size: 14px;" CssClass="form-control">
                        </asp:TextBox>
                    </div>
                </li>

                <li class="media">
                    <div class="media-left">
                        <label for="lblConfClave" style="width: 180px; padding-top: 5px; margin-right: 15px;" class="letrasTexto">Confirmar Contraseña:</label>
                    </div>
                    <div class="media-body">
                        <asp:TextBox ID="txtConfClave"
                            TextMode="Password"
                            runat="server" Style="margin-bottom: 10px; font-size: 14px;" CssClass="form-control">
                        </asp:TextBox>
                        <div class="media">
                            <div class="media-left">
                                <asp:CompareValidator ID="CompareValidator2" runat="server"
                                    ControlToCompare="txtClave3" ControlToValidate="txtConfClave"
                                    Display="Dynamic" SetFocusOnError="True" ForeColor="Red"
                                    ErrorMessage="La constraseña actual y la de confirmación deben ser iguales">
                                </asp:CompareValidator>
                            </div>
                        </div>
                    </div>
                </li>

                <li class="media">
                    <div class="media-left">
                        <label for="txtTelefono1"
                            class="letrasTexto"
                            style="width: 180px; padding-top: 5px; margin-right: 15px;">
                            Teléfono:</label>
                    </div>
                    <div class="media-body">
                        <asp:TextBox ID="txtTelefono1"
                            runat="server"
                            MaxLength="10"
                            Style="margin-bottom: 10px; font-size: 14px;" CssClass="form-control" placeholder="">
                        </asp:TextBox>
                        <div class="media">
                            <div class="media-left">
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server"
                                    ControlToValidate="txtTelefono1" ErrorMessage="Formato inválido"
                                    ForeColor="Red" SetFocusOnError="True"
                                    ValidationExpression="^[0-9]*">
                                </asp:RegularExpressionValidator>
                            </div>
                        </div>
                    </div>
                </li>

            </ul>
            <!---------------------------------------------------->
            <div id="seccion9">
                <div style="display: inline-flex; align-content: center;">
                    <recaptcha:RecaptchaControl
                        ID="recaptcha"
                        runat="server"
                        PublicKey="6Ld-od0SAAAAAL-7eV_JbD8brOewzWcL0AMig-ar"
                        PrivateKey="6Ld-od0SAAAAAPmNITxMyGFHybQxFmewdLICP0lF"
                        AllowMultipleInstances="True"
                        Theme="white" />
                </div>
            </div>
            <hr />
        </div>
        <!--Fin del segmento-->

        <!--Segmento de botones-->
        <div id="divBotonesRegistro" visible="false" runat="server" style="width: 50%;">
            <div id="seccion10">
                <div style="display: inline-flex; align-content: center;">
                    <asp:Button ID="btnSiguiente" runat="server" CssClass="btn-primary"
                        Text="Siguiente" BorderStyle="Solid"
                        Style="font-size: 12px; border-radius: 4px; margin-right: 10px; height: 35px; width: 90px;"
                        Font-Bold="true" />
                    <asp:Button ID="btnCancelar" runat="server" CssClass="btn-primary"
                        Text="Cancelar" BorderStyle="Solid"
                        Style="font-size: 12px; border-radius: 4px; margin-left: 10px; height: 35px; width: 90px;"
                        Font-Bold="true" />
                </div>
            </div>
        </div>
        <div>
            <table>
                <tr>
                    <td colspan="2" id="tblmensaje" runat="server" visible="false">
                        <asp:Label ID="lblMensaje" runat="server" CssClass="error" Font-Size="10pt"></asp:Label>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <!--Fin de segmento-->
    <!--Fin del Registro-->
    <!---------------------------------------------------------------------------------------------------------------------------------->
    <!--Sección de Preguntas-->

    <div id="DivPreguntas" align="center" visible="false" runat="server">

        <h3 style="color: #63AD22; margin: 0;" class="letras">Conteste las preguntas correctamente para finalizar el registro.</h3>
        <hr />
        <div class="numberlist" runat="server">
            <table>
                <tr>
                    <td class="TituloTable">Preguntas</td>
                    <td class="TituloTable">Respuestas</td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="HLPregunta1" CssClass="LetrasTable" runat="server"></asp:Label></td>
                    <td>
                        <asp:RadioButton ID="RdsiP1" Text="Si" value="V" GroupName="Pregunta1" Font-Size="13pt" runat="server" AutoPostBack="false" />
                        <asp:RadioButton ID="RdNoP1" Text="No" value="F" GroupName="Pregunta1" Font-Size="13pt" runat="server" AutoPostBack="false" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="HLPregunta2" CssClass="LetrasTable" runat="server"></asp:Label></td>
                    <td>
                        <asp:RadioButton ID="RdsiP2" Text="Si" value="V" GroupName="Pregunta2" Font-Size="13pt" runat="server" AutoPostBack="false" />
                        <asp:RadioButton ID="RdNoP2" Text="No" value="F" GroupName="Pregunta2" Font-Size="13pt" runat="server" AutoPostBack="false" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="HLPregunta3" CssClass="LetrasTable" runat="server"></asp:Label></td>
                    <td>
                        <asp:RadioButton ID="RdsiP3" Text="Si" value="V" GroupName="Pregunta3" Font-Size="13pt" runat="server" AutoPostBack="false" />
                        <asp:RadioButton ID="RdNoP3" Text="No" value="F" GroupName="Pregunta3" Font-Size="13pt" runat="server" AutoPostBack="false" /></td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="HLPregunta4" CssClass="LetrasTable" runat="server"></asp:Label></td>
                    <td>
                        <asp:RadioButton ID="RdsiP4" Text="Si" value="V" GroupName="Pregunta4" Font-Size="13pt" runat="server" AutoPostBack="false" />
                        <asp:RadioButton ID="RdNoP4" Text="No" value="F" GroupName="Pregunta4" Font-Size="13pt" runat="server" AutoPostBack="false" /></td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="HLPregunta5" CssClass="LetrasTable" runat="server"></asp:Label></td>
                    <td>
                        <asp:RadioButton ID="RdsiP5" Text="Si" value="V" GroupName="Pregunta5" Font-Size="13pt" runat="server" AutoPostBack="false" />
                        <asp:RadioButton ID="RdNoP5" Text="No" value="F" GroupName="Pregunta5" Font-Size="13pt" runat="server" AutoPostBack="false" /></td>
                </tr>
            </table>
            <hr />
            <div id="Td1" runat="server" style="text-align: center;">
                <asp:Button ID="btnAceptarPreguntas" runat="server" CssClass="btn-primary" Text="Enviar" UseSubmitBehavior="false" Style="font-size: 12px; border-radius: 4px; height: 35px; width: 90px;" BorderStyle="Solid" Font-Bold="true" />&nbsp;
                        <asp:Button ID="btnCancelarPreguntas" runat="server" Enabled="true" CssClass="btn-primary" Text="Cancelar" BorderStyle="Solid" Style="font-size: 12px; border-radius: 4px; height: 35px; width: 90px;" Font-Bold="true" />
            </div>
            <div id="Td2" runat="server">
                <asp:Label ID="lblErrorMsj" runat="server" CssClass="error" Font-Size="10pt" Visible="false" data-toggle="modal" data-target="#myModal"></asp:Label>
            </div>

            <%--<br />
            <br />
                <li>
                   
                    <fieldset class="letrasTexto">
                        <table>
                            <tr>
                                <td>
                                  
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </li>
                <li>
                  
                    <fieldset class="letrasTexto">
                        <table>
                            <tr>
                                <td>
                                 
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </li>
                <li>
                  
                    <fieldset class="letrasTexto">
                        <table>
                            <tr>
                                <td>
                                   
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </li>
                <li>
                   

                    <fieldset class="letrasTexto">
                        <table>
                            <tr>
                                <td>
                                  
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </li>
                <li>
                   
                    <fieldset class="letrasTexto">
                        <table>
                            <tr>
                                <td>
                                 
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </li>

            <table>
               

            </table>--%>
        </div>
    </div>

    <!--Inicio del Popo Up-->

    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" data-backdrop="">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="false">&times;</span></button>--%>
                    <h4 class="modal-title" id="myModalLabel">Advertencia</h4>
                </div>
                <div id="divMensajeModal" class="modal-body">
                    Las respuestas a sus preguntas no han sido satisfactorias.
                </div>
                <div class="modal-footer">
                    <button id="btnClosePopUp" runat="server" type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                    <asp:Button ID="btnResetPreguntas" CssClass="btn btn-primary" runat="server" Text="Intentar de Nuevo" />
                </div>
            </div>
        </div>
    </div>

    <!--Fin del Pop Up-->

    <div id="divIntentarNew" style="text-align: center" runat="server" visible="false">
        <asp:LinkButton Text="Intentar de nuevo" Font-Underline="true" Font-Bold="true" ForeColor="Blue" Font-Size="12px" ID="lnkintentarnew" runat="server" Visible="false" />
    </div>

    <div id="divMensaje" visible="false" align="center" runat="server">
        <fieldset style="width: 600px">
            <table width="600px">
                <tr>
                    <td align="center">
                        <br />
                        <br />
                        <asp:Label ID="lblMsgOk" runat="server" ForeColor="Blue" Font-Size="Medium" Visible="false"></asp:Label>
                        <asp:Label ID="lblBlockeoError" runat="server" CssClass="error" Font-Size="10pt" Visible="false"></asp:Label>
                        <br />
                        <br />
                    </td>
                </tr>
            </table>
        </fieldset>
    </div>
</asp:Content>
