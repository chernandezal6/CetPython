Partial Class sys_SolEnvioFacturasEmail
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Put user code to initialize the page here
    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Me.btnConsultar.Visible = False
        Me.pnlFacturasEmail.Visible = False
        Me.txtNuevoCorreo.Text = String.Empty
        Me.txtConfirmacion.Text = String.Empty

        If SuirPlus.SolicitudesEnLinea.Solicitudes.isRepresentanteEnEmpresa(Me.txtRnc.Text, Me.txtCedula.Text) Then
            Dim emp As New SuirPlus.Empresas.Empleador(Me.txtRnc.Text)
            Me.pnlFacturasEmail.Visible = True

            Me.lblRazonSocial.Text = emp.RazonSocial
            Me.lblNombreComercial.Text = emp.NombreComercial

            Dim rep As New SuirPlus.Empresas.Representante(Me.txtRnc.Text, Me.txtCedula.Text)

            Me.lblRepresentante.Text = rep.NombreCompleto

            Me.lblCorreoActual.Text = rep.Email
            Me.lblMensaje.Visible = False

        Else
            Me.btnConsultar.Visible = True
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "Esta cédula no es un representante para el empleador digitado."
            Exit Sub

        End If

    End Sub

    Private Sub ActualizarEmail()

        Dim rep As New SuirPlus.Empresas.Representante(Me.txtRnc.Text, Me.txtCedula.Text)

        rep.Email = Me.txtNuevoCorreo.Text

        rep.GuardarCambios(Me.txtRnc.Text & Me.txtCedula.Text)


    End Sub


    Private Sub EnvioEmail()

        Dim NumeroSolicitud As String
        Dim valor1 As String
        Dim valor2 As String
        Dim Res As String()

        Dim Comentario As String
        Comentario = "Solicitado por www.tss.gov.do"

        Dim emp As New SuirPlus.Empresas.Empleador(Me.txtRnc.Text)

        If (Me.lblCorreoActual.Text = Nothing) And (Me.txtNuevoCorreo.Text = Nothing) And (Me.txtConfirmacion.Text = Nothing) Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "Debe Agregar un nuevo email y confirmarlo"
            Exit Sub
        Else
            Me.lblMensaje.Visible = False
        End If

        If (Me.lblCorreoActual.Text = Nothing) And (Me.txtNuevoCorreo.Text <> Me.txtConfirmacion.Text) Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "El nuevo correo debe ser identico en la confirmación"
            Exit Sub
        Else
            Me.lblMensaje.Visible = False
        End If
        If (Me.lblCorreoActual.Text = Nothing) And (Me.txtNuevoCorreo.Text <> Nothing) And (Me.txtConfirmacion.Text <> Nothing) Then
            Me.ActualizarEmail()
        End If

        If (Me.lblCorreoActual.Text <> Nothing) And (Me.txtNuevoCorreo.Text = Nothing) And (Me.txtConfirmacion.Text = Nothing) Then
            Comentario = "Solicitado por www.tss.gov.do"

        ElseIf (Me.lblCorreoActual.Text <> Nothing) And (Me.txtNuevoCorreo.Text = Me.txtConfirmacion.Text) And (Me.txtConfirmacion.Text <> Me.lblCorreoActual.Text) Then
            Me.ActualizarEmail()
        End If

        Try
            NumeroSolicitud = SuirPlus.SolicitudesEnLinea.Solicitudes.crearSolicitud(8, 0, Me.txtRnc.Text, Me.txtCedula.Text, "", Comentario)

            Res = NumeroSolicitud.Split("|")
            valor1 = Res(0)
            valor2 = Res(1)

            If valor1 = "0" Then

                'Dim mensaje As String
                'mensaje = "A partir del próximo corte usted recibirá sus facturas al correo electrónico " & Me.txtNuevoCorreo.Text & ", gracias por utilizar este servicio."

                Response.Redirect("SolicitudCreada.aspx?tipo=Em")

            Else

                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = valor2

            End If
        Catch ex As Exception
            Response.Redirect("error.aspx?errMsg=" & ex.ToString())
        End Try
    End Sub

    Private Sub btnActualizarEmail_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnActualizarEmail.Click
        Me.EnvioEmail()

    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.btnConsultar.Visible = True
        Response.Redirect("SolEnvioFacturasEmail.aspx")
    End Sub

End Class
