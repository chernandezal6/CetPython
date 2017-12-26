Imports SuirPlus
Imports SuirPlus.SolicitudesEnLinea
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios

Partial Class Solicitudes_FacturasViaMail
    Inherits BasePage

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents btnCrear As System.Web.UI.WebControls.Button
    'Protected WithEvents lblMensaje As System.Web.UI.WebControls.Label
    'Protected WithEvents txtComentario As System.Web.UI.WebControls.TextBox
    'Protected WithEvents lblRepresentante As System.Web.UI.WebControls.Label
    'Protected WithEvents lblCedRepresentante As System.Web.UI.WebControls.Label
    'Protected WithEvents lblNombreComercial As System.Web.UI.WebControls.Label
    'Protected WithEvents lblRazonSocial As System.Web.UI.WebControls.Label
    'Protected WithEvents lblRnc As System.Web.UI.WebControls.Label
    'Protected WithEvents lblSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents txtEmail As System.Web.UI.WebControls.TextBox
    'Protected WithEvents txtCfonfirmaEmail As System.Web.UI.WebControls.TextBox
    'Protected WithEvents CompareValidator1 As System.Web.UI.WebControls.CompareValidator
    'Protected WithEvents RegularExpressionValidator1 As System.Web.UI.WebControls.RegularExpressionValidator
    'Protected WithEvents RegularExpressionValidator2 As System.Web.UI.WebControls.RegularExpressionValidator
    'Protected WithEvents lblEmail As System.Web.UI.WebControls.Label
    'Protected WithEvents lblBefore As System.Web.UI.WebControls.Label
    'Protected WithEvents lblAfter As System.Web.UI.WebControls.Label

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
        Me.lblRnc.Text = Session("RNCEmpleador")
        Me.lblCedRepresentante.Text = Utils.FormatearCedula(Session("CedulaRepresentate"))
        Me.lblRepresentante.Text = Utilitarios.TSS.getNombreCiudadano("C", Session("CedulaRepresentate"))
        Dim emp As New Empleador(Me.lblRnc.Text)
        Me.lblRazonSocial.Text = emp.RazonSocial
        Me.lblNombreComercial.Text = emp.NombreComercial
        Dim rep As New Representante(Me.lblRnc.Text, Session("CedulaRepresentate"))
        Me.lblEmail.Text = rep.Email

        If Me.lblEmail.Text.Length <= 1 Then
            Me.lblBefore.Text = ""
            Me.lblAfter.Text = ""
            Me.lblEmail.Text = "Por favor dígame su correo electrónico donde desea recibir su factura."
        End If

    End Sub

    Private Sub btnCrear_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCrear.Click

        If Me.lblEmail.Text = String.Empty And Me.txtEmail.Text = String.Empty Then
            Me.lblMensaje.Text = "El correo electrónico es requerido en esta solicitud."
            Exit Sub
        End If

        If Me.txtEmail.Text <> Me.txtCfonfirmaEmail.Text Then
            Me.lblMensaje.Text = "La confirmación del correo debe ser igual al nuevo correo."
            Exit Sub
        End If

        Dim idTipoSolicitud As String = Session("IdTipoSolicitud")
        Dim cedulaRep As String = Session("CedulaRepresentate")
        Dim idSolicitud As String = String.Empty

        Try
            idSolicitud = SolicitudesEnLinea.Solicitudes.crearSolicitud(idTipoSolicitud, 0, Me.lblRnc.Text, cedulaRep, MyBase.UsrUserName, txtComentario.Text)
            If idSolicitud.Split("|")(0) = "0" Then

                If Not Me.txtEmail.Text = String.Empty Then
                    'Actualizamos el correo del reprentante.
                    Dim rep As New Representante(Me.lblRnc.Text, Session("CedulaRepresentate"))
                    rep.Email = Me.txtEmail.Text
                    rep.GuardarCambios(MyBase.UsrUserName)
                End If

                'Confirmamos.
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
