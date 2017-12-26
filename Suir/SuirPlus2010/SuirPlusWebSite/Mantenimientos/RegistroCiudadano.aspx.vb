
Partial Class Mantenimientos_RegistroCiudadano
    Inherits BasePage
    Protected imgStream As System.IO.Stream
    Protected imgLength As Integer

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            CargarTipoSangre()
            CargarProvincias()
            CargarMunicipios()
            CargarNacionalidad()
        End If
    End Sub
    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click
        Validar()
    End Sub


    Protected Sub Validar()

        Dim valor As Boolean = False
        Try

            If Not Me.txtcedula.Text = String.Empty Then

                'validamos el formato de fecha de nacimiento

                Dim dias As String = Me.txtFechaNac.Text.Substring(0, 2)
                Dim mes As String = Me.txtFechaNac.Text.Substring(3, 2)

                If (dias > 31) Or (dias < 0) Then
                    Me.lblMsg.Visible = True
                    Me.lblMsg.Text = "Formato fecha de nacimiento inválido, el dia no puede ser mayor a 31"
                    Exit Sub
                Else
                    Me.lblMsg.Visible = False
                End If

                If (mes > 12) Or (mes < 0) Then
                    Me.lblMsg.Visible = True
                    Me.lblMsg.Text = "Formato fecha de nacimiento inválido, el mes no puede ser mayor a 12"
                    Exit Sub
                Else
                    Me.lblMsg.Visible = False
                End If


                If Me.ddlEstadoCivil.SelectedValue <> "-1" Then
                    Me.lblEstadoCivil.Visible = False
                Else
                    Me.lblEstadoCivil.Visible = True
                    Exit Sub
                End If

                If Me.ddlSexo.SelectedValue <> "-1" Then
                    Me.lblSexo.Visible = False
                Else
                    Me.lblSexo.Visible = True
                    Exit Sub
                End If

                valor = SuirPlus.Utilitarios.Utils.validaDigitoVerificadorCedula(Me.txtcedula.Text)

                If valor = True Then
                    Try
                        RegistrarCiudadano()
                    Catch ex As Exception
                        Me.lblMsg.Visible = True
                        Me.lblMsg.Text = ex.Message
                        SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                        Exit Sub
                    End Try

                    Me.lblMsg.Visible = True
                    Me.lblMsg.Text = "Registro creado satisfactoriamente"
                    Me.pnlGeneral.Visible = False
                    Me.btnVolver.Visible = True
                Else
                    Me.lblMsg.Visible = True
                    Me.lblMsg.Text = "Cédula Inválida"

                End If

            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub CargarProvincias()

        Me.ddlProvincia.DataSource = SuirPlus.Utilitarios.TSS.getProvincias()
        Me.ddlProvincia.DataTextField = "PROVINCIA_DES"
        Me.ddlProvincia.DataValueField = "Id_provincia"
        Me.ddlProvincia.DataBind()
        Me.ddlProvincia.Items.Add(New WebControls.ListItem("<--Seleccione-->", ""))
        Me.ddlProvincia.SelectedValue = ""
    End Sub

    Protected Sub CargarMunicipios()

        Me.ddlMunicipio.DataSource = SuirPlus.Utilitarios.TSS.get_Municipios()
        Me.ddlMunicipio.DataTextField = "MUNICIPIO_DES"
        Me.ddlMunicipio.DataValueField = "ID_MUNICIPIO"
        Me.ddlMunicipio.DataBind()
        Me.ddlMunicipio.Items.Add(New WebControls.ListItem("<--Seleccione-->", ""))
        Me.ddlMunicipio.SelectedValue = ""
    End Sub

    Protected Sub CargarTipoSangre()

        Me.ddlTipoSangre.DataSource = SuirPlus.Utilitarios.Utils.getTipoSangre()
        Me.ddlTipoSangre.DataTextField = "TIPO_SANGRE_DES"
        Me.ddlTipoSangre.DataValueField = "ID_TIPO_SANGRE"
        Me.ddlTipoSangre.DataBind()
        Me.ddlTipoSangre.Items.Add(New WebControls.ListItem("<--Seleccione-->", ""))
        Me.ddlTipoSangre.SelectedValue = ""
    End Sub

    Protected Sub CargarNacionalidad()

        Me.ddlNacionalidad.DataSource = SuirPlus.Utilitarios.Utils.getNacionalidad()
        Me.ddlNacionalidad.DataTextField = "NACIONALIDAD_DES"
        Me.ddlNacionalidad.DataValueField = "ID_NACIONALIDAD"
        Me.ddlNacionalidad.DataBind()
        Me.ddlNacionalidad.Items.Add(New WebControls.ListItem("<--Seleccione-->", ""))
        Me.ddlNacionalidad.SelectedValue = ""

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.Response.Redirect("RegistroCiudadano.aspx")
    End Sub

    Protected Sub RegistrarCiudadano()
        'Try
        'validamos la imagen antes de insertarla
        ValidarImagen()

        'insertar la imagen del acta
        Dim imgContent(imgLength) As System.Byte
        imgStream.Read(imgContent, 0, imgLength)


        'imgContent

        SuirPlus.Mantenimientos.Mantenimientos.RegistroCiudadano(Me.txtNombres.Text, Me.txtPrimerApellido.Text, Me.txtSegundoApellido.Text, Me.ddlEstadoCivil.SelectedValue, _
                                Me.txtFechaNac.Text, Me.txtcedula.Text, Me.ddlSexo.SelectedValue, Me.ddlProvincia.SelectedValue, _
                                Me.ddlTipoSangre.SelectedValue, Me.ddlNacionalidad.SelectedValue, Me.txtPadre.Text, Me.txtMadre.Text, Me.ddlMunicipio.SelectedValue, _
                                Me.txtOficialia.Text, Me.txtLibro.Text, Me.txtfolio.Text, Me.txtNroActa.Text, Me.txtAnoActa.Text, Me.txtCedulaAnt.Text, Me.UsrUserName, imgContent)


        'Catch ex As Exception
        '    Me.lblMsg.Visible = True
        '    Me.lblMsg.Text = ex.Message
        '    SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        'End Try
    End Sub

    Protected Sub ValidarImagen()

        'validacion imagen cargando(TIF o JPG )
        Try
            If Me.upLImagenCiudadano.HasFile() Then
                imgStream = upLImagenCiudadano.PostedFile.InputStream
                imgLength = upLImagenCiudadano.PostedFile.ContentLength
                Dim imgContentType As String = upLImagenCiudadano.PostedFile.ContentType
                ' Dim imgFileName As String = upLImagenCiudadano.PostedFile.FileName

                ''validamos los tipos de archivos que deseamos aceptar
                If (imgContentType = "image/jpeg") Or (imgContentType = "image/pjpeg") Or (imgContentType = "image/tif") Or (imgContentType = "image/tiff") Then

                    Dim imgSize As String = (imgLength / 1024)
                    If imgSize > 500 Then
                        Throw New Exception("Esta imagen no debe superar los 500KB")
                        Exit Sub
                    End If
                Else
                    Throw New Exception("La imagen debe ser de tipo TIF o JPG")
                    Exit Sub
                End If

            End If
            ' Dim imgContent(imgLength) As System.Byte
            'imgStream.Read(imgContent, 0, imgLength)

            'Response.ContentType = "image/tiff"
            ' Response.BinaryWrite(imgContent)

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVolver.Click
        Me.Response.Redirect("RegistroCiudadano.aspx")
        Me.btnVolver.Visible = False

    End Sub
End Class
