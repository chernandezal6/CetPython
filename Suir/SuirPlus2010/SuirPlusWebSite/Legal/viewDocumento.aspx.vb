Partial Class Legal_viewDocumento
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Request.QueryString.Get("id") IsNot Nothing Then
            Try
                If IsNumeric(Request.QueryString.Get("id")) Then
                    Me.UcDocumentosLeyFacPago._IDSolicitud = CInt(Request.QueryString.Get("id"))
                    Me.UcDocumentosLeyFacPago._MostrarData()
                Else
                    Response.Write("<span class='label-Resaltado'>ID de Solicitud Inválida</span>")
                End If
            Catch ex As Exception
                Response.Write("<span class='label-Resaltado'>" & ex.Message & "</span>")
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If

    End Sub

End Class
