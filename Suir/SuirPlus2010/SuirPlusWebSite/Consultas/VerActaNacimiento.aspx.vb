
Partial Class Consultas_VerActaNacimiento
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ImgActa As Byte()
        Dim IdNss As Integer
        Dim dt As New System.Data.DataTable

        If (Request.QueryString.Get("idNss") IsNot Nothing) Then
            IdNss = CInt(Request.QueryString.Get("idNss"))
            Try

                dt = SuirPlus.Utilitarios.TSS.getConsultaNss(String.Empty, _
                                            IdNss, String.Empty, _
                                            String.Empty, _
                                            String.Empty, 1, 1)

                If Not dt.Rows(0)("Imagen_Acta").ToString() = Nothing Then

                    ImgActa = dt.Rows(0)("Imagen_Acta")

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
