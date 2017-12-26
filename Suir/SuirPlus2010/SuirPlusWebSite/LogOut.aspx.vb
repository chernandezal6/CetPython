
Partial Class LogOut
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        System.Web.Security.FormsAuthentication.SignOut()

        Session.Abandon()

        Response.Redirect("login.aspx")

    End Sub
End Class
