Imports SuirPlus
Partial Class Legal_verImagenAcuerdoPago
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ImgAcuerdo As Byte()
        Dim IdAcuerdo As Integer
        Dim tipoAcuerdo As Integer

        If (Request.QueryString.Get("idAcuerdo") IsNot Nothing) And (IsNumeric(Request.QueryString.Get("idAcuerdo")) And Request.QueryString.Get("tipoAcuerdo") IsNot Nothing) And (IsNumeric(Request.QueryString.Get("tipoAcuerdo"))) Then
            IdAcuerdo = CInt(Request.QueryString.Get("idAcuerdo"))
            tipoAcuerdo = CInt(Request.QueryString.Get("tipoAcuerdo"))
            Try

                ImgAcuerdo = Legal.AcuerdosDePago.getImagenAcuerdoPago(IdAcuerdo, tipoAcuerdo)
                If ImgAcuerdo IsNot Nothing Then
                    Dim tipoBlob As String = Utilitarios.Utils.getMimeFromFile(ImgAcuerdo)

                    Select Case tipoBlob

                        Case "application/pdf" 'pdf-"application/pdf"
                            Response.AddHeader("Content-Disposition", "filename=Documento.pdf")
                            Response.ContentType = "application/pdf"
                            Response.BinaryWrite(ImgAcuerdo)
                        Case "application/octet-stream" 'tiff-"application/octet-stream"
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(ImgAcuerdo)
                        Case "image/pjpeg" 'jpg-"image/pjpeg"
                            Response.AddHeader("Content-Disposition", "filename=Documento.jpeg")
                            Response.ContentType = "image/pjpeg"
                            Response.BinaryWrite(ImgAcuerdo)
                        Case "application/x-zip-compressed" 'doc
                            Response.AddHeader("Content-Disposition", "filename=Documento.doc")
                            Response.ContentType = "application/msword"
                            Response.BinaryWrite(ImgAcuerdo)
                        Case Else
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(ImgAcuerdo)
                    End Select

                    'Response.ContentType = "image/tiff"
                    'Response.BinaryWrite(ImgAcuerdo)
                Else
                    Response.Write("<span class='label-Resaltado'>No existe la imagen de este acuerdo de pago</span>")
                End If

            Catch ex As Exception
                Response.Write("<span class='label-Resaltado'>" & ex.Message & "</span>")
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If

    End Sub

End Class
