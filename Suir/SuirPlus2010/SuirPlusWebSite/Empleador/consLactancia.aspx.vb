Imports SuirPlus
Partial Class Empleador_consLactancia
    Inherits BasePage
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try

            Dim dtLactante As New Data.DataTable
            dtLactante = Empresas.SubsidiosSFS.Consultas.getElegibilidadLactancia(UsrRegistroPatronal)

            If dtLactante.Rows.Count > 0 Then
                Me.gvLantancia.DataSource = dtLactante
                Me.gvLantancia.DataBind()
                pnlLatancia.Visible = True
                Me.lblMensaje.Visible = False
            Else
                Me.lblMensaje.Text = "No hay datos para Mostrar"
                pnlLatancia.Visible = False
                Me.lblMensaje.Visible = True
            End If
        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
        End Try
    End Sub
    Protected Function formateaPeriodo(ByVal Periodo As Object) As String

        If IsDBNull(Periodo) Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormateaPeriodo(Periodo)
        End If

    End Function

    Protected Sub gvLantancia_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvLantancia.RowDataBound
        e.Row.Cells(0).Text = Utilitarios.Utils.ProperCase(e.Row.Cells(0).Text)
    End Sub
End Class
