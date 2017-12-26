
Partial Class Solicitudes_ConsultaSolicitud
    Inherits BasePage

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents btnConsultar As System.Web.UI.WebControls.Button
    'Protected WithEvents RequiredFieldValidator1 As System.Web.UI.WebControls.RequiredFieldValidator
    'Protected WithEvents txtIDSolicitud As System.Web.UI.WebControls.TextBox
    'Protected WithEvents btnCancelar As System.Web.UI.WebControls.Button
    'Protected WithEvents lblMensaje As System.Web.UI.WebControls.Label

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    'Protected WithEvents ctrlSolicitud As ucSolicitud

    Private IdSolicitud As String

    Dim rnc As String
    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        rnc = Session("rnc")

        If Not Request.QueryString("IdSolicitud") = String.Empty Then
            Me.txtIDSolicitud.Text = Request.QueryString("IdSolicitud")
            Me.btnConsultar_Click(Me, Nothing)
        End If

    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click

        'Validamos que el ID solicitud no este en blanco.
        If Me.txtIDSolicitud.Text = String.Empty Then
            Me.lblMensaje.Text = "Nro. solicitud es requerido."
            Exit Sub
        End If

        'Validamos que la solicitud exista antes de mostrar la consulta.
        If Not SuirPlus.SolicitudesEnLinea.Solicitudes.isExisteIdSolicitud(Me.txtIDSolicitud.Text) Then
            Me.lblMensaje.Text = "Nro. solicitud inválido."
        Else
            ctrlSolicitud.NroSolicitud = Me.txtIDSolicitud.Text
            ctrlSolicitud.Visible = True
            ctrlSolicitud.Mostrar()
        End If

    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Response.Redirect("ConsultaByRNC.aspx?rnc=" & rnc)
        'Response.Redirect("consultaSolicitud.aspx")
    End Sub
End Class
