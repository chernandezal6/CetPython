
Imports System.Data
Imports SuirPlus

Partial Class Mantenimientos_TipoAjustes
    Inherits BasePage


    Protected Sub Mantenimientos_TipoAjustes_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            CargarTipoAjustes()
        End If

    End Sub

    Protected Sub CargarTipoAjustes()
        Dim dt As New DataTable
        Try
            dt = Mantenimientos.ManejoDeAjustes.getTipoAjustes

            If dt.Rows.Count > 0 Then
                Me.gvTipoAjustes.DataSource = dt
                Me.gvTipoAjustes.DataBind()
                Me.lblMsg.Visible = False
                Me.lblMsg.Text = String.Empty
            End If
        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
        End Try
    End Sub

End Class
