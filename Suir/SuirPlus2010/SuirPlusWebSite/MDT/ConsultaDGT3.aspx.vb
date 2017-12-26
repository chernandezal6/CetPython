
Partial Class MDT_ConsultaDGT3
    Inherits BasePage


    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

    End Sub


    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        If txtRNC.Text <> String.Empty Then
            gvDatos.DataSource = SuirPlus.MDT.General.ConsultaDGT3(txtRNC.Text)
            gvDatos.DataBind()

            If gvDatos.Rows.Count <= 1 Then
                lblMensaje.Text = SuirPlus.MDT.General.ConsultaDGT3(txtRNC.Text).ToString()
            Else
                lblMensaje.Text = String.Empty

            End If

            For Each item As GridViewRow In gvDatos.Rows

                Dim objImg As Image = CType(item.FindControl("imgSaved"), Image)

                If item.Cells(1).Text.TrimEnd() <> String.Empty And item.Cells(1).Text <> "&nbsp;" Then
                    objImg.ImageUrl = "../images/Aproval.png"
                Else
                    objImg.ImageUrl = "../images/Cancelar.png"
                End If

            Next

            gvDatos.Columns(1).Visible = False

        Else
            lblMensaje.Text = "Debe ingresar el RNC de la empresa para realizar la busqueda."
        End If
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        Response.Redirect("ConsultaDGT3.aspx")

    End Sub
End Class
