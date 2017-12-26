Imports System.Data
Imports SuirPlus.Ars
Imports SuirPlus
Imports System.Collections.Generic
Imports SuirPlus.Exepciones

Partial Class Mantenimientos_MostrarEvaluacionPasaporte
    Inherits BasePage

    Dim id_solicitud As String
    Dim id_requisito As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsNothing(Request.QueryString("id_solicitud")) Then
            id_solicitud = Request.QueryString("id_solicitud")
        Else
            id_solicitud = Session("Sol")

        End If
        If Not IsNothing(Request.QueryString("id_requisito")) Then
            id_requisito = Request.QueryString("id_requisito")
        Else
            id_requisito = Session("Req")
        End If



        Dim dt As New DataTable

        Dim stream As System.IO.MemoryStream
        Dim img As System.Drawing.Image

        Try
            dt = Mantenimientos.Mantenimientos.getImagenesPasaportes(id_solicitud, id_requisito)


            If dt.Rows.Count > 0 Then
                If Not IsDBNull(dt.Rows(0)("documento")) Then
                    Dim imgBuffer As Byte() = CType(dt.Rows(0)("documento"), Byte())

                    If imgBuffer IsNot Nothing Then
                        stream = New System.IO.MemoryStream(imgBuffer)
                        img = System.Drawing.Image.FromStream(stream)

                        Dim tipoBlob As String = Utilitarios.Utils.getMimeFromFile(imgBuffer)


                        Select Case tipoBlob
                            Case "image/jpg"
                                Response.AddHeader("Content-Disposition", "filename=Documento.jpg")
                                Response.ContentType = "image/jpg"
                                Response.BinaryWrite(imgBuffer)
                            Case "image/png"
                                Response.AddHeader("Content-Disposition", "filename=Documento.png")
                                Response.ContentType = "image/png"
                                Response.BinaryWrite(imgBuffer)
                            Case "image/gif"
                                Response.AddHeader("Content-Disposition", "filename=Documento.gif")
                                Response.ContentType = "image/gif"
                                Response.BinaryWrite(imgBuffer)
                            Case Else
                                ' System.Drawing.Bitmap.FromFile(img).Save(img, System.Drawing.Imaging.ImageFormat.Jpeg)
                                ' System.Drawing.Bitmap.FromStream(stream).Save(Context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg)
                                Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                                Response.ContentType = "image/tiff"
                                Response.BinaryWrite(imgBuffer)
                        End Select

                    Else
                        Response.Write("<span class='label-Resaltado'>No existen imagen para este pasaporte</span>")

                    End If
                End If
            End If

        Catch ex As Exception
            Response.Write("<span class='label-Resaltado'>" & ex.Message & "</span>")
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try


    End Sub

End Class
