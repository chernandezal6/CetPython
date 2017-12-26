
Partial Class Controles_ucEncabezadoTSS
    Inherits System.Web.UI.UserControl
    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Me.imgTSS.ImageUrl = CType(Me.Page, BasePage).urlLogoTSSDocumento

    End Sub
End Class
