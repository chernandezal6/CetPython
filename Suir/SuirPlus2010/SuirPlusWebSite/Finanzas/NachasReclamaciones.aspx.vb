Imports System.Data
Imports SuirPlus

Partial Class Finanzas_NachasReclamaciones
    Inherits BasePage

    Protected Sub Finanzas_NachasReclamaciones_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            CargarNachasPendientes()
        End If
    End Sub

    Private Sub CargarNachasPendientes()

        Dim dt As New DataTable

        Try
            dt = Finanzas.DevolucionAportes.getNachasPendientes()

            If dt.Rows.Count > 0 Then
                lblMsg.Visible = False
                fsNachasPendientes.Visible = True
                gvNachasPendientes.DataSource = dt
                gvNachasPendientes.DataBind()
            Else
                lblMsg.Visible = True
                Me.lblMsg.Text = "No existen archivos nachas pendientes."
                fsNachasPendientes.Visible = False
                gvNachasPendientes.DataSource = Nothing
                gvNachasPendientes.DataBind()

            End If

        Catch ex As Exception
            lblMsg.Visible = True
            lblMsg.Text = ex.Message

        End Try


    End Sub


    Protected Sub gvNachasPendientes_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvNachasPendientes.RowCommand

        Dim nacha = e.CommandArgument.ToString.Split("|")(0)
        Try
            If e.CommandName.ToString = "DET" Then

                Dim monto = e.CommandArgument.ToString.Split("|")(1)
                Dim estatus = e.CommandArgument.ToString.Split("|")(2)
                Response.Redirect("~/finanzas/DetNachaReclamaciones.aspx?nacha=" & nacha & "&monto=" & monto & "&estatus=" & estatus)

            ElseIf (e.CommandName.ToString = "APR") Then
                Finanzas.DevolucionAportes.aprobarNachaPendiente(nacha, UsrUserName)
                CargarNachasPendientes()
            ElseIf e.CommandName = "REC" Then
                Finanzas.DevolucionAportes.rechazarNachaPendiente(nacha, UsrUserName)
                CargarNachasPendientes()
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
        End Try

    End Sub



    Protected Sub gvNachasPendientes_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNachasPendientes.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then

            Dim status As String = CType(e.Row.Cells(2).FindControl("lblStatus"), Label).Text

            If status = "R" Then
                CType(e.Row.Cells(4).FindControl("lbAprobar"), LinkButton).Visible = False
                CType(e.Row.Cells(4).FindControl("lbRechazar"), LinkButton).Visible = False
            Else
                CType(e.Row.Cells(4).FindControl("lbAprobar"), LinkButton).Visible = True
                CType(e.Row.Cells(4).FindControl("lbRechazar"), LinkButton).Visible = True
            End If

        End If
    End Sub
End Class
