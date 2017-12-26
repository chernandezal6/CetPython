<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusExterno.master" AutoEventWireup="false" CodeFile="RegUsuarioEmp.aspx.vb" Inherits="Reg_RegUsuarioEmp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../css/Formulario.css" rel="stylesheet" />

    <script type="text/javascript">
        $(function () {

            // Datepicker
            //j2.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));

            //j2("#ctl00_ContentPlaceHolder1_txtFechaNacimiento").datepicker($.datepicker.regional['es']);
            CambiarBotones();
            $("#ctl00_ContentPlaceHolder1_txtFechaNacimiento").datepicker();
            function CambiarBotones() {
                $("input[name='ctl00$ContentPlaceHolder1$btnAceptar']").removeClass("contact_form input, contact_form textarea");
                $("input[name='ctl00$ContentPlaceHolder1$btnAceptar']").removeClass("contact_form input");
                $("input[name='ctl00$ContentPlaceHolder1$btnCancelar']").removeClass();
                $("input[name='ctl00$ContentPlaceHolder1$btnCancelar']").removeClass();
            }            
        });

    </script>

    <style>  
    </style>


    </asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <asp:HiddenField ID="PasaporteValidar" runat="server" />
    <div class="contact_form" id="contact_form">

        <div align="center">
            <ul>
                <li>
                    <h2 style="color: black; font: bold 16pt Tahoma, Verdana, Arial;">Registro de Usuario</h2>


                </li>

            </ul>
            <span id="Todo" name="Todo" runat="server">
            <ul id="Cedulado" runat="server">

                <li>
                    <label for="txtEmail1"  class="letrasTexto">Correo Electrónico:</label>
                    <asp:TextBox ID="txtEmail1" runat="server" Font-Size="11pt" Style="margin-left: 102px;"  placeholder=""></asp:TextBox>
                    

                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                        ErrorMessage="Formato inválido" ControlToValidate="txtEmail1"
                        SetFocusOnError="True"
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
                    </asp:RegularExpressionValidator>

                </li>
                <li>
                    <label for="txtClave" class="letrasTexto">Contraseña:</label>
                    <asp:TextBox ID="txtClave" TextMode="Password" runat="server"  Width="220px" Font-Size="16pt"></asp:TextBox>
                    
                </li>
                <li>
                    <label for="txtClave3"  class="letrasTexto">Confirmar Contraseña:</label>
                    <asp:TextBox ID="txtClave3" TextMode="Password" runat="server" Width="220px"  Font-Size="16pt"></asp:TextBox>
                    
                </li>


                <li><label for="txTipoDocumento"  class="letrasTexto">Nro. de Documento:</label>
                    <table style="margin-left: 90px;">
                        <tr>                            
                            <td>
                                <asp:DropDownList ID="ddlTipoDocumento" runat="server" Width="95px" Height="30px" style="font-family:Tahoma, Verdana, Arial;"  class="letrasTexto">
                                 <asp:ListItem Value="C">Cédula </asp:ListItem>
                                 <asp:ListItem Value="P">Pasaporte</asp:ListItem>
                                </asp:DropDownList>

                            </td>
                            
                            <td><asp:TextBox ID="txtDocumento" runat="server" MaxLength="11" Width="130px" Font-Size="11pt"></asp:TextBox>
                    <asp:ImageButton ID="ImgDocumento" runat="server" ImageUrl="../images/boton-buscar.gif" cssClass="imgBuscar" AlternateText="Buscar" />
                        <asp:HiddenField ID="ValidarLupa" runat="server" Value="0"/>
                                <%--<span id="lupa1" runat="server" class="label-Blue">click para buscar</span>--%>

                            </td>
                        </tr>
                    </table>
                     
                    <asp:Label ID="lblNombreCiudadano" runat="server" CssClass="label-Blue" Style="margin-left: 0px;"></asp:Label></li>
                    
              
                 <li id="liNombre" runat="server" visible="false">
                    <label for="txtNombre"  class="letrasTexto">Nombre:</label>
                    <asp:TextBox ID="txtNombre"  runat="server" Font-Size="11pt"></asp:TextBox>
                </li>

                <li id="liApellido" runat="server" visible="false">
                    <label for="txtApellido"  class="letrasTexto">Apellido:</label>
                    <asp:TextBox ID="txtApellido"  runat="server" Font-Size="11pt"></asp:TextBox>
                </li>

                <li>
                    <label for="txtTelefono1" class="letrasTexto">Teléfono:</label>
                    <asp:TextBox ID="txtTelefono1" runat="server"  MaxLength="10" Font-Size="11pt" Style="margin-left: 100px;"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server"
                        ControlToValidate="txtTelefono1" ErrorMessage="Formato inválido, solo números"
                        ForeColor="Red"
                        SetFocusOnError="True"
                        ValidationExpression="^[0-9]*">
                    </asp:RegularExpressionValidator>
                </li>
                <li>
                    <label for="txtTelefono2"  class="letrasTexto">Teléfono secundario:</label>
                    <asp:TextBox ID="txtTelefono2" runat="server"  MaxLength="10" Font-Size="11pt" Style="margin-left: 100px;"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator6" runat="server"
                        ControlToValidate="txtTelefono2" ErrorMessage="Formato inválido, solo número"
                        ForeColor="Red"
                        SetFocusOnError="True"
                        ValidationExpression="^[0-9]*">
                    </asp:RegularExpressionValidator>
                </li>

            </ul>

            <br/>
            <table>
                <tr>
                    <td colspan="2" id="tblButton" runat="server" style="text-align: center;">
                        <asp:Button ID="btnAceptar" runat="server" CssClass="btnAceptar" Text="Aceptar" BorderStyle="Solid" Font-Bold="true" />&nbsp;
                        <asp:Button ID="btnCancelar" runat="server" CssClass="btnAceptar" Text="Cancelar" BorderStyle="Solid" Font-Bold="true"/>
                    </td>
                </tr>
                            </table>

            </span>
                            <table>
                <tr>
                    <td colspan="2" id="tblmensaje" runat="server" visible="false">
                        <asp:Label ID="lblMensaje" runat="server" CssClass="error" Font-Size="10pt"></asp:Label>
                    </td>
                </tr>

            </table>
        </div>




    </div>


</asp:Content>
