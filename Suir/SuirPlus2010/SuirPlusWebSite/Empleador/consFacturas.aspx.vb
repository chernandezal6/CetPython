
Partial Class Empleador_consFacturas
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim Req As String = ""
        Req = Request("tipo")
        Req = Trim(Req)
        Req = Req.ToUpper

        Select Case Req
            Case "SDSS"
                Server.Transfer("consFacturasTSS.aspx")
            Case "TSS"
                Server.Transfer("consFacturasTSS.aspx")
            Case "ISR"
                Server.Transfer("consFacturasISR.aspx")
            Case "IR17"
                Server.Transfer("consFacturasIR17.aspx")
            Case "INF"
                Server.Transfer("consFacturasINF.aspx")
            Case "MDT"
                Server.Transfer("consFacturasMDT.aspx")
            Case "ISRP"
                Server.Transfer("consFacturasISRP.aspx")
            Case Else
                Response.Redirect("consNotificaciones.aspx")
        End Select

    End Sub

End Class
