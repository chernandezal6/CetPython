Imports SuirPlus
Partial Class Certificaciones_verImagenCertificacion
    Inherits System.Web.UI.Page

    Protected Sub Certificaciones_verImagenCertificacion_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ImgCertificacion As Byte()
        Dim IdCertificacion As Integer

        If (Request.QueryString.Get("idCertificacion") IsNot Nothing) Then
            IdCertificacion = CInt(Request.QueryString.Get("IdCertificacion"))

            Try

                ImgCertificacion = Empresas.Certificaciones.getImagenCertificacion(IdCertificacion)
                If ImgCertificacion IsNot Nothing Then
                    Dim tipoBlob As String = Utilitarios.Utils.getMimeFromFile(ImgCertificacion)

                    Select Case tipoBlob

                        Case "application/pdf" 'pdf-"application/pdf"
                            Response.AddHeader("Content-Disposition", "filename=Documento.pdf")
                            Response.ContentType = "application/pdf"
                            Response.BinaryWrite(ImgCertificacion)
                        Case "application/octet-stream" 'tiff-"application/octet-stream"
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(ImgCertificacion)
                        Case "image/pjpeg" 'jpg-"image/pjpeg"
                            Response.AddHeader("Content-Disposition", "filename=Documento.jpeg")
                            Response.ContentType = "image/pjpeg"
                            Response.BinaryWrite(ImgCertificacion)
                        Case "application/x-zip-compressed" 'doc
                            Response.AddHeader("Content-Disposition", "filename=Documento.doc")
                            Response.ContentType = "application/msword"
                            Response.BinaryWrite(ImgCertificacion)
                        Case Else
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(ImgCertificacion)
                    End Select

                Else
                    Response.Write("<span class='label-Resaltado'>No existen documetnos scaneados para esta certificación</span>")
                End If

            Catch ex As Exception
                Response.Write("<span class='label-Resaltado'>" & ex.Message & "</span>")
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If
    End Sub
End Class
