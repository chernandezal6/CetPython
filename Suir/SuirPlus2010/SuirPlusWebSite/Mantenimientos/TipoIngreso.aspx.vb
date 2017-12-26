Imports SuirPlus
Imports System.Data

Partial Class Mantenimientos_TipoIngreso
    Inherits BasePage

    Protected Sub Mantenimientos_TipoIngreso_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            cargarTipoIngreso()

        End If
    End Sub

    Protected Sub cargarTipoIngreso()

        Try
            Dim dt As DataTable = Mantenimientos.TipoIngreso.getAllTipoIngreso()

            If dt.Rows.Count > 0 Then
                gvTipoIngreso.SelectedIndex = -1
                gvTipoIngreso.DataSource = dt
                gvTipoIngreso.DataBind()

            Else
                gvTipoIngreso.DataSource = Nothing
                gvTipoIngreso.DataBind()

            End If
        Catch ex As Exception
            lbl_error.Visible = True
            lbl_error.Text = ex.Message
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        txtdescripcion.Text = String.Empty
        lbl_error.Text = String.Empty
        trEstatus.Visible = False
        gvTipoIngreso.SelectedIndex = -1
    End Sub

    Protected Sub gvTipoIngreso_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvTipoIngreso.RowCommand
        Dim index As Integer = Convert.ToInt32(e.CommandArgument)
        Me.gvTipoIngreso.SelectedIndex = index
        lbl_error.Text = String.Empty
        Session("idIngreso") = IIf(gvTipoIngreso.Rows(index).Cells(0).Text = "&nbsp;", "0", gvTipoIngreso.Rows(index).Cells(0).Text)

        Me.txtdescripcion.Text = IIf(gvTipoIngreso.Rows(index).Cells(1).Text = "&nbsp;", String.Empty, gvTipoIngreso.Rows(index).Cells(1).Text)
        Dim lblStatus As Label = CType(gvTipoIngreso.Rows(index).FindControl("lblEstatus"), Label)

        Me.ddlEstatus.SelectedValue = lblStatus.Text

        trEstatus.Visible = True

    End Sub

    Protected Sub gvTipoIngreso_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvTipoIngreso.RowCreated
        If e.Row.RowType = DataControlRowType.DataRow Then

            CType(e.Row.FindControl("ibEditar"), ImageButton).CommandArgument = e.Row.RowIndex

        End If
    End Sub

    Protected Sub btnGrabar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGrabar.Click
        Dim result As String = String.Empty

        Try
            If (txtdescripcion.Text <> String.Empty) Then

                result = Mantenimientos.TipoIngreso.NuevoTipoIngreso(CInt(Session("idIngreso")), txtdescripcion.Text, ddlEstatus.SelectedValue, UsrUserName)
                If result.Split("|")(0) = "0" Then
                    cargarTipoIngreso()
                    txtdescripcion.Text = String.Empty
                    Session.Remove("idIngreso")
                    trEstatus.Visible = False
                Else
                    lbl_error.Visible = True
                    lbl_error.Text = result.Split("|")(1)
                    Exit Sub
                End If

            Else
                lbl_error.Visible = True
                lbl_error.Text = "El tipo de ingreso es requeridos."
            End If


        Catch ex As Exception
            lbl_error.Visible = True
            lbl_error.Text = ex.Message.Split("|")(1)
        End Try
    End Sub
End Class
