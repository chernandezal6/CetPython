Imports System.Data
Imports SuirPlus

Partial Class VerificarCertificacion
    Inherits BasePage

    Protected Sub btBuscarRef_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btBuscarRef.Click

        Try

            Dim dt As New DataTable
            If Not String.IsNullOrEmpty(txtcodigo.Text) And Not String.IsNullOrEmpty(txtPin.Text) Then

                dt = Empresas.Certificaciones.getIdCertificacion(txtcodigo.Text, txtPin.Text)

                If dt.Rows.Count > 0 Then
                    hfNumeroFormulario.Value = Convert.ToBase64String(Encoding.ASCII.GetBytes(dt.Rows(0)("ID_CERTIFICACION").ToString().ToCharArray()))
                Else
                    lblError.Text = "No existen registros para esta busqueda!!."
                    lblError.Visible = True
                End If

                Me.txtcodigo.Enabled = False
                Me.txtPin.Enabled = False
                Me.btBuscarRef.Enabled = False
            Else
                lblError.Text = "Ambos valores son requeridos."
                lblError.Visible = True
            End If
        Catch ex As Exception
            lblError.Text = ex.Message
            lblError.Visible = True
        End Try

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.limpiar()
    End Sub

    Private Sub limpiar()
        Response.Redirect("VerificarCertificacion.aspx")
    End Sub

End Class
