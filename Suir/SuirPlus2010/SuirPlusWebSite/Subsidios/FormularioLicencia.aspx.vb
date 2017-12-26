
Partial Class Subsidios_FormularioLicencia
    Inherits System.Web.UI.Page
    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        CargarDatos()
      
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

            End If

        Catch ex As Exception

            'TODO: logica de explosion

        End Try

    End Sub


End Class
