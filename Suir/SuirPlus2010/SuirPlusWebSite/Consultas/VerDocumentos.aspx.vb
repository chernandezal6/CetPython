
Partial Class VerDocumentos
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ImgDoc As Byte()
        Dim IdReg As Integer
        Dim dt As New System.Data.DataTable

        If (Request.QueryString.Get("idReg") IsNot Nothing) Then
            IdReg = CInt(Request.QueryString.Get("IdReg"))
            Try

                dt = SuirPlus.Empresas.Empleador.getDocumentoEmpleador(IdReg)

                If Not IsDBNull(dt.Rows(0)("DOCUMENTOS_REGISTRO")) Then
                    ImgDoc = dt.Rows(0)("DOCUMENTOS_REGISTRO")

                    Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                    Response.ContentType = "image/tiff"
                    Response.BinaryWrite(ImgDoc)
                Else
                    Response.Write("<span class='label-Resaltado'>No existe Documento</span>")
                End If
            Catch ex As Exception
                Response.Write("<span class='label-Resaltado'>" & ex.Message & "</span>")
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If
    End Sub
End Class
