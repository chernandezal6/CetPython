Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Web.Script.Services
Imports System.Data
Imports SuirPlus.MDT
Imports System.Web.Script.Serialization
Imports SuirPlus.Utilitarios

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class MDT
    Inherits System.Web.Services.WebService
    'Private usuarioLogueado As String = HttpContext.Current.Session("UsrUserName")
    'Private idRegPatronalLogueado As String = HttpContext.Current.Session("ImpRegistroPatronal")
    'Private idRegPatronalLogueado2 As String = HttpContext.Current.Session("UsrRegistroPatronal")


    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getPuestos(pCriterio As String, pPageSize As Integer, pCurrentPage As Integer, pSortColumn As String, pSortOrder As String) As String
        Try
            Dim dt = SuirPlus.MDT.General.getPuestos(pCriterio, pCurrentPage, pPageSize)

            Dim cantidadRegistros = dt.Rows(0)("RECORDCOUNT").ToString()
            Dim totalPaginas = Math.Ceiling(cantidadRegistros / pPageSize)

            Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}

            Dim i As Integer = 0

            For Each rs As DataRow In dt.Rows
                jArray(i) = New String() {rs("ID_OCUPACION").ToString(), rs("DESCRIPCION").ToString()}
                i = i + 1
            Next

            Dim jsonData = New With { _
                    Key .total = totalPaginas, _
                    Key .page = pCurrentPage, _
                    Key .records = cantidadRegistros, _
                    Key .rows = jArray
                }

            Return New JavaScriptSerializer().Serialize(jsonData)

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getLocalidades(pCriterio As String, pPageSize As Integer, pCurrentPage As Integer, pSortColumn As String, pSortOrder As String) As String
        Try

            Dim dt = SuirPlus.MDT.Localidades.getLocalidades(CInt(pCriterio), pCurrentPage, pPageSize)

            If dt.Rows.Count > 0 Then

                Dim cantidadRegistros = dt.Rows(0)("RECORDCOUNT").ToString()
                Dim totalPaginas = Math.Ceiling(cantidadRegistros / pPageSize)

                Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}
                Dim i As Integer = 0

                For Each rs As DataRow In dt.Rows
                    jArray(i) = New String() {rs("id_localidad").ToString(), rs("LOCALIDAD").ToString(), rs("RNL").ToString(), rs("DESCRIPCION").ToString(), rs("DIRECCION").ToString(), rs("CONTACTO").ToString(), rs("ANIO_INI_OPERACIONES").ToString(), rs("STATUS_DES").ToString()}
                    i = i + 1
                Next

                Dim jsonData = New With { _
                        Key .total = totalPaginas, _
                        Key .page = pCurrentPage, _
                        Key .records = cantidadRegistros, _
                        Key .rows = jArray
                    }

                Return New JavaScriptSerializer().Serialize(jsonData)
            Else
                Throw New Exception("No hay data para mostrar")

            End If

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getLocalidad(IdLocalidad As String) As SuirPlus.MDT.Localidades
        Try
            Dim localidad As New SuirPlus.MDT.Localidades(CInt(IdLocalidad))

            Return localidad

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getTurno(IdTurno As String) As SuirPlus.MDT.Turnos
        Try
            Dim turno As New SuirPlus.MDT.Turnos(CInt(IdTurno))

            Return turno

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getTurnos(pCriterio As String, pPageSize As Integer, pCurrentPage As Integer, pSortColumn As String, pSortOrder As String) As String
        Try

            Dim dt = SuirPlus.MDT.Turnos.getTurnos(CInt(pCriterio), pCurrentPage, pPageSize)

            Dim cantidadRegistros = dt.Rows(0)("RECORDCOUNT").ToString()
            Dim totalPaginas As Double = Math.Ceiling(Convert.ToDouble(cantidadRegistros) / pPageSize)
            If Convert.ToDouble(cantidadRegistros) = 1 Or totalPaginas = 0 Then
                totalPaginas = 1
            End If
            If pPageSize > Convert.ToDouble(cantidadRegistros) Then
                pPageSize = Int16.Parse(totalPaginas)
            End If

            Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}

            Dim i As Integer = 0

            For Each rs As DataRow In dt.Rows
                jArray(i) = New String() {rs("ID_TURNO").ToString(), rs("COD_TURNO").ToString(), rs("DESCRIPCION").ToString(), rs("INICIO_JORNADA").ToString(), rs("DESCANSO_DIARIO").ToString(), rs("FIN_JORNADA").ToString(), rs("DESCANSO_SEMANAL").ToString(), rs("STATUS").ToString()}
                i = i + 1
            Next

            Dim jsonData = New With { _
                    Key .total = totalPaginas, _
                    Key .page = pCurrentPage, _
                    Key .records = cantidadRegistros, _
                    Key .rows = jArray
                }

            Return New JavaScriptSerializer().Serialize(jsonData)

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ListarLocalidades(ByVal idRegPatronal As Integer) As String
        Try
            Dim dt = Localidades.listarLocalidades(idRegPatronal)

            Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}

            Dim i As Integer = 0

            For Each rs As DataRow In dt.Rows
                jArray(i) = New String() {rs("ID").ToString(), rs("DESCRIPCION").ToString()}
                i = i + 1
            Next

            Return New JavaScriptSerializer().Serialize(jArray)

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ListarTurnos(ByVal idRegPatronal As Integer) As String
        Try
            Dim dt = Turnos.listarTurnos(idRegPatronal)

            Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}

            Dim i As Integer = 0

            For Each rs As DataRow In dt.Rows
                jArray(i) = New String() {rs("ID").ToString(), rs("DESCRIPCION").ToString()}
                i = i + 1
            Next

            Return New JavaScriptSerializer().Serialize(jArray)

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ListarActividad() As String
        Try
            Dim dt = SuirPlus.MDT.General.listarActividad

            Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}

            Dim i As Integer = 0

            For Each rs As DataRow In dt.Rows
                jArray(i) = New String() {rs("ID").ToString(), rs("DESCRIPCION").ToString()}
                i = i + 1
            Next

            Return New JavaScriptSerializer().Serialize(jArray)

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function listarParqueZonaFranca() As String
        Try
            Dim dt = SuirPlus.MDT.General.listarParqueZonaFranca

            Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}

            Dim i As Integer = 0

            For Each rs As DataRow In dt.Rows
                jArray(i) = New String() {rs("ID").ToString(), rs("DESCRIPCION").ToString()}
                i = i + 1
            Next

            Return New JavaScriptSerializer().Serialize(jArray)

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getNacionalidades() As String
        Try

            Dim dt = SuirPlus.Utilitarios.TSS.get_Nacionalidades()

            Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}

            Dim i As Integer = 0

            For Each rs As DataRow In dt.Rows
                jArray(i) = New String() {rs("id_nacionalidad").ToString(), rs("nacionalidad_des").ToString()}
                i = i + 1
            Next

            Return New JavaScriptSerializer().Serialize(jArray)

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getProvincias() As String
        Try

            Dim dt = SuirPlus.Utilitarios.TSS.getProvincias()
            'For Each dr As DataRow In dt.Rows
            '    If dr("ID_PROVINCIA").ToString() = "99" Then
            '        dr.Delete()
            '        Exit For
            '    End If
            'Next

            Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}

            Dim i As Integer = 0

            For Each rs As DataRow In dt.Rows
                    jArray(i) = New String() {rs("ID_PROVINCIA").ToString(), rs("PROVINCIA_DES").ToString()}
                    i = i + 1
            Next

            Return (New JavaScriptSerializer().Serialize(jArray))

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getMunicipios(ByVal idProvincia As String) As String
        Try

            Dim dt = SuirPlus.Utilitarios.TSS.getMunicipios(idProvincia, "")


            Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}

            Dim i As Integer = 0

            For Each rs As DataRow In dt.Rows
                jArray(i) = New String() {rs("ID_MUNICIPIO").ToString(), rs("MUNICIPIO_DES").ToString()}
                i = i + 1
            Next

            Return New JavaScriptSerializer().Serialize(jArray)

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod()> _
   <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getTrabajador(idRegPatronal As String, documento As String, tipoDoc As String) As String
        Try

            Dim trabajador = SuirPlus.MDT.General.getTrabajador(idRegPatronal, documento, tipoDoc)

            Dim jArray(0 To 2) As String

            If Split(trabajador, "|")(0) <> 0 Then
                jArray(0) = Split(trabajador, "|")(0)
                jArray(1) = Split(trabajador, "|")(1)
            Else
                jArray(0) = Split(trabajador, "|")(0)
                jArray(1) = Split(trabajador, "|")(1)
                jArray(2) = Split(trabajador, "|")(2)


            End If

            Dim jsonData = New With {Key .rows = jArray}

            Return New JavaScriptSerializer().Serialize(jsonData)

        Catch ex As Exception
            Return ex.ToString()
        End Try

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getCiudadano(no_documento As String, tipoDoc As String) As String
        Try

            Dim trabajador = SuirPlus.MDT.General.getCiudadano(no_documento, tipoDoc)

            Dim jArray(0 To 3) As String

            If Split(trabajador, "|")(0) <> 0 Then
                jArray(0) = Split(trabajador, "|")(0)
                jArray(1) = Split(trabajador, "|")(1)
            Else
                jArray(0) = Split(trabajador, "|")(0)
                jArray(1) = Split(trabajador, "|")(1)
                jArray(2) = Split(trabajador, "|")(2)
                jArray(3) = Split(trabajador, "|")(3)
            End If

            Dim jsonData = New With {Key .rows = jArray}

            Return New JavaScriptSerializer().Serialize(jsonData)

        Catch ex As Exception
            Return ex.ToString()
        End Try

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getContactoLocalidad(id_localidad As String, documento As String, tipoDoc As String) As String
        Try

            Dim trabajador = SuirPlus.MDT.General.getContactoLocalidad(id_localidad, documento, tipoDoc)
            Dim jArray(0 To 4) As String

            If Split(trabajador, "|")(0) <> 0 Then
                jArray(0) = Split(trabajador, "|")(0)
                jArray(1) = Split(trabajador, "|")(1)
            Else
                jArray(0) = Split(trabajador, "|")(0)
                jArray(1) = Split(trabajador, "|")(1)
                jArray(2) = Split(trabajador, "|")(2)
                jArray(3) = Split(trabajador, "|")(3)
                jArray(4) = Split(trabajador, "|")(4)
            End If

            Dim jsonData = New With {Key .rows = jArray}

            Return New JavaScriptSerializer().Serialize(jsonData)

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getPuestoList(ByVal Puesto As String) As String()

        Try

            'Dim miPuesto = SuirPlus.MDT.General.getPuestoList(Puesto)

            'Dim list As New List(Of String)

            'If miPuesto.Rows.Count > 0 Then

            '    For Each dr As Data.DataRow In miPuesto.Rows
            '        list.Add(dr.Field(Of String)("Ocupacion"))
            '        list.Add(dr.Field(Of String)("Id_Ocupacion"))

            '    Next
            'End If

            'Return list.ToArray
            Dim jArray As New List(Of String)()

            Dim miPuesto = SuirPlus.MDT.General.getPuestoList(Puesto)
            'Dim jArray As String()() = New String(miPuesto.Rows.Count - 1)() {}

            Dim i As Integer = 0

            For Each rs As DataRow In miPuesto.Rows
                'jArray(i) = New String() {rs("Ocupacion").ToString(), rs("Id_Ocupacion").ToString()}
                'i = i + 1
                jArray.Add(String.Format("{0}|{1}", rs("Ocupacion"), rs("Id_Ocupacion")))
            Next

            Return jArray.ToArray()


        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Throw New Exception(ex.ToString())
        End Try
    End Function

    'Insertar o actualizar una turno
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function procesarTurno(ByVal p_id_turno As String, ByVal p_id_registro_patronal As String, ByVal p_descripcion As String,
                                           ByVal p_trabajo_1_desde As String, ByVal p_trabajo_1_hasta As String, ByVal p_descanso_1_desde As String,
                                           ByVal p_descanso_1_hasta As String, ByVal p_trabajo_2_desde As String, ByVal p_trabajo_2_hasta As String,
                                           ByVal p_descanso_dia_desde As String, ByVal p_descanso_hora_desde As String, ByVal p_descanso_dia_hasta As String,
                                           ByVal p_descanso_hora_hasta As String, ByVal ult_usuario_act As String, ByVal p_status As String) As String

        Try
            Dim result = SuirPlus.MDT.Turnos.procesarTurno(CInt(p_id_turno), CInt(p_id_registro_patronal), p_descripcion,
                                                           p_trabajo_1_desde, p_trabajo_1_hasta, p_descanso_1_desde, p_descanso_1_hasta, p_trabajo_2_desde,
                                                           p_trabajo_2_hasta, p_descanso_dia_desde, p_descanso_hora_desde, p_descanso_dia_hasta, p_descanso_hora_hasta, ult_usuario_act, p_status
                                                           )

            Return result

        Catch ex As Exception
            Return ex.Message()

        End Try

    End Function

    'Insertar o actualizar una localidad
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function procesarLocalidad(ByVal id_localidad As String, ByVal id_registro_patronal As String,
                                           ByVal descripcion As String, ByVal status As String,
                                           ByVal calle As String, ByVal edificio As String, ByVal sector As String,
                                           ByVal id_provincia As String, ByVal id_municipio As String, ByVal correo_electronico As String,
                                           ByVal fax_contacto As String, ByVal telefono_contacto As String, ByVal no_documento As String, ByVal ini_operaciones As String,
                                           ByVal valor_instalacion As String, ByVal ult_usuario_act As String, ByVal id_actividad As String, ByVal a_que_se_dedica As String,
                                           ByVal es_zona_franca As String, ByVal tipo_zona_franca As String, ByVal id_zona_franca As String, ByVal no_documento_rep As String) As String


        Try
            Dim result = SuirPlus.MDT.Localidades.procesarLocalidad(id_localidad, CInt(id_registro_patronal), descripcion, status,
                                                                    calle, edificio, sector, id_provincia, id_municipio, correo_electronico,
                                                                    fax_contacto, telefono_contacto, no_documento, ini_operaciones, valor_instalacion, ult_usuario_act,
                                                                    id_actividad, a_que_se_dedica, es_zona_franca, tipo_zona_franca, id_zona_franca, no_documento_rep)

            Return result

        Catch ex As Exception
            Return ex.Message()

        End Try

    End Function

    'Insertar o actualizar en MDT_cartera
    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ProcesarTrabajadorMDT(ByVal tipo As String, ByVal id_nss As String, ByVal id_planilla As String, ByVal id_localidad As String, ByVal id_turno As String, ByVal id_ocupacion As String, ByVal segundo_puesto As String, ByVal vacaciones_desde As String, ByVal vacaciones_hasta As String, ByVal observacion As String, ByVal salario As String, ByVal periodo As String, ByVal fechaNovedad As String, ByVal ocupacion_des As String, ByVal ult_usuario_act As String) As String
        Try
            Dim result = ""
            Dim oDesc = ocupacion_des
            oDesc = oDesc.Split("|")(0)

            Dim id_registro_patronal = HttpContext.Current.Session("UsrRegistroPatronal")
            'id_registro_patronal = 0
            If id_registro_patronal > 0 Then

                If tipo = "I" Then
                    result = SuirPlus.MDT.General.IngresoTrabajadorMDT(Convert.ToInt32(id_registro_patronal), Convert.ToInt32(id_nss), id_planilla, Convert.ToInt32(id_localidad), Convert.ToInt32(id_turno), Convert.ToInt32(id_ocupacion), segundo_puesto, vacaciones_desde, vacaciones_hasta, observacion, salario, periodo, fechaNovedad, oDesc, ult_usuario_act)
                ElseIf tipo = "S" Then
                    result = SuirPlus.MDT.General.SalidaTrabajadorMDT(Convert.ToInt32(id_registro_patronal), Convert.ToInt32(id_nss), id_planilla, Convert.ToInt32(id_localidad), Convert.ToInt32(id_turno), Convert.ToInt32(id_ocupacion), segundo_puesto, vacaciones_desde, vacaciones_hasta, observacion, salario, periodo, fechaNovedad, oDesc, ult_usuario_act)
                ElseIf tipo = "C" Then
                    result = SuirPlus.MDT.General.CambioTrabajadorMDT(Convert.ToInt32(id_registro_patronal), Convert.ToInt32(id_nss), id_planilla, Convert.ToInt32(id_localidad), Convert.ToInt32(id_turno), Convert.ToInt32(id_ocupacion), segundo_puesto, vacaciones_desde, vacaciones_hasta, observacion, salario, periodo, oDesc, ult_usuario_act)
                End If
            Else
                'este codigo es para causar el efecto de redireccion al login 
                Context.Response.ClearHeaders()
                Context.Response.ClearContent()
                Context.Response.Status = "401 La conexion ha expirado..."
                Context.Response.StatusCode = 401
                Context.Response.StatusDescription = "La conexion ha expirado..."
                Context.Response.Flush()
            End If

            Return result

        Catch ex As Exception
            Return ex.Message
        End Try

    End Function


    ' Insertar o actualizar en MDT_cartera SOBRECARGA 
    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ProcesarTrabajadorMDT2(ByVal tipo As String, ByVal id_nss As String, ByVal id_planilla As String, ByVal id_localidad As String, ByVal id_turno As String, ByVal id_ocupacion As String, ByVal segundo_puesto As String, ByVal vacaciones_desde As String, ByVal vacaciones_hasta As String, ByVal observacion As String, ByVal salario As String, ByVal periodo As String, ByVal fechaNovedad As String, ByVal ocupacion_des As String, ByVal tipo_cambio As String, ByVal fecha_cambio As String, ByVal ult_usuario_act As String) As String
        Try
            Dim result = ""
            Dim oDesc = ocupacion_des
            oDesc = oDesc.Split("|")(0)

            Dim id_registro_patronal = HttpContext.Current.Session("UsrRegistroPatronal")
            'id_registro_patronal = 0
            If id_registro_patronal > 0 Then

                If tipo = "I" Then
                    result = SuirPlus.MDT.General.IngresoTrabajadorMDT(Convert.ToInt32(id_registro_patronal), Convert.ToInt32(id_nss), id_planilla, Convert.ToInt32(id_localidad), Convert.ToInt32(id_turno), Convert.ToInt32(id_ocupacion), segundo_puesto, vacaciones_desde, vacaciones_hasta, observacion, salario, periodo, fechaNovedad, oDesc, ult_usuario_act)
                ElseIf tipo = "S" Then
                    result = SuirPlus.MDT.General.SalidaTrabajadorMDT(Convert.ToInt32(id_registro_patronal), Convert.ToInt32(id_nss), id_planilla, Convert.ToInt32(id_localidad), Convert.ToInt32(id_turno), Convert.ToInt32(id_ocupacion), segundo_puesto, vacaciones_desde, vacaciones_hasta, observacion, salario, periodo, fechaNovedad, oDesc, ult_usuario_act)
                ElseIf tipo = "C" Then
                    result = SuirPlus.MDT.General.CambioTrabajadorMDT2(Convert.ToInt32(id_registro_patronal), Convert.ToInt32(id_nss), id_planilla, Convert.ToInt32(id_localidad), Convert.ToInt32(id_turno), Convert.ToInt32(id_ocupacion), segundo_puesto, vacaciones_desde, vacaciones_hasta, observacion, salario, periodo, oDesc, tipo_cambio, fecha_cambio, ult_usuario_act)
                End If
            Else
                'este codigo es para causar el efecto de redireccion al login 
                Context.Response.ClearHeaders()
                Context.Response.ClearContent()
                Context.Response.Status = "401 La conexion ha expirado..."
                Context.Response.StatusCode = 401
                Context.Response.StatusDescription = "La conexion ha expirado..."
                Context.Response.Flush()
            End If

            Return result

        Catch ex As Exception
            Return ex.Message
        End Try

    End Function


    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function listadoPeriodos() As String
        Try
            Dim dt = SuirPlus.MDT.General.listadoPeriodos

            Dim Cadena = dt.Rows(0).Item(0)
            Dim lista As String() = Cadena.Split(New Char() {"|"c})
            Dim jArray As String()() = New String(lista.Length - 1)() {}

            For i As Integer = 0 To lista.Length - 1
                jArray(i) = New String() {lista(i).ToString(), lista(i).ToString()}
            Next

            Return New JavaScriptSerializer().Serialize(jArray)

        Catch ex As Exception
            Throw ex
        End Try

    End Function

    'verificamos si la empresa logeada paga MDT
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function pagaMDT(idRegPatronal As String) As String
        Try

            If idRegPatronal <> String.Empty Then
                Dim emp As New SuirPlus.Empresas.Empleador(CInt(idRegPatronal))
                Return emp.PagaMDT
            End If
            Return String.Empty
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getInformacionTrabajador(no_documento As String, tipoDoc As String, id_registro_patronal As Int32)
        ' id_registro_patronal = 476208
        Try
            Dim Trabajador As New SuirPlus.MDT.General(no_documento, tipoDoc, id_registro_patronal)
            Return Trabajador

        Catch ex As Exception
            Return ex.Message
            'Return "Hubo una excepcion en el web service"
        End Try

    End Function


    'Insertar un extranjero al MDT
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ingresoExtranjeroMDT(ByVal nombres As String, ByVal primerApellido As String,
                                           ByVal segundoApellido As String, ByVal fechaNamimiento As String, ByVal sexo As String, nroDocumento As String, tipoDoc As String,
                                            ByVal idNacionalidad As Integer, ByVal ult_usuario_act As String) As String

        Try
            Dim result = SuirPlus.MDT.General.IngresoExtranjeroMDT(nombres, primerApellido, segundoApellido, fechaNamimiento, sexo, nroDocumento, tipoDoc, CInt(idNacionalidad), ult_usuario_act)

            Return result

        Catch ex As Exception
            Return ex.Message()

        End Try

    End Function

    'Actualizar la nacionalidad de un extranjero al MDT
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function actualizarExtranjeroMDT(nroDocumento As String, tipoDoc As String, ByVal idNacionalidad As Integer, ByVal ult_usuario_act As String) As String

        Try
            Dim result = SuirPlus.MDT.General.ActualizarExtranjeroMDT(nroDocumento, tipoDoc, CInt(idNacionalidad), ult_usuario_act)

            Return result

        Catch ex As Exception
            Return ex.Message()

        End Try

    End Function



End Class
