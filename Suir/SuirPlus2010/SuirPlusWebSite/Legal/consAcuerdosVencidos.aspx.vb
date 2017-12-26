Imports SuirPlus
Partial Class Legal_consAcuerdosVencidos
    Inherits BasePage
    Dim dt As New Data.DataTable

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        bindGridView()
    End Sub

    Protected Sub bindGridView()

        Try
            dt = Legal.AcuerdosDePago.getAcuerdosVencidos()
            If dt.Rows.Count > 0 Then
                Me.gvAcuerdosVencidos.DataSource = dt
                Me.gvAcuerdosVencidos.DataBind()
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

    Protected Sub gvAcuerdosVencidos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvAcuerdosVencidos.RowCommand
        Dim IdAcuerdo As Integer = e.CommandArgument

        If e.CommandName = "Ver" Then
            Dim row As GridViewRow = CType(CType(e.CommandSource, Control).NamingContainer, GridViewRow)
            Dim cuota As Integer = CInt(CType(row.FindControl("lblcuota"), Label).Text)
            Dim tipoAcuerdo As Integer = CInt(CType(row.FindControl("lbltipoAcuerdo"), Label).Text)
            Response.Redirect("consDetAcuerdoVencido.aspx?Id= " & IdAcuerdo & "&cuota=" & cuota & "&tipo=" & tipoAcuerdo)
        End If
    End Sub

    Protected Function formateaRNC_Cedula(ByVal rnc As Object) As Object

        If Not rnc Is DBNull.Value Then

            Return Utilitarios.Utils.FormatearRNCCedula(rnc.ToString)

        End If

        Return rnc

    End Function

    Protected Function formateaTelefono(ByVal Tel As Object) As Object

        If Not Tel Is DBNull.Value Then

            Return Utilitarios.Utils.FormatearTelefono(Tel.ToString)

        End If

        Return Tel

    End Function

End Class
