Imports Suirplus
Partial Class Mantenimientos_mntParametros
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Page.IsPostBack Then
            Me.CargaIncial()
        End If
    End Sub

    Private Sub CargaIncial()

        Me.dgParametros.DataSource = Mantenimientos.Parametro.getParametros(-1)
        Me.dgParametros.DataBind()
        Dim Param As String = CType(Me.dgParametros.Rows(0).FindControl("lblID"), Label).Text

        'Para que muestre el detalle del primer parametro
        Me.dgDetalleParametros.DataSource = Mantenimientos.Parametro.getDetalleParametros(Param)
        Me.dgDetalleParametros.DataBind()

        'Muestra el detalle del parámetro maestro, en esta caso, de la primera fila del gridview
        Me.ShowDetail(0, Param)

    End Sub

    Protected Sub dgParametros_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgParametros.RowCreated

        'Para obtener el index de cada fila del gridview
        If e.Row.RowType = DataControlRowType.DataRow Then

            CType(e.Row.FindControl("imgBtReseteo"), ImageButton).CommandArgument = e.Row.RowIndex

        End If

    End Sub

    Protected Sub dgParametros_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgParametros.RowCommand

        'Muestra el detalle del parametro seleccionado
        Dim index As Integer = Convert.ToInt32(e.CommandArgument)
        Dim Param As Integer = CType(Me.dgParametros.Rows(index).FindControl("lblID"), Label).Text

        'Muestra el detalle del parámetro maestro, en esta caso, el de la fila del botón presionado
        Me.ShowDetail(index, Param)

    End Sub

    Private Sub ShowDetail(ByVal Row As Integer, ByVal idParam As String)

        'Muestra el detalle del parametro seleccionado
        Try

            Me.dgParametros.SelectedIndex = Row
            Me.dgDetalleParametros.DataSource = Mantenimientos.Parametro.getDetalleParametros(idParam)
            Me.dgDetalleParametros.DataBind()
            Me.lblSubTitulo.Text = "Detalle Parámetro: " & Me.dgParametros.Rows(Row).Cells(0).Text
            Me.pnlAbajo.Visible = True

        Catch ex As Exception
            Me.pnlAbajo.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub
End Class
