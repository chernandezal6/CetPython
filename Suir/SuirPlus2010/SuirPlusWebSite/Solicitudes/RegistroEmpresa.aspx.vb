Imports SuirPlus
Imports SuirPlus.SolicitudesEnLinea
Imports SuirPlus.Utilitarios

Partial Class Solicitudes_RegistroEmpresa
    Inherits BasePage
#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents lblSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents lblRnc As System.Web.UI.WebControls.Label
    'Protected WithEvents txtRazonSocial As System.Web.UI.WebControls.TextBox
    'Protected WithEvents txtNombreComercial As System.Web.UI.WebControls.TextBox
    'Protected WithEvents lblRepresentante As System.Web.UI.WebControls.Label
    'Protected WithEvents btnCrear As System.Web.UI.WebControls.Button
    'Protected WithEvents lblCedRepresentante As System.Web.UI.WebControls.Label
    'Protected WithEvents RequiredFieldValidator1 As System.Web.UI.WebControls.RequiredFieldValidator
    'Protected WithEvents RequiredFieldValidator2 As System.Web.UI.WebControls.RequiredFieldValidator
    'Protected WithEvents lblMensaje As System.Web.UI.WebControls.Label
    'Protected WithEvents txtComentario As System.Web.UI.WebControls.TextBox

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
        InicializaFromSession()
    End Sub

#End Region

    'Protected WithEvents ctrlTelefono1 As UCTelefono
    'Protected WithEvents ctrlTelefono2 As UCTelefono
    Protected RazonSocial As String = String.Empty
    Protected idSolicitud As String = String.Empty

    Private Sub InicializaFromSession()

        If Convert.ToString(Session("RNCEmpleador")) = String.Empty Then
            Response.Redirect("Solicitudes.aspx")
        Else
            Me.lblSolicitud.Text = Session("TipoSolcitud")
            Me.lblRnc.Text = Session("RNCEmpleador")
            Me.lblCedRepresentante.Text = Utils.FormatearCedula(Session("CedulaRepresentate"))
        End If

    End Sub

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not Page.IsPostBack Then

            'Buscamos el nombre del representante en ciudadanos.
            Me.lblRepresentante.Text = Utilitarios.TSS.getNombreCiudadano("C", Session("CedulaRepresentate"))

            'Buscamos la razon social en DGII del RNC
            RazonSocial = Empresas.Empleador.getRazonSocialEnDGII(Session("RNCEmpleador"))

            'Verificamos que no vaga en el error 179
            If RazonSocial.Split("|")(0) <> "179" Then
                Me.txtRazonSocial.Text = RazonSocial
            End If

        End If

    End Sub

    Private Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.PreRender

        If Me.txtRazonSocial.Text <> String.Empty Then
            Me.txtRazonSocial.Enabled = False
        End If

    End Sub

    Private Sub btnCrear_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCrear.Click

        'Realizamos las validaciones del lado del servidor.
        If Me.txtRazonSocial.Text.Trim = String.Empty Then
            Me.lblMensaje.Text = "La razón social es requerida."
            Exit Sub
        ElseIf Me.txtNombreComercial.Text = String.Empty Then
            Me.lblMensaje.Text = "El nombre comercial es requerido."
            Exit Sub
        ElseIf Me.ctrlTelefono1.PhoneNumber = String.Empty And Me.ctrlTelefono2.PhoneNumber = String.Empty Then
            Me.lblMensaje.Text = "Se requiere un teléfono"
            Exit Sub
        ElseIf ctrlTelefono1.PhoneNumber = Me.ctrlTelefono2.PhoneNumber Then
            Me.lblMensaje.Text = "El teléfono1 y el teléfono2 deben ser diferente."
            Exit Sub
        End If

        Dim RNC As String = Session("RNCEmpleador")
        Dim CedulaRep As String = Session("CedulaRepresentate")
        Dim razonSocial As String = Me.txtRazonSocial.Text
        Dim nombreComercial As String = Me.txtNombreComercial.Text
        Dim telefono1 As String = Me.ctrlTelefono1.PhoneNumber
        Dim telefono2 As String = Me.ctrlTelefono2.PhoneNumber
        Dim comentario As String = Me.txtComentario.Text

        'Si todas las validaciones estas correctas, registramos la emrpesa.
        Try
            idSolicitud = SolicitudesEnLinea.Solicitudes.crearRegistroEmpresa(RNC, razonSocial, _
            nombreComercial, CedulaRep, telefono1.Replace("-", ""), telefono2.Replace("-", ""), comentario, MyBase.UsrUserName)

            If idSolicitud.Split("|")(0) = "0" Then
                Response.Redirect("confirmacion.aspx?id=" & idSolicitud.Split("|")(1))
            Else
                Me.lblMensaje.Text = idSolicitud.Split("|")(1)
            End If

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Response.Redirect("error.aspx?errMsg=" & ex.ToString())
        End Try

    End Sub

End Class
