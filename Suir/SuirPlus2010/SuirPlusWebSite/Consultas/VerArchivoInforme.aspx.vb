Imports SuirPlus

Partial Class VerArchivoInforme
    Inherits System.Web.UI.Page

    Protected Sub Subsidios_verImagenSubsidiosSFS_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim Img As Byte()
        Dim IdInforme As Integer

        If (Request.QueryString.Get("IdInforme") IsNot Nothing) Then
            IdInforme = CInt(Request.QueryString.Get("IdInforme"))

            Try

                Img = Empresas.Empleador.getArchivoInforme(IdInforme)
                If Img IsNot Nothing Then
                    Dim tipoBlob As String = Utilitarios.Utils.getMimeFromFile(Img)

                    Select Case tipoBlob

                        Case "application/pdf" 'pdf-"application/pdf"
                            Response.AddHeader("Content-Disposition", "filename=Documento.pdf")
                            Response.ContentType = "application/pdf"
                            Response.BinaryWrite(Img)
                        Case "application/octet-stream" 'tiff-"application/octet-stream"
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(Img)
                        Case Else
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(Img)
                    End Select

                Else
                    Response.Write("<span class='label-Resaltado'>No existen documentos scaneados para esta solicitud.</span>")
                End If

            Catch ex As Exception
                Response.Write("<span class='label-Resaltado'>" & ex.Message & "</span>")
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If
    End Sub
End Class
