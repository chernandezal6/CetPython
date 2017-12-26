
Partial Class Empleador_popupEstatusArchivos
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.lblNombreArchivo.Text = Request("nombre")
        Me.lblNumeroArchivo.Text = Request("numero")
        Me.lblFechaCarga.Text = DateTime.Now
    End Sub
End Class
