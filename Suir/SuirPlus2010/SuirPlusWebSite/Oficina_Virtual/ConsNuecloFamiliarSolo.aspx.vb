Imports System.Data

Partial Class Oficina_Virtual_ConsultasInfEmpleo
    Inherits SeguridadOFV

    Dim Valor As String = String.Empty
    Dim Nro_documento As String = String.Empty
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Nro_documento = UserNoDocument
        If UserNoDocument <> Nothing Then
            Consultar()
        Else
            Response.Redirect("LoginOficinaVirtual.aspx")
        End If
    End Sub

    Private Sub Consultar()
        Dim infoDT As DataTable
        infoDT = SuirPlus.Ars.Consultas.consultaAfilado(Nro_documento, Valor, "", "", "", "", "")
        gvNucleoFamiliar.DataSource = infoDT
        gvNucleoFamiliar.DataBind()
        infoTitulo.Visible = True
        Titulo.InnerText = "Núcleo Familiar"
    End Sub
    Protected Sub btnRegresar_Click(sender As Object, e As EventArgs) Handles btnRegresar.Click
        Response.Redirect("OficinaVirtual.aspx", True)
        'Response.Redirect("OficinaVirtual.aspx?nro_documento=" + Request.QueryString("nro_documento"), True)
    End Sub
End Class
