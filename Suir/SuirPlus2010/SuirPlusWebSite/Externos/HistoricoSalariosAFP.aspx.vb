Imports System.Net
Imports System.Web.Services.Protocols.SoapHttpClientProtocol
Imports System.Security.Cryptography.X509Certificates
Imports System.Net.Security
Imports System.Data
Imports SuirPlus
Imports System.Xml
Imports System.IO
Imports System.Globalization
Imports SuirPlus.Utilitarios.Utils


Partial Class Externos_HistoricoSalariosAFP
    Inherits BasePage

    Protected empleado As SuirPlus.Empresas.Trabajador
    Protected idciudadano As String
    Protected empleador As String
    Protected ano As String
    Dim formulario() As Byte
    Protected imgStream As System.IO.Stream
    Protected imgLength As Integer
    Private height As Integer
    Private width As Integer
    Private thumbnail As Boolean

    Protected Sub Page_Load1(sender As Object, e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Session.Remove("_cedula")
        End If

        pageNum = 1
        PageSize = BasePage.PageSize


        pageNum2 = 1
        PageSize2 = BasePage.PageSize


    End Sub

    Public Property pageNum() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNum.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNum.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNum.Text = value
        End Set
    End Property

    Public Property PageSize() As Int16
        Get
            If String.IsNullOrEmpty(Me.lblPageSize.Text) Then
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSize.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSize.Text = value
        End Set
    End Property



    Public Property pageNum2() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNum.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNum.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNum.Text = value
        End Set
    End Property

    Public Property PageSize2() As Int16
        Get
            If String.IsNullOrEmpty(Me.lblPageSize.Text) Then
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSize.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSize.Text = value
        End Set
    End Property




    Function VerificarUsuarioAFP() As Boolean

        Dim is_usuario As String

        is_usuario = SuirPlus.Empresas.Trabajador.isUsuarioAFP(UsrIDEntidadRecaudadora, UsrUserName)

        If is_usuario = "true" Then
            Return True
        Else
            Return False
        End If
    End Function


    'Aqui verificamos el id de la entidad recaudadora del usuario logueado con el id devuelto por el webservice de la persona
    'que esta consultando
    Protected Sub VerificarAfiliadoAFP()

        'Dim Res As String = String.Empty
        'Dim Nombre As String = String.Empty
        Dim AFP As String = String.Empty
        Dim Status As String = String.Empty
        Dim tipo_afiliacion As String = String.Empty
        Dim Fecha_Afiliacion As String = String.Empty
        'Dim Fecha_Solicitud As String = String.Empty

        Dim nucleo As New DataTable

        If Me.txtCedula.Text = String.Empty Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "La cédula es requerida"
            Exit Sub
        Else
            Me.lblMensaje.Visible = False
            Me.lblMensaje.Text = String.Empty
        End If

        Try

            Dim ws As New wsUnipago.Consulta_Afiliados_SDSS

            Dim prxInternet As New SuirPlus.Config.Configuracion(Config.ModuloEnum.ProxyInternet)
            Dim infoWS As New SuirPlus.Config.Configuracion(Config.ModuloEnum.WS_SDSS)


            Dim ProxyUser As String = prxInternet.FTPUser
            Dim ProxyIP As String = prxInternet.FTPHost
            Dim ProxyDomain As String = prxInternet.FTPDir
            Dim ProxyPort As String = prxInternet.FTPPort
            Dim ProxyPass As String = prxInternet.FTPPass
            Dim dataPass As Byte() = Convert.FromBase64String(ProxyPass)
            ProxyPass = System.Text.ASCIIEncoding.ASCII.GetString(dataPass)

            Dim Autenticacion As New NetworkCredential(ProxyUser, ProxyPass, ProxyDomain) 'poner usuario y password de la red

            Dim ProxyServer As New WebProxy(ProxyIP, Convert.ToInt32(ProxyPort))
            ProxyServer.Credentials = Autenticacion
            ws.Proxy = ProxyServer


            'Dim Usuario As String = infoWS.FTPUser
            'Dim Pass As String = infoWS.FTPPass
            Dim Usuario As String = infoWS.FTPUser
            Dim Pass As String = infoWS.FTPPass
            Dim data As Byte() = Convert.FromBase64String(Pass)
            Pass = System.Text.ASCIIEncoding.ASCII.GetString(data)

            Dim Resultado As String
            Resultado = ws.ConsultarAfiliacionAFPporCedula(Me.txtCedula.Text, Usuario, Pass)

            Dim dataUrl As StringReader
            dataUrl = New StringReader(Resultado)
            Dim ds As DataSet = New DataSet
            ds.ReadXml(dataUrl)


            If ds.Tables.Count > 0 Then

                If Not IsNothing(ds.Tables("DatosAfiliacion")) Then
                    'AFP = ds.Tables("DatosAfiliacion").Rows(0)("AFP").ToString()

                    Me.lblMensaje.Visible = True
                    Me.lblMensaje.Text = "Algo Devolvio el web service"

                End If
            End If


        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
        End Try
    End Sub


    Function ValidarCedula() As Boolean
        idciudadano = txtCedula.Text

        Try

            If idciudadano.Length = 9 Then
                empleado = New SuirPlus.Empresas.Trabajador(Convert.ToInt32(idciudadano))
            ElseIf idciudadano.Length = 11 Then
                empleado = New SuirPlus.Empresas.Trabajador(SuirPlus.Empresas.Trabajador.TrabajadorDocumentoType.Cedula, idciudadano)
            End If

        Catch ex As Exception

            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Return False
        End Try

        If empleado Is Nothing Then
            Me.lblMensaje.Text = SuirPlus.Utilitarios.TSS.getErrorDescripcion(24)
            Return False
        End If


        Return True
    End Function


    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click


        If ValidarCedula() = True Then

            If ValidarFormulario() = True Then


                If VerificarUsuarioAFP() = True Then

                    'Falta colocar el id_entidad_recaudadora devuelto por el web service, el aprobado depende de lo que devuelve el web service, y
                    '   InsertarHistoricoSalarios(txtCedula.Text, Me.UsrUserName, id_entidad_recaudadora_afil, Me.UsrIDEntidadRecaudadora, aprobado, formulario)
                    BindResultadoConsulta(UsrIDEntidadRecaudadora, Me.pageNum, Me.PageSize)
                    'VerificarAfiliadoAFP()  falta chequear este metodo y convertirlo en funcion para saber si porcede o no

                Else
                    divDatos.Visible = False
                    Me.lblMensaje.Visible = True
                    Me.lblMensaje.Text = "No es usuario AFP"


                End If
            End If
        Else
            divDatos.Visible = False
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "Cédula Inválida"

        End If
    End Sub


    Protected Sub InsertarHistorico(cedula As String, id_usuario As Integer, id_entidad_recaudadora_afil As Integer, id_entidad_rec_cons As Integer, aprobado As String, archivos As Byte)
        Dim dtResultadoConsulta As String

        Try
            dtResultadoConsulta = SuirPlus.Empresas.Trabajador.InsertarHistoricoSalarios(cedula, id_usuario, id_entidad_recaudadora_afil, id_entidad_rec_cons, aprobado, formulario)


        Catch ex As Exception
            Throw ex
        End Try
    End Sub



    Protected Sub BindResultadoConsulta(id_entidad_recaudora As Integer, pagenum As Integer, pagesize As Integer)
        Dim dtResultadoConsulta As New DataTable

        Try
            dtResultadoConsulta = SuirPlus.Empresas.Trabajador.getConsultasRealizadas(id_entidad_recaudora, Me.pageNum, Me.PageSize)
            If dtResultadoConsulta.Rows.Count > 0 Then
                'llenamos el grid y los labels'


                divConsultasRealizadas.Visible = True
                Me.lblTotalRegistros.Text = dtResultadoConsulta.Rows(0)("RECORDCOUNT")
                Me.gvConsultasRealizadas.DataSource = dtResultadoConsulta
                Me.gvConsultasRealizadas.DataBind()
                'Me.imgMDT.Visible = False


            End If

            setNavigation()
            ' dtResultadoConsulta = Nothing
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Function ValidarFormulario() As Boolean
        'validacion imagen cargando(TIF o JPG )
        Dim Resultado As Boolean = True

        Try
            If Me.flCargarImagenCert.HasFile() Then
                imgStream = flCargarImagenCert.PostedFile.InputStream
                imgLength = flCargarImagenCert.PostedFile.ContentLength
                Dim imgContentType As String = flCargarImagenCert.PostedFile.ContentType

                Dim imgSize As String = (imgLength / 1024)

                    If imgSize > 900 Then
                        lblMensaje.Text = "El tamaño del archivo de imagen no debe superar los 800 KB, por favor contacte a mesa de ayuda."
                        Return False

                    Else
                        Dim imageContent(imgLength) As Byte
                        imgStream.Read(imageContent, 0, imgLength)
                        formulario = imageContent
                    End If

                Else

                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "Debe Subir el formulario de solicitud"
                    Return False
                End If



            Return Resultado

        Catch ex As Exception

            Me.lblMensaje.Text = ex.Message

            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

        Return Resultado
    End Function

    Protected Sub BindInfoGeneral(id_consulta As Integer)
        Dim dtResultadoConsulta As New DataTable

        Try
            dtResultadoConsulta = SuirPlus.Empresas.Trabajador.getInfoConsultasRealizadas(id_consulta)
            If dtResultadoConsulta.Rows.Count > 0 Then
                'llenamos el grid y los labels'

                divConsultasRealizadas.Visible = False
                divInfo.Visible = True
                Me.lblNombres.Text = dtResultadoConsulta.Rows(0)("Nombres")
                Me.lblAfp.Text = dtResultadoConsulta.Rows(0)("entidad_recaudadora_des")
                Me.lblFechaSolicitud.Text = dtResultadoConsulta.Rows(0)("fecha_solicitud").ToString()


                'Me.imgMDT.Visible = False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub




    Protected Sub BindHistoricoSalarios(cedula As String, pagenum As Integer, pagesize As Integer)
        Dim dtHistoricoSalarios As New DataTable

        Try
            dtHistoricoSalarios = SuirPlus.Empresas.Trabajador.getHistoricoSalarios(cedula, Me.pageNum, Me.PageSize)
            If dtHistoricoSalarios.Rows.Count > 0 Then
                'llenamos el grid y los labels'


                divHistoricoSalarios.Visible = True
                Me.gvHistoricoSalarios.DataSource = dtHistoricoSalarios
                Me.gvHistoricoSalarios.DataBind()
                Me.lblTotalRegistros2.Text = dtHistoricoSalarios.Rows(0)("RECORDCOUNT")
                'Me.imgMDT.Visible = False


            End If

            setNavigation2()
            ' dtResultadoConsulta = Nothing
        Catch ex As Exception
            Throw ex
        End Try
    End Sub



    Private Sub setNavigation()

        Dim totalRecords As Integer = 0

        If IsNumeric(Me.lblTotalRegistros2.Text) Then
            totalRecords = CInt(Me.lblTotalRegistros.Text)
        End If

        Dim totalPages As Double = Math.Ceiling(Convert.ToDouble(totalRecords) / PageSize)

        If totalRecords = 1 Or totalPages = 0 Then
            totalPages = 1
        End If

        If PageSize > totalRecords Then
            PageSize = Int16.Parse(totalPages)
        End If

        Me.lblCurrentPage.Text = pageNum
        Me.lblTotalPages.Text = totalPages

        If pageNum = 1 Then
            Me.btnLnkFirstPage.Enabled = False
            Me.btnLnkPreviousPage.Enabled = False
        Else
            Me.btnLnkFirstPage.Enabled = True
            Me.btnLnkPreviousPage.Enabled = True
        End If

        If pageNum = totalPages Then
            Me.btnLnkNextPage.Enabled = False
            Me.btnLnkLastPage.Enabled = False
        Else
            Me.btnLnkNextPage.Enabled = True
            Me.btnLnkLastPage.Enabled = True
        End If

    End Sub



    Protected Sub NavigationLink_Click(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First"
                pageNum = 1
            Case "Last"
                pageNum = Convert.ToInt32(lblTotalPages.Text)
            Case "Next"
                pageNum = Convert.ToInt32(lblCurrentPage.Text) + 1
            Case "Prev"
                pageNum = Convert.ToInt32(lblCurrentPage.Text) - 1
        End Select

        'Aqui ponemos el metodo que cargara la informacion perteneciente al grid de la paginacion'
        BindResultadoConsulta(UsrIDEntidadRecaudadora, Me.pageNum, Me.PageSize)
    End Sub




    'Para el segundo GRID del resultado de la consulta



    Private Sub setNavigation2()

        Dim totalRecords As Integer = 0

        If IsNumeric(Me.lblTotalRegistros2.Text) Then
            totalRecords = CInt(Me.lblTotalRegistros2.Text)
        End If

        Dim totalPages As Double = Math.Ceiling(Convert.ToDouble(totalRecords) / PageSize2)

        If totalRecords = 1 Or totalPages = 0 Then
            totalPages = 1
        End If

        If PageSize2 > totalRecords Then
            PageSize2 = Int16.Parse(totalPages)
        End If

        Me.lblCurrentPage2.Text = pageNum2
        Me.lblTotalPages2.Text = totalPages

        If pageNum = 1 Then
            Me.btnLnkFirstPage2.Enabled = False
            Me.btnLnkPreviousPage2.Enabled = False
        Else
            Me.btnLnkFirstPage2.Enabled = True
            Me.btnLnkPreviousPage2.Enabled = True
        End If

        If pageNum = totalPages Then
            Me.btnLnkNextPage2.Enabled = False
            Me.btnLnkLastPage2.Enabled = False
        Else
            Me.btnLnkNextPage2.Enabled = True
            Me.btnLnkLastPage2.Enabled = True
        End If

    End Sub

    Protected Sub NavigationLink_Click2(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First"
                pageNum2 = 1
            Case "Last"
                pageNum2 = Convert.ToInt32(lblTotalPages2.Text)
            Case "Next"
                pageNum2 = Convert.ToInt32(lblCurrentPage2.Text) + 1
            Case "Prev"
                pageNum2 = Convert.ToInt32(lblCurrentPage2.Text) - 1
        End Select

        'Aqui ponemos el metodo que cargara la informacion perteneciente al grid de la paginacion'
        BindHistoricoSalarios(Session("_cedula"), Me.pageNum2, Me.PageSize2)
    End Sub



    Protected Function formateaCedula(ByVal Cedula As String) As String

        If Cedula = String.Empty Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormatearCedula(Cedula)
        End If

    End Function

    Protected Function formateaFecha(ByVal fecha As String) As String

        If fecha = String.Empty Then
            Return String.Empty
        Else

            Return Utilitarios.Utils.FormatearFecha(fecha.ToString)
        End If

    End Function

    Protected Sub gvConsultasRealizadas_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvConsultasRealizadas.RowCommand
        Dim Id_consulta As Integer = Split(e.CommandArgument, "|")(0)
        Dim cedula As String = Split(e.CommandArgument, "|")(1)


        Session("_cedula") = cedula
        Try
            If e.CommandName = "VerResultado" Then

                BindInfoGeneral(Id_consulta)
                BindHistoricoSalarios(cedula, Me.pageNum2, Me.PageSize2)
            End If


        Catch ex As Exception
            Me.lblErrorHistoricos.Visible = True
            Me.lblErrorHistoricos.Text = ex.Message
        End Try
    End Sub

    Protected Function formateaPeriodo(ByVal Periodo As Object) As String
        If Not IsDBNull(Periodo) Then
            Return Utilitarios.Utils.FormateaPeriodo(Periodo)
        Else
            Return String.Empty
        End If
    End Function



    Public Function formateaSalario(ByVal salario As String) As String
        Dim salFormatear As Double
        Dim res As String

        If Not IsNumeric(salario) Then
            Return salario
        Else
            salFormatear = CDbl(salario)
            res = String.Format("{0:c}", salFormatear)
            Return res
        End If
    End Function

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        Response.Redirect("HistoricoSalariosAFP.aspx")
    End Sub
End Class
