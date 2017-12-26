Imports System.IO
Imports System.Data
Imports SuirPlus
Partial Class RegistroActaNacimiento
    Inherits BasePage
    Protected imgStream As System.IO.Stream
    Protected imgLength As Integer
    Private height As Integer
    Private width As Integer
    Private thumbnail As Boolean
    Dim ImagenMod() As Byte

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            CargarMunicipios()
        End If
    End Sub

    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click
        If Me.upnlNSSDuplicado.Visible = True Then
            RegistrarActa()
        Else
            Validar()
        End If
    End Sub

    Protected Sub CargarInfo()

        Try
            SuirPlus.Mantenimientos.Mantenimientos.GetInfoNssDup(Me.txtNoIdentidad.Text, Me.txtNombres.Text, Me.txtPrimerApellido.Text, Me.txtFechaNac.Text, ddlSexo.SelectedValue, ddlMunicipio.SelectedValue, ddlOficilia.SelectedValue,
                                                                 Me.txtLibro.Text, Me.txtfolio.Text, Me.txtNroActa.Text, Me.txtAnoActa.Text)
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub ddlNSSDuplicados_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlNSSDuplicados.SelectedIndexChanged
        Try
            CargarInfoNss(CInt(ddlNSSDuplicados.SelectedValue.ToString()))
        Catch ex As Exception
            Me.upnlNSSDuplicado.Visible = False
        End Try
        
    End Sub

    Private Sub CargarInfoNss(ByRef idNss As Integer)
        Try
            Dim dt As New DataTable
            dt = Utilitarios.TSS.getCiudadanoNSS(idNss)

            If dt.Rows.Count = 0 Then
                Throw New Exception("Este ciudadano no existe en la base de datos TSS.")
            Else

                lblNombresNSS.Text = dt.Rows(0)("nombres")
                lblPrimerApellidoNSS.Text = dt.Rows(0)("primer_apellido").ToString()
                lblSegundoApellidoNSS.Text = dt.Rows(0)("segundo_apellido").ToString()
                lblFechaNacNSS.Text = CDate(dt.Rows(0)("fecha_nacimiento").ToString())
                lblSexoNSS.Text = dt.Rows(0)("sexo_des").ToString()
                lblNacionalidadNSS.Text = dt.Rows(0)("nacionalidad_des").ToString()
                lblPadreNSS.Text = dt.Rows(0)("nombre_padre").ToString()
                lblMadreNSS.Text = dt.Rows(0)("nombre_madre").ToString()
                lblMunicipioNSS.Text = dt.Rows(0)("id_municipio").ToString()
                lblMunicipioNSSDes.Text = dt.Rows(0)("municipio_des").ToString()
                lblAnoNSS.Text = dt.Rows(0)("ano_acta").ToString()
                lblNroActaNSS.Text = dt.Rows(0)("numero_acta").ToString()
                lblFolioNSS.Text = dt.Rows(0)("folio_acta").ToString()
                lblLibroNSS.Text = dt.Rows(0)("libro_acta").ToString()
                lblOficialiaNSS.Text = dt.Rows(0)("oficialia_acta").ToString()

            End If

        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try
    End Sub

    Protected Sub Validar()
        lblMsg.Text = String.Empty

        Dim valor As Boolean = True
        Dim dt As New DataTable


        Try

            If Not String.IsNullOrEmpty(txtAnoActa.Text) Then
                If CInt(txtAnoActa.Text) < CDate(txtFechaNac.Text).Year Then
                    Me.lblMsg.Visible = True
                    Me.lblMsg.Text += "El Año del Acta No Debe Ser Menor Que la Fecha de Nacimiento!! <br>"
                    valor = False
                End If
            End If


            If Not String.IsNullOrEmpty(txtFechaNac.Text) Then
                If CDate(txtFechaNac.Text) > Now Then
                    Me.lblMsg.Visible = True
                    Me.lblMsg.Text += "El Año del Acta No Debe Ser Mayor a la Fecha Actual!! <br>"
                    valor = False
                End If
            End If


            If ddlMunicipio.SelectedValue = "" Then
                Me.lblMsg.Visible = True
                Me.lblMsg.Text += "Debe Seleccionar Un Municipio!! <br>"
                valor = False
            End If

            If ddlOficilia.SelectedValue = "" Then
                Me.lblMsg.Visible = True
                Me.lblMsg.Text += "Debe Seleccionar Una Oficilia!! <br>"
                valor = False
            End If

            If Not String.IsNullOrEmpty(txtNombres.Text) And Not String.IsNullOrEmpty(txtPrimerApellido.Text) And Not String.IsNullOrEmpty(txtSegundoApellido.Text) And ValidarFecha() = True Then
                If Validar_ExisteCiudadano() Then
                    valor = False
                End If
            End If
            If valor = False Then
                Exit Sub
            End If


            dt = SuirPlus.Mantenimientos.Mantenimientos.GetInfoNssDup(Me.txtNoIdentidad.Text, Me.txtNombres.Text, Me.txtPrimerApellido.Text, Me.txtFechaNac.Text, ddlSexo.SelectedValue, ddlMunicipio.SelectedValue, ddlOficilia.SelectedValue,
                                                                    Me.txtLibro.Text, Me.txtfolio.Text, Me.txtNroActa.Text, Me.txtAnoActa.Text)

            If dt.Rows.Count > 0 Then
                Me.upnlNSSDuplicado.Visible = True

                'llenamos combo de nss encontrados con el mismo criterio
                ddlNSSDuplicados.DataSource = dt
                ddlNSSDuplicados.DataTextField = "id_nss"
                ddlNSSDuplicados.DataValueField = "id_nss"
                ddlNSSDuplicados.DataBind()

                'llenar data nss duplicado default
                CargarInfoNss(Convert.ToInt32(dt.Rows(0)("id_nss")))

            Else
                RegistrarActa()

            End If


        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub LimpiarControles()
        Me.txtNombres.Text = String.Empty
        Me.txtPrimerApellido.Text = String.Empty
        Me.txtSegundoApellido.Text = String.Empty
        Me.txtFechaNac.Text = String.Empty
        Me.txtNoIdentidad.Text = String.Empty
        UCCiudadanoPadre.iniForm()
        UCCiudadanoMadre.iniForm()
        Me.ddlMunicipio.SelectedValue = ""
        Me.ddlOficilia.SelectedValue = ""
        Me.txtLibro.Text = String.Empty
        Me.txtfolio.Text = String.Empty
        Me.txtNroActa.Text = String.Empty
        Me.txtAnoActa.Text = String.Empty
    End Sub

    Protected Sub LimpiarControlesNSS()
        ddlNSSDuplicados.SelectedValue = ""
        lblNombresNSS.Text = String.Empty
        lblPrimerApellidoNSS.Text = String.Empty
        lblSegundoApellidoNSS.Text = String.Empty
        lblFechaNacNSS.Text = String.Empty
        lblSexoNSS.Text = String.Empty
        lblNacionalidadNSS.Text = String.Empty
        lblPadreNSS.Text = String.Empty
        lblMadreNSS.Text = String.Empty
        lblMunicipioNSS.Text = String.Empty
        lblMunicipioNSSDes.Text = String.Empty
        lblAnoNSS.Text = String.Empty
        lblNroActaNSS.Text = String.Empty
        lblFolioNSS.Text = String.Empty
        lblLibroNSS.Text = String.Empty
        lblOficialiaNSS.Text = String.Empty

    End Sub

    

    Protected Sub CargarMunicipios()
        Me.ddlMunicipio.DataSource = SuirPlus.Utilitarios.TSS.get_Municipios()
        Me.ddlMunicipio.DataTextField = "MUNICIPIO_DES"
        Me.ddlMunicipio.DataValueField = "ID_MUNICIPIO"
        Me.ddlMunicipio.DataBind()
        Me.ddlMunicipio.Items.Add(New WebControls.ListItem("<--Seleccione-->", ""))
        Me.ddlMunicipio.SelectedValue = ""
    End Sub

    Protected Sub CargarOficilias()
        Me.ddlOficilia.DataSource = SuirPlus.Utilitarios.TSS.get_Oficialis_Municipios(ddlMunicipio.SelectedValue)
        Me.ddlOficilia.DataTextField = "OFICIALIA_DES"
        Me.ddlOficilia.DataValueField = "ID_OFICIALIA"
        Me.ddlOficilia.DataBind()
        Me.ddlOficilia.Items.Add(New WebControls.ListItem("<--Seleccione-->", ""))
        Me.ddlOficilia.SelectedValue = ""
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.Response.Redirect("RegistroActaNacimiento.aspx")
    End Sub

    Protected Sub RegistrarActa()
        Try
            'Cargamos los NSS duplicados en caso de que existan
            'CargarInfo()

            'validamos la imagen antes de insertarla
            ValidarImagen()

            SuirPlus.Mantenimientos.Mantenimientos.RegistroActaNacimiento(Me.txtNombres.Text, Me.txtPrimerApellido.Text, Me.txtSegundoApellido.Text, _
                                    Me.txtFechaNac.Text, Me.txtNoIdentidad.Text, ddlSexo.SelectedValue, UCCiudadanoPadre.getNombres & " " & UCCiudadanoPadre.getApellidos, UCCiudadanoMadre.getNombres & " " & UCCiudadanoMadre.getApellidos, _
                                    Me.ddlMunicipio.SelectedValue, Me.ddlOficilia.SelectedValue, Me.txtLibro.Text, Me.txtfolio.Text, Me.txtNroActa.Text, Me.txtAnoActa.Text, Me.UsrUserName, ImagenMod)

            LimpiarControles()
            LimpiarControlesNSS()
            Me.upnlNSSDuplicado.Visible = False


            Me.lblMsg.Visible = True
            Me.lblMsg.Text = "Registro insertado correctactamente!!"
        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub ValidarImagen()
        'validacion imagen cargando(TIF o JPG )
        Try
            If Me.upLImagenCiudadano.HasFile() Then
                imgStream = upLImagenCiudadano.PostedFile.InputStream
                imgLength = upLImagenCiudadano.PostedFile.ContentLength
                Dim imgContentType As String = upLImagenCiudadano.PostedFile.ContentType
                'Dim imgFileName As String = upLImagenCiudadano.PostedFile.FileName

                'validamos los tipos de archivos que deseamos aceptar

                If SuirPlus.Utilitarios.Utils.ImagenValida(imgContentType) Then

                    Dim imgSize As String = (imgLength / 1024)

                    If (imgSize > 600) And SuirPlus.Utilitarios.Utils.ImagenValidaJPG(imgContentType) Then
                        'Throw New Exception("Esta imagen no debe superar los 600KB")
                        RehacerImagen()
                    Else
                        Dim imageContent(imgLength) As Byte
                        imgStream.Read(imageContent, 0, imgLength)
                        ImagenMod = imageContent
                    End If
                Else
                    Throw New Exception("La imagen debe ser TIFF, JPG, JPEG o PDF")
                End If

            End If
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try
    End Sub

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

    Public Function ThumbnailCallBack() As Boolean
        Return False
    End Function

    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVolver.Click
        Me.Response.Redirect("RegistroActaNacimiento.aspx")
        Me.btnVolver.Visible = False
    End Sub



    Private Function Validar_ExisteCiudadano() As Boolean

        If SuirPlus.Mantenimientos.Mantenimientos.Validar_ExisteCiudadano(txtNombres.Text, txtPrimerApellido.Text, txtSegundoApellido.Text, txtFechaNac.Text) = True Then
            lblMsg.Text = "CIUDADANO YA EXISTE"
            Me.lblMsg.Visible = True
            Return True
        Else
            lblMsg.Text = String.Empty
            Me.lblMsg.Visible = False
            Return False
        End If

    End Function

    Private Function ValidarFecha() As Boolean
        If Not String.IsNullOrEmpty(txtFechaNac.Text) Then
            Try
                Dim validate As Date = Date.Parse(txtFechaNac.Text)
                Return True
            Catch ex As Exception
                Return False
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If
        Return False
    End Function

    Protected Sub ddlMunicipio_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        CargarOficilias()
    End Sub


    Protected Sub btnValidar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnValidar.Click
        If txtNoIdentidad.Text.Length = 11 Then

            If SuirPlus.Utilitarios.TSS.existeCiudadano("U", txtNoIdentidad.Text) = True Then
                lblMsg.Text = "Ya Existe Un Ciudadano Con Este Número De Identidad"
                Me.lblMsg.Visible = True
            Else
                lblMsg.Text = "Número De Identidad Disponible"
                Me.lblMsg.Visible = True
            End If
        Else
            lblMsg.Text = "Número De Identidad Inválido"
            Me.lblMsg.Visible = True
            Exit Sub
        End If
    End Sub
End Class
