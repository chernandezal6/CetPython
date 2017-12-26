<%@ WebHandler Language="VB" Class="CargarImagenFormulario" %>

Imports System
Imports System.Web
Imports System.IO
Imports SuirPlus

Public Class CargarImagenFormulario : Implements IHttpHandler
    
    Dim ImagenMod() As Byte
    Dim imgContentType As String
    Dim imgFileName As String
    Protected imgLength As Integer
    Protected imgStream As System.IO.Stream

    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        Dim file As HttpPostedFile = context.Request.Files("File")
        Dim IdFormulario As String = context.Request("nrosolimagen")
        
        Try
          
            imgStream = file.InputStream
            imgLength = file.ContentLength
            imgContentType = file.ContentType
            imgFileName = file.FileName

            'validamos los tipos de archivos que deseamos aceptar
            If (imgContentType = "image/jpeg") Or (imgContentType = "image/pjpeg") Or (imgContentType = "application/pdf") Then

                Dim imgSize As String = (imgLength / 1024)
                If imgSize > 650 Then
                    context.Response.ContentType = "text/plain"
                    context.Response.Write("{""d"":""El tamaño del archivo de imagen no debe superar los 650 KB, por favor contacte a mesa de ayuda.""}")
                    Exit Sub
                Else
                    Dim imageContent(imgLength) As Byte
                    imgStream.Read(imageContent, 0, imgLength)
                    ImagenMod = imageContent
                End If
                    
                Dim result As String = Empresas.SubsidiosSFS.Consultas.CargarImagen(CInt(IdFormulario), ImagenMod, imgFileName)
                  
                If result = "0" Then
                    context.Response.ContentType = "text/plain"
                    context.Response.Write("{""d"":""Exito""}")
                    Exit Sub
                Else
                    Throw New Exception("La imagen debe ser de tipo JPG,PDF")
                End If
                
            Else
                Throw New Exception("La imagen debe ser de tipo JPG,PDF")
            End If

        Catch ex As Exception
            context.Response.ContentType = "text/plain"
            context.Response.Write("{""d"":""" + ex.Message + """}")
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class