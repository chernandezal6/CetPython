Partial Class Solicitudes_SolConsultaNSS
    Inherits BasePage

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents lblInfo As System.Web.UI.WebControls.Label
    'Protected WithEvents Label1 As System.Web.UI.WebControls.Label
    'Protected WithEvents Label2 As System.Web.UI.WebControls.Label
    'Protected WithEvents lblAdios As System.Web.UI.WebControls.Label
    'Protected WithEvents Button1 As System.Web.UI.HtmlControls.HtmlInputButton

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

        Dim inf As String = SuirPlus.Utilitarios.TSS.consultaCiudadano("C", Session("CedulaRepresentate"))

        Dim Informacion As String() = inf.Split("|")

        Dim msg As String
        If Informacion.Length > 2 Then

            msg = "Señor/Señora: " & Informacion(1) & " " & Informacion(2) & ", su número de seguridad social es: " & Informacion(3) & ". "

        Else
            msg = Informacion(1)

        End If

        Me.lblInfo.Text = msg

        Me.lblAdios.Text = MyBase.UsrNombreCompleto & " le asistió tenga un feliz resto del día!"
    End Sub

    Private Sub Button1_ServerClick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.ServerClick
        Response.Redirect("Solicitudes.aspx")
    End Sub
End Class
