Imports SuirPlus.Utilitarios

Partial Class Controles_Legal_ucDocumentosLeyFacPago
    Inherits System.Web.UI.UserControl


    Public Property _RNC() As String
        Get
            Return myRNC
        End Get
        Set(ByVal value As String)
            Me.myRNC = value
        End Set
    End Property
    Public Property _IDSolicitud() As Nullable(Of Integer)
        Get
            Return Me.myIDSolicitud
        End Get
        Set(ByVal value As Nullable(Of Integer))
            Me.myIDSolicitud = value
        End Set
    End Property

    Private myRNC As String = String.Empty
    Private myIDSolicitud As Nullable(Of Integer) = Nothing

    Public Sub _MostrarData()
        Dim RegPat As Nullable(Of Integer) = Nothing
        Try

            If Not Me._RNC = String.Empty Then
                RegPat = SuirPlus.Empresas.Empleador.getEmpleadorDatos(Me._RNC).Rows(0)("id_registro_patronal")
            End If

            If Not Me._IDSolicitud.HasValue Then
                Me._IDSolicitud = Nothing
            End If

            If SuirPlus.Legal.LeyFacilidadesPago.getSolicitudFacilidadesPago(Me._IDSolicitud, RegPat, Nothing, Nothing, Nothing, "A").Rows.Count > 0 Then
                Dim dt As Byte()
                dt = SuirPlus.Legal.LeyFacilidadesPago.getImagenesLeyFacilidadesPago(Me._IDSolicitud, RegPat)

                If dt IsNot Nothing Then
                    Dim tipoBlob As String = Utils.getMimeFromFile(dt)

                    Select Case tipoBlob

                        Case "application/pdf" 'pdf-"application/pdf"
                            Response.AddHeader("Content-Disposition", "filename=Documento.pdf")
                            Response.ContentType = "application/pdf"
                            Response.BinaryWrite(dt)
                        Case "application/octet-stream" 'tiff-"application/octet-stream"
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(dt)
                        Case "image/pjpeg" 'jpg-"image/pjpeg"
                            Response.AddHeader("Content-Disposition", "filename=Documento.jpeg")
                            Response.ContentType = "image/pjpeg"
                            Response.BinaryWrite(dt)
                        Case "application/x-zip-compressed" 'doc
                            Response.AddHeader("Content-Disposition", "filename=Documento.doc")
                            Response.ContentType = "application/msword"
                            Response.BinaryWrite(dt)
                        Case Else
                            Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                            Response.ContentType = "image/tiff"
                            Response.BinaryWrite(dt)
                    End Select

                    'If dt IsNot Nothing Then
                    '    Response.ContentType = "image/tiff"
                    '    Response.BinaryWrite(dt)
                Else
                    Throw New Exception("Esta solictud no tiene imagen escaneada.")
                End If
            Else
                Throw New Exception("No existen documentos escaneados para este empleador.")
            End If







        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try

    End Sub

End Class
