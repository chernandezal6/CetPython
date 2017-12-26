
Partial Class adpImprimirAcuerdoPago
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Me.lblTitulo.Text = "Su acuerdo de pago No." & Request("idAcuerdoPago") & " fue generado satisfactoriamente."

        Dim script As String = "<script Language=JavaScript>" + "window.open('adpImprimirAcuerdoPagoPopUp.aspx?idAcuerdoPago=" & Request("idAcuerdoPago") & "&tipoAcuerdo=" & Request("tipoAcuerdo") & "')</script>"

        Me.ClientScript.RegisterStartupScript(Me.GetType, "popup", script)

    End Sub
End Class
