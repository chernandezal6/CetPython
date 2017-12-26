Imports SuirPlus
Imports System.Data
Imports System.IO

Partial Class Controles_ucCargarImagenSubsidio
    Inherits System.Web.UI.UserControl

    Private myImgStream As System.IO.Stream
    Private ImgStream As System.IO.Stream
    Private imgLength As Integer
    Private height As Integer
    Private width As Integer
    Private thumbnail As Boolean
    Dim ImagenMod() As Byte



    Public Property imgStream2() As System.IO.Stream
        Get
            Return myImgStream
        End Get

        Set(ByVal value As System.IO.Stream)
            myImgStream = value
        End Set

    End Property

    Protected Sub Controles_ucCargarImagenSubsidio_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        GenerateUploadForm()
    End Sub

    Protected Sub GenerateUploadForm()
        ' if querystring parameter "MODE" is set to "IFRAME" 
        Dim mode As String = Request.QueryString("MODE")
        If Not mode = "IFRAME" Then Return
        pnlIFrame.Visible = False
        pnlFileUpload.Visible = True
    End Sub


    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpload.Click

        Try
            If Me.fuImagenSubsidio.HasFile() Then
                ImgStream = fuImagenSubsidio.PostedFile.InputStream
                imgLength = fuImagenSubsidio.PostedFile.ContentLength
                Dim imgContentType As String = fuImagenSubsidio.PostedFile.ContentType
                Dim imgFileName As String = fuImagenSubsidio.PostedFile.FileName

                'validamos los tipos de archivos que deseamos aceptar
                If (imgContentType = "image/jpeg") Or (imgContentType = "image/pjpeg") Or (imgContentType = "image/tif") Or (imgContentType = "image/tiff") Then

                    Dim imgSize As String = (imgLength / 1024)
                    If imgSize > 600 Then
                        Throw New Exception("El tamaño del archivo de imagen no debe superar los 500 KB, por favor contacte a mesa de ayuda.")
                    Else
                        Dim imageContent(imgLength) As Byte
                        ImgStream.Read(imageContent, 0, imgLength)
                        'ImagenMod = imageContent
                        Throw New Exception("La imagen será cargada cuando el metodo este disponible")
                        'insertamos la imagen
                        ' Dim result As String = Empresas.SubsidiosSFS.EnfermedadComun.CargaImagenFormulario("id movimiento", "ID linea", imgFileName, imageContent)

                    End If
                Else
                    Throw New Exception("La imagen debe ser de tipo TIF o JPG")

                End If

            End If

        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

End Class
