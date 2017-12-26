Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios
Imports System.Data
Imports System.IO
Partial Class Empleador_empRegInicial
    Inherits BasePage

    Dim ImagenMod() As Byte
    Protected imgStream As System.IO.Stream
    Protected imgLength As Integer
    Private height As Integer
    Private width As Integer
    Private thumbnail As Boolean

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        If Not Page.IsPostBack Then
            iniForm()
            cargaDropDowns()
        End If
        TrTipo.Visible = False
        TrParque.Visible = False
        Me.ucRepresentante.ShowPasaporte = False
    End Sub

    Protected Sub cargaDropDowns()
        Try
            'Cargando DropDown de Sectores Economicos
            Me.ddlSectorEconomico.DataSource = SuirPlus.Utilitarios.TSS.getSectoresEconomicos()
            Me.ddlSectorEconomico.DataValueField = "ID_SECTOR_ECONOMICO"
            Me.ddlSectorEconomico.DataTextField = "SECTOR_ECONOMICO_DES"

            'Cargando DropDown de Provincias
            Me.ddProvincia.DataSource = SuirPlus.Utilitarios.TSS.getProvincias()
            Me.ddProvincia.DataValueField = "ID_PROVINCIA"
            Me.ddProvincia.DataTextField = "PROVINCIA_DES"

            'cargando sectores salariales
            ddlSectorSalarial.DataSource = Mantenimientos.SectoresSalariales.getSectoresSalariales()
            ddlSectorSalarial.DataTextField = "descripcion"
            ddlSectorSalarial.DataValueField = "id"

            'cargando actividad economica
            ddlActividad.DataSource = SuirPlus.MDT.General.listarActividad()
            ddlActividad.DataTextField = "descripcion"
            ddlActividad.DataValueField = "id"

            'cargamos los parques zona franca
            ddlParque.DataSource = SuirPlus.MDT.General.listarParqueZonaFranca
            ddlParque.DataTextField = "descripcion"
            ddlParque.DataValueField = "id"

            'Cargamos los valores del ddlTipoZona
            ddlTipoZonaFranca.Items.Insert(0, "Comercial")
            ddlTipoZonaFranca.Items.Insert(1, "Normal")



            Me.DataBind()

            'asignamos default value en los dropdowns

            ddlSectorSalarial.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
            ddlSectorSalarial.SelectedIndex = 0

            Me.ddProvincia.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
            Me.ddProvincia.SelectedIndex = 0

            Me.ddlSectorEconomico.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
            Me.ddlSectorEconomico.SelectedIndex = 0

            Me.ddlActividad.Items.Insert(0, New ListItem("<-- Seleccione -->", ""))
            Me.ddlActividad.SelectedIndex = 0

            Me.ddlParque.Items.Insert(0, New ListItem("<-- Seleccione -->", ""))
            Me.ddlParque.SelectedIndex = 0

            Me.ddlTipoZonaFranca.Items.Insert(0, New ListItem("<-- Seleccione -->", ""))
            Me.ddlTipoZonaFranca.SelectedIndex = 0



        Catch ex As Exception
            Me.lblFormError.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub iniForm()

        Me.ddProvincia.SelectedIndex = 0
        Me.ddMunicipio.Items.Clear()
        Me.ddMunicipio.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
        Me.ddMunicipio.SelectedIndex = 0

        Me.txtRNCCedula.ReadOnly = False
        Me.btnBuscar.Text = "Buscar empleador"

        'Campos del empleador
        Me.txtRNCCedula.Text = ""
        Me.txtRazonSocial.Text = ""
        Me.txtNombreComercial.Text = ""
        Me.ddlTipoEmpresa.SelectedIndex = 0
        Me.ddlSectorEconomico.SelectedIndex = 0
        Me.ddlSectorSalarial.SelectedIndex = 0
        Me.txtCalle.Text = ""
        Me.txtNumero.Text = ""
        Me.txtEdificio.Text = ""
        Me.txtPiso.Text = ""
        Me.txtApartamento.Text = ""
        Me.txtSector.Text = ""
        Me.ddProvincia.SelectedIndex = 0
        Me.Telefono1.phoneNumber = String.Empty
        Me.Telefono2.phoneNumber = String.Empty
        Me.Fax.phoneNumber = String.Empty
        Me.txtRepExt1.Text = String.Empty
        Me.txtRepExt2.Text = String.Empty
        Me.txtEmail.Text = String.Empty

        'Campos del representante
        Me.ucRepresentante.iniForm()
        Me.RepTelefono1.phoneNumber = String.Empty
        Me.txtRepExt1.Text = ""
        Me.RepTelefono2.phoneNumber = String.Empty
        Me.txtRepExt2.Text = String.Empty
        Me.txtRepEmail.Text = String.Empty
        Me.chkboxNotificacionMail.Checked = False
        Me.imgBusqueda.Visible = False

        'Seteando paneles
        Me.pnlFormulario.Visible = True
        Me.pnlResultado.Visible = False
        'Me.upFormulario.Update()

    End Sub

    Private Sub setFormError(ByVal msg As String)
        'Me.lblFormError.Text = Me.lblFormError.Text & "<br>" + msg + "<br>"

        Me.lblFormError.Text = msg + "<br>"
        ' Me.upError.Update()
    End Sub

    Protected Sub ddProvincia_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddProvincia.SelectedIndexChanged
        If Me.ddProvincia.SelectedValue = "-1" Then

            Me.ddMunicipio.Items.Clear()
            Me.ddMunicipio.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
            Me.ddMunicipio.SelectedIndex = 0

        Else

            'Cargando dd de municipios 
            Me.ddMunicipio.DataSource = SuirPlus.Utilitarios.TSS.getMunicipios(Me.ddProvincia.SelectedValue, "")
            Me.ddMunicipio.DataValueField = "ID_MUNICIPIO"
            Me.ddMunicipio.DataTextField = "MUNICIPIO_DES"

            Me.ddMunicipio.DataBind()

            Me.ddMunicipio.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
            Me.ddMunicipio.SelectedIndex = 0

        End If

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        ' Me.iniForm()
        Response.Redirect("empRegInicial.aspx")
    End Sub

    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        'Validando que seleccionen un empleador
        If Not Me.btnBuscar.Text = "Cancelar" Then
            Me.setFormError("Debe seleccionar un empleador.")
            Return
        End If

        'Validando que seleccionen un individuo
        If Me.ucRepresentante.getNSS = "" Then
            Me.setFormError("Debe seleccionar un individuo como representante.")
            Return
        End If

        'Validando el Telefono1 del Representante
        If Me.RepTelefono1.phoneNumber = String.Empty Then
            Me.setFormError("Debe introducir al menos el primer teléfono del representante.")
            Return
        End If

        'Validando el Telefonos1 del Empleador
        If Telefono1.phoneNumber = String.Empty Then
            Me.setFormError("Debe introducir al menos el primer teléfono del empleador.")
            Return
        End If

        'Validando que si quieren notificaciones por email introduzcan su email.
        If Me.chkboxNotificacionMail.Checked And Trim(Me.txtRepEmail.Text) = String.Empty Then
            Me.setFormError("Si desea recibir notificaciones via e-mail, debe introducir su e-mail.")
            Return
        End If

        Try
            Dim EsZonafranca As String
            Dim TipoZonaFranca As String

            If ChkEsZonaFranca.Checked = False Then
                EsZonafranca = "N"
            ElseIf ChkEsZonaFranca.Checked = True Then
                EsZonafranca = "S"
            Else
                EsZonafranca = String.Empty
            End If

            If ddlTipoZonaFranca.SelectedValue = "Comercial" Then
                TipoZonaFranca = "1"
            ElseIf ddlTipoZonaFranca.SelectedValue = "Normal" Then
                TipoZonaFranca = "2"
            Else
                TipoZonaFranca = String.Empty
            End If

            'validamos el contenidos de los documentos recientemente scaneados para atachar en la certificación recietemente creada
            ValidarImagen()
            'ImagenMod
            'Insertando empleador
            Dim strRet As String = SuirPlus.Empresas.Empleador.insertaEmpleador(Integer.Parse(Me.ddlSectorEconomico.SelectedValue), _
                                                                                Me.ddMunicipio.SelectedValue, _
                                                                                Me.txtRNCCedula.Text.Trim, _
                                                                                Me.txtRazonSocial.Text.Trim, _
                                                                                Me.txtNombreComercial.Text.Trim, _
                                                                                Me.txtCalle.Text.Trim, _
                                                                                Me.txtNumero.Text.Trim, _
                                                                                Me.txtEdificio.Text.Trim, _
                                                                                Me.txtPiso.Text.Trim, _
                                                                                Me.txtApartamento.Text.Trim, _
                                                                                Me.txtSector.Text.Trim, _
                                                                                Me.Telefono1.phoneNumber, _
                                                                                Me.txtExt1.Text.Trim, _
                                                                                Me.Telefono2.phoneNumber, _
                                                                                Me.txtExt2.Text.Trim, _
                                                                                Me.Fax.phoneNumber, _
                                                                                Me.txtEmail.Text.Trim, _
                                                                                Me.ddlTipoEmpresa.SelectedValue, _
                                                                                CInt(Me.ddlSectorSalarial.SelectedValue), _
                                                                                ImagenMod, _
                                                                                ddlActividad.SelectedValue, _
                                                                                ddlParque.SelectedValue, _
                                                                                EsZonafranca, _
                                                                                TipoZonaFranca, _
                                                                                Me.UsrUserName)

            '/****** Evaluando resultado de la insersion del empleador ****/

            'Insertado sin problemas
            If Split(strRet, "|")(0) = "0" Then

                'Obteniendo el nuevo codigo de Registro Patronal
                Dim tmpRegistroPatronal As Integer = Integer.Parse(Split(strRet, "|")(1))
                Dim tmpIdNomina As Integer
                Dim pass, retRep As String

                'Insertando Representante
                retRep = SuirPlus.Empresas.Representante.insertaRepresentante(Trim(Me.ucRepresentante.getDocumento), _
                                                                                  tmpRegistroPatronal, _
                                                                                  "A", _
                                                                                  IIf(Me.chkboxNotificacionMail.Checked, "S", "N"), _
                                                                                  Me.RepTelefono1.phoneNumber, _
                                                                                  Me.txtRepExt1.Text.Trim, _
                                                                                  Me.RepTelefono2.phoneNumber, _
                                                                                  Me.txtRepExt2.Text.Trim, _
                                                                                  Me.txtRepEmail.Text.Trim, _
                                                                                  Me.UsrUserName)

                'Verificando posibles errores al crear el representante
                If Split(retRep, "|")(0) = "0" Then

                    pass = Split(retRep, "|")(1)

                    'Insertando Nomina
                    SuirPlus.Empresas.Nomina.insertaNomina(tmpRegistroPatronal, "Nómina Principal", "A", "N", Nothing)

                    'Opteniendo el nuevo numero de nomina
                    tmpIdNomina = Integer.Parse(SuirPlus.Empresas.Nomina.getNomina(tmpRegistroPatronal, -1).Rows(0).Item(1))

                    'Dando acceso a nomina
                    SuirPlus.Empresas.Representante.darAccesoNomina(tmpRegistroPatronal, tmpIdNomina, Integer.Parse(Me.ucRepresentante.getNSS), Me.UsrUserName)

                    'Cargando resumen final
                    Me.setResumen(tmpRegistroPatronal, pass)

                    'Cambiando paneles
                    Me.pnlFormulario.Visible = False
                    Me.pnlResultado.Visible = True

                    Try
                        'cargar # solicitud para este rnc...y posteriormente cerrar automaticamente
                        cargarSolicitud(Me.txtRNCCedula.Text.Trim)
                        Me.lblMensajeSol.Text = String.Empty
                    Catch ex As Exception
                        Me.lblNroSolicitud.Text = 0
                        Me.lblMensajeSol.Text = ex.Message
                        SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                        Exit Sub
                    End Try

                Else

                    Me.setFormError(Split(retRep, "|")(1))
                    Return
                End If

            Else 'Ocurrio un error

                Me.setFormError(Split(strRet, "|")(1))

            End If

        Catch ex As Exception
            Me.lblFormError.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub setResumen(ByVal rnl As Integer, ByVal password As String)

        'Informacion del empleador
        Me.lblFRncCedula.Text = SuirPlus.Utilitarios.Utils.FormatearRNCCedula(txtRNCCedula.Text)
        Me.lblFinRazonSocial.Text = Me.txtRazonSocial.Text
        Me.lblFinNombreComercial.Text = Me.txtNombreComercial.Text

        'Informacion del representante
        Me.lblFinCedula.Text = IIf(Me.ucRepresentante.getTipoDoc = "C", "Cédula ", "Pasaporte ") & IIf(Me.ucRepresentante.getTipoDoc = "C", SuirPlus.Utilitarios.Utils.FormatearCedula(Me.ucRepresentante.getDocumento), Me.ucRepresentante.getDocumento)
        Me.lblFinNSS.Text = SuirPlus.Utilitarios.Utils.FormatearNSS(Me.ucRepresentante.getNSS)
        Me.lblFinNombre.Text = Me.ucRepresentante.getNombres & " " & Me.ucRepresentante.getApellidos
        'Me.lblFinCLASS.Text = password

    End Sub

    Protected Sub btnFinal_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFinal.Click
        Me.iniForm()
    End Sub

    Protected Sub btnImpersonar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnImpersonar.Click

        'TODO:Revisar esta parte
        'Redireccionando a la validacion de usuario para su ingreso automatico
        Response.Redirect("loginTmpRep.aspx?rnc=" & txtRNCCedula.Text.Trim & "&cedula=" & Me.ucRepresentante.getDocumento.Trim & "&class=" & Me.lblFinCLASS.Text)

    End Sub


#Region "Metodos para la carga de imagenes scaneadas"

    Protected Sub ValidarImagen()
        'validacion imagen cargando(TIF o JPG )
        Try

            If Me.flCargarDocumentosEmpresa.HasFile() Then
                imgStream = flCargarDocumentosEmpresa.PostedFile.InputStream
                imgLength = flCargarDocumentosEmpresa.PostedFile.ContentLength
                Dim imgContentType As String = flCargarDocumentosEmpresa.PostedFile.ContentType
                'Dim imgFileName As String = upLImagenCiudadano.PostedFile.FileName

                'validamos los tipos de archivos que deseamos aceptar
                If (imgContentType = "image/tif") Or (imgContentType = "image/tiff") Then

                    Dim imgSize As String = (imgLength / 1024)

                    If imgSize > 600 Then
                        Throw New Exception("El tamaño del archivo de imagen no debe superar los 500 KB, por favor contacte a mesa de ayuda.")
                    Else
                        Dim imageContent(imgLength) As Byte
                        imgStream.Read(imageContent, 0, imgLength)
                        ImagenMod = imageContent
                    End If

                Else
                    Throw New Exception("La imagen debe ser de tipo .tif")
                    Exit Sub
                End If
            Else
                Throw New Exception("La imagen de los documentos para el registro de la empresa es requerida")
            End If
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Throw New Exception(ex.Message)
        End Try
    End Sub

    Private Sub RehacerImagen()
        'Lee La primera imagen
        Dim intImageSize As Int64 = Me.flCargarDocumentosEmpresa.PostedFile.ContentLength
        Dim ImageStream As Stream = Me.flCargarDocumentosEmpresa.PostedFile.InputStream
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

#End Region

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        Dim textBtnBuscar = Me.btnBuscar.Text
        Select Case textBtnBuscar
            Case "Buscar empleador"
                regExpRncCedula.Validate()
                If Not regExpRncCedula.IsValid() Then
                    Me.setFormError("No cumple con el digito verificador del RNC")
                    Exit Sub
                End If

                'Realizando busqueda del empleador
                Dim retStr As String() = Split(SuirPlus.Empresas.Empleador.busquedaInicial(Trim(txtRNCCedula.Text), ddlTipoEmpresa.SelectedValue), "|")

                ' Si la busqueda fue satisfactoria
                If retStr(0) = "0" Then
                    Me.imgBusqueda.Visible = True
                    Me.imgBusqueda.ImageUrl = Me.urlImgOK

                    Me.txtRazonSocial.Text = retStr(2)
                    Me.txtNombreComercial.Text = IIf(txtRNCCedula.Text.Length = 11, "", retStr(3))
                    Me.txtCalle.Text = retStr(4)
                    Me.txtNumero.Text = retStr(5)
                    Me.txtEdificio.Text = retStr(6)
                    Me.txtPiso.Text = retStr(7)
                    Me.txtApartamento.Text = retStr(8)
                    Me.Telefono1.phoneNumber = retStr(9)
                    Me.txtEmail.Text = retStr(10)

                    If Not retStr(13) = "null" Then
                        If Me.ddProvincia.Items.FindByValue(retStr(13)) IsNot Nothing Then
                            Me.ddProvincia.SelectedValue = retStr(13)
                            'ddProvincia_SelectedIndexChanged(Nothing, Nothing)
                        End If
                    End If

                    Me.ddlTipoEmpresa.SelectedValue = retStr(12)
                    Me.txtRNCCedula.ReadOnly = True
                    Me.btnBuscar.Text = "Cancelar"

                Else ' Si ocurrio un error.
                    Me.setFormError(retStr(1))
                    Me.imgBusqueda.ImageUrl = Me.urlImgCancelar
                    Exit Select

                End If
            Case "Cancelar"
                Me.iniForm()
        End Select
    End Sub

    Protected Sub btnCerrarSolRegistroEmpresa_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCerrarSolRegistroEmpresa.Click
        Dim result As String = String.Empty

        Try
            If IsNumeric(Me.lblNroSolicitud.Text) Then
                If (txtComentarioSolicitud.Text <> String.Empty) Then

                    result = CerrarSolRegEmpresa(lblNroSolicitud.Text, txtComentarioSolicitud.Text)

                    If result.Split("|")(0) <> "0" Then
                        Me.lblMensajeSol.Text = result.Split("|")(1)
                    Else
                        Me.lblMensajeSol.Text = "La solicitud para el registro de esta empresa fue completada satisfactoriamente."
                        lblMensajeSol.ForeColor = Drawing.Color.Blue
                        btnCerrarSolRegistroEmpresa.Enabled = False
                        txtComentarioSolicitud.Enabled = False

                    End If

                Else
                    Me.lblMensajeSol.Text = "El nro. de solicitud y el comentario son requeridos."
                    Exit Sub
                End If
            End If

        Catch ex As Exception
            Me.lblMensajeSol.Text = ex.Message
            Me.lblMensajeSol.Visible = True

        End Try

    End Sub

    Function CerrarSolRegEmpresa(ByVal idSolicitud As Integer, ByVal comentario As String) As String
        Dim mensaje As String
        Try
            mensaje = SuirPlus.SolicitudesEnLinea.Solicitudes.CambiarStatus(idSolicitud, 3, UsrUserName, comentario)

            'If mensaje.Split("|")(0) <> "0" Then
            '    Return mensaje.Split("|")(1)
            'Else
            '    Return "0|La solicitud para el registro de esta empresa fue completada satisfactoriamente."
            'End If
            Return mensaje
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Throw New Exception(ex.Message)
        End Try

    End Function

    Protected Sub cargarSolicitud(ByVal rnc As String)
        Dim solicitud As String = String.Empty
        Try
            'buscamos la solicitud amarrada a este rnc y activamos el boton para cerrarla automaticamente
            btnCerrarSolRegistroEmpresa.Enabled = True
            txtComentarioSolicitud.Enabled = True

            solicitud = SolicitudesEnLinea.Solicitudes.getSolicitudByRNC(rnc)
            Me.lblNroSolicitud.Text = solicitud
            If Not IsNumeric(solicitud) Then
                btnCerrarSolRegistroEmpresa.Enabled = False
                txtComentarioSolicitud.Enabled = False
            Else
                btnCerrarSolRegistroEmpresa.Enabled = True
                txtComentarioSolicitud.Enabled = True
            End If

        Catch ex As Exception
            btnCerrarSolRegistroEmpresa.Enabled = False
            txtComentarioSolicitud.Enabled = False
            Throw New Exception(ex.Message)
        End Try

    End Sub


    Protected Sub ChkEsZonaFranca_CheckedChanged(sender As Object, e As EventArgs)
        If ChkEsZonaFranca.Checked = True Then
            TrTipo.Visible = True
            TrParque.Visible = True
        Else
            TrTipo.Visible = False
            TrParque.Visible = False
        End If
    End Sub

    Protected Sub ddlTipoEmpresa_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles ddlTipoEmpresa.SelectedIndexChanged
        If ddlTipoEmpresa.SelectedValue = "PE" Then
            rqvActividad.Enabled = False
            rqvSectorEconomico.Enabled = False
            rqvSectorSalarial.Enabled = False
        Else
            rqvActividad.Enabled = true
            rqvSectorEconomico.Enabled = True
            rqvSectorSalarial.Enabled = True
        End If

    End Sub
End Class
