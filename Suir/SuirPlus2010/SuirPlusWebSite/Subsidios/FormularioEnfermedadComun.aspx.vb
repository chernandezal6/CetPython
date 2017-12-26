Imports SuirPlus.Utilitarios.Utils
Partial Class Novedades_sfsFormularioEnfermedadComun
    Inherits System.Web.UI.Page
    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        If Not IsPostBack Then
            CargarDatos()
        End If

    End Sub
    Private Sub CargarDatos()

        Try
            If Not IsNothing(Request.QueryString) Then

                Me.lblFechaEmision.Text = Date.Today.ToShortDateString()
                Me.lblNumeroFormulario.Text = SuirPlus.Empresas.SubsidiosSFS.EnfermedadComun.unhashValores(Request.QueryString("hash").ToString())
                Me.lblNombreAfiliado.Text = HttpUtility.UrlDecode(Request.QueryString("nombre").ToString())
                Me.lblCedulaAfiliado.Text = Request.QueryString("cedula").ToString()
                Me.lblNSS.Text = Request.QueryString("nss").ToString()
                Me.lblHash.Text = Request.QueryString("hash").ToString()
                Me.ckF.Checked = Request.QueryString("sexo").ToString().Equals("Femenino")
                Me.ckM.Checked = Request.QueryString("sexo").ToString().Equals("Masculino")
                Me.ckPrimeraSolicitud.Checked = Request.QueryString("tipoSolicitud").ToString().Equals("Nueva")
                Me.ckRenovacion.Checked = Request.QueryString("tipoSolicitud").ToString().Equals("Renovacion")

            End If

        Catch ex As Exception

            'TODO: logica de explosion

        End Try

    End Sub

End Class
