
Imports System.Data
Imports System.Drawing
Imports System.Drawing.Imaging
Imports SuirPlus.Utilitarios

Partial Class images_JpegImage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            ' Create a CAPTCHA image using the text stored in the Session object.
            Dim ci As CaptchaImage


            ci = New CaptchaImage(Me.Session("CaptchaImageText").ToString(), 200, 100, "Century Schoolbook")



            ' Change the response headers to output a JPEG image.
            Me.Response.Clear()
            Me.Response.ContentType = "image/jpeg"

            ' Write the image to the response stream in JPEG format.
            ci.Image.Save(Me.Response.OutputStream, ImageFormat.Jpeg)

            ' Dispose of the CAPTCHA image object.
            ci.Dispose()
        Catch ex As Exception

        End Try
    End Sub
End Class
