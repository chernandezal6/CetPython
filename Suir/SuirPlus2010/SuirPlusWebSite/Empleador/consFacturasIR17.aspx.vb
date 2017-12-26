
Partial Class Empleador_consFacturasIR17
    Inherits BasePage
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim sec As String = ""
        sec = Request("sec")
        sec = Trim(sec)
        sec = sec.ToLower

        Dim nro As String = ""
        nro = Request("nro")
        nro = Trim(nro)
        nro = nro.ToLower

        Select Case sec
            Case "encabezado"

                Me.ucLiqEncIR.Visible = True
                Me.ucLiqEncIR.NroReferencia = nro
                Me.ucLiqEncIR.MostrarEncabezado()

            Case "detalle"

        End Select
    End Sub
End Class
