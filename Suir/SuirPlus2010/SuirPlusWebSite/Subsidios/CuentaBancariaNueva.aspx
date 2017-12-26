<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false"
    CodeFile="CuentaBancariaNueva.aspx.vb" Inherits="Subsidios_CuentaBancariaNueva" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
    <script src="../Script/webservices.js" type="text/javascript"></script>
    <script type="text/javascript">
        var idBanco;
        var idTipoCuenta;

        $(function () {
            $("#divConfirmarCuenta").hide();

            $("#btnActualizarCuenta").click(VerificarRNCoCedula);
            $("#btnCancelar").click(CancelarConfirmacion);
            $("#btnCancelar0").click(CancelarRegistro);
            $("#btnConfirmar").click(ConfirmarRegistro);

            $("#ddTipo_Cuentas").change(Prefijo);
            $(".ddentidadrec").change(Prefijo);

            $('#txtNumeroCuenta2').live("cut copy paste", function (e) {
                e.preventDefault();
            });
        });

        function checkItNoPaste(evt) {
            evt = (evt) ? evt : window.event;
            input = evt.target || evt.srcElement;
            input.setAttribute('maxLength', input.value.length + 1);
        }
        function Prefijo() {

            if ($(".ddentidadrec option:selected").val() == "1") {
                if ($("#ddTipo_Cuentas option:selected").val() == "1") {
                    $("#lblPrefijo").html("100-01-");
                    $("#lblPrefijo0").html("100-01-");
                }
                else {
                    $("#lblPrefijo").html("200-01-");
                    $("#lblPrefijo0").html("200-01-");
                }
            }
            else {
                $("#lblPrefijo").html("");
                $("#lblPrefijo0").html("");
            }
        }

        function CancelarConfirmacion() {
            $("#lblIdEntidadRecaudadora").html("");
            $("#lblRNCoCedulaDuenoCuenta").html("");
            $("#lblNroCuenta").html("");
            $("#lblTipoCuenta").html("");
            idTipoCuenta = "";
            idBanco = "";

            $("#divConfirmarCuenta").hide();
            $("#divNuevaCuenta").show();
        }
        function CancelarRegistro() {
            $(".ddentidadrec").val("0");
            $("#txtRNCoCedulaTitular").val("");
            $("#txtNumeroCuenta").val("");
            $("#txtNumeroCuenta2").val("");
            $("#ddTipo_Cuentas").val("2");
            idTipoCuenta = "";
            idBanco = "";

            $("#lblMensaje").html("");
        }
        function VerificarRNCoCedula() {
            var Url2 = loc + "/EsRncOCedulaInactiva";
            var data2 = '{ rnc: "' + $("#txtRNCoCedulaTitular").val() + '" }';
            var resultado;

            Util.llamarWS(Url2, data2, function (data3) {
                resultado = data3.d;

                if (resultado == 'OK') {
                    ActualizarCuentaBancaria();
                } else {
                    $("#lblMensaje").html(data3.d);
                    return true;
                }
            }, ajaxFailed);
        };
        function ActualizarCuentaBancaria() {

            $("#lblMensaje").html("");

            if ($(".ddentidadrec option:selected").text() == "Seleccione") {
                $("#lblMensaje").html("Debe seleccionar una Entidad Recaudadora");
            }
            else if ($("#txtRNCoCedulaTitular").val() == "") {
                $("#lblMensaje").html("Debe suplir la cédula del titular");
            }
            else if ($("#txtNumeroCuenta").val() == "") {
                $("#lblMensaje").html("Debe suplir el número de cuenta");
            }
            else if ($("#txtNumeroCuenta").val() != $("#txtNumeroCuenta2").val()) {
                $("#lblMensaje").html("La cuenta de confirmación no coincide con el número de cuenta digitado");
            }
            else if (ValidacionesCuenta()) {
                //si cae aqui, no cumple con las validaciones, y no se procede al grabado
                //(no se necesita codigo)
            }
            else {

                $("#lblIdEntidadRecaudadora").html($(".ddentidadrec option:selected").text());
                $("#lblRNCoCedulaDuenoCuenta").html($("#txtRNCoCedulaTitular").val());
                $("#lblNroCuenta").html($("#txtNumeroCuenta").val());
                $("#lblTipoCuenta").html($("#ddTipo_Cuentas").text());
                idTipoCuenta = $("#ddTipo_Cuentas option:selected").val();
                idBanco = $(".ddentidadrec option:selected").val();

                $("#divConfirmarCuenta").show();
                $("#divNuevaCuenta").hide();
            }
        }
        function ConfirmarRegistro() {

            $("#lblMensaje").html("");

            var Url = loc + "/RegistrarCuentaBancaria";
            var data = '{ entidadrecaudadora: "' + idBanco
                        + '", nrodocumento: "' + $("#lblRNCoCedulaDuenoCuenta").html()
                        + '", cuentabanco : "' + $("#lblNroCuenta").html()
                        + '", registropatronal: "' + $("#registropatronalCB").val()
                        + '", tipocuenta: "' + idTipoCuenta
                        + '", usuarioregistro: "' + $("#usuarioCB").val()
                        + '" }';

            Util.llamarWS(Url, data, recibirResultadoCB, ajaxFailed);
           
        }
        function recibirResultadoCB(infoCB) {
            var resultado = infoCB.d;

            if (resultado == 'OK') {
                var url;
                if (Util.GetQueryStringByName("url") == "sol") {
                    window.location = "Sol.aspx";
                }
                else if (Util.GetQueryStringByName("url") == "ef") {
                    window.location = "EnfermedadComun.aspx";
                }
            }
            else {
                $("#lblMensaje").html(infoCB.d);
            }
        }
        function ajaxFailed(xhr, ajaxOptions, thrownError) {

            alert(xhr.status);
            alert(thrownError);
            console.log(thrownError);
        }

        function ValidacionesCuenta() {

            if (!CuentaCaracteresNum($("#txtNumeroCuenta").val())) {
                $("#lblMensaje").html("Formato de cuenta incorrecto, debe contener solo caracteres numéricos!")
                return true;
            }

            switch ($(".ddentidadrec option:selected").val()) {
                case "1":
                    //Banreservas
                    if (!Cuenta10Caracteres($("#txtNumeroCuenta").val())) {
                        $("#lblMensaje").html("Formato de cuenta incorrecto, debe contener 10 caracteres numericos")
                        return true;
                    }
                    break;
                case "6":
                    //CitiBank
                    if (!Cuenta10Caracteres($("#txtNumeroCuenta").val())) {
                        $("#lblMensaje").html("Formato de cuenta incorrecto, debe contener 10 caracteres numericos")
                        return true;
                    }
                    else {
                        if ($("#ddTipo_Cuentas option:selected").val() == "2") {
                            if (!($("#txtNumeroCuenta").val().substring(0, 1) == "5")) {

                                $("#lblMensaje").html("Formato de cuenta incorrecto, las cuentas de ahorro contienen el dígito '5' en la posición resaltada, en lugar de " +
                                $("#txtNumeroCuenta").val().substring(0, 1) + ": " +
                                "<br><div>No. Cuenta= <span style='background-color:Yellow;color:Black'>" +
                                $("#txtNumeroCuenta").val().substring(0, 1) + "</span>" + $("#txtNumeroCuenta").val().substring(1, 10));

                                return true;
                            }
                        }
                    }
                    break;
                case "11":
                    //Banco del Progreso
                    if (!Cuenta10Caracteres($("#txtNumeroCuenta").val())) {
                        $("#lblMensaje").html("Formato de cuenta incorrecto, debe contener 10 caracteres numericos")
                        return true;
                    }
                    else {
                        if ($("#ddTipo_Cuentas option:selected").val() == "1") {
                            if (!($("#txtNumeroCuenta").val().substring(2, 1) == "2") || !($("#txtNumeroCuenta").val().substring(2, 1) == "1")) {
                                $("#lblMensaje").html("Formato de cuenta incorrecto, las cuentas corrientes contienen  el dígito  '1' o '2' en la posición resaltada, en lugar de " +
                                $("#txtNumeroCuenta").val().substring(2, 1) + ": " +
                                "<br><div>No. Cuenta=" + $("#txtNumeroCuenta").val().substring(0, 1) + "<span style='background-color:Yellow;color:Black'>" +
                                $("#txtNumeroCuenta").val().substring(2, 1) + "</span>" + $("#txtNumeroCuenta").val().substring(2, 10));

                                return true;
                            }
                        }
                        else {
                            if (!($("#txtNumeroCuenta").val().substring(2, 1) == "3")) {
                                $("#lblMensaje").html("Formato de cuenta incorrecto, las cuentas de ahorro contienen  el dígito '3' en la posición resaltada, en lugar de " +
                                $("#txtNumeroCuenta").val().substring(2, 1) + ": " +
                                "<br><div>No. Cuenta=" + $("#txtNumeroCuenta").val().substring(0, 1) + "<span style='background-color:Yellow;color:Black'>" +
                                $("#txtNumeroCuenta").val().substring(2, 1) + "</span>" + $("#txtNumeroCuenta").val().substring(2, 10));

                                return true;
                            }
                        }
                    }
                    break;
                case "34":
                    //Banco Santa Cruz
                    if (!Cuenta14Caracteres($("#txtNumeroCuenta").val())) {
                        $("#lblMensaje").html("Formato de cuenta incorrecto, debe contener 14 caracteres numericos")
                        return true;
                    }
                    else {
                        if ($("#ddTipo_Cuentas option:selected").val() == "1") {
                            var sc100 = ($("#txtNumeroCuenta").val().substring(4, 7) == "100");
                            var sc101 = ($("#txtNumeroCuenta").val().substring(4, 7) == "101");
                            var sc102 = ($("#txtNumeroCuenta").val().substring(4, 7) == "102");
                            var sc103 = ($("#txtNumeroCuenta").val().substring(4, 7) == "103");

                            if (!(sc100 || sc101 || sc102 || sc103)) {
                                $("#lblMensaje").html("Formato de cuenta incorrecto, las cuentas corrientes contienen  el dígito  '100' o '101' o '102' o '103' en la posición resaltada, en lugar de " +
                                $("#txtNumeroCuenta").val().substring(4, 7) + ": " +
                                "<br><div>No. Cuenta=" + $("#txtNumeroCuenta").val().substring(0, 4) + "<span style='background-color:Yellow;color:Black'>" +
                                $("#txtNumeroCuenta").val().substring(4, 7) + "</span>" + $("#txtNumeroCuenta").val().substring(7, 14));

                                return true;
                            }
                        }
                        else {
                            var sc200 = ($("#txtNumeroCuenta").val().substring(4, 7) == "200");
                            var sc500 = ($("#txtNumeroCuenta").val().substring(4, 7) == "500");

                            if (!(sc200 || sc500)) {
                                $("#lblMensaje").html("Formato de cuenta incorrecto, las cuentas de ahorro contienen  el dígito  '200' o '500' en la posición resaltada, en lugar de " +
                                $("#txtNumeroCuenta").val().substring(4, 7) + ": " +
                                "<br><div>No. Cuenta=" + $("#txtNumeroCuenta").val().substring(0, 4) + "<span style='background-color:Yellow;color:Black'>" +
                                $("#txtNumeroCuenta").val().substring(4, 7) + "</span>" + $("#txtNumeroCuenta").val().substring(7, 14));

                                return true;
                            }
                        }
                    }
                    break;
                case "36":
                    //Banco BDI
                    if (!Cuenta10Caracteres($("#txtNumeroCuenta").val())) {
                        $("#lblMensaje").html("Formato de cuenta incorrecto, debe contener 10 caracteres numericos")
                        return true;
                    }
                    else {
                        if ($("#ddTipo_Cuentas option:selected").val() == "1") {
                            var bdi404 = ($("#txtNumeroCuenta").val().substring(0, 3) == "404");
                            var bdi406 = ($("#txtNumeroCuenta").val().substring(0, 3) == "406");
                            var bdi409 = ($("#txtNumeroCuenta").val().substring(0, 3) == "409");
                            var bdi410 = ($("#txtNumeroCuenta").val().substring(0, 3) == "410");

                            if (!(bdi404 || bdi406 || bdi409 || bdi410)) {
                                $("#lblMensaje").html("Formato de cuenta incorrecto, las cuentas corrientes contienen  el dígito  '410' o '404' o '406' o '409' en la posición resaltada, en lugar de " +
                                $("#txtNumeroCuenta").val().substring(0, 3) + ": " +
                                "<br><div>No. Cuenta=<span style='background-color:Yellow;color:Black'>" +
                                $("#txtNumeroCuenta").val().substring(0, 3) + "</span>" + $("#txtNumeroCuenta").val().substring(3, 10));

                                return true;
                            }
                        }
                        else {
                            var bdi401 = ($("#txtNumeroCuenta").val().substring(0, 3) == "401");
                            var bdi407 = ($("#txtNumeroCuenta").val().substring(0, 3) == "407");

                            if (!(bdi401 || bdi407)) {
                                $("#lblMensaje").html("Formato de cuenta incorrecto, las cuentas de ahorro contienen  el dígito  '401' o '407' en la posición resaltada, en lugar de " +
                                $("#txtNumeroCuenta").val().substring(0, 3) + ": " +
                                "<br><div>No. Cuenta= <span style='background-color:Yellow;color:Black'>" +
                                $("#txtNumeroCuenta").val().substring(0, 3) + "</span>" + $("#txtNumeroCuenta").val().substring(3, 10));

                                return true;
                            }
                        }
                    }
                    break;
                case "37":
                    //Banco Leon
                    if ($("#txtNumeroCuenta").val().length == "7") {
                        $("#ddTipo_Cuentas").val("1")
                    }
                    else {
                        $("#ddTipo_Cuentas").val("2")
                    }
                    break;
            }
            return false
        }

        //regex-----------------------------------
        function Cuenta10Caracteres(cuenta) {
            if (cuenta == "") {
                return true;
            }
            var filter = /^[0-9]{10}$/;
            return filter.test(cuenta);
        }
        function Cuenta23Caracteres(cuenta) {
            if (cuenta == "") {
                return true;
            }
            var filter = /^[0-9]{23}$/;
            return filter.test(cuenta);
        }
        function Cuenta14Caracteres(cuenta) {
            if (cuenta == "") {
                return true;
            }
            var filter = /^[0-9]{14}$/;
            return filter.test(cuenta);
        }
        function CuentaCaracteresNum(cuenta) {
            if (cuenta == "") {
                return true;
            }
            var filter = /^[0-9]+$/;
            return filter.test(cuenta);
        }
        //EO-regex--------------------------------

    </script>
    <style type="text/css">
        .style1
        {
            font-weight: normal;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <input type="hidden" name="registropatronalCB" id="registropatronalCB" value="<%  Response.Write(UsrRegistroPatronal)%>" />
    <input type="hidden" name="usuarioCB" id="usuarioCB" value="<%  Response.Write(UsrRNC + UsrCedula)%>" />
    <div class="header">
        <br />
        Registro Cuenta Receptora de Reembolsos de Subsidio<br />
        <br />
        <span id="lblCuentaNovededad" class="label-Blue">"Antes de agregar esta novedad, la
            empresa debe tener una cuenta bancaria activa en el sistema."</span>
        <br />
        <br />
    </div>
    <div>
        <fieldset id="fsCuentaBancaria" style="width: 400px; height: auto;">
            <legend>Cuenta Bancaria</legend>
            <div id="divNuevaCuenta">
                <table>
                    <tr>
                        <td colspan="2">
                            <div id="divCuentaBancariaActual" style="float: left; margin-right: 10px" visible="true">
                                <br />
                                <table cellpadding="1" cellspacing="0" class="td-content" style="width: 390px;">
                                    <tr>
                                        <td>
                                            <br />
                                            Banco Múltiple
                                        </td>
                                        <td>
                                            <br />
                                            <asp:DropDownList ID="ddlEntidadRecaudadora2" runat="server" class="ddentidadrec">
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <br />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            RNC/Cédula Titular de Cuenta
                                        </td>
                                        <td>
                                            <input type="text" id="txtRNCoCedulaTitular" class="input" />
                                            &nbsp;
                                            <%--
                                            <asp:RegularExpressionValidator id="RegularExpressionValidator1" runat="server" ControlToValidate="txtRNCoCedulaTitular"
                                                Display="Dynamic" ErrorMessage="Formato de cédula o RNC inválido" ValidationExpression="^(\d{11}|\d{9})$">*</asp:RegularExpressionValidator>--%>
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Nro de Cuenta
                                        </td>
                                        <td>
                                            <span id="lblPrefijo"></span>
                                            <input type="text" id="txtNumeroCuenta" class="input" maxlength="20" />
                                            &nbsp;
                                            <%--<asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" ControlToValidate="txtNumeroCuenta"
                                                ErrorMessage="El número de cuenta es requerido" Font-Bold="True">*</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator id="regexNumber" runat="server" ControlToValidate="txtNumeroCuenta"
                                                Display="Dynamic" ErrorMessage="Formato de cuenta inválido" ValidationExpression="^[0-9]+$">*</asp:RegularExpressionValidator>--%>
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Confirmar Nro de Cuenta
                                        </td>
                                        <td>
                                            <span id="lblPrefijo0"></span>
                                            <input id="txtNumeroCuenta2" type="text" class="input" maxlength="20" />
                                            &nbsp;
                                            <%--  <asp:CompareValidator id="CompareValidator1" runat="server" ControlToCompare="txtNumeroCuenta"
                                                ControlToValidate="txtNumeroCuenta2" Display="Dynamic" 
                                                ErrorMessage="La cuenta de confirmación no coincide con el número de cuenta digitado">*</asp:CompareValidator>
                                            <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" ControlToValidate="txtNumeroCuenta2"
                                                ErrorMessage="La confirmación de la cédula es requerida" Font-Bold="True">*</asp:RequiredFieldValidator>--%>
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Tipo de Cuenta
                                        </td>
                                        <td>
                                            <select id="ddTipo_Cuentas" class="dropDowns">
                                                <option value="2">Cuenta de Ahorro</option>
                                                <option value="1">Cuenta Corriente</option>
                                            </select>
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2">
                                            &nbsp;
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                </table>
                                <br />
                            </div>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <%--<asp:ValidationSummary id="ValidationSummary1" runat="server" Font-Bold="True" HeaderText="Por favor revisar los siguientes errores:" />--%>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td class="style1" width="300">
                            <input type="button" id="btnCancelar0" value="Cancelar" />
                        </td>
                        <td width="100">
                            <input type="button" id="btnActualizarCuenta" value="Actualizar" />
                        </td>
                    </tr>
                </table>
            </div>
            <div id="divConfirmarCuenta">
                <table>
                    <tr>
                        <td>
                            <table>
                                <tr>
                                    <td colspan="2" class="subHeader">
                                        <br />
                                        Por favor confirme los datos de la cuenta:<br />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="label-Resaltado">
                                        <br />
                                        <table cellpadding="1" cellspacing="0" class="td-content" width="400" align="left">
                                            <tr>
                                                <td class="style3">
                                                    <span style="font-weight: normal">
                                                        <br />
                                                        Banco Múltiple</span>
                                                </td>
                                                <td style="margin-left: 40px" align="left">
                                                    <br />
                                                    <span id="lblIdEntidadRecaudadora" class="labelData"></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style3">
                                                    <span style="font-weight: normal">Titular de Cuenta</span>
                                                </td>
                                                <td>
                                                    <span id="lblRNCoCedulaDuenoCuenta" class="labelData"></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style3">
                                                    <span style="font-weight: normal">Nro de Cuenta</span>
                                                </td>
                                                <td>
                                                    <span id="lblNroCuenta" class="labelData"></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1">
                                                    Tipo de Cuenta
                                                </td>
                                                <td>
                                                    <span id="lblTipoCuenta" class="labelData"></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style3">
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                        <br />
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left" class="style2">
                                        <input type="button" id="btnCancelar" value="Cancelar" />
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td>
                                        <input type="button" id="btnConfirmar" value="Confirmar" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <br />
                                        <br />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </fieldset>
        <br />
        <br />
        <span id="lblMensaje" class="error"></span>
        <br />
        <br />
        <uc1:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
    </div>
</asp:Content>
