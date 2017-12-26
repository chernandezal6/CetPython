Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios
Imports System.Data
Imports System.IO
Imports SuirPlus.Utilitarios.TiffManager
Imports SuirPlus.Empresas.Empleador


Partial Class Consultas_AnexarDocumento
    Inherits BasePage
    Dim ImagenMod() As Byte
    Private documentos As ArrayList
    Protected imgStream As System.IO.Stream
    Protected imgLength As Integer
    Private height As Integer
    Private width As Integer
    Dim IdReg As Integer
    Dim usuario As String
    Private thumbnail As Boolean
    Private archivoFinal As String = "C:\TestingTiff\Documentos.TIFF"

    Protected Sub Consultas_AnexarDocumento_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            If (Request.QueryString.Get("idReg") IsNot Nothing) And (Request.QueryString.Get("usuario") IsNot Nothing) Then
                IdReg = CInt(Request.QueryString.Get("IdReg"))
                usuario = Request.QueryString.Get("usuario").ToString

                btnGuardar.Enabled = True
            Else
                btnGuardar.Enabled = False
                lblMsgDocumento.Text = "Ocurrió un error cargando el módulo, por favor intente nuevamente"
            End If
        Catch ex As Exception
            lblMsgDocumento.Text = "Ocurrió un error cargando el módulo, por favor intente nuevamente"
        End Try
    End Sub

    Protected Function ValidarImagen() As Boolean
        'validacion imagen cargando(TIF o JPG )
        Try
            imgStream = fuDocumentos.PostedFile.InputStream
            imgLength = fuDocumentos.PostedFile.ContentLength
            Dim imgContentType As String = fuDocumentos.PostedFile.ContentType

            'validamos los tipos de archivos que deseamos aceptar
            If (imgContentType = "image/tif") Or (imgContentType = "image/tiff") Then

                Dim imgSize As String = (imgLength / 1024)
                If imgSize > 600 Then
                    lblMsgDocumento.Text = "El tamaño del archivo no debe superar los 500 KB, por favor contacte a mesa de ayuda."
                    Return False
                Else
                    Dim imageContent(imgLength) As Byte
                    imgStream.Read(imageContent, 0, imgLength)
                    ImagenMod = imageContent
                    Return True
                End If
            Else
                lblMsgDocumento.Text = "El documento a anexar debe ser de tipo TIF"
                Return False
            End If

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB("Ocurrio el siguiente error leyendo la imagen de empleadores: " & ex.ToString())
        End Try

        Return False

    End Function

    Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGuardar.Click

        Dim tiffMan As New TiffManager()

        If fuDocumentos.HasFile() Then
            If ValidarImagen() Then
                If Request.QueryString.Get("accion").ToString = "Anexar" Then
                    AnexarDocumentos()
                ElseIf Request.QueryString.Get("accion").ToString = "Subir" Then
                    GuardarArchivo(ImagenMod)
                End If
            Else
                Exit Sub
            End If
        Else
            lblMsgDocumento.Text = "El documento es requerido"
            Exit Sub
        End If

    End Sub
    Private Sub AnexarDocumentos()

        Dim tiffMan As New TiffManager()

        '1: Leer el TIFF que esta en la base de datos, separar sus paginas y agregarlas al listado de imagenes para unir----
        Try
            Dim dt = SuirPlus.Empresas.Empleador.getDocumentoEmpleador(IdReg)

            If Not IsDBNull(dt.Rows(0)("DOCUMENTOS_REGISTRO")) Then
                Dim ImgDoc = dt.Rows(0)("DOCUMENTOS_REGISTRO")
                documentos = tiffMan.SplitTiffImageStream(ImgDoc, System.Drawing.Imaging.EncoderValue.CompressionLZW)
            Else
                lblMsgDocumento.Text = "No existe documento al cual anexar el documento nuevo"
                Exit Sub
            End If

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB("Ocurrio el siguiente error leyendo" _
                                            & "la imagen de empleadores: " & ex.ToString())
            Exit Sub
        End Try

        DocumentosNuevos(documentos)

    End Sub
    Private Sub DocumentosNuevos(ByVal documentos As ArrayList)

        '2: Agregar al listado la(s) imagen(es) nueva(s)-----------------------------------------------------------------
        Dim tiffMan As New TiffManager()
        Dim tempImages = tiffMan.SplitTiffImageStream(ImagenMod, System.Drawing.Imaging.EncoderValue.CompressionLZW)

        For Each img As Stream In tempImages
            documentos.Add(img)
        Next

        UnirDocumentos()

    End Sub
    Private Sub UnirDocumentos()
        Dim img As Byte() = Nothing
        '3: Unir imagenes en el archivo TIFF en memoria
        Try
            img = TiffManager.JoinTiffImagesStreamMS(documentos, System.Drawing.Imaging.EncoderValue.CompressionLZW)
            If Not img Is Nothing Then
                GuardarArchivo(img)
            Else
                lblMsgDocumento.Text = "El archivo no se pudo anexar, por favor intente nuevamente"
                Exit Sub
            End If
        Catch ex As Exception
            lblMsgDocumento.Text = "El archivo no se pudo anexar " + ex.Message
            Exit Sub
        End Try

        '******************************************************************************************************
        '3.1: Unir imagenes en el archivo TIFF fisico en el servidor
        'If TiffManager.JoinTiffImagesStream(documentos, archivoFinal, System.Drawing.Imaging.EncoderValue.CompressionLZW) Then
        '    Dim documento = System.IO.File.ReadAllBytes(archivoFinal)
        '    If GuardarArchivo(documento) Then
        '        BorrarArchivo()
        '    End If
        'Else
        '    lblMsgDocumento.Text = "El archivo no se pudo anexar, por favor intente nuevamente"
        '    Exit Sub
        'End If
    End Sub

    Private Function GuardarArchivo(ByVal documento As Byte()) As Boolean

        '4: grabar en la DB en el campo BLOB del empleador----------------------------------------------------------------
        Try
            Dim result = Empleador.setDocumentoEmpleador(IdReg, documento, usuario)

            If result.Equals("0") Then
                lblMsgDocumento.Text = "Documento actualizado exitosamente"
                Return True
            Else
                lblMsgDocumento.Text = "El archivo no se pudo grabar, por favor intente nuevamente"
                Return False
            End If

        Catch ex As Exception
            lblMsgDocumento.Text = "El archivo no se pudo grabar, por favor intente nuevamente"
            Return False
        End Try

    End Function

    Private Sub BorrarArchivo()

        '5: Borrar archivo----------------------------------------------------------------------------------------------
        Try
            System.IO.File.Delete(archivoFinal)
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB("Ocurrio el siguiente error borrando" _
                                               & "el archivo Documento: " & ex.ToString())
        End Try

    End Sub

End Class
