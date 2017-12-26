
Imports SuirPlus.Bancos

Partial Class Bancos_EntidadesRecaudadoras
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (Page.IsPostBack = False) Then

            Dim dt As New Data.DataTable
            dt = EntidadRecaudadora.getBancos(0)

            Dim dr As Data.DataRow
            For Each dr In dt.Rows

                If dr.Item("id_entidad_recaudadora").ToString() = 0 Then
                    dr.Delete()
                    Exit For
                End If

            Next

            Me.ddlEntidades.DataSource = dt
            Me.ddlEntidades.DataTextField = "entidad_recaudadora_des"
            Me.ddlEntidades.DataValueField = "id_entidad_recaudadora"
            Me.ddlEntidades.DataBind()

            Dim item As New ListItem
            item.Value = -1
            item.Text = "Seleccione una Entidad Recaudadora"
            ddlEntidades.DataBind()
            ddlEntidades.Items.Add(item)
            ddlEntidades.SelectedValue = -1

        End If

    End Sub

    Protected Sub ddlEntidades_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEntidades.SelectedIndexChanged
        Me.gvBancos.DataSource = EntidadRecaudadora.getBancos(Me.ddlEntidades.SelectedValue)
        Me.gvBancos.DataBind()
    End Sub

    Protected Sub gvBancos_RowEditing(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewEditEventArgs) Handles gvBancos.RowEditing
        Me.gvBancos.EditIndex = e.NewEditIndex
        Me.gvBancos.DataSource = EntidadRecaudadora.getBancos(Me.ddlEntidades.SelectedValue)
        Me.gvBancos.DataBind()
    End Sub

    Protected Sub gvBancos_RowCancelingEdit(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCancelEditEventArgs) Handles gvBancos.RowCancelingEdit
        Me.gvBancos.EditIndex = -1
        Me.gvBancos.DataSource = EntidadRecaudadora.getBancos(Me.ddlEntidades.SelectedValue)
        Me.gvBancos.DataBind()
    End Sub

    Protected Sub gvBancos_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles gvBancos.RowUpdating
        Dim row As GridViewRow = Me.gvBancos.Rows(e.RowIndex)
        Dim id = Me.gvBancos.Rows(e.RowIndex).Cells(0).Text
        Dim tss, infoted, dgii As Integer

        Dim check1 As CheckBox = row.FindControl("CheckTSS")
        Dim check2 As CheckBox = row.FindControl("CheckInfotec")
        Dim check3 As CheckBox = row.FindControl("CheckDGII")

        If check1.Checked = True Then
            tss = 1
        Else
            tss = 0
        End If
        If check2.Checked = True Then
            infoted = 1
        Else
            infoted = 0
        End If
        If check3.Checked = True Then
            dgii = 1
        Else
            dgii = 0
        End If

        EntidadRecaudadora.updateEntidades(id, tss, infoted, dgii)

        Me.gvBancos.EditIndex = -1
        Me.gvBancos.DataSource = EntidadRecaudadora.getBancos(Me.ddlEntidades.SelectedValue)
        Me.gvBancos.DataBind()


    End Sub
End Class
