Imports System.Data
Imports SuirPlus
Imports SuirPlus.Empresas.SubsidiosSFS.Consultas
Partial Class Consultas_consPerCapitaExceso
    Inherits BasePage
    Dim total As Decimal
    Protected Sub btBuscarRef_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btBuscarRef.Click

        Try
            If Me.txtnodocumento.Text = String.Empty Then
                Me.lblError.Visible = True
                Me.lblError.Text = "La cédula es requerida"
                Exit Sub
            Else
                Me.lblError.Visible = False
                Me.lblError.Text = String.Empty
            End If

            Dim dt As New DataTable
            dt = getPagosExcesoExterno(txtnodocumento.Text)

            If dt.Rows.Count > 0 Then
                gvPagos.DataSource = dt
                gvPagos.DataBind()
                Leyenda.Visible = True
                'SumatoriaTotal()

                lblCedula.Text = formateaCedula(txtnodocumento.Text)

                If txtnodocumento.Text = dt.Rows(0)("cedula_titular").ToString() Then
                    lblNombre.Text = dt.Rows(0)("nombre_titular").ToString()
                ElseIf txtnodocumento.Text = dt.Rows(0)("cedula_dependiente").ToString() Then
                    lblNombre.Text = dt.Rows(0)("nombre_dependiente").ToString()
                Else
                    lblNombre.Text = "--"
                End If

                pnlInfo.Visible = True
                pnlPagos.Visible = True
            Else
                lblError.Text = "No existen registros para esta búsqueda."
                lblError.Visible = True
            End If
            btBuscarRef.Enabled = False
            txtnodocumento.Enabled = False
        Catch ex As Exception
            lblError.Text = ex.Message
            lblError.Visible = True
        End Try


    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.limpiar()
    End Sub

    Private Sub limpiar()
        Response.Redirect("consPerCapitaExceso.aspx")
    End Sub

    Protected Function formateaCedula(ByVal Cedula As String) As String

        If Cedula = String.Empty Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormatearCedula(Cedula)
        End If

    End Function

    Protected Sub gvPagos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPagos.RowDataBound
        Dim Resultado As Decimal
        If gvPagos.Rows.Count > 0 Then
            For Each item As GridViewRow In gvPagos.Rows
                Resultado = Resultado + item.Cells(9).Text
            Next
        End If
        gvPagos.ShowFooter = True

        If e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(1).Text = ""
            e.Row.Cells(9).Text = "RD$" + Resultado.ToString()
            e.Row.HorizontalAlign = HorizontalAlign.Right
        End If
    End Sub
    Protected Function formateaPeriodo(ByVal Periodo As Object) As String
        If Not IsDBNull(Periodo) Then
            Return Utilitarios.Utils.FormateaPeriodo(Periodo)
        Else
            Return String.Empty
        End If
    End Function
    Protected Function formateaCedula(ByVal rnc As Object) As String

        If Not IsDBNull(rnc) Then
            If rnc = String.Empty Then
                Return String.Empty
            Else
                Return Utilitarios.Utils.FormatearRNCCedula(rnc)
            End If
        Else
            Return String.Empty
        End If

    End Function

    'Sub SumatoriaTotal()
    '    Dim Resultado As Decimal
    '    If gvPagos.Rows.Count > 0 Then


    '        For Each item As GridViewRow In gvPagos.Rows
    '            Resultado = Resultado + item.Cells(9).Text
    '        Next

    '        lblTotal.Text = "RD$" + Resultado.ToString()
    '    End If
    'End Sub

End Class
