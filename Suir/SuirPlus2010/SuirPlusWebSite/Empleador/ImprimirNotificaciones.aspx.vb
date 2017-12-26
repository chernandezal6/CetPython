Imports SuirPlus
Partial Class Empleador_ImprimirNotificaciones
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim Req As String = ""
        Req = Request("tipo")
        Req = Trim(Req)
        Req = Req.ToUpper

        Dim nro As String = ""
        nro = Request("nro")
        nro = Trim(nro)
        nro = nro.ToLower

        Select Case Req
            Case "TSS"
                Me.ImprimirTSS(nro)
            Case "ISR"
                Me.ImprimirISR(nro)
            Case "IR17"
                Me.ImprimirIR17(nro)
            Case "INF"
                Me.ImprimirINF(nro)
            Case "MDT"
                Me.ImprimirMDT(nro)
            Case "ISRP"
                Me.ImprimirISRP(nro)
            Case Else
                Response.Redirect("consNotificaciones.aspx")
        End Select

        Dim Script As String = "<script language='javascript'>window.print()</script>"
        ClientScript.RegisterStartupScript(Me.GetType(), "Onload", Script)

    End Sub

    Private Sub ImprimirTSS(ByVal NroReferencia As String)

        Me.ucNotTSS.Visible = True
        Me.ucNotTSS.Visible = True
        Me.ucNotTSS.NroReferencia = NroReferencia
        Me.ucNotTSS.isBotonesVisibles = False
        Me.ucNotTSS.MostrarEncabezado()

    End Sub
    Private Sub ImprimirISR(ByVal NroReferencia As String)

        Me.ucLiqISR.Visible = True
        Me.ucLiqISR.Visible = True
        Me.ucLiqISR.NroReferencia = NroReferencia
        Me.ucLiqISR.isBotonesVisibles = False
        Me.ucLiqISR.MostrarEncabezado()

    End Sub
    Private Sub ImprimirIR17(ByVal NroReferencia As String)

        Me.ucDecIR17.Visible = True
        Me.ucDecIR17.Visible = True
        Me.ucDecIR17.NroReferencia = NroReferencia
        Me.ucDecIR17.MostrarEncabezado()

    End Sub
    Private Sub ImprimirINF(ByVal NroReferencia As String)

        Me.ucLiqINF.Visible = True
        Me.ucLiqINF.NroReferencia = NroReferencia
        Me.ucLiqINF.MostrarEncabezado()

    End Sub
    Private Sub ImprimirMDT(ByVal NroReferencia As String)

        Me.ucPlanillasMDTencabezado1.Visible = True
        Me.ucPlanillasMDTencabezado1.NroReferencia = NroReferencia
        Me.ucPlanillasMDTencabezado1.MostrarEncabezado()

    End Sub
    Private Sub ImprimirISRP(ByVal Periodo As String)

        Me.ucLiqISRP.Visible = True
        Me.ucLiqISRP.Visible = True
        Me.ucLiqISRP.Periodo = Periodo
        Me.ucLiqISRP.RNC = Me.UsrRNC
        Me.ucLiqISRP.isBotonesVisibles = False
        Me.ucLiqISRP.MostrarEncabezado()

    End Sub
End Class
