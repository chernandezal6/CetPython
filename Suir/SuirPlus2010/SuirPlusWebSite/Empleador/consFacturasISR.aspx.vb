
Partial Class Empleador_consFacturasISR
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

                Me.ucLiqEncISR.Visible = True
                Me.ucLiqEncISR.NroReferencia = nro
                Me.ucLiqEncISR.isBotonesVisibles = True
                Me.ucLiqEncISR.MostrarEncabezado()

            Case "detalle"

                Me.ucLiqDetalle.Visible = True
                Me.ucLiqDetalle.NroReferencia = nro
                ''Me.ucLiqDetalle.MostrarDetalle()
                Me.ucLiqDetalle.DataBind()

        End Select
    End Sub
End Class
