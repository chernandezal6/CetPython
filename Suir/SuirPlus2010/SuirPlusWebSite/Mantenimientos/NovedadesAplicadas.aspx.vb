
Partial Class Novedades_NovedadesAplicadas
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.Label1.Text = Request.QueryString("msg")

        Session("dtLactantes") = Nothing


    End Sub

End Class
