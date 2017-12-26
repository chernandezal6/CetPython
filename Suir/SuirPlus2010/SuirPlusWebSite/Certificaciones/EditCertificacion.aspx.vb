Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios
Imports System.Data
Imports System.IO
Partial Class Certificaciones_EditCertificacion
    Inherits BasePage
    Dim ImagenMod() As Byte
    Protected imgStream As System.IO.Stream
    Protected imgLength As Integer
    Private height As Integer
    Private width As Integer
    Private thumbnail As Boolean
    Dim idCert As Integer


    Protected Sub Certificaciones_EditCertificacion_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            If Request.QueryString("codCert") <> String.Empty Then
                idCert = CInt(Request.QueryString("codCert"))
                Me.lblIdCert.Text = idCert

            End If
            cargarfirmas()
            cargarDatos()
            Dim Estatus As String = Session("Estatus")
            If Estatus.ToUpper = "VERIFICADA" Then
                Me.flCargarImagenCert.Enabled = False
            Else
                Me.flCargarImagenCert.Enabled = True
            End If


        End If

    End Sub

    Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGuardar.Click
        Dim idFirma As Integer
        Dim Estatus As String = Session("Estatus")
        Try

            If Me.flCargarImagenCert.HasFile() = False And Me.dlFirmaResponsable.SelectedValue = "-1" Then
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "Debe selecionar lo que desea actualizar en la certificación"
                Exit Sub
            End If


            If Me.flCargarImagenCert.HasFile() = True Then
                'validamos el contenido de la imagen
                ValidarImagen()
                If Estatus.ToUpper = "RECHAZADA" Then
                    'cambiamos el status de "rechazada" a "pendiente de verificación"
                    Dim result = Empresas.Certificaciones.CambiarStatusCert(CInt(Me.lblIdCert.Text), 1, Me.UsrUserName, "Se actualizó la documentación requerida")
                    Session.Remove("Estatus")
                    If result <> 0 Then
                        Me.lblMsg.Visible = True
                        Me.lblMsg.Text = result
                        Exit Sub
                    End If

                End If
            End If

            If Me.dlFirmaResponsable.SelectedValue > 0 Then
                idFirma = CInt(dlFirmaResponsable.SelectedValue)
            End If

            'actualizamos el registro
            Dim res = Empresas.Certificaciones.SubirImagenCertificacion(CInt(Me.lblIdCert.Text), idFirma, ImagenMod, UsrUserName)
            If res = 0 Then
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "Certificaciones Actualizada!!!"
            Else
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = res
                Exit Sub
            End If

            cargarDatos()

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message

        End Try


    End Sub

    Protected Sub cargarDatos()

        Dim cert As New Empresas.Certificaciones(CInt(Me.lblIdCert.Text))
        Me.lblFirmaActual.Text = cert.FirmaResponsable & " | " & cert.PuestoFirmaResponsable
        Session("Estatus") = cert.Estatus

    End Sub

    Protected Sub cargarfirmas()

        Me.dlFirmaResponsable.DataSource = Empresas.Certificaciones.getFirmasOficinas()
        Me.dlFirmaResponsable.DataTextField = "DESCRIPCION"
        Me.dlFirmaResponsable.DataValueField = "ID"
        Me.dlFirmaResponsable.DataBind()
        Me.dlFirmaResponsable.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))

    End Sub

    Protected Sub CambiarStatus(ByVal idCert As Integer, ByVal idStatus As Integer, ByVal Comentario As String)
        Try
            Dim res = Empresas.Certificaciones.CambiarStatusCert(idCert, idStatus, Me.UsrUserName, Comentario)
            If res <> 0 Then
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = res
                Throw New Exception(res)
            End If

        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try

    End Sub

#Region "Metodos para la carga de imagenes scaneadas"

    Protected Sub ValidarImagen()
        'validacion imagen cargando(TIF o JPG )
        Try
            If Me.flCargarImagenCert.HasFile() Then
                imgStream = flCargarImagenCert.PostedFile.InputStream
                imgLength = flCargarImagenCert.PostedFile.ContentLength
                Dim imgContentType As String = flCargarImagenCert.PostedFile.ContentType
                'Dim imgFileName As String = upLImagenCiudadano.PostedFile.FileName

                'validamos los tipos de archivos que deseamos aceptar
                If (imgContentType = "image/jpeg") Or (imgContentType = "image/pjpeg") Or (imgContentType = "image/tif") Or (imgContentType = "image/tiff") Then

                    Dim imgSize As String = (imgLength / 1024)
                    If imgSize > 600 Then
                       Throw New Exception("El tamaño del archivo de imagen no debe superar los 500 KB, por favor contacte a mesa de ayuda.")
                    Else
                        Dim imageContent(imgLength) As Byte
                        imgStream.Read(imageContent, 0, imgLength)
                        ImagenMod = imageContent
                    End If
                Else
                    Throw New Exception("La imagen debe ser de tipo TIF o JPG")

                End If

            End If
        Catch ex As Exception

            Throw New Exception(ex.Message)
        End Try
    End Sub

    Private Sub RehacerImagen()
        'Lee La primera imagen
        Dim intImageSize As Int64 = Me.flCargarImagenCert.PostedFile.ContentLength
        Dim ImageStream As Stream = Me.flCargarImagenCert.PostedFile.InputStream
        Dim imageContent(intImageSize) As Byte

        ImageStream.Read(imageContent, 0, intImageSize)

        'Esto es para leer
        Dim memStream As New MemoryStream(imageContent)

        Dim fullSizeImg As System.Drawing.Image = System.Drawing.Image.FromStream(memStream)

        height = Math.Round(fullSizeImg.Height / 2)
        width = Math.Round(fullSizeImg.Width / 2)


        Dim thumbNailImg As System.Drawing.Image
        Dim dummyCallBack As New System.Drawing.Image.GetThumbnailImageAbort(AddressOf ThumbnailCallBack)

        Dim ms As New MemoryStream()


        thumbNailImg = fullSizeImg.GetThumbnailImage(width, height, dummyCallBack, IntPtr.Zero)
        thumbNailImg.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg)

        'Lee las segunda imagen
        ImagenMod = ms.GetBuffer

    End Sub

    Public Function ThumbnailCallBack() As Boolean
        Return False
    End Function

#End Region



End Class
