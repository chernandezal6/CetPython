
Partial Class Mantenimientos_RegistroCiudadanoTitular
    Inherits BasePage

    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click
        Try
            Me.lblMsg.ForeColor = Drawing.Color.Red
            If (txtNombres.Text = String.Empty Or IsNumeric(txtNombres.Text)) Then
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "La razón social del centro es inválida"
                Exit Sub
            End If

            If (txtNombrePadre.Text = String.Empty Or Not IsNumeric(txtNombrePadre.Text)) Then
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "El RNC del centro es inválido"
                Exit Sub
            End If

            RegistrarCiudadano()
            txtNombres.Text = String.Empty
            txtNombrePadre.Text = String.Empty
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = "El ciudadano titular ha sido registrado correctamente!"
            Me.lblMsg.ForeColor = Drawing.Color.Blue


        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub


    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.Response.Redirect("RegistroCiudadanoTitular.aspx")
    End Sub

    Protected Sub RegistrarCiudadano()

        Try
            SuirPlus.Mantenimientos.Mantenimientos.RegistroCiudadanoTitular(Me.txtNombres.Text, Me.txtNombrePadre.Text, UsrUserName)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

End Class
