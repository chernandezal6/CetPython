Imports SuirPlus
Partial Class Legal_SolicitudAcogerseLeyConfirmacion
    Inherits BasePage
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Me.lblNroSolicitud.Text = Request("id")
        Me.lblFecha.Text = DateTime.Now().ToString
        Me.lblRNC.Text = Request("rnc")

        Dim em As New Empresas.Empleador(Me.lblRNC.Text)
        Me.lblRazonSocial.Text = em.RazonSocial

    End Sub
    Protected Sub btProcesarOtra_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btProcesarOtra.Click
        Response.Redirect("SolicitudAcogerseLey.aspx")
    End Sub

End Class
