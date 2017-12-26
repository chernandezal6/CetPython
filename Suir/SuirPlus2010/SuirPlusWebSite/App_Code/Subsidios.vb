Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports SuirPlus
Imports SuirPlus.Empresas
Imports System.Web.Script.Services
Imports SuirPlus.Empresas.SubsidiosSFS
Imports SuirPlus.Subsidios
Imports SuirPlus.Bancos
Imports SuirPlus.Utilitarios
Imports System.Collections.Generic
Imports System.Data
Imports System.Linq
Imports System.IO
' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class Subsidios
    Inherits System.Web.Services.WebService
    Private nroformulario As String = String.Empty
#Region "Metodos para genericos"
    <WebMethod()> _
  <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ConsultaCedula(ByVal cedula As String, ByVal registropatronal As String, ByVal tiposubsidio As String) As Object

        Dim result = String.Empty

        If String.IsNullOrEmpty(cedula) Or String.IsNullOrEmpty(registropatronal) Then
            Return "La cedula y registro patronal son requeridos para realizar la busqueda."
        End If

        Try
            If tiposubsidio.Equals("M") Then

                Dim trabajadora = Novedades.ObtenerDetalleTrabajadora(cedula, Convert.ToInt32(registropatronal), result)

                If result.Equals("OK") Then

                    If trabajadora.sexo.Equals("Masculino") Then
                        Return "Sexo Invalido"
                    End If

                    Dim res As String = Validaciones.ValidarDocumento(0, cedula)

                    If res = "0" Then
                        Return trabajadora
                    Else
                        Return res.Replace("567", "")
                    End If

                Else
                    Return result
                End If
            Else
                Dim res As String = Validaciones.ValidarDocumento(0, cedula)

                If res = "0" Then

                    Dim trabajadora = Novedades.ObtenerDetalleTrabajadora(cedula, Convert.ToInt32(registropatronal), result)

                    If result.Equals("OK") Then
                        Return trabajadora
                    Else
                        Return result
                    End If
                Else
                    Return res.Replace("567", "")
                End If
            End If

        Catch ex As Exception
            Return ex.ToString()
        End Try
    End Function
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ObtenerEntidadesRecaudadoras() As Generic.List(Of EntidadRecaudadora)
        Return Novedades.ObtenerEntidadesRecaudadoras()
    End Function
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function DetalleEntidadRecaudadora(ByVal idEntidadRecaudadora As String) As EntidadRecaudadora
        Try
            Dim mientidad = ObtenerEntidadesRecaudadoras().FirstOrDefault(Function(e) e.IdEntidadRecaudadora = Convert.ToUInt32(idEntidadRecaudadora))
            Return mientidad

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
            Throw ex
        End Try
    End Function
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function RegistrarCuentaBancaria(ByVal cuentabanco As String, ByVal entidadrecaudadora As String, ByVal nrodocumento As String,
                                            ByVal registropatronal As String, ByVal tipocuenta As String, ByVal usuarioregistro As String) As String


        Dim micuenta = New CuentaBancariaMadre()

        With micuenta
            .IdEntidadRecaudadora = Convert.ToInt32(entidadrecaudadora)
            .NroDocumento = nrodocumento
            .CuentaBanco = cuentabanco
            .RegistroPatronal = Convert.ToInt32(registropatronal)
            .TipoCuenta = tipocuenta
            .UltimoUsrAct = usuarioregistro
        End With

        Try

            Dim cuentaregistrada = CuentaBancariaMadre.actualizarCuentaBancaria(micuenta)

            Return cuentaregistrada

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
            Return ex.Message
        End Try
    End Function
    Public Function DetalleCuentaBanco(ByVal registropatronal As String, ByVal rnc As String) As CuentaBancariaMadre
        Try
            Return CuentaBancariaMadre.getDetalleCuenta(Convert.ToInt32(registropatronal), rnc)
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
            Throw ex
        End Try
    End Function
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Function EsRncOCedulaInactiva(rnc As String) As String
        Return SuirPlus.Subsidios.Validaciones.EsRncOCedulaInactiva(rnc)
    End Function


#End Region

#Region "Metodos del reporte del lactancia"

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getLactante(ByVal nsslactante As String, ByVal idTextBox As String) As Object


        Try
            Dim lactante = SuirPlus.Subsidios.Lactante.ObtenerDatosLactate(Convert.ToInt32(nsslactante))

            If (Not lactante Is Nothing) Then

                Dim milactante = New With {.idtextbox = idTextBox,
                                         .nss = lactante.NSSLactante,
                                         .nombres = lactante.Nombres,
                                         .primerapellido = lactante.PrimerApellido,
                                         .segundoapellido = lactante.SegundoApellido,
                                         .nui = lactante.NUI,
                                         .sexo = lactante.Sexo}

                Return milactante
            End If
            Return ""
        Catch ex As Exception
            Return ex.Message
        End Try

    End Function
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ReporteNacimiento() As String

        Dim solicitud = New SuirPlus.Subsidios.Solicitud()
        Try

            Dim nacimiento = String.Empty
            Dim result = String.Empty


            If Context.Request.QueryString("fechanacimiento").Equals("") Then
                Return "La fecha de nacimiento es obligatoria"
            End If

            Dim CantidadLactantes = Convert.ToInt32(Context.Request.QueryString("cantidadlactante"))
            Dim rpatronal = Convert.ToInt32(Context.Request.QueryString("registropatronalregistrolactancia"))
            Dim nssmadre = Convert.ToInt32(Context.Request.QueryString("nssmadre"))
            Dim usuarioregistro = Context.Request.QueryString("usuarioregistrolactancia")
            Dim fnacimiento = Utils.FormatearFecha(Context.Request.QueryString("fechanacimiento"))

            Dim nrosolicitudnacimiento = Context.Request.QueryString("nrosolicitudnacimiento")

            Dim modo = Context.Request.QueryString("modo")

            Dim nroSolicitudMaternidad = Context.Request.QueryString("nrosolicitudmaternidad")

            If fnacimiento > DateTime.Now Then
                Return "La fecha de nacimiento no puede ser futura."
            End If

            If CantidadLactantes > 8 Then
                Return "La cantidad de lactante debe ser menor o igual a 8."
            End If

            'Hacer el registro del nacimiento'
            nacimiento = SuirPlus.Subsidios.Lactante.RegistrarNacimiento(nssmadre, rpatronal, CantidadLactantes, fnacimiento, "NO", nroSolicitudMaternidad, modo, nrosolicitudnacimiento)

            If Not nacimiento.Equals("OK") Then

                Return "Ocurrio el siguiente error" & " " & nacimiento
            End If

            Dim lac As SuirPlus.Subsidios.Lactante = New SuirPlus.Subsidios.Lactante()

            solicitud.NroSolicitud = Convert.ToDecimal(nrosolicitudnacimiento)

            For index = 1 To CantidadLactantes

                Dim nss = Context.Request.QueryString("nss" & index.ToString)

                If nss = "" Then
                    nss = Nothing

                    lac.Nombres = Context.Request.QueryString("nombres" & index.ToString)
                    lac.PrimerApellido = Context.Request.QueryString("papellido" & index.ToString)
                    lac.SegundoApellido = Context.Request.QueryString("sapellido" & index.ToString)
                    lac.NUI = Context.Request.QueryString("nui" & index.ToString)
                    lac.Sexo = Context.Request.QueryString("sexo" & index.ToString)
                Else

                    Dim lactante = SuirPlus.Subsidios.Lactante.ObtenerDatosLactate(Convert.ToInt32(nss))


                    lac.Nombres = lactante.Nombres
                    lac.PrimerApellido = lactante.PrimerApellido
                    lac.SegundoApellido = lactante.SegundoApellido
                    lac.NUI = lactante.NUI
                    lac.Sexo = lactante.Sexo

                End If

                lac.NSS = nssmadre
                lac.NSSLactante = Convert.ToInt32(nss)
                lac.UltimoUsrAct = usuarioregistro
                lac.RegistroPatronalNC = rpatronal
                lac.Solicitud = solicitud
                lac.Retroactiva = "NO"
                lac.modo = modo
                'Crear los lactantes'
                result = SuirPlus.Subsidios.Lactante.crearLactantes(lac)

                'Si ocurrio un error retornar el mensaje'
                If (result <> "OK") Then

                    SuirPlus.Subsidios.Lactante.DeshacerNacimiento(solicitud.NroSolicitud)

                    Return "Ocurrio el siguiente error" & "" & result & "" & "crear el lactante."
                End If
            Next

            Return result

        Catch ex As Exception

            Return ex.Message
        End Try
    End Function
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function RegistrarMuerteLactante(ByVal nss As String, ByVal registropatronal As String, ByVal fechamuerte As String, ByVal idlactante As String, ByVal usuariomuerte As String) As String

        Dim fechamuertelactante = Utils.FormatearFecha(fechamuerte)

        Dim result = String.Empty

        result = SuirPlus.Subsidios.Lactante.RegistrarMuerteLactante(Convert.ToInt32(nss), Convert.ToInt32(registropatronal),
                                                                     Utils.FormatearFecha(fechamuertelactante), Convert.ToInt32(idlactante), usuariomuerte)
        Return result

    End Function
    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function PreValidacionesMuerteLactante(ByVal nss As String, ByVal registropatronal As String) As String
        Try
            If Not SuirPlus.Subsidios.Validaciones.tieneEmbarazoConNacimiento(Convert.ToInt32(nss), Convert.ToInt32(registropatronal)) Then
                Return "La trabajadora debe tener un reporte de embarazo para el cual se haya reportado un nacimiento"
            End If
            Return "OK"
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
            Return ex.Message
        End Try
    End Function
    <WebMethod()> _
   <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ValidaDocumento(ByVal nss As String, ByVal nrodocumento As String) As String
        Dim result = String.Empty

        Try
            result = SuirPlus.Subsidios.Validaciones.ValidarDocumento(Convert.ToInt32(nss), nrodocumento)
            Return result
        Catch ex As Exception
            Return ex.ToString
        End Try
    End Function
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getLactancia(idlactancia As String) As Object
        Dim result = String.Empty

        Dim lactantes As New List(Of DetalleLactante)

        Try
            Dim dtlactancia = SuirPlus.Subsidios.Lactante.getLactates(Convert.ToInt32(idlactancia), result)

            If result = "OK" Then

                If dtlactancia.Rows.Count > 0 Then


                    For Each la As DataRow In dtlactancia.Rows

                        lactantes.Add(New DetalleLactante With
                                                                {
                                                                 .FechaNacimiento = la.Field(Of DateTime?)("fecha_nacimiento"),
                                                                 .IdLactante = Convert.ToInt32(la.Field(Of Int64)("ID_LACTANTE")),
                                                                 .NSSLactante = Convert.ToInt32(la.Field(Of Int64?)("ID_NSS_LACTANTE")),
                                                                 .NroSolicitud = Convert.ToInt32(la.Field(Of Int64?)("NRO_SOLICITUD")),
                                                                 .NUI = la.Field(Of String)("NUI"),
                                                                 .SecuenciaLactante = Convert.ToInt32(la.Field(Of Int64)("SECUENCIA_LACTANTE")),
                                                                 .Nombres = la.Field(Of String)("NOMBRES"),
                                                                 .PrimerApellido = la.Field(Of String)("PRIMER_APELLIDO"),
                                                                 .SegundoApellido = la.Field(Of String)("SEGUNDO_APELLIDO"),
                                                                 .Sexo = la.Field(Of String)("SEXO"),
                                                                 .Estatus = la.Field(Of String)("ESTATUS"),
                                                                 .CantidadLactante = Convert.ToInt32(la.Field(Of Int64?)("cant_lactantes")),
                                                                 .NroDocumentoMadre = la.Field(Of String)("No_Documento"),
                                                                 .NroSolicitudMaternidad = Convert.ToInt32(la.Field(Of Int64)("nro_solicitud_mat"))
                                                                 })

                    Next

                    Return lactantes

                Else
                    Return "Esta lactancia no tiene datos para reconsiderar."
                End If
            Else
                Return result
            End If
        Catch ex As Exception
            Return ex.ToString
        End Try
    End Function
#End Region

#Region "Metodos del reporte de maternidad"
    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ConsultaTutor(ByVal cedula As String) As Object

        Dim result = String.Empty

        If String.IsNullOrEmpty(cedula) Then
            Return "La cédula es requerida para realizar la busqueda."
        End If

        If cedula.Length <> 11 Then
            Return "la longitud de la cédula es inválida"
        End If

        Try
            Dim emp As New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, cedula)

            Dim empleado = New With {.nss = emp.NSS,
                                     .sexo = emp.Sexo,
                                     .nombres = emp.Nombres & " " & emp.PrimerApellido & " " & emp.SegundoApellido,
                                     .cedula = emp.Documento}

            Dim s As String = Validaciones.ValidarDocumento(0, empleado.cedula)

            If s = "0" Then
                Return empleado
            Else
                Return s
            End If

        Catch ex As Exception
            Return ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
        End Try

    End Function
    <WebMethod()> _
   <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getDetalleMedico(ByVal cedulamedico As String) As Object

        If String.IsNullOrEmpty(cedulamedico) Then
            Return "La cédula del médico es requerida para realizar la búsqueda."
        End If

        If cedulamedico.Length <> 11 Then
            Return "la logintud de la cédula del médico es inválida"
        End If
        Try
            Dim medico = SuirPlus.Subsidios.Medico.ObtenerDetalleMedico(cedulamedico)

            If medico Is Nothing Then
                Return "No se encontró el médico con la cédula suministrada."
            End If

            Dim detalleMedico = New With {.nromedico = medico.PSS_Med,
                                          .mediconombre = medico.NombreMedico,
                                          .cedulamedico = medico.NoDocumentoMedico,
                                          .telefonomedico = medico.TelefonoMedico,
                                          .celularmedico = medico.celularMedico,
                                          .direcciomedico = medico.DireccionMedico}
            Return detalleMedico

        Catch ex As Exception
            Return ex.ToString
        End Try
    End Function
    <WebMethod()> _
     <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getDetallePss(ByVal PssNombre As String) As Object

        If String.IsNullOrEmpty(PssNombre) Then
            Return "El nombre de la prestadora de salud es requerido"
        End If

        Try
            Dim datosPSS = SuirPlus.Empresas.SubsidiosSFS.EnfermedadComun.getPss(PssNombre)


            If datosPSS.Rows.Count > 0 Then

                Dim DetallePss = New With {.numeropss = datosPSS.Rows(0).Field(Of Int32)("prestadora_numero"),
                                   .direccionpss = datosPSS.Rows(0).Field(Of String)("direccion"),
                                   .telefonopss = datosPSS.Rows(0).Field(Of String)("telefono"),
                                   .nombrepss = datosPSS.Rows(0).Field(Of String)("prestadora_nombre"),
                                   .rncpss = datosPSS.Rows(0).Field(Of String)("rnccedula")}
                Return DetallePss
            Else
                Return "Esta PSS no se encuentra registrada en nuestra base de datos, favor comunicarse con la SISALRIL para más información."
            End If


        Catch ex As Exception
            Return ex.Message
        End Try

    End Function
    <WebMethod()> _
   <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getPssList(ByVal pssNombre As String) As String()

        Try

            Dim mipss = SuirPlus.Subsidios.Novedades.getPssList(pssNombre)

            Dim psslist As New List(Of String)

            If mipss.Rows.Count > 0 Then

                For Each dr As Data.DataRow In mipss.Rows
                    psslist.Add(dr.Field(Of String)("PssNombre"))
                Next
            End If

            Return psslist.ToArray

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Throw New Exception(ex.ToString())
        End Try
    End Function
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function RegistrarEmbarazo(ByVal celularmadre As String,
                                      ByVal emailmadre As String,
                                      ByVal emailtutor As String,
                                      ByVal fechadiagnostico As String,
                                      ByVal fechaestimadaparto As String,
                                      ByVal nss As String,
                                      ByVal nsstutor As String,
                                      ByVal registropatronalregistroembarazo As String,
                                      ByVal telefonomadre As String,
                                      ByVal telefonotutor As String,
                                      ByVal usuarioregistroembarazo As String) As String

        Dim result = String.Empty


        Dim maternidad = New SuirPlus.Subsidios.Maternidad()



        Try

            With maternidad
                .Celular = Utils.FormatearTelefonoDB(celularmadre)
                .Email = emailmadre
                'Inicialiar el Objeto Tutor que esta relacionado a la maternidad.'
                .Tutor = New SuirPlus.Subsidios.Tutor() With {.NSS = Convert.ToInt32(nsstutor),
                                                              .Email = emailtutor,
                                                              .Telefono = Utils.FormatearTelefonoDB(telefonotutor)}
                .FechaDiagnostico = fechadiagnostico
                .FechaEstimadaParto = fechaestimadaparto
                .NSS = Convert.ToInt32(nss)
                .RegistroPatronalRegistroEmbarazo = Convert.ToInt32(registropatronalregistroembarazo)
                .Telefono = Utils.FormatearTelefonoDB(telefonomadre)
                .UsuarioRegistroEmbarazo = usuarioregistroembarazo
                .FechaInicioLicencia = Nothing
                .Retroactiva = "NO"
            End With

            result = SuirPlus.Subsidios.Maternidad.RegistrarEmbarazo(maternidad, nroformulario)

            Return result
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
            Throw ex
        End Try
    End Function
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ObtenerNovedadesToDoList(ByVal nss As String, ByVal registropatronal As String) As List(Of SuirPlus.Subsidios.NovedadesPendientes)

        Try

            Return SuirPlus.Subsidios.Novedades.ObtenerOpcionesMenu(Convert.ToInt32(nss), Convert.ToInt32(registropatronal))

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
            Throw ex
        End Try
    End Function
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function RegistroLicenciaPreNatal() As String

        Dim result = String.Empty

        Try

            Dim nss = Convert.ToInt32(Context.Request.QueryString("nss"))
            Dim fechalicencia = Utils.FormatearFecha(Context.Request.QueryString("fechalicencia"))
            Dim registropatronal = Convert.ToInt32(Context.Request.QueryString("registropatronal"))

            If Not Validaciones.estaActivaNomina(Convert.ToInt32(Context.Request.QueryString("nss")), Nothing, registropatronal, fechalicencia, "L") Then
                Return "La trabajadora no esta en una NP pagada para esta fecha de licencia o esta no activa en nomina para este empleador."
            End If

            Dim formulario = New SuirPlus.Subsidios.Formulario()

            With formulario
                .TipoFormulario = Context.Request.QueryString("tipoformulario")

                'Inicialiar el Objecto Medico que esta relacionado con este formulario de licencia.'
                .Medico = New SuirPlus.Subsidios.Medico() With {.PSS_Med = Convert.ToInt32(Context.Request.QueryString("numeropss")),
                                                                .NoDocumentoMedico = Context.Request.QueryString("cedulamedico"),
                                                                .DireccionMedico = Context.Request.QueryString("direccionmedico"),
                                                                .TelefonoMedico = Utils.FormatearTelefonoDB(Context.Request.QueryString("telefono")),
                                                                .celularMedico = Utils.FormatearTelefonoDB(Context.Request.QueryString("celular")),
                                                                .emailMedico = Context.Request.QueryString("correo"),
                                                                .NombreMedico = Context.Request.QueryString("mediconombre"),
                                                                .Exequatur = Context.Request.QueryString("medicoexequatur")
                                                                }

                'Inicialiar el Objecto PrestadoraSalud que esta relacionado con este formulario de licencia.'
                .PrestadoraSalud = New SuirPlus.Subsidios.Prestadora With {.idPssCentro = Convert.ToInt32(Context.Request.QueryString("numeropss")),
                                                                           .nombreCentro = Context.Request.QueryString("nombrepss"),
                                                                           .DireccionCentro = Context.Request.QueryString("direccionpss"),
                                                                           .TelefonoCentro = Utils.FormatearTelefonoDB(Context.Request.QueryString("telefonopss")),
                                                                           .faxCentro = Utils.FormatearTelefonoDB(Context.Request.QueryString("faxpss")),
                                                                           .emailCentro = Context.Request.QueryString("correopss")}
                .UltimoUsrAct = Context.Request.QueryString("usuariolicencia")
                .diagnostico = Context.Request.QueryString("diagnostico")
                .signoSintomas = Context.Request.QueryString("sintomas")
                .Procedimientos = Context.Request.QueryString("procedimientos")
                .fechaDiagnostico = Utils.FormatearFecha(Context.Request.QueryString("fechadiagnostico"))
                .NroFormulario = Context.Request.QueryString("nroformulariopretnatal")

            End With

            Dim nrosolicitudlicenciaprenatal = Context.Request.QueryString("nrosolicitudprenatal")
            Dim usuariolicencia = Context.Request.QueryString("usuariolicencia")

            Dim modo = Context.Request.QueryString("modo")

            Try
                result = SuirPlus.Subsidios.Maternidad.RegistroLicencia(Convert.ToInt32(nss), fechalicencia,
                                                                        Convert.ToInt32(registropatronal), usuariolicencia,
                                                                        "PR", "NO", Convert.ToInt32(nrosolicitudlicenciaprenatal), formulario, modo)


            Catch ex As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex.Message)
                Return ex.Message
            End Try

            Return result

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
            Throw ex
        End Try
    End Function
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function imprimioFormulario(ByVal registropatronal As String, ByVal numerosolicitud As String) As String

        Dim formulario = SuirPlus.Subsidios.Formulario.imprimioFormulario(Convert.ToInt32(numerosolicitud), Convert.ToInt32(registropatronal))

        If formulario Then
            Return "S"
        End If

        Return "N"

    End Function
    <WebMethod()> _
   <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function tieneCuentaBancaria(ByVal registropatronal As String) As String
        If String.IsNullOrEmpty(registropatronal) Then
            Return "El registro patronal es requerido para realizar la validacion"
        End If
        Dim result = String.Empty
        Try
            If SuirPlus.Subsidios.Validaciones.tieneCuentaBancaria(Convert.ToInt32(registropatronal), result) Then
                Return "S"
            Else
                If result.Equals("OK") Then
                    Return "N"
                Else
                    Return result
                End If
            End If
        Catch ex As Exception
            Return "Ocurrio el siguiente error" + " " + ex.Message
        End Try
    End Function
    <WebMethod()> _
  <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function tieneSubsidioMaternidadInconcluso(ByVal nss As String) As String

        Dim result = String.Empty
        Try
            If Not SuirPlus.Subsidios.Maternidad.tieneEmbarazoInconcluso(Convert.ToInt32(nss)) Then
                Return "N"
            End If
            Return "S"
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
            result = ex.Message
            Return result
        End Try
    End Function
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ObtenerNumeroFormulario(ByVal nss As String, ByVal registropatronal As String, ByVal cedula As String) As Object
        Try
            'Obtener el Nro de Formulario'
            Dim nroformulario = SuirPlus.Subsidios.Novedades.obtenerNumeroFormulario(Convert.ToInt32(nss), Convert.ToInt32(registropatronal), TipoSubsidio.Maternidad)

            'Obtener el hash de este nro de formulario'
            Dim hash = SuirPlus.Empresas.SubsidiosSFS.EnfermedadComun.hashValores(nroformulario)

            'Crear un objeto anonimo para almacenar el nro de formulario y el hash'
            Dim ObjectNumeroFormulario = New With {.nroformulario = nroformulario, .hash = hash}

            Return ObjectNumeroFormulario

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
            Return ex.Message
        End Try
    End Function
    <WebMethod()> _
  <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function tieneEmbarazoActivo(ByVal nss As String, ByVal registropatronal As String) As String
        Try
            If Not SuirPlus.Subsidios.Validaciones.tieneEmbarazoActivo(Convert.ToInt32(nss), Convert.ToInt32(registropatronal)) Then
                Return "N"
            End If
            Return "S"

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
            Return ex.Message
        End Try
    End Function
    <WebMethod()> _
  <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function PreValidacionesMuerteMadre(ByVal nss As String, ByVal registropatronal As String) As String
        Try
            If Not SuirPlus.Subsidios.Validaciones.estaActivaNomina(Convert.ToInt32(nss), DateTime.Now, registropatronal, Nothing, "M") Then
                Return "La trabajadora no esta activa en nomina"
                'ElseIf SuirPlus.Subsidios.Validaciones.tieneEmbarazoSinNacimiento(Convert.ToInt32(nss), Convert.ToInt32(registropatronal)) Then
                '    Return "la trabajadora debe tener un registro de embarazo activo"
            End If
            Return "OK"
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
            Return ex.Message
        End Try
    End Function
    <WebMethod()> _
 <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function PreValidacionesPerdidaEmbarazo(ByVal nss As String, ByVal registropatronal As String) As String
        Try

            If Not SuirPlus.Subsidios.Validaciones.estaActivaNomina(nss, DateTime.Now, registropatronal, Nothing, "M") Then
                Return "La trabajadora no esta activa en nomina"
            End If

            If Not SuirPlus.Subsidios.Validaciones.tieneEmbarazoSinNacimiento(Convert.ToInt32(nss), Convert.ToInt32(registropatronal)) Then
                Return "la trabajadora debe tener un reporte de embarazo para el cual no haya reportado un Nacimiento, ni una Perdida de Embarazo."
            End If

            Return "OK"
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
            Return ex.Message
        End Try
    End Function
    <WebMethod()> _
  <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ReporteMuerteMadre(ByVal nss As String, ByVal registropatronal As String, ByVal fechamuerte As String, ByVal usuariomuerte As String) As String
        Try
            If fechamuerte > DateTime.Now Then
                Return "La fecha de la muerte no puede ser futura."
            End If

            Return SuirPlus.Subsidios.Maternidad.ReporteMuerteMadre(Convert.ToInt32(nss), Convert.ToInt32(registropatronal), Utils.FormatearFecha(fechamuerte), usuariomuerte)

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
            Return ex.Message
        End Try
    End Function
    <WebMethod()> _
 <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function RegistrarPedidaEmbarazo(ByVal registropatronal As String, ByVal fechaperdida As String, ByVal usuarioperdida As String,
                                            ByVal nrosolicitudperdida As String) As String
        Try

            If Not IsDate(fechaperdida) Then
                Return "Fecha incorrecta, favor verificar"
            End If

            If fechaperdida > DateTime.Now Then
                Return "La fecha de pérdida introducida no debe ser futura"
            End If

            Return SuirPlus.Subsidios.Maternidad.RegistrarPedidaEmbarazo(Convert.ToInt32(registropatronal), Utils.FormatearFecha(fechaperdida),
                                                                         usuarioperdida, "NO", Convert.ToInt32(nrosolicitudperdida))
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
            Return ex.Message
        End Try
    End Function
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function RegistrarEmbarazoRetroactivo() As String

        Dim resultembarazo = String.Empty
        Dim nrosolicitud = String.Empty

        Try
            If Not Validaciones.estaActivaNomina(Convert.ToInt32(Context.Request.QueryString("nssmadre")), Nothing, Context.Request.QueryString("registropatronalretroactivo"), Context.Request.QueryString("fechalicencia"), "L") Then
                Return "La trabajadora no esta en una NP pagada para esta fecha de licencia o esta no activa en nomina para este empleador."
            End If

            'Datos de la maternidad
            Dim maternidad = New SuirPlus.Subsidios.Maternidad()

            If Context.Request.QueryString("fechalicencia").Equals("") Then
                maternidad.FechaInicioLicencia = Nothing
            Else
                maternidad.FechaInicioLicencia = Utils.FormatearFecha(Context.Request.QueryString("fechalicencia"))
            End If

            If Context.Request.QueryString("fechaperdida").Equals("") Then
                maternidad.FechaPerdidaEmbarazo = Nothing
            Else
                    maternidad.FechaPerdidaEmbarazo = Utils.FormatearFecha(Context.Request.QueryString("fechaperdida"))
            End If

            If Context.Request.QueryString("fechadefuncion").Equals("") Then
                maternidad.FechaMuerteMadre = Nothing
            Else
                    maternidad.FechaMuerteMadre = Utils.FormatearFecha(Context.Request.QueryString("fechadefuncion"))
            End If

            'Si es Normal o una Reconsideracion. Este puede ser R = "Reconsidenracion" o N = "Normal"
            Dim modo = Context.Request.QueryString("modo")

            With maternidad
                .Celular = Utils.FormatearTelefonoDB(Context.Request.QueryString("celularmadreretroactivo"))
                .Email = Context.Request.QueryString("emailmadreretroactivo")
                'Inicialiar el Objeto Tutor que esta relacionado a la maternidad.'
                .Tutor = New SuirPlus.Subsidios.Tutor() With {.NSS = Convert.ToInt32(Context.Request.QueryString("nsstutorretroactivo")),
                                                              .Email = Context.Request.QueryString("emailtutorretroactivo"),
                                                              .Telefono = Utils.FormatearTelefonoDB(Utils.FormatearTelefonoDB(Context.Request.QueryString("telefonotutorretroactivo")))}


                .FechaDiagnostico = Utils.FormatearFecha(Context.Request.QueryString("fechadiagnosticoretroactiva"))

                    .FechaEstimadaParto = Utils.FormatearFecha(Context.Request.QueryString("fechaestimadapartoretroactivo"))
           
                .NSS = Convert.ToInt32(Context.Request.QueryString("nssmadre"))
                .RegistroPatronalRegistroEmbarazo = Convert.ToInt32(Context.Request.QueryString("registropatronalretroactivo"))
                .Telefono = Utils.FormatearTelefonoDB(Context.Request.QueryString("telefonomadreretroactivo"))
                .UsuarioRegistroEmbarazo = Context.Request.QueryString("usuarioregistroretroactivo")
                .Retroactiva = "SI"
                .TipoLicencia = "PO"
                .UsuarioRegistroLicencia = Context.Request.QueryString("usuarioregistroretroactivo")
            End With


            'Datos del formulario
            Dim datosformulario As New SuirPlus.Subsidios.Formulario()

            With datosformulario
                'Inicialiar el Objecto Medico que esta relacionado con este formulario de licencia.'
                .Medico = New SuirPlus.Subsidios.Medico() With {
                                                                .PSS_Med = Convert.ToInt32(Context.Request.QueryString("numeropss")),
                                                                .NoDocumentoMedico = Context.Request.QueryString("cedulamedico"),
                                                                .DireccionMedico = Context.Request.QueryString("direccionmedico"),
                                                                .TelefonoMedico = Utils.FormatearTelefonoDB(Context.Request.QueryString("telefonomedico")),
                                                                .celularMedico = Utils.FormatearTelefonoDB(Context.Request.QueryString("celularmedico")),
                                                                .emailMedico = Context.Request.QueryString("correomedico"),
                                                                .NombreMedico = Context.Request.QueryString("mediconombre"),
                                                                .Exequatur = Context.Request.QueryString("medicoexequatur")
                                                                }

                'Inicialiar el Objecto PrestadoraSalud que esta relacionado con este formulario de licencia.'
                .PrestadoraSalud = New SuirPlus.Subsidios.Prestadora With {
                                                                           .idPssCentro = Convert.ToInt32(Context.Request.QueryString("numeropss")),
                                                                           .nombreCentro = Context.Request.QueryString("nombrepss"),
                                                                           .DireccionCentro = Context.Request.QueryString("direccionpss"),
                                                                           .TelefonoCentro = Utils.FormatearTelefonoDB(Context.Request.QueryString("telefonopss")),
                                                                           .faxCentro = Utils.FormatearTelefonoDB(Context.Request.QueryString("faxpss")),
                                                                           .emailCentro = Context.Request.QueryString("correopss")
                                                                          }

                .UltimoUsrAct = Context.Request.QueryString("usuarioregistroretroactivo")
                .diagnostico = Context.Request.QueryString("diagnostico")
                .signoSintomas = Context.Request.QueryString("sintomas")
                .Procedimientos = Context.Request.QueryString("procedimientos")
                .fechaDiagnostico = Utils.FormatearFecha(Context.Request.QueryString("fechadiagnosticolicencia"))
                 .NroFormulario = nroformulario
        .Retroactiva = "SI"
        .TipoFormulario = "L"
            End With

            'Datos del Nacimiento
            Dim nacimiento = New SuirPlus.Subsidios.Lactante()

            If Context.Request.QueryString("fechanacimiento").Equals("") Then
                nacimiento.FechaNacimiento = Nothing
            Else
                nacimiento.FechaNacimiento = Utils.FormatearFecha(Context.Request.QueryString("fechanacimiento"))
            End If


            With nacimiento
                .NSS = Convert.ToInt32(Context.Request.QueryString("nssmadre"))
                .RegistroPatronalNC = Convert.ToInt32(Context.Request.QueryString("registropatronalretroactivo"))
                .CantidadLactante = Convert.ToInt32(Context.Request.QueryString("cantidadlactante"))
                .Retroactiva = "SI"
            End With

            'Dato de los lactantes
            Dim lactante As SuirPlus.Subsidios.Lactante = New SuirPlus.Subsidios.Lactante()
            Dim lactantes = New List(Of SuirPlus.Subsidios.Lactante)

            For index = 1 To nacimiento.CantidadLactante

                lactante = New SuirPlus.Subsidios.Lactante()

                Dim nsslactante = Context.Request.QueryString("nsslactante" & index.ToString)
                If nsslactante = "" Then
                    lactante.NSSLactante = Nothing
                Else
                    lactante.NSSLactante = Convert.ToInt32(nsslactante)
                End If

                lactante.Nombres = Context.Request.QueryString("nombreslactante" & index.ToString)
                lactante.PrimerApellido = Context.Request.QueryString("papellidolactante" & index.ToString)
                lactante.SegundoApellido = Context.Request.QueryString("sapellidolactante" & index.ToString)
                lactante.NUI = Context.Request.QueryString("nuilactante" & index.ToString)
                lactante.Sexo = Context.Request.QueryString("sexolactante" & index.ToString)
                lactante.UltimoUsrAct = Context.Request.QueryString("usuarioregistroretroactivo")
                lactante.RegistroPatronalNC = Convert.ToInt32(Context.Request.QueryString("registropatronalretroactivo"))

                lactantes.Add(lactante)



            Next
            nrosolicitud = Context.Request.QueryString("nrosolicitudretroactivo")

            resultembarazo = SuirPlus.Subsidios.Maternidad.RegistrarEmbarazoRetroactivo(maternidad, datosformulario, nacimiento, lactantes, modo, nrosolicitud)

            Return resultembarazo & "|" & nrosolicitud

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
            Return ex.Message.ToString
        End Try



    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function RegistrarLicenciaPostNatal() As String

        Try
            Dim nss = Convert.ToInt32(Context.Request.QueryString("nssmadre"))
            Dim usuario = Context.Request.QueryString("usuariolicenciapostnatal")
            Dim registropatronal = Convert.ToInt32(Context.Request.QueryString("registropatronalpostnatal"))

            Dim solicitud = New SuirPlus.Subsidios.Solicitud()

            'Datos Obligatorios
            If Context.Request.QueryString("fechalicencia").Equals("") Then
                Return "La fecha de la licencia es obligatoria."
            End If
            If Context.Request.QueryString("fechanacimiento").Equals("") Then
                Return "La fecha de nacimiento es obligatoria."
            End If
            If Context.Request.QueryString("cantidadlactante").Equals("") Then
                Return "La cantidad de lactante es obligatoria."
            End If

            Dim CantidadLactantes = Convert.ToInt32(Context.Request.QueryString("cantidadlactante"))
            Dim fnacimiento = Utils.FormatearFecha(Context.Request.QueryString("fechanacimiento"))
            Dim fechalicencia = Utils.FormatearFecha(Context.Request.QueryString("fechalicencia"))

            If fechalicencia > DateTime.Now Then
                Return "La fecha de licencia no puede ser futura."
            End If
            If CantidadLactantes > 8 Then
                Return "La cantidad de lactante debe ser menor o igual a 8."
            End If
            If fnacimiento > DateTime.Now Then
                Return "La fecha de nacimiento no puede ser futura."
            End If
            If Not Validaciones.estaActivaNomina(Convert.ToInt32(Context.Request.QueryString("nssmadre")), Nothing, Convert.ToInt32(Context.Request.QueryString("registropatronalpostnatal")), fechalicencia, "L") Then
                Return "La trabajadora no esta en una NP pagada para esta fecha de licencia o esta no activa en nomina para este empleador."
            End If


            Dim datosformulario As New SuirPlus.Subsidios.Formulario()

            With datosformulario
                'Inicialiar el Objecto Medico que esta relacionado con este formulario de licencia.'
                .Medico = New SuirPlus.Subsidios.Medico() With {
                                                                .PSS_Med = Convert.ToInt32(Context.Request.QueryString("numeropss")),
                                                                .NoDocumentoMedico = Context.Request.QueryString("cedulamedico"),
                                                                .DireccionMedico = Context.Request.QueryString("direccionmedico"),
                                                                .TelefonoMedico = Utils.FormatearTelefonoDB(Context.Request.QueryString("telefonomedico")),
                                                                .celularMedico = Utils.FormatearTelefonoDB(Context.Request.QueryString("celularmedico")),
                                                                .emailMedico = Context.Request.QueryString("correomedico"),
                                                                .NombreMedico = Context.Request.QueryString("mediconombre"),
                                                                .Exequatur = Context.Request.QueryString("medicoexequatur")
                                                                }

                'Inicialiar el Objecto PrestadoraSalud que esta relacionado con este formulario de licencia.'
                .PrestadoraSalud = New SuirPlus.Subsidios.Prestadora With {
                                                                           .idPssCentro = Convert.ToInt32(Context.Request.QueryString("numeropss")),
                                                                           .nombreCentro = Context.Request.QueryString("nombrepss"),
                                                                           .DireccionCentro = Context.Request.QueryString("direccionpss"),
                                                                           .TelefonoCentro = Utils.FormatearTelefonoDB(Context.Request.QueryString("telefonopss")),
                                                                           .faxCentro = Utils.FormatearTelefonoDB(Context.Request.QueryString("faxpss")),
                                                                           .emailCentro = Context.Request.QueryString("correopss")
                                                                          }

                .diagnostico = Context.Request.QueryString("diagnostico")
                .signoSintomas = Context.Request.QueryString("sintomas")
                .Procedimientos = Context.Request.QueryString("procedimientos")
                .fechaDiagnostico = Utils.FormatearFecha(Context.Request.QueryString("fechadiagnostico"))
                .NroFormulario = nroformulario
            End With

            'Datos del Nacimiento
            Dim nacimiento = New SuirPlus.Subsidios.Lactante()

            nacimiento.FechaNacimiento = Utils.FormatearFecha(Context.Request.QueryString("fechanacimiento"))
            nacimiento.CantidadLactante = Convert.ToInt32(Context.Request.QueryString("cantidadlactante"))

            'Dato de los lactantes
            Dim lactante As SuirPlus.Subsidios.Lactante = New SuirPlus.Subsidios.Lactante()
            Dim lactantes = New List(Of SuirPlus.Subsidios.Lactante)

            For index = 1 To nacimiento.CantidadLactante

                lactante = New SuirPlus.Subsidios.Lactante()

                Dim nsslactante = Context.Request.QueryString("nsslactante" & index.ToString)
                If nsslactante = "" Then
                    lactante.NSSLactante = Nothing
                Else
                    lactante.NSSLactante = Convert.ToInt32(nsslactante)
                End If

                lactante.Nombres = Context.Request.QueryString("nombreslactante" & index.ToString)
                lactante.PrimerApellido = Context.Request.QueryString("papellidolactante" & index.ToString)
                lactante.SegundoApellido = Context.Request.QueryString("sapellidolactante" & index.ToString)
                lactante.NUI = Context.Request.QueryString("nuilactante" & index.ToString)
                lactante.Sexo = Context.Request.QueryString("sexolactante" & index.ToString)

                lactantes.Add(lactante)
            Next

            Dim nrosolicitud = Context.Request.QueryString("nrosolicitudpostnatal")
            Dim result = SuirPlus.Subsidios.Maternidad.RegistrarLicenciaPostNatal(nss, fechalicencia, usuario, registropatronal, datosformulario, nacimiento, lactantes, nrosolicitud)

            Return result

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.Message)
            Return ex.Message.ToString
        End Try



    End Function
    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function getMaternidad(maternidadId As String, registropatronal As String) As Object

        Dim result = String.Empty
        Try
            Dim dtMaternidad = SuirPlus.Subsidios.Maternidad.TraerDatosMaternidad(Convert.ToInt32(maternidadId), Convert.ToInt32(registropatronal), result)

            If result = "OK" Then

                If dtMaternidad.Rows.Count > 0 Then

                    Dim detalleMaternidad = New With {
                                                      .MaternidadId = Convert.ToInt32(dtMaternidad.Rows(0)("ID_MATERNIDAD")),
                                                      .NroSolicitud = Convert.ToInt32(dtMaternidad.Rows(0)("NRO_SOLICITUD")),
                                                      .FechaDiagnostico = dtMaternidad.Rows(0).Field(Of DateTime)("FECHA_DIAGNOSTICO").ToShortDateString(),
                                                      .FechaEstimadaParto = dtMaternidad.Rows(0).Field(Of DateTime)("FECHA_ESTIMADA_PARTO").ToShortDateString(),
                                                      .CuentaBanco = dtMaternidad.Rows(0).Field(Of String)("CUENTA_BANCO"),
                                                      .Telefono = dtMaternidad.Rows(0).Field(Of String)("TELEFONO"),
                                                      .Celular = dtMaternidad.Rows(0).Field(Of String)("CELULAR"),
                                                      .Correo = dtMaternidad.Rows(0).Field(Of String)("EMAIL"),
                                                      .Estatus = dtMaternidad.Rows(0).Field(Of String)("ESTATUS"),
                                                      .FechaCancelacion = dtMaternidad.Rows(0).Field(Of DateTime?)("FECHA_CANCELACION"),
                                                      .CantidadDias = dtMaternidad.Rows(0).Field(Of Int16?)("CANTIDAD_DIAS"),
                                                      .CorreoTutor = dtMaternidad.Rows(0).Field(Of String)("EMAIL_TUTOR"),
                                                      .TelefonoTutor = dtMaternidad.Rows(0).Field(Of String)("TELEFONO_TUTOR"),
                                                      .NSSMadre = Convert.ToInt32(dtMaternidad.Rows(0)("nss")),
                                                      .NoDocumento = dtMaternidad.Rows(0).Field(Of String)("no_documento"),
                                                      .NombreMadre = dtMaternidad.Rows(0).Field(Of String)("nombre_madre"),
                                                      .PrimerApellidoMadre = dtMaternidad.Rows(0).Field(Of String)("primer_apellido_madre"),
                                                      .SegundoApellidoMadre = dtMaternidad.Rows(0).Field(Of String)("segundo_apellido_madre"),
                                                      .SexoMadre = dtMaternidad.Rows(0).Field(Of String)("sexo"),
                                                      .FechaNacimiento = dtMaternidad.Rows(0).Field(Of DateTime)("fecha_nacimiento").ToShortDateString(),
                                                      .FechaLicencia = dtMaternidad.Rows(0).Field(Of DateTime)("FECHA_LICENCIA").ToShortDateString(),
                                                      .RegistroPatronalLicencia = dtMaternidad.Rows(0).Field(Of Int32?)("ID_REGISTRO_PATRONAL"),
                                                      .NSSTutor = dtMaternidad.Rows(0).Field(Of Int32?)("NSS_TUTOR"),
                                                      .CuentaTutor = dtMaternidad.Rows(0).Field(Of String)("CUENTA_TUTOR"),
                                                      .NombreTutor = dtMaternidad.Rows(0).Field(Of String)("nombre_tutor"),
                                                      .PrimerApellidoTutor = dtMaternidad.Rows(0).Field(Of String)("primer_apellido_tutor"),
                                                      .SegundoApellidoTutor = dtMaternidad.Rows(0).Field(Of String)("segundo_apellido_tutor"),
                                                      .FechaNacimientoTutor = Convert.ToDateTime(dtMaternidad.Rows(0).Field(Of DateTime?)("fecha_nacimiento_tutor")).ToShortDateString(),
                                                      .SexoTutor = dtMaternidad.Rows(0).Field(Of String)("sexo_tutor"),
                                                      .NroDocumentoTutor = dtMaternidad.Rows(0).Field(Of String)("no_documento_tutor"),
                                                      .PSSMedico = dtMaternidad.Rows(0).Field(Of Int32)("ID_PSS_MED"),
                                                      .NoDocumentoMedico = dtMaternidad.Rows(0).Field(Of String)("NO_DOCUMENTO_MED"),
                                                      .NombreMedico = dtMaternidad.Rows(0).Field(Of String)("NOMBRE_MED"),
                                                      .DireccionMedico = dtMaternidad.Rows(0).Field(Of String)("DIRECCION_MED"),
                                                      .TelefonoMedico = dtMaternidad.Rows(0).Field(Of String)("TELEFONO_MED"),
                                                      .CelularMedico = dtMaternidad.Rows(0).Field(Of String)("CELULAR_MED"),
                                                      .CorreoMedico = dtMaternidad.Rows(0).Field(Of String)("EMAIL_MED"),
                                                      .PssCen = dtMaternidad.Rows(0).Field(Of Int32)("ID_PSS_CEN"),
                                                      .NombreCentro = dtMaternidad.Rows(0).Field(Of String)("NOMBRE_CEN"),
                                                      .DireccionCentro = dtMaternidad.Rows(0).Field(Of String)("DIRECCION_CEN"),
                                                      .TelefonoCentro = dtMaternidad.Rows(0).Field(Of String)("TELEFONO_CEN"),
                                                      .FaxCentro = dtMaternidad.Rows(0).Field(Of String)("FAX_CEN"),
                                                      .CorreoCentro = dtMaternidad.Rows(0).Field(Of String)("EMAIL_CEN"),
                                                      .Exequatur = dtMaternidad.Rows(0).Field(Of String)("EXEQUATUR"),
                                                      .Diagnostico = dtMaternidad.Rows(0).Field(Of String)("DIAGNOSTICO"),
                                                      .Sintomas = dtMaternidad.Rows(0).Field(Of String)("SIGNOS_SINTOMAS"),
                                                      .Procedimientos = dtMaternidad.Rows(0).Field(Of String)("PROCEDIMIENTOS"),
                                                      .FechaDiagnosticoLicencia = Convert.ToDateTime(dtMaternidad.Rows(0).Field(Of DateTime?)("FECHA_DIAGNOSTICO")).ToShortDateString()
                                                  }

                    Return detalleMaternidad
                Else
                    Return "Esta maternidad no esta registrada."

                End If

            Else
                Return result
            End If

        Catch ex As Exception
            Return ex.ToString
        End Try
    End Function

#End Region

#Region "testing subir imagen by charlie pena"
    '   <WebMethod()> _
    '<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    '   Public Function SubirImagen() As String
    '       Try


    '           Dim ImgStream As System.IO.Stream
    '           Dim imgLength As Integer
    '           Dim height As Integer
    '           Dim width As Integer
    '           Dim thumbnail As Boolean
    '           Dim ImagenMod() As Byte

    '           Dim result = String.Empty

    '           Dim nrosolicitud = 0

    '           Dim memoryStream As New MemoryStream()
    '           Dim streamWriter As New StreamWriter(memoryStream)

    '           Dim texto = Context.Request.QueryString("Text1")

    '           streamWriter.Write(Context.Request.QueryString("fuImagenSubsidio"))
    '           memoryStream.Position = 0

    '           ImgStream = memoryStream

    '           Return texto

    '       Catch ex As Exception

    '           Return ex.Message
    '       End Try
    '   End Function

    '   <WebMethod()> _
    '   Public Function GetEmployee(ByVal employeeId As String) As String
    '       'simulate employee name lookup

    '       Dim ImgStream As System.IO.Stream
    '       Dim imgLength As Integer
    '       Dim height As Integer
    '       Dim width As Integer
    '       Dim thumbnail As Boolean
    '       Dim ImagenMod() As Byte

    '       Dim result = String.Empty
    '       Dim nrosolicitud = 0
    '       Dim memoryStream As New MemoryStream()
    '       Dim streamWriter As New StreamWriter(memoryStream)
    '       Dim hfc As HttpFileCollection = Context.Request.Files
    '       For i As Integer = 0 To hfc.Count - 1
    '           Dim hpf As HttpPostedFile = hfc(i)
    '           If hpf.ContentLength > 0 Then
    '               result = "File: " + hpf.FileName & " Size: " + hpf.ContentLength & " Type: " + hpf.ContentType & " Uploaded uccessfully "

    '           End If
    '       Next

    '       Return result

    '   End Function

#End Region

#Region "Registro Enfermedad Comun"
    <WebMethod()> _
 <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ObtenerOpcionesEnfermedadComun(ByVal nss As String, ByVal registropatronal As String) As List(Of NovedadesPendientes)

        Return SuirPlus.Subsidios.Novedades.ObtenerOpcionesMenuEnfermedadComun(Convert.ToInt32(nss), Convert.ToInt32(registropatronal))

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function RegistrarDatosInciales(ByVal nsstrabajador As String, ByVal tiposolicitud As String, ByVal numerosolicitud As String,
                                           ByVal direcciontrabajador As String, ByVal telefonotrabajador As String, ByVal correotrabajador As String,
                                           ByVal celulartrabajador As String, ByVal usuario As String) As String


        Dim nroSolicitud = String.Empty
        Dim Pin = String.Empty
        Dim NroFormulario = String.Empty


        Dim telefono = Utils.FormatearTelefonoDB(telefonotrabajador)
        Dim celular = Utils.FormatearTelefonoDB(celulartrabajador)

        If String.IsNullOrEmpty(direcciontrabajador) Then
            Return "La dirección de la afiliada es requerida."
        End If


        If String.IsNullOrEmpty(telefono) Then
            Return "El teléfono del empleado es requerido"
        End If


        Try

            Dim result = SuirPlus.Subsidios.EnfermedadComun.RegistrarDatosIniciales(Convert.ToInt32(nsstrabajador), tiposolicitud, numerosolicitud,
                                                                                    direcciontrabajador, telefono, correotrabajador, celular, usuario, Pin, nroSolicitud, NroFormulario)

            If result.Equals("OK") Then

                Dim hash = SuirPlus.Empresas.SubsidiosSFS.EnfermedadComun.hashValores(NroFormulario)

                Return result & "|" & Pin & "|" & hash
            End If

            Return result

        Catch ex As Exception
            Return ex.ToString
        End Try

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function CompletarRegistro() As String


        If String.IsNullOrEmpty(Context.Request.QueryString("direcciontrabajador")) Then
            Return "La dirección de la afiliada es requerida."
        End If


        If String.IsNullOrEmpty(Context.Request.QueryString("telefonotrabajador")) Then
            Return "El teléfono del empleado es requerido"
        End If

        If Utils.FormatearFecha(Context.Request.QueryString("fechadiagnostico")).Date > DateTime.Now.Date Then
            Return "La fecha de diagnóstico no debe ser futura!"
        End If



        ' Datos del Formulario

        Dim datosformulario As New SuirPlus.Subsidios.Formulario()

        Dim numeropss = Context.Request.QueryString("numeropss")

        If numeropss = "" Then
            numeropss = Nothing
        Else
            numeropss = Context.Request.QueryString("numeropss")
        End If

        'Si es Normal o una Reconsideracion, Este puede ser R = "Reconsidenracion" o N = "Normal" 
        Dim modo = Context.Request.QueryString("modo")

        With datosformulario

            'Inicialiar el Objecto Medico que esta relacionado con este formulario de licencia.'
            .Medico = New SuirPlus.Subsidios.Medico() With {
                                                            .PSS_Med = numeropss,
                                                            .NoDocumentoMedico = Context.Request.QueryString("cedulamedico"),
                                                            .DireccionMedico = Context.Request.QueryString("direccionmedico"),
                                                            .TelefonoMedico = Utils.FormatearTelefonoDB(Context.Request.QueryString("telefonomedico")),
                                                            .celularMedico = Utils.FormatearTelefonoDB(Context.Request.QueryString("celularmedico")),
                                                            .emailMedico = Context.Request.QueryString("correomedico"),
                                                            .NombreMedico = Context.Request.QueryString("mediconombre"),
                                                            .Exequatur = Context.Request.QueryString("medicoexequatur")
                                                            }



            .PrestadoraSalud = New SuirPlus.Subsidios.Prestadora()

            If Context.Request.QueryString("phospitalario").Equals("S") Then


                'Inicialiar el Objecto PrestadoraSalud que esta relacionado con este formulario de licencia.'
                .PrestadoraSalud = New SuirPlus.Subsidios.Prestadora With {
                                                                           .idPssCentro = Convert.ToInt32(Context.Request.QueryString("numeropss")),
                                                                           .nombreCentro = Context.Request.QueryString("nombrepss"),
                                                                           .DireccionCentro = Context.Request.QueryString("direccionpss"),
                                                                           .TelefonoCentro = Utils.FormatearTelefonoDB(Context.Request.QueryString("telefonopss")),
                                                                           .faxCentro = Utils.FormatearTelefonoDB(Context.Request.QueryString("faxpss")),
                                                                           .emailCentro = Context.Request.QueryString("correopss")
                                                                          }
            End If

            .UltimoUsrAct = Context.Request.QueryString("usuario")
            .diagnostico = Context.Request.QueryString("diagnostico")
            .signoSintomas = Context.Request.QueryString("sintomas")
            .Procedimientos = Context.Request.QueryString("procedimientos")
            .fechaDiagnostico = Utils.FormatearFecha(Context.Request.QueryString("fechadiagnostico"))
            .TipoFormulario = "E"
        End With

        'Datos de la Enfermedad Comun'

        Dim enfComun = New SuirPlus.Subsidios.EnfermedadComun()

        Dim nomina = Context.Request.QueryString("nomina")

        If nomina = "" Then
            nomina = Nothing
        Else
            nomina = Context.Request.QueryString("nomina")
        End If



        With enfComun
            .NSS = Convert.ToInt32(Context.Request.QueryString("nss"))
            .UltimoUsrAct = Context.Request.QueryString("usuario")
            .RegistroPatronal = Context.Request.QueryString("registropatronal")
            .Direccion = Context.Request.QueryString("direcciontrabajador")
            .Correo = Context.Request.QueryString("correotrabajador")
            .Telefono = Utils.FormatearTelefonoDB(Context.Request.QueryString("telefonotrabajador"))
            .Celular = Utils.FormatearTelefonoDB(Context.Request.QueryString("celulartrabajador"))
            .Solicitud = New SuirPlus.Subsidios.Solicitud With {.Nomina = Convert.ToInt32(nomina),
                                                                .NroSolicitud = Convert.ToDecimal(Context.Request.QueryString("numerosolicitud"))}
            .Ambulatorio = Context.Request.QueryString("pambulatorio")
            .Hospitalizado = Context.Request.QueryString("phospitalario")
            .CodigoCie10 = Context.Request.QueryString("cie10")

            Try

                If Context.Request.QueryString("pambulatorio").Equals("S") Then
                    .FechaInicioAmbulatorio = Utils.FormatearFecha(Context.Request.QueryString("fechalicenciaamb"))
                    .DiasCalendarioAmbulatorio = Context.Request.QueryString("diasamb")
                End If

                If Context.Request.QueryString("phospitalario").Equals("S") Then
                    .FechaInicioHospitalizado = Utils.FormatearFecha(Context.Request.QueryString("fechalicenciahosp"))
                    .DiasCalendarioHospitalizado = Context.Request.QueryString("diashosp")
                End If

            Catch ex As Exception

                Dim msg As String = ""

                msg = msg & " ... " & Context.Request.QueryString("fechadiagnostico")
                msg = msg & " ... " & Context.Request.QueryString("fechalicenciaamb")
                msg = msg & " ... " & ex.ToString()

                Throw New Exception(msg)

            End Try

            .TipoDiscapacidad = Context.Request.QueryString("tipodiscapacidad")
        End With

        Try

            If enfComun.Hospitalizado.Equals("S") And enfComun.Ambulatorio.Equals("S") Then

                If enfComun.FechaInicioHospitalizado = enfComun.FechaInicioAmbulatorio Then
                    Return "La fecha de inicio de licencias no deben coincidir"
                End If

                If enfComun.FechaInicioAmbulatorio < enfComun.FechaInicioHospitalizado Then
                    If DateAdd(DateInterval.Day, enfComun.DiasCalendarioAmbulatorio, enfComun.FechaInicioAmbulatorio) > enfComun.FechaInicioHospitalizado Then
                        Return "La fecha de inicio de licencias no deben coincidir"
                    End If
                End If

                If enfComun.FechaInicioHospitalizado < enfComun.FechaInicioAmbulatorio Then
                    If DateAdd(DateInterval.Day, enfComun.DiasCalendarioHospitalizado, enfComun.FechaInicioHospitalizado) > enfComun.FechaInicioAmbulatorio Then
                        Return "La fecha de inicio de licencias no deben coincidir"
                    End If
                End If

            End If

            Dim result = SuirPlus.Subsidios.EnfermedadComun.CompletarRegistro(enfComun, datosformulario, modo)

            Return result

        Catch ex As Exception
            Return ex.ToString
        End Try
    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ObtenerNominaDiscapacitados(ByVal nss As String, ByVal registropatronal As String) As List(Of DetalleNomina)
        Return SuirPlus.Subsidios.Novedades.ObtenerNominaDiscapacitados(Convert.ToInt32(nss), Convert.ToInt32(registropatronal))
    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ObtenerDatosIniciales(ByVal numerosolicitud As String) As SuirPlus.Subsidios.EnfermedadComun

        Dim enf As New SuirPlus.Subsidios.EnfermedadComun(Convert.ToInt32(numerosolicitud))

        Return enf

    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ObtenerPadecimientosCompletados(ByVal nss As String, ByVal registropatronal As String) As List(Of DetalleEnfermedadComun)
        Return SuirPlus.Subsidios.EnfermedadComun.ObtenerPadecimientosCompletados(Convert.ToInt32(nss), Convert.ToInt32(registropatronal))
    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function PadecimientosAConvalidar(ByVal nss As String, ByVal registropatronal As String) As List(Of DetalleEnfermedadComun)
        Return SuirPlus.Subsidios.EnfermedadComun.PadecimientosAConvalidar(Convert.ToInt32(nss), Convert.ToInt32(registropatronal))
    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function MostrarDatosReintegro(ByVal nrosolicitud As String) As Object
        Dim datosReitengo = SuirPlus.Subsidios.EnfermedadComun.MostrarDatosReintegro(Convert.ToInt32(nrosolicitud))
        Return datosReitengo
    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function RecibirDatosReintegro(ByVal nrosolicitud As String, ByVal fechareintegro As String, ByVal usuario As String, ByVal registropatronal As String) As String
        Try
            Return SuirPlus.Subsidios.EnfermedadComun.RecibirDatosReintegro(Convert.ToInt32(nrosolicitud), Utils.FormatearFecha(fechareintegro), usuario, Convert.ToInt32(registropatronal))
        Catch ex As Exception
            Return ex.ToString
        End Try
    End Function

    <WebMethod()> _
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function ConvalidarPadecimiento(ByVal nrosolicitud As String, ByVal registropatronal As String, ByVal usuario As String, ByVal idnomina As String) As String
        Try
            Return SuirPlus.Subsidios.EnfermedadComun.ConvalidarPadecimiento(Convert.ToInt32(nrosolicitud), Convert.ToInt32(registropatronal), usuario, Convert.ToInt32(idnomina))
        Catch ex As Exception
            Return ex.ToString
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Function getEnfermedadComun(idenfermedadcomun As String, registropatronal As String) As Object

        Dim result = String.Empty

        Try

            Dim dtEnfermedadComun = SuirPlus.Subsidios.EnfermedadComun.TraerEnfermedadComun(Convert.ToInt32(idenfermedadcomun), Convert.ToInt32(registropatronal), result)


            If result = "OK" Then

                If dtEnfermedadComun.Rows.Count > 0 Then

                    Dim detalleEnfermedadComun = New With {.id = Convert.ToInt32(dtEnfermedadComun.Rows(0)("ID_ENFERMEDAD_COMUN")),
                                                           .NroSolicitud = Convert.ToInt32(dtEnfermedadComun.Rows(0)("NRO_SOLICITUD")),
                                                           .Direccion = dtEnfermedadComun.Rows(0)("DIRECCION").ToString(),
                                                           .Telefono = dtEnfermedadComun.Rows(0)("TELEFONO").ToString(),
                                                           .Correo = dtEnfermedadComun.Rows(0)("EMAIL").ToString(),
                                                           .TipoDiscapacidad = dtEnfermedadComun.Rows(0)("TIPO_DISCAPACIDAD").ToString(),
                                                           .Ambulatorio = dtEnfermedadComun.Rows(0)("AMBULATORIO").ToString(),
                                                           .FechaInicioAmbulatorio = dtEnfermedadComun.Rows(0).Field(Of DateTime?)("FECHA_INICIO_AMB"),
                                                           .DiasCalendarioAmbulatorio = Convert.ToInt32(dtEnfermedadComun.Rows(0)("DIAS_CAL_AMB")),
                                                           .Hospitalizado = dtEnfermedadComun.Rows(0)("HOSPITALIZACION").ToString(),
                                                           .FechaInicioHospitalizado = dtEnfermedadComun.Rows(0).Field(Of DateTime?)("FECHA_INICIO_HOS"),
                                                           .DiasCalendarioHospitalizado = Convert.ToInt32(dtEnfermedadComun.Rows(0)("DIAS_CAL_HOS")),
                                                           .CodigoCie10 = dtEnfermedadComun.Rows(0)("CODIGOCIE10").ToString(),
                                                           .FechaRegistro = dtEnfermedadComun.Rows(0).Field(Of DateTime)("FECHA_REGISTRO"),
                                                           .UltimoUsrAct = dtEnfermedadComun.Rows(0)("ULT_USUARIO_ACT").ToString(),
                                                           .FechaUltimaAct = dtEnfermedadComun.Rows(0).Field(Of DateTime)("ULT_FECHA_ACT"),
                                                           .Pin = Convert.ToInt32(dtEnfermedadComun.Rows(0)("PIN")),
                                                           .Completado = dtEnfermedadComun.Rows(0)("COMPLETADO").ToString(),
                                                           .NSS = Convert.ToInt32(dtEnfermedadComun.Rows(0)("nss")),
                                                           .NoDocumento = dtEnfermedadComun.Rows(0)("no_documento").ToString(),
                                                           .PSSMedico = Convert.ToInt32(dtEnfermedadComun.Rows(0)("ID_PSS_MED")),
                                                           .NoDocumentoMedico = dtEnfermedadComun.Rows(0)("NO_DOCUMENTO_MED").ToString(),
                                                           .NombreMedico = dtEnfermedadComun.Rows(0)("NOMBRE_MED").ToString(),
                                                           .DireccionMedico = dtEnfermedadComun.Rows(0)("DIRECCION_MED").ToString(),
                                                           .TelefonoMedico = dtEnfermedadComun.Rows(0)("TELEFONO_MED").ToString(),
                                                           .CelularMedico = dtEnfermedadComun.Rows(0)("CELULAR_MED").ToString(),
                                                           .CorreoMedico = dtEnfermedadComun.Rows(0)("EMAIL_MED").ToString(),
                                                           .PssCen = Convert.ToInt32(dtEnfermedadComun.Rows(0)("ID_PSS_CEN")),
                                                           .NombreCentro = dtEnfermedadComun.Rows(0)("NOMBRE_CEN").ToString(),
                                                           .DireccionCentro = dtEnfermedadComun.Rows(0)("DIRECCION_CEN").ToString(),
                                                           .TelefonoCentro = dtEnfermedadComun.Rows(0)("TELEFONO_CEN").ToString(),
                                                           .FaxCentro = dtEnfermedadComun.Rows(0)("FAX_CEN").ToString(),
                                                           .CorreoCentro = dtEnfermedadComun.Rows(0)("EMAIL_CEN").ToString(),
                                                           .Exequatur = dtEnfermedadComun.Rows(0)("EXEQUATUR").ToString(),
                                                           .Diagnostico = dtEnfermedadComun.Rows(0)("DIAGNOSTICO").ToString(),
                                                           .Sintomas = dtEnfermedadComun.Rows(0)("SIGNOS_SINTOMAS").ToString(),
                                                           .Procedimientos = dtEnfermedadComun.Rows(0)("PROCEDIMIENTOS").ToString(),
                                                           .FechaDiagnostico = dtEnfermedadComun.Rows(0).Field(Of DateTime?)("FECHA_DIAGNOSTICO")}


                    Return detalleEnfermedadComun
                Else
                    Return "Esta Enfermedad no tiene datos que mostar"
                End If
            Else
                Return result

            End If

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString)
            Return ex.Message
        End Try
    End Function

#End Region
End Class
