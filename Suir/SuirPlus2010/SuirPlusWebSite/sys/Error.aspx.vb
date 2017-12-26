
Partial Class sys_Error
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Request.QueryString("errMsg") <> Nothing Then
            Me.lblError.Text = Request.QueryString("errMsg")
        Else
            Me.lblError.Text = "Ha ocurrido un error en el Sistema. Favor contactar a suirplus@tss.gov.do"
        End If
    End Sub
End Class
