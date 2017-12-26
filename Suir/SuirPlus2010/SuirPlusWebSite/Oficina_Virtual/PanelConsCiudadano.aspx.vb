Imports System.Data

Partial Class Oficina_Virtual_PanelConsCiudadano
    Inherits SeguridadOFV

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
        infoDT = SuirPlus.Utilitarios.TSS.getCiudadano(Nro_documento + "", "", "", "", "", "", "", "", "", "", "")
        If infoDT.Rows.Count > 0 Then
            lblNombre.Text = infoDT.Rows(0)("NOMBRES").ToString()
            lblApellido.Text = infoDT.Rows(0)("PRIMER_APELLIDO").ToString()
            lblFechaNac.Text = String.Format("{0:d}", CDate(infoDT.Rows(0)("FECHA_NACIMIENTO").ToString()))
            lblNSS.Text = infoDT.Rows(0)("ID_NSS").ToString()
        Else
        End If
    End Sub
End Class
