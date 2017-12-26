Imports System.Data
Imports SuirPlus.Ars
Imports SuirPlus
Imports System.Collections.Generic
Imports SuirPlus.Exepciones

Partial Class Mantenimientos_MostrarEvaluacionFallecido
    Inherits BasePage
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Dim nss As Integer = Request.QueryString("Nss")

        Dim dt As New DataTable

        Dim stream As System.IO.MemoryStream
        Dim img As System.Drawing.Image

        Try
        dt = Ars.Consultas.getInfoEvaluacionActaFallecido()

        If dt.Rows.Count > 0 Then
            If Not IsDBNull(dt.Rows(0)("imagen_acta_defuncion")) Then
                Dim imgBuffer As Byte() = CType(dt.Rows(0)("imagen_acta_defuncion"), Byte())

                    If imgBuffer IsNot Nothing Then
                        stream = New System.IO.MemoryStream(imgBuffer)
                        img = System.Drawing.Image.FromStream(stream)

                        Dim tipoBlob As String = Utilitarios.Utils.getMimeFromFile(imgBuffer)


                        Select Case tipoBlob

                            Case "application/octet-stream" 'tiff-"application/octet-stream"
                                'Esto para convertir la imagen a jpg y que pueda ser vista en google chrome y mozilla.
                                'System.Drawing.Bitmap.FromStream(stream).Save(Context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg)
                                Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                                Response.ContentType = "image/tiff"
                                Response.BinaryWrite(imgBuffer)
                            Case "image/pjpeg" 'jpg-"image/pjpeg"
                                Response.ContentType = "image/pjpeg"
                                Response.BinaryWrite(imgBuffer)
                            Case "application/pdf" 'pdf-"application/pdf"
                                Response.AddHeader("Content-Disposition", "filename=Documento.pdf")
                                Response.ContentType = "application/pdf"
                                Response.BinaryWrite(imgBuffer)
                            Case "application/x-zip-compressed" 'doc
                                Response.AddHeader("Content-Disposition", "filename=Documento.doc")
                                Response.ContentType = "application/msword"
                                Response.BinaryWrite(imgBuffer)
                            Case Else
                                ' System.Drawing.Bitmap.FromFile(img).Save(img, System.Drawing.Imaging.ImageFormat.Jpeg)
                                ' System.Drawing.Bitmap.FromStream(stream).Save(Context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg)
                                Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                                Response.ContentType = "image/tiff"
                                Response.BinaryWrite(imgBuffer)
                        End Select

                    Else
                        Response.Write("<span class='label-Resaltado'>No existen documentos escaneados para esta certificación</span>")
                    End If
                End If
            End If

        Catch ex As Exception
            Response.Write("<span class='label-Resaltado'>" & ex.Message & "</span>")
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

End Class
