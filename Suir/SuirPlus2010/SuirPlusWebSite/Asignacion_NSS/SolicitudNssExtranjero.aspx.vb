Imports System.Data
Imports System.IO
Imports SuirPlus
Imports SuirPlusEF
Imports SuirPlusEF.Models
Imports SuirPlusEF.Service
Imports SuirPlusEF.ViewModels
Imports SuirPlusMasterPage
Partial Class Asignacion_NSS_SolicitudNssExtranjero
    Inherits BasePage

    Protected imgStream As System.IO.Stream
    Protected imgLength As Integer
    Private height As Integer
    Private width As Integer
    Private thumbnail As Boolean
    Dim ImagenMod() As Byte


    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            maskNroDocumento.PromptCharacter = " "
            maskNroDocumento.ClearMaskOnLostFocus = True
            maskNroDocumento.Mask = "99999999999"
            txtNroDocSinMask.Visible = True
            txtNroDocSinMask.Text = String.Empty
            txtNoDocumento.Text = String.Empty
            txtNoDocumento.Visible = False
            ddlTipo.Focus()
            CargarDatos()
            HabilitarParametros(True)
        End If

    End Sub
    Private Sub CargarDatos()
        CargarDdlTipoDocumento()
        CargarDdlNacionalidad()
        InhabilitarCampos()

    End Sub
    Private Sub InhabilitarCampos()

        Me.txtNombres.Enabled = False
        Me.txtPrimerApellido.Enabled = False
        Me.txtSegundoApellido.Enabled = False
        Me.txtFechaNac.Enabled = False
        DdlSexo.Enabled = False
        ddlNacionalidad.Enabled = False
        upLImagenSolicitud.Enabled = False
    End Sub
    Private Sub HabilitarCampos()

        Me.txtNombres.Enabled = True
        Me.txtPrimerApellido.Enabled = True
        Me.txtSegundoApellido.Enabled = True
        Me.txtFechaNac.Enabled = True
        DdlSexo.Enabled = True
        ddlNacionalidad.Enabled = True
        upLImagenSolicitud.Enabled = True
    End Sub
    Private Sub LimpiarCampos()

        Me.txtNoDocumento.Text = String.Empty
        txtNroDocSinMask.Text = String.Empty
        txtNombres.Text = String.Empty
        txtPrimerApellido.Text = String.Empty
        txtSegundoApellido.Text = String.Empty
        txtFechaNac.Text = String.Empty
        lblerror.Visible = False
        ddlTipo.SelectedValue = "0"
        ddlNacionalidad.SelectedValue = "-1"
        lblNombreExt.Text = String.Empty
        trNombreExt.Visible = False
        maskNroDocumento.MaskType = AjaxControlToolkit.MaskedEditType.None
        maskNroDocumento.Mask = AjaxControlToolkit.MaskedEditType.None
        maskNroDocumento.PromptCharacter = " "
        maskNroDocumento.ClearMaskOnLostFocus = True
        maskNroDocumento.Mask = "99999999999"
        txtNoDocumento.Focus()
        InhabilitarCampos()
        HabilitarParametros(True)
        btnValidar.Enabled = True
    End Sub
    Private Sub HabilitarParametros(ByVal habilitar As Boolean)
        If habilitar Then
            txtNoDocumento.Enabled = True
            txtNroDocSinMask.Enabled = True
            ddlTipo.Enabled = True
        Else
            txtNoDocumento.Enabled = False
            txtNroDocSinMask.Enabled = False
            ddlTipo.Enabled = False
        End If
    End Sub
    Protected Sub btnLimpiar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click

        lblmensaje.Visible = False
        LimpiarCampos()
        fsTSS.Visible = False
    End Sub
    Private Sub CargarDdlTipoDocumento()
        Try
            Dim TiposDocumentos As New SuirPlusEF.Repositories.TipoDocumentoRepository()
            Me.ddlTipo.DataSource = TiposDocumentos.GetAllTipoDocumento()
            ddlTipo.DataTextField = "Descripcion"
            ddlTipo.DataValueField = "IdTipoDocumento"
            ddlTipo.DataBind()
            ddlTipo.Items.Add(New ListItem("Seleccione", "0"))
            ddlTipo.SelectedValue = "0"
        Catch ex As Exception
            Throw ex.InnerException
        End Try
    End Sub
    Private Sub CargarDdlNacionalidad()
        Dim Nacionalidades As New SuirPlusEF.Repositories.NacionalidadRepository()
        Me.ddlNacionalidad.DataSource = Nacionalidades.GetAllNacionalidad()
        ddlNacionalidad.DataTextField = "Descripcion"
        ddlNacionalidad.DataValueField = "IdNacionalidad"
        ddlNacionalidad.DataBind()
        ddlNacionalidad.Items.Insert(0, New ListItem("Seleccione", "-1"))

    End Sub
    Protected Function ValidarImagen() As Boolean
        'validacion imagen cargando(PDF)
        Try
            If Me.upLImagenSolicitud.HasFile() Then
                imgStream = upLImagenSolicitud.PostedFile.InputStream
                imgLength = upLImagenSolicitud.PostedFile.ContentLength
                Dim imgContentType As String = upLImagenSolicitud.PostedFile.ContentType

                'validamos los tipos de archivos que deseamos aceptar
                If (imgContentType = "application/pdf" Or imgContentType = "application/PDF") Then
                    Dim imgSize As String = (imgLength / 1024)
                    If imgSize > 600 Then
                        Throw New Exception("La imagen debe ser menor o igual a 600kb")
                    End If

                    If (imgContentType <> "application/pdf" And imgContentType <> "application/PDF") Then
                        Throw New Exception("La imagen es requerida y de tipo PDF")
                    End If

                    Dim imageContent(imgLength) As Byte
                    imgStream.Read(imageContent, 0, imgLength)
                    ImagenMod = imageContent

                    Return True
                Else
                    Throw New Exception("La imagen es requerida y de tipo PDF")
                End If
            Else
                Throw New Exception("La imagen es requerida y de tipo PDF")
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Private Sub RehacerImagen()
        'Lee La primera imagen
        Dim intImageSize As Int64 = Me.upLImagenSolicitud.PostedFile.ContentLength
        Dim ImageStream As Stream = Me.upLImagenSolicitud.PostedFile.InputStream
        Dim imageContent(intImageSize) As Byte

        ImageStream.Read(imageContent, 0, intImageSize)


        'Esto es para leer
        Dim memStream As New MemoryStream(imageContent)

        Dim fullSizeImg As System.Drawing.Image = System.Drawing.Image.FromStream(memStream)

        height = Math.Round(fullSizeImg.Height / 2)
        width = Math.Round(fullSizeImg.Width / 2)


        Dim thumbNailImg As System.Drawing.Image
        Dim dummyCallBack As New System.Drawing.Image.GetThumbnailImageAbort(AddressOf ThumbnailCallBack)

        Dim ms As New MemoryStream()


        thumbNailImg = fullSizeImg.GetThumbnailImage(width, height, dummyCallBack, IntPtr.Zero)
        thumbNailImg.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg)

        'Lee las segunda imagen
        ImagenMod = ms.GetBuffer

    End Sub
    Public Function ThumbnailCallBack() As Boolean
        Return False
    End Function
    Protected Sub btnValidar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnValidar.Click

        Dim RepExtranjero As New Repositories.MaestroExtranjerosRepository()
        Dim RepCiudadano As New Repositories.CiudadanoRepository()
        Dim NroDocumento As String = String.Empty

        lblmensaje.Text = String.Empty
        lblerror.Text = String.Empty

        Try
            If ddlTipo.SelectedValue = "0" Then
                lblerror.Text = "Debe seleccionar un tipo de documento"
                lblerror.Visible = True
                lblmensaje.Visible = False
                Return
            End If
            If (txtNoDocumento.Text = String.Empty) And (Trim(txtNroDocSinMask.Text.ToUpper()) = String.Empty) Then
                lblerror.Text = "El número de documento es requerido"
                lblerror.Visible = True
                Return
            End If


            If ((txtNoDocumento.Text <> String.Empty)) And (ddlTipo.SelectedValue = "I") Then

                Dim Ext As MaestroExtranjero = RepExtranjero.GetExtranjero(txtNoDocumento.Text, ddlTipo.SelectedValue)
                lblerror.Visible = False
                If Ext IsNot Nothing Then
                    If Ext.IdNSSAsignado.HasValue Then
                        llenarPanelNSSExiste(Ext, Nothing)
                    Else
                        HabilitarCampos()
                        lblNombreExt.Text = Ext.Nombres & " " & Ext.PrimerApellido & " " & Ext.SegundoApellido
                        trNombreExt.Visible = True
                        lblmensaje.Text = "Por favor completar los datos del formulario"
                        lblmensaje.Visible = True
                        txtNombres.Focus()
                        ddlTipo.Enabled = False
                        HabilitarParametros(False)
                        btnProcesar.Enabled = True
                        btnValidar.Enabled = True
                    End If
                Else
                    lblerror.Text = "Número de expediente no existe en el maestro de extranjero"
                    lblerror.Visible = True
                    InhabilitarCampos()
                    Return
                End If
            ElseIf (txtNroDocSinMask.Text <> String.Empty) And (ddlTipo.SelectedValue = "G" Or ddlTipo.SelectedValue = "V") Then

                Dim Ext1 As MaestroExtranjero = RepExtranjero.GetExtranjero(txtNroDocSinMask.Text, ddlTipo.SelectedValue)

                If Ext1 IsNot Nothing Then
                    If Ext1.IdNSSAsignado.HasValue Then

                        llenarPanelNSSExiste(Ext1, Nothing)
                    Else
                        HabilitarCampos()
                        lblNombreExt.Text = Ext1.Nombres & " " & Ext1.PrimerApellido & " " & Ext1.SegundoApellido
                        trNombreExt.Visible = True
                        lblmensaje.Text = "Por favor completar los datos del formulario"
                        lblmensaje.Visible = True
                        txtNombres.Focus()
                        HabilitarParametros(False)
                        btnProcesar.Enabled = True
                        btnValidar.Enabled = True
                    End If
                Else

                    Dim repSolicitud As New Repositories.SolicitudNSSRepository()
                    Dim solProcesada = repSolicitud.GetSolicitudProcesada(txtNroDocSinMask.Text, ddlTipo.SelectedValue)

                    If solProcesada IsNot Nothing Then
                        llenarPanelNSSExiste(Nothing, solProcesada)
                    Else
                        HabilitarCampos()
                        trNombreExt.Visible = False
                        lblmensaje.Text = "Por favor completar los datos del formulario"
                        lblmensaje.Visible = True
                        HabilitarParametros(False)
                        btnProcesar.Enabled = True
                        btnValidar.Enabled = True
                    End If
                End If
            End If
            txtNombres.Focus()

        Catch ex As Exception
            lblerror.Text = "Error generando la solicitud."
            lblerror.Visible = True
            Exepciones.Log.LogToDB("Error generando la solicitud. " + ex.ToString())
        End Try

    End Sub

    Protected Sub llenarPanelNSSExiste(ByVal ext As MaestroExtranjero, ByVal detSol As DetalleSolicitudes)
        Dim RepExtranjero As New Repositories.MaestroExtranjerosRepository()
        Dim RepCiudadano As New Repositories.CiudadanoRepository()
        Dim ciu1 As Ciudadano
        Dim obj As Object = Nothing
        Dim expediente As String = String.Empty
        If ext IsNot Nothing Then
            obj = ext
            expediente = ext.IdExpediente
            ciu1 = RepCiudadano.GetByNSS(ext.IdNSSAsignado)
        Else
            obj = detSol
            expediente = detSol.Documento
            ciu1 = RepCiudadano.GetByNSS(detSol.IdNSSAsignado)
        End If

        lblNss.Text = ciu1.IdNSS
        lblNroExpediente.Text = expediente
        If ciu1.NroDocumento <> String.Empty Then
                lblNroDocumento.Text = Utilitarios.Utils.FormatearCedula(ciu1.NroDocumento)
            End If
        lblTipoDocumento.Text = obj.TipoDocumento.Descripcion
        lblNombres.Text = Utilitarios.Utils.ProperCase(ciu1.Nombres)
            lblPrimerApellido.Text = Utilitarios.Utils.ProperCase(ciu1.PrimerApellido)
            If ciu1.SegundoApellido IsNot Nothing Then
                lblSegundoApellido.Text = Utilitarios.Utils.ProperCase(ciu1.SegundoApellido)
            End If
        If ciu1.FechaNacimiento.ToShortDateString() <> String.Empty Then
            lblFechaNacimiento.Text = ciu1.FechaNacimiento.ToString("dd/MM/yyyy")
        End If
        lblSexo.Text = ciu1.Sexo
            If ciu1.IdNacionalidad IsNot Nothing Then
                lblNacionalidad.Text = Utilitarios.Utils.ProperCase(ciu1.Nacionalidad.Descripcion)
            End If
            fsTSS.Visible = True
            pnlInfoTSS.Visible = True
            InhabilitarCampos()
            lblciu.Text = "El ciudadano ya tiene un NSS asignado: " + lblNss.Text
            lblciu.Visible = True
            lblerror.Visible = False
            ddlTipo.Enabled = False
            txtNroDocSinMask.Enabled = False
            HabilitarParametros(False)
            btnProcesar.Enabled = False
            btnValidar.Enabled = False

            Dim repSolicitud As New Repositories.SolicitudNSSRepository()
            Dim solicitudCreada = repSolicitud.GetSolicitudNss(lblNss.Text)

        If (solicitudCreada.IdNSSAsignado IsNot Nothing) And (solicitudCreada.IdEstatus = AsignacionNSS.EstatusSolicitudNSSEnum.NSS_Asignado Or solicitudCreada.IdEstatus = AsignacionNSS.EstatusSolicitudNSSEnum.NSS_Existe Or solicitudCreada.IdEstatus = AsignacionNSS.EstatusSolicitudNSSEnum.Registro_Actualizado) Then
            If solicitudCreada.IdCertificacion IsNot Nothing Then
                Dim repCertificacion As New Repositories.CertificacionesRepository()
                Dim certificacion As New Models.Certificaciones()
                certificacion = repCertificacion.GetByIdCertificacion(solicitudCreada.IdCertificacion)

                If certificacion.PdfCertificacion IsNot Nothing Then
                    divGenerarCert.Visible = False
                    divVerCert.Visible = True
                Else
                    divGenerarCert.Visible = True
                    divVerCert.Visible = False
                End If
            Else
                divGenerarCert.Visible = True
                divVerCert.Visible = False
            End If
        End If


    End Sub
    Protected Sub btnProcesar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnProcesar.Click

        Dim SolicitudAsignacion As New SolicitudAsignacion()
        Dim vmSolicitudNSSExtranjero As New vmSolicitudNSSExtranjero()
        Dim Asignacion As New AsignacionNSS(1)
        Dim NumeroDocumento = String.Empty

        lblmensaje.Text = String.Empty
        lblerror.Text = String.Empty

        Try
            If ddlTipo.SelectedValue = "0" Then
                lblerror.Text = "Debe seleccionar un tipo de documento"
                lblerror.Visible = True
                Return
            End If
            If (txtNoDocumento.Text = String.Empty) And (txtNroDocSinMask.Text = String.Empty) Then
                lblerror.Text = "El número de documento es requerido"
                lblerror.Visible = True
                Return
            End If

            If txtNoDocumento.Text <> String.Empty Then
                NumeroDocumento = txtNoDocumento.Text
            ElseIf (txtNroDocSinMask.Text) <> String.Empty Then
                NumeroDocumento = txtNroDocSinMask.Text
            End If
            If ddlTipo.Enabled = True Then
                lblerror.Text = "Debe validar el número de documento"
                lblerror.Visible = True
                Return
            End If

            If txtNombres.Text.Trim() = String.Empty Then
                lblerror.Text = "El nombre es requerido"
                lblerror.Visible = True
                Return
            End If
            If txtPrimerApellido.Text.Trim() = "" Then
                lblerror.Text = "El primer apellido es requerido"
                lblerror.Visible = True
                Return
            End If
            If txtFechaNac.Text.Trim() = "" Then
                lblerror.Text = "La fecha es requerida"
                lblerror.Visible = True
                Return
            Else
                Try
                    Dim FechaNac = Convert.ToDateTime(txtFechaNac.Text.Trim())

                    If RangoMinimoFecha(FechaNac) Then
                        lblerror.Text = "La fecha de nacimiento debe ser mayor a 1900"
                        lblerror.Visible = True
                        Return
                    End If

                    If Fechafutura(FechaNac) Then
                        lblerror.Text = "La fecha de nacimiento no debe ser futura"
                        lblerror.Visible = True
                        Return
                    End If
                Catch ex As Exception
                    lblerror.Text = "Fecha de nacimieto inválida"
                    Return
                End Try

            End If
            If DdlSexo.SelectedValue = "" Then
                lblerror.Text = "El sexo es requerido"
                lblerror.Visible = True
                Return
            End If
            If ddlNacionalidad.SelectedValue = "-1" Then
                lblerror.Text = "La nacionalidad es requerida"
                lblerror.Visible = True
                Return
            End If

            Try
                ValidarImagen()
            Catch ex As Exception
                lblerror.Text = ex.Message
                lblerror.Visible = True
                lblmensaje.Visible = False
                Return
            End Try

            Dim repSolicitud As New Repositories.SolicitudNSSRepository()
            Dim solProcesada = repSolicitud.GetSolicitudProcesada(NumeroDocumento, ddlTipo.SelectedValue)

            If solProcesada IsNot Nothing Then
                lblerror.Text = "Este número de documento ya tiene un NSS asignado, su NSS es " + solProcesada.IdNSSAsignado.ToString()
                lblerror.Visible = True
                Return
            End If

            'Llenamos el viewmodels con los valores del formulario
            vmSolicitudNSSExtranjero.NoDocumento = NumeroDocumento.ToUpper()
            vmSolicitudNSSExtranjero.Nombres = txtNombres.Text
            vmSolicitudNSSExtranjero.PrimerApellido = txtPrimerApellido.Text
            vmSolicitudNSSExtranjero.SegundoApellido = txtSegundoApellido.Text
            vmSolicitudNSSExtranjero.Sexo = DdlSexo.SelectedValue
            vmSolicitudNSSExtranjero.FechaNacimiento = txtFechaNac.Text
            vmSolicitudNSSExtranjero.TipoDocumento = ddlTipo.SelectedValue
            vmSolicitudNSSExtranjero.IdNacionalidad = ddlNacionalidad.SelectedValue
            vmSolicitudNSSExtranjero.Imagen = upLImagenSolicitud.FileBytes

            Dim sol = SolicitudAsignacion.CrearSolicitudExtranjero(vmSolicitudNSSExtranjero, UsrUserName, UsrRegistroPatronal)

            If sol.ToString IsNot Nothing Then
                Me.lblmensaje.Text = "Solicitud generada sastifactoriamente, su número de solicitud es " + sol.ToString
                Me.lblmensaje.Visible = True
                LimpiarCampos()
            End If

            Dim regpat = UsrRegistroPatronal
            Dim usuario = UsrUserName
            Dim mensaje = "Solicitud de asignación de NSS para" & " " & vmSolicitudNSSExtranjero.Nombres.ToUpper() & " " & vmSolicitudNSSExtranjero.PrimerApellido.ToUpper() & " " & vmSolicitudNSSExtranjero.SegundoApellido.ToUpper() & "." & " " + "Solicitud número " & sol.ToString()
            Dim asunto = "Solicitud de Asignación de NSS"

            Dim inbox = Utilitarios.Utils.InsertarMensajeInbox(regpat, mensaje, asunto, usuario)
            ddlTipo.Focus()

        Catch ex As Exception
            lblerror.Text = "Error generando la solicitud."
            lblerror.Visible = True
            Exepciones.Log.LogToDB("Error generando la solicitud. " + ex.ToString())
        End Try
    End Sub
    Private Sub ddlTipoDocumento_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlTipo.SelectedIndexChanged

        Dim tipoDocumento As TipoDocumento = New TipoDocumento()
        Dim repTipoDocumento As SuirPlusEF.Repositories.TipoDocumentoRepository = New Repositories.TipoDocumentoRepository()
        lblerror.Text = String.Empty
        lblmensaje.Text = String.Empty

        If ddlTipo.SelectedValue = "I" Then
            tipoDocumento = repTipoDocumento.GetByIdTipoDocumento(ddlTipo.SelectedValue.ToString())
            txtNoDocumento.Text = String.Empty
            txtNroDocSinMask.Text = String.Empty
            maskNroDocumento.Mask = tipoDocumento.Mascara
            txtNoDocumento.Visible = True
            txtNroDocSinMask.Visible = False
            maskNroDocumento.ClearMaskOnLostFocus = False
            txtNoDocumento.Focus()
        Else
            txtNoDocumento.Visible = False
            txtNroDocSinMask.Visible = True
            txtNoDocumento.Text = String.Empty
            txtNroDocSinMask.Text = String.Empty
            txtNroDocSinMask.Focus()
        End If

    End Sub

    Private Function Fechafutura(ByVal FechaNacimiento As DateTime) As Boolean
        If FechaNacimiento > DateTime.Now Then
            Return True
        End If
        Return False
    End Function
    Private Function RangoMinimoFecha(ByVal FechaNacimiento As DateTime) As Boolean
        Dim FechaInicio As DateTime = "1900/01/01"
        If FechaNacimiento < FechaInicio Then
            Return True
        End If
        Return False
    End Function

    Private Sub btnCertificacion_Click(sender As Object, e As EventArgs) Handles btnCertificacion.Click

        Dim repDetalleSol As New Repositories.DetalleSolicitudesRepository()
        Dim repMaestro As New Repositories.MaestroExtranjerosRepository()
        Dim repSolicitud As New Repositories.SolicitudNSSRepository()
        Dim DetalleSol As New DetalleSolicitudes()

        Dim nss = lblNss.Text
        Dim solicitudCreada = repSolicitud.GetSolicitudNss(nss)
        Dim sol = solicitudCreada.IdSolicitud

        Dim tipoCert = Empresas.Certificaciones.setTipoCertificacion(88)
        Dim myCert = New Empresas.Certificaciones(tipoCert)

        myCert.NSS = nss
        myCert.Crear(UsrUserName)

        If myCert.NoCertificacion IsNot Nothing Then
            DetalleSol = repDetalleSol.GetBySolicitud(sol)
            DetalleSol.IdCertificacion = myCert.Numero
            DetalleSol.UltimaFechaActualizacion = DateTime.Now
            DetalleSol.UltimoUsuarioActualiza = UsrUserName
            repDetalleSol.Update(DetalleSol)
        End If
        divGenerarCert.Visible = False
        divVerCert.Visible = True
        ibImagenCert_Click(Nothing, Nothing)
    End Sub

    Private Sub ibImagenCert_Click(sender As Object, e As ImageClickEventArgs) Handles ibImagenCert.Click

        Dim repDetalleSol As New Repositories.DetalleSolicitudesRepository()
        Dim repMaestro As New Repositories.MaestroExtranjerosRepository()
        Dim repSolicitud As New Repositories.SolicitudNSSRepository()
        Dim DetalleSol As New DetalleSolicitudes()

        Dim solicitudCreada = repSolicitud.GetSolicitudNss(lblNss.Text)
        Dim sol = solicitudCreada.IdSolicitud
        Dim id_certificacion As String = String.Empty

        DetalleSol = repDetalleSol.GetBySolicitud(sol)
        id_certificacion = DetalleSol.IdCertificacion


        Dim b, c, d As String
        b = String.Empty
        c = String.Empty
        d = String.Empty

        Dim random = New Random(DateTime.Now.Millisecond)
        Dim rand As Random = New Random()
        Dim letras = Enumerable.Range(0, 20).Select(Function(i) (Chr(Asc("A") + rand.Next(0, 26)))).OrderBy(Function(x) random.Next()).ToList()
        Dim letras2 = Enumerable.Range(20, 40).Select(Function(i) (Chr(Asc("A") + rand.Next(0, 26)))).OrderBy(Function(x) random.Next()).ToList()
        Dim letras3 = Enumerable.Range(40, 60).Select(Function(i) (Chr(Asc("A") + rand.Next(0, 26)))).OrderBy(Function(x) random.Next()).ToList()

        For Each l As String In letras
            b = b & l
        Next

        For Each l As String In letras2
            c = c & l
        Next

        For Each l As String In letras3
            d = d & l
        Next

        Dim Resultado = Convert.ToBase64String(Encoding.ASCII.GetBytes(id_certificacion.ToString().ToCharArray()))
        Dim script As String = "<script Language=JavaScript>" + "window.open('../sys/ImpCertificacion.aspx?A=" + Resultado + "&b=" + b + "&C=" + c + "&D=" + d + "')</script>"
        Me.ClientScript.RegisterStartupScript(Me.GetType, "popup", script)
    End Sub
End Class