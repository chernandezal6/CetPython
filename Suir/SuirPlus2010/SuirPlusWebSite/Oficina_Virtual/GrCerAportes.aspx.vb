Imports System.Data
Imports SuirPlus
Partial Class Oficina_Virtual_GrCerAportes
    Inherits SeguridadOFV
    Dim Nro_documento As String = String.Empty
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Nro_documento = UserNoDocument
        If UserNoDocument <> Nothing Then
            '12 --> Para firmas
            '3  --> Tipo de certificación
            Consultar()
            ConsultarCer()
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
            'lblFechaNac.Text = String.Format("{0:d}", CDate(infoDT.Rows(0)("FECHA_NACIMIENTO").ToString()))
            lblNSS.Text = infoDT.Rows(0)("ID_NSS").ToString()
        Else
        End If
    End Sub
    Private Sub ConsultarCer()
        Dim infoDT As String
        Dim Result
        infoDT = SuirPlus.Empresas.Certificaciones.SolicitudCertificacionOFV("3", Nro_documento)
        Result = infoDT.Split("|")
        If Result(0).ToString() = "0" Then
            lblNoCertificacion.Text = Result(1).ToString()
            lblNoDocumento.Text = Nro_documento
        End If
    End Sub
    Protected Sub btnRegresar_Click(sender As Object, e As EventArgs) Handles btnRegresar.Click
        Response.Redirect("OficinaVirtual.aspx", True)
    End Sub
    Protected Sub btnConscertificacion_Click(sender As Object, e As EventArgs) Handles btnConscertificacion.Click
        Response.Redirect("ConsCertificaciones.aspx", True)
    End Sub
End Class