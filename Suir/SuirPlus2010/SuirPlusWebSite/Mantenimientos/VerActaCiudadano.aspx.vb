Imports SuirPlus
Imports System.Data

Partial Class Mantenimientos_VerActaCiudadano
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim idNSS As String = Request.QueryString("idNSS")
        Dim dt As New DataTable
        Try
            dt = Ars.Consultas.getImagenNSS(CInt(idNSS))
            If dt.Rows.Count > 0 Then
                If Not IsDBNull(dt.Rows(0)("IMAGEN_ACTA")) Then
                    Dim imgBuffer As Byte() = CType(dt.Rows(0)("IMAGEN_ACTA"), Byte())
                    Response.ContentType = "image/jpeg"
                    Response.BinaryWrite(imgBuffer)
                Else
                    lblErrorMsg.Text = "NO EXISTE IMAGEN DE ACTA NACIMIENTO PARA ESTE CIUDADANO"
                End If
            Else
                lblErrorMsg.Text = "NO EXISTE IMAGEN DE ACTA NACIMIENTO PARA ESTE CIUDADANO"
            End If
        Catch ex As Exception
            lblErrorMsg.Text = "ERROR CARGANDO LA IMAGEN DE ACTA NACIMIENTO PARA ESTE CIUDADANO"
        End Try

    End Sub
End Class
