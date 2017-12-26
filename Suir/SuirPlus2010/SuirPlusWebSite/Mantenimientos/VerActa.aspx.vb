Imports SuirPlus
Imports SuirPlus.Empresas

Partial Class Consultas_VerActa
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ImgActa As Byte()
        Dim numLote As String
        Dim numDetalle As String
        Dim dt As New System.Data.DataTable

        numLote = Request.QueryString.Get("idLote")
        numDetalle = Request.QueryString.Get("idRegistro")


        If (numLote IsNot Nothing Or numDetalle IsNot Nothing) Then
            Try

                dt = Empresas.Consultas.getImagenRegLote(numLote, numDetalle)

                If Not dt.Rows(0)("imagen_acta").ToString() = Nothing Then

                    ImgActa = dt.Rows(0)("imagen_acta")

                    Dim tipoBlob As String = SuirPlus.Utilitarios.Utils.getMimeFromFile(ImgActa)

                    Select Case tipoBlob

                        Case "application/pdf" 'pdf-"application/pdf"
                            Response.AddHeader("Content-Disposition", "filename=Documento.pdf")
                            Response.ContentType = "application/pdf"
                            Response.BinaryWrite(ImgActa)
                        Case "application/octet-stream" 'tiff-"application/octet-stream"
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(ImgActa)
                        Case "image/pjpeg" 'jpg-"image/pjpeg"
                            Response.AddHeader("Content-Disposition", "filename=Documento.jpeg")
                            Response.ContentType = "image/pjpeg"
                            Response.BinaryWrite(ImgActa)
                        Case "application/x-zip-compressed" 'doc
                            Response.AddHeader("Content-Disposition", "filename=Documento.doc")
                            Response.ContentType = "application/msword"
                            Response.BinaryWrite(ImgActa)
                        Case Else
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(ImgActa)
                    End Select

                Else
                    Response.Write("<span class='label-Resaltado'>No existe la imagen</span>")
                End If
            Catch ex As Exception
                Response.Write("<span class='label-Resaltado'>" & ex.Message & "</span>")
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If
    End Sub
End Class
