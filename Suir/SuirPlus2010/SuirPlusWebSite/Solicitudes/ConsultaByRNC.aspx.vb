
Partial Class Solicitudes_ConsultaByRNC
    Inherits BasePage

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents lblMensaje As System.Web.UI.WebControls.Label
    'Protected WithEvents btnCancelar As System.Web.UI.WebControls.Button
    'Protected WithEvents btnConsultar As System.Web.UI.WebControls.Button
    'Protected WithEvents txtRNC As System.Web.UI.WebControls.TextBox
    'Protected WithEvents RegularExpressionValidator2 As System.Web.UI.WebControls.RegularExpressionValidator
    'Protected WithEvents RequiredFieldValidator1 As System.Web.UI.WebControls.RequiredFieldValidator
    'Protected WithEvents pnlResultados As System.Web.UI.WebControls.Panel

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    'Protected WithEvents ctrlByRNC As ucSolicitudByRNC
    Dim rnc As String = String.Empty

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        Me.divSolicitud.Visible = False
        ctrlByRNC.Ocultar()

        'Put user code to initialize the page here
        rnc = Request.QueryString("rnc")
        If Not rnc = String.Empty Then
            Me.txtRNC.Text = rnc
            btnConsultar_Click(sender, e)
        End If

    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click

        'Validamos
        Try

            If Me.txtRNC.Text = String.Empty Then
                Me.lblMensaje.Text = "El RNC o Cédula es requerido."
                Exit Sub
            End If

            If Not System.Text.RegularExpressions.Regex.IsMatch(Me.txtRNC.Text, "^(\d{9}|\d{11})$") Then
                Me.lblMensaje.Text = "El RNC o Cédula es inválido. Trate Nuevamente."
                Me.lblRazonSocial.Text = ""
                Me.lblNombreComercial.Text = ""
                Exit Sub
            End If

            Dim dt As System.Data.DataTable = SuirPlus.Empresas.Empleador.getEmpleadorDatos(Me.txtRNC.Text)
            If dt.Rows.Count <= 0 Then
                Me.lblMensaje.Text = "El RNC o Cédula es inválido. Trate Nuevamente."
                Me.lblRazonSocial.Text = ""
                Me.lblNombreComercial.Text = ""
                dt.Dispose()
                Exit Sub
            Else
                Me.lblRazonSocial.Text = dt.Rows(0)("Razon_Social").ToString()
                Me.lblNombreComercial.Text = dt.Rows(0)("Nombre_Comercial").ToString()
                Me.divSolicitud.Visible = True
                dt.Dispose()
            End If

            ctrlByRNC.RNC = Me.txtRNC.Text
            ctrlByRNC.Mostrar()

            'Me.divResultados.Visible = True

            Session("rnc") = Me.txtRNC.Text

        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            'Me.pnlResultados.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Response.Redirect("SolicitudIntro.aspx")
    End Sub
End Class
