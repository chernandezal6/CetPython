Imports System
Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios
Imports System.Data
Imports System.IO
Imports System.Linq


Partial Class Oficina_Virtual_RegistroSolicitudUsuario
    Inherits RegistroEmpresaSeguridad

    Dim cantidad_intentos As Integer
    Dim nss As Integer

    Protected Sub Page_Load1(sender As Object, e As EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnSiguiente_Click(sender As Object, e As EventArgs) Handles btnSiguiente.Click
        'If CaptchaControl1.UserValidated Then
        '    CaptchaControl1.Visible = False
        'End If
        RegistroValidacion()
        lblMensaje.CssClass = "label-Blue"
        ViewState("_UserName") = txtDocumento.Text
        ViewState("_Estatus") = 1
        ViewState("_Password") = txtClave3.Text
        ViewState("_email") = txtEmail1.Text


        DivPreguntas.Visible = True
        ' Divcontact_form.Visible = False
        HideControls()
        'Aqui se llenan las preguntas que vienen desde la base de datos
        GetPreguntas()
    End Sub

    Protected Sub GetPreguntas()
        Dim ds As New DataTable
        Dim respuesta1 As String
        Dim respuesta2 As String
        Dim respuesta3 As String
        Dim respuesta4 As String
        Dim respuesta5 As String

        Try
            ds = SuirPlus.OficinaVirtual.OficinaVirtual.getPReguntasRegistro(ViewState("NSS_Solicitante"))

            If ds.Rows.Count > 0 Then

                'Presentamos las preguntas traidas desde la base de datos
                Me.HLPregunta1.Text = ds.Rows(0)("PREGUNTA")
                Me.HLPregunta2.Text = ds.Rows(1)("PREGUNTA")
                Me.HLPregunta3.Text = ds.Rows(2)("PREGUNTA")
                Me.HLPregunta4.Text = ds.Rows(3)("PREGUNTA")
                Me.HLPregunta5.Text = ds.Rows(4)("PREGUNTA")

                'Aqui llenamos en variables de sesion las respuestas a las preguntas traidas por el datatable

                respuesta1 = ds.Rows(0)("RESPUESTA")
                respuesta2 = ds.Rows(1)("RESPUESTA")
                respuesta3 = ds.Rows(2)("RESPUESTA")
                respuesta4 = ds.Rows(3)("RESPUESTA")
                respuesta5 = ds.Rows(4)("RESPUESTA")

                'LLenando ahora las variables de Sesion que contienen las respuestas a las preguntas cargadas.
                ViewState.Add("_RespQuest1", respuesta1)
                ViewState.Add("_RespQuest2", respuesta2)
                ViewState.Add("_RespQuest3", respuesta3)
                ViewState.Add("_RespQuest4", respuesta4)
                ViewState.Add("_RespQuest5", respuesta5)
            End If
        Catch ex As Exception
            Me.lblErrorMsj.Visible = True
            Me.lblErrorMsj.Text = ex.Message.ToString
        End Try
    End Sub

    Protected Function GetRadioChecked(id_radio1 As RadioButton, id_radio2 As RadioButton) As RadioButton
        If id_radio1.Checked Then
            Return id_radio1
        Else
            Return id_radio2
        End If

    End Function

    Protected Function ValidarRespuestas() As Boolean
        Dim value1 As String = RdsiP1.Attributes("value")
        Dim respuestai As String = ViewState("_RespQuest2")

        If Me.GetRadioChecked(RdsiP1, RdNoP1).Attributes("value") <> ViewState("_RespQuest1") Then
            Return False
        End If
        If Me.GetRadioChecked(RdsiP2, RdNoP2).Attributes("value") <> ViewState("_RespQuest2") Then
            Return False
        End If
        If Me.GetRadioChecked(RdsiP3, RdNoP3).Attributes("value") <> ViewState("_RespQuest3") Then
            Return False
        End If
        If Me.GetRadioChecked(RdsiP4, RdNoP4).Attributes("value") <> ViewState("_RespQuest4") Then
            Return False
        End If
        If Me.GetRadioChecked(RdsiP5, RdNoP5).Attributes("value") <> ViewState("_RespQuest5") Then
            Return False
        End If
        Return True

    End Function

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        Limpiar()
        Response.Redirect("LoginOficinaVirtual.aspx")
    End Sub

    Sub Limpiar()
        'Para la tabla de Cedula
        txtDocumento.Text = String.Empty
        txtClave3.Text = String.Empty
        txtTelefono1.Text = String.Empty
        lblNombreCiudadano.Text = String.Empty
        txtEmail1.Text = String.Empty
        txtClave3.Text = String.Empty
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        lblMensaje.Text = String.Empty
        lblNombreCiudadano.Text = String.Empty
        Dim Res As New DataTable
        Dim resultado As String
        Dim nss As Integer
        Dim status As String
        Dim NewDocument As Integer

        If txtDocumento.Text.Length = 11 Or txtDocumento.Text.Length <= 10 Then

            'Validaciones sobre el ciudadano en cuestion: cedula cancelada, causas de inhabilidad, entre otras.
            Try
                If ddlTipoDocumento.SelectedValue = "N" Then
                    NewDocument = Convert.ToInt32(txtDocumento.Text)
                    Res = SuirPlus.OficinaVirtual.OficinaVirtual.getCiudadanoValidoOFC(NewDocument, ddlTipoDocumento.SelectedValue)
                    resultado = SuirPlus.OficinaVirtual.OficinaVirtual.getCiudadanoValidoOFV(NewDocument, ddlTipoDocumento.SelectedValue)
                Else
                    Res = SuirPlus.OficinaVirtual.OficinaVirtual.getCiudadanoValidoOFC(txtDocumento.Text, ddlTipoDocumento.SelectedValue)
                    resultado = SuirPlus.OficinaVirtual.OficinaVirtual.getCiudadanoValidoOFV(txtDocumento.Text, ddlTipoDocumento.SelectedValue)
                End If
                status = resultado
                If resultado.Contains("|") Then
                    status = resultado.Split("|")(0)
                End If

                If Res.Rows.Count > 0 Then
                    lblNombreCiudadano.Visible = True
                    lblNombreCiudadano.Text = Res.Rows(0)("NOMBRE_COMPLETO").ToString
                    nss = Integer.Parse(Res.Rows(0)("ID_NSS").ToString)
                    ViewState("NSS_Solicitante") = nss
                    tblmensaje.Visible = False
                    statusU.Value = status
                    ValidarLupa.Value = "1"
                    HideErrors()
                    ShowControls()
                ElseIf resultado.Length > 1 Then

                    hfMostrarPopUp.Value = "El ciudadano está inválido"
                    btnClosePopUp.Visible = True
                    tblmensaje.Visible = True
                    btnResetPreguntas.Visible = False
                End If

                If Res.Rows.Count > 0 And resultado = "P" Then
                    HideControls()
                    DivPreguntas.Visible = True
                    GetPreguntas()
                End If

                If Res.Rows.Count > 0 And resultado = "A" Then
                    HideControls()
                    lblMensajeBuscar.Visible = True
                    lblMensajeBuscar.Text = "Este usuario ya ha sido registrado."
                    LnkRegresar.Visible = True
                    tblmensaje.Visible = True
                End If

                If Res.Rows.Count > 0 And resultado = "C" Then
                    HideControls()
                    lblMensajeBuscar.Visible = True
                    lblMensajeBuscar.Text = "Este usuario está pendiente de confirmación. Favor revisar el correo que le fue enviado cuando se registró y confirmar."
                    LnkRegresar.Visible = True
                    tblmensaje.Visible = True
                End If

                'Para mostrar resultados que vienen desde la base de datos diferentes.
                If Res.Rows.Count > 0 And resultado.Length > 1 And Not resultado.Contains("|") Then
                    HideControls()
                    lblMensajeBuscar.Visible = True
                    lblMensajeBuscar.Text = resultado
                    LnkRegresar.Visible = True
                    tblmensaje.Visible = True
                End If

                If status = "B" Then
                    Dim dias As String = resultado.Split("|")(1)
                    Dim horas As String = resultado.Split("|")(2)
                    Dim mins As String = resultado.Split("|")(3)
                    Dim segs As String = resultado.Split("|")(4)
                    HideControls()
                    hfMostrarPopUp.Value = GetTimeRest(dias, horas, mins, segs)
                    btnClosePopUp.Visible = True
                    btnResetPreguntas.Visible = False
                End If
            Catch ex As Exception
                Me.lblMensajeBuscar.Visible = True
                Me.lblMensajeBuscar.Text = ex.Message.ToString
                tblmensaje.Visible = True
            End Try

        ElseIf ddlTipoDocumento.SelectedValue = "C" And txtDocumento.Text.Length < 11 Then
            lblMensaje.Text = "Cédula debe constar de 11 caracteres, favor verificar"
            tblmensaje.Visible = True

        ElseIf txtDocumento.Text = String.Empty Then
            lblMensaje.Text = "Debe completar el No. Documento"
            tblmensaje.Visible = True
        End If

    End Sub

    Protected Function GetTimeRest(Days As String, hours As String, mins As String, secs As String) As String
        'Validamos que la primera posicion del string sea mayor que cero para saber si quedan dias restantes.
        If Integer.Parse(Days(0)) > 0 Then
            Return " Su solicitud ha sido obviada. Intente nuevamente dentro de " + Days + " y " + hours
            'Si es 0  y quedan horas retornamos solo las horas con los minutos
        ElseIf Integer.Parse(Days(0)) = 0 And Integer.Parse(hours(0)) > 0 Then
            Return " Su solicitud ha sido obviada. Intente nuevamente dentro de " + hours + "y " + mins
            'Si los dias restantes son 0 y tambien las horas entonces retornamos los minutos y los segundos
        ElseIf Integer.Parse(Days(0)) = 0 And Integer.Parse(hours(0)) = 0 And Integer.Parse(mins(0)) > 0 Then
            Return " Su solicitud ha sido obviada. Intente nuevamente dentro de " + mins + "y " + secs
            'Si los dias restantes son 0 y tambien las horas y tambien los minutos entonces retornamos solo los segundos restantes
        ElseIf Integer.Parse(Days(0)) = 0 And Integer.Parse(hours(0)) = 0 And Integer.Parse(mins(0)) = 0 Then
            Return " Su solicitud ha sido obviada. Intente nuevamente dentro de " + secs
        End If
        Return ""
    End Function
    Protected Sub HideControls()
        DivDocumento.Visible = False
        divRegistroInicial.Visible = False
        divBotonesRegistro.Visible = False
    End Sub
    Protected Sub ShowControls()
        divRegistroInicial.Visible = True
        divBotonesRegistro.Visible = True
    End Sub
    Protected Sub HideErrors()
        lblMensajeBuscar.Visible = False
        lblMensajeBuscar.Text = ""
        LnkRegresar.Visible = False
        tblmensaje.Visible = False
    End Sub

    Protected Sub GetResultQuestions()

        Dim Valido As Boolean
        Dim resultado_validado As String
        Dim nro_documento As String
        nro_documento = txtDocumento.Text
        Dim resultado_insertado As String
        Dim NewDocument As String

        Valido = ValidarRespuestas()
        If Valido = True Then
            resultado_validado = "S"
            Try
                If ddlTipoDocumento.SelectedValue = "N" Then
                    NewDocument = Convert.ToInt32(txtDocumento.Text)
                    resultado_insertado = SuirPlus.OficinaVirtual.OficinaVirtual.CrearUsuarioOFC(NewDocument, ViewState("_Password"), ViewState("_email"), ddlTipoDocumento.SelectedValue, resultado_validado)
                Else
                    resultado_insertado = SuirPlus.OficinaVirtual.OficinaVirtual.CrearUsuarioOFC(nro_documento, ViewState("_Password"), ViewState("_email"), ddlTipoDocumento.SelectedValue, resultado_validado)
                End If
                '^ Aqui manda el correo de creacion del usuario y la confirmacion
                If resultado_insertado = "0" Then
                    Divcontact_form.Visible = False
                    DivPreguntas.Visible = False
                    divMensaje.Visible = True
                    lblMsgOk.Visible = True
                    lblMsgOk.Text = "Se le ha enviado un correo de confirmación a su cuenta. Favor revisar y confirmar para activar su cuenta."
                Else
                    Me.lblErrorMsj.Visible = True
                    Me.lblErrorMsj.Text = resultado_insertado.ToString
                End If
            Catch ex As Exception
                Me.lblErrorMsj.Visible = True
                Me.lblErrorMsj.Text = ex.Message.ToString
            End Try
        Else
            resultado_validado = "N"
            resultado_insertado = SuirPlus.OficinaVirtual.OficinaVirtual.CrearUsuarioOFC(nro_documento, ViewState("_Password"), ViewState("_email"), ddlTipoDocumento.SelectedValue, resultado_validado)
            ViewState.Add(ddlTipoDocumento.SelectedValue, "_TipoDocumento")

            Try
                If BlockedUser(txtDocumento.Text) <> "B" Then
                    hfMostrarPopUp.Value = "Las respuestas a sus preguntas no han sido satisfactorias."
                    btnClosePopUp.Visible = False
                    divIntentarNew.Visible = True
                Else
                    HideControls()
                    divIntentarNew.Visible = False
                    lnkintentarnew.Visible = False
                    DivPreguntas.Visible = False
                    divMensaje.Visible = True
                    hfMostrarPopUp.Value = "Ha excedido el número de intentos permitidos, su solicitud ha sido obviada. Intente nuevamente dentro de 48 horas."
                    btnClosePopUp.Visible = True
                    btnResetPreguntas.Visible = False
                End If
            Catch ex As Exception
                Me.lblErrorMsj.Visible = True
                Me.lblErrorMsj.Text = ex.Message.ToString
            End Try

        End If

    End Sub
    Protected Sub btnAceptarPreguntas_Click(sender As Object, e As EventArgs) Handles btnAceptarPreguntas.Click
        GetResultQuestions()
    End Sub

    Protected Sub btnCancelarPreguntas_Click(sender As Object, e As EventArgs) Handles btnCancelarPreguntas.Click
        Response.Redirect("LoginOficinaVirtual.aspx")
    End Sub

    Protected Sub txtClave3_TextChanged(sender As Object, e As EventArgs) Handles txtClave3.TextChanged
        If txtClave3.Text <> txtClave3.Text Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "Contraseñas no coinciden"

        End If
    End Sub

    Protected Sub btnResetPreguntas_Click(sender As Object, e As EventArgs) Handles btnResetPreguntas.Click
        Try
            If BlockedUser(txtDocumento.Text) <> "B" Then
                lblErrorMsj.Visible = False
                divIntentarNew.Visible = False
                lnkintentarnew.Visible = False
                ResetRadioButtons()
                GetPreguntas()
            Else
                HideControls()
                divIntentarNew.Visible = False
                lnkintentarnew.Visible = False
                DivPreguntas.Visible = False
                divMensaje.Visible = True
                hfMostrarPopUp.Value = "Ha excedido el número de intentos permitidos, su solicitud ha sido obviada. Intente nuevamente dentro de 48 horas."
                btnClosePopUp.Visible = True
                btnResetPreguntas.Visible = False
            End If
        Catch ex As Exception
            Me.lblErrorMsj.Visible = True
            Me.lblErrorMsj.Text = ex.Message.ToString
        End Try

    End Sub

    Protected Sub ResetRadioButtons()

        'Pregunta 1
        RdsiP1.Checked = False
        RdNoP1.Checked = False

        'Pregunta 2
        RdsiP2.Checked = False
        RdNoP2.Checked = False

        'Pregunta 3
        RdsiP3.Checked = False
        RdNoP3.Checked = False

        'Pregunta 4
        RdsiP4.Checked = False
        RdNoP4.Checked = False

        'Pregunta 5
        RdsiP5.Checked = False
        RdNoP5.Checked = False
    End Sub
    Function BlockedUser(UserName As String) As String
        Dim res_blocked As String
        Dim status As String
        Dim tipo_documento As String

        If UserName.Length < 11 Then

            tipo_documento = "N"
        Else
            tipo_documento = "C"
        End If
        Try
            res_blocked = SuirPlus.OficinaVirtual.OficinaVirtual.getCiudadanoValidoOFV(UserName, tipo_documento)
            status = res_blocked

            If res_blocked.Contains("|") Then
                status = res_blocked.Split("|")(0)
            End If
            If status = "B" Then
                Return status
            Else
                Return res_blocked
            End If
        Catch ex As Exception
            Throw New Exception(ex.ToString())
        End Try
        Return ""
    End Function
    Protected Sub LnkRegresar_Click(sender As Object, e As EventArgs) Handles LnkRegresar.Click
        Response.Redirect("LoginOficinaVirtual.aspx")
    End Sub

    Protected Sub btnClosePopUp_ServerClick(sender As Object, e As EventArgs) Handles btnClosePopUp.ServerClick
        Response.Redirect("LoginOficinaVirtual.aspx")
    End Sub

    Private Sub RegistroValidacion()
        Dim resultado As String
        If ValidarLupa.Value <> 1 Then
            lblMensaje.Text = "Debe validar nro. de documento."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return
        End If
        If txtEmail1.Text = String.Empty Then
            lblMensaje.Text = "Digite la cuenta de correo electrónico."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return
        End If
        Try
            resultado = SuirPlus.OficinaVirtual.OficinaVirtual.isValidarUsuarioEmailOFV(txtEmail1.Text)
            If resultado <> "0" Then
                lblMensajeBuscar.Visible = True
                lblMensajeBuscar.Text = "* Ya existe un usuario registrado con este correo electrónico"
                Return
            End If
        Catch ex As Exception
            tblmensaje.Visible = True
            lblMensaje.Visible = True
            lblMensaje.Text = ex.Message.ToString()
        End Try
        If txtClave3.Text = String.Empty Then
            lblMensaje.Text = "Debe introducir una contraseña para continuar."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return
        End If
        If txtClave3.Text.Length < 6 Then
            lblMensaje.Text = "Su contraseña debe contener minimo 6 caracteres."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return
        End If
        If txtClave3.Text.Length > 32 Then
            lblMensaje.Text = "Su contraseña no debe contener mas de 32 caracteres."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return
        End If
        If txtClave3.Text.Length > 32 Then
            lblMensaje.Text = "Su contraseña no debe contener mas de 32 caracteres."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return
        End If
        If txtClave3.Text <> txtClave3.Text Then
            lblMensaje.Text = "Sus contraseñas no coinciden."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return
        End If
        If ddlTipoDocumento.SelectedValue = "C" Then
            If txtDocumento.Text = String.Empty Then
                lblMensaje.Text = "Digite un número de documento para validar."
                lblMensaje.CssClass = "error"
                tblmensaje.Visible = True
                Return
            End If
        End If
        If ddlTipoDocumento.SelectedValue = "P" Then
            If txtDocumento.Text = String.Empty Then
                lblMensaje.Text = "Digite un número de documento para validar."
                lblMensaje.CssClass = "error"
                tblmensaje.Visible = True
                Return
            End If
        End If
        If txtTelefono1.Text = String.Empty Then
            lblMensaje.Text = "Debe digitar el número telefónico."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return
        End If
    End Sub
End Class
