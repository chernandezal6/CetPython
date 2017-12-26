
Partial Class Consultas_consNominaDetalle
    Inherits BasePage

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not (Request("regPat") = String.Empty) And Not (Request("idNom") = String.Empty) Then
            UcDetalleNomina.RegistroPatronal = Request("regPat")
            UcDetalleNomina.IdNomina = Request("idNom")
            UcDetalleNomina.DataBind()
        End If

    End Sub

End Class
