<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusExterno.master" AutoEventWireup="false" CodeFile="RegNuevaEmp.aspx.vb" Inherits="Reg_RegNuevaEmp" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../css/LoginAndWizard.css" rel="stylesheet" />
    <script src="../Script/RegNuevaEmpresa/FuncionesGenerales.js" type="text/javascript"></script>

    <style type="text/css">
        a {
            display: inline-block;
            max-width: 250px;
            vertical-align: middle;
        }
    </style> 
      
    <script type="text/javascript">
        $ = jQuery;

        var Ruta = "http://" + location.host + "/Reg/"
        var CodSolicitud = "";
        var IdCodSolicitud = "";
        var NumRequisitos = "";
        var FlujoPrimario = "";
        var regEmp = false;
        var Paso = "";
        var Visualizado = "";
        var User = "";
        var EmpresaReg = "";
        var StatusSol = "";
        var idStatusSol = "";
        var Comentario = "";
        var FormReady = "";

        //Seleccionar alguna solicitud del cuadro
        function Redireccionar() {
            window.location.href = Ruta + "/ConsEmp.aspx";
        }

        //Si se intenta ingresar a la pagina sin loguearse
        function RedireccionarLogin() {
            window.location.href = Ruta + "/LoginPage.aspx";
        }

        function LlamarPantallaSiguiente2() {
            $(".buttonNext").click();
            Paso = "";
            Visualizado = "";
            for (var i = 1; i < 6; i++) {
                Paso = 'step-' + i;
                $("a[href$='#" + Paso + "']").css("cursor", "DEFAULT");
                if ($("#" + Paso).css('display') == 'block') {
                    Paso = 'step-' + (i + 1);
                    Visualizado = Paso;
                    break;
                }
            }
            CargarPasos(Paso);
            estiloYvalidacion(Visualizado);
        }

        function LlamarPantallaSiguiente() {
            //Recuerda llamar a gethistoricoPasos
            //$(".buttonNext").click();
            switch ($(document).data('PasoPendiente')) {
                case 1:
                    setTimeout(function () {
                        $("#wizard").smartWizard("goToStep", 4);
                    }, 200);
                    getHistoricoDePasos($(document).data('PasoPendiente'), 'step-4');
                    break;
                case 2:
                    setTimeout(function () {
                        ActivarFinishBoton();
                        ActivarNextBoton();
                        ApagarPreviewBoton();
                        $(".buttonNext").attr("validar", "0");
                        $(".buttonNext").html("Editar");
                        $(".buttonFinish").html("Someter");
                    }, 450);
                    $("#wizard").smartWizard("goToStep", 5);
                    getHistoricoDePasos($(document).data('PasoPendiente'), 'step-5');
                    break;
                case 3:
                    setTimeout(function () {
                        ActivarFinishBoton();
                        ActivarNextBoton();
                        ApagarPreviewBoton();
                        $(".buttonNext").attr("validar", "0");
                        $(".buttonNext").html("Editar");
                        $(".buttonFinish").html("Someter");
                    }, 450);
                    $("#wizard").smartWizard("goToStep", 5);
                    getHistoricoDePasos($(document).data('PasoPendiente'), 'step-5');
                    break;
                case 4:
                    $("#wizard").smartWizard("goToStep", 5);
                    getHistoricoDePasos($(document).data('PasoPendiente'), 'step-5');
                    break;
                case 5:
                    $("#wizard").smartWizard("goToStep", 5);
                    getHistoricoDePasos($(document).data('PasoPendiente'), 'step-5');
                    break;
                default:
                    Paso = "";
                    Visualizado = "";
                    for (var i = 1; i < 7; i++) {
                        Paso = 'step-' + i;
                        $("a[href$='#" + Paso + "']").css("cursor", "DEFAULT");
                        if ($("#" + Paso).css('display') == 'block') {
                            Paso = 'step-' + (i + 1);
                            Visualizado = Paso;
                            break;
                        }
                    }
                    CargarPasos(Paso);
                    estiloYvalidacion(Visualizado);
                    break;
            }
            setTimeout(function () { RecorrerPasos(Paso); }, 500);
        }

        function ValidarSolEnProceso(usuario) {
            $('.btnIniciarNuevo').click();
        };

        function LlamarPantallaAnterior() {
            $(".buttonPrevious").click();
        }

        //Se cambia la clase que habilita los pasos del SmartWizard
        function RecorrerPasos(status) {
            numero = status.split("-");
            numero = numero[1];
            numero = parseInt(numero);
            for (var i = 1; i <= numero; i++) {
                if (i == numero) {
                    $("a[href='#step-" + numero + "']").removeClass('disabled');
                    $("a[href='#step-" + numero + "']").addClass('selected');
                }
                else {
                    $("a[href='#step-" + i + "']").removeClass('disabled');
                    $("a[href='#step-" + i + "']").removeClass('selected');
                    $("a[href='#step-" + i + "']").addClass('done');
                }
            }
        }

        function Llenarlista(Ruta, Servicio, Metodo, data, ListaID, OptionId, OptionText, defaultValue, selectedValue, CallBack, callBackFailed) {

            var R = '';
            if (Ruta == '') {
                Rt = Util.LocHost;
            } else {
                Rt = Ruta;
            }
            var d = $("#" + ListaID);
            var o = "";
            var a = "";
            var namecontrol = "";
            var namelabel = "";
            $.ajax({
                type: "POST",
                url: Rt + Servicio + "/" + Metodo,
                cache: false,
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: "json",
                success: function (data) {

                    /// Llenar el DropDown
                    d.html("");

                    /// Viene en un arreglo, deba hacerse un JSON.parse()
                    if (!isNaN(OptionId)) {
                        data.d = JSON.parse(data.d);
                    }

                    //o += 'Descripción | Obligatorio';

                    for (var i = 0; i < data.d.length; i++) {
                        var dv = "";
                        var dt = "";
                        var dy = "";
                        if (isNaN(OptionId)) {
                            dv = eval('data.d[i].' + OptionId);
                            dt = eval('data.d[i].' + OptionText);
                            dy = eval('data.d[i].' + 2);
                        }
                        else {
                            dv = eval('data.d[i][' + OptionId + ']');
                            dt = eval('data.d[i][' + OptionText + ']');
                            dy = eval('data.d[i][' + 2 + ']');
                            // Esta dentro de un arreglo, la propiedad se llama por posicion
                        }

                        if (dy == undefined) {
                            namecontrol = "chkEmp" + dv;
                            namelabel = "flat-radio-" + dv;

                            o += '<div><input id=' + namecontrol + ' type="radio" name="Paso2" class="iradio_square-blue" onclick="handleClick(this);" />'
                                + '<strong style="margin-left: 5px;">' + dt + '  ' + '</strong>'
                                + '<label for=' + namelabel + ' style="font-size: 12pt; margin-right: 50px;"></label></div>';
                            //o += '<li>' + dt + ' /></li>'
                        } else {
                            namecontrol = "chkEmp" + dv;
                            namelabel = "flat-radio-" + dv;

                            o += '<div><input id=' + namecontrol + ' type="radio" name="Paso2" class="iradio_square-blue" onclick="handleClick(this);" />'
                                + '<strong style="margin-left: 5px;">' + dt + '  ' + '</strong>'
                                + '<strong style="margin-left: 5px;">' + dy + '  ' + '</strong>'
                                + '<label for=' + namelabel + ' style="font-size: 12pt; margin-right: 50px;"></label></div>';
                            //o += '<li>' + dt + ' /></li>'

                        }
                    };
                    d.append(o);

                    /// Funcion para ejecutar
                    if (CallBack) {
                        CallBack();
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    console.error(xhr);
                    console.error(ajaxOptions);
                    console.error(thrownError);

                    if (xhr.status == "401") {
                        window.location = Util.Login;
                    }
                    callBackFailed(xhr, ajaxOptions, thrownError);
                }
            });
        }

        //Primera funcion para llamadas Post por ajax.
        function llamarServicio(Url, Metodo, data, recibirResultado, callBackFailed, sync) {
            var aSync = true;
            if (sync) {
                aSync = false;
            }
            else {
                aSync = true;
            }
            $.ajax({
                type: "POST",
                url: Url + "/" + Metodo,
                cache: false,
                contentType: "application/json; charset=utf-8",
                async: aSync,
                data: JSON.stringify(data),
                dataType: "json",
                success: recibirResultado,
                error: function (xhr, ajaxOptions, thrownError) {
                    console.error(xhr);
                    console.error(ajaxOptions);
                    console.error(thrownError);
                    if (xhr.status == "401") {
                        window.location = Util.Login;
                    }
                    if (callBackFailed) {
                        callBackFailed(xhr, ajaxOptions, thrownError);
                    }
                }
            });
        }

        //Segunda funcion para llamadas Post por ajax.
        function llamarServicio2(Url, Metodo, data, recibirResultado, callBackFailed, sync) {
            var aSync = true;
            if (sync) {
                aSync = false;
            }
            else {
                aSync = true;
            }
            var obj = Sys.Serialization.JavaScriptSerializer.serialize(data);
            $.ajax({
                type: "POST",
                url: Url + "/" + Metodo,
                cache: false,
                contentType: "application/json; charset=utf-8",
                async: aSync,
                data: obj,
                dataType: "json",
                success: recibirResultado,
                error: function (xhr, ajaxOptions, thrownError) {
                    console.error(xhr);
                    console.error(ajaxOptions);
                    console.error(thrownError);
                    if (xhr.status == "401") {
                        window.location = Util.Login;
                    }
                    if (callBackFailed) {
                        callBackFailed(xhr, ajaxOptions, thrownError);
                    }
                }
            });
        }

        //Para obtener el historico de pasos recorridos por el usuario y el ID de la clase de la empresa.
        function GetHistoricoSolicitudes(codigo) {
            var metodo = 'GetHistoricoSolicitud';
            var servicio = 'RegEmpresa.asmx';
            var rutaFinal = Ruta + servicio;
            params = { CodSol: codigo }
            llamarServicio(rutaFinal, metodo, params, function (data) {
                var info = JSON.parse(data.d);
                if (info == false) {
                    $("#MensajeVal").html('Este código de Solicitud no tiene registro, favor verificar');
                    $("#MensajeVal").addClass('error');
                }
                else {
                    info = info[0];
                    NumRequisitos = info[2];
                }
            }, '', true);
        }

        //Para validar todos los campos necesarios del formulario juntos.
        function ValidarCamposNec(NComercial, SSalarial, SEconomico, Actividad, Calle, Numero, Provincia, Municipio, Telefono1, CedulaR, Tel1R, Email) {
            
            if ((NComercial != "") && (SSalarial != "0") && (SEconomico != "0") && (Actividad != "0") && (Calle != "") && (Numero != "") && (Provincia != "0") && (Municipio != "0") && (Telefono1 != "") && (CedulaR != "") && (Tel1R != "") && (Email != "")) {
                return true;
            }
            else {
                return false;
            }
        }

        //Aquí se inserta el conteo de los pasos del usuario.
        function HistoricoDePasos(PasoActual) {
            switch (PasoActual) {
                case 'step-3':
                    $(document).data('PasoPendiente', 1);
                    setTimeout(function () {
                        $(".buttonNext").attr("validar", "1");
                    }, 1200);
                    InsertarPasos("Incompleta");

                    var metodo = 'ActualizaStatus';
                    var servicio = 'RegEmpresa.asmx';
                    var rutaFinal = Ruta + servicio;
                    params = {
                        Solicitud: CodSolicitud,
                        Status: "2"
                    }
                    llamarServicio(rutaFinal, metodo, params, function (data) {
                    }, '', true);
                    break;
                case 'step-4':
                    if ($(document).data('PasoPendiente') == 1) {

                        var cantArchivos = "";
                        var metodo = 'getCantidadDeDoc';
                        var servicio = 'RegEmpresa.asmx';
                        var rutaFinal = Ruta + servicio;
                        params = {
                            Codigo: CodSolicitud
                        }
                        llamarServicio(rutaFinal, metodo, params, function (data) {
                            var info = JSON.parse(data.d);
                            info = info[0];
                            cantArchivos = info[0];
                            console.log(cantArchivos);
                        }, '', true);

                        //Se consultan la canttidad de requisitos por esa clase de empresa
                        ClaseEmpresa(NumRequisitos);

                        if (cantArchivos == FlujoPrimario) {

                            //Se inserta el paso final (Paso 5)

                            $(document).data('PasoPendiente', 2);
                            $(".buttonNext").attr("validar", "0");
                            InsertarPasos("En Proceso");

                            //Se cambia el estatus de la solicitud cuando se haya terminado el proceso

                            var metodo = 'ActualizaStatus';
                            var servicio = 'RegEmpresa.asmx';
                            var rutaFinal = Ruta + servicio;
                            params = {
                                Solicitud: CodSolicitud,
                                Status: "1"
                            }
                            llamarServicio(rutaFinal, metodo, params, function (data) {
                            }, '', true);
                        }
                        else {
                            $(document).data('PasoPendiente', 1);
                            ActualizarHisPasos(CodSolicitud);
                            $(".buttonNext").attr("validar", "1");
                        }
                    }
                    else if ($(document).data('PasoPendiente') == 1) {

                        $(document).data('PasoPendiente', 2);
                        InsertarPasos("Incompleta");
                    }
                    break;
                case 'step-5':

                    if ($(document).data('PasoPendiente') == 1) {

                        //var cantArchivos = "";
                        //var metodo = 'getCantidadDeDoc';
                        //var servicio = 'RegEmpresa.asmx';
                        //var rutaFinal = Ruta + servicio;
                        //params = {
                        //    Codigo: CodSolicitud
                        //}
                        //llamarServicio(rutaFinal, metodo, params, function (data) {

                        //    var info = JSON.parse(data.d);
                        //    info = info[0];
                        //    cantArchivos = info[0];
                        //    console.log(cantArchivos);
                        //}, '', true);

                        ////Se consultan la canttidad de requisitos por esa clase de empresa
                        //ClaseEmpresa(NumRequisitos);

                        //if (cantArchivos == FlujoPrimario) {
                        InsertarPasos("En Proceso");
                        //Se inserta el paso final (Paso 5)

                        $(document).data('PasoPendiente', 2);
                        $(".buttonNext").attr("validar", "0");

                        //Se cambia el estatus de la solicitud cuando se haya terminado el proceso

                        var metodo = 'ActualizaStatus';
                        var servicio = 'RegEmpresa.asmx';
                        var rutaFinal = Ruta + servicio;
                        params = {
                            Solicitud: CodSolicitud,
                            Status: "1"
                        }
                        llamarServicio(rutaFinal, metodo, params, function (data) {
                        }, '', true);

                        ////}
                        ////else {
                        //    //$(document).data('PasoPendiente', 2);
                        //    //ActualizarHisPasos(CodSolicitud);
                        //    //$(".buttonNext").attr("validar", "1");
                        //}
                    }
                    else if ($(document).data('PasoPendiente') == 2) {
                        //$(document).data('PasoPendiente', 1);
                        //ActualizarHisPasos(CodSolicitud);
                    }
                    break;
            }
        }

        //Se cargan el paso donde el usuario se quedo.
        function getHistoricoDePasos(UltimoPaso, paso) {
            switch (UltimoPaso) {
                case 1:
                    Visualizado = paso;
                    CargarPasos(paso);
                    estiloYvalidacion(Visualizado);
                    break;
                case 2:
                    Visualizado = paso;
                    CargarPasos(paso);
                    estiloYvalidacion(Visualizado);
                    break;
                case 3:
                    Visualizado = paso;
                    CargarPasos(paso);
                    estiloYvalidacion(Visualizado);
                    break;
                case 4:
                    Visualizado = paso;
                    CargarPasos(paso);
                    estiloYvalidacion(Visualizado);
                    break;
                case 5:
                    Visualizado = paso;
                    CargarPasos(paso);
                    estiloYvalidacion(Visualizado);
                    break;
                default:
                    break;
            }
        }

        //Actualizar Historico de pasos.
        function ActualizarHisPasos(codigo) {
            var metodo = 'ActualizarHistoricoPasos';
            var servicio = 'RegEmpresa.asmx';
            var rutaFinal = Ruta + servicio;
            var params = { CodSol: codigo };
            llamarServicio(rutaFinal, metodo, params, function (data) {
                var info = JSON.parse(data.d);
                if (info == false) {
                }
                else {
                }
            }, '', true);
        }

        //Obtener el valor numerico del estatus de la solicitud
        function getStatusSol(nombre) {
            switch (nombre) {
                case "Incompleta":
                    idStatusSol = 2;
                    break;
                case "En,Proceso":
                    idStatusSol = 1;
                    break;
                case "Completada":
                    idStatusSol = 3;
                    break;
                case "Entregada":
                    idStatusSol = 4;
                    break;
                case "Rechazada":
                    idStatusSol = 5;
                    break;
            }
        }

        //Para obtener el comentario de la solicitud
        function CargarComentario(codigo) {
            var metodo = 'CargarComentario';
            var servicio = 'RegEmpresa.asmx';
            var rutaFinal = Ruta + servicio;
            params = {
                CodSol: codigo
            }
            llamarServicio(rutaFinal, metodo, params, function (data) {

                var info = JSON.parse(data.d);
                if (info == false) {
                    $("#MensajeVal").html('Este código de Solicitud no es valido, favor verificar');
                    $("#MensajeVal").addClass('error');
                }
                else {
                    Comentario = info[0][0];
                }
            }, '', true);
        }

        //Para obtener los pasos del historico de pasos.
        function GetHistoricoPasos(codigo, status) {
            var metodo = 'GetHistoricoPasos';
            var servicio = 'RegEmpresa.asmx';
            var rutaFinal = Ruta + servicio;
            params = {
                CodSol: codigo
            }
            llamarServicio(rutaFinal, metodo, params, function (data) {

                var info = JSON.parse(data.d);
                if (info == false) {
                    $("#MensajeVal").html('Este código de Solicitud no es valido, favor verificar');
                    $("#MensajeVal").addClass('error');
                }
                else {
                    info = info[0];
                    $(document).data('IdCod', info[2]);
                    IdCodSolicitud = $(document).data('IdCod');
                    info = info[0];
                    info = parseInt(info);
                    idStatusSol = info;
                    if (info == 1) {
                        $(document).data('PasoPendiente', 2);
                    }
                    else if (info == 2) {
                        $(document).data('PasoPendiente', 1);
                        Paso = "step-4";
                        $('.buttonNext').css('visibility', 'visible');
                        $('#hdCargarArchivos').val("Paso4");
                    }
                    else if (info == 3) {
                        $(document).data('PasoPendiente', 3);
                        Paso = "step-5";
                        $('#hdResumen').val("Paso5");
                    }
                    else if (info > 3) {
                        $(document).data('PasoPendiente', info);
                        Paso = "step-5";
                        $('#hdResumen').val("Paso5");
                    }
                }
            }, '', true);
        }

        //Se valida la cedula para el empleador.
        function RegRncCedula(rnc_o_cedula, tipoempresa) {
            var parametro = {
                empleador: rnc_o_cedula,
                tipo_empresa: tipoempresa
            };

            var metodo = 'ValidarEmpleador';
            var servivio = 'RegEmpresa.asmx';
            var rutaFinal = Ruta + servivio;
            llamarServicio(rutaFinal, metodo, parametro, function (data) {
                var info = data.d.toString().split("|");
                var resultset = info[0].split('"');

                //Se valida que resultNum no venga null o con error
                if (resultset[1].toString() === "0") {
                    EmpresaReg = resultset[2];
                }

            })
        };

        //Actualizar Pasos... no el estatus de la solicitud
        function InsertarPasos(statusSol) {
            switch (statusSol) {
                case "Rechazada":
                    var data = {
                        Nosolicitud: CodSolicitud,
                        id_TipoSolicitud: "2",
                        id_status: "5"
                    }
                    var Url2 = Ruta + "RegEmpresa.asmx/" + "InsertarHistoPasos";
                    $(document).data('data', data).serialize();
                    $.get(Url2, data, function (data) {
                    });
                    break;
                case "Entregada":
                    var data = {
                        Nosolicitud: CodSolicitud,
                        id_TipoSolicitud: "2",
                        id_status: "4"
                    }
                    var Url2 = Ruta + "RegEmpresa.asmx/" + "InsertarHistoPasos";
                    $(document).data('data', data).serialize();
                    $.get(Url2, data, function (data) {
                    });
                    break;
                case "Complatada":
                    var data = {
                        Nosolicitud: CodSolicitud,
                        id_TipoSolicitud: "2",
                        id_status: "3"
                    }
                    var Url2 = Ruta + "RegEmpresa.asmx/" + "InsertarHistoPasos";
                    $(document).data('data', data).serialize();
                    $.get(Url2, data, function (data) {
                    });
                    break;
                case "En Proceso":
                    var data = {
                        Nosolicitud: CodSolicitud,
                        id_TipoSolicitud: "2",
                        id_status: "1"
                    }
                    var Url2 = Ruta + "RegEmpresa.asmx/" + "InsertarHistoPasos";
                    $(document).data('data', data).serialize();
                    $.get(Url2, data, function (data) {
                    });
                    break;
                case "Incompleta":
                    var data = {
                        Nosolicitud: CodSolicitud,
                        id_TipoSolicitud: "2",
                        id_status: "2"
                    }
                    var Url2 = Ruta + "RegEmpresa.asmx/" + "InsertarHistoPasos";
                    $(document).data('data', data).serialize();
                    $.get(Url2, data, function (data) {
                    });
                    break;
            }
        }

        //Se continua con la solicitud pendiente.
        function ContinuarSolicitud(span, codigo, status) {

            if (status == "En,Proceso")
                status = "En Proceso";
            StatusSol = status;
            EmpresaReg = $(span.parentElement.parentElement).find(RSocial).html();
            CodSolicitud = codigo;
            ResetValues();
            GetHistoricoPasos(codigo, StatusSol);
            GetHistoricoSolicitudes(codigo);
            LlamarPantallaSiguiente();
            //RegRncCedula("#txtRazonSocial", "PR");
            setTimeout(function () {
                $("#SolEnPro").css('visibility', 'visible');
                $("#ctl00_LoginView1_Codigo").html(codigo);
                $("#Empresa").css('visibility', 'visible');
                $("#ctl00_LoginView1_EmpresaReg").html(EmpresaReg);
                $('a[href="#step-1"]').removeClass('selected');
                $('a[href="#step-1"]').addClass('done');
                $('a[href="#step-1"]').attr('isdone', '1');
                $('a[href="#step-1"]').attr('validar', '0');
                $('a[href="#step-2"]').removeClass('selected');
                $('a[href="#step-2"]').addClass('done');
                $('a[href="#step-2"]').attr('isdone', '1');
                $('a[href="#step-2"]').attr('validar', '0');
                $('a[href="#step-3"]').removeClass('selected');
                $('a[href="#step-3"]').addClass('done');
                $('a[href="#step-3"]').attr('isdone', '1');
                $('a[href="#step-3"]').attr('validar', '0');
                $('a[href="#step-4"]').removeClass('disabled');
                $('a[href="#step-4"]').addClass('selected');
                $('a[href="#step-4"]').attr('isdone', '1');
                $('a[href="#step-4"]').attr('validar', '0');
            }, 200);
        }

        //Validar el codigo de la solicitud...        
        function ValidarCod(codigo) {
            $(document).data('Cod', codigo);
            CodSolicitud = $("#txtCodSolicitud").val();
            var metodo = 'ValidarCodigoSolicitud';
            var servicio = 'RegEmpresa.asmx';
            var rutaFinal = Ruta + servicio;
            llamarServicio(rutaFinal, metodo, codigo, function (data) {
                var info = JSON.parse(data.d);
                if (info == false) {
                    $("#MensajeVal").html('Este código de Solicitud no existe, favor verificar');
                    $("#MensajeVal").addClass('error');
                }
                else {
                    GetHistoricoPasos(codigo);
                    GetHistoricoSolicitudes(codigo);
                }
            }, '', false);
        }

        //Se reinician algunas variables fundamentales.
        function ResetValues() {
            NumRequisitos = "";
            FlujoPrimario = "";
            Paso = "";
            Visualizado = "";
            User = "";
            $(document).data('PasoPendiente', 0);
        }

        //Se envian los parametros para cargar el Jqgrid
        function Grid(Servicio, Metodo, TableId, PagerId, ColNames, ColModel, Params, Caption, CantidadFilas, onSelectRow, Ancho) {

            Servicio = Servicio + "RegEmpresa.asmx" + "/";
            var filas = 8;
            var altura = 30;
            var ancho = 550;

            if (CantidadFilas) {
                filas = CantidadFilas;
                if (CantidadFilas < 26) {
                    altura = 170;
                }
            }

            if (Ancho) {
                ancho = Ancho;
            }

            function getInfo(a) {

                Params.pCurrentPage = a.page;
                //console.log(Params);
                $.ajax({

                    url: Servicio + "/" + Metodo,
                    data: JSON.stringify(Params),
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        $("#" + TableId)[0].addJSONData(JSON.parse(data.d));
                    }
                });
            }

            $("#" + TableId).jqGrid({
                //url: Url,
                datatype: getInfo,
                colNames: ColNames,
                colModel: ColModel,
                rowNum: filas,
                //rowList: [10, 25, 50, 100],

                pager: '#' + PagerId,
                sortname: 'id',
                viewrecords: true,
                sortorder: "desc",
                caption: Caption,
                jsonReader: { repeatitems: false },
                width: ancho,
                height: 'auto',
                enableSearch: false,
                onSelectRow: onSelectRow,
                altRows: true,
                loadComplete: function () {
                    $(".ui-jqgrid-bdiv").css('height', $("#" + TableId).css('height'));
                }

            });

            $("#" + TableId).jqGrid('navGrid', '#' + PagerId, { edit: false, add: false, del: false, refresh: true });

            //Remove the grid search table
            $(".ui-pg-div").remove();

            //Remove the div titlebar
            $('.ui-jqgrid-titlebar').remove();

            //Color Alternado para las Filas
            $("#" + TableId + " tbody").removeClass('ui-widget-content').addClass('AltRowClass');

            //Color para el jqgridtitlebar
            $('.ui-jqgrid-hbox').removeClass('ui-state-default').addClass('JqGridTitleBar');
            $('.ui-jqgrid-hbox table thead tr th').removeClass('ui-state-default').addClass('JqGridTitleBar');
            //Color para el jqgridpager
            $('#' + PagerId).removeClass('ui-state-default').addClass('JqGridPager');
            $("#" + TableId).trigger("reloadGrid");
        }

        //Se usa para llenar los dropdown del formulario
        function LlenarDropDown(Servicio, Metodo, data, DropDownId, OptionId, OptionText, defaultValue, selectedValue, CallBack, callBackFailed) {

            var d = $("#" + DropDownId);
            var o = "";
            var s = "";
            var v = "";
            $.ajax({
                type: "POST",
                url: Ruta + Servicio + "/" + Metodo,
                cache: false,
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(data),
                dataType: "json",
                success: function (data) {
                    /// valor seleccionado
                    if (selectedValue) {
                        if (selectedValue == 0) {
                            s = "";
                            v = "selected";
                        }
                        else {
                            s = "selected";
                            v = "";
                        }
                    }
                    else {
                        s = "";
                        v = "selected";
                    }

                    /// Llenar el DropDown
                    d.html("");

                    /// Viene en un arreglo, deba hacerse un JSON.parse()
                    if (!isNaN(OptionId)) {
                        data.d = JSON.parse(data.d);
                    }

                    for (var i = 0; i < data.d.length; i++) {

                        var dv = "";
                        var dt = "";

                        if (isNaN(OptionId)) {
                            dv = eval('data.d[i].' + OptionId);
                            dt = eval('data.d[i].' + OptionText);
                        }
                        else {
                            dv = eval('data.d[i][' + OptionId + ']');
                            dt = eval('data.d[i][' + OptionText + ']');
                            /// Esta dentro de un arreglo, la propiedad se llama por posicion
                        }

                        var f = "";

                        if (s == "selected") {
                            if (selectedValue == dv) { f = "selected"; } else { f = ""; }
                        }
                        o += '<option value="' + dv + '" ' + f + '>' + dt + '</option>';

                    };
                    d.append(o);

                    /// Opcion por defecto
                    if ((defaultValue != null) && (defaultValue != false) && (typeof defaultValue != "undefined")) {
                        d.append('<option value="0" ' + v + '>' + defaultValue + '</option>');
                    }

                    /// Funcion para ejecutar
                    if (CallBack) {
                        CallBack();
                    }

                },
                error: function (xhr, ajaxOptions, thrownError) {
                    console.error(xhr);
                    console.error(ajaxOptions);
                    console.error(thrownError);

                    if (xhr.status == "401") {
                        window.location = Util.Login;
                    }
                    callBackFailed(xhr, ajaxOptions, thrownError);
                }
            });
        }

        //Se carga el formulario para ser editado
        function TraerFormulario(CodSol) {
            var metodo = 'getInfoEmpresa';
            var servivio = 'RegEmpresa.asmx';
            var rutaFinal = Ruta + servivio;
            var params = { CodSol: CodSol };
            llamarServicio(rutaFinal, metodo, params, function (data) {

                var info = data.d.toString().split('"');
                PrepararFormulario2(info);
            }, function (callback) { console.log("Estoy haciendo PostBack"); }, true);
        }

        //Se cargan todos los campos del formulario con los datos del usuario para ser editado
        function PrepararFormulario2(Campos) {
            
            desbloquearYhabilitar()
            CargarProvincias();
            CargarSectoresSalariales();
            CargarActividad();
            CargarSectorEconomico();
            CargarTipoZonaFranca();

            if (Campos[1].toString() != "null") {
                $("#txtRazonSocial").val(Campos[1])
            } else if (Campos[1].toString() == "") {
                $("#txtRazonSocial").val(Campos[1])
            }
            else {
                $("#txtRazonSocial").val("");
            }

            if (Campos[3].toString() != "null") {
                $("#txtNombreComercial").val(Campos[3]);
            }
            else if (Campos[3].toString() == "") {
                $("#txtNombreComercial").val(Campos[3]);
            }
            else {
                $("#txtNombreComercial").val("");
            }

            //Esto es para cargar asignarlos el valor de los dropdowns una ves cargados...
            setTimeout(function () {
                if (Campos[5].toString() != "null") {
                    $("#ddlSectorSalarial").val(Campos[5])
                } else if (Campos[5].toString() == "") {
                    $("#ddlSectorSalarial").val(Campos[5])
                }
                else {
                    $("#ddlSectorSalarial").val("");
                }

                if (Campos[7].toString() != "null") {
                    $("#ddlSectorEconomico").val(Campos[7])
                } else if (Campos[7].toString() == "") {
                    $("#ddlSectorEconomico").val(Campos[7])
                }
                else {
                    $("#ddlSectorEconomico").val("");
                }

                if (Campos[9].toString() != "null") {
                    $("#ddlActividad").val(Campos[9]);
                }
                else if (Campos[9].toString() == "") {
                    $("#ddlActividad").val(Campos[9]);
                }
                else {
                    $("#ddlActividad").val("");
                }

                if (Campos[11].toString() != "null") {
                    $("#ddlTipoZonaFranca").val(Campos[11]);
                }
                else if (Campos[11].toString() == "") {
                    $("#ddlTipoZonaFranca").val(Campos[11]);
                }
                else {
                    $("#ddlTipoZonaFranca").val("");
                }

                if (Campos[13].toString() != "null") {
                    $("#ddlParque").val(Campos[13]);
                }
                else if (Campos[13].toString() == "") {
                    $("#ddlParque").val(Campos[13]);
                }
                else {
                    $("#ddlParque").val("");
                }

                if (Campos[23].toString() != "null") {
                    $("#ddlProvincia").val(Campos[23]);
                }
                else if (Campos[23].toString() == "") {
                    $("#ddlProvincia").val(Campos[23]);
                }
                else {
                    $("#ddlProvincia").val("0");
                }

                if (Campos[25].toString() != "null") {
                    CargarMunicipio(Campos[23]);
                    setTimeout(function () { $("#ddlMunicipio").val(Campos[25]); }, 300);
                }
                else if (Campos[25].toString() == "") {
                    CargarMunicipio(Campos[23]);
                    setTimeout(function () { $("#ddlMunicipio").val(Campos[25]); }, 300);

                }
                else {
                    $("#ddlMunicipio").val("0");
                }
            }, 3300);

            if (Campos[15].toString() != "null") {
                $("#txtCalle").val(Campos[15]);
            }
            else if (Campos[15].toString() == "") {
                $("#txtCalle").val(Campos[15]);
            }
            else {
                $("#txtCalle").val("");
            }

            if (Campos[17].toString() != "null") {
                $("#txtNumero").val(Campos[17]);
            }
            else if (Campos[17].toString() == "") {
                $("#txtNumero").val(Campos[17]);
            }
            else {
                $("#txtNumero").val("");
            }

            if (Campos[19].toString() != "null") {
                $("#txtApartamento").val(Campos[19]);
            }
            else if (Campos[19].toString() == "") {
                $("#txtApartamento").val(Campos[19]);
            }
            else {
                $("#txtApartamento").val("");
            }

            if (Campos[21].toString() != "null") {
                $("#txtSector").val(Campos[21]);
            }
            else if (Campos[21].toString() == "") {
                $("#txtSector").val(Campos[21]);
            }
            else {
                $("#txtSector").val("");
            }

            if (Campos[27].toString() != "null") {
                $("#txtTel1").val(Campos[27]);
            }
            else if (Campos[27].toString() == "") {
                $("#txtTel1").val(Campos[27]);
            }
            else {
                $("#txtTel1").val("");
            }

            if (Campos[29].toString() != "null") {
                $("#txtExt1").val(Campos[29]);
            }
            else if (Campos[29].toString() == "") {
                $("#txtExt1").val(Campos[29]);
            }
            else {
                $("#txtExt1").val("");
            }

            if (Campos[31].toString() != "null") {
                $("#txtTel2").val(Campos[31]);
            }
            else if (Campos[31].toString() == "") {
                $("#txtTel2").val(Campos[31]);
            }
            else {
                $("#txtTel2").val("");
            }

            if (Campos[33].toString() != "null") {
                $("#txtExt2").val(Campos[33]);
            }
            else if (Campos[33].toString() == "") {
                $("#txtExt2").val(Campos[33]);
            }
            else {
                $("#txtExt2").val("");
            }

            if (Campos[35].toString() != "null") {
                $("#Fax").val(Campos[35]);
            }
            else if (Campos[35].toString() == "") {
                $("#Fax").val(Campos[35]);
            }
            else {
                $("#Fax").val("");
            }

            if (Campos[37].toString() != "null") {
                $("#txtEmail").val(Campos[37]);
            }
            else if (Campos[37].toString() == "") {
                $("#txtEmail").val(Campos[37]);
            }
            else {
                $("#txtEmail").val("");
            }

            if (Campos[39].toString() != "null") {
                $("#txtRepresentante").val(Campos[39]);
            }
            else if (Campos[39].toString() == "") {
                $("#txtRepresentante").val(Campos[39]);
            }
            else {
                $("#txtRepresentante").val("");
            }
            BuscarRep();

            if (Campos[41].toString() != "null") {
                $("#txtRepTel1").val(Campos[41]);
            }
            else if (Campos[41].toString() == "") {
                $("#txtRepTel1").val(Campos[41]);
            }
            else {
                $("#txtRepTel1").val("");
            }

            if (Campos[43].toString() != "null") {
                $("#txtRepExt1").val(Campos[43]);
            }
            else if (Campos[43].toString() == "") {
                $("#txtRepExt1").val(Campos[43]);
            }
            else {
                $("#txtRepExt1").val("");
            }

            if (Campos[45].toString() != "null") {
                $("#txtRepTel2").val(Campos[45]);
            }
            else if (Campos[45].toString() == "") {
                $("#txtRepTel2").val(Campos[45]);
            }
            else {
                $("#txtRepTel2").val("");
            }

            if (Campos[47].toString() != "null") {
                $("#txtRepExt2").val(Campos[47]);
            }
            else if (Campos[47].toString() == "") {
                $("#txtRepExt2").val(Campos[47]);
            }
            else {
                $("#txtRepExt2").val("");
            }

            //Se activa el dropdown del municipio cuando se cambia una provincia
            $("#ddlProvincia").change(function () {
                var pro = $("#ddlProvincia").val();
                if (pro != '0') {
                    $("#ddlMunicipio").show();
                    CargarMunicipio(pro);
                }
                else {
                    $("#ddlMunicipio").hide();
                }
            });

            //Función para accionar el checkBox de Zona Franca
            $("#ChkEsZonaFranca").change(function () {
                var ver = this.checked;
                if (ver == true) {
                    $("#TrZona").show();
                    $("#EsZonaFranca").val("S");
                }
                else {
                    $("#EsZonaFranca").val("N");
                    $("#TrZona").hide();

                    $("#ddlTipoZonaFranca").val('0');
                    $("#ddlParque").val('0');
                }
            });
        }

        //Valida la Empresa
        function ValidarRncCedula(rnc_o_cedula, tipoempresa) {

            var parametro = {
                empleador: rnc_o_cedula,
                tipo_empresa: tipoempresa
            };

            var metodo = 'ValidarEmpleador';
            var servivio = 'RegEmpresa.asmx';
            var rutaFinal = Ruta + servivio;
            llamarServicio(rutaFinal, metodo, parametro, function (data) {
                
                var info = data.d.toString().split("|");
                var resultset = info[0].split('"');
                EmpresaReg = info[2];
                //Se valida que resultNum no venga null o con error
                if (resultset[1].toString() === "0") {
                    FormReady = "Ready";
                    $(".buttonNext").mouseover(validaciones());
                    PrepararFormulario(info);
                    ActivarNextBoton();
                    ApagarPreviewBoton();
                    //setTimeout(function () {  }, 200);
                }
                else {
                    $("#trMensaje").show();
                    $("#lbMensaje").html(info[1]);
                    $("#txtRNC_O_Cedula").val("");
                }
            }, function (callback) { }, true);

            //Se reinicia el ddProvincia al buscar otra provincia (evento change del ddProvincia)
            $("#ddlProvincia").change(function () {
                var pro = $("#ddlProvincia").val();
                if (pro != '0') {
                    $("#ddlMunicipio").show();
                    CargarMunicipio(pro);
                }
                else {
                    $("#ddlMunicipio").hide();
                }
            });

            //Función para accionar el checkBox de Zona Franca
            $("#ChkEsZonaFranca").change(function () {
                var ver = this.checked;
                if (ver == true) {
                    $("#TrZona").show();
                    $("#EsZonaFranca").val("S");
                }
                else {
                    $("#EsZonaFranca").val("N");
                    $("#TrZona").hide();

                    $("#ddlTipoZonaFranca").val('0');
                    $("#ddlParque").val('0');
                }
            });
        }

        //Accion del boton btnBuscarRep para buscar el representante en la BD
        function BuscarRep() {
            var Params = {
                cedula_o_pasaporte: $("#txtRepresentante").val(),
                documento: $("#ddlRepresentante").val()
            };
            ValidarRepresentante(Params);
        }

        //Valida el Representante
        function ValidarRepresentante(Parametro) {
            var metodo = 'ValidarRepresentante';
            var servivio = 'RegEmpresa.asmx';
            var rutaFinal = Ruta + servivio;
            llamarServicio(rutaFinal, metodo, Parametro, function (data) {
                var info = data.d.toString().split("|");
                var resultset = info[0].split('"');
                if (resultset[1].toString() === "0") {
                    $("#lblNombreRepresentante").html(info[1] + " " + info[2]);
                    $("#TrMensajeRep").show();
                    $("#TrMensajeRepError").hide();
                }
                else {
                    $("#TrMensajeRepError").show();
                    $("#TrMensajeRep").hide();
                    $("#lblErrorRepresentante").html(info[1]);
                    $("#lblNombreRepresentante").val("");
                    $("#lblNombreRepresentante").val("");
                }
            });
        }

        //Se cargan los datos del empleador cuando el mismo está en DGI
        function PrepararFormulario(Campos) {
            $("#trMensaje").hide();

            if (Campos[2].toString() != "null") {
                $("#txtRazonSocial").val(Campos[2])
            } else if (Campos[2].toString() == "") {
                $("#txtRazonSocial").val(Campos[2])
            }
            else {
                $("#txtRazonSocial").val("");
            }

            if (Campos[3].toString() != "null") {
                $("#txtNombreComercial").val(Campos[3]);
            }
            else if (Campos[3].toString() == "") {
                $("#txtNombreComercial").val(Campos[3]);
            }
            else {
                $("#txtNombreComercial").val("");
            }

            if (Campos[4].toString() != "null") {
                $("#txtCalle").val(Campos[4]);
            }
            else if (Campos[4].toString() == "") {
                $("#txtCalle").val(Campos[4]);
            }
            else {
                $("#txtCalle").val("");
            }

            if (Campos[5].toString() != "null") {
                $("#txtNumero").val(Campos[5]);
            }
            else if (Campos[5].toString() == "") {
                $("#txtNumero").val(Campos[5]);
            }
            else {
                $("#txtNumero").val("");
            }

            if (Campos[6].toString() != "null") {
                $("#txtEdificio").val(Campos[6]);
            }
            else if (Campos[6].toString() == "") {
                $("#txtEdificio").val(Campos[6]);
            }
            else {
                $("#txtEdificio").val("");
            }

            if (Campos[7] != "null") {
                $("#txtPiso").val(Campos[7]);
            }
            else if (Campos[7].toString() == "") {
                $("#txtPiso").val(Campos[7]);
            }
            else {
                $("#txtPiso").val("");
            }

            if (Campos[8].toString() != "null") {
                $("#txtApartamento").val(Campos[8]);
            }
            else if (Campos[8].toString() == "") {
                $("#txtApartamento").val(Campos[8]);
            }
            else {
                $("#txtApartamento").val("");
            }

            if (Campos[9].toString() != "null") {
                $("#txtExt1").val(Campos[9]);
            }
            else if (Campos[9].toString() == "") {
                $("#txtExt1").val(Campos[9]);
            }
            else {
                $("#txtExt1").val("");
            }

            if (Campos[10].toString() != "null") {
                $("#txtEmail").val(Campos[10]);
            }
            else if (Campos[10].toString() == "") {
                $("#txtEmail").val(Campos[10]);
            }
            else {
                $("#txtEmail").val("");
            }

            if (Campos[11].toString() != "null") {
                $("#ddlMunicipio").val(Campos[11]);
            }
            else if (Campos[11].toString() == "") {
                $("#ddlMunicipio").val(Campos[11]);
            }
            else {
                $("#ddlMunicipio").val("");
            }

            if (Campos[12].toString() != "null") {
                $("#ddlProvincia").val(Campos[12]);
            }
            else if (Campos[12].toString() == "") {
                $("#ddlProvincia").val(Campos[12]);
            }
            else {
                $("#ddlProvincia").val("");
            }
            CargarProvincias();
            CargarSectoresSalariales();
            CargarActividad();
            CargarSectorEconomico();
            CargarTipoZonaFranca();
        }

        //Dropdown de provincias
        function CargarProvincias() {
            var Params2 = {};
            LlenarDropDown('RegEmpresa.asmx', 'getProvincias', Params2, 'ddlProvincia', '0', '1', "Seleccione", null, function () {
                var pro = $("#ddlProvincia").val();
                if (pro != '0') {
                    CargarMunicipio(pro);
                }
                else {
                    $("#ddlMunicipio").val('0');
                }
            });
        }

        //Dropdown de Municipios
        function CargarMunicipio(Provincia, municipio) {
            var Params3 = {
                idProvincia: Provincia
            };
            LlenarDropDown('RegEmpresa.asmx', 'getMunicipios', Params3, 'ddlMunicipio', '0', '1', "Seleccione", municipio, function () {
                $("#ddlMunicipio").find("option[value='777']").remove();
            },
            function () {
                CargarProvincias();
            });
        }

        //Dropdown de SectorSalarial
        function CargarSectoresSalariales() {
            var Params4 = {};
            LlenarDropDown('RegEmpresa.asmx', 'getSectoresSalariales', Params4, 'ddlSectorSalarial', '0', '1', "Seleccione", null, null);
        };

        //Dropdown de Actividad
        function CargarActividad() {
            var Params5 = {};
            LlenarDropDown('RegEmpresa.asmx', 'getActividad', Params5, 'ddlActividad', '0', '1', "Seleccione", null, null);
        }

        //Dropdown de SectorEconomico
        function CargarSectorEconomico() {
            var Params6 = {};
            LlenarDropDown('RegEmpresa.asmx', 'getSectorEconomico', Params6, 'ddlSectorEconomico', '0', '1', "Seleccione", null, null);
        }

        //Dropdown de Tipo de Zona Franca
        function CargarTipoZonaFranca() {
            var Params7 = {};
            LlenarDropDown('RegEmpresa.asmx', 'getParqueZonaFranca', Params7, 'ddlParque', '0', '1', "Seleccione", null, null);
        }

        //Aquí se analiza el Status
        function CheckStatus(codigo, status) {

            if (status == "En Proceso")
                status = "En,Proceso";
            status = status.toString();
            CodSolicitud = codigo;
            switch (status) {
                case "Incompleta":
                    InsertarPasos("Incompleta");
                    return "</td><td class='Cuerpo'><span class='btnContinuar' id='btnContinuar' onclick=ContinuarSolicitud(this" + ",'" + codigo + "','" + status + "')>Continuar</span></></td></tr>";
                    break;
                case "En,Proceso":
                    InsertarPasos("En Proceso");
                    return "</td><td class='Cuerpo'><span class='btnContinuar' id='btnContinuar' onclick=ContinuarSolicitud(this" + ",'" + codigo + "','" + status + "')>Ver Resumen</span></></td></tr>";
                    break;
                case "Completada":
                    InsertarPasos("Completada");
                    return "</td><td class='Cuerpo'><span class='Evaluando' id='btnContinuar'>En Evaluación</span></></td></tr>";
                    break;
                case "Entregada":
                    InsertarPasos("Entregada");
                    return "</td><td class='Cuerpo'><span class='btnContinuar' id='btnContinuar' onclick=ContinuarSolicitud(this" + ",'" + codigo + "','" + status + "')>Aprobada</span></></td></tr>";
                    break;
                case "Rechazada":
                    InsertarPasos("Rechazada");
                    return "</td><td class='Cuerpo'><span class='btnContinuar' id='btnContinuar' onclick=ContinuarSolicitud(this" + ",'" + codigo + "','" + status + "')>Rechazada</span></></td></tr>";
                    break;
                default:
                    return "</td><td class='Cuerpo'><span class='btnContinuar' id='btnContinuar' >?????</span></></td></tr>";
                    break;
            }
        }

        //Para cambiar el Status de Entregada
        function ChangeStatus(status) {
            switch (status) {
                case "Entregada":
                    return "Enviada";
                    break;
                default:
                    return status;
                    break;
            }
        }

        //Llamar desde el inicio el servicio que activa la carga de solicitudes
        function TraerSolicitudes(Cedula) {
            //var query = window.location.search.substring(1);
            if (Cedula == null) {
                window.location.href = Ruta + "/LoginPage.aspx";
            }
            var metodo = 'getSolEnProceso';
            var servicio = 'RegEmpresa.asmx';
            var rutaFinal = Ruta + servicio;
            params = {
                Usuario: Cedula
            }
            llamarServicio(rutaFinal, metodo, params, function (data) {
                
                var info = JSON.parse(data.d);
                if (info.length == 0) {
                    $("#laTabla").hide();
                    $("#Titulo").hide();
                    $("#Raya").hide();
                }
                else {
                    for (var i = 0; i < info.length; i++) {
                        Solicitudes = "<tr id='Sol' class='Headers'><td class='Cuerpo'>" + info[i][0] +
                            "</td><td class='Cuerpo' style='width: 230px'>" + info[i][1] +
                            "</td><td class='Cuerpo' id='RSocial'>" + info[i][3] +
                            "</td><td class='Cuerpo'>" + info[i][2] +
                            "</td><td class='Cuerpo'>" + ChangeStatus(info[i][4]) +
                            "</td><td class='Cuerpo'>" + info[i][5] +
                            CheckStatus(info[i][0], info[i][4]);
                        $(".TablaSol").append(Solicitudes);
                    }
                    $("#solicitud").removeClass("p");
                    $("#solicitud").addClass("NoSolicitudes");

                    if ($(".MarcoSolicitud").find("#solicitud").length != 0) {
                        $("#Div2").hide();
                        $("#Div2").display = "none";
                    }
                    else {
                        $("#Div1").hide();
                        $("#Div1").display = "none";
                    }
                }
            }, '', true);
        }

        //Para pulsar el boton enter
        function EnterBoton(event) {
            if (event.which == 13 || event.keyCode == 13) {
                //code to execute here
            }
        };

        $(function () {
            ApagarFinishBoton();
            TraerSolicitudes($("#ctl00_ContentPlaceHolder1_hdUsuario").val());
            var Params = {};

            Llenarlista(Ruta, "RegEmpresa.asmx", "ListarEmpresas", Params, "listadoEmpresas", '0', '1', "Seleccione", null, function () { }, 1);

            //Boton Next de los controles inferiores
            $(".buttonNext").click(function () {
                debugger;
                $("a[href$='#step-1']").css("cursor", "DEFAULT");
                if (FormReady == "Ready") {
                    if ((regEmp == true) && (ValidarCamposNec($('#txtNombreComercial').val(),
                            $('#ddlSectorSalarial').val(), $('#ddlSectorEconomico').val(),
                            $('#ddlActividad').val(), $('#txtCalle').val(), $('#txtNumero').val(),
                            $('#ddlProvincia').val(), $('#ddlMunicipio').val(), $('#txtTel1').val(),
                            $("#txtRepresentante").val(), $("#txtRepTel1").val(), $("#txtEmail").val()) == true)) {

                        EmpresaReg = $("#txtRazonSocial").val();
                        validaciones();
                        HistoricoDePasos(Paso);
                        setTimeout(function () {
                            $("#wizard").smartWizard("goToStep", 4);
                            $("#SolEnPro").css('visibility', 'visible');
                            $("#ctl00_LoginView1_Codigo").html(CodSolicitud);
                            $("#Empresa").css('visibility', 'visible');
                            $("#ctl00_LoginView1_EmpresaReg").html(EmpresaReg);
                        }, 850);
                        getHistoricoDePasos($(document).data('PasoPendiente'), 'step-4');

                        $("#txtCodSol").val(CodSolicitud);
                        $("#idsolicitud").val($(document).data('IdCod'));
                        $("#txtIdCodSol").val($(document).data('IdCod'));
                        $("#step-3").css('display', 'none');
                    }
                    else if (((regEmp == false) && (ValidarCamposNec($('#txtNombreComercial').val(),
                            $('#ddlSectorSalarial').val(), $('#ddlSectorEconomico').val(),
                            $('#ddlActividad').val(), $('#txtCalle').val(), $('#txtNumero').val(),
                            $('#ddlProvincia').val(), $('#ddlMunicipio').val(), $('#txtTel1').val(),
                            $("#txtRepresentante").val(), $("#txtRepTel1").val(), $("#txtEmail").val()) == false)) || ((regEmp == true))
                            && (ValidarCamposNec($('#txtNombreComercial').val(),
                            $('#ddlSectorSalarial').val(), $('#ddlSectorEconomico').val(),
                            $('#ddlActividad').val(), $('#txtCalle').val(), $('#txtNumero').val(),
                            $('#ddlProvincia').val(), $('#ddlMunicipio').val(), $('#txtTel1').val(),
                            $("#txtRepresentante").val(), $("#txtRepTel1").val(), $("#txtEmail").val()) == false)) {

                        $(".buttonNext").attr("validar", "1");
                        document.getElementById("Revisar").innerHTML = "Complete los campos necesarios para continuar:";
                        document.getElementById("lblMensaje").innerHTML = validaciones();
                    }
                }
                else {
                    switch ($(document).data('PasoPendiente')) {
                        case 1:
                            var SINumbers = $('table#ctl00_ContentPlaceHolder1_gvCargaArchivo tbody td:nth-child(2):contains(SI)').length;
                            var ImgNumbers = $('table#ctl00_ContentPlaceHolder1_gvCargaArchivo tbody td:nth-child(3) img').length;
                            if ((SINumbers > ImgNumbers) && ((SINumbers != 0) || (ImgNumbers != 0))) {
                                $(".buttonNext").attr("validar", "1");
                                document.getElementById('divUploadMessage').innerHTML = '<span style=\"color:#ff0000\">Debe cargar los archivos que son Obligatorios.</span>';
                                document.getElementById('divUploadMessage').style.display = '';
                            }
                            else {
                                var NONumbers = $('table#ctl00_ContentPlaceHolder1_gvCargaArchivo tbody td:nth-child(2):contains(NO)').length;
                                if ((NONumbers > 0) && (SINumbers == 0))
                                    getHistoricoDePasos($(document).data('PasoPendiente'), 'step-5');
                                else {
                                    ValidarArcObligatorios(SINumbers);
                                    $(".buttonFinish").removeClass("buttonDisabled");
                                }
                            }
                            break;

                        case 2:
                            var SINumbers = $('table#ctl00_ContentPlaceHolder1_gvCargaArchivo tbody td:nth-child(2):contains(SI)').length;
                            var ImgNumbers = $('table#ctl00_ContentPlaceHolder1_gvCargaArchivo tbody td:nth-child(3) img').length;
                            if ((SINumbers > ImgNumbers) && ((SINumbers != 0) || (ImgNumbers != 0))) {
                                $(".buttonNext").attr("validar", "1");
                                document.getElementById('divUploadMessage').innerHTML = '<span style=\"color:#ff0000\">Debe cargar los archivos que son Obligatorios.</span>';
                                document.getElementById('divUploadMessage').style.display = '';
                            }
                            else if ($("#step-5").css('display') == 'block') {
                                CargarPasos("step-6");
                                estiloYvalidacion("step-6");
                            }
                            else if (SINumbers == 0) {
                                getHistoricoDePasos($(document).data('PasoPendiente'), 'step-5');
                            }
                            break;

                        case 3:

                            break;
                        default:
                            Paso = "";
                            Visualizado = "";
                            for (var i = 1; i < 7; i++) {
                                Paso = 'step-' + i;
                                $("a[href$='#" + Paso + "']").css("cursor", "DEFAULT");
                                if ($("#" + Paso).css('display') == 'block') {
                                    Paso = 'step-' + (i + 1);
                                    Visualizado = Paso;
                                    break;
                                }
                            }
                            CargarPasos(Paso);
                            estiloYvalidacion(Visualizado);
                            break;
                    }
                }
            });

            //Boton para retroceder...
            $(".buttonPrevious").click(function () {
                
                var Paso = "";
                var Visualizado = "";
                for (var i = 1; i < 7; i++) {
                    Paso = 'step-' + i;
                    if ($("#" + Paso).css('display') == 'block') {
                        $("#hdPaso").val(Paso);
                        Visualizado = Paso;
                    }
                }
                if (Visualizado == "step-2") {
                    setTimeout(function () {
                        $(".NoSolicitudes").removeClass("buttonDisabled");
                        $(".NoSolicitudes").removeClass("DivSelect");
                        $('.buttonNext').css('visibility', 'hidden');
                    }, 100);
                }
                if (Visualizado == "step-6") {
                    if (ValidarCamposNec($('#txtNombreComercial').val(),
                            $('#ddlSectorSalarial').val(), $('#ddlSectorEconomico').val(),
                            $('#ddlActividad').val(), $('#txtCalle').val(), $('#txtNumero').val(), $('#ddlProvincia').val(), $('#ddlMunicipio').val(),
                            $('#txtTel1').val()) == true) {

                        EmpresaReg = $("#txtRazonSocial").val();
                        validaciones2();
                        ActualizarDatosEmpresa();
                        setTimeout(function () {
                            $("#SolEnPro").css('visibility', 'visible');
                            $("#ctl00_LoginView1_Codigo").html(CodSolicitud);
                            $("#Empresa").css('visibility', 'visible');
                            $("#ctl00_LoginView1_EmpresaReg").html(EmpresaReg);

                            ActivarFinishBoton();
                            ActivarNextBoton();
                            ApagarPreviewBoton();
                            getHistoricoDePasos($(document).data('PasoPendiente'), 'step-5');
                        }, 150);
                    }
                    else if (((regEmp == false) && (ValidarCamposNec($('#txtNombreComercial').val(),
                            $('#ddlSectorSalarial').val(), $('#ddlSectorEconomico').val(),
                            $('#ddlActividad').val(), $('#ddlProvincia').val(), $('#ddlMunicipio').val(),
                            $('#txtTel1').val()) == false)) || ((regEmp == true)) && (ValidarCamposNec($('#txtNombreComercial').val(),
                            $('#ddlSectorSalarial').val(), $('#ddlSectorEconomico').val(),
                            $('#ddlActividad').val(), $('#ddlProvincia').val(), $('#ddlMunicipio').val(),
                            $('#txtTel1').val()) == false)) {

                        $(".buttonPrevious").attr("validar", "1");
                        document.getElementById("Revisar").innerHTML = "Complete los campos necesarios para continuar:";
                        document.getElementById("lblMensaje").innerHTML = validaciones();
                    }
                }
            });

            //Boton para finalizar el registro de empresa
            $(".buttonFinish").click(function () {

                if (idStatusSol < 3) {
                    var metodo = 'ActualizaStatus';
                    var servicio = 'RegEmpresa.asmx';
                    var rutaFinal = Ruta + servicio;
                    params = {
                        Solicitud: CodSolicitud,
                        Status: "3"
                    }
                    llamarServicio(rutaFinal, metodo, params, function (data) {
                        $("#SolEnPro").css('visibility', 'hidden');
                    }, '', true);

                    //Este se queda así por el momento debido al reload
                    var data = {
                        Nosolicitud: CodSolicitud,
                        id_TipoSolicitud: "   2",
                        id_status: "3"
                    }
                    var Url2 = Ruta + "RegEmpresa.asmx/" + "InsertarHistoPasos";
                    $(document).data('data', data).serialize();
                    $.get(Url2, data, function (data) {
                        window.location.reload();
                    });
                }
                else if ((idStatusSol >= 3) && (idStatusSol <= 5)) {
                    window.location.reload();
                }
            });
        });

        //Valida si los archivos obligatorios han sido cargados
        function ValidarArcObligatorios(numSi) {
            var fila = '';
            var count = 0;
            for (var i = 0; i < numSi; i++) {
                fila = $('table#ctl00_ContentPlaceHolder1_gvCargaArchivo tbody td:nth-child(2):contains(SI):eq(' + i + ')').parent().children().eq(2);
                if (fila.find($("img"))[0] != undefined) {
                    count++;
                }
                else {
                    document.getElementById('divUploadMessage').innerHTML = '<span style=\"color:#ff0000\">Debe cargar los archivos que son Obligatorios.</span>';
                    document.getElementById('divUploadMessage').style.display = '';
                    i = 10;
                }
                if (count == numSi) {
                    getHistoricoDePasos($(document).data('PasoPendiente'), 'step-5');
                }
            }
        }

        //Aqui se actualizan los datos de la empresa
        function ActualizarDatosEmpresa() {
            //var mensajeCompletarDatos = $("#mensajeCompletarDatos");
            $("#txtIdCodSol").val(IdCodSolicitud);
            var Url2 = Ruta + "RegEmpresa.asmx/" + "ActualizarDatosEmpresa";
            var data = $('#DatoEmpresas').serialize();
            $.get(Url2, data, function (data) {
            });
        }

        //Funcion para validar los archivos no obligatorios
        function Nobligatorios() {
            if ($('table#ctl00_ContentPlaceHolder1_gvCargaArchivo tbody td:nth-child(2):contains(SI)').length == 0) {
                if ($('table#ctl00_ContentPlaceHolder1_gvCargaArchivo tbody td:nth-child(2):contains(NO)').length > 0) {
                    $(".buttonNext").attr("validar", "0");
                }
            }
        }
        
        //Se cargan los estilos y algunas validaciones de la ventena 
        function estiloYvalidacion(panelActual) {
            switch (panelActual) {
                case "step-1":
                    CargarEstilo("step-1", "Menu3", "Menu2");
                    CargarSolPen("PanelDeSolicitudes.html", "");
                    break;

                case "step-2":
                    setTimeout(function () {

                        Visualizado = "step-2";
                        $("#TrZona").hide();
                        $("input[name='Paso2']").click(function () {
                            $('#divCrearSol').css('visibility', 'visible');
                            var n = this.id;
                            var resultado = "";
                            resultado = n.substring(6, 7);

                            $("#hdEmpSeleccionada").val(resultado);
                            $("#ctl00_ContentPlaceHolder1_EmpSeleccionada").val(resultado);

                            /*CARGA DE PREREQUISITOS*/
                            var Params = {
                                pPageSize: 35,
                                pCurrentPage: 1,
                                pCriterio: $("#hdEmpSeleccionada").val(),
                                pSortColumn: '',
                                pSortOrder: ''
                            };
                            var ColNames = ['Requisitos', 'Obligatorio'];
                            var ColModel = [
                                { name: '0', index: '0', sortable: false, width: 15, align: "justify" },
                                { name: '1', index: '1', sortable: false, width: 5, align: "center" }
                            ];
                            $('#gvEmpresas').jqGrid('GridUnload');
                            Grid(Ruta, 'MostrarRequisitos', 'gvEmpresas', null, ColNames, ColModel, Params, 'gvEmpresas', 25);

                            $(".ui-jqgrid .ui-jqgrid-bdiv").attr("overflow", "none");
                            /*FIN DE LA CARGA DE PREREQUISITOS*/
                        });
                    }, 100);
                    break;

                case "step-3":
                    if ($("#step-3").css('display') != 'block')
                        $("#step-3").css('display', 'block')
                    if ($('#hdSolVerificada').val() == "paso3") {
                        CargarEstilo("step-3", "Menu3", "Menu2");
                        CargarFormulario("FormularioReg.html", "");
                    }
                    
                    ApagarNextBoton();
                    ActivarPreviewBoton();
                    setTimeout(function () {
                        $(".buttonPrevious").attr("validar", "0");
                        $("#txtRNC_O_Cedula").keyup(SoloNumeros);
                        $("#txtRepresentante").keyup(SoloNumeros);
                        $("#txtRepTel1").keyup(SoloNumeros);
                        $("#txtRepTel2").keyup(SoloNumeros);
                        $("#txtRepExt1").keyup(SoloNumeros);
                        $("#txtRepExt2").keyup(SoloNumeros);
                        $("#txtTel1").keyup(SoloNumeros);
                        $("#txtTel2").keyup(SoloNumeros);
                        $("#txtExt1").keyup(SoloNumeros);
                        $("#txtExt2").keyup(SoloNumeros);
                        $("#Fax").keyup(SoloNumeros);
                    }, 500);
                    break;

                case "step-4":
                    if ($('#hdCargarArchivos').val() == "paso4") {
                        FormReady = "";
                        CargarEstilo("step-4", "Menu3", "Menu2");
                        $("#hdEmpSeleccionada").val(NumRequisitos);
                        ApagarPreviewBoton();
                        $("#ctl00_ContentPlaceHolder1_EmpSeleccionada").val(NumRequisitos);
                        $("#ctl00_ContentPlaceHolder1_CodsolicitudServer").val(CodSolicitud);
                        $("#ctl00_ContentPlaceHolder1_idsolicitudServer").val(IdCodSolicitud);
                        $("#ctl00_ContentPlaceHolder1_btnMostrarRequisitos").click();
                        //HistoricoDePasos('step-4');
                        $(".buttonNext").attr("validar", "1");
                        $(".buttonNext").mouseover();
                    }
                    break;

                case "step-5":
                    if ($('#hdResumen').val() == "paso5") {
                        debugger;
                        //-------- Inventando una manera de Sincronizar la Asincronización --------//                        
                        var A = function () { $("#wizard").smartWizard("goToStep", 5); }
                        var B = function () { CargarEstilo("step-5", "Menu3", "Menu2"); }
                        var C = function () { CargarResumen("PanelDeResumen.html", ""); }                        
                        
                        var Cadena = function(funcion1,funcion2,funcion3) {
                            var A = funcion1;
                            var B = funcion2;
                            var C = funcion3;
                            A();
                            B();
                            C();
                        };
                        Cadena(A, B, C);
                        //---------------------------------- FIN ---------------------------------//
                                             

                        var metodo = 'getResumenEmp';
                        var servicio = 'RegEmpresa.asmx';
                        var rutaFinal = Ruta + servicio;
                        var Params = {
                            CodSol: CodSolicitud
                        };
                        $("#ctl00_ContentPlaceHolder1_CodsolicitudServer").val(CodSolicitud);
                        $("#ctl00_ContentPlaceHolder1_idsolicitudServer").val(IdCodSolicitud);
                        setTimeout(function () {
                            if (CodSolicitud != "") {
                                llamarServicio(rutaFinal, metodo, Params,
                                        function (result) {
                                            debugger;
                                            var info = result.d.toString().split("[[");
                                            info = info[1].split("]]");
                                            resultset = info[0].split(',');
                                            CargaResumen(resultset);
                                            HistoricoDePasos(Visualizado);
                                            $('.buttonNext').css('visibility', 'visible');
                                            MostrarMensajeRepresentante(idStatusSol);
                                        }, function (data) {
                                            console.log("Estoy en PostBack!");
                                        }, '', true);
                            }
                        }, 200);                        
                    }
                    break;

                case "step-6":

                    if ($("#step-6").css('display') != 'block') {
                        $("#step-6").css('display', 'block');
                    }
                    if ($('#hdEditar').val() == "paso6") {
                        CargarEstilo("step-6", "Menu3", "Menu2");
                        EditarFormulario("FormularioReg.html", "");
                        ActivarPreviewBoton();
                        $(".buttonPrevious").html("Guardar");
                        ApagarNextBoton();
                        ApagarFinishBoton();
                        $('#hdSolVerificada').val("");
                        $("#contenidoFormulario").empty();
                        $("#CodsolicitudServer").val();
                        $("#ctl00_ContentPlaceHolder1_btnCargarEditados").click();
                        $("#ctl00_ContentPlaceHolder1_btnCargarEditados").hide();

                        setTimeout(function () {
                            TraerFormulario(CodSolicitud);
                            $("#cedula").hide();
                        }, 800);
                    }
                    break;
            }
        }

        //Se despliega el mensaje del representate sobre la solicitud
        function MostrarMensajeRepresentante(status) {
            switch (status) {
                case 4:
                    $(".MarcoFinal").css("display", "none");
                    ActivarFinishBoton();
                    ApagarNextBoton();
                    ApagarPreviewBoton();
                    $(".buttonFinish").html("Regresar");
                    $("#PanelResumen div:nth-child(1) div div").empty();
                    $("#PanelResumen div:nth-child(1) div div").append("Estado del Registro de Empresa");
                    $("#PanelResumen div:nth-child(1) div p").empty();
                    CargarComentario(CodSolicitud);
                    $("#PanelResumen div:nth-child(1) div p").append("<span class='MsjRepresentante1'>Solicitud Aprobada</span></br></br>" + "</br>" +  Comentario + ".");
                    break;
                case 5:
                    $(".MarcoFinal").css("display", "none");
                    ActivarFinishBoton();
                    ApagarNextBoton();
                    ApagarPreviewBoton();
                    $(".buttonFinish").html("Regresar");
                    $("#PanelResumen div:nth-child(1) div div").empty();
                    $("#PanelResumen div:nth-child(1) div div").append("Estado del Registro de Empresa");
                    $("#PanelResumen div:nth-child(1) div p").empty();
                    CargarComentario(CodSolicitud);
                    $("#PanelResumen div:nth-child(1) div p").append("<span class='MsjRepresentante2'>Solicitud Rechazada</span></br></br>" + "</br>" + Comentario + ".");
                    break;
                default:
                    ActivarNextBoton();
                    ActivarFinishBoton();
                    ApagarPreviewBoton();
                    $(".buttonNext").attr("validar", "0");
                    $(".buttonNext").html("Editar");
                    $(".buttonFinish").html("Someter");
                    break;
            }
        }

        //Se carga el contenido o cuerpo de la pagina mediante el div hdPaso
        function CargarPasos(Countpaso) {
            switch (Countpaso) {
                case 'step-1':
                    break;
                case 'step-2':
                    $("#hdPaso").val(Paso);
                    Visualizado = Paso;
                    break;
                case 'step-3':
                    Paso = "step-3";
                    $("#hdPaso").val(Paso);
                    $("#hdSolVerificada").val("paso3");
                    Visualizado = Paso;
                    break;

                case 'step-4':
                    Paso = "step-4";
                    $("#hdPaso").val(Paso);
                    $("#hdCargarArchivos").val("paso4");
                    document.getElementById("step-3").disabled = true;
                    Visualizado = Paso;
                    break;

                case 'step-5':
                    Paso = "step-5";
                    $("#hdPaso").val(Paso);
                    $("#hdResumen").val("paso5");
                    Visualizado = Paso;
                    break;

                case 'step-6':
                    Paso = "step-6";
                    $("#hdPaso").val(Paso);
                    $("#hdEditar").val("paso6");
                    Visualizado = Paso;
                    break;
            }
        }

        //Se manejan los checkeds de los requisitos para enviar la cantidad de archivos que se requeriran del usuario
        function handleClick(myRadio) {
            if (myRadio.id == "chkEmp3") {
                FlujoPrimario = 7;
                NumRequisitos = 3;
                ActivarNextBoton();
            }
            else if (myRadio.id == "chkEmp4") {
                FlujoPrimario = 5;
                NumRequisitos = 4;
                ActivarNextBoton();
            }
            else if (myRadio.id == "chkEmp5") {
                FlujoPrimario = 4;
                NumRequisitos = 5;
                ActivarNextBoton();
            }
            else if (myRadio.id == "chkEmp6") {
                FlujoPrimario = 3;
                NumRequisitos = 6;
                ActivarNextBoton();
            }
            else if (myRadio.id == "chkEmp2") {
                FlujoPrimario = 5;
                NumRequisitos = 2;
                ActivarNextBoton();
            }
            else if (myRadio.id == "chkEmp1") {
                FlujoPrimario = 4;
                NumRequisitos = 1;
                ActivarNextBoton();
            }
        }

        function getBase64FromImageUrl(URL) {
            var img = new Image();
            img.src = URL;
            img.onload = function () {
                var canvas = document.createElement("canvas");
                canvas.width = this.width;
                canvas.height = this.height;
                var ctx = canvas.getContext("2d");
                ctx.drawImage(this, 0, 0);
                var dataURL = canvas.toDataURL("image/png");
                alert(dataURL.replace(/^data:image\/(png|jpg);base64,/, ""));
            }
        }

        //Se genera el codigo de validacion del cliente
        function GenerarSolicitud() {

            User = $("#ctl00_ContentPlaceHolder1_hdUsuario").val();
            var metodo = 'GenerarCodigo';
            var servicio = 'RegEmpresa.asmx';
            var rutaFinal = Ruta + servicio;
            if (User != "") {
                var params = {
                    ClaseEmpresa: NumRequisitos,
                    Usuario: User,
                    RNC_o_Cedula: $("#txtRNC_O_Cedula").val()
                };
            }
            else {
                var params = {
                    ClaseEmpresa: NumRequisitos,
                    Usuario: User,
                    RNC_o_Cedula: $("#txtRNC_O_Cedula").val()
                };
            }
            llamarServicio(rutaFinal, metodo, params,
                function (result) {

                    var info = result.d.toString().split("|");
                    resultset = info[1].split('"');
                    resultset = resultset[0];
                    $(document).data("IdCod", resultset);
                    IdCodSolicitud = $(document).data("IdCod");
                    resultset = info[0].split('"');
                    resultset = resultset[1];
                    $(document).data("Cod", resultset);
                    CodSolicitud = $(document).data("Cod");

                    document.getElementById("MensajeCodSol").innerHTML = "Su numero de solicitud es: ";
                    document.getElementById("CodSol").innerHTML = CodSolicitud;
                    $("#txtCodSol").val(CodSolicitud);
                    $("#idsolicitud").val(IdCodSolicitud);
                    $("#txtIdCodSol").val(IdCodSolicitud);
                },
                function (data) {
                    var info = JSON.parse(data.d);
                    CodSolicitud = info;
                    var Params = { codsol: info };
                    ValidarCod(Params);
                }, true);
        }

        //Se registra la nueva empresa en la BD
        function Registrar() {
            var mensajeCompletarDatos = $("#mensajeCompletarDatos");
            var Url2 = Ruta + "RegEmpresa.asmx/" + "InsertarEmpleadorTMP";
            var data = $('#DatoEmpresas').serialize();
            $.get(Url2, data, function (data) {
                $('.buttonNext').click();
            });
        }

        //Accion del boton btnBuscar para buscar al empleador en la BD
        function Buscar() {
            var campo = $("#txtRNC_O_Cedula").val();
            if (campo.length == 11) {
                campo = parseInt(campo);
                if (typeof campo == 'number') {
                    var Params = {
                        empleador: $("#txtRNC_O_Cedula").val(),
                        tipo_empresa: "PR"
                    };

                    var parametro = {
                        Rnc_o_Cedula: Params.empleador
                    };

                    var metodo = 'ValidarSolEnProceso';
                    var servivio = 'RegEmpresa.asmx';
                    var rutaFinal = Ruta + servivio;
                    llamarServicio(rutaFinal, metodo, parametro, function (data) {

                        var info = data.d.toString().split("|");
                        var resultset = info[0].split('"');

                        //Se valida que resultNum no venga null o con error
                        if (resultset[1].toString() === "0") {
                            ValidarRncCedula(Params.empleador, Params.tipo_empresa);

                            //$("#ctl00_ContentPlaceHolder1_idsolicitudServer").val($(document).data('Cod'));
                            regEmp = true;
                        }
                    }, function (callback) {
                        var inf = callback.responseText.split(":");
                        inf = inf[1].split('"');
                        var res = inf[1].split("|");
                        if (res[0].toString() === "1") {
                            $("#trMensaje").show();
                            $("#lbMensaje").html(res[1]);
                            $("#txtRNC_O_Cedula").val("");
                        }
                    }, true);
                }
                else {
                    $("#trMensaje").show();
                    $("#lbMensaje").html("El documento insertado no es valido.");
                }
            }
            else {
                $("#trMensaje").show();
                $("#lbMensaje").html("El documento insertado no es valido.");
            }
            document.getElementById("ddlSectorSalarial").disabled = false;
            document.getElementById("ddlSectorEconomico").disabled = false;
            document.getElementById("ddlActividad").disabled = false;
            document.getElementById("ddlProvincia").disabled = false;
            document.getElementById("ddlMunicipio").disabled = false;
            document.getElementById("ddlTipoZonaFranca").disabled = false;
            document.getElementById("ddlParque").disabled = false;
        }

        //Acción que recarga el iframe para enviar nuevamente el requisito
        function EditarArchivo(boton) {
            
            var InputIframe = $(boton).parent().find("iframe").css("display", "block");
            $(boton).parent().find("iframe").contents().find("input#hdPropiedad").val("ACTUALIZAR");
            $(boton).parent().find("img").remove();
            $(boton).parent().find("scan").remove();
            $(boton).parent().find("iframe").contents().find("#btnUpload").attr("validar", "1");
            $(boton).parent().find("input#btnReCargar").detach();
        }

        //Validando la existencia de la extension del archivo
        function ExisteExtension(fileName, MensajeError) {
            
            if (fileName.indexOf(".") != -1) {
                var fileSeparate = fileName.split(".");
                var Ext = fileSeparate.length - 1;
                Ext = fileSeparate[Ext];
                return ValidarExt(Ext, MensajeError);
            }
            else {
                MensajeError.innerHTML = '<span style=\"color:#ff0000\">Archivo con formato invalido. Observe en el recuadro de abajo los Archivos validos.</span>';
                MensajeError.style.display = 'block';
                return false;
            }
        }

        //Validando la extensión adecuada (.jpg|.JPG|.gif|.GIF|.png|.PNG|.tiff|.TIFF|.tif|.TIF|.pdf|.PDF|.doc|.DOC|.docx|.DOCX|.xls|.XLS|.xlsx|.XLSX|)
        function ValidarExt(Ext, MensajeError) {
            switch (Ext) {
                case 'jpg':
                    return true;
                    break;
                case 'JPG':
                    return true;
                    break;
                case 'gif':
                    return true;
                    break;
                case 'GIF':
                    return true;
                    break;
                case 'png':
                    return true;
                    break;
                case 'PNG':
                    return true;
                    break;
                case 'tiff':
                    return true;
                    break;
                case 'TIFF':
                    return true;
                    break;
                case 'tif':
                    return true;
                    break;
                case 'TIF':
                    return true;
                    break;
                case 'pdf':
                    return true;
                    break;
                case 'PDF':
                    return true;
                    break;
                case 'doc':
                    return true;
                    break;
                case 'DOC':
                    return true;
                    break;
                case 'docx':
                    return true;
                    break;
                case 'DOCX':
                    return true;
                    break;
                case 'xls':
                    return true;
                    break;
                case 'XLS':
                    return true;
                    break;
                case 'xlsx':
                    return true;
                    break;
                case 'XLSX':
                    return true;
                    break;
                default:
                    MensajeError.innerHTML = '<span style=\"color:#ff0000\">Archivo con formato invalido. Observe en el recuadro de abajo los Archivos validos.</span>';
                    MensajeError.style.display = 'block';
                    return false;
                    break;
            }
        }

        //Elementos que aparecen cuando los archivos cargan correctamente
        function goodFile(frame) {
            frame.style.display = 'none';
            $(frame).parent().append("<scan style='font: bold 10px arial'>Archivo cargado satisfactoriamente!</scan>");
            $(frame).parent().append("<img style='margin-left: 10px;' src='/images/check.png' alt='' />");

            if ($("#step-4").css('display') == 'block') {
                            $(frame).parent().append("<input id='btnReCargar' name='btnReCargar' type='button' value='Editar' " +
                "style='margin-left: 5px;' onclick='EditarArchivo(this)'/>");
            }

            $("#imagen").display = 'block';
        }

        //Validar que los archivos obligatorios esten cargados.
        function Obligatorios() {
            var SINumbers = $('table#ctl00_ContentPlaceHolder1_gvCargaArchivo tbody td:nth-child(2):contains(SI)').length;
            var ImgNumbers = $('table#ctl00_ContentPlaceHolder1_gvCargaArchivo tbody td:nth-child(3) img').length;
            if ((SINumbers > ImgNumbers) && ((SINumbers != 0) || (ImgNumbers != 0))) {
                $(".buttonNext").attr("validar", "1");
            }
            else {

                var fila = '';
                var count = 0;
                for (var i = 0; i < SINumbers; i++) {
                    fila = $('table#ctl00_ContentPlaceHolder1_gvCargaArchivo tbody td:nth-child(2):contains(SI):eq(' + i + ')').parent().children().eq(2);
                    if (fila.find($("img"))[0] != undefined) {
                        count++;
                    }
                    else {
                    }
                    if (count == SINumbers) {
                        $(".buttonNext").attr("validar", "0");
                    }
                }
            }
        }

        /*UPLOAD UTILIZADO EN LA PAGINA*/
        var _divUploadMessage;

        function initPhotoUpload(frame) {

            _divUploadMessage = frame.contentWindow.document.getElementById('divUploadMessage');
            var btnUpload = frame.contentWindow.document.getElementById('btnUpload');

            //Botón para subir las imagenes
            btnUpload.onclick = function (event) {

                frame.contentWindow.document.getElementById('filPhoto');
                _divUploadMessage = document.getElementById('divUploadMessage');
                _divUploadMessage.style.display = 'none';

                if (frame.contentWindow.document.getElementById('filPhoto').value.length == 0) {
                    _divUploadMessage.innerHTML = '<span style=\"color:#ff0000\">Especificar el Archivo.</span>';
                    _divUploadMessage.style.display = '';
                    frame.focus();
                    return;
                }

                //var regExp = /^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w].*))(.jpg|.JPG|.gif|.GIF|.png|.PNG|.tiff|.TIFF|.tif|.TIF|.pdf|.PDF|.doc|.DOC|.docx|.DOCX|.xls|.XLS|.xlsx|.XLSX|)$/;

                if (ExisteExtension($(frame.contentWindow.document.getElementById('filPhoto')).val().split("\\").pop(), _divUploadMessage) == false) //Somehow the expression does not work in Opera
                {
                    frame.focus();
                    return;
                }

                if ($(document).data('PasoPendiente') == 1) {
                    HistoricoDePasos('step-4');
                }
                else {
                    ActualizarHisPasos(CodSolicitud);
                }

                
                if ($("#step-6").css('display') == 'block') {
                    $(frame.contentWindow.document.getElementById('btnUpload')).attr("validar",'1');
                }

                
                if ($(frame.contentWindow.document.getElementById('btnUpload')).attr("validar") == "0") {
                    $(frame.contentWindow.document.getElementById('hdPropiedad')).val("INSERTAR");


                    frame.contentWindow.document.getElementById('photoUpload').submit(function () {
                        //frame.style.display = 'none';
                        //$(frame).parent().append("<img id='imgCargando' style='margin-left: 10px; with: 16px; height: 16px;' src='/images/loadingred.gif' alt='' />");
                        //$(frame).parent().append("<img style='margin-left: 10px;' src='/images/check.png' alt='' />");
                        //$(frame).parent().append("<scan style='font: bold 10px arial'>Cargado...</scan>");
                        //$("#imgCargando").show();
                        //$(frame.contentWindow.document.getElementById('btnUpload')).attr("validar", "1");
                    });
                } else if ($(frame.contentWindow.document.getElementById('btnUpload')).attr("validar") == "1") {
                    $("#ctl00_ContentPlaceHolder1_NombreArchivo").val($(frame.contentWindow.document.getElementById('filPhoto')).val().split("\\").pop());
                    $(frame.contentWindow.document.getElementById('hdPropiedad')).val("ACTUALIZAR");
                    frame.contentWindow.document.getElementById('photoUpload').submit();
                }

                goodFile(frame);
                Obligatorios();
            }
            Nobligatorios();
        }

        function RegRncCedula(rnc_o_cedula, tipoempresa) {

            var parametro = {
                empleador: rnc_o_cedula,
                tipo_empresa: tipoempresa
            };

            var metodo = 'ValidarEmpleador';
            var servivio = 'RegEmpresa.asmx';
            var rutaFinal = Ruta + servivio;
            llamarServicio(rutaFinal, metodo, parametro, function (data) {

                var info = data.d.toString().split("|");
                var resultset = info[0].split('"');

                //Se valida que resultNum no venga null o con error
                if (resultset[1].toString() === "0") {
                    empresaReg = resultset[2];
                }

            })
        };

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <input type="hidden" id="hdPaso" value="step-1" />
    <input type="hidden" id="hdEmpSeleccionada" />
    <input type="hidden" id="hdSolVerificada" />
    <input type="hidden" id="hdCargarArchivos" />
    <input type="hidden" id="hdResumen" />
    <input type="hidden" id="hdEditar" />
    <asp:HiddenField ID="EmpSeleccionada" runat="server" />
    <asp:HiddenField ID="CodsolicitudServer" runat="server" />
    <asp:HiddenField ID="idsolicitudServer" runat="server" />
    <asp:HiddenField ID="NombreArchivo" runat="server" />
    <input type="hidden" id="idsolicitud" name="idsolicitud" />
    <input type="hidden" id="id_TipoSolicitud" name="id_TipoSolicitud" />
    <input type="hidden" id="id_status" name="id_status" />
    <input type="hidden" id="idrequisito" name="idrequisito" runat="server" />

    <asp:HiddenField ID="ValidarCargaArchivo" runat="server" Value="0" />
    <asp:HiddenField ID="hdUsuario" runat="server" />

    <%--Valores capturados para el insert--%>
    <input type="hidden" id="nssRepresentante" name="nssRepresentante" />
    <%--<input type="hidden" id="EsZonaFranca" name="EsZonaFranca" value="" />--%>
    <%--<input type="hidden" id="RepresentanteNotificacion" name="RepresentanteNotificacion" />--%>

    <%-- <img src="../images/logoTSShorizontal.gif" />--%>

    <div style="text-align: center">
        <h2 class="Titulos">Registro de Empresas</h2>
    </div>
    <table align="center" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <div id="wizard" class="swMain">
                    <ul class="anchor">
                        <li><a href="#step-1" class="done" isdone="0" rel="1" validar="null">
                            <label class="stepNumber">1</label><span class="stepDesc">Inicio</span></a>
                        </li>
                        <li><a href="#step-2" class="selected" isdone="0" rel="2" validar="null">
                            <label class="stepNumber">2</label><span class="stepDesc">Tipo</span></a>
                        </li>
                        <li><a href="#step-3" class="disabled" isdone="0" rel="3" validar="invalido">
                            <label class="stepNumber">3</label><span class="stepDesc">Solicitud</span></a>
                        </li>
                        <li><a href="#step-4" class="disabled" isdone="0" rel="4" validar="null">
                            <label class="stepNumber">4</label><span class="stepDesc">Cargar Archivo</span></a>
                        </li>
                        <li><a href="#step-5" class="disabled" isdone="0" rel="5" validar="null">
                            <label class="stepNumber">5</label><span class="stepDesc">Resumen</span></a>
                        </li>
                        <li><a href="#step-6" class="disabled" isdone="0" rel="5" validar="null">
                            <label class="stepNumber">6</label><span class="stepDesc">Editar</span></a>
                        </li>
                    </ul>

                    <div id="step-1" style="text-align: center; min-height: 540px; height: auto;">
                        <h2 class="StepTitle" style="margin-bottom: 20px;">Inicio</h2>
                        <div align="center">
                            <a href="#" onclick="LlamarPantallaSiguiente2()">
                                <div class="NoSolicitudes">
                                    <span style="vertical-align: middle; color: white;" id="btnIniciarNuevo">Iniciar Nueva Solicitud</span>
                                </div>
                            </a>
                            <div id="Raya" style="width: auto; border: 1px solid #CCC; margin: 20px; margin-top: 40px;"></div>
                            <div id="Titulo">
                                <h2>Solicitudes Pendientes</h2>
                            </div>
                            <div id="laTabla" style="height: 350px; overflow: auto; width: 1000px;">
                                <table border="0" cellpadding="0" cellspacing="2" style="width: 100%">
                                    <tbody class="TablaSol">
                                        <tr id="Headers" class="Headers">
                                            <td class="Cabeza">Solicitud</td>
                                            <td class="Cabeza" style="width: 230px">Clase de Empresa</td>
                                            <td class="Cabeza">Razon Social</td>
                                            <td class="Cabeza">RNC</td>
                                            <td class="Cabeza">Estatus</td>
                                            <td class="Cabeza">Inicio solicitud</td>
                                            <td class="Cabeza"></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                        </div>
                        <%--<div class="general">
                            <div class="MarcoSolicitud">
                            </div>
                        </div>

                        <div class="SubGeneral">
                            <div id="Div1" class="MarcoDelMensaje">
                                Seleccione una de sus solicitudes pendientes y proceda a continuar con la misma.
                            </div>
                            <div id="Div2" class="MarcoDelMensaje">
                                No tiene Solicitudes pendientes.
                            </div>
                            <input type="checkbox" id="NuevaEmp"/><label style="font-size: 16px; margin-left: 5px;">Registrar Nueva Empresa</label>
                            <input type="button" id="NuevaEmp" value="Nueva Empresa" class="css_button" onclick="DivChangeClass(this)" />
                        </div>--%>
                    </div>
                    <div id="step-2">
                        <h2 class="StepTitle" style="margin-bottom: 15px;">Por favor seleccione el tipo de empresa que desea registrar?</h2>

                        <div id="listadoEmpresas" style="margin-left: 15px;">
                        </div>
                        <br />
                        <div id="listarRequisitos" style="margin-left: 15px;">
                        </div>

                        <div id="divCrearSol" style="visibility: hidden; margin: 10px; font-weight: bold; color: blue;">
                            Para completar el registro de este tipo de empresa, debe presentar los siguientes documentos.
                            <span id="lblNroSolicitud"></span>

                        </div>
                        <table id="gvEmpresas" style="width: auto">
                        </table>
                        <span id="lblMsgLista"></span>
                        <%--<div id="gvEmpresasPager">
                        </div>--%>
                    </div>
                    <div id="step-3" style="height: auto;">
                        <h2 class="StepTitle">Formulario</h2>
                        <br />
                        <div id="contenidoFormulario">
                        </div>
                    </div>
                    <div id="step-4" style="height: auto">
                        <h2 class="StepTitle">Cargar Archivos</h2>
                        <div id="Cuerpo">

                            <div>
                                <img class="imagen" alt="" src="../images/formulario.jpg" />
                                <div id="divUploadMessage" style="padding-top: 4px; display: none; font: bold 14px arial;"></div>
                            </div>

                            <asp:UpdatePanel ID="upCargaArchivo" runat="server" UpdateMode="Conditional" style="margin-top: 15px;">
                                <ContentTemplate>
                                    <asp:GridView ID="gvCargaArchivo" runat="server" AutoGenerateColumns="False" Width="90%">
                                        <Columns>
                                            <asp:BoundField HeaderText="Requisitos" DataField="descripcion" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField HeaderText="Obligatorio" DataField="obligatorio" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:TemplateField HeaderText="Adjunto" HeaderStyle-HorizontalAlign="Center">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblID" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.id_seq")%>' Visible="False" />
                                                    <div id="divFrame" style="text-align: center; padding-bottom: 0px; padding-top: 0px;">
                                                        <iframe id="ifrPhoto" onload="initPhotoUpload(this)" scrolling="no"
                                                            frameborder="0" hidefocus="true" style="text-align: center; vertical-align: middle; border-style: none; margin: 0px; width: 100%; height: 35px"
                                                            src="RegUploadImage.aspx?Codsolicitud=<%= CodsolicitudServer.Value%>&idrequisito='<%# DataBinder.Eval(Container, "DataItem.id_seq")%>&idSolicitud=<%= idsolicitudServer.Value%>&NombreArchivo=<%= NombreArchivo.Value%>>'"></iframe>
                                                    </div>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                    <br />
                                    <asp:Button ID="btnMostrarRequisitos" runat="server" Style="display: none;" Text="Refrescar Requisitos" OnClick="btnMostrarRequisitos_Click" />
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="btnMostrarRequisitos" EventName="Click" />
                                    <%--<asp:AsyncPostBackTrigger ControlID="gvCargaArchivo" EventName="RowCommand" />--%>
                                </Triggers>
                            </asp:UpdatePanel>

                            <!--Aquí se manejan las leyendas de la carga de archivos-->
                            <div id="Leyendas">
                                <div class="TablaLeyendas">
                                    <div id="HeadTabla" class="HeadTabla">
                                        <div class="CabezaLeyenda" style="width: 178px;">Archivos Validos</div>
                                        <div class="CabezaLeyenda" style="width: 292px;">Tipos de Archivos</div>
                                    </div>
                                    <div id="Inf1" class="HeadTabla">
                                        <div class="CuerpoTabla">Documentos</div>
                                        <div class="CuerpoTabla2">Excel, PDF y World. </div>
                                    </div>
                                    <div id="Inf2" class="HeadTabla">
                                        <div class="CuerpoTabla">Imagenes</div>
                                        <div class="CuerpoTabla2">Imagenes de Scanner y Fotos: .Jpg .Gif .Png .Tif</div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                    <div id="step-5" style="height: 685px">
                        <h2 class="StepTitle">Resumen</h2>
                        <div id="Final">
                        </div>
                    </div>
                    <div id="step-6" style="height: auto">
                        <h2 class="StepTitle">Editar</h2>
                        <div id="PanelEditar">
                        </div>                      

                        <asp:UpdatePanel ID="upCargarArchivosEditar" runat="server" UpdateMode="Conditional" style="margin-top: 5px;">
                            <ContentTemplate>
                                <asp:GridView ID="gvCargarArchivosEditar" runat="server" AutoGenerateColumns="False" Width="90%">
                                    <Columns>
                                        <asp:BoundField HeaderText="Requisitos" DataField="descripcion" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderStyle HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Obligatorio" DataField="obligatorio" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Editar adjunto" HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:Label ID="lblID" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.id_seq")%>' Visible="False" />
                                                <div id="divFrame" style="text-align: center; padding-bottom: 0px; padding-top: 0px;">
                                                    <iframe id="ifrPhoto" onload="initPhotoUpload(this)" scrolling="no"
                                                        frameborder="0" hidefocus="true" style="text-align: center; vertical-align: middle; border-style: none; margin: 0px; width: 100%; height: 35px"
                                                        src="RegUploadImage.aspx?Codsolicitud=<%= CodsolicitudServer.Value%>&idrequisito='<%# DataBinder.Eval(Container, "DataItem.id_seq")%>&idSolicitud=<%= idsolicitudServer.Value%>&NombreArchivo=<%= NombreArchivo.Value%>>'"></iframe>
                                                </div>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Ver adjunto" ItemStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="ibDescargar" runat="server" ImageUrl="~/images/pdf.png" CommandName='<%# Eval("id_requisito")%>' CommandArgument='<%# Eval("id_solicitud ")%>' />

                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                <br />
                                <asp:Button ID="Button1" runat="server" Style="display: none;" Text="Refrescar Requisitos" OnClick="btnMostrarRequisitos_Click" />
                            </ContentTemplate>
                            <Triggers>
                               <asp:AsyncPostBackTrigger ControlID="btnCargarEditados" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="gvCargarArchivosEditar" EventName="RowCommand" />
                                
                            </Triggers>
                        </asp:UpdatePanel>
                        <asp:Button ID="btnCargarEditados" Text="Cargar" runat="server" OnClick="btnCargarEditados_Click" />
                    </div>
            </td>
        </tr>
    </table>
</asp:Content>

