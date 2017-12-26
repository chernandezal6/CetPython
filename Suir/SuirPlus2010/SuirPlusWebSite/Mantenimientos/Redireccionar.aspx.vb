
Partial Class Mantenimientos_Redireccionar
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Convert.ToString(Request.QueryString("id")) = "1" Then
            Response.Redirect("AsignacionNSS.aspx?id_solicitud=" & Convert.ToString(Request.QueryString("id_solicitud")))
        Else
            Response.Redirect("mEvaluacionVisualActa.aspx?IdRow=" & Convert.ToString(Request.QueryString("IdRow")))
        End If
    End Sub
End Class
