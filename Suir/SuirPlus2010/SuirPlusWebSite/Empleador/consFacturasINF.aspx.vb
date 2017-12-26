
Partial Class Empleador_consFacturasINF
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

                Me.ucLiqEncINF.Visible = True
                Me.ucLiqEncINF.NroReferencia = nro
                'Me.ucLiqEncINF.isBotonesVisibles = True
                Me.ucLiqEncINF.MostrarEncabezado()

            Case "detalle"
                Me.UcLiquidacionInfotepDet.Visible = True
                Me.UcLiquidacionInfotepDet.NroReferencia = nro
                Me.UcLiquidacionInfotepDet.DataBind()



        End Select
    End Sub
End Class
