
Partial Class Controles_ucDependientes
    Inherits System.Web.UI.UserControl

    Dim lastEmp As String
    Dim lastNom As String
    Private idNss As Integer

    Public WriteOnly Property setNSS() As Integer
        Set(ByVal Value As Integer)
            Me.idNss = Value
        End Set
    End Property

    Public WriteOnly Property setTitulo() As String
        Set(ByVal Value As String)
            Me.lblTitulo.Text = Value
        End Set
    End Property

    Public Sub bindControl()

        Dim dt As System.Data.DataTable = SuirPlus.Empresas.Trabajador.getDependientes(idNss)
        Me.gvDependientes.DataSource = dt
        Me.gvDependientes.DataBind()
        Me.lblTitulo.Visible = True

        If dt.Rows.Count <= 0 Then
            Me.lblTitulo.Text = "Este Trabajador no Tiene Dependientes Adicionales."
            Me.gvDependientes.Visible = False
        Else
            Me.lblTitulo.Text = "Dependientes Adicionales"
            Me.gvDependientes.Visible = True
        End If

    End Sub

    Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load

        lastEmp = String.Empty
        lastNom = String.Empty

    End Sub

    Protected Sub gvDependientes_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDependientes.RowDataBound
        If e.Row.RowType = ListItemType.Item Or ListItemType.AlternatingItem Then

            Dim CurrentEmp As String = e.Row.Cells(0).Text
            Dim CurrentNom As String = e.Row.Cells(1).Text

            If CurrentEmp = lastEmp Then

                e.Row.Cells(0).Text = String.Empty

                If CurrentNom = lastNom Then

                    e.Row.Cells(1).Text = String.Empty

                End If

            End If

            lastEmp = CurrentEmp
            lastNom = CurrentNom

        End If

    End Sub
End Class
