<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false"
    CodeFile="EvaluarPasaportes.aspx.vb" Inherits="Mantenimientos_EvaluarPasaportes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
    <style type="text/css">
        tr.spacer td {
            padding-bottom: 10px;
        }
    </style>


    <script type="text/javascript">

        $(function () {

            var $tabs = $("#ctl00_MainContent_tabs").tabs({
                select: function (evt, ui) {
                    var valor = $(ui.tab).attr('Req');
                    var valor2 = $(ui.tab).attr('Sol');

                }
            });

            $("#ctl00_MainContent_btnDescargar").click(function () {
                getSelectedTabIndex();
            });



            function getSelectedTabIndex() {
                $tabIndex = $tabs.tabs('option', 'selected');
                var valor = $("#ctl00_MainContent_tabs ul>li a").eq($tabIndex).attr('req');
                var valor2 = $("#ctl00_MainContent_tabs ul>li a").eq($tabIndex).attr('sol');

                $("#<%= HDRequisito.ClientID%>").val(valor);
                $("#<%= HDSolicitud.ClientID%>").val(valor2);

        }
        });
    function checkNum() {
        var carCode = event.keyCode;
        if ((carCode < 48) || (carCode > 57)) {
            event.cancelBubble = true
            event.returnValue = false;
        }
    }

    $('#theDiv').prepend('<img id="theImg" src="theImg.png" />')
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:HiddenField ID="HDRequisito" runat="server" />
    <asp:HiddenField ID="HDSolicitud" runat="server" />


    <div class="header" align="left">
        Evaluación Visual de Pasaportes<br />
    </div>
    <br />
    <asp:Label ID="lbl_error" runat="server" CssClass="error" Visible="false" Font-Size="Small"></asp:Label>
    <br />
    <asp:Label ID="Lblmsj" runat="server" CssClass="error" Visible="false"></asp:Label>
    <table>
        <div id="divDatosPasaportes" runat="server">
            <tr>
                <td>
                    <fieldset style="height: 380px;">
                        <legend>Datos Pasaportes</legend>
                        <asp:Label ID="LblNovedad" Visible="false" runat="server" CssClass="labelData"></asp:Label>
                        <table>
                            <tr>
                                <td align="right" style="width: 121px; font-size: small">Nro. Solicitud:
                                </td>
                                <td style="height: 16px">
                                    <asp:Label ID="lblSolicitud" runat="server" CssClass="labelData" Font-Size="small"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="width: 121px; font-size: small">Nro. Pasaporte:
                                </td>
                                <td style="height: 16px">
                                    <asp:Label ID="lblPasaporte" runat="server" CssClass="labelData" Font-Size="small"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="width: 117px; font-size: small">Nombres:
                                </td>
                                <td class="sel">
                                    <asp:Label ID="lblNombres" runat="server" CssClass="labelData" Font-Size="small"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="width: 121px; font-size: small">Primer Apellido:
                                </td>
                                <td style="height: 16px">
                                    <asp:Label ID="lblPrimerApellido" runat="server" CssClass="labelData" Font-Size="small"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="width: 117px; font-size: small">Segundo Apellido:
                                </td>
                                <td class="sel">
                                    <asp:Label ID="lblSegundoApellido" runat="server" CssClass="labelData" Font-Size="small"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="width: 121px; font-size: small">Sexo:
                                </td>
                                <td class="sel">
                                    <asp:Label ID="lblSexo" runat="server" CssClass="labelData" Font-Size="small"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="width: 117px; font-size: small">Fecha de Nacimiento:
                                </td>
                                <td align="left">
                                    <asp:Label ID="lblFechaNacimiento" runat="server" CssClass="labelData" Font-Size="small"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="width: 121px; font-size: small">Nacionalidad:
                                </td>
                                <td class="sel">
                                    <asp:Label ID="lblNacionalidad" runat="server" CssClass="labelData" Font-Size="small"></asp:Label>
                                </td>
                            </tr>

                            <tr>
                                <td align="right" style="width: 121px; font-size: small">Correo Electrónico:
                                </td>
                                <td class="sel">
                                    <asp:Label ID="lblEmail" runat="server" CssClass="labelData" Font-Size="small"></asp:Label>
                                </td>
                            </tr>

                            <tr>
                                <td align="right" style="width: 121px; font-size: small">Numero de Contacto:
                                </td>
                                <td class="sel">
                                    <asp:Label ID="lblNumeroContacto" runat="server" CssClass="labelData" Font-Size="small"></asp:Label>
                                </td>
                            </tr>

                            <tr>
                                <td align="right" style="width: 121px; font-size: small">Fecha de Registro:
                                </td>
                                <td class="sel">
                                    <asp:Label ID="lblFechaRegistro" runat="server" CssClass="labelData" nowrap="true"
                                        Font-Size="small"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td style="font-size: 10pt;"><%--<strong>CANTIDAD DE PASAPORTES PENDIENTES DE APROBACION:</strong> <strong>
                    <asp:Label ID="lblContador" runat="server" Style="text-align: right; color: red;"></asp:Label></strong>--%>
                    <div id="divImagenActa" runat="server">
                    </div>
                    <table>
                        <tr>
                            <td colspan="2" style="width: 600px;">
                                <div id="tabs" runat="server">
                                    <ul id="ulTabs" runat="server">
                                    </ul>
                                </div>


                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table>
                                    <tr>
                                        <td>
                                            <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" Width="89px" />
                                        </td>
                                        <td>
                                            <asp:Button ID="btnRechazar" runat="server" Text="Rechazar" Width="87px" />
                                        </td>

                                        <td>
                                            <asp:Button ID="btnDescargar" runat="server" Text="Descargar imagen" Width="91px" CssClass="dis" />
                                        </td>
                                        <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Motivo Rechazo:
                                        </td>
                                        <td colspan="1" nowrap="nowrap">
                                            <asp:DropDownList ID="ddlMotivo" runat="server" CssClass="dropDowns">
                                            </asp:DropDownList>

                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </div>
    </table>
</asp:Content>
