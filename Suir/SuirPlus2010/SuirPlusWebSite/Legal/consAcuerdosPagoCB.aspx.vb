Imports SuirPlus
Partial Class Legal_consAcuerdosPagoCB

    Inherits BasePage

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        bindGridView()
    End Sub

    Protected Sub bindGridView()
        Dim dt As New Data.DataTable
        Try
            dt = Legal.AcuerdosDePago.getAcuerdosPagoTipo("CB")
            If dt.Rows.Count > 0 Then
                Me.gvAcuerdosPago.DataSource = dt
                Me.gvAcuerdosPago.DataBind()
            Else
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existen registros"
            End If
        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub gvAcuerdosPago_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvAcuerdosPago.RowCommand
        If e.CommandName = "Ver" Then
            Dim vec() As String = e.CommandArgument.ToString.Split("|")
            Response.Redirect("consDetAcuerdoPago.aspx?Id= " & CInt(vec(0)) & "&Tipo=CB&TipoAcuerdo=" & CInt(vec(1)))
        End If

    End Sub

    Protected Function formateaRNC_Cedula(ByVal rnc As Object) As Object

        If Not rnc Is DBNull.Value Then

            Return Utilitarios.Utils.FormatearRNCCedula(rnc.ToString)

        End If

        Return rnc

    End Function
End Class
