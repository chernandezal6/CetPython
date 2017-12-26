Imports System.Data
Imports SuirPlus

Partial Class Oficina_Virtual_OficinaVirtual
    Inherits SeguridadOFV
    Dim Nro_Documento As String = String.Empty

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If UserNoDocument <> Nothing Then
        Else
            Response.Redirect("LoginOficinaVirtual.aspx")
        End If
    End Sub

    Protected Sub btnEmpReportados_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEmpReportados.Click
        Buscar("EMP")
    End Sub
    Protected Sub btnAfiliacionARS_Click(sender As Object, e As EventArgs) Handles btnAfiliacionARS.Click
        Buscar("ARS")
    End Sub
    Protected Sub btnAfiliacionAFP_Click(sender As Object, e As EventArgs) Handles btnAfiliacionAFP.Click
        Buscar("AFP")
    End Sub
    Protected Sub btnCrearSolicitud_Click(sender As Object, e As EventArgs) Handles btnCrearSolicitud.Click
        Buscar("GCR")
    End Sub
    Protected Sub btnConsDisARS_Click(sender As Object, e As EventArgs) Handles btnConsDisARS.Click
        Buscar("DIS")
    End Sub
    Protected Sub btnConsCertificaciones_Click(sender As Object, e As EventArgs) Handles btnConsCertificaciones.Click
        Buscar("CCER")
    End Sub
    Private Sub Buscar(ByVal Tipo As String)
        Select Case Tipo
            Case "EMP"
                Response.Redirect("ConsEmpReportados.aspx", True)
            Case "ARS"
                Response.Redirect("ConsAfiliacionARS.aspx", True)
            Case "AFP"
                Response.Redirect("ConsAfiliacionAFP.aspx", True)
            Case "GCR"
                Response.Redirect("GrCerAportes.aspx", True)
            Case "DIS"
                Response.Redirect("ConsDispercionARS.aspx", True)
            Case "CCER"
                Response.Redirect("ConsCertificaciones.aspx", True)
            Case Else
                Response.Redirect("ConsOficinaVirtual.aspx?tipo=" + Tipo, True)
        End Select
    End Sub
End Class
