
Partial Class adpImprimirAcuerdoPagoPopUp
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim nroAcuerdo As String
        nroAcuerdo = Request.QueryString("idAcuerdoPago")
        Dim Tipo As String = Request.QueryString("tipoAcuerdo")
        If Tipo = "3" Or Tipo = "Ordinario" Then

            divAcuerdoPagoOrdinario.Visible = True
            Me.AdpucAcuerdoPago1._NroAcuerdoDePago = nroAcuerdo
            Me.AdpucAcuerdoPago1._MostrarData()

        Else

            divAcuerdoPagoEmbajadas.Visible = True
            Me.AdpucAcuerdoPago2._NroAcuerdoDePago = nroAcuerdo
            Me.AdpucAcuerdoPago2._MostrarData()
        End If

    End Sub
End Class
