Partial Class Controles_UCTrabajadoresCedCancelada
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Con esto consigo mejorar el rendimiento de la pagina, ya que no se llaman el o los
        'métodos para llenar el o los datagrids, que es donde se degrada el rendimiento.
        'Gregorio Herrera, 24/07/2007
        If Me.Visible = False Then
            Return
        End If

        If Not Me.Page.IsPostBack Then
            Me.CargarNonimas()
        End If

    End Sub

    Sub CargarNonimas()
        'Carga el listado de las nóminas de un empleador.
        Try

            Dim dt As Data.DataTable = SuirPlus.Empresas.Representante.getTrabCedulaCancelada(getIDNSS, getRegPatronal)

            If dt.Rows.Count > 0 Then
                Me.gvTRabajadoresCedCancel.DataSource = dt
                Me.gvTRabajadoresCedCancel.DataBind()
                trHeader.Visible = True
            Else
                trHeader.Visible = False
            End If

        Catch ex As Exception
            Me.lblResultado.Text = ex.Message
        End Try

    End Sub

    Private Function getIDNSS() As Integer

        Return CType(Me.Page, BasePage).UsrNSS

    End Function

    Private Function getUserRepresentante() As String

        Return CType(Me.Page, BasePage).UsrUserName

    End Function

    Private Function getRegPatronal() As Integer
        Return CType(Me.Page, BasePage).UsrRegistroPatronal
    End Function

    Protected Sub gvTRabajadoresCedCancel_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvTRabajadoresCedCancel.RowDataBound

        If (e.Row.RowType = DataControlRowType.DataRow) Then

            Dim regPatronal As String = CType(e.Row.FindControl("lblRegistroPatronal"), Label).Text
            Dim idNomina As String = CType(e.Row.FindControl("lblNomina"), Label).Text
            Dim hl As System.Web.UI.WebControls.HyperLink = CType(e.Row.FindControl("hlkDetalle"), HyperLink)

            hl.NavigateUrl = "../Empleador/consDetallesCedulaCanceladas.aspx?nomina=" & idNomina & "&regPatronal=" & regPatronal
            'se deshabilita el linkbutton de ver el detalle si no tiene registros
            If e.Row.Cells(3).Text = 0 Then
                hl.Enabled = False

            Else
                hl.Enabled = True

            End If
        End If
    End Sub

End Class
