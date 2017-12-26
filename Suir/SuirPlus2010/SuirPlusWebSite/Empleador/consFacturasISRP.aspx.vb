
Partial Class Empleador_consFacturasISRP
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

        Dim tipo As String = ""
        tipo = Request("tifa")
        tipo = Trim(tipo)
       

        Select Case sec
            Case "encabezado"

                Me.ucLiqEncISR.Visible = True
                Me.ucLiqEncISR.Periodo = nro
                Me.ucLiqEncISR.RNC = Me.UsrRNC
                Me.ucLiqEncISR.Tipo = tipo

                Me.ucLiqEncISR.isBotonesVisibles = True
                Me.ucLiqEncISR.MostrarEncabezado()

            Case "detalle"

                Me.ucLiqDetalle.Visible = True
                Me.ucLiqDetalle.Periodo = nro
                Me.ucLiqDetalle.RNC = Me.UsrRNC
                Me.ucLiqDetalle.Tipo = tipo
                Me.ucLiqDetalle.DataBind()

        End Select
    End Sub
End Class
