
Imports System.Data
Imports System.Drawing
Imports System.Drawing.Imaging
Imports SuirPlus.Utilitarios

Partial Class images_jpegBarra
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try

            Dim Id As String = Request.QueryString("Id")

            Dim barcode As New BarcodeLib.Barcode() With {.IncludeLabel = False, .Alignment = BarcodeLib.AlignmentPositions.CENTER, .Height = 50}

            Dim img As Image = barcode.Encode(BarcodeLib.TYPE.CODE128B, Id)

            ' Change the response headers to output a JPEG image.
            Me.Response.Clear()
            Me.Response.ContentType = "image/jpeg"

            ' Write the image to the response stream in JPEG format.
            img.Save(Me.Response.OutputStream, ImageFormat.Jpeg)


            img.Dispose()
        Catch ex As Exception

        End Try
    End Sub
End Class
