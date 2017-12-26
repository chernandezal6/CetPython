Imports System.IO
Imports System.Data
Imports SuirPlus.Mantenimientos.Mantenimientos
Imports SuirPlus.Utilitarios.TSS
Imports SuirPlus.Ars.Consultas
Partial Class Mantenimientos_RegistroMenorExtranjero
    Inherits BasePage
    Protected imgStream As System.IO.Stream
    Protected imgLength As Integer
    Private height As Integer
    Private width As Integer
    Private thumbnail As Boolean
    Dim ImagenMod() As Byte

#Region "Metodos"
    Private Function ValidarFecha() As Boolean
        If Not String.IsNullOrEmpty(txtFechaNac.Text) Then
            Try
                Dim validate As Date = Date.Parse(txtFechaNac.Text)
                Return True
            Catch ex As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                lblMsg.Text = "Fecha de nacimiento incorrecta!"
                Return False

            End Try
        End If
        Return False
    End Function
    Private Sub Validar_ExisteCiudadano()

        If Not String.IsNullOrEmpty(txtNombres.Text) And Not String.IsNullOrEmpty(txtPrimerApellido.Text) And ValidarFecha() = True Then

            Dim menores As DataTable = Nothing
            Validar_ExisteMenorExtranjero(menores, txtNombres.Text.Trim().ToUpper(), txtPrimerApellido.Text.Trim().ToUpper(), txtSegundoApellido.Text.Trim().ToUpper())

            If Not IsNothing(menores) Then

                If menores.Rows.Count > 0 Then
                    gvMenoresExtranjeros.DataSource = menores
                    gvMenoresExtranjeros.DataBind()

                    tblExtranjerosNombreComun.Visible = True
                    btnAceptar.Enabled = False
                    tblDatos.Visible = False
                Else
                    lblMsg.Text = String.Empty
                    Validar()
                End If
            Else
                lblMsg.Text = String.Empty
                Validar()
            End If

        End If

    End Sub
    Protected Function ValidarImagen() As Boolean
        'validacion imagen cargando(TIF o JPG )
        Try
            If Me.upLImagenCiudadano.HasFile() Then
                imgStream = upLImagenCiudadano.PostedFile.InputStream
                imgLength = upLImagenCiudadano.PostedFile.ContentLength
                Dim imgContentType As String = upLImagenCiudadano.PostedFile.ContentType
                'Dim imgFileName As String = upLImagenCiudadano.PostedFile.FileName

                'validamos los tipos de archivos que deseamos aceptar
                If (imgContentType = "image/jpeg") Or (imgContentType = "image/pjpeg") Or (imgContentType = "image/jpg") Or (imgContentType = "image/tif") Or (imgContentType = "image/tiff") Or (imgContentType = "application/pdf") Then

                    Dim imgSize As String = (imgLength / 1024)

                    If (imgSize > 600) And ((imgContentType = "image/jpeg") Or (imgContentType = "image/jpg")) Then
                        'Throw New Exception("Esta imagen no debe superar los 600KB")
                        RehacerImagen()
                    Else
                        Dim imageContent(imgLength) As Byte
                        imgStream.Read(imageContent, 0, imgLength)
                        ImagenMod = imageContent
                    End If

                    Return True
                Else
                    Throw New Exception("La imagen debe ser de tipo TIFF, JPG o PDF")
                    Return False
                End If
            Else
                Return False
            End If
        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Return False
        End Try
    End Function
    Public Function ThumbnailCallBack() As Boolean
        Return False
    End Function
    Private Sub RehacerImagen()
        'Lee La primera imagen
        Dim intImageSize As Int64 = Me.upLImagenCiudadano.PostedFile.ContentLength
        Dim ImageStream As Stream = Me.upLImagenCiudadano.PostedFile.InputStream
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
    Protected Sub Validar()
        lblMsg.Text = String.Empty

        Dim valor As Boolean = True
        Try

            If Not String.IsNullOrEmpty(txtFechaNac.Text) Then
                If CDate(txtFechaNac.Text) > Now Then
                    Me.lblMsg.Text = "El Año del Acta No Debe Ser Mayor a la Fecha Actual!"
                    valor = False
                End If
            End If

            If valor = False Then
                Exit Sub
            End If

            RegistrarActa()

        Catch ex As Exception
            Me.lblMsg.Text = ex.ToString
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub
    Protected Sub RegistrarActa()
        Try
            'validamos la imagen antes de insertarla
            If ValidarImagen() Then
                RegistroMenorExtranjero(Me.txtNombres.Text.ToUpper, Me.txtPrimerApellido.Text.ToUpper, Me.txtSegundoApellido.Text.ToUpper, _
                                        Me.txtFechaNac.Text, ddlSexo.SelectedValue, ddlNacionalidad.SelectedValue, UCCiudadanoMadre.getNSS, _
                                        Me.UsrUserName, ImagenMod)
                LimpiarControles()

                Me.lblMsg.Visible = True
                Me.lblMsg1.Visible = True
                btnAceptar.Enabled = True

            End If

        Catch ex As Exception
            Me.lblMsg1.Visible = False
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
            tblDatos.Visible = True
            tblExtranjerosNombreComun.Visible = False
            btnAceptar.Enabled = True
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub
    Protected Sub LimpiarControles()
        Me.txtNombres.Text = String.Empty
        Me.txtPrimerApellido.Text = String.Empty
        Me.txtSegundoApellido.Text = String.Empty
        Me.txtFechaNac.Text = String.Empty
        UCCiudadanoMadre.iniForm()
        btnAceptar.Enabled = True
        Me.lblMsg1.Visible = False
        tblDatos.Visible = True
        tblExtranjerosNombreComun.Visible = False

    End Sub
#End Region

#Region "Eventos"
    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        lblMsg.Text = String.Empty
        lblMsg1.Visible = False
        Dim years As Int32


        'Menor de 18 anos
        Try
            years = Year(Today) - Year(CType(txtFechaNac.Text, Date))
        Catch ex As Exception
            lblMsg.Text = "Formato de fecha de nacimiento inválido"
            Exit Sub
        End Try

        If years > 18 Then
            lblMsg.Text = "No debe ser mayor de 18 años "
            Exit Sub
        Else
            If Not UCCiudadanoMadre.getNombres.Equals(String.Empty) Then

                Validar_ExisteCiudadano()

            Else
                lblMsg.Text = "Titular inválido, por favor verificar y presionar Buscar"
            End If
        End If



    End Sub


    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        LimpiarControles()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Try
                'Cargar nacionalidades
                ddlNacionalidad.DataSource = get_Nacionalidades()
                ddlNacionalidad.DataValueField = "ID_NACIONALIDAD"
                ddlNacionalidad.DataTextField = "NACIONALIDAD_DES"
                ddlNacionalidad.DataBind()

                'Cargar ARSs
                'ddlARS.DataSource = getARS()
                'ddlARS.DataValueField = "ID_ARS"
                'ddlARS.DataTextField = "ARS_DES"
                'ddlARS.DataBind()

            Catch
            End Try

        End If


    End Sub
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        'Remover el tipo de documento "Pasaporte" del listado de tipos de documento del control
        Try
            Dim ddlDoc As DropDownList = UCCiudadanoMadre.FindControl("ddRepTipoDoc")
            ddlDoc.Items.Remove(ddlDoc.Items.Item(1))
        Catch
        End Try
    End Sub
    Protected Sub btnNo_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNo.Click
        tblExtranjerosNombreComun.Visible = False
        btnAceptar.Enabled = True
        tblDatos.Visible = True
        LimpiarControles()
    End Sub
#End Region

End Class
