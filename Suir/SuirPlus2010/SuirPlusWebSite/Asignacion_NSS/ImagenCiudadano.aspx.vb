Imports SuirPlus
Imports SuirPlusEF.Repositories
Partial Class Asignacion_NSS_ImagenCiudadano
    Inherits System.Web.UI.Page
    Dim repCiudadano As New CiudadanoRepository()

    Protected Sub form1_Load(sender As Object, e As System.EventArgs) Handles form1.Load
        Dim imagen As Byte()
        Dim idNss As String

        If (Request.QueryString.Get("nss") IsNot Nothing) Then
            idNss = Request.QueryString.Get("nss")

            Try
                Dim ciudadano = repCiudadano.GetByNSS(idNss)
                imagen = ciudadano.ImagenActa
                If imagen IsNot Nothing Then

                    Dim tipoBlob As String = Utilitarios.Utils.getMimeFromFile(imagen)
                    Select Case tipoBlob

                        Case "application/pdf" 'pdf-"application/pdf"
                            Response.AddHeader("Content-Disposition", "filename=Documento.pdf")
                            Response.ContentType = "application/pdf"
                            Response.BinaryWrite(imagen)
                        Case "application/octet-stream" 'tiff-"application/octet-stream"
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(imagen)
                        Case "image/pjpeg" 'jpg-"image/pjpeg"
                            Response.AddHeader("Content-Disposition", "filename=Documento.jpeg")
                            Response.ContentType = "image/pjpeg"
                            Response.BinaryWrite(imagen)
                        Case "application/x-zip-compressed" 'doc
                            Response.AddHeader("Content-Disposition", "filename=Documento.doc")
                            Response.ContentType = "application/msword"
                            Response.BinaryWrite(imagen)
                        Case Else
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(imagen)
                    End Select
                Else
                    Response.Write("<span class='label-Resaltado'>Este ciudadano no tiene imagen para visualizar</span>")
                End If
            Catch ex As Exception
                Response.Write("<span class='label-Resaltado'>" & ex.Message & "</span>")
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If
    End Sub

End Class
