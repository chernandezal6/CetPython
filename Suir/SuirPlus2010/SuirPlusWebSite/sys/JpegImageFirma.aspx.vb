
Imports System.Data
Imports System.Drawing
Imports System.Drawing.Imaging
Imports SuirPlus.Utilitarios
Imports SuirPlus.Empresas
Imports System.IO

Partial Class JpegImageFirma
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try

            If Not IsPostBack Then

                Dim data As Byte() = Convert.FromBase64String(Request.QueryString("A"))

                Dim NroCert As String = System.Text.ASCIIEncoding.ASCII.GetString(data)

                Dim cert As Certificaciones = New Certificaciones(CInt(NroCert))


                Dim img As Byte() = cert.FirmaImagen

                Dim memStream As New MemoryStream(img)
                makeThumb(System.Drawing.Image.FromStream(memStream))

            End If

        Catch ex As Exception

        End Try
    End Sub

    Private Sub makeThumb(ByVal fullSizeImg As System.Drawing.Image)

        Dim thumbNailImg As System.Drawing.Image
        Dim dummyCallBack As New System.Drawing.Image.GetThumbnailImageAbort(AddressOf ThumbnailCallBack)

        'thumbNailImg = fullSizeImg.GetThumbnailImage(351, 200, dummyCallBack, IntPtr.Zero)
        thumbNailImg = fullSizeImg.GetThumbnailImage(301, 150, dummyCallBack, IntPtr.Zero)
        thumbNailImg.Save(Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg)

    End Sub

    Public Function ThumbnailCallBack() As Boolean
        Return False
    End Function
End Class
