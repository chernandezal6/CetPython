Imports SuirPlus
Imports SuirPlus.SolicitudesEnLinea
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios

Partial Class Solicitudes_SolicitudInformacion
    Inherits BasePage

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents btnEnviar As System.Web.UI.WebControls.Button
    'Protected WithEvents Requiredfieldvalidator5 As System.Web.UI.WebControls.RequiredFieldValidator
    'Protected WithEvents txtDireccion As System.Web.UI.WebControls.TextBox
    'Protected WithEvents Requiredfieldvalidator4 As System.Web.UI.WebControls.RequiredFieldValidator
    'Protected WithEvents txtMotivo As System.Web.UI.WebControls.TextBox
    'Protected WithEvents Requiredfieldvalidator3 As System.Web.UI.WebControls.RequiredFieldValidator
    'Protected WithEvents txtinfosolicitada As System.Web.UI.WebControls.TextBox
    'Protected WithEvents txtCargo As System.Web.UI.WebControls.TextBox
    'Protected WithEvents txtInstitucion As System.Web.UI.WebControls.TextBox
    'Protected WithEvents lblCedula As System.Web.UI.WebControls.Label
    'Protected WithEvents lblSolicitante As System.Web.UI.WebControls.Label
    'Protected WithEvents lblSolicitud As System.Web.UI.WebControls.Label
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

    ' Protected WithEvents ctrlTelefono As UCTelefono
    ' Protected WithEvents ctrlCelular As UCTelefono
    Private Sub InicializaFromSession()
        If Convert.ToString(Session("IdTipoSolicitud")) = String.Empty Or _
           Convert.ToString(Session("CedulaRepresentate")) = String.Empty Then
            Response.Redirect("Solicitudes.aspx")
        End If
    End Sub

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Page.IsPostBack Then
            cargarInfo()
        End If
    End Sub

    Protected Sub cargarInfo()
        Dim nombreSolicitante As String = String.Empty
        Dim tipoDoc As String = String.Empty

        Me.lblSolicitud.Text = Session("TipoSolcitud")

        If Session("CedulaRepresentate").ToString.Length <> 11 Then
            tipoDoc = "P"
            Me.txtNroDocumento.Text = Session("CedulaRepresentate")
        Else
            tipoDoc = "C"
            Me.txtNroDocumento.Text = Utils.FormatearCedula(Session("CedulaRepresentate"))
        End If
        'nombreSolicitante = Utilitarios.TSS.getNombreCiudadano(tipoDoc, Session("CedulaRepresentate"))
        nombreSolicitante = Utilitarios.TSS.consultaCiudadano(tipoDoc, Session("CedulaRepresentate"))
        If nombreSolicitante.Split("|")(0) = "0" Then
            Me.txtNombreCompleto.Text = nombreSolicitante.Split("|")(1) + " " + nombreSolicitante.Split("|")(2)
        End If

    End Sub

    Private Sub btnEnviar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnEnviar.Click

        'Validamos que la info requerida sea obligatoria.
        Dim NumeroSolicitud As String
        Dim cblValor As String = String.Empty

        If txtNombreCompleto.Text = String.Empty Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "El nombre completo del solicitante es requerido"
            Exit Sub
        End If
        If Me.ctrlTelefono.PhoneNumber = String.Empty Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "El Número de teléfono es requerido"
            Exit Sub
        End If

        If txtinfosolicitada.Text = String.Empty Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "La información solicitada es requerida"
            Exit Sub
        End If

        If txtMotivo.Text = String.Empty Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "El motivo es requerido"
            Exit Sub
        End If

        If cblMedio.SelectedValue = Nothing Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "El medio para recibir la información es requerido"
            Exit Sub
        Else
            Dim contador As Integer = 0
            For Each item As ListItem In cblMedio.Items
                If item.Selected Then
                    contador = contador + 1
                    If contador > 1 Then
                        cblValor += ", " + item.Value
                    Else
                        cblValor += item.Value
                    End If
                End If
            Next
        End If

        Try
            NumeroSolicitud = SuirPlus.SolicitudesEnLinea.Solicitudes.crearSolicitudInformacion(txtNombreCompleto.Text, txtNroDocumento.Text, Me.txtDireccion.Text, Me.ctrlTelefono.PhoneNumber.Replace("-", ""),
                                                                                                Me.ctrlCelular.PhoneNumber.Replace("-", ""), Me.ctrlFax.PhoneNumber.Replace("-", ""), txtEmail.Text,
                                                                                                Me.txtInstitucion.Text, Me.txtCargo.Text, Me.txtinfosolicitada.Text, Me.txtMotivo.Text, txtAutoridad.Text, cblValor, txtLugar.Text, txtComentario.Text, UsrUserName)



            If NumeroSolicitud.Split("|")(0) = "0" Then
                Response.Redirect("confirmacion.aspx?id=" & NumeroSolicitud.Split("|")(1))
            Else
                Me.lblMensaje.Text = NumeroSolicitud.Split("|")(1)
            End If

        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

End Class
