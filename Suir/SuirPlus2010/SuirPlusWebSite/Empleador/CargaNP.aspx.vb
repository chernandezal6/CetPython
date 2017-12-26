
Partial Class Empleador_CargaNP
    Inherits BasePage

    Protected Sub btnAceptar_Click(sender As Object, e As EventArgs) Handles btnAceptar.Click
        Me.lblMensaje.Text = String.Empty

        Dim ret As String = String.Empty


        'Validando los aportes y descuento
        If String.IsNullOrEmpty(Me.txtMonto.Text) Then
            Me.txtMonto.Text = "0.00"
        Else
            If Not isDecimal(Me.txtMonto.Text) Then
                Me.lblMensaje.Text = "El valor en el monto es inválido."
                Exit Sub
            End If
        End If

       
        Try
            ret = SuirPlus.Empresas.Trabajador.novedadSVDS(Me.UsrRegistroPatronal, 1, Me.UsrNSS, Me.txtMonto.Text, Me.UsrUserName, Me.GetIPAddress())

        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub
        End Try

        If Split(ret, "|")(0) = "0" Then
            lblinfo.Visible = True
            tblInicio.Visible = False

        Else
            Me.lblMensaje.Text = Split(ret, "|")(1)

        End If


    End Sub

    Protected Function isDecimal(ByVal valor As String) As Boolean
        Return Regex.IsMatch(valor, "^\d+(\.\d\d)?$")
    End Function
End Class
