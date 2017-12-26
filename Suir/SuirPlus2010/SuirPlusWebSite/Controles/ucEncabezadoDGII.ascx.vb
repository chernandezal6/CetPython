
Partial Class Controles_ucEncabezadoDGII
    Inherits System.Web.UI.UserControl


    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Me.imgDGII.ImageUrl = CType(Me.Page, BasePage).urlLogoDGIIDocumento

    End Sub


End Class
