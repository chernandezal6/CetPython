Imports SuirPlus.Empresas
Imports System.Data

Partial Class Certificaciones_ConfirmarDatos
    Inherits BasePage

    Dim ImagenMod() As Byte
    Protected imgStream As System.IO.Stream
    Protected imgLength As Integer
    Private height As Integer
    Private width As Integer
    Private thumbnail As Boolean
    Dim registroPatronal As String

    Protected Sub btnSolicitar_Click(sender As Object, e As EventArgs) Handles btnSolicitar.Click
        lblMensaje.Text = String.Empty
        Dim Empresa As String
        Dim msg As String = String.Empty

        Try
            btnSolicitar.Enabled = False

            If hdTipoCertificacion.Value <> String.Empty Then
                If hdTipoCertificacion.Value = "2" Or hdTipoCertificacion.Value = "3" Or hdTipoCertificacion.Value = "9" Then

                    If hdTipoCertificacion.Value = "2" And lblRNC.Text = String.Empty Then
                        lblMensaje.Text = "RNC es requerido"
                        Return

                    End If


                    If txtCedula.Text = String.Empty Then
                        btnSolicitar.Enabled = True
                        lblMensaje.Text = "Cedula es requerida"
                        Return
                    ElseIf txtCedula.Text.Length <> 11 Then
                        btnSolicitar.Enabled = True
                        lblMensaje.Text = "Cedula invalida"
                        Return

                    Else
                        If UsrRegistroPatronal <> Nothing Then

                            registroPatronal = SuirPlus.Utilitarios.TSS.getRegistroPatronal(lblRNC.Text)

                            Dim Info = SuirPlus.Empresas.Certificaciones.getTrabajador(registroPatronal, txtCedula.Text)

                            If Info.Substring(0, 1) <> "0" Then
                                txtCedula.Enabled = True
                                btnSolicitar.Enabled = True
                                lblMensaje.Text = Info.Split("|")(1)

                                Return
                            Else
                                txtCedula.Enabled = False
                            End If
                        End If
                    End If
                ElseIf hdTipoCertificacion.Value = "13" Then
                    Dim myCert As Certificaciones = New Certificaciones(Certificaciones.CertificacionType.Deuda)

                    myCert.Cedula = Trim(Me.txtCedula.Text).PadLeft(11)
                    myCert.RNC = Trim(Me.txtRnc.Text).PadLeft(11)

                    If Me.txtFechaDesde.Text <> String.Empty Then myCert.FechaDesde = Me.txtFechaDesde.Text
                    If Me.txtFechaHasta.Text <> String.Empty Then myCert.FechaHasta = Me.txtFechaHasta.Text

                    If Me.txtRnc.Text = "" Then
                        Me.lblMensaje.Text = "El rnc del empleador es requerido para realizar esta certificación."
                        Me.txtRnc.Text = String.Empty
                        btnSolicitar.Enabled = True
                        Exit Sub
                    Else
                        If Not myCert.esEmpleador(msg) Then
                            Me.lblMensaje.Text = msg
                            Me.txtCedula.Text = String.Empty
                            btnSolicitar.Enabled = True
                            Exit Sub
                        End If
                    End If

                    Dim dt As DataTable = myCert.getFactVencidas

                    If dt.Rows.Count = 0 Then
                        Me.lblMensaje.Text = "Este empleador no cumple con los requisitos para realizarle esta certificacion."
                        btnSolicitar.Enabled = True
                        Exit Sub
                    End If

                ElseIf hdTipoCertificacion.Value = "16" Then
                    Dim myCert As Certificaciones = New Certificaciones(Certificaciones.CertificacionType.CiudadanoSinAportePorEmpleador)

                    myCert.Cedula = Trim(Me.txtCedula.Text).PadLeft(11)
                    myCert.RNC = Trim(Me.txtRnc.Text).PadLeft(11)

                    If Me.txtFechaDesde.Text <> String.Empty Then myCert.FechaDesde = Me.txtFechaDesde.Text
                    If Me.txtFechaHasta.Text <> String.Empty Then myCert.FechaHasta = Me.txtFechaHasta.Text

                    If Me.txtCedula.Text = "" Or Me.txtRnc.Text = "" Then
                        Me.lblMensaje.Text = "El RNC y la cédula del empleado son requerido."
                        Me.txtRnc.Text = String.Empty
                        Me.txtCedula.Text = String.Empty
                        btnSolicitar.Enabled = True
                        Exit Sub
                    ElseIf Me.txtFechaDesde.Text = "" Then
                        Me.lblMensaje.Text = "La fecha desde, debe ser especificada."
                        Me.txtFechaDesde.Text = String.Empty
                        btnSolicitar.Enabled = True
                        Exit Sub
                    ElseIf Me.txtFechaHasta.Text = "" Then
                        Me.lblMensaje.Text = "La fecha hasta, debe ser especificada."
                        Me.txtFechaHasta.Text = String.Empty
                        btnSolicitar.Enabled = True
                        Exit Sub

                    ElseIf (CDate(Me.txtFechaHasta.Text)) < (CDate(Me.txtFechaDesde.Text)) Then
                        Me.lblMensaje.Text = "La fecha hasta, debe ser mayor que la fecha desde."
                        Me.txtFechaHasta.Text = String.Empty
                        Me.txtFechaDesde.Text = String.Empty
                        btnSolicitar.Enabled = True
                        Exit Sub
                    ElseIf (CDate(Me.txtFechaDesde.Text)) > (CDate(Me.txtFechaHasta.Text)) Then
                        Me.lblMensaje.Text = "La fecha desde, debe ser menor que la fecha hasta."
                        Me.txtFechaHasta.Text = String.Empty
                        Me.txtFechaDesde.Text = String.Empty
                        btnSolicitar.Enabled = True
                        Exit Sub
                    Else
                        'Verificamos que sea un ciudadano valido.
                        If Not myCert.esCiudadano(msg) Then
                            Me.lblMensaje.Text = msg
                            Me.txtCedula.Text = String.Empty
                            btnSolicitar.Enabled = True
                            Exit Sub
                        End If
                        'Verificamos que sea un empleador valido.
                        If Not myCert.esEmpleador(msg) Then
                            Me.lblMensaje.Text = msg
                            Me.txtRnc.Text = String.Empty
                            btnSolicitar.Enabled = True
                            Exit Sub
                        End If


                        'Validamos que el empleador no haya hecho aporte.
                        If myCert.tieneAporteCiudadanoEmpleador Then
                            myCert.CargarDatos()
                            Me.lblMensaje.Text = "** El empleador: " & myCert.RazonSocial & " ha realizado aportes al trabajador: " & myCert.Nombre
                            btnSolicitar.Enabled = True
                            Exit Sub
                        End If
                    End If
                ElseIf hdTipoCertificacion.Value = "17" Then
                    Dim myCert As Certificaciones = New Certificaciones(Certificaciones.CertificacionType.AcuerdoPagoSinAtraso)

                    myCert.Cedula = Trim(Me.txtCedula.Text).PadLeft(11)
                    myCert.RNC = Trim(Me.txtRnc.Text).PadLeft(11)

                    If Me.txtFechaDesde.Text <> String.Empty Then myCert.FechaDesde = Me.txtFechaDesde.Text
                    If Me.txtFechaHasta.Text <> String.Empty Then myCert.FechaHasta = Me.txtFechaHasta.Text


                    If Me.txtRnc.Text = "" Then
                        Me.lblMensaje.Text = "El rnc del empleador es requerido para realizar esta certificación."
                        Me.txtRnc.Text = String.Empty
                        btnSolicitar.Enabled = True
                        Exit Sub
                    Else
                        If Not myCert.esEmpleador(msg) Then
                            Me.lblMensaje.Text = msg
                            Me.txtCedula.Text = String.Empty
                            btnSolicitar.Enabled = True
                            Exit Sub
                        End If
                    End If

                    'Validando si tiene acuerdo de pago
                    If myCert.tieneAcuerdodePagoVigente = False Then
                        Me.lblMensaje.Text = "Este empleador no cumple con los requisitos para realizarle esta certificacion."
                        btnSolicitar.Enabled = True
                        Exit Sub
                    End If

                    'Validando si tiene cuotas vencidas
                    Dim result As String = String.Empty
                    Dim dt As DataTable = myCert.getCuotasPagadasAcuerdo(result)

                    If result <> "0" Then
                        Me.lblMensaje.Text = "Este empleador no cumple con los requisitos para realizarle esta certificacion."
                        btnSolicitar.Enabled = True
                        Exit Sub
                    Else
                        If dt.Rows.Count = 0 Then
                            Me.lblMensaje.Text = "Este empleador no cumple con los requisitos para realizarle esta certificacion."
                            btnSolicitar.Enabled = True
                            Exit Sub
                        End If
                    End If

                ElseIf hdTipoCertificacion.Value = "18" Then
                    Dim myCert As Certificaciones = New Certificaciones(Certificaciones.CertificacionType.EstatusGeneral)

                    myCert.Cedula = Trim(Me.txtCedula.Text).PadLeft(11)
                    myCert.RNC = Trim(Me.txtRnc.Text).PadLeft(11)

                    If Me.txtFechaDesde.Text <> String.Empty Then myCert.FechaDesde = Me.txtFechaDesde.Text
                    If Me.txtFechaHasta.Text <> String.Empty Then myCert.FechaHasta = Me.txtFechaHasta.Text

                    If Me.txtRnc.Text = "" Then
                        Me.lblMensaje.Text = "El rnc del empleador es requerido para realizar esta certificación."
                        Me.txtRnc.Text = String.Empty
                        btnSolicitar.Enabled = True
                        Exit Sub
                    ElseIf Me.txtFechaDesde.Text = "" Then
                        Me.lblMensaje.Text = "La fecha desde, debe ser especificada."
                        Me.txtFechaDesde.Text = String.Empty
                        btnSolicitar.Enabled = True
                        Exit Sub
                    ElseIf Me.txtFechaHasta.Text = "" Then
                        Me.lblMensaje.Text = "La fecha hasta, debe ser especificada."
                        Me.txtFechaHasta.Text = String.Empty
                        btnSolicitar.Enabled = True
                        Exit Sub

                    ElseIf (CDate(Me.txtFechaHasta.Text)) < (CDate(Me.txtFechaDesde.Text)) Then
                        Me.lblMensaje.Text = "La fecha hasta, debe ser mayor que la fecha desde."
                        Me.txtFechaHasta.Text = String.Empty
                        Me.txtFechaDesde.Text = String.Empty
                        btnSolicitar.Enabled = True
                        Exit Sub
                    ElseIf (CDate(Me.txtFechaDesde.Text)) > (CDate(Me.txtFechaHasta.Text)) Then
                        Me.lblMensaje.Text = "La fecha desde, debe ser menor que la fecha hasta."
                        Me.txtFechaHasta.Text = String.Empty
                        Me.txtFechaDesde.Text = String.Empty
                        btnSolicitar.Enabled = True
                        Exit Sub
                    Else
                        If Not myCert.esEmpleador(msg) Then
                            Me.lblMensaje.Text = msg
                            Me.txtCedula.Text = String.Empty
                            btnSolicitar.Enabled = True
                            Exit Sub
                        End If
                    End If

                    'Validamos que el empleador no haya hecho aporte.
                    If myCert.tieneAporteGeneral = False Then
                        myCert.CargarDatos()
                        Me.lblMensaje.Text = "** El empleador: " & myCert.RazonSocial & " no ha realizado aportes al SDSS entre las fechas especificadas"
                        btnSolicitar.Enabled = True
                        Exit Sub
                    End If

                End If

                If UsrTipoUsuario = "Usuario" Then
                    If flCargarImagenCert.HasFile() Then
                        If ValidarImagen() = False Then
                            btnSolicitar.Enabled = True
                            txtCedula.Enabled = True
                            Return
                        End If
                    Else
                        lblMensaje.Text = "La Imagen es Requerida."
                        btnSolicitar.Enabled = True
                        Return

                    End If

                End If

                pnlMensaje.Visible = True
                lblGenerado.Text = "<span style='text-align:center; margin-left:30%;'>Estamos procesando la Solicitud...</span>"
                lblGenerado.Visible = True


                If UsrRNC <> Nothing Then
                    Empresa = UsrRNC
                Else
                    Empresa = txtRnc.Text
                End If


                Dim Numero = SuirPlus.Empresas.Certificaciones.ProcesarSolicitud(UsrUserName, hdTipoCertificacion.Value, Empresa, txtCedula.Text, txtFechaDesde.Text, txtFechaHasta.Text)

                If Numero.Substring(0, 1) = "0" Then
                    lblGenerado.Text = "<span style='text-align:center;'>Su numero de seguimiento es: " + Numero.Split("|")(1) + "</span>"
                    'validamos el contenidos de los documentos recientemente scaneados para atachar en la certificación recietemente creada
                    If UsrTipoUsuario = "Usuario" Then
                        Dim result As String = SuirPlus.Empresas.Certificaciones.SubirImagenCertificacion(Numero.Split("|")(2), 0, ImagenMod, UsrUserName)
                    End If
                    btnProcesar.Visible = True
                    txtCedula.Enabled = False
                Else

                    lblMensaje.Text = Numero.Split("|")(1)
                    pnlMensaje.Visible = False
                    btnSolicitar.Enabled = True
                    txtCedula.Enabled = True
                End If


            Else
                txtCedula.Enabled = True
                btnSolicitar.Enabled = True
                lblMensaje.Text = "No se puede procesar la solicitud, no se ha seleccionado un Tipo de Certificación"
                Return
            End If

        Catch ex As Exception
            lblMensaje.Text = ex.Message

        End Try

    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        lblMensaje.Text = String.Empty

        If Not Page.IsPostBack Then
            pnlMensaje.Visible = False
            hdTipoCertificacion.Value = Request.QueryString("ID")
            lblRNC.Text = UsrRNC

            If SuirPlus.Empresas.Empleador.getRazonSocialEnDGII(UsrRNC).Split("|")(0) = "179" Then
                lblRazonSocial.Text = "No existe razon social para este RNC."
            Else
                lblRazonSocial.Text = SuirPlus.Empresas.Empleador.getRazonSocialEnDGII(UsrRNC)
            End If


            If UsrTipoUsuario = "Usuario" Then
                trDocumentos.Visible = True
                lblRNC.Visible = False
                txtRnc.Visible = True
            Else
                lblRNC.Visible = True
                txtRnc.Visible = False
                trDocumentos.Visible = False
            End If


            If hdTipoCertificacion.Value <> String.Empty Then
                btnSolicitar.Enabled = True

            End If

            If hdTipoCertificacion.Value = "2" Then
                trCedula.Visible = True
                trRNC.Visible = True
                trRazonSocial.Visible = True
            ElseIf hdTipoCertificacion.Value = "3" Then
                trCedula.Visible = True
                trRNC.Visible = False
                trRazonSocial.Visible = False
            ElseIf hdTipoCertificacion.Value = "9" Then
                trCedula.Visible = True
                trRNC.Visible = False
                trRazonSocial.Visible = False
            ElseIf hdTipoCertificacion.Value = "16" Then
                trCedula.Visible = True
                trRNC.Visible = True
                trRazonSocial.Visible = True
                trFechaDesde.Visible = True
                trFechaHasta.Visible = True
            ElseIf hdTipoCertificacion.Value = "17" Or hdTipoCertificacion.Value = "13" Then
                trCedula.Visible = False
                trRNC.Visible = True
                trRazonSocial.Visible = True
                trFechaDesde.Visible = False
                trFechaHasta.Visible = False
            ElseIf hdTipoCertificacion.Value = "18" Then
                trCedula.Visible = False
                trRNC.Visible = True
                trRazonSocial.Visible = True
                trFechaDesde.Visible = True
                trFechaHasta.Visible = True
            Else
                trCedula.Visible = False
                trRNC.Visible = True
                trRazonSocial.Visible = True
            End If
        End If

    End Sub

    Protected Sub btnProcesar_Click(sender As Object, e As EventArgs) Handles btnProcesar.Click
        Response.Redirect("ConsultaCerSolicitudes.aspx")


    End Sub

    Protected Function ValidarImagen() As Boolean
        Dim Resultado As Boolean = True
        Try
            If Me.flCargarImagenCert.HasFile() Then
                imgStream = flCargarImagenCert.PostedFile.InputStream
                imgLength = flCargarImagenCert.PostedFile.ContentLength
                Dim imgContentType As String = flCargarImagenCert.PostedFile.ContentType

                'validamos los tipos de archivos que deseamos aceptar
                If (imgContentType = "image/tif") Or (imgContentType = "image/tiff") Or (imgContentType = "image/jpg") Or (imgContentType = "image/jpeg") Or (imgContentType = "image/png") Or (imgContentType = "image/gif") Then

                    Dim imgSize As String = (imgLength / 1024)
                    If imgSize > 900 Then
                        lblMensaje.Text = "El tamaño del archivo de imagen no debe superar los 800 KB, por favor contacte a mesa de ayuda."
                        Resultado = False
                    Else
                        Dim imageContent(imgLength) As Byte
                        imgStream.Read(imageContent, 0, imgLength)
                        ImagenMod = imageContent
                    End If
                Else
                    lblMensaje.Text = "La imagen debe ser de tipo TIF, JPG, PNG o GIF."
                    Resultado = False
                End If
            End If

            Return Resultado
        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Return Resultado
        End Try
    End Function

    Protected Sub txtRnc_TextChanged(sender As Object, e As EventArgs) Handles txtRnc.TextChanged
        lblMensaje.Text = String.Empty
        If txtRnc.Text <> String.Empty Then
            If SuirPlus.Utilitarios.TSS.getEmpleadorDatos(txtRnc.Text).Rows.Count > 0 Then
                lblRazonSocial.Text = SuirPlus.Utilitarios.TSS.getEmpleadorDatos(txtRnc.Text).Rows(0).Item("Razon_social").ToString()
                lblRNC.Text = SuirPlus.Utilitarios.TSS.getEmpleadorDatos(txtRnc.Text).Rows(0).Item("rnc_o_cedula").ToString()
                lblRNC.Visible = True
                txtRnc.Visible = False
                btnSolicitar.Enabled = True

            Else
                lblRNC.Visible = False
                txtRnc.Visible = True
                lblMensaje.Text = "Este Rnc no ha devuelto ningun resultado."
                btnSolicitar.Enabled = False
                Return
            End If
        End If

    End Sub

End Class