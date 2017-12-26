Imports System.Data

Partial Class Oficina_Virtual_ConsEmpReportados
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
        Try
            infoDT = SuirPlus.Ars.Consultas.getEmpReportados(Nro_documento)
            If (infoDT.Rows.Count > 0) Then
                gvEmpleadoresR.DataSource = infoDT
                gvEmpleadoresR.DataBind()
                dvError.Visible = False
                txtError.InnerText = ""
            Else
                dvError.Visible = True
                txtError.InnerText = "No existen registros para esta consulta."
            End If
        Catch ex As Exception
            dvError.Visible = True
            txtError.InnerText = ex.Message.ToString()
        End Try
    End Sub
    Protected Sub btnRegresar_Click(sender As Object, e As EventArgs) Handles btnRegresar.Click
        Response.Redirect("OficinaVirtual.aspx", True)
    End Sub
End Class
