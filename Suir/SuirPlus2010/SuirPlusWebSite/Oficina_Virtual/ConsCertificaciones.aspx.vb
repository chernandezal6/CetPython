Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios

Partial Class Oficina_Virtual_ConsCertificaciones
    Inherits SeguridadOFV
    Dim Nro_documento As String = String.Empty
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Nro_documento = UserNoDocument
        If UserNoDocument <> Nothing Then
            Consultar()
            Me.bind()
        Else
            Response.Redirect("LoginOficinaVirtual.aspx")
        End If
    End Sub
    Private Sub bind()
        Dim dt As New DataTable
        Try
            dt = Empresas.Certificaciones.getCertificacionesOFV(String.Empty, Nro_documento, "3")
            If dt.Rows.Count > 0 Then
                If Utilitarios.Utils.HayErrorEnDataTable(dt) = False Then
                    gvCertificaciones.DataSource = dt
                    gvCertificaciones.DataBind()
                    OcultarCeldas()
                Else
                    dvError.Visible = True
                    txtError.InnerText = Utilitarios.Utils.sacarMensajeDeErrorDesdeTabla(dt)
                End If
            Else
                dvError.Visible = True
                txtError.InnerText = "No hay data disponible."
            End If
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try

    End Sub
    Protected Sub gvCertificaciones_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvCertificaciones.RowCommand
        If e.CommandName = "Entregada" Then
            Dim b, c, d As String
            b = String.Empty
            c = String.Empty
            d = String.Empty

            Dim random = New Random(DateTime.Now.Millisecond)
            Dim rand As Random = New Random()
            Dim letras = Enumerable.Range(0, 20).Select(Function(i) (Chr(Asc("A") + rand.Next(0, 26)))).OrderBy(Function(x) random.Next()).ToList()
            Dim letras2 = Enumerable.Range(20, 40).Select(Function(i) (Chr(Asc("A") + rand.Next(0, 26)))).OrderBy(Function(x) random.Next()).ToList()
            Dim letras3 = Enumerable.Range(40, 60).Select(Function(i) (Chr(Asc("A") + rand.Next(0, 26)))).OrderBy(Function(x) random.Next()).ToList()

            For Each l As String In letras
                b = b & l
            Next
            For Each l As String In letras2
                c = c & l
            Next
            For Each l As String In letras3
                d = d & l
            Next

            Dim Resultado = Convert.ToBase64String(Encoding.ASCII.GetBytes(e.CommandArgument.ToString().ToCharArray()))
            Response.Redirect(Application("servidor") + "Oficina_Virtual/CertImpresa.aspx?A=" + Resultado + "&b=" + b + "&C=" + c + "&D=" + d + "")
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
    Sub OcultarCeldas()
        For i = 0 To gvCertificaciones.Rows.Count - 1
            If gvCertificaciones.Rows(i).Cells(2).Text <> "Entregada" Then
                CType(gvCertificaciones.Rows(i).FindControl("ibDescargar"), ImageButton).Visible = False
                'CType(gvConsulta.Rows(i).FindControl("ibDescargar"), HyperLink).Visible = False
            End If
        Next
    End Sub
    Protected Sub btnRegresar_Click(sender As Object, e As EventArgs) Handles btnRegresar.Click
        Response.Redirect("OficinaVirtual.aspx", True)
    End Sub
End Class

