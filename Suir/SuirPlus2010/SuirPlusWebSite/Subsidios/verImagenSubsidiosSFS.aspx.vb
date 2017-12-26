Imports SuirPlus

Partial Class Subsidios_verImagenSubsidiosSFS
    Inherits System.Web.UI.Page

    Protected Sub Subsidios_verImagenSubsidiosSFS_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ImgSubsidiosSFS As Byte()
        Dim IdSolicitud As Integer

        If (Request.QueryString.Get("IdSolicitud") IsNot Nothing) Then
            IdSolicitud = CInt(Request.QueryString.Get("IdSolicitud"))

            Try

                ImgSubsidiosSFS = Empresas.SubsidiosSFS.Consultas.getImagenSubSFS(IdSolicitud)
                If ImgSubsidiosSFS IsNot Nothing Then
                    Dim tipoBlob As String = Utilitarios.Utils.getMimeFromFile(ImgSubsidiosSFS)

                    Select Case tipoBlob

                        Case "application/pdf" 'pdf-"application/pdf"
                            Response.AddHeader("Content-Disposition", "filename=Documento.pdf")
                            Response.ContentType = "application/pdf"
                            Response.BinaryWrite(ImgSubsidiosSFS)
                        Case "application/octet-stream" 'tiff-"application/octet-stream"
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(ImgSubsidiosSFS)
                        Case "image/pjpeg" 'jpg-"image/pjpeg"
                            Response.AddHeader("Content-Disposition", "filename=Documento.jpeg")
                            Response.ContentType = "image/pjpeg"
                            Response.BinaryWrite(ImgSubsidiosSFS)
                        Case "application/x-zip-compressed" 'doc
                            Response.AddHeader("Content-Disposition", "filename=Documento.doc")
                            Response.ContentType = "application/msword"
                            Response.BinaryWrite(ImgSubsidiosSFS)
                        Case Else
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(ImgSubsidiosSFS)
                    End Select

                Else
                    Response.Write("<span class='label-Resaltado'>No existen documetnos scaneados para esta solicitud.</span>")
                End If

            Catch ex As Exception
                Response.Write("<span class='label-Resaltado'>" & ex.Message & "</span>")
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If
    End Sub
End Class
