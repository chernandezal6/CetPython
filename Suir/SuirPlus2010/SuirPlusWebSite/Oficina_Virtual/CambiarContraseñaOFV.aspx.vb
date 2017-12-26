Imports System
Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios
Imports System.Data
Imports System.IO
Imports System.Linq

Partial Class Oficina_Virtual_CambiarContraseñaOFV
    Inherits SeguridadOFV

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        'Completar que redireccione a la oficina virtual
        Response.Redirect("OficinaVirtual.aspx")
    End Sub

    Protected Sub btnProceder_Click(sender As Object, e As EventArgs) Handles btnProceder.Click


        Dim resultado As String
        Dim resultado_final As String

        'Para curarnos en salud
        If Me.txtOldPassword.Text <> "" And Me.txtNewPassword.Text <> "" Then

            Try
                resultado = OficinaVirtual.OficinaVirtual.CambiarClassUserOFV(Me.UserNameOFV, Me.txtOldPassword.Text, Me.txtNewPassword.Text)

                If resultado.Contains("|") Then
                    resultado_final = resultado.Split("|")(1)

                Else
                    resultado_final = resultado
                End If
                If resultado = "0" Then
                    divMsjError.Visible = True
                    hfMostrarPopUp.Value = "Su contraseña fue cambiada correctamente "
                    'lbtnRegresar.Visible = True
                Else
                    divMsjError.Visible = True
                    lblMensaje.Text = resultado_final
                    ' lbtnRegresar.Visible = True
                End If
            Catch ex As Exception
                divMsjError.Visible = True
                lblMensaje.Text = ex.Message.ToString()
            End Try

        Else
            divMsjError.Visible = True
            btnOKPopUp.Visible = False
            hfMostrarPopUp.Value = "Favor llenar todos los campos"
            btnMsjPopUp.Visible = True
        End If

    End Sub

    Protected Sub btnOKPopUp_Click(sender As Object, e As EventArgs) Handles btnOKPopUp.ServerClick
        Response.Redirect("OficinaVirtual.aspx")
    End Sub

    Protected Sub btnMsjPopUp_ServerClick(sender As Object, e As EventArgs) Handles btnMsjPopUp.ServerClick
        Response.Redirect("CambiarContraseñaOFV.aspx")
    End Sub
End Class
