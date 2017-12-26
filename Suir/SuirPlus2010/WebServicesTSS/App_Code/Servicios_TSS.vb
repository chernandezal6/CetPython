Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Data
Imports SuirPlus
Imports SuirPlus.Empresas
Imports System.Dynamic.DynamicObject


' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="ServiciosTSS")>
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)>
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Public Class Servicios_TSS
    Inherits System.Web.Services.WebService

    Public ReadOnly Property IP() As String
        Get
            Return HttpContext.Current.Request.ServerVariables("LOCAL_ADDR")
        End Get
    End Property

    Private myFact As Facturacion.LiquidacionInfotep
    Dim Rep As New SuirPlusEF.Repositories.ErrorRepository

    <WebMethod(Description:="Consulta de afiliado al SSDS.<br>" &
    "Esta función devuelve un datatable con la información del afiliado." &
    "Esta función retorna un XML con el resultado de la Ejecución.<br>" & "")>
    Public Function ConsultaAfiliado(ByVal p_usuario As String,
                                     ByVal p_password As String,
                                     ByVal p_rnc_cedula As String,
                                     ByVal p_cedula As String) As DataSet

        Dim ds As New DataSet("ConsultaAfiliado")
        Dim res = New SuirPlusEF.Models.Error
        Dim Url = "Servicios_TSS.asmx/ConsultaAfiliado"
        Dim PermisoId = SuirPlus.Seguridad.Permiso.BuscarIdPermisoPorDireccionURL(Url.ToLower())
        Url = Url.ToLower()
        Url = Url.Replace("/ser", "ser")
        p_usuario = Trim(p_usuario)
        p_password = Trim(p_password)
        p_rnc_cedula = Trim(p_rnc_cedula)
        p_cedula = Trim(p_cedula)

        'Verificar Usuario & Password
        Try
            If Seg.CheckUserPass(p_usuario, p_password, IP) = False Then
                res = Rep.GetByIdError("WS010")
                Seg.AgregarMensajeDeError(ds, res.Descripcion)
                Return ds
            Else
                If SuirPlus.Seguridad.Permiso.PermisoWebService(p_usuario, Url) = "S" Then
                    'Validamos si la empresa es valida
                    If Trim(p_rnc_cedula.ToString()) = String.Empty Then
                        res = Rep.GetByIdError("WS011")
                        Seg.AgregarMensajeDeError(ds, res.Descripcion)
                        Return ds
                    Else
                        Dim emp As New Empresas.Empleador(p_rnc_cedula)
                        Dim rz As String = emp.RazonSocial()

                        If rz = Nothing Then
                            res = Rep.GetByIdError("WS011")
                            Seg.AgregarMensajeDeError(ds, res.Descripcion)
                            Return ds
                        End If
                    End If

                    ' Verificar si la cedula es valida
                    If Trim(p_cedula) <> String.Empty Then
                        If Not (SuirPlus.Utilitarios.TSS.existeCiudadano("C", p_cedula)) Then
                            res = Rep.GetByIdError("WS018")
                            Seg.AgregarMensajeDeError(ds, res.Descripcion)
                            Return ds
                        End If
                    End If

                    'Validamos que el usuario tenga Cuota de Consumo
                    Dim ResultadoValidacion = SuirPlus.Seguridad.Permiso.ValidarCuota(PermisoId, p_usuario)
                    Select Case ResultadoValidacion
                        Case "1"
                            SuirPlus.Seguridad.Permiso.ActualizarCuota(PermisoId, p_usuario)
                        Case "0"
                            res = Rep.GetByIdError("WS023")
                            Seg.AgregarMensajeDeError(ds, res.Descripcion)
                            Return ds
                        Case Else
                            ResultadoValidacion = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(ResultadoValidacion)
                            Seg.AgregarMensajeDeError(ds, ResultadoValidacion)
                            Return ds
                    End Select

                    ' buscamos la informacion del afiliado
                    ds.Tables.Add(Servicios.WebServices.getAfiliado(p_rnc_cedula, p_cedula).Copy())
                    ds.Tables(0).TableName = "Tabla"
                    Dim Obtenermensaje = ds.Tables(0).Rows(0).Item(0).ToString()
                    If Obtenermensaje.Contains("WS") Or Obtenermensaje.Contains("-1") Then
                        Obtenermensaje = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(ds.Tables(0).Rows(0).Item(0).ToString())
                        ds.Clear()
                        Seg.AgregarMensajeDeError(ds, Obtenermensaje)
                    End If

                Else
                    res = Rep.GetByIdError("WS014")
                    Seg.AgregarMensajeDeError(ds, res.Descripcion)
                    Return ds
                End If
            End If

            Return ds

        Catch ex As Exception
            Seg.AgregarErrorTecnico(ds, ex.ToString())
            Exepciones.Log.LogToDB(ex.ToString())
            Return ds
        End Try

    End Function

    <WebMethod(Description:="Histórico de Descuento del afiliado.<br>" &
    "Esta función devuelve un datatable con la información del afiliado." &
    "Esta función retorna un XML con el resultado de la Ejecución.<br>" & "")>
    Public Function HistoricoDescuento(ByVal p_usuario As String,
                                       ByVal p_password As String,
                                       ByVal p_rnc_cedula As String,
                                       ByVal p_cedula As String,
                                       ByVal p_nss As String,
                                       ByVal p_ano As String) As DataSet

        Dim ds As New DataSet("HistoricoDescuento")
        Dim res = New SuirPlusEF.Models.Error
        Dim Url = "Servicios_TSS.asmx/HistoricoDescuento"
        Dim PermisoId = SuirPlus.Seguridad.Permiso.BuscarIdPermisoPorDireccionURL(Url.ToLower())
        p_usuario = Trim(p_usuario)
        p_password = Trim(p_password)
        p_rnc_cedula = Trim(p_rnc_cedula)
        p_cedula = Trim(p_cedula)
        p_ano = Trim(p_ano)

        Url = Url.ToLower()
        Url = Url.Replace("/ser", "ser")

        Try
            'Validamos el usuario y password
            If Seg.CheckUserPass(p_usuario, p_password, IP) = False Then
                res = Rep.GetByIdError("WS010")
                Seg.AgregarMensajeDeError(ds, res.Descripcion)
                Return ds
            Else
                'Validamos el usuario tiene el permiso para consumir este servicio
                If SuirPlus.Seguridad.Permiso.PermisoWebService(p_usuario, Url.ToLower()) = "S" Then
                    If Trim(p_rnc_cedula.ToString()) <> String.Empty Then
                        Dim emp As New Empresas.Empleador(p_rnc_cedula)
                        Dim rz As String = emp.RazonSocial()

                        If rz = Nothing Then
                            res = Rep.GetByIdError("WS011")
                            Seg.AgregarMensajeDeError(ds, res.Descripcion)
                            Return ds
                        End If
                    End If

                    ' Verificar si la cedula es valida
                    If Trim(p_cedula) <> String.Empty Then
                        If Not (SuirPlus.Utilitarios.TSS.existeCiudadano("C", p_cedula)) Then
                            res = Rep.GetByIdError("WS018")
                            Seg.AgregarMensajeDeError(ds, res.Descripcion)
                            Return ds
                        End If
                    End If

                    If Trim(p_cedula) = String.Empty And Trim(p_nss) = String.Empty Then
                        Seg.AgregarMensajeDeError(ds, "Al menos uno de los campos, Cédula o NSS es requerido")
                        Return ds
                    End If

                    ' Verificar si el año es válido
                    If Trim(p_ano) <> String.Empty Then
                        If Not IsNumeric(p_ano) Or p_ano < "2003" Then
                            res = Rep.GetByIdError("WS019")
                            Seg.AgregarMensajeDeError(ds, res.Descripcion)
                            Return ds
                        End If
                    End If

                    'Validamos que el usuario tenga Cuota de Consumo
                    Dim ResultadoValidacion = SuirPlus.Seguridad.Permiso.ValidarCuota(PermisoId, p_usuario)
                    Select Case ResultadoValidacion
                        Case "1"
                            SuirPlus.Seguridad.Permiso.ActualizarCuota(PermisoId, p_usuario)
                        Case "0"
                            res = Rep.GetByIdError("WS023")
                            Seg.AgregarMensajeDeError(ds, res.Descripcion)
                            Return ds
                        Case Else
                            ResultadoValidacion = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(ResultadoValidacion)
                            Seg.AgregarMensajeDeError(ds, ResultadoValidacion)
                            Return ds
                    End Select

                    'Buscamos la informacion del afiliado
                    ds.Tables.Add(Servicios.WebServices.getHistoricoDescuento(p_rnc_cedula, p_cedula, p_ano, p_nss).Copy())
                        ds.Tables(0).TableName = "Tabla"
                        Dim Obtenermensaje = ds.Tables(0).Rows(0).Item(0).ToString()
                        If Obtenermensaje.Contains("WS") Or Obtenermensaje.Contains("-1") Then
                            Obtenermensaje = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(ds.Tables(0).Rows(0).Item(0).ToString())
                            ds.Clear()
                            Seg.AgregarMensajeDeError(ds, Obtenermensaje)
                        End If
                    Else
                        res = Rep.GetByIdError("WS014")
                    Seg.AgregarMensajeDeError(ds, res.Descripcion)
                    Return ds
                End If
            End If

            Return ds

        Catch ex As Exception
            Seg.AgregarErrorTecnico(ds, ex.ToString())
            Exepciones.Log.LogToDB(ex.ToString())
            Return ds
        End Try

    End Function

    <WebMethod(Description:="Catálogo Tipo Referencia.<br>" &
    "Esta función devuelve un databable con un listado de los diferentes tipos de referencias disponibles." &
    "Esta función retorna un XML con el resultado de la Ejecución.<br>" & "")>
    Public Function CatalogoTipoReferencia(ByVal p_usuario As String,
                                           ByVal p_password As String) As DataSet

        Dim ds As New DataSet("CatalogoTipoReferencia")
        Dim res = New SuirPlusEF.Models.Error
        Dim Url = "Servicios_TSS.asmx/CatalogoTipoReferencia"
        Url = Url.ToLower()
        Url = Url.Replace("/ser", "ser")
        p_usuario = Trim(p_usuario)
        p_password = Trim(p_password)

        'Verificar Usuario & Password
        If Seg.CheckUserPass(p_usuario, p_password, IP) = False Then
            res = Rep.GetByIdError("WS010")
            Seg.AgregarMensajeDeError(ds, res.Descripcion)
            Return ds
        End If

        'Buscamos los diferentes tipos de referencias existentes
        Try
            If SuirPlus.Seguridad.Permiso.PermisoWebService(p_usuario, Url.ToLower()) = "S" Then
                ds.Tables.Add(SuirPlus.Servicios.WebServices.getTiposReferencias().Copy())
                ds.Tables(0).TableName = "Tabla"
                Dim Obtenermensaje = ds.Tables(0).Rows(0).Item(0).ToString()
                If Obtenermensaje.Contains("WS") Or Obtenermensaje.Contains("-1") Then
                    Obtenermensaje = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(ds.Tables(0).Rows(0).Item(0).ToString())
                    ds.Clear()
                    Seg.AgregarMensajeDeError(ds, Obtenermensaje)
                End If
            Else
                res = Rep.GetByIdError("WS014")
                Seg.AgregarMensajeDeError(ds, res.Descripcion)
                Return ds
            End If
        Catch ex As Exception
            Seg.AgregarErrorTecnico(ds, ex.ToString())
            Exepciones.Log.LogToDB(ex.ToString())
            Return ds
        End Try

        Return ds

    End Function

    <WebMethod(Description:="Consulta de ciudadano.<br>" &
    "Esta función devuelve un databable con la informacion del ciudadano solicitado." &
    "Esta función retorna un XML con el resultado de la Ejecución.<br>" & "")>
    Public Function ConsultaCiudadano(ByVal p_usuario As String,
                                      ByVal p_password As String,
                                      ByVal p_cedula As String) As DataSet

        Dim ds As New DataSet("ConsultaCiudadano")
        Dim res = New SuirPlusEF.Models.Error
        Dim Url = "Servicios_TSS.asmx/ConsultaCiudadano"
        Url = Url.ToLower()
        Url = Url.Replace("/ser", "ser")
        Dim resultado As String = String.Empty
        p_usuario = Trim(p_usuario)
        p_password = Trim(p_password)
        p_cedula = Trim(p_cedula)


        Try
            'Verificar Usuario & Password
            If Trim(p_usuario) = String.Empty Or Trim(p_password) = String.Empty Then
                resultado = Rep.GetByIdError("WS010").Descripcion
                Return ds
            End If

            If Seg.CheckUserPass(p_usuario, p_password, IP) = False Then
                res = Rep.GetByIdError("WS010")
                Seg.AgregarMensajeDeError(ds, res.Descripcion)
                Return ds
            Else
                'Validamos si el usuario tiene permiso para consumir los recursos
                If SuirPlus.Seguridad.Permiso.PermisoWebService(p_usuario, Url.ToLower()) = "S" Then
                    If Trim(p_cedula) = String.Empty Then
                        res = Rep.GetByIdError("WS018")
                        Seg.AgregarMensajeDeError(ds, res.Descripcion)
                        Return ds
                    Else
                        ds.Tables.Add(SuirPlus.Servicios.WebServices.getCiudadano(p_cedula).Copy())
                        ds.Tables(0).TableName = "Tabla"
                        Dim Obtenermensaje = ds.Tables(0).Rows(0).Item(0).ToString()
                        If Obtenermensaje.Contains("WS") Or Obtenermensaje.Contains("-1") Then
                            Obtenermensaje = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(ds.Tables(0).Rows(0).Item(0).ToString())
                            ds.Clear()
                            Seg.AgregarMensajeDeError(ds, Obtenermensaje)
                        End If

                    End If
                Else
                    res = Rep.GetByIdError("WS014")
                    Seg.AgregarMensajeDeError(ds, res.Descripcion)
                    Return ds
                End If
            End If
        Catch ex As Exception
            Seg.AgregarErrorTecnico(ds, ex.ToString())
            Exepciones.Log.LogToDB(ex.ToString())
            Return ds
        End Try

        Return ds

    End Function

    <WebMethod(Description:="Consulta de empleador.<br>" &
    "Esta función devuelve un databable con la informacion del empleador y sus representantes activos." &
    "Esta función retorna un XML con el resultado de la Ejecución.<br>" & "")>
    Public Function ConsultaEmpleador(ByVal p_usuario As String,
                                         ByVal p_password As String,
                                         ByVal p_rnc_cedula As String) As DataSet

        Dim ds As New DataSet("ConsultaEmpleador")
        Dim res = New SuirPlusEF.Models.Error
        Dim Url = "Servicios_TSS.asmx/ConsultaEmpleador"
        Url = Url.ToLower()
        Url = Url.Replace("/ser", "ser")
        Dim resultado As String = String.Empty
        p_usuario = Trim(p_usuario)
        p_password = Trim(p_password)
        p_rnc_cedula = Trim(p_rnc_cedula)

        Try
            'Verificar Usuario & Password
            If (p_usuario) = String.Empty Or (p_password) = String.Empty Then
                res = Rep.GetByIdError("WS010")
                Seg.AgregarMensajeDeError(ds, res.Descripcion)
                Return ds
            End If

            If Seg.CheckUserPass(p_usuario, p_password, IP) = False Then
                res = Rep.GetByIdError("WS010")
                Seg.AgregarMensajeDeError(ds, res.Descripcion)
                Return ds
            Else
                'Validamos si el usuario tiene permiso para consumir los recursos
                If SuirPlus.Seguridad.Permiso.PermisoWebService(p_usuario, Url.ToLower()) = "S" Then
                    If Trim(p_rnc_cedula) = String.Empty Then
                        res = Rep.GetByIdError("WS011")
                        Seg.AgregarMensajeDeError(ds, res.Descripcion)
                        Return ds
                    Else
                        Dim emp As New Empresas.Empleador(p_rnc_cedula)
                        Dim rz As String = emp.RazonSocial()

                        If rz = Nothing Then
                            res = Rep.GetByIdError("WS011")
                            Seg.AgregarMensajeDeError(ds, res.Descripcion)
                            Return ds
                        Else

                            Dim Encabezado As New DataTable
                            Encabezado.Columns.Add("NOMBRE_COMERCIAL")
                            Encabezado.Columns.Add("RAZON_SOCIAL")
                            Encabezado.Columns.Add("ACTIVIDAD_ECONOMICA")
                            Encabezado.Columns.Add("TIPO_EMPRESA")
                            Encabezado.Columns.Add("CATEGORIA_RIESGO")
                            Encabezado.Columns.Add("TELEFONO_1")
                            Encabezado.Columns.Add("TELEFONO_2")
                            Encabezado.Columns.Add("DIRECCION")
                            Encabezado.Columns.Add("SECTOR")
                            Encabezado.Columns.Add("MUNICIPIO")

                            Dim Representante As New DataTable
                            Representante.Columns.Add("ID_NSS")
                            Representante.Columns.Add("NO_DOCUMENTO")
                            Representante.Columns.Add("NOMBRES")
                            Representante.Columns.Add("PRIMER_APELLIDO")
                            Representante.Columns.Add("SEGUNDO_APELLIDO")
                            Representante.Columns.Add("TIPO_REPRESENTANTE")
                            Representante.Columns.Add("TELEFONO_1")
                            Representante.Columns.Add("TELEFONO_2")
                            Representante.Columns.Add("STATUS")

                            Dim ListadoInfo = SuirPlus.Servicios.WebServices.getEmpleadorRep(p_rnc_cedula).Copy()
                            Dim contador As Integer = 0

                            For Each dt In ListadoInfo.Rows
                                If contador = 0 Then
                                    Encabezado.Rows.Add(dt("NOMBRE_COMERCIAL"), dt("RAZON_SOCIAL"), dt("ACTIVIDAD_ECONOMICA"), dt("TIPO_EMPRESA"), dt("CATEGORIA_RIESGO"), dt("TELEFONO_1"), dt("TELEFONO_2"), dt("DIRECCION"), dt("SECTOR"), dt("MUNICIPIO"))
                                    ds.Tables.Add(Encabezado)
                                Else
                                    Representante.Rows.Add(dt("ID_NSS"), dt("NO_DOCUMENTO"), dt("NOMBRES"), dt("PRIMER_APELLIDO"), dt("SEGUNDO_APELLIDO"), dt("TIPO_REPRESENTANTE"), dt("TELEFONO_1"), dt("TELEFONO_2"), dt("STATUS"))
                                    ds.Tables(0).TableName = "representante"
                                End If

                                contador = contador + 1

                            Next

                            ds.Tables.Add(Representante)
                            ds.Tables(0).TableName = "Empresa"

                            Dim Obtenermensaje = ds.Tables(0).Rows(0).Item(0).ToString()
                            If Obtenermensaje.Contains("WS") Or Obtenermensaje.Contains("-1") Then
                                Obtenermensaje = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(ds.Tables(0).Rows(0).Item(0).ToString())
                                ds.Clear()
                                Seg.AgregarMensajeDeError(ds, Obtenermensaje)
                            End If
                        End If

                    End If
                Else
                    res = Rep.GetByIdError("WS014")
                    Seg.AgregarMensajeDeError(ds, res.Descripcion)
                    Return ds
                End If
            End If
        Catch ex As Exception
            Seg.AgregarErrorTecnico(ds, ex.ToString())
            Exepciones.Log.LogToDB(ex.ToString())
            Return ds
        End Try

        Return ds

    End Function

    <WebMethod(Description:="Consulta de extranjeros.<br>" &
    "Esta función devuelve un databable con la informacion del empleador y sus representantes activos." &
    "Esta función retorna un XML con el resultado de la Ejecución.<br>" & "")>
    Public Function ConsultaExtranjero(ByVal p_usuario As String,
                                         ByVal p_password As String,
                                         ByVal p_nro_carnet As String) As DataSet

        Dim ds As New DataSet("ConsultaExtranjero")
        Dim res = New SuirPlusEF.Models.Error
        Dim Url = "Servicios_TSS.asmx/ConsultaExtranjero"
        Url = Url.ToLower()
        Url = Url.Replace("/ser", "ser")
        Dim resultado As String = String.Empty
        p_usuario = Trim(p_usuario)
        p_password = Trim(p_password)
        p_nro_carnet = Trim(p_nro_carnet)

        Try
            'Verificar Usuario & Password
            If Trim(p_usuario) = String.Empty Or Trim(p_password) = String.Empty Then
                resultado = Rep.GetByIdError("WS010").Descripcion
                Return ds
            End If

            If Seg.CheckUserPass(p_usuario, p_password, IP) = False Then
                res = Rep.GetByIdError("WS010")
                Seg.AgregarMensajeDeError(ds, res.Descripcion)
                Return ds
            Else
                'Validamos si el usuario tiene permiso para consumir los recursos
                If SuirPlus.Seguridad.Permiso.PermisoWebService(p_usuario, Url.ToLower()) = "S" Then
                    If Trim(p_nro_carnet) = String.Empty Then
                        res = Rep.GetByIdError("WS021")
                        Seg.AgregarMensajeDeError(ds, res.Descripcion)
                        Return ds
                    Else
                        ds.Tables.Add(SuirPlus.Servicios.WebServices.getExtranjero(p_nro_carnet).Copy())
                        ds.Tables(0).TableName = "Tabla"
                        Dim Obtenermensaje = ds.Tables(0).Rows(0).Item(0).ToString()
                        If Obtenermensaje.Contains("WS") Or Obtenermensaje.Contains("-1") Then
                            Obtenermensaje = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(ds.Tables(0).Rows(0).Item(0).ToString())
                            ds.Clear()
                            Seg.AgregarMensajeDeError(ds, Obtenermensaje)
                        End If
                    End If
                Else
                    res = Rep.GetByIdError("WS014")
                    Seg.AgregarMensajeDeError(ds, res.Descripcion)
                    Return ds
                End If
            End If
        Catch ex As Exception
            Seg.AgregarErrorTecnico(ds, ex.ToString())
            Exepciones.Log.LogToDB(ex.ToString())
            Return ds
        End Try

        Return ds

    End Function

    <WebMethod(Description:="Método para actualizar la categoria de riesgo de una empresa. <br>" &
    "En caso de que la categoria riesgo no pueda actualizarse se mostrara un mensaje de error." &
    "Esta función retorna un XML con el resultado de la Ejecución.<br>" & "")>
    Public Function ActualizarCategoriaRiesgo(ByVal p_usuario As String,
                                              ByVal p_password As String,
                                              ByVal p_rnc_cedula As String,
                                              ByVal p_categoria_riesgo As String) As String

        Dim Url = "Servicios_TSS.asmx/ActualizarCategoriaRiesgo"
        Url = Url.ToLower()
        Url = Url.Replace("/ser", "ser")
        Dim resultado As String = String.Empty
        p_usuario = Trim(p_usuario)
        p_password = Trim(p_password)
        p_rnc_cedula = Trim(p_rnc_cedula)
        p_categoria_riesgo = Trim(p_categoria_riesgo)

        Try
            If Trim(p_usuario) = String.Empty Or Trim(p_password) = String.Empty Then
                resultado = Rep.GetByIdError("WS010").Descripcion
                Return resultado
            End If

            If Seg.CheckUserPass(p_usuario, p_password, IP) = False Then
                resultado = Rep.GetByIdError("WS010").Descripcion
                Return resultado
            Else
                If SuirPlus.Seguridad.Permiso.PermisoWebService(p_usuario, Url.ToLower()) = "S" Then

                    If Trim(p_categoria_riesgo) = String.Empty Then
                        resultado = Rep.GetByIdError("WS020").Descripcion
                        Return resultado
                    End If

                    If Trim(p_rnc_cedula.ToString()) = String.Empty Then
                        resultado = Rep.GetByIdError("WS011").Descripcion
                        Return resultado
                    Else
                        'validamos que la empresa sea valida
                        Dim emp As New Empresas.Empleador(p_rnc_cedula)
                        Dim rz As String = emp.RazonSocial()

                        If rz = Nothing Then
                            resultado = Rep.GetByIdError("WS011").Descripcion
                            Return resultado
                        Else
                            resultado = Servicios.WebServices.ActualizarCategoriaRiesgo(p_usuario, p_rnc_cedula, p_categoria_riesgo)
                            Return resultado
                        End If
                    End If

                Else
                    resultado = Rep.GetByIdError("WS014").Descripcion
                End If

            End If

            Return resultado

        Catch ex As Exception
            Exepciones.Log.LogToDB(ex.ToString())
            Return resultado
        End Try

    End Function

    <WebMethod(Description:="Método para colocar como pagadas las liquidación de Infotep. <br>" &
    "En caso de que la liquidación no pueda pagarse, se retornara un mensaje de Error." &
    "Esta función retorna un XML con el resultado de la Ejecución.<br>" & "")>
    Public Function MarcarPagada(ByVal p_usuario As String,
                                 ByVal p_password As String,
                                 ByVal p_liquidacion As String,
                                 ByVal p_fecha_pago As String,
                                 ByVal p_entidad_recaudadora As Int32) As String

        Dim Fecha As New DateTime
        Dim Url = "Servicios_TSS.asmx/MarcarPagada"
        Url = Url.ToLower()
        Url = Url.Replace("/ser", "ser")
        p_fecha_pago = SuirPlus.Utilitarios.Utils.FormatearFecha(p_fecha_pago)
        Dim resultado As String = String.Empty
        p_usuario = Trim(p_usuario)
        p_password = Trim(p_password)
        p_liquidacion = Trim(p_liquidacion)
        p_fecha_pago = Trim(p_fecha_pago)
        p_entidad_recaudadora = Trim(p_entidad_recaudadora)

        Try

            If Seg.CheckUserPass(p_usuario, p_password, IP) = False Then
                resultado = Rep.GetByIdError("WS010").Descripcion
            Else
                If SuirPlus.Seguridad.Permiso.PermisoWebService(p_usuario, Url.ToLower()) = "S" Then

                    If DateTime.TryParse(p_fecha_pago, Fecha) = True Then
                        Fecha = Fecha.Add(DateTime.Now.TimeOfDay)
                        resultado = SuirPlus.Servicios.WebServices.LiquidacionMarcarPagada(p_usuario, p_liquidacion, Fecha, p_entidad_recaudadora)
                    Else
                        resultado = Rep.GetByIdError("WS013").Descripcion
                    End If
                Else
                    resultado = Rep.GetByIdError("WS014").Descripcion
                End If

            End If

            Return resultado

        Catch ex As Exception
            Exepciones.Log.LogToDB(ex.ToString())
            Return resultado
        End Try

    End Function

    <WebMethod(Description:="Método para colocar como canceladas las liquidación de Infotep. <br>" &
    "En caso de que la liquidación no pueda cancelarse se retornara un mensaje de Error. " &
    "Esta función retorna un XML con el resultado de la Ejecución.<br>" & "")>
    Public Function MarcarCancelada(ByVal p_usuario As String,
                                    ByVal p_password As String,
                                    ByVal p_liquidacion As String) As String

        Dim resultado As String = String.Empty
        Rep = New SuirPlusEF.Repositories.ErrorRepository
        Dim Url = "Servicios_TSS.asmx/MarcarCancelada"
        Url = Url.ToLower()
        Url = Url.Replace("/ser", "ser")
        p_usuario = Trim(p_usuario)
        p_password = Trim(p_password)
        p_liquidacion = Trim(p_liquidacion)

        Try
            If Seg.CheckUserPass(p_usuario, p_password, IP) = False Then
                resultado = Rep.GetByIdError("WS010").Descripcion
            Else
                If SuirPlus.Seguridad.Permiso.PermisoWebService(p_usuario, Url.ToLower()) = "S" Then
                    If p_liquidacion = String.Empty Then
                        resultado = Rep.GetByIdError("WS001").Descripcion
                    Else
                        resultado = Servicios.WebServices.LiquidacionMarcarCancelada(p_password, p_liquidacion)
                    End If
                Else
                    resultado = Rep.GetByIdError("WS014").Descripcion
                End If
            End If

            Return resultado

        Catch ex As Exception
            Exepciones.Log.LogToDB(ex.ToString())
            Return resultado
        End Try

    End Function

    <WebMethod(Description:="Método para marcar empresas que paguen infotep.<br>" &
     "En caso de que la empresa no pueda marcarse que paga infotep, se retornara un mensaje con el código de Error. " &
     "Esta función retorna un XML con el resultado de la Ejecución. <br>" & "")>
    Public Function PagaInfotep(ByVal p_usuario As String,
                                ByVal p_password As String,
                                ByVal p_rnc_cedula As String) As String

        Dim resultado As String = String.Empty
        Rep = New SuirPlusEF.Repositories.ErrorRepository
        Dim Url = "Servicios_TSS.asmx/PagaInfotep"
        Url = Url.ToLower()
        Url = Url.Replace("/ser", "ser")
        p_usuario = Trim(p_usuario)
        p_password = Trim(p_password)
        p_rnc_cedula = Trim(p_rnc_cedula)

        Try

            If Seg.CheckUserPass(p_usuario, p_password, IP) = False Then
                resultado = Rep.GetByIdError("WS010").Descripcion
            Else
                If SuirPlus.Seguridad.Permiso.PermisoWebService(p_usuario, Url.ToLower()) = "S" Then
                    If p_rnc_cedula = String.Empty Then
                        resultado = Rep.GetByIdError("WS011").Descripcion
                    Else
                        resultado = Servicios.WebServices.PagaInfotep(p_usuario, p_rnc_cedula)
                    End If
                Else
                    resultado = Rep.GetByIdError("WS014").Descripcion
                End If
            End If

            Return resultado

        Catch ex As Exception
            Exepciones.Log.LogToDB(ex.ToString())
            Return resultado
        End Try

    End Function

    <WebMethod(Description:="Método para marcar empresas que no paguen infotep. <br>" &
    "En caso de que la empresa no pueda marcarse que no paga infotep, se retornara un mensaje de Error." &
    "Esta función retorna un XML con el resultado de la Ejecución.<br>" & "")>
    Public Function NoPagaInfotep(ByVal p_usuario As String,
                                  ByVal p_password As String,
                                  ByVal p_rnc_cedula As String) As String

        Dim resultado As String = String.Empty
        Rep = New SuirPlusEF.Repositories.ErrorRepository
        Dim Url = "Servicios_TSS.asmx/NoPagaInfotep"
        Url = Url.ToLower()
        Url = Url.Replace("/ser", "ser")
        p_usuario = Trim(p_usuario)
        p_password = Trim(p_password)
        p_rnc_cedula = Trim(p_rnc_cedula)

        Try
            If Seg.CheckUserPass(p_usuario, p_password, IP) = False Then
                resultado = Rep.GetByIdError("WS010").Descripcion
            Else
                If SuirPlus.Seguridad.Permiso.PermisoWebService(p_usuario, Url.ToLower()) = "S" Then
                    If p_rnc_cedula = String.Empty Then
                        resultado = Rep.GetByIdError("WS011").Descripcion
                    Else
                        resultado = Servicios.WebServices.NoPagaInfotep(p_usuario, p_rnc_cedula)
                    End If
                Else
                    resultado = Rep.GetByIdError("WS014").Descripcion
                End If
            End If

            Return resultado

        Catch ex As Exception
            Exepciones.Log.LogToDB(ex.ToString())
            Return resultado
        End Try
    End Function

    <WebMethod(Description:="Método para validar si las PYMES estan al dia en TSS. <br>" &
               "Esta función retorna un XML con el resultado de la Ejecución.<br>" & "")>
    Public Function ValidarPYMES(ByVal p_usuario As String,
                                 ByVal p_password As String,
                                 ByVal p_rnc_cedula As String) As DataSet

        Dim ds As New DataSet("ValidarPYMES")
        Dim Url = "Servicios_TSS.asmx/ValidarPYMES"
        Url = Url.ToLower()
        Url = Url.Replace("/ser", "ser")
        Rep = New SuirPlusEF.Repositories.ErrorRepository
        p_usuario = Trim(p_usuario)
        p_password = Trim(p_password)
        p_rnc_cedula = Trim(p_rnc_cedula)

        Try
            Dim resultado As String = String.Empty
            If Trim(p_usuario) = String.Empty Or Trim(p_password) = String.Empty Then
                resultado = Rep.GetByIdError("WS010").Descripcion
                Seg.AgregarMensajeDeError(ds, resultado)
                Return ds
            End If

            If Seg.CheckUserPass(p_usuario, p_password, IP) = False Then
                resultado = Rep.GetByIdError("WS010").Descripcion
                Seg.AgregarMensajeDeError(ds, resultado)
            Else
                If SuirPlus.Seguridad.Permiso.PermisoWebService(p_usuario, Url.ToLower()) = "S" Then
                    If Trim(p_rnc_cedula.ToString()) = String.Empty Then
                        resultado = Rep.GetByIdError("WS011").Descripcion
                        Seg.AgregarMensajeDeError(ds, resultado)
                        Return ds
                    Else
                        Dim emp As New Empresas.Empleador(p_rnc_cedula)
                        Dim rz As String = emp.RazonSocial()

                        If rz = Nothing Then
                            resultado = Rep.GetByIdError("WS011").Descripcion
                            Seg.AgregarMensajeDeError(ds, resultado)
                            Return ds
                        Else
                            ds.Tables.Add(Servicios.WebServices.ValidarPymes(p_rnc_cedula).Copy())
                            ds.Tables(0).TableName = "Tabla"
                            Dim Obtenermensaje = ds.Tables(0).Rows(0).Item(0).ToString()
                            If Obtenermensaje.Contains("WS") Or Obtenermensaje.Contains("-1") Then
                                Obtenermensaje = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(ds.Tables(0).Rows(0).Item(0).ToString())
                                ds.Clear()
                                Seg.AgregarMensajeDeError(ds, Obtenermensaje)
                            End If
                        End If
                    End If
                Else
                    resultado = Rep.GetByIdError("WS014").Descripcion
                    Seg.AgregarMensajeDeError(ds, resultado)
                End If
            End If
            Return ds

        Catch ex As Exception
            Seg.AgregarErrorTecnico(ds, ex.ToString())
            Exepciones.Log.LogToDB(ex.ToString())
            Return ds
        End Try
    End Function

End Class