Imports SuirPlus


Partial Class Reg_VerImagenesSolicitud
    Inherits System.Web.UI.Page

    Protected Sub form1_Load(sender As Object, e As System.EventArgs) Handles form1.Load
        Dim byteDoc As Byte()
        Dim idDoc As String
        Dim idrequisito As String

        Dim Tipo As String


        If (Request.QueryString.Get("idDoc") IsNot Nothing) Then
            idDoc = CDec(Request.QueryString.Get("idDoc"))
            idrequisito = CDec(Request.QueryString.Get("req"))
            Try

                Dim Res = SuirPlus.Mantenimientos.Mantenimientos.getImagenesPasaportes(idDoc, idrequisito)

                byteDoc = Res.Rows(0).Item(2)
                Tipo = Res.Rows(0).Item(3).ToString()

                If byteDoc IsNot Nothing Then
                    'Dim tipoBlob As String = Utilitarios.Utils.getMimeFromFile(byteDoc)

                    Select Case Tipo
                        Case "application/vnd.ms-word"
                            Response.AddHeader("Content-Disposition", "filename=Documento.doc")
                            Response.ContentType = "application/vnd.ms-word"
                            Response.BinaryWrite(byteDoc)
                        Case "application/vnd.ms-excel"
                            Response.AddHeader("Content-Disposition", "filename=Documento.xls")
                            Response.ContentType = "application/vnd.ms-excel"
                            Response.BinaryWrite(byteDoc)
                        Case "image/jpg"
                            Response.AddHeader("Content-Disposition", "filename=Documento.jpg")
                            Response.ContentType = "image/jpg"
                            Response.BinaryWrite(byteDoc)
                        Case "image/png"
                            Response.AddHeader("Content-Disposition", "filename=Documento.png")
                            Response.ContentType = "image/png"
                            Response.BinaryWrite(byteDoc)

                        Case "application/pdf"
                            Response.AddHeader("Content-Disposition", "filename=Documento.pdf")
                            Response.ContentType = "application/pdf"
                            Response.BinaryWrite(byteDoc)

                        Case "image/gif"
                            Response.AddHeader("Content-Disposition", "filename=Documento.pdf")
                            Response.ContentType = "image/gif"
                            Response.BinaryWrite(byteDoc)

                        Case Else
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(byteDoc)
                    End Select

                Else
                    Response.Write("<span class='label-Resaltado'>No existen documentos en este registro.</span>")
                End If

            Catch ex As Exception
                Response.Write("<span class='label-Resaltado'>" & ex.Message & "</span>")
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If
    End Sub
End Class
