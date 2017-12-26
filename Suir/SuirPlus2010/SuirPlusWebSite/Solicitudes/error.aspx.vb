
Partial Class Solicitudes_error
    Inherits BasePage

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    ' Protected WithEvents btnErrorCargaArchivo As System.Web.UI.WebControls.Button
    ' Protected WithEvents lblError As System.Web.UI.WebControls.Label

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Request.QueryString("errMsg") <> Nothing Then
            Me.lblError.Text = Request.QueryString("errMsg")
        Else
            Response.Redirect("SolicitudIntro.aspx")
        End If

    End Sub

    Private Sub btnErrorCargaArchivo_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnErrorCargaArchivo.Click
        Response.Redirect("SolicitudIntro.aspx")
    End Sub
End Class

