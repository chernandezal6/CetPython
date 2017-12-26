Imports SuirPlus
Partial Class Legal_documentUpload
    Inherits BasePage

    Const SCRIPT_TEMPLATE As String = "<script type='text/javascript'>window.parent.documentUploadComplete('{0}', {1});</script>"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If IsPostBack Then
            UploadDocument()
        End If
    End Sub
    Private Sub UploadDocument()

        Dim script As String = String.Empty
        If (Not filPhoto Is Nothing And filPhoto.PostedFile.ContentLength > 0) Then

            'Verificamos si es un documento válido.
            If Not isValidDocumentFile(filPhoto) Then

                script = String.Format(SCRIPT_TEMPLATE, "El archivo cargado no es un documento válido.", "true")

            End If
        Else

            script = String.Format(SCRIPT_TEMPLATE, "Por favor especifíque un archivo válido.", "true")

        End If

        'Si todo esta correcto procedemos a guardar el archivo en la base de datos.
        If String.IsNullOrEmpty(script) Then
            Try
                Dim imgStream As System.IO.Stream = filPhoto.PostedFile.InputStream
                Dim imgContent(filPhoto.PostedFile.ContentLength) As System.Byte
                imgStream.Read(imgContent, 0, filPhoto.PostedFile.ContentLength)
                'Para restringir el tamaño de la imagen a subir a no mas de 500KB
                If (filPhoto.PostedFile.ContentLength / 1024) > 500 Then
                    script = String.Format(SCRIPT_TEMPLATE, "El tamaño del archivo de imagen no debe superar los 500 KB, por favor contacte a mesa de ayuda.", "true")
                Else
                    Legal.AcuerdosDePago.SubirImagenAcuerdoPago(CInt(Session("idAcuerdo")), CInt(Session("tipoAcuerdo")), imgContent, Me.UsrUserName)
                    script = String.Format(SCRIPT_TEMPLATE, "Documento cargado.", "false")
                End If
            Catch ex As Exception
                script = String.Format(SCRIPT_TEMPLATE, ex.Message, "true")
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

        End If
        'Now inject the script which will fire when the page is refreshed.
        ClientScript.RegisterStartupScript(Me.GetType(), "uploadNotify", script)


    End Sub
    Private Function isValidDocumentFile(ByVal file As HtmlInputFile) As Boolean

        Dim contentType As String = file.PostedFile.ContentType
        If Not contentType = "image/jpeg" And _
         Not contentType = "image/gif" And _
         Not contentType = "image/tiff" And _
         Not contentType = "image/pjpeg" And _
         Not contentType = "image/bmp" Then
            Return False
        End If

        Return True

    End Function

End Class
