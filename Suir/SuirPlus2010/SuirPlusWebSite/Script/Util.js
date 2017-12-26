/// <reference path="jquery-1.5.2-vsdoc.js" />
var loc = "";

var Util = {

    LocHost: "",
    Login: "",

    init: function () {

        /// Iniciar el console para evitar errores en IE...
        if (typeof console == "undefined") {
            window.console = {
                log: function () { },
                info: function () { },
                warn: function () { },
                error: function () { }
            };
        }

        /// Inicar el location
        Util.LocHost = "http://" + location.host + "/Services/";
        Util.Login = "http://" + location.host + "/Login.aspx";
        loc = "http://" + location.host + "/Services/Subsidios.asmx" /// No colocar Util.

        /// Cache falso
        $.ajaxSetup({
            cache: false
        });

    },

    SoloFecha: function (e) {
        if (e.keyCode == '8') {
            this.value = "";
        }
        else {
            return false;
        }
    },

    llamarWS: function (Url, data, recibirResultado, callBackFailed, sync) {

        var aSync = true;
        if (sync) {
            aSync = false;
        }
        else {
            aSync = true;
        }

        try {
            $.ajax({
                type: "POST",
                url: Url,
                cache: false,
                contentType: "application/json; charset=utf-8",
                async: aSync,
                data: data,
                dataType: "json",
                success: recibirResultado,
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
        } catch (e) {

            alert(e);
        }

        $.fn.serializeObject = function () {
            var o = {};
            var a = this.serializeArray();
            $.each(a, function () {
                if (o[this.name]) {
                    if (!o[this.name].push) {
                        o[this.name] = [o[this.name]];
                    }
                    o[this.name].push(this.value || '');
                } else {
                    o[this.name] = this.value || '';
                }
            });
            return o;
        };
    },
    LlamarServicio: function (Servicio, Metodo, data, recibirResultado, callBackFailed, sync) {

        var aSync = true;
        if (sync) {
            aSync = false;
        }
        else {
            aSync = true;
        }

        $.ajax({
            type: "POST",
            url: Util.LocHost + Servicio + "/" + Metodo,
            cache: false,
            contentType: "application/json; charset=utf-8",
            async: aSync,
            data: $.toJSON(data),
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

    },

    LlenarDropDown: function (Servicio, Metodo, data, DropDownId, OptionId, OptionText, defaultValue, selectedValue, CallBack, callBackFailed) {
        var d = $("#" + DropDownId);
        var o = "";
        var s = "";
        var v = "";


        $.ajax({
            type: "POST",
            url: Util.LocHost + Servicio + "/" + Metodo,
            cache: false,
            contentType: "application/json; charset=utf-8",
            data: $.toJSON(data),
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
    },

    StopSubmit: function (e, callBack) {
        if (e.keyCode == '13') {

            e.stopImmediatePropagation();

            if (callBack) {
                callBack();
            }

        }
    },

    SoloNumeros: function (e) {
        this.value = this.value.replace(/([^0-9].*)/g, "");
    },
    //funcion para validar que solo se acepten numeros o deciminales de acuerdo al formato(INT si es solo numeros y Float si es solo decimales)
    Solo_Numeros_o_Decimales: function (input, format) {
        var value = input.val();
        var values = value.split("");
        var update = "";
        var transition = "";
        if (format == 'int') {
            expression = /^([0-9])$/;
            finalExpression = /^([1-9][0-9]*)$/;
        }
        else if (format == 'float') {
            var expression = /(^\d+$)|(^\d+\.\d+$)|[,\.]/;
            var finalExpression = /^([1-9][0-9]*[,\.]?\d{0,3})$/;
        }
        for (id in values) {
            if (expression.test(values[id]) == true && values[id] != '') {
                transition += '' + values[id].replace(',', '.');
                if (finalExpression.test(transition) == true) {
                    update += '' + values[id].replace(',', '.');
                }
            }
        }
        input.val(update);
    },


    QuitarLetras: function (str) {
        return str.replace(/([^0-9].*)/g, "");
    },

    EvitarPaste: function (e) {
        try {
            var v = this.value;
            var j = v.replace("/", "");
            j = j.replace("/", "") /// HM: Dejarlo asi... 

            if (isNaN(j)) {
                v = "";
            }

            if (v.length > 10) {
                v = "";
            }

            this.value = v;

            $("#" + this.id).val(v);
        } catch (ex) {
            alert(ex);
        }
    },

    formatJSONDate: function (jsonDate, formato) {
        var d = new Date(parseInt(jsonDate.substr(6)));

        if (formato) {
            d = dateFormat(d, formato);
        }
        else {
            d = dateFormat(d, "dd mmm yyyy");
        }
        if (d == "01/01/1") {
            d = null;
        }
        return d;
    },

    FormaterPeriodo: function (periodo) {
        var fecha = periodo;
        return fecha.substring(6, 10) + "" + fecha.substring(3, 5);
    },

    formatCurrency: function (num) {
        num = isNaN(num) || num === '' || num === null ? 0.00 : num;
        return parseFloat(num).toFixed(2);
    },

    GetQueryStringByName: function (name) {
        name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
        var regexS = "[\\?&]" + name + "=([^&#]*)";
        var regex = new RegExp(regexS);
        var results = regex.exec(window.location.href);
        if (results == null)
            return "";
        else
            return decodeURIComponent(results[1].replace(/\+/g, " "))
    },

    IsValidEmail: function (email) {
        if (email == "") {
            return true;
        }
        var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
        return filter.test(email);
    },

    LlamarAutocomplete2: function (Servicio, Metodo, Input, Parametro, msgError) {
        $("#" + Input).autocomplete({
            source: function (request, response) {
                $.debounce(250,
                    $.ajax({
                        type: "POST",
                        url: Util.LocHost + Servicio + "/" + Metodo,
                        cache: false,
                        contentType: "application/json; charset=utf-8",
                        data: '{' + Parametro + ': "' + $("#" + Input).val() + '" }',
                        dataType: "json",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    value: item
                                }
                            }))
                        },
                        error: function () {
                            $("#" + msgError).html("Ha ocurrido un error en la busqueda del puesto, favor revisar el nombre del puesto e intentar de nuevo");
                        },
                        minLength: 5
                    }));
            },
            minLength: 3
        });

    },
    /*validar fechas*/
    ValidarFecha: function (fecha) {

        // regular expression to match required date format
        re = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/;

        if (fecha != '') {
            if (regs = fecha.match(re)) {
                // day value between 1 and 31
                if (regs[1] < 1 || regs[1] > 31) {
                    return false;
                }
                // month value between 1 and 12
                if (regs[2] < 1 || regs[2] > 12) {
                    return false;
                }
                // year value between 1902 and 2012
                if (regs[3] < 1902 || regs[3] > (new Date()).getFullYear()) {
                    return false;
                }
            } else {
                return false;
            }
        }
        return true;
    },



    /*AutoComplete que retorna varios valores*/
    LlamarAutocompleteMoreInput: function (Servicio, Metodo, InputDescription, InputValue, InputFocus, Parametro, msgError) {

        $("#" + InputDescription).autocomplete({
            source: function (request, response) {
                $.debounce(250,
                    $.ajax({
                        type: "POST",
                        url: Util.LocHost + Servicio + "/" + Metodo,
                        cache: false,
                        contentType: "application/json; charset=utf-8",
                        data: '{' + Parametro + ': "' + $("#" + InputDescription).val() + '" }',
                        dataType: "json",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item.split('-')[0],
                                    val: item.split('-')[1]
                                }
                            }))
                        },
                        error: function () {
                            $("#" + msgError).html("Ha ocurrido un error en la busqueda del puesto, favor revisar el nombre del puesto e intentar de nuevo");
                            $("#" + msgError).removeClass("labelSubtitulo");
                            $("#" + msgError).addClass("error");
                        },
                        minLength: 5
                    }));
            },

            select: function (e, i) {

                var item = i.item.val;
                if (item != "" && item != null) {
                    $("#" + InputValue).html(i.item.val);
                    $("#" + InputFocus).focus();

                }
                else {
                    $("#" + InputValue).html('');
                }


            },
            minLength: 3
        });

    },

    LlamarAutoComplete: function (Servicio, Metodo, InputText, ServiceParameter, OnSelect) {

        $("#" + InputText).autocomplete({

            source: function (request, response) {
                $.debounce(250,
                    $.ajax({
                        type: "POST",
                        url: Util.LocHost + Servicio + "/" + Metodo,
                        cache: false,
                        data: '{' + ServiceParameter + ': "' + $("#" + InputText).val() + '" }',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    label: item,
                                    val: item
                                }
                            }))
                        },
                        error: function (ex) {
                            console.log("-=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=-");
                            console.log(ex.toString());
                            console.log("-=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=-");
                        },
                        minLength: 5
                    }));
            },
            minLength: 2,
            select: OnSelect

        });

    },
    //*para agregar tips o comentarios a un control especifico
    AgregarTip: function (control, texto) {

        $("#" + control).qtip({
            content: texto,
            style: {
                width: 300,
                padding: 5,
                background: '#A2D959',
                color: 'white',
                bold: 'true',
                textAlign: 'center',
                border: {
                    width: 7,
                    radius: 5,
                    color: '#A2D959'
                },
                tip: 'topLeft'

            }
        });

    },

    //*para limitar la cantidad de caracteres para un textArea
    limitarTexto: function (control, limite) {

        var idControl = $("#" + control);
        var valor = idControl.val();
        if (valor.length > limite) {
            valor = "";
            valor = idControl.val().substring(0, limite);
            idControl.val(valor);
            //return valor;
        }
    },

    //*Para mostrar mensajes personalisados
    MostrarMensaje: function (tipo, texto, onSuccess, onError) {

        if (tipo == 'ERROR') {
            var BarraHTML = '<div id="divMSG" title="Información"><div id="TextoMsg" class="ui-dialog-title" style="float: left; margin: 0 7px 0px 0; font-size: small; color: Red;">' + texto + '</div></div>';
            $("body").append(BarraHTML);
            $("#divMSG").show();
            $("#dialog:ui-dialog").dialog("destroy");
            $("#divMSG").dialog({
                modal: true,
                buttons: {
                    Ok: function () {
                        eval(onError);
                        $("#divMSG").remove();
                        $(this).dialog("close");
                    }
                }
            });
        }
        else {
            if (tipo == 'OK') {
                var BarraHTML = '<div id="divMSG" title="Información"><div id="TextoMsg" class="ui-dialog-title" style="float: left; margin: 0 7px 0px 0; font-size: small; color: Blue;">' + texto + '</div></div>';
                $("body").append(BarraHTML);
                $("#divMSG").show();
                $("#dialog:ui-dialog").dialog("destroy");
                $("#divMSG").dialog({
                    modal: true,
                    buttons: {
                        Ok: function () {
                            eval(onSuccess);
                            $("#divMSG").remove();
                            $(this).dialog("close");
                        }
                    }
                });
            }
        }

    },
    //Para lanzar el Progressbar 
    ProgressBarInicio: function () {
        var progressBarHTML = '<div id="ProgressBar" title="Procesando ........">';
        progressBarHTML += '<br /><br />';
        progressBarHTML += '<div id="ProgressBarBarra"></div>';
        progressBarHTML += '<br />';

        $("body").append(progressBarHTML);

        $("#ProgressBarBarra").progressbar({ value: 0 });

        $("#ProgressBar").dialog({
            autoOpen: false,
            height: 150,
            width: 500,
            modal: true
        });
        $("#ProgressBar").dialog("open");
        var i = 0;
        setInterval(function () {
            i = i + 1;
            if (i >= 100) {
                i = 0;
            }
            $("#ProgressBarBarra").progressbar({ value: i });
        }, 50);
    },
    //Para ocultar el Progressbar 
    ProgressBarFin: function () {
        $("#ProgressBar").dialog("close");
        $("#ProgressBar").remove();
    },


    //para utilizar el jqgrid
    Grid: function (Servicio, Metodo, TableId, PagerId, ColNames, ColModel, Params, Caption, CantidadFilas, onSelectRow, Ancho) {
        var filas = 10;
        var altura = 550;
        var ancho = 860;

        if (CantidadFilas) {
            filas = CantidadFilas;
            if (CantidadFilas < 26) {
                altura = 340;
            }
        }

        if (Ancho) {
            ancho = Ancho;
        }

        function getInfo(a) {

            Params.pCurrentPage = a.page;

            $.ajax({

                url: Util.LocHost + Servicio + "/" + Metodo,
                data: $.toJSON(Params),
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    console.info(JSON.parse(data.d));
                    jQuery("#" + TableId)[0].addJSONData(JSON.parse(data.d));

                }
            });
        }

        jQuery("#" + TableId).jqGrid({
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
            height: altura,
            enableSearch: false,
            onSelectRow: onSelectRow,
            altRows: true

        });

        jQuery("#" + TableId).jqGrid('navGrid', '#' + PagerId, { edit: false, add: false, del: false, refresh: true });

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

}


$(function () {
    Util.init();
});


//fin de namespace Util

function numbersonly(myfield, e, dec) {

    var key;
    var keychar;

    if (window.event)
        key = window.event.keyCode;
    else if (e)
        key = e.which;
    else
        return true;
    keychar = String.fromCharCode(key);

    // control keys
    if ((key == null) || (key == 0) || (key == 8) ||
    (key == 9) || (key == 13) || (key == 27))
        return true;

    // numbers
    else if ((("0123456789").indexOf(keychar) > -1))
        return true;

    // decimal point jump
    else if (dec && (keychar == ".")) {
        myfield.form.elements[dec].focus();
        return false;
    }
    else
        return false;
}

function IsValidEmail(email) {
    if (email == "") {
        return true;
    }
    var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    return filter.test(email);
}

function llamarWS(Url, data, recibirResultado, ajaxFailed) {
    try {
        $.ajax({
            type: "POST",
            url: Url,
            cache: false,
            contentType: "application/json; charset=utf-8",
            data: data,
            dataType: "json",
            success: recibirResultado,
            error: ajaxFailed
        });
    } catch (e) {

        alert(e);
    }

    $.fn.serializeObject = function () {
        var o = {};
        var a = this.serializeArray();
        $.each(a, function () {
            if (o[this.name]) {
                if (!o[this.name].push) {
                    o[this.name] = [o[this.name]];
                }
                o[this.name].push(this.value || '');
            } else {
                o[this.name] = this.value || '';
            }
        });
        return o;
    };
}

//Utilizado para quitar el 0.00 cuandos se hace focus.
function maskFocus(control) {
    if (control.value == "0.00")
        control.value = "";
}

//Utilizado para colocar el 0.00 si no se coloco ningun valor.    
function maskBlur(control) {
    if (control.value == "") {
        control.value = "0.00";
    }
    else {
        round(control)
    }
}


//Funcion utilizada para redondear. toma como parametro el control.
function roundNum(num) {
    ans = num * 1000
    ans = Math.round(ans / 10) + ""
    while (ans.length < 3) { ans = "0" + ans }
    len = ans.length
    ans = ans.substring(0, len - 2) + "." + ans.substring(len - 2, len)
    return ans;
}

//Funcion utilizada para redondear. toma como parametro el control.
function round(control) {
    ans = control.value * 1000
    ans = Math.round(ans / 10) + ""
    while (ans.length < 3) { ans = "0" + ans }
    len = ans.length
    ans = ans.substring(0, len - 2) + "." + ans.substring(len - 2, len)
    control.value = ans;
}

//Verificador que se utiliza para solo permitir numero y punto.
function CheckKeyCode() {
    if ((event.keyCode == 189 || event.keyCode == 109) ||
      (event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 110) ||
      (event.keyCode >= 48 && event.keyCode <= 57) ||
      (event.keyCode >= 96 && event.keyCode <= 105))
    { return true; }
    else {
        return false;
    }
}

//Wraper de la funcion de formatNumber.
function FormatNum(num) {
    return FormatNumber(num, 2, true, false, true);
}
function FormatNumber(num, decimalNum, bolLeadingZero, bolParens, bolCommas) {
    if (isNaN(parseInt(num))) return "NaN";

    var tmpNum = num;
    var iSign = num < 0 ? -1 : 1; 	// obtenemos el signo del numero.

    // Adjust number so only the specified number of numbers after
    // the decimal point are shown.
    tmpNum *= Math.pow(10, decimalNum);
    tmpNum = Math.round(Math.abs(tmpNum))
    tmpNum /= Math.pow(10, decimalNum);
    tmpNum *= iSign; 				// reajustamos el signo.


    // creamos un string temporal para formatear el numero.
    var tmpNumStr = new String(tmpNum);

    // Verificamos si se desear rellenar de 0.
    if (!bolLeadingZero && num < 1 && num > -1 && num != 0)
        if (num > 0)
            tmpNumStr = tmpNumStr.substring(1, tmpNumStr.length);
        else
            tmpNumStr = "-" + tmpNumStr.substring(2, tmpNumStr.length);

    // Verificamos si de desea utilizar coma como separador.
    if (bolCommas && (num >= 1000 || num <= -1000)) {
        var iStart = tmpNumStr.indexOf(".");
        if (iStart < 0)
            iStart = tmpNumStr.length;

        iStart -= 3;
        while (iStart >= 1) {
            tmpNumStr = tmpNumStr.substring(0, iStart) + "," + tmpNumStr.substring(iStart, tmpNumStr.length)
            iStart -= 3;
        }
    }

    // Verificamos si deseamos usar parentesis.
    if (bolParens && num < 0)
        tmpNumStr = "(" + tmpNumStr.substring(1, tmpNumStr.length) + ")";

    return tmpNumStr; 	// retornamos nuestro numero formateado.
}

function DoFocus(box) {

    box.className = 'inputFocus';
}

function DoBlur(box) {
    box.className = 'input';
}

