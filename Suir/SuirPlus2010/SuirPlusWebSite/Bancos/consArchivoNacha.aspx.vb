Imports SuirPlus
Partial Class Bancos_consArchivoNacha
    Inherits BasePage

    Private dt As Data.DataTable

    Private Sub btBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btBuscar.Click
        Try
            dt = Empresas.Facturacion.Factura.getMensajesNacha(Me.txtReferencia.Text)
            Me.dgDetalle.DataSource = dt
            Me.dgDetalle.DataBind()
        Catch ex As Exception
            Me.lblMsg.Text = "No. Referencia no Encontrado"
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
        If dt.Rows.Count = 0 Then
            Me.lblMsg.Text = "No. Referencia no Existe"
        Else
            Me.lblMsg.Text = ""
        End If

    End Sub

End Class
