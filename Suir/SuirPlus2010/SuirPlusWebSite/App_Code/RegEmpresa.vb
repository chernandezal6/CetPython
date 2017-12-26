Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Web.Script.Services
Imports System.Data
Imports System.Web.Script.Serialization
Imports SuirPlus.Utilitarios
Imports SuirPlus.Empresas
Imports SuirPlus.SolicitudesEnLinea
Imports System.IO
' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class RegEmpresa
    Inherits RegistroEmpresaSeguridad


    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ListarEmpresas() As String
        Dim result As String = String.Empty

        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim lista = SuirPlus.Empresas.Empleador.getClaseEmpresa()
                    Dim jArray As String()() = New String(lista.Rows.Count - 1)() {}
                    Dim i As Integer = 0

                    For Each rs As DataRow In lista.Rows
                        jArray(i) = New String() {rs("ID").ToString(), rs("DESCRIPCION").ToString()}
                        i = i + 1
                    Next
                    result = New JavaScriptSerializer().Serialize(jArray)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ValidarCodigoSolicitud(ByVal CodSol As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim Cod = SuirPlus.SolicitudesEnLinea.Solicitudes.isValidaNroSolicitud(CodSol)

                    result = New JavaScriptSerializer().Serialize(Cod)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getInfoEmpresa(ByVal CodSol As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim lista = SuirPlus.SolicitudesEnLinea.Solicitudes.getInfoEmpresa(CodSol)
                    Dim jArray As String()() = New String(lista.Rows.Count - 1)() {}
                    Dim i As Integer = 0

                    For Each rs As DataRow In lista.Rows
                        jArray(i) = New String() {rs("RAZON_SOCIAL").ToString(), rs("NOMBRE_COMERCIAL").ToString(), rs("SECTOR_SALARIAL").ToString(),
                                                  rs("ID_SECTOR_ECONOMICO").ToString(), rs("ID_ACTIVIDAD_ECO").ToString(),
                                                  rs("TIPO_ZONA_FRANCA").ToString(), rs("PARQUE").ToString(),
                                                  rs("CALLE").ToString(), rs("NUMERO").ToString(), rs("APARTAMENTO").ToString(),
                                                  rs("SECTOR").ToString(), rs("PROVINCIA").ToString(),
                                                  rs("ID_MUNICIPIO").ToString(), rs("TELEFONO_1").ToString(),
                                                  rs("EXT_1").ToString(), rs("TELEFONO_2").ToString(), rs("EXT_2").ToString(),
                                                  rs("FAX").ToString(), rs("EMAIL").ToString(), rs("CEDULA_REPRESENTANTE").ToString(),
                                                  rs("TELEFONO_REP_1").ToString(), rs("EXT_REP_1").ToString(),
                                                  rs("TELEFONO_REP_2").ToString(), rs("EXT_REP_2").ToString()}
                        i = i + 1
                    Next

                    result = New JavaScriptSerializer().Serialize(jArray)
                Else
                    Throw New Exception("Este codigo de solicitud no es correcto")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function


    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getInfoEmpresaEdit(ByVal IdSol As Integer) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim lista = SuirPlus.SolicitudesEnLinea.Solicitudes.getInfoEmpresaEdit(IdSol)
                    Dim jArray As String()() = New String(lista.Rows.Count - 1)() {}
                    Dim i As Integer = 0

                    For Each rs As DataRow In lista.Rows
                        jArray(i) = New String() {rs("RAZON_SOCIAL").ToString(), rs("NOMBRE_COMERCIAL").ToString(), rs("SECTOR_SALARIAL").ToString(),
                                                  rs("ID_SECTOR_ECONOMICO").ToString(), rs("ID_ACTIVIDAD_ECO").ToString(),
                                                  rs("TIPO_ZONA_FRANCA").ToString(), rs("PARQUE").ToString(),
                                                  rs("CALLE").ToString(), rs("NUMERO").ToString(), rs("APARTAMENTO").ToString(),
                                                  rs("SECTOR").ToString(), rs("PROVINCIA").ToString(),
                                                  rs("ID_MUNICIPIO").ToString(), rs("TELEFONO_1").ToString(),
                                                  rs("EXT_1").ToString(), rs("TELEFONO_2").ToString(), rs("EXT_2").ToString(),
                                                  rs("FAX").ToString(), rs("EMAIL").ToString(), rs("CEDULA_REPRESENTANTE").ToString(),
                                                  rs("TELEFONO_REP_1").ToString(), rs("EXT_REP_1").ToString(),
                                                  rs("TELEFONO_REP_2").ToString(), rs("EXT_REP_2").ToString()}
                        i = i + 1
                    Next

                    result = New JavaScriptSerializer().Serialize(jArray)
                Else
                    Throw New Exception("Este codigo de solicitud no es correcto")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function MostrarRequisitosLista() As String
        Dim result As String = String.Empty
        Dim EmpresaID = Convert.ToInt32(1)

        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim lista = SuirPlus.Empresas.Empleador.getDocClaseEmpresa(EmpresaID)
                    Dim jArray As String()() = New String(lista.Rows.Count - 1)() {}
                    Dim i As Integer = 0

                    For Each rs As DataRow In lista.Rows
                        jArray(i) = New String() {rs("id_seq").ToString(), rs("descripcion").ToString(), rs("obligatorio").ToString()}
                        i = i + 1
                    Next

                    result = New JavaScriptSerializer().Serialize(jArray)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function MostrarRequisitos(pCriterio As String, pPageSize As Integer, pCurrentPage As Integer, pSortColumn As String, pSortOrder As String) As String
        Dim result As String = String.Empty
        Dim EmpresaID = Convert.ToInt32(pCriterio)

        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim lista = SuirPlus.Empresas.Empleador.getDocClaseEmpresa(EmpresaID)
                    Dim jArray As String()() = New String(lista.Rows.Count - 1)() {}

                    Dim i As Integer = 0

                    For Each rs As DataRow In lista.Rows
                        jArray(i) = New String() {rs("descripcion").ToString(), rs("obligatorio").ToString()}
                        i = i + 1
                    Next

                    Dim jsonData = New With { _
                           Key .total = 1, _
                           Key .page = 1, _
                           Key .records = 25, _
                           Key .rows = jArray
                       }
                    result = New JavaScriptSerializer().Serialize(jsonData)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function GenerarCodigo(ByVal ClaseEmpresa As Integer, ByVal Usuario As String, ByVal RNC_o_Cedula As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim NroSolicitud = GeneradorSolicitud()
                    Dim IdCodSol = String.Empty
                    Dim resultado = String.Empty
                    While SuirPlus.SolicitudesEnLinea.Solicitudes.isValidaNroSolicitud(NroSolicitud) = True
                        NroSolicitud = GeneradorSolicitud()
                    End While

                    resultado = SuirPlus.SolicitudesEnLinea.Solicitudes.crearSolicitudRegEmp(NroSolicitud, Usuario, ClaseEmpresa, RNC_o_Cedula, "Creación solicitud de nueva empresa")
                    If (resultado.Chars(0) = "0") And (resultado.Chars(1) = "|") Then
                        For value As Integer = (resultado.Length - 1) To 2 Step -1
                            'Se saca el ID del codigo de solicitud de manera inversa
                            IdCodSol = resultado.Chars(value) + IdCodSol
                            Console.WriteLine(IdCodSol)
                        Next
                    End If

                    result = New JavaScriptSerializer().Serialize(NroSolicitud + "|" + IdCodSol)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If
            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    Function GeneradorSolicitud() As String
        Dim chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        Dim chars2 = "0123456789"
        Dim stringChars = New Char(2) {}
        Dim stringChars2 = New Char(2) {}

        Dim random = New Random()

        For i As Integer = 0 To stringChars.Length - 1
            stringChars(i) = chars(random.[Next](chars.Length))
        Next

        For i As Integer = 0 To stringChars2.Length - 1
            stringChars2(i) = chars2(random.[Next](chars2.Length))
        Next

        Dim finalString = New [String](stringChars + "-" + stringChars2)

        Return finalString
    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ValidarEmpleador(ByVal empleador As String, tipo_empresa As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim resultado = SuirPlus.Empresas.Empleador.busquedaInicial(empleador, tipo_empresa)

                    result = New JavaScriptSerializer().Serialize(resultado)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getEmpleadorDatos(ByVal rncCedula As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim dt = SuirPlus.Utilitarios.TSS.getEmpleadorDatos(rncCedula)

                    If (dt.Rows.Count > 0) Then
                        Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}
                        Dim i As Integer = 0

                        For Each rs As DataRow In dt.Rows
                            jArray(i) = New String() {rs("RNC_O_CEDULA").ToString(), rs("NOMBRE_COMERCIAL").ToString(), rs("RAZON_SOCIAL").ToString}
                            i = i + 1
                        Next

                        result = (New JavaScriptSerializer().Serialize(jArray))
                    Else
                        Throw New Exception("El Empleador no esta registrado")
                    End If
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getResumenEmp(ByVal CodSol As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim dt = SuirPlus.SolicitudesEnLinea.Solicitudes.getResumenEmp(CodSol)

                    If (dt.Rows.Count > 0) Then
                        Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}
                        Dim i As Integer = 0

                        For Each rs As DataRow In dt.Rows
                            jArray(i) = New String() {rs("RNC_O_CEDULA").ToString(),
                                                      rs("RAZON_SOCIAL").ToString,
                                                      rs("NOMBRE_COMERCIAL").ToString(),
                                                      rs("EMAIL").ToString(),
                                                      rs("Nombre").ToString(),
                                                      rs("TELEFONO_REP_1").ToString()}
                            i = i + 1
                        Next

                        result = (New JavaScriptSerializer().Serialize(jArray))
                    End If
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function GetHistoricoPasos(ByVal CodSol As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim dt = SuirPlus.SolicitudesEnLinea.Solicitudes.GetHistoricoPasos(CodSol)
                    Dim dv As DataView = dt.DefaultView
                    dv.Sort = "FECHA_REGISTRO DESC"
                    If (dt.Rows.Count > 0) Then
                        Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}
                        Dim i As Integer = 0

                        For Each rs As DataRowView In dv
                            jArray(i) = New String() {rs("STATUS").ToString(),
                                                      rs("DESCRIPCION").ToString(),
                                                      rs("ID_SOLICITUD").ToString(),
                                                      rs("FECHA_REGISTRO").ToString()}
                            i = i + 1
                        Next

                        result = (New JavaScriptSerializer().Serialize(jArray))
                    Else
                        Throw New Exception("El Codígo no es valido")
                    End If
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function CargarComentario(ByVal CodSol As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim dt = SuirPlus.SolicitudesEnLinea.Solicitudes.CargarComentario(CodSol)
                    If (dt.Rows.Count > 0) Then
                        Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}
                        Dim i As Integer = 0

                        For Each rs As DataRow In dt.Rows
                            jArray(i) = New String() {rs("COMENTARIOS").ToString()}
                            i = i + 1
                        Next

                        result = (New JavaScriptSerializer().Serialize(jArray))
                    Else
                        Throw New Exception("El Codígo no es valido")
                    End If
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function GetHistoricoSolicitud(ByVal CodSol As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim dt = SuirPlus.SolicitudesEnLinea.Solicitudes.getHistoricosolicitudes(CodSol)

                    If (dt.Rows.Count > 0) Then
                        Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}
                        Dim i As Integer = 0

                        For Each rs As DataRow In dt.Rows
                            jArray(i) = New String() {rs("STATUS").ToString(),
                                                      rs("FECHA").ToString(),
                                                      rs("ID_CLASE_EMP").ToString()}
                            i = i + 1
                        Next

                        result = (New JavaScriptSerializer().Serialize(jArray))
                    Else
                        Throw New Exception("El Codígo no tiene registro de uso")
                    End If
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ActualizarHistoricoPasos(ByVal CodSol As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim Cod = SuirPlus.SolicitudesEnLinea.Solicitudes.ActualizarHistoricoPasos(CodSol)

                    result = New JavaScriptSerializer().Serialize(Cod)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getProvincias() As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then

                    Dim dt = SuirPlus.Utilitarios.TSS.getProvincias()

                    Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}

                    Dim i As Integer = 0

                    For Each rs As DataRow In dt.Rows
                        jArray(i) = New String() {rs("ID_PROVINCIA").ToString(), rs("PROVINCIA_DES").ToString()}
                        i = i + 1
                    Next

                    result = (New JavaScriptSerializer().Serialize(jArray))
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getMunicipios(ByVal idProvincia As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim dt = SuirPlus.Utilitarios.TSS.getMunicipios(idProvincia, "")
                    Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}
                    Dim i As Integer = 0

                    For Each rs As DataRow In dt.Rows
                        jArray(i) = New String() {rs("ID_MUNICIPIO").ToString(), rs("MUNICIPIO_DES").ToString()}
                        i = i + 1
                    Next

                    result = New JavaScriptSerializer().Serialize(jArray)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getSectoresSalariales() As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim dt = SuirPlus.Mantenimientos.SectoresSalariales.getSectoresSalariales()


                    Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}

                    Dim i As Integer = 0

                    For Each rs As DataRow In dt.Rows
                        jArray(i) = New String() {rs("id").ToString(), rs("descripcion").ToString()}
                        i = i + 1
                    Next

                    result = New JavaScriptSerializer().Serialize(jArray)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getActividad() As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim dt = SuirPlus.MDT.General.listarActividad()
                    Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}
                    Dim i As Integer = 0

                    For Each rs As DataRow In dt.Rows
                        jArray(i) = New String() {rs("id").ToString(), rs("descripcion").ToString()}
                        i = i + 1
                    Next

                    result = New JavaScriptSerializer().Serialize(jArray)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getSectorEconomico() As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim dt = SuirPlus.Utilitarios.TSS.getSectoresEconomicos()
                    Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}
                    Dim i As Integer = 0

                    For Each rs As DataRow In dt.Rows
                        jArray(i) = New String() {rs("ID_SECTOR_ECONOMICO").ToString(), rs("SECTOR_ECONOMICO_DES").ToString()}
                        i = i + 1
                    Next

                    result = New JavaScriptSerializer().Serialize(jArray)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getParqueZonaFranca() As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim dt = SuirPlus.MDT.General.listarParqueZonaFranca
                    Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}
                    Dim i As Integer = 0

                    For Each rs As DataRow In dt.Rows
                        jArray(i) = New String() {rs("id").ToString(), rs("descripcion").ToString()}
                        i = i + 1
                    Next

                    result = New JavaScriptSerializer().Serialize(jArray)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function InsertarEmpleador() As String
        Try

            'Empresa
            Dim TipoEmpresa = Context.Request.QueryString("ddlTipoEmpresa")
            Dim RNC = Context.Request.QueryString("txtRNC_O_Cedula")
            Dim RazonSocial = Context.Request.QueryString("txtRazonSocial")
            Dim NombreComercial = Context.Request.QueryString("txtNombreComercial")
            Dim SectorSalarial = Context.Request.QueryString("ddlSectorSalarial")
            Dim SectorEconomico = Context.Request.QueryString("ddlSectorEconomico")
            Dim Actividad = Context.Request.QueryString("ddlActividad")
            Dim TipoZonaFranca = Context.Request.QueryString("ddlTipoZonaFranca")
            Dim EsZonaFranca = Context.Request.QueryString("EsZonaFranca")
            Dim Parque = Context.Request.QueryString("ddlParque")
            Dim Calle = Context.Request.QueryString("txtCalle")
            Dim Numero = Context.Request.QueryString("txtNumero")
            Dim Edificio = Context.Request.QueryString("txtEdificio")
            Dim Piso = Context.Request.QueryString("txtPiso")
            Dim Apartamento = Context.Request.QueryString("txtApartamento")
            Dim Sector = Context.Request.QueryString("txtSector")
            Dim Provincia = Context.Request.QueryString("ddlProvincia")
            Dim Municipio = Context.Request.QueryString("ddlMunicipio")
            Dim Telefono1 = Context.Request.QueryString("txtTel1")
            Dim Telefono2 = Context.Request.QueryString("txtTel2")
            Dim Ext1 = Context.Request.QueryString("txtExt1")
            Dim Ext2 = Context.Request.QueryString("txtExt2")

            'Representante
            Dim Representante_Cedula_Pasaporte = Context.Request.QueryString("txtRepresentante")
            Dim RepresentanteTelefono1 = Context.Request.QueryString("txtRepTel1")
            Dim RepresentanteTelefono2 = Context.Request.QueryString("txtRepTel2")
            Dim RepresentanteExt1 = Context.Request.QueryString("txtRepTel1")
            Dim RepresentanteExt2 = Context.Request.QueryString("txtRepTel2")
            Dim RepresentanteEmail = Context.Request.QueryString("txtRepEmail")
            Dim Fax = Context.Request.QueryString("Fax")
            Dim Email = Context.Request.QueryString("txtEmail")
            Dim NotificaEmail = Context.Request.QueryString("RepresentanteNotificacion")




            Dim strRet As String = SuirPlus.Empresas.Empleador.insertaEmpleador(SectorEconomico,
                                                                                 Municipio,
                                                                                 RNC,
                                                                                 RazonSocial,
                                                                                 NombreComercial,
                                                                                 Calle,
                                                                                 Numero,
                                                                                 Edificio,
                                                                                 Piso, Apartamento, Sector, Telefono1, Ext1, Telefono2, Ext2, Fax, Email, TipoEmpresa, Integer.Parse(SectorSalarial), Nothing, Actividad, Parque, EsZonaFranca, TipoZonaFranca, "HMINAYA")



            If Split(strRet, "|")(0) = "0" Then
                'Obteniendo el nuevo codigo de Registro Patronal
                Dim tmpRegistroPatronal As Integer = Integer.Parse(Split(strRet, "|")(1))
                Dim tmpIdNomina As Integer
                Dim retRep As String

                SuirPlus.Empresas.CRM.insertaRegistroCRM(tmpRegistroPatronal, "Solicitud registro nueva empresa", Nothing, 2, Nothing, "Empleador generado correctamente", "HMINAYA", Nothing, Nothing, Nothing)

                'Insertando Representante
                retRep = SuirPlus.Empresas.Representante.insertaRepresentante(Representante_Cedula_Pasaporte,
                                                                              tmpRegistroPatronal, _
                                                                                  "A", _
                                                                                  NotificaEmail, _
                                                                                  RepresentanteTelefono1, _
                                                                                  RepresentanteExt1.Trim, _
                                                                                  RepresentanteTelefono2, _
                                                                                  RepresentanteExt2.Trim, _
                                                                                  RepresentanteEmail.Trim, _
                                                                                  "OPERACIONES")



                'Verificando posibles errores al crear el representante
                If Split(retRep, "|")(0) = "0" Then
                    Dim Mensaje = Split(retRep, "|")(1)

                    SuirPlus.Empresas.CRM.insertaRegistroCRM(tmpRegistroPatronal, "Solicitud registro nueva empresa", Nothing, 2, Nothing, " Representante creado correctamente", "HMINAYA", Nothing, Nothing, Nothing)

                    'Insertando Nomina
                    SuirPlus.Empresas.Nomina.insertaNomina(tmpRegistroPatronal, "Nómina Principal", "B", "N", Nothing)

                    'Opteniendo el nuevo numero de nomina
                    tmpIdNomina = Integer.Parse(SuirPlus.Empresas.Nomina.getNomina(tmpRegistroPatronal, -1).Rows(0).Item(1))

                    'Consultamos el representante insertado para obtener su NSS'
                    Dim ciudadano = SuirPlus.Utilitarios.TSS.consultaCiudadano("C", Representante_Cedula_Pasaporte)
                    Dim nss As String = String.Empty

                    If Not ciudadano = String.Empty Then
                        nss = Split(ciudadano, "|")(3)
                    End If

                    'Dando acceso a nomina
                    ' El usuario ha utilizar debe ser creado para el manejo de este servicio

                    SuirPlus.Empresas.Representante.darAccesoNomina(tmpRegistroPatronal, tmpIdNomina, Integer.Parse(nss), "HMINAYA")

                    ' Insertando CRM 
                    SuirPlus.Empresas.CRM.insertaRegistroCRM(tmpRegistroPatronal, "Solicitud registro nueva empresa", Nothing, 2, Nothing, "Nomina creada correctamente", "HMINAYA", Nothing, Nothing, Nothing)


                    Return New JavaScriptSerializer().Serialize(Mensaje)

                End If
            End If


            Return New JavaScriptSerializer().Serialize(strRet)
            Return True


        Catch ex As Exception
            Throw ex
        End Try
    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ValidarRepresentante(ByVal cedula_o_pasaporte As String, ByVal documento As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim resultado = SuirPlus.Utilitarios.TSS.consultaCiudadano(documento, cedula_o_pasaporte)

                    result = New JavaScriptSerializer().Serialize(resultado)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function CargarArchivo(ByVal nro_solicitud As Integer, ByVal id_requisito As Integer, ByVal p_documento As Stream) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim resultado = SuirPlus.Empresas.Archivo.GuardarDocCertificacion(nro_solicitud, id_requisito, p_documento)

                    result = New JavaScriptSerializer().Serialize(resultado)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function CargarStatus(ByVal nro_solicitud As String, ByVal id_tipo_solicitud As String, ByVal p_status As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim resultado = SuirPlus.SolicitudesEnLinea.Solicitudes.InsertarHistoricoSol(nro_solicitud, id_tipo_solicitud, p_status)

                    If resultado = 0 Then
                        result = New JavaScriptSerializer().Serialize(resultado)
                    Else
                        Throw New Exception("Error actualizando el estatus de la solicitud")
                    End If
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Function InsertarHistoPasos() As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim id_CodSol = Context.Request.QueryString("Nosolicitud")
                    Dim id_TipoSolicitud = Context.Request.QueryString("id_TipoSolicitud")
                    Dim id_status = Context.Request.QueryString("id_status")

                    Dim strRet As String = SuirPlus.SolicitudesEnLinea.Solicitudes.InsertarHistoricoSol(id_CodSol, id_TipoSolicitud, id_status)

                    If strRet = 0 Then
                        result = New JavaScriptSerializer().Serialize(strRet)
                    Else
                        Dim ex = New Exception()
                        Throw New Exception(ex.Message)
                    End If
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function InsertarEmpleadorTMP() As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim RNC = Context.Request.QueryString("txtRNC_O_Cedula")
                    Dim RazonSocial = Context.Request.QueryString("txtRazonSocial")
                    Dim NombreComercial = Context.Request.QueryString("txtNombreComercial")
                    Dim status = "I"
                    Dim TipoEmpresa = "PR"
                    Dim SectorSalarial = Context.Request.QueryString("ddlSectorSalarial")
                    Dim SectorEconomico = Context.Request.QueryString("ddlSectorEconomico")
                    Dim Actividad = Context.Request.QueryString("ddlActividad")
                    Dim TipoZonaFranca = Context.Request.QueryString("ddlTipoZonaFranca")
                    Dim Parque = Context.Request.QueryString("ddlParque")
                    Dim Calle = Context.Request.QueryString("txtCalle")
                    Dim Numero = Context.Request.QueryString("txtNumero")
                    Dim Apartamento = Context.Request.QueryString("txtApartamento")
                    Dim Sector = Context.Request.QueryString("txtSector")
                    Dim Provincia = Context.Request.QueryString("ddlProvincia")
                    Dim Municipio = Context.Request.QueryString("ddlMunicipio")
                    Dim Telefono1 = Context.Request.QueryString("txtTel1")
                    Dim Ext1 = Context.Request.QueryString("txtExt1")
                    Dim Telefono2 = Context.Request.QueryString("txtTel2")
                    Dim Ext2 = Context.Request.QueryString("txtExt2")
                    Dim Fax = Context.Request.QueryString("Fax")
                    Dim Email = Context.Request.QueryString("txtEmail")
                    'Representante
                    Dim R_Cedula_Pasaporte = Context.Request.QueryString("txtRepresentante")
                    Dim R_Telefono1 = Context.Request.QueryString("txtRepTel1")
                    Dim R_Ext1 = Context.Request.QueryString("txtRepExt1")
                    Dim R_Telefono2 = Context.Request.QueryString("txtRepTel2")
                    Dim R_Ext2 = Context.Request.QueryString("txtRepExt2")
                    Dim idSol = Context.Request.QueryString("txtIdCodSol")

                    Dim strRet As String = SuirPlus.Empresas.Empleador.insertaEmpleadorTMP(RNC,
                                                                                         RazonSocial,
                                                                                         NombreComercial,
                                                                                         status,
                                                                                         TipoEmpresa,
                                                                                         Integer.Parse(SectorSalarial),
                                                                                         Integer.Parse(SectorEconomico),
                                                                                         Actividad,
                                                                                         TipoZonaFranca, Parque,
                                                                                         Calle, Numero,
                                                                                         Apartamento, Sector,
                                                                                         Provincia, Municipio, Telefono1,
                                                                                         Ext1,
                                                                                         Telefono2,
                                                                                         Ext2, Fax, Email,
                                                                                         R_Cedula_Pasaporte, R_Telefono1,
                                                                                         R_Ext1, R_Telefono2, R_Ext2,
                                                                                         "HMINAYA", Date.Now, Integer.Parse(idSol))
                    If strRet = 0 Then
                        result = New JavaScriptSerializer().Serialize(strRet)
                    Else
                        Dim ex = New Exception()
                        Throw New Exception(ex.Message)
                    End If
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try
    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getSolEnProceso(ByVal Usuario As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim dt = SuirPlus.SolicitudesEnLinea.Solicitudes.SolEnProceso(Usuario)
                    Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}

                    Dim i As Integer = 0

                    For Each rs As DataRow In dt.Rows
                        jArray(i) = New String() {rs("NO_SOLICITUD").ToString(), rs("DESCRIPCION").ToString(), rs("rnc_cedula").ToString(), rs("razon_social").ToString(), rs("status").ToString(), Convert.ToDateTime(rs("FECHA_REGISTRO")).Date
                    }
                        i = i + 1
                    Next

                    result = New JavaScriptSerializer().Serialize(jArray)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If
            Return result
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getCantidadDeDoc(ByVal Codigo As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim dt = SuirPlus.SolicitudesEnLinea.Solicitudes.getCantidadDeDoc(Codigo)
                    Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}

                    Dim i As Integer = 0

                    For Each rs As DataRow In dt.Rows
                        jArray(i) = New String() {rs("CANT_DOCS").ToString()}
                        i = i + 1
                    Next

                    result = New JavaScriptSerializer().Serialize(jArray)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If
            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ValidarSolicitud(ByVal Rnc_o_Cedula As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim strRet As String = SuirPlus.SolicitudesEnLinea.Solicitudes.isValidarSolEnProceso(Rnc_o_Cedula)

                    If strRet = 1 Then
                        result = New JavaScriptSerializer().Serialize(strRet)
                    Else
                        Dim ex = New Exception()
                        Throw New Exception(ex.Message)
                    End If
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If
            Return result
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function GetNombreUsuario(ByVal Usuario As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim dt = SuirPlus.SolicitudesEnLinea.Solicitudes.GetNombreUsuario(Usuario)
                    Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}
                    Dim i As Integer = 0

                    For Each rs As DataRow In dt.Rows
                        jArray(i) = New String() {rs("Nombre_Usuario").ToString()}
                        i = i + 1
                    Next

                    result = New JavaScriptSerializer().Serialize(jArray)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ValidarSolEnProceso(ByVal Rnc_o_Cedula As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then

                    Dim strRet As String = SuirPlus.SolicitudesEnLinea.Solicitudes.isValidarSolEnProceso(Rnc_o_Cedula)

                    If strRet = 0 Then
                        result = New JavaScriptSerializer().Serialize(strRet)
                    Else
                        Dim ex = New Exception()
                        Throw New Exception(ex.Message)
                    End If

                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try

    End Function


    <WebMethod(EnableSession:=True)> _
   <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ValidarUsuario(ByVal Usuario As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then

                    Dim strRet As String = SuirPlus.SolicitudesEnLinea.Solicitudes.isValidarUsuarioReg(Usuario)

                    If strRet = 0 Then
                        result = New JavaScriptSerializer().Serialize(strRet)
                    Else
                        Dim ex = New Exception()
                        Throw New Exception(ex.Message)
                    End If

                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try

    End Function


    <WebMethod(EnableSession:=True)> _
   <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ValidarUsuario2(ByVal Usuario As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then

                    Dim strRet As String = SuirPlus.SolicitudesEnLinea.Solicitudes.isValidarUsuarioReg2(Usuario)

                    If strRet = 0 Then
                        result = New JavaScriptSerializer().Serialize(strRet)
                    Else
                        Dim ex = New Exception()
                        Throw New Exception(ex.Message)
                        'Throw New Exception("No puede realizar una nueva solicitud ya que tiene una en proceso")
                    End If

                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
   <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ActualizaStatus(ByVal Solicitud As String, ByVal Status As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then

                    Dim strRet As String = SuirPlus.SolicitudesEnLinea.Solicitudes.ActualizaStatus(Solicitud, Status)

                    If strRet = 0 Then
                        result = New JavaScriptSerializer().Serialize(strRet)
                    Else
                        Dim ex = New Exception()
                        Throw New Exception(ex.Message)
                    End If
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try

    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ActualizarDatosEmpresa() As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim RazonSocial = Context.Request.QueryString("txtRazonSocial")
                    Dim NombreComercial = Context.Request.QueryString("txtNombreComercial")
                    Dim SectorSalarial = Context.Request.QueryString("ddlSectorSalarial")
                    Dim SectorEconomico = Context.Request.QueryString("ddlSectorEconomico")
                    Dim Actividad = Context.Request.QueryString("ddlActividad")
                    Dim TipoZonaFranca = Context.Request.QueryString("ddlTipoZonaFranca")
                    Dim Parque = Context.Request.QueryString("ddlParque")
                    Dim Calle = Context.Request.QueryString("txtCalle")
                    Dim Numero = Context.Request.QueryString("txtNumero")
                    Dim Apartamento = Context.Request.QueryString("txtApartamento")
                    Dim Sector = Context.Request.QueryString("txtSector")
                    Dim Provincia = Context.Request.QueryString("ddlProvincia")
                    Dim Municipio = Context.Request.QueryString("ddlMunicipio")
                    Dim Telefono1 = Context.Request.QueryString("txtTel1")
                    Dim Ext1 = Context.Request.QueryString("txtExt1")
                    Dim Telefono2 = Context.Request.QueryString("txtTel2")
                    Dim Ext2 = Context.Request.QueryString("txtExt2")
                    Dim Fax = Context.Request.QueryString("Fax")
                    Dim Email = Context.Request.QueryString("txtEmail")
                    Dim idSolicitud = Context.Request.QueryString("txtIdCodSol")

                    'Datos del representante
                    Dim R_Cedula_Pasaporte = Context.Request.QueryString("txtRepresentante")
                    Dim R_Telefono1 = Context.Request.QueryString("txtRepTel1")
                    Dim R_Ext1 = Context.Request.QueryString("txtRepExt1")
                    Dim R_Telefono2 = Context.Request.QueryString("txtRepTel2")
                    Dim R_Ext2 = Context.Request.QueryString("txtRepExt2")
                    Dim idSol = Context.Request.QueryString("txtIdCodSol")

                    Dim strRet As String = SuirPlus.SolicitudesEnLinea.Solicitudes.ActualizaDatosEmpresa(RazonSocial,
                                                                                         NombreComercial,
                                                                                         SectorSalarial,
                                                                                         SectorEconomico,
                                                                                         Actividad,
                                                                                         TipoZonaFranca,
                                                                                         Parque, Calle,
                                                                                         Numero, Apartamento,
                                                                                         Sector, Provincia,
                                                                                         Municipio, Telefono1, Ext1,
                                                                                         Telefono2,
                                                                                         Ext2,
                                                                                         Fax, Email,
                                                                                         R_Cedula_Pasaporte,
                                                                                         R_Telefono1, R_Ext1,
                                                                                         R_Telefono2, R_Ext2,
                                                                                         idSolicitud)
                    If strRet = 0 Then
                        result = New JavaScriptSerializer().Serialize(strRet)
                    Else
                        Dim ex = New Exception()
                        Throw New Exception(ex.Message)
                    End If
                Else
                    Throw New Exception("Error al actualizar datos de la empresa!")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try
    End Function

    <WebMethod(EnableSession:=True)> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function GetEditDoc(ByVal IdSolicitud As String) As String
        Dim result As String = String.Empty
        Try
            If Context.Session("Estatus") IsNot Nothing Then
                If Autorizar() = Convert.ToInt32(HttpContext.Current.Session("Estatus")) Then
                    Dim lista = SuirPlus.SolicitudesEnLinea.Solicitudes.GetEditDoc(IdSolicitud)
                    Dim jArray As String()() = New String(lista.Rows.Count - 1)() {}
                    Dim i As Integer = 0

                    For Each rs As DataRow In lista.Rows
                        jArray(i) = New String() {rs("DESCRIPCION").ToString(), rs("OBLIGATORIO").ToString(),
                                                  rs("NOMBRE_DOCUMENTO").ToString()}
                        i = i + 1
                    Next

                    result = New JavaScriptSerializer().Serialize(jArray)
                Else
                    Throw New Exception("Debe ser un usuario registrado para acceder a este servicio")
                End If
            Else
                Context.Response.Redirect("LoginPage.aspx")
            End If

            Return result
        Catch ex As Exception
            Throw ex
        End Try

    End Function

End Class