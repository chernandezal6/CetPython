Imports SuirPlus
Imports System.Data

Partial Class Carteras
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadData()
        End If
    End Sub

    Private Sub LoadData()
        Dim dt As New DataTable

        dt = Legal.Cobro.getCarteraAsignada(Me.UsrUserName)

        If dt.Rows.Count > 0 Then
            gvCarteras.DataSource = dt
            gvCarteras.DataBind()
        End If
    End Sub

    Protected Sub gvCarteras_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvCarteras.RowCommand
        If e.CommandName = "Trabajar" Then
            Response.Redirect("ManejodeCartera.aspx?ID=" & e.CommandArgument)
        End If
    End Sub
End Class
