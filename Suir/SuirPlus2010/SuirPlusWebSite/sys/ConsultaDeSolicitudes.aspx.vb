Partial Class sys_ConsultaDeSolicitudes
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Put user code to initialize the page here
    End Sub

    Private Sub btBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btBuscar.Click

        'validar si existe la solicitud y si existe llenar los labels sino presentar un mensaje
        If SuirPlus.SolicitudesEnLinea.Solicitudes.isExisteIdSolicitud(Me.txtNroSolicitud.Text) Then
            Me.pnlSolicitudes.Visible = True
            Dim dt As System.Data.DataTable = SuirPlus.SolicitudesEnLinea.Solicitudes.getSolicitud(Me.txtNroSolicitud.Text)

            Me.lblNroSolicitud.Text = Me.txtNroSolicitud.Text
            Me.lblTipoSolicitud.Text = Convert.ToString(dt.Rows(0)("Descripcion_Status"))
            Me.lblRazonSocial.Text = Convert.ToString(dt.Rows(0)("Razon_Social"))
            Me.lblSolicitante.Text = Convert.ToString(dt.Rows(0)("Solicitante"))
            Me.lblComentarios.Text = Convert.ToString(dt.Rows(0)("Comentarios"))
            Me.lblMensaje.Visible = False
        Else
            Me.pnlSolicitudes.Visible = False
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "Registro No existe"
        End If


    End Sub
End Class
