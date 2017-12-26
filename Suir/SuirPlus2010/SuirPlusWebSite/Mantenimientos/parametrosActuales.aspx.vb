Imports System.Xml
Partial Class Mantenimientos_parametrosActuales
    Inherits BasePage

    Dim LastColumn As String
    Dim dsParam As System.Data.DataSet = New System.Data.DataSet

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not Page.IsPostBack Then

            LastColumn = String.Empty

            dsParam = SuirPlus.Mantenimientos.Parametro.getParametrosActuales()
            binGridParametros()
            bindGridISR()
            bindGridPEN()

        End If

    End Sub

    Private Sub bindGridISR()

        Me.dgRangosISR.DataSource = dsParam.Tables(0)
        Me.dgRangosISR.DataBind()

    End Sub

    Private Sub bindGridPEN()

        Me.dgRangosPEN.DataSource = dsParam.Tables(1)
        Me.dgRangosPEN.DataBind()

    End Sub

    Private Sub binGridParametros()

        Me.dgParametros.DataSource = dsParam.Tables(2)
        Me.dgParametros.DataBind()

    End Sub

    'Private Sub dgParametros_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgParametros.ItemDataBound

    '    Dim CurrentColumn = e.Item.Cells(0).Text

    '    If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
    '        e.Item.Cells(0).BackColor = System.Drawing.Color.White
    '        e.Item.Cells(0).Style.Add("BORDER", "none")
    '    End If

    '    If e.Item.ItemType.ToString <> "Header" Then

    '        If CurrentColumn = LastColumn Then

    '            e.Item.Cells(0).Text = String.Empty
    '            'e.Item.Cells(0).Style.Add("BORDER", "none")

    '        Else

    '            LastColumn = CurrentColumn
    '            e.Item.Cells(0).BackColor = System.Drawing.Color.LightSteelBlue 'System.Drawing.Color.SteelBlue
    '            'e.Item.Cells(0).Font.Bold = True
    '            'e.Item.Cells(0).ForeColor = System.Drawing.Color.White
    '            e.Item.Cells(0).Font.Size = FontUnit.Point(7)

    '        End If

    '    End If

    'End Sub

    Protected Sub dgParametros_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgParametros.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then

            Dim CurrentColumn = e.Row.Cells(0).Text

            If e.Row.RowState = DataControlRowState.Alternate Then
                e.Row.Cells(0).BackColor = System.Drawing.Color.White
                e.Row.Cells(0).Style.Add("BORDER", "none")
            End If

            If e.Row.RowType <> DataControlRowType.Header Then

                If CurrentColumn = LastColumn Then

                    e.Row.Cells(0).Text = String.Empty

                Else

                    LastColumn = CurrentColumn
                    e.Row.Cells(0).BackColor = System.Drawing.Color.LightSteelBlue
                    e.Row.Cells(0).Font.Size = FontUnit.Point(7)

                End If

            End If

        End If

    End Sub

End Class
