Imports System.Data
Partial Class Seguridad_segUsuariosOnline
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Dim ds As DataSet = Application("dsUsuariosOnline")

        Me.dgUsuariosOnline.DataSource = ds
        Me.dgUsuariosOnline.DataBind()

        Me.lblCount.Text = ds.Tables(0).Rows.Count

        If Application("Modo") = "Normal" Then
            Me.btAdmin.Enabled = True
            Me.btNormal.Enabled = False
        ElseIf Application("Modo") = "Admin" Then
            Me.btAdmin.Enabled = False
            Me.btNormal.Enabled = True
        End If

    End Sub

    Private Sub btAdmin_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btAdmin.Click

        SuirPlus.Mantenimientos.Parametro.nuevoDetParametro(70, "6/1/2003", Nothing, Nothing, Nothing, "Admin", "S", Me.UsrUserName)

        Application("Modo") = "Admin"
        Response.Redirect("segUsuariosOnline.aspx")

    End Sub

    Private Sub btNormal_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btNormal.Click

        SuirPlus.Mantenimientos.Parametro.nuevoDetParametro(70, "6/1/2003", Nothing, Nothing, Nothing, "Normal", "S", Me.UsrUserName)

        Application("Modo") = "Normal"
        Response.Redirect("segUsuariosOnline.aspx")

    End Sub

End Class