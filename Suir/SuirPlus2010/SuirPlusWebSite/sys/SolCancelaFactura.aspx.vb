Imports SuirPlus
Imports SuirPlus.SolicitudesEnLinea
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios

Partial Class sys_SolCancelaFactura
    Inherits BasePage

    '    Protected WithEvents ctrlTelefono1 As UCTelefono
    '   Protected WithEvents ctrlFax As UCTelefono


    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Me.btnConsultar.Visible = False
        cargarInfo()

    End Sub

    Private Sub cargarInfo()

        If SuirPlus.SolicitudesEnLinea.Solicitudes.isRepresentanteEnEmpresa(Me.txtRNC.Text, Me.txtCedula.Text) Then

            Me.pnlInfoGeneral.Visible = True
            Me.pnlfacturas.Visible = True

            Dim emp As New Empleador(Me.txtRNC.Text)
            Me.lblRNC.Text = emp.RNCCedula
            Utils.FormatearRNCCedula(Me.lblRNC.Text)
            Me.lblRazonSocial.Text = emp.RazonSocial
            Me.lblNombreComercial.Text = emp.NombreComercial
            Me.ctrlTelefono1.PhoneNumber = emp.Telefono1
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
        Response.Redirect("SolCancelaFactura.aspx")
    End Sub

    Private Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click
        'Validamos que los nro. de notificacion puesto en los textbox sean validos.
        For i As Int16 = 1 To 8

            Dim txtNotificacion As TextBox = CType(pnlfacturas.FindControl("txtNotificacion" & i.ToString()), TextBox)

            If Not txtNotificacion.Text = String.Empty Then

                'Si se cololo un nro. de referencia verificamos si se coloco lo que se desea cancelar.
                Dim rbtnRecargos As RadioButton = CType(pnlfacturas.FindControl("rbtnRecargos" & i.ToString()), RadioButton)
                Dim rbtnFacturas As RadioButton = CType(pnlfacturas.FindControl("rbtnFactura" & i.ToString()), RadioButton)

                If Not rbtnRecargos.Checked And Not rbtnFacturas.Checked Then

                    Me.lblMensaje.Visible = True
                    Me.lblMensaje.Text = "favor específicar el tipo de cancelación (Recargo/Factura) en la línea " & i.ToString()
                    Exit Sub

                End If

                'Verificamos que el Nro. de referencia sea valido
                If Not Facturacion.FacturaSS.isReferenciaValida(txtNotificacion.Text, Me.lblRNC.Text) Then
                    Me.lblMensaje.Visible = True
                    Me.lblMensaje.Text = "El Nro. de referencia de la linea " & i.ToString() & " es inválido."
                    Exit Sub
                End If

            End If

        Next



        'Insertamos la solicitud
        Try

            Dim idSolicitud As String = String.Empty
            idSolicitud = SolicitudesEnLinea.Solicitudes.crearCancelacion(5, Me.lblRNC.Text, _
             Me.lblContacto.Text, Me.txtCargo.Text, Me.ctrlTelefono1.PhoneNumber.Replace("-", ""), "F", _
             Me.txtMotivo.Text, Nothing, Nothing, Nothing, Me.ctrlFax.PhoneNumber.Replace("-", ""), Me.txtEmail.Text)

            'El idSolicitud viene acompañado de un error o un cero si todo marcho bien.
            If idSolicitud.Split("|")(0) = "0" Then

                idSolicitud = idSolicitud.Split("|")(1)
                Dim tipoCancelacion As String = String.Empty

                'Si la solicitud se creo correctamente insertamos el detalle.
                For i As Int16 = 1 To 8
                    Dim txtNotificacion As TextBox = CType(pnlfacturas.FindControl("txtNotificacion" & i.ToString()), TextBox)
                    Dim rbtnRecargos As RadioButton = CType(pnlfacturas.FindControl("rbtnRecargos" & i.ToString()), RadioButton)

                    If rbtnRecargos.Checked Then
                        tipoCancelacion = "R"
                    Else
                        tipoCancelacion = "F"
                    End If

                    SolicitudesEnLinea.Solicitudes.crearDetCancelacion(idSolicitud, txtNotificacion.Text, tipoCancelacion)

                Next

                Response.Redirect("SolicitudCreada.aspx?id=" & idSolicitud)

            Else
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = idSolicitud.Split("|")(2)
            End If

        Catch ex As Exception
            Response.Redirect("error.aspx?errMsg=" & ex.ToString())
        End Try

        Me.btnConsultar.Visible = True

    End Sub
End Class
