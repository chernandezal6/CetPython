
Partial Class Controles_UCEncabezadoInfotep
    Inherits System.Web.UI.UserControl


    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Me.imgDGII.ImageUrl = CType(Me.Page, BasePage).urlLogoINFDocumento

    End Sub


End Class
