Imports SuirPlus

Partial Class Legal_verImagenNotificacion
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ImgNotificacion As Byte()
        Dim IdNotificacion As Integer

        If (Request.QueryString.Get("idNotificacion") IsNot Nothing) And (IsNumeric(Request.QueryString.Get("idNotificacion"))) Then
            IdNotificacion = CInt(Request.QueryString.Get("idNotificacion"))
            Try

                ImgNotificacion = Legal.Notificacion.getImagenNotificacion(IdNotificacion)
                If ImgNotificacion IsNot Nothing Then

                    Dim tipoBlob As String = Utilitarios.Utils.getMimeFromFile(ImgNotificacion)
                    Select Case tipoBlob
                        Case "application/pdf" 'pdf-"application/pdf"
                            Response.AddHeader("Content-Disposition", "filename=Documento.pdf")
                            Response.ContentType = "application/pdf"
                            Response.BinaryWrite(ImgNotificacion)
                        Case "application/octet-stream" 'tiff-"application/octet-stream"
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(ImgNotificacion)
                        Case "image/pjpeg" 'jpg-"image/pjpeg"
                            Response.AddHeader("Content-Disposition", "filename=Documento.jpeg")
                            Response.ContentType = "image/pjpeg"
                            Response.BinaryWrite(ImgNotificacion)
                        Case "application/x-zip-compressed" 'doc
                            Response.AddHeader("Content-Disposition", "filename=Documento.doc")
                            Response.ContentType = "application/msword"
                            Response.BinaryWrite(ImgNotificacion)
                        Case Else
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(ImgNotificacion)
                    End Select

                Else
                    Response.Write("<span class='label-Resaltado'>No existe la imagen de esta Notificación</span>")
                End If

            Catch ex As Exception
                Response.Write("<span class='label-Resaltado'>" & ex.Message & "</span>")
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If

    End Sub

End Class
