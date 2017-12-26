Imports SuirPlus
Imports SuirPlus.SolicitudesEnLinea
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios

Partial Class Solicitudes_CancelaRNC
    Inherits BasePage

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents btnAceptar As System.Web.UI.WebControls.Button
    'Protected WithEvents ValidationSummary1 As System.Web.UI.WebControls.ValidationSummary
    'Protected WithEvents lblMensaje As System.Web.UI.WebControls.Label
    'Protected WithEvents txtMotivo As System.Web.UI.WebControls.TextBox
    'Protected WithEvents RequiredFieldValidator2 As System.Web.UI.WebControls.RequiredFieldValidator
    'Protected WithEvents txtCargo As System.Web.UI.WebControls.TextBox
    'Protected WithEvents lblContacto As System.Web.UI.WebControls.Label
    'Protected WithEvents RequiredFieldValidator1 As System.Web.UI.WebControls.RequiredFieldValidator
    'Protected WithEvents RegularExpressionValidator1 As System.Web.UI.WebControls.RegularExpressionValidator
    'Protected WithEvents txtEmail As System.Web.UI.WebControls.TextBox
    'Protected WithEvents lblRNC As System.Web.UI.WebControls.Label
    'Protected WithEvents lblRazonSocial As System.Web.UI.WebControls.Label
    'Protected WithEvents lblSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents txtRNC As System.Web.UI.WebControls.TextBox

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    'Protected WithEvents ctrlTelefono As UCTelefono
    'Protected WithEvents ctrlFax As UCTelefono

    Private Sub InicializaFromSession()

        If Convert.ToString(Session("RNCEmpleador")) = String.Empty Or _
        Convert.ToString(Session("IdTipoSolicitud")) = String.Empty Or _
        Convert.ToString(Session("CedulaRepresentate")) = String.Empty Then
            Response.Redirect("Solicitudes.aspx")
        End If

    End Sub

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Page.IsPostBack Then
            cargarInfo()
        End If
    End Sub

    Private Sub cargarInfo()

        Me.lblSolicitud.Text = Session("TipoSolcitud")
        Me.lblRNC.Text = Session("RNCEmpleador")

        Try
            Dim emp As New Empleador(Me.lblRNC.Text)
            Me.lblRazonSocial.Text = emp.RazonSocial
            Me.ctrlTelefono.PhoneNumber = emp.Telefono1
            Me.ctrlFax.PhoneNumber = emp.Fax
            Dim rep As New Representante(Me.lblRNC.Text, Convert.ToString(Session("CedulaRepresentate")))
            Me.txtEmail.Text = rep.Email
            Me.lblContacto.Text = rep.NombreCompleto
        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub btnAceptar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        'Validamos que los datos requeridos para esta certificacion sean correctos.
        If Me.txtEmail.Text = String.Empty Then
            Me.lblMensaje.Text = "El email es requerido para esta solicitud"
            Exit Sub
        ElseIf Me.ctrlTelefono.PhoneNumber = String.Empty Then
            Me.lblMensaje.Text = "El teléfono es requerido para esta solicitud."
            Exit Sub
        ElseIf Me.txtRNC.Text = String.Empty Then
            Me.lblMensaje.Text = "Se debe específicar el RNC a cancelar."
            Exit Sub
        End If

        'Validamos que el RNC que se va a cancelar sea un RNC Valido
        If Not Empresas.Empleador.isRegistrado(Me.txtRNC.Text) Then
            Me.lblMensaje.Text = "El RNC específicado no es válido o no esta registrado."
            Exit Sub
        End If

        'Realizamos la solicitud
        Try
            Dim idSolicitud As String = String.Empty

            idSolicitud = SolicitudesEnLinea.Solicitudes.crearCancelacion(6, Me.lblRNC.Text, _
            Me.lblContacto.Text, Me.txtCargo.Text, Me.ctrlTelefono.PhoneNumber.Replace("-", ""), _
            "R", Me.txtMotivo.Text, Me.txtRNC.Text, Nothing, MyBase.UsrUserName, Me.ctrlFax.PhoneNumber.Replace("-", ""), Me.txtEmail.Text)

            If idSolicitud.Split("|")(0) = "0" Then
                Response.Redirect("confirmacion.aspx?id=" & idSolicitud.Split("|")(1))
            Else
                Me.lblMensaje.Text = idSolicitud.Split("|")(1)
                Exit Sub
            End If
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Response.Redirect("error.aspx?errMsg=" & ex.Message)
        End Try

    End Sub

End Class
