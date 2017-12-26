Imports SuirPlus
Partial Class INFOTEP_CargarFactura
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        txtRNC.Focus()
    End Sub

    Protected Sub btAgregar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btAgregar.Click
        Try
            insertardatos(Me.txtRNC.Text, Me.txtPeriodo.Text, Me.txtMonto.Text)
        Catch ex As Exception
            lblmensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub
    Private Sub insertardatos(ByVal rnc As String, ByVal preiodo As Integer, ByVal monto As Decimal)
        Try
            Dim res As String = String.Empty
            'AQUI LE LE PASO EL INSERTE DE LA CLASE INFOTEP'
            res = Bancos.Infotep.insert_infotep_ext(Me.txtRNC.Text, Me.txtPeriodo.Text, Me.txtMonto.Text)
            If res = "0" Then
                lblmensaje.Text = "Los datos han sido insertado correctamente"
            Else
                lblmensaje.Text = res
            End If
        Catch ex As Exception
            lblmensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub btLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btLimpiar.Click
        txtMonto.Text = String.Empty
        txtPeriodo.Text = String.Empty
        txtRNC.Text = String.Empty
    End Sub
End Class
