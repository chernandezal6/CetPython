Imports System.Data
Imports SuirPlus

Partial Class Solicitudes_solicitudIntro
    Inherits BasePage

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    ' Protected WithEvents dtUrls As System.Web.UI.WebControls.DataList

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Protected Sub lnkRegEmpresa_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRegEmpresa.Click
        Response.Redirect("Info.aspx?id=" & 2)
    End Sub

    Protected Sub lnkCalcAporte_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCalcAporte.Click
        Response.Redirect("Info.aspx?id=" & 11)
    End Sub

    Protected Sub lkRecClave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lkRecClave.Click
        Response.Redirect("Info.aspx?id=" & 3)
    End Sub

    Protected Sub LkMail_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles LkMail.Click
        Response.Redirect("Info.aspx?id=" & 8)
    End Sub

    Protected Sub lkEstadoCuenta_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lkEstadoCuenta.Click
        Response.Redirect("Info.aspx?id=" & 4)
    End Sub

    Protected Sub lkSolicitud_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lkSolicitud.Click
        Response.Redirect("Info.aspx?id=" & 9)
    End Sub

    Protected Sub lkInfoPublica_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lkInfoPublica.Click
        Response.Redirect("Info.aspx?id=" & 7)
    End Sub

    Protected Sub lkConsulSolicitud_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lkConsulSolicitud.Click
        Response.Redirect("Info.aspx?id=" & 18)
    End Sub

    Protected Sub lkConslRNC_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lkConslRNC.Click
        Response.Redirect("Info.aspx?id=" & 17)
    End Sub

    Protected Sub lkNSS_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lkNSS.Click
        Response.Redirect("Info.aspx?id=" & 10)
    End Sub

    Protected Sub lkAfiliado_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lkAfiliado.Click
        Response.Redirect("Info.aspx?id=" & 19)
    End Sub

    Protected Sub lkNomina_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lkNomina.Click
        Response.Redirect("Info.aspx?id=" & 12)
    End Sub

    Protected Sub lkPreguntasF_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lkPreguntasF.Click
        Response.Redirect("Info.aspx?id=" & 13)
    End Sub

    Protected Sub lkDirectorio_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lkDirectorio.Click
        Response.Redirect("Info.aspx?id=" & 15)
    End Sub

    Protected Sub lkGlosario_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lkGlosario.Click
        Response.Redirect("Info.aspx?id=" & 14)
    End Sub

    Protected Sub lkOficina_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lkOficina.Click
        Response.Redirect("Info.aspx?id=" & 16)
    End Sub

    Protected Sub lnkConsultaSP_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkConsultaSP.Click
        Response.Redirect("Info.aspx?id=" & 20)
    End Sub

    Protected Sub lnkConsultaAFP_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkConsultaAFP.Click
        Response.Redirect("Info.aspx?id=" & 21)
    End Sub
End Class
