
Partial Class SuirPlain
    Inherits System.Web.UI.MasterPage

    Dim bPage As New BasePage

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        bPage.highLigthTextbox(Me.MainContent)

    End Sub

End Class

