
Partial Class Legal_ImprimirAcuerdoPagoPopUp
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Me.ucAcuerdo._NroAcuerdoDePago = Request("idAcuerdoPago")
        Me.ucAcuerdo._MostrarData()

    End Sub
End Class
