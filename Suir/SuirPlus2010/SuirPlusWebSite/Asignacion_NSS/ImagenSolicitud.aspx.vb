
Imports SuirPlusEF.Repositories
Partial Class Asignacion_NSS_ImagenSolicitud
    Inherits System.Web.UI.Page

    Dim repSolicitud As New DetalleSolicitudesRepository()

    Protected Sub form1_Load(sender As Object, e As System.EventArgs) Handles form1.Load
        Dim ImagenDocumento As Byte()
        Dim idRegistro As String

        If (Request.QueryString.Get("registro") IsNot Nothing) Then
            idRegistro = Request.QueryString.Get("registro")

            Dim imagen = repSolicitud.GetByRegistro(idRegistro)
            Try
                ImagenDocumento = imagen.IMAGEN_SOLICITUD

                Dim tipoBlob As String = SuirPlus.Utilitarios.Utils.getMimeFromFile(ImagenDocumento)
                Select Case tipoBlob

                    Case "application/pdf" 'pdf-"application/pdf"
                        Response.AddHeader("Content-Disposition", "filename=Documento.pdf")
                        Response.ContentType = "application/pdf"
                        Response.BinaryWrite(ImagenDocumento)
                    Case "application/octet-stream" 'tiff-"application/octet-stream"
                        Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                        Response.ContentType = "image/tiff"
                        Response.BinaryWrite(ImagenDocumento)
                    Case "image/pjpeg" 'jpg-"image/pjpeg"
                        Response.AddHeader("Content-Disposition", "filename=Documento.jpeg")
                        Response.ContentType = "image/pjpeg"
                        Response.BinaryWrite(ImagenDocumento)
                    Case "application/x-zip-compressed" 'doc
                        Response.AddHeader("Content-Disposition", "filename=Documento.doc")
                        Response.ContentType = "application/msword"
                        Response.BinaryWrite(ImagenDocumento)
                    Case Else
                        Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                        Response.ContentType = "image/tiff"
                        Response.BinaryWrite(ImagenDocumento)
                End Select
            Catch ex As Exception
                Response.Write("<span class='label-Resaltado'>" & ex.Message & "</span>")
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If
    End Sub

End Class
