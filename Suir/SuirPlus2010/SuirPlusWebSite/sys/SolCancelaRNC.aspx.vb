Imports SuirPlus
Imports SuirPlus.SolicitudesEnLinea
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios

Partial Class sys_SolCancelaRNC
    Inherits BasePage

    Private Sub btnAceptar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        ''Validamos que los datos requeridos para esta certificacion sean correctos.
        'If Me.txtEmail.Text = String.Empty Then
        '    Me.lblMensaje.Visible = True
        '    Me.lblMensaje.Text = "El email es requerido para esta solicitud"
        '    Exit Sub
        'ElseIf Me.ctrlTelefono.PhoneNumber = String.Empty Then
        '    Me.lblMensaje.Visible = True
        '    Me.lblMensaje.Text = "El teléfono es requerido para esta solicitud."
        '    Exit Sub
        'ElseIf Me.txtRNC.Text = String.Empty Then
        '    Me.lblMensaje.Visible = True
        '    Me.lblMensaje.Text = "Se debe específicar el RNC a cancelar."
        '    Exit Sub
        'Else
        '    Me.lblMensaje.Visible = False
        'End If

        'Validamos que el RNC que se va a cancelar sea un RNC Valido
        If Not Empresas.Empleador.isRegistrado(Me.txtRncCancelar.Text) Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "El RNC específicado no es válido o no está registrado."
            Exit Sub
        Else
            Me.lblMensaje.Visible = False
        End If

        'Realizamos la solicitud
        Try
            Dim NumeroSolicitud As String
            Dim valor1 As String
            Dim valor2 As String
            Dim Res As String()

            NumeroSolicitud = SolicitudesEnLinea.Solicitudes.crearCancelacion(6, Me.txtRNC.Text, _
                Me.lblContacto.Text, Me.txtCargo.Text, Me.ctrlTelefono.PhoneNumber.Replace("-", ""), _
                "R", Me.txtMotivo.Text, Me.txtRncCancelar.Text, Nothing, Nothing, Me.ctrlFax.PhoneNumber.Replace("-", ""), Me.txtEmail.Text)

            Res = NumeroSolicitud.Split("|")
            valor1 = Res(0)
            valor2 = Res(1)

            If valor1 = "0" Then
                Response.Redirect("SolicitudCreada.aspx?id=" & valor2)
            Else
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = valor2
            End If
        Catch ex As Exception
            Response.Redirect("error.aspx?errMsg=" & ex.ToString())
        End Try

        Me.btnConsultar.Visible = True

    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Me.btnConsultar.Visible = False

        cargarInfo()

    End Sub

    Private Sub cargarInfo()

        If SuirPlus.SolicitudesEnLinea.Solicitudes.isRepresentanteEnEmpresa(Me.txtRNC.Text, Me.txtCedula.Text) Then

            Me.pnlCancelacionRNC.Visible = True

            Dim emp As New Empleador(Me.txtRNC.Text)
            Me.lblRNC.Text = emp.RNCCedula
            Utils.FormatearRNCCedula(Me.lblRNC.Text)
            Me.lblRazonSocial.Text = emp.RazonSocial
            Me.lblNombreComercial.Text = emp.NombreComercial
            Me.ctrlTelefono.PhoneNumber = emp.Telefono1
            Me.ctrlFax.PhoneNumber = emp.Fax
            Dim rep As New Representante(Me.lblRNC.Text, Me.txtCedula.Text)
            Me.txtEmail.Text = rep.Email
            Me.lblContacto.Text = rep.NombreCompleto

            Me.lblMensaje.Visible = False

        Else
            Me.btnConsultar.Visible = True
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "Esta cédula no es un representante para el empleador digitado."
        End If

    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.btnConsultar.Visible = True

        Response.Redirect("SolCancelaRnc.aspx")
    End Sub

End Class
