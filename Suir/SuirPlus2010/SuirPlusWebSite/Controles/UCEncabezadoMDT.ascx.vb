
Partial Class Controles_UCEncabezadoMDT
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Me.imgMDT.ImageUrl = CType(Me.Page, BasePage).urlLogoMDT
    End Sub
End Class
