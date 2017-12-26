<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false"
    CodeFile="Turnos.aspx.vb" Inherits="MDT_Turnos" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc1" %>
<%@ Register Src="../Controles/ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
    <% If 1 = 2 Then
    %>
    <script src="../Script/Util.js" type="text/javascript"></script>
    <script src="../Script/jquery-1.5.2-vsdoc.js" type="text/javascript"></script>
    <%
    End If
    %>
    

    <script type="text/javascript" src="../Script/json2.js"></script>
    <script type="text/javascript">

        $(function () {

            //pagaMDT();
            $(function ($) {
                $.mask.definitions['H'] = '[01]';
                $.mask.definitions['N'] = '[012345]';
                $.mask.definitions['n'] = '[0123456789]';
                $(".formatearHoras").mask("Hn:Nn");
            });

            HabilitarListado();

            $("#btnAgregar").click(function () {               
                HabilitarFormulario(0);
            });
            $("#btnAgregar1").click(function () {
                HabilitarFormulario(0);
            });
            $("#btnAgregar").button();

            $("#btnAgregar1").button();
            $("#btnCancelar").click(function () {
                
                HabilitarListado();
            });                      

            $('#btnGuardar').click(function () {

             ProcesarTurno($("#hfIdTurno").val());
            });

        });


        //Bloque de Implementacion del JQGrid/////////////////////////////////////////
        function LlamarGrid() {
            var Params = {
                pPageSize: 25,
                pCurrentPage: 1,
                pCriterio: $("#RegistroPatronal").html(),
                pSortColumn: '',
                pSortOrder: ''
            };

            var ColNames = ['', 'Id', 'Turno', 'Inicio Jornada', 'Descanso Diario', 'Fin Jornada', 'Descanso Semanal','Estatus'];
            var ColModel = [
                { name: '0', index: '0', sortable: false, width: 8, align: "center", key: true, formatter: formatColumnImage },
                { name: '1', index: '1', sortable: false, width: 12, align: "center" },
                { name: '2', index: '2', sortable: false, width: 40, align: "left" },
                { name: '3', index: '3', sortable: false, width: 40, align: "center" },
                { name: '4', index: '4', sortable: false, width: 40, align: "center" },
                { name: '5', index: '5', sortable: false, width: 40, align: "center" },
                { name: '6', index: '6', sortable: false, width: 63, align: "left" },
                { name: '7', index: '7', sortable: false, width: 14, align: "center" }
            ];

            Util.Grid('MDT.asmx', 'getTurnos', 'Turnos', 'TurnosPager', ColNames, ColModel, Params, 'Listado de Turnos', 25, function (id) {

                HabilitarFormulario(id);
            });

            function formatColumnImage(cellvalue, options, rowObject) {
                $(".colimg").css('cursor', 'pointer');
                return "<img class='colimg' src='../images/edit-icon.png' />";
            }

            //Fin del JQGrid/////////////////////////////////////////           
        }
        //Bloque de Funciones Generales de JavaScript//////////////////////////////////////


        //verificamos si el empresa logeada paga mdt

//        function pagaMDT() {
//            Params = {
//                idRegPatronal: $("#RegistroPatronal").html()
//            }
//            Util.LlamarServicio('MDT.asmx', 'pagaMDT', Params, function (data) {

//                if (data.d == "False") {
//                    $("#divListado").hide();
//                    $("#divExportarExcel").hide();
//                    $("#btnAgregar").hide();
//                    var onerror = "window.location.href = '../Empleador/consNotificaciones.aspx'";
//                    Util.MostrarMensaje('ERROR', 'Este empleador no paga impuestos del Ministerio de Trabajo.', null, onerror);
//                }

//            });
//        }
        /////////////////////////////////////////////

        function HabilitarListado() {

            LlamarGrid();
            $("#btnAgregar").button();
            $("#btnAgregar").show();
            $("#btnAgregar1").button();
            $("#btnAgregar1").show();
            $("#divListado").show();
            $("#divFormulario").hide();           
           
            Limpiar();
        }
        function HabilitarFormulario(valor) {
            $("#btnAgregar").hide();
            $("#btnAgregar1").hide();
            $("#divListado").hide();
            $("#divFormulario").show();
            $("#btnCancelar").button();
            $("#btnGuardar").button();
            $("#hfIdTurno").val(valor);
            
            if (valor > 0) {
               ///Para mostrar el TR de Estatus
                $("#trEstatus").show();
                /// Cargar turno by Id
                Params = {
                    IdTurno: valor
                };
                Util.LlamarServicio('MDT.asmx', 'getTurno', Params, function (data) {
                    if (data.d.trabajo_1_desde != null) {
                        var h = data.d.trabajo_1_desde.split(" ");
                        var h2 = h[0].split(":");
                        if (h2[0] < 10) {
                            $('#txtInicioJornadaDesde').val(0 + h[0]);
                        } else {
                            $('#txtInicioJornadaDesde').val(h[0]);
                        }

                        $('#selInicioJornadaDesde').val(h[1].toUpperCase());
                    }
                    if (data.d.trabajo_2_hasta != null) {
                        var h = data.d.trabajo_2_hasta.split(" ");
                        var h2 = h[0].split(":");
                        if (h2[0] < 10) {
                            $('#txtInicioJornadaHasta').val(0 + h[0]);
                        } else {
                            $('#txtInicioJornadaHasta').val(h[0]);
                        }

                        $('#selInicioJornadaHasta').val(h[1].toUpperCase());
                    }


//                    if (data.d.trabajo_1_hasta != null) {
//                        var h = data.d.trabajo_1_hasta.split(" ");
//                        var h2 = h[0].split(":");
//                        if (h2[0] < 10) {
//                            $('#txtInicioJornadaHasta').val(0 + h[0]);
//                        } else {
//                            $('#txtInicioJornadaHasta').val(h[0]);
//                        }

//                        $('#selInicioJornadaHasta').val(h[1].toUpperCase());
//                    }
                    //--
                    if (data.d.descanso_1_desde != null) {
                        var h = data.d.descanso_1_desde.split(" ");
                        var h2 = h[0].split(":");
                        if (h2[0] < 10) {
                            $('#txtDescansoDiarioDesde').val(0 + h[0]);
                        } else {
                            $('#txtDescansoDiarioDesde').val(h[0]);
                        }

                        $('#selDescansoDiarioDesde').val(h[1].toUpperCase());

                    }
                    if (data.d.descanso_1_hasta != null) {
                        var h = data.d.descanso_1_hasta.split(" ");
                        var h2 = h[0].split(":");
                        if (h2[0] < 10) {
                            $('#txtDescansoDiarioHasta').val(0 + h[0]);
                        } else {
                            $('#txtDescansoDiarioHasta').val(h[0]);
                        }

                        $('#selDescansoDiarioHasta').val(h[1].toUpperCase());
                    }
//                    if (data.d.trabajo_2_desde != null) {
//                        var h = data.d.trabajo_2_desde.split(" ");
//                        var h2 = h[0].split(":");
//                        if (h2[0] < 10) {
//                            $('#txtFinJornadaDesde').val(0 + h[0]);
//                        } else {
//                            $('#txtFinJornadaDesde').val(h[0]);
//                        }

//                        $('#selFinJornadaDesde').val(h[1].toUpperCase());
//                    }
//                    if (data.d.trabajo_2_hasta != null) {
//                        var h = data.d.trabajo_2_hasta.split(" ");
//                        var h2 = h[0].split(":");
//                        if (h2[0] < 10) {
//                            $('#txtFinJornadaHasta').val(0 + h[0]);
//                        } else {
//                            $('#txtFinJornadaHasta').val(h[0]);
//                        }

//                        $('#selFinJornadaHasta').val(h[1].toUpperCase());
//                    }
                    if (data.d.descanso_hora_desde != null) {
                        var h = data.d.descanso_hora_desde.split(" ");
                        var h2 = h[0].split(":");
                        if (h2[0] < 10) {
                            $('#txtDescansoSemanalHrsDesde').val(0 + h[0]);
                        } else {
                            $('#txtDescansoSemanalHrsDesde').val(h[0]);
                        }

                        $('#selDescansoSemanalHrsDesde').val(h[1].toUpperCase());
                    }
                    if (data.d.descanso_hora_hasta != null) {
                        var h = data.d.descanso_hora_hasta.split(" ");
                        var h2 = h[0].split(":");
                        if (h2[0] < 10) {
                            $('#txtDescansoSemanalHrsHasta').val(0 + h[0]);
                        } else {
                            $('#txtDescansoSemanalHrsHasta').val(h[0]);
                        }
                        $('#selDescansoSemanalHrsHasta').val(h[1].toUpperCase());
                    }


                    $("#ddlEstatus").val(data.d.status)
                    $("#ddlDescansoSemanalDesde").val(data.d.descanso_dia_desde);
                    $("#ddlDescansoSemanalHasta").val(data.d.descanso_dia_hasta);
                    $("#txtDescripcion").val(data.d.descripcion);



                });
            } else {
                ///Para Ocultar mostrar el TR de Estatus
                $("#trEstatus").hide();
               Limpiar();
            }
        }

        //procesamos el turno
        function ProcesarTurno(id_Turno) {
            if (id_Turno.toString.length == 0) {
                id_Turno == 0;
            }
            
            var descansoDesde = '';
            var descansoHasta = '';
            var finJornadaDesde = '';
            var finJornadaHasta = '';
           
            if ($("#txtDescansoDiarioDesde").val() != '') {
                descansoDesde =  $("#txtDescansoDiarioDesde").val() + ' ' +  $("#selDescansoDiarioDesde").val();
            }
            if ($("#txtDescansoDiarioHasta").val() != '') {
                descansoHasta = $("#txtDescansoDiarioHasta").val() + ' ' +  $("#selDescansoDiarioHasta").val();
            }
//            if ($("#txtFinJornadaDesde").val() != '') {
//                finJornadaDesde = $("#txtFinJornadaDesde").val() + ' ' +  $("#selFinJornadaDesde").val();
//            }
//            if ($("#txtFinJornadaHasta").val() != '') {
//                finJornadaHasta = $("#txtFinJornadaHasta").val() + ' ' +  $("#selFinJornadaHasta").val();
            //            }

            if ($("#txtFinJornadaDesde").val() != '') {
                finJornadaDesde = $("#txtDescansoDiarioHasta").val() + ' ' + $("#selDescansoDiarioHasta").val();
            }
            if ($("#txtFinJornadaHasta").val() != '') {
                finJornadaHasta = $("#txtInicioJornadaHasta").val() + ' ' + $("#selInicioJornadaHasta").val();
            }
   
            var ParamsTurno = {
                p_id_turno: id_Turno,
                p_id_registro_patronal: $("#RegistroPatronal").html(),
                p_descripcion: $("#txtDescripcion").val(),
                p_trabajo_1_desde: $("#txtInicioJornadaDesde").val() + ' ' +  $("#selInicioJornadaDesde").val(),
                p_trabajo_1_hasta: $("#txtDescansoDiarioDesde").val() + ' ' + $("#selDescansoDiarioDesde").val(),
                //  p_descanso_1_desde: $("#txtDescansoDiarioDesde").val() + ' ' +  $("#selDescansoDiarioDesde").val(),
                p_descanso_1_desde: descansoDesde,
                //p_descanso_1_hasta: $("#txtDescansoDiarioHasta").val() + ' ' +  $("#selDescansoDiarioHasta").val(),
                p_descanso_1_hasta: descansoHasta,
                //p_trabajo_2_desde: $("#txtFinJornadaDesde").val() + ' ' +  $("#selFinJornadaDesde").val(),
                p_trabajo_2_desde: finJornadaDesde,
               // p_trabajo_2_hasta: $("#txtFinJornadaHasta").val() + ' ' +  $("#selFinJornadaHasta").val(),
                p_trabajo_2_hasta: finJornadaHasta,
                p_descanso_dia_desde: $("#ddlDescansoSemanalDesde").val(),
                p_descanso_hora_desde: $("#txtDescansoSemanalHrsDesde").val() + ' ' +  $("#selDescansoSemanalHrsDesde").val(),
                p_descanso_dia_hasta: $("#ddlDescansoSemanalHasta").val(),
                p_descanso_hora_hasta: $("#txtDescansoSemanalHrsHasta").val() + ' ' +  $("#selDescansoSemanalHrsHasta").val(),
                ult_usuario_act: $("#UsuarioLog").html(),
                p_status: $("#ddlEstatus").val()
            };

            //set de validaciones

            var Resultado = validaciones();
            if (Resultado != "") {
                Resultado = "Favor revisar los siguientes campos: <br>" + Resultado;
                $("#lblMensaje").html(Resultado);
                $("#lblMensaje").addClass("error");
                return;
            }

            Util.LlamarServicio('MDT.asmx', 'procesarTurno', ParamsTurno, function (data) {
                var info = data.d;
                console.info(info);

                if (info == 0) {
                    Limpiar();
                    Util.MostrarMensaje('OK', 'Registro procesado satisfactoriamente.');
                    HabilitarListado();
                }
                else {
                  
                    $("#lblMensaje").html(info);
                    $("#lblMensaje").removeClass("labelSubtitulo");
                    $("#lblMensaje").addClass("error");
                }

            });
        }

        
        //Validaciones para Turnos

        function validaciones() {
           
            var Resultado = "";


            if (($("#txtDescripcion").val() == "") || ($.trim($("#txtDescripcion").val()).length == 0)) {
                Resultado += "* La descripción del turno es requerida.</br>";
            }
            
            if (DeterminarHorario($("#txtInicioJornadaDesde").val()) == true) {
                Resultado += "* La hora de jornada <b>desde</b> es requerida y en formato de 12 horas(AM/PM).</br>";
            }

            if (DeterminarHorario($("#txtInicioJornadaHasta").val()) == true) {
                Resultado += "* La hora de jornada <b>hasta</b> es requerida y en formato de 12 horas(AM/PM).</br>";
            }

            if ($("#ddlDescansoSemanalDesde").val() == 0) {
                Resultado += "* Debe seleccionar el dia de descanso semanal <b>desde</b>.</br>";
            } 

            if (DeterminarHorario($("#txtDescansoSemanalHrsDesde").val()) == true) {
                Resultado += "* La hora de descanso semanal <b>desde</b> es requerida y en formato de 12 horas(AM/PM).</br>";
            }
            if ($("#ddlDescansoSemanalHasta").val() == 0) {
                Resultado += "* Debe seleccionar el dia de descanso semanal <b>hasta</b>.</br>";
            } 
            if (DeterminarHorario($("#txtDescansoSemanalHrsHasta").val()) == true) {
                Resultado += "* La hora de descanso semanal <b>hasta</b> es requerida y en formato de 12 horas(AM/PM).</br>";
            }

            if(validarHorarios($("#txtInicioJornadaDesde").val(),$("#txtInicioJornadaHasta").val(),$("#selInicioJornadaDesde").val(),$("#selInicioJornadaHasta").val()) == true){
             Resultado += "* La hora de jornada <b>desde</b> debe ser menor a la hora de jornada <b>hasta</b>.</br>";
         }

         if (($("#txtDescansoDiarioDesde").val() != '') && ($("#txtDescansoDiarioHasta").val() != '')) {
            if (validarHorarios($("#txtDescansoDiarioDesde").val(), $("#txtDescansoDiarioHasta").val(), $("#selDescansoDiarioDesde").val(), $("#selDescansoDiarioHasta").val()) == true) {
                Resultado += "* La hora de descanso diario <b>desde</b> debe ser menor a La hora de descanso diario <b>hasta</b>.</br>";
            }
        }
        if ((($("#txtDescansoDiarioDesde").val() == '') && ($("#txtDescansoDiarioHasta").val() != '')) || (($("#txtDescansoDiarioDesde").val() != '') && ($("#txtDescansoDiarioHasta").val() == ''))) {
            Resultado += "* La hora de descanso diario <b>desde</b> y la hora de descanso diario <b>hasta</b> deben ser válidas.</br>";
        }

//        if (($("#txtFinJornadaDesde").val() != '') && ($("#txtFinJornadaHasta").val() != '')) {
//            if (validarHorarios($("#txtFinJornadaDesde").val(), $("#txtFinJornadaHasta").val(), $("#selFinJornadaDesde").val(), $("#selFinJornadaHasta").val()) == true) {
//                Resultado += "* La hora fin de jornada <b>desde</b> debe ser menor a la hora fin de jornada <b>hasta</b>.</br>";
//            }
//        }
//        if ((($("#txtFinJornadaDesde").val() == '') && ($("#txtFinJornadaHasta").val() != '')) || (($("#txtFinJornadaDesde").val() != '') && ($("#txtFinJornadaHasta").val() == ''))) {
//            Resultado += "* La hora fin de jornada <b>desde</b> y la hora fin de jornada <b>hasta</b> deben ser válidas.</br>";
//        }

            if ($("#ddlDescansoSemanalDesde").val() == $("#ddlDescansoSemanalHasta").val()) {
            if (validarHorarios($("#txtDescansoSemanalHrsDesde").val(), $("#txtDescansoSemanalHrsHasta").val(), $("#selDescansoSemanalHrsDesde").val(), $("#selDescansoSemanalHrsHasta").val()) == true) {
                Resultado += "* La hora descanso semanal <b>desde</b> debe ser menor a La hora descanso semanal <b>hasta</b>.</br>";
                }
            }

            if (($("#txtDescansoDiarioDesde").val() != '') && ($("#txtInicioJornadaHasta").val() != '')) {
                if (validarHorarios($("#txtDescansoDiarioDesde").val(), $("#txtInicioJornadaHasta").val(), $("#selDescansoDiarioDesde").val(), $("#selInicioJornadaHasta").val()) == true) {
                    Resultado += "* La hora de descanso diario <b>desde</b> debe ser menor a La hora de jornada <b>hasta</b>.</br>";
                }
            }

            if (($("#txtInicioJornadaDesde").val() != '') && ($("#txtDescansoDiarioDesde").val() != '')) {
                if (validarHorarios($("#txtInicioJornadaDesde").val(), $("#txtDescansoDiarioDesde").val(), $("#selInicioJornadaDesde").val(), $("#selDescansoDiarioDesde").val()) == true) {
                    Resultado += "* La hora de descanso diario <b>desde</b> debe ser mayor a La hora de jornada <b>desde</b>.</br>";
                }
            }

            if (($("#txtDescansoDiarioHasta").val() != '') && ($("#txtInicioJornadaHasta").val() != '')) {
                if (validarHorarios($("#txtDescansoDiarioHasta").val(), $("#txtInicioJornadaHasta").val(), $("#selDescansoDiarioHasta").val(), $("#selInicioJornadaHasta").val()) == true) {
                    Resultado += "* La hora de descanso diario <b>hasta</b> debe ser menor a La hora de jornada <b>hasta</b>.</br>";
                }
            }

            if (($("#txtInicioJornadaDesde").val() != '') && ($("#txtDescansoDiarioHasta").val() != '')) {
                if (validarHorarios($("#txtInicioJornadaDesde").val(), $("#txtDescansoDiarioHasta").val(), $("#selInicioJornadaDesde").val(), $("#selDescansoDiarioHasta").val()) == true) {
                    Resultado += "* La hora de descanso diario <b>hasta</b> debe ser mayor a La hora de jornada <b>desde</b>.</br>";
                }
            }

           return Resultado;
        }

        // Utilizar para validar la información de la hora en el dia       
        function DeterminarHorario(valor) {
            
            var mySplitResult = valor.split(":");

            if (mySplitResult[0] > 12 || valor == "") {
                return true;
            }

            else if (mySplitResult[0] == "00") {
             
                return true;
            } 
            
            else {
               return false;

            }

        }

        function Limpiar() {
            $("#txtInicioJornadaDesde").val("");
            $("#txtInicioJornadaHasta").val("");
            $("#txtDescansoDiarioDesde").val("");
            $("#txtDescansoDiarioHasta").val("");
            //$("#txtFinJornadaDesde").val("");
            //$("#txtFinJornadaHasta").val("");
            $("#ddlDescansoSemanalDesde").val(0);
            $("#txtDescansoSemanalHrsDesde").val("");
            $("#ddlDescansoSemanalHasta").val(0);
            $("#txtDescansoSemanalHrsHasta").val("");
            $("#txtDescripcion").val("");
            $("#lblMensaje").html("");
            $("#ddlEstatus").val(0);
        }


        function validarHorarios(fechauno, fechaDos, fechaUnoTanda, fechaDosTanda) {
            
            if (fechaUnoTanda == "A.M." && fechaDosTanda == "A.M.") {
               var fecha = fechauno.split(":");
                var fecha2 = fechaDos.split(":");
                var l = fecha[0] + fecha[1];
                var l2 = fecha2[0] + fecha2[1];

                if (fecha[0] == 12 && fecha2[0] == 12) {
                    if (l > l2) {
                        return true;
                    }
                }

                else if (fecha[0] == 12 && fecha2[0] < 12) {
                    return false;
                }

                else if (fecha2[0] == 12 && fecha[0] < 12) {
                    return true;
                    
                }

                else {
                    if (l > l2) {
                        return true;
                    }
                }

            }

            if (fechaUnoTanda == "P.M." && fechaDosTanda == "P.M.") {

                var fecha = fechauno.split(":");
                var fecha2 = fechaDos.split(":");
                var l = fecha[0] + fecha[1];
                var l2 = fecha2[0] + fecha2[1];

                if (fecha[0] == 12 && fecha2[0] == 12) {
                    if (l > l2) {
                        return true;
                    }
                }

                else if (fecha[0] == 12) {
               
                    var l2 = fecha2[0];
                    l2 = parseInt(l2) + 12;
                    var l3 = l2 + "" + fecha2[1];
                  
                    if (l > l3) {
                        return true;
                    }
                }

                else if (fecha2[0] == 12) {

                    if (l > l2) {
                        return true;
                    }
                }

                else {
                    if (l > l2) {
                        return true;
                    }
                }
            }          
        } 
        

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <uc1:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
    <span class="header">Turnos</span>
    <br />
    <div style="text-align: right; width: 860px;">
        <span id="btnAgregar1" style="font-size: 8pt;">Agregar</span>
        <br />
    </div>
   <br />
    <div id="divListado">
        <table id="Turnos">
        </table>
        <div id="TurnosPager">
        </div>
        <div id="divExportarExcel" style="text-align: left">
            <br />
            <uc2:ucExportarExcel ID="ucExportarExcel1" runat="server" />
        </div>
    </div>
    <div id="divFormulario">
        <span class="subHeader">Distribución del Horario de Trabajo</span>
        <br />
        <br />
        <table class="td-content">
            <tr>
                <td colspan="2">
                    <span id="RegistroPatronal" style="visibility: hidden"><%=UsrRegistroPatronal%></span>
                    <span id="UsuarioLog" style="visibility: hidden;"><%=UsrUserName%></span>
                    <input type="hidden" id="hfIdTurno" value="0"/>
                </td>
            </tr>
            <tr id="trEstatus">
                <td class="labelSubtitulo" colspan="2">
                    Estatus:  <select id="ddlEstatus" class="dropDowns">
                        <option value="A" selected="selected">Activo</option>
                        <option value="I">Inactivo</option>
                    </select></td>

             </tr>
            <tr>
                <td colspan="2" class="labelSubtitulo">
                    Turno:&nbsp;&nbsp;&nbsp; <input name="" id="txtDescripcion" style="width:250px;" /> 
                </td>
             </tr>
            <tr>
                <td colspan="2" class="labelSubtitulo">
                    <br />
                    Jornada de Trabajo
                </td>
            </tr>
             
            <tr>
                <td valign="middle">
                    Desde
                    <input id="txtInicioJornadaDesde" type="text" class="formatearHoras"
                        style="width: 40px" /><span id="lblDesde" />                   
                   <select id="selInicioJornadaDesde" class="dropDowns">
                        <option value="A.M." selected="selected">a.m.</option>
                        <option value="P.M.">p.m.</option>
                   </select>
                </td>
                <td valign="middle">
                    Hasta
                    <input id="txtInicioJornadaHasta" type="text" class="formatearHoras" style="width: 40px" />
                    <select id="selInicioJornadaHasta" class="dropDowns">
                        <option value="A.M." selected="selected">a.m.</option>
                        <option value="P.M.">p.m.</option>
                   </select>
                </td>
            </tr>

            <tr>
                <td colspan="2" class="labelSubtitulo">
                    <br />
                    Descanso Diario
                </td>
            </tr>
            <tr>
                <td valign="middle">
                    Desde
                    <input id="txtDescansoDiarioDesde" type="text" class="formatearHoras" style="width: 40px" />
                    <select id="selDescansoDiarioDesde" class="dropDowns">
                          <option value="A.M." selected="selected">a.m.</option>
                        <option value="P.M.">p.m.</option>
                   </select>
                </td>
                <td valign="middle">
                    Hasta
                    <input id="txtDescansoDiarioHasta"" type="text" class="formatearHoras" style="width: 40px" />
                    <select id="selDescansoDiarioHasta" class="dropDowns">
                          <option value="A.M." selected="selected">a.m.</option>
                        <option value="P.M.">p.m.</option>
                   </select>
                </td>
            </tr>
<%--            <tr>
                <td colspan="2" class="labelSubtitulo">
                    <br />
                    Fin de Jornada
                </td>
            </tr>
            <tr>
                <td valign="middle">
                    Desde
                    <input id="txtFinJornadaDesde" type="text" class="formatearHoras" style="width: 40px" />
                    <select id="selFinJornadaDesde" class="dropDowns">
                       <option value="A.M." selected="selected">a.m.</option>
                        <option value="P.M.">p.m.</option>
                   </select>
                </td>
                <td valign="middle">
                    Hasta
                    <input id="txtFinJornadaHasta" type="text" class="formatearHoras" style="width: 40px" />
                    <select id="selFinJornadaHasta" class="dropDowns">
                         <option value="A.M." selected="selected">a.m.</option>
                        <option value="P.M.">p.m.</option>
                   </select>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <br />
                </td>
            </tr>--%>
        </table>
        <br />
        <table class="td-content">
            <tr>
                <td colspan="2" class="labelSubtitulo">
                    <br />
                    Descanso Semanal
                </td>
            </tr>
            <tr>
                <td valign="middle">
                    Día
                    <select id="ddlDescansoSemanalDesde" class="dropDowns">
                        <option value="0" selected="selected">Seleccione</option>
                        <option value="1">Domingo</option>
                        <option value="2">Lunes</option>
                        <option value="3">Martes</option>
                        <option value="4">Miercoles</option>
                        <option value="5">Jueves</option>
                        <option value="6">Viernes</option>
                        <option value="7">Sabado</option>
                    </select>
                </td>
                <td valign="middle">
                    Hora
                    <input id="txtDescansoSemanalHrsDesde" type="text" class="formatearHoras" style="width: 40px" />
                    <select id="selDescansoSemanalHrsDesde" class="dropDowns">
                         <option value="A.M." selected="selected">a.m.</option>
                        <option value="P.M.">p.m.</option>
                   </select>
                </td>
            </tr>
            <tr>
                <td valign="middle">
                    Día
                    <select id="ddlDescansoSemanalHasta" class="dropDowns" name="D2">
                        <option value="0" selected="selected">Seleccione</option>
                        <option value="1">Domingo</option>
                        <option value="2">Lunes</option>
                        <option value="3">Martes</option>
                        <option value="4">Miercoles</option>
                        <option value="5">Jueves</option>
                        <option value="6">Viernes</option>
                        <option value="7">Sabado</option>
                    </select>
                </td>
                <td valign="middle">
                    Hora
                    <input id="txtDescansoSemanalHrsHasta" type="text" class="formatearHoras" style="width: 40px" />
                    <select id="selDescansoSemanalHrsHasta" class="dropDowns">
                         <option value="A.M." selected="selected">a.m.</option>
                        <option value="P.M.">p.m.</option>
                   </select>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <br />
                </td>
            </tr>
        </table>
        <br />
        <div style="width: 416px; text-align: right">
            <span id="btnGuardar" style="font-size: 8pt;">Guardar</span> &nbsp; <span id="btnCancelar"
                style="font-size: 8pt;">Cancelar</span>
        </div>
    </div>
    <div style="text-align: right; width: 860px;">
        <span id="btnAgregar" style="font-size: 8pt;">Agregar</span>
        <br />
    </div>
   <br />
        <div id="divMensaje">
            <span id="lblMensaje"></span>
 </div>
</asp:Content>
