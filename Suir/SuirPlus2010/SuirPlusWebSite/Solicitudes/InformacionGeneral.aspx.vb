Imports SuirPlus
Imports SuirPlus.SolicitudesEnLinea
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios

Partial Class Solicitudes_InformacionGeneral
    Inherits BasePage
    'Protected WithEvents ctrlTelefono As UCTelefono
    'Protected WithEvents lblProvincia As System.Web.UI.WebControls.Label
    'Protected WithEvents ctrlFax As UCTelefono

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents btnEnviar As System.Web.UI.WebControls.Button
    'Protected WithEvents lblMensaje As System.Web.UI.WebControls.Label
    'Protected WithEvents lblSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents lblRNC As System.Web.UI.WebControls.Label
    'Protected WithEvents lblRazonSocial As System.Web.UI.WebControls.Label
    'Protected WithEvents lblNombreComercial As System.Web.UI.WebControls.Label
    'Protected WithEvents lblCedRepresentante As System.Web.UI.WebControls.Label
    'Protected WithEvents lblRepresentante As System.Web.UI.WebControls.Label
    'Protected WithEvents txtMotivo As System.Web.UI.WebControls.TextBox

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
        Convert.ToString(Session("IDProvincia")) = String.Empty Or _
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
        Me.lblProvincia.Text = Session("Provincia")
        Me.lblCedRepresentante.Text = Utils.FormatearCedula(Session("CedulaRepresentate"))
        Me.lblRepresentante.Text = Utilitarios.TSS.getNombreCiudadano("C", Session("CedulaRepresentate"))
        Dim emp As New Empleador(Me.lblRNC.Text)
        Me.lblRazonSocial.Text = emp.RazonSocial
        Me.lblNombreComercial.Text = emp.NombreComercial

    End Sub

    Private Sub btnEnviar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnEnviar.Click

        'Validamos que los datos requeridos.
        If Me.ctrlFax.PhoneNumber = String.Empty And ctrlTelefono.PhoneNumber = String.Empty Then
            Me.lblMensaje.Text = "Se requiere al menos un teléfono para esta solicitud."
            Me.lblMensaje.Visible = True
            Exit Sub
        End If

        If Me.txtMotivo.Text = String.Empty Then
            Me.lblMensaje.Text = "Se requiere el motivo de esta solicitud."
            Me.lblMensaje.Visible = True
            Exit Sub
        End If

        Dim idTipoSolicitud As String = Session("IdTipoSolicitud")
        Dim cedulaRep As String = Session("CedulaRepresentate")
        Dim idProvincia As String = Session("IDProvincia")
        Dim idSolicitud As String = String.Empty

        Try

            idSolicitud = SolicitudesEnLinea.Solicitudes.crearSolicitudInformacionGral(Me.lblRNC.Text, _
             cedulaRep, Me.txtMotivo.Text, Me.ctrlTelefono.PhoneNumber.Replace("-", ""), _
             Me.ctrlFax.PhoneNumber.Replace("-", ""), idProvincia, Nothing, MyBase.UsrUserName)

            If idSolicitud.Split("|")(0) = "0" Then
                'Confirmamos.
                Response.Redirect("confirmacion.aspx?id=" & idSolicitud.Split("|")(1))
            Else
                Me.lblMensaje.Text = idSolicitud.Split("|")(1)
                Me.lblMensaje.Text = idSolicitud
            End If
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Response.Redirect("error.aspx?errMsg=" & ex.ToString())
        End Try

    End Sub

End Class
