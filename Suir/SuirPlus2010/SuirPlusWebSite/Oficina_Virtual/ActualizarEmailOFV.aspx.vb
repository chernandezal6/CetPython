Imports System
Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios
Imports System.Data
Imports System.IO
Imports System.Linq


Partial Class Oficina_Virtual_ActualizarEmailOFV
    Inherits SeguridadOFV


    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        Response.Redirect("OficinaVirtual.aspx")
    End Sub

    Protected Sub btnProceder_Click(sender As Object, e As EventArgs) Handles btnProceder.Click
        Dim resultado As String
        Dim resultado_final As String

        Try
            resultado = OficinaVirtual.OficinaVirtual.CambiarEmailOFV(Me.UserNameOFV, Me.txtEmailAnterior.Text, Me.txtEmailNuevo.Text)

            If resultado.Contains("|") Then
                resultado_final = resultado.Split("|")(1)
            Else
                resultado_final = resultado
            End If
            If resultado = "0" Then
                divMsjError.Visible = True
                hfMostrarPopUp.Value = "Su correo electrónico fue cambiado satisfactoriamente. "
                ' lbtnRegresar.Visible = True
                lblMensaje.Text = String.Empty
                divChangePassword.Visible = False
                DivCaptchaButtons.Visible = False
            Else
                divMsjError.Visible = True
                lblMensaje.Text = resultado_final
                'lbtnRegresar.Visible = True
            End If
        Catch ex As Exception
            divMsjError.Visible = True
            lblMensaje.Text = ex.Message.ToString()
        End Try

    End Sub

    'Protected Sub lbtnRegresar_Click(sender As Object, e As EventArgs) Handles lbtnRegresar.Click
    '    Response.Redirect("OficinaVirtual.aspx")
    'End Sub

    Protected Sub btnOKPopUp_ServerClick(sender As Object, e As EventArgs) Handles btnOKPopUp.ServerClick
        Response.Redirect("OficinaVirtual.aspx")
    End Sub
End Class
