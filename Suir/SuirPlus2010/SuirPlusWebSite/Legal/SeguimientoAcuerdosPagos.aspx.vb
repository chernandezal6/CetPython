Imports SuirPlus
Partial Class Legal_SiguimientoAcuerdosPagos
    Inherits BasePage

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        bindGridView()
    End Sub

    Protected Sub bindGridView()
        Dim dt As New Data.DataTable
        Try
            dt = Legal.AcuerdosDePago.getSeguimientoAcuerdosPagos()
            If dt.Rows.Count > 0 Then
                Me.gvSeguimientoAcuerdosPago.DataSource = dt
                Me.gvSeguimientoAcuerdosPago.DataBind()
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

    Protected Function formateaRNC_Cedula(ByVal rnc As Object) As Object

        If Not rnc Is DBNull.Value Then

            Return Utilitarios.Utils.FormatearRNCCedula(rnc.ToString)

        End If

        Return rnc

    End Function

    Protected Sub gvSeguimientoAcuerdosPago_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvSeguimientoAcuerdosPago.RowCommand

        Try
            If e.CommandName = "Ver" Then
                Response.Redirect("../Consultas/consEmpleador.aspx?rnc=" & e.CommandArgument.ToString())
            End If

            If e.CommandName = "Cancelar" Then
                CancelarAcuerdo(CInt(e.CommandArgument.ToString()))
            End If

        Catch ex As Exception
            Throw ex
        End Try

    End Sub

    Protected Sub CancelarAcuerdo(ByVal idAcuerdo As Integer)

        Try
            Dim result As String = String.Empty

            result = Legal.AcuerdosDePago.CancelarAPincumplido(idAcuerdo, 3, UsrUserName)

            If Not result = 0 Then
                Throw New Exception(result)
            Else
                bindGridView()
            End If


        Catch ex As Exception
            Throw New Exception(ex.ToString)
        End Try


    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        For Each i As System.Web.UI.WebControls.GridViewRow In Me.gvSeguimientoAcuerdosPago.Rows
            CType(i.FindControl("lbtnCancelar"), LinkButton).Attributes.Add("onClick", "return confirm('Esta seguro que desea cancelar este acuerdo de pago?');")
        Next
    End Sub
End Class
