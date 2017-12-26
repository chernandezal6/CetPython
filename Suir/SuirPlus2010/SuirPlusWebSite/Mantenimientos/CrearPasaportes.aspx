<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false"
    CodeFile="CrearPasaportes.aspx.vb" Inherits="Mantenimientos_CrearPasaportes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <%--    <asp:ScriptManager EnableScriptGlobalization="true" EnableScriptLocalization="true"
        ID="ScriptManager1" runat="server" ScriptMode="Release">
    </asp:ScriptManager>--%>

    <% If 1 = 2 Then
    %>
    <link href="../App_Themes/SP/StyleSheet.css" rel="stylesheet" type="text/css" />
    <script src="../Script/Util.js" type="text/javascript"></script>
    <script src="../Script/jquery-1.5.2-vsdoc.js" type="text/javascript"></script>
    <%
    End If
    %>

    <script type="text/javascript">
        $(function () {

            $(".date").datepicker({
                dateFormat: 'dd/mm/yy',
                //defaultDate: "+1w",
                changeMonth: true,
                changeYear: true,
                numberOfMonths: 1,
                yearRange: "-100:+0"

            });


            $(".button").button();
        });

        if ($(".date").val() == "") {
            Resultado += "* La fecha de nacimiento es requerida.</br>";
        } else {
            if (!Util.ValidarFecha($(".date").val())) {
                Resultado += "* Debe ingresar una fecha de nacimiento válida.</br>";
            }
        }
    </script>
    <script language="javascript" type="text/javascript">

        function modelesswin(url) {
            //window.showModalDialog(url, "", "help:0;status:0;toolbar:0;scrollbars:0;dialogwidth:800px:dialogHeight:1300px")
            newwindow = window.open(url, "", "width=800px,height=1300px");
            newwindow.print();
        }

        function checkNum() {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false;
            }
        }

        function UploadValidate() {

            for (var i = 1; i < 11; i++) {
                var fileName = document.getElementById("ctl00_MainContent_FileUp" + i).value;
                var ext = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
                var name = fileName.substring(fileName.lastIndexOf('\\') + 1)
                if (ext != "") {
                    if (ext == "doc" || ext == "docx" || ext == "xls" || ext == "xlsx" || ext == "jpg" || ext == "jpeg" || ext == "png" || ext == "gif" || ext == "tiff" || ext == "tif" || ext == "pdf") {
                        $("#ctl00_MainContent_btnGuardar").disabled = false;
                        $("#ctl00_MainContent_lbl_error").html("")
                        $("#ctl00_MainContent_OcultaResultado").val("false");
                    }
                    else {
                        $("#ctl00_MainContent_btnGuardar").disabled = true;
                        $("#ctl00_MainContent_OcultaResultado").val("true");
                        $("#ctl00_MainContent_lbl_error").html("El Formato de archivo " + name + " desconocido.")
                        $("#ctl00_MainContent_lbl_error").css('color', 'RED');
                        break;
                    }
                }
            }

        }

        function Resultado() {
            var Booleano = $("#ctl00_MainContent_OcultaResultado").val();

            if (Booleano == "true") {
                return false;
            }
            else {
                return true;
            }
        }


    </script>

    <style>
        .Titulo {
            font-size: 15pt;
            font-weight: bold;
            color: #006699;
        }

        .SubTitulo {
            font-size: 13pt;
            font-weight: bold;
            color: #006699;
        }
    </style>
    <h2 class="Titulo">Registro de Documentos(Nombre Pendiente a Colocar)</h2>
    <asp:HiddenField ID="OcultaResultado" runat="server" Value="false" />
    <asp:Label ID="lbl_error" runat="server" CssClass="error" Font-Size="Small"></asp:Label>
    <table>
        <tr>
            <td style="width: 430px">
                <fieldset style="width: 590px">
                    <legend>Datos del Documento</legend>
                    <asp:Label ID="LblNovedad" Visible="false" runat="server" CssClass="labelData"></asp:Label>
                    <table>
                        <tr>
                            <td style="font-size: small">Tipo de Documento:</td>
                            <td>
                                <asp:DropDownList ID="ddlTipoDocumento" runat="server">
                                    <asp:ListItem Text="<--Seleccione-->" Value="-1"></asp:ListItem>
                                    <asp:ListItem Text="Pasaporte" Value="P"></asp:ListItem>
                                    </asp:DropDownList>

                            </td>
                        </tr>


                        <tr>
                            <td style="font-size: small">Nro. Documento:
                            </td>
                            <td>
                                <asp:TextBox ID="txtDocumento" runat="server" Style="font-size: small"></asp:TextBox>
                                <asp:RegularExpressionValidator runat="server" ID="RegularExpressionValidator3"
                                    ControlToValidate="txtDocumento" ErrorMessage="No se permiten caracteres especiales."
                                    ValidationExpression="^[a-zA-Z0-9ñÑáéíóúÁÉÍÓÚ]+$" />

                            </td>
                        </tr>
                        <tr>
                            <td style="font-size: small">Nombres:
                            </td>
                            <td>
                                <asp:TextBox ID="txtNombre" runat="server" Style="font-size: small"></asp:TextBox>
                                <asp:RegularExpressionValidator runat="server" ID="RegularExpressionValidator2"
                                    ControlToValidate="txtNombre" ErrorMessage="No se permiten caracteres especiales."
                                    ValidationExpression="^[a-zA-Z0-9ñÑáéíóúÁÉÍÓÚ]+$" />
                            </td>
                        </tr>
                        <tr>
                            <td style="font-size: small">Primer Apellido:
                            </td>
                            <td>
                                <asp:TextBox ID="txtApellido" runat="server" Style="font-size: small"></asp:TextBox>
                                <asp:RegularExpressionValidator runat="server" ID="ValPasaporte"
                                    ControlToValidate="txtApellido" ErrorMessage="No se permiten caracteres especiales."
                                    ValidationExpression="^[a-zA-Z0-9ñÑáéíóúÁÉÍÓÚ]+$" />
                            </td>
                        </tr>
                        <tr>
                            <td style="font-size: small">Segundo Apellido:
                            </td>
                            <td>
                                <asp:TextBox ID="txtApellido2" runat="server" Style="font-size: small"></asp:TextBox>
                                <asp:RegularExpressionValidator runat="server" ID="RegularExpressionValidator4"
                                    ControlToValidate="txtApellido2" ErrorMessage="No se permiten caracteres especiales."
                                    ValidationExpression="^[a-zA-Z0-9ñÑáéíóúÁÉÍÓÚ]+$" />
                            </td>
                        </tr>
                        <tr>
                            <td style="font-size: small">Fecha de Nacimiento:
                            </td>
                            <td>
                                <asp:TextBox ID="txtFechaNacimiento" runat="server" Style="font-size: small" CssClass="date"></asp:TextBox>
                            </td>
                        </tr>

                        <tr>
                            <td style="font-size: small">Correo Electrónico:
                            </td>
                            <td>
                                <asp:TextBox ID="TextEmail" runat="server" Style="font-size: small"></asp:TextBox>

                                <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" ErrorMessage="Formato inválido" ControlToValidate="TextEmail" SetFocusOnError="True"
                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
                                </asp:RegularExpressionValidator>
                            </td>
                        </tr>
                        <tr>
                            <td style="font-size: small">Numero de Contacto:
                            </td>
                            <td>
                                <asp:TextBox ID="TextNumeroContacto" runat="server" MaxLength="10" Style="font-size: small"></asp:TextBox>

                                <asp:RegularExpressionValidator ID="RegularExpressionValidator6" runat="server"
                                    ControlToValidate="TextNumeroContacto" ErrorMessage="Formato inválido"
                                    ForeColor="Red"
                                    SetFocusOnError="True"
                                    ValidationExpression="^[0-9]*">
                                </asp:RegularExpressionValidator>
                            </td>
                        </tr>
                        <tr>
                            <td style="font-size: small">Nacionalidad:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlNacionalidad" runat="server" Width="125px" Style="font-size: small;"
                                    CssClass="dropDowns">
                                </asp:DropDownList>
                            </td>
                        </tr>

                        <tr>
                            <td style="font-size: small">Sexo:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlSexo" runat="server" Width="125px" Style="font-size: small;"
                                    CssClass="dropDowns">
                                </asp:DropDownList>
                            </td>
                        </tr>

                        <%-- <tr>
                            <td style="font-size: small">Imagen Pasaporte:
                            </td>
                            <td>
                                <asp:FileUpload ID="upImagenPasaporte" runat="server" Style="font-size: small" />
                            </td>
                        </tr>--%>

                        <tr>
                            <td colspan="2">
                                <%-- <asp:UpdatePanel ID="upCargarArchivosEditar" runat="server" UpdateMode="Conditional" style="margin-top: 5px;">
                                    <ContentTemplate>--%>
                                <asp:GridView ID="gvCargarArchivos" runat="server" AutoGenerateColumns="False" Width="90%">
                                    <Columns>

                                        <asp:BoundField HeaderText="REQUISITOS" DataField="descripcion" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderStyle HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="OBLIGATORIO" DataField="obligatorio" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:TemplateField Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lbLRequisito" runat="server" Text='<%# Eval("ID_REQUISITO")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:FileUpload ID="upImagenes" runat="server" />
                                            </ItemTemplate>

                                            <HeaderStyle HorizontalAlign="Center" />

                                        </asp:TemplateField>

                                        <%--<asp:TemplateField HeaderText="VER ADJUNTO" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        <asp:ImageButton ID="ibDescargar" runat="server" ImageUrl="~/images/pdf.png" CommandName='<%# Eval("id_requisito")%>' />

                                                    </ItemTemplate>
                                                </asp:TemplateField>--%>
                                    </Columns>
                                </asp:GridView>

                                <%--                                    </ContentTemplate>

                                </asp:UpdatePanel>--%>
                            </td>
                        </tr>

                    </table>

                </fieldset>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Button ID="btnGuardar" runat="server" Text="Guardar" Style="font-size: 9pt;"
                    CssClass="button" />
            </td>
        </tr>
    </table>

</asp:Content>
