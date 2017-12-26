Imports System
Imports System.IO
Imports SuirPlus.Config
Imports System.Data
'nueva pagina manejo archivos python ch
Partial Class Bancos_DescargaArchivosProcesados
    Inherits BasePage

    Protected idReferencia As String
    Protected tipoArchivo As String
    Protected fileName As String

    Dim sw As StreamWriter
    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        idReferencia = Request.QueryString.Item("ref").Split("|")(0)
        tipoArchivo = Request.QueryString.Item("ref").Split("|")(1)
        If idReferencia <> String.Empty And tipoArchivo <> String.Empty Then
            getArchivoRespuesta(CInt(idReferencia), tipoArchivo)
        Else
            Throw New Exception("Error descargando el archivo.")
        End If

    End Sub

    Protected Sub getArchivoRespuesta(ByVal p_referencia As Integer, ByVal p_tipo As String)
        Dim dt As DataTable
        Dim encrypted As String = String.Empty
        Dim arch_ne As String = String.Empty
        Dim nombre_archivo As String = String.Empty
        Dim tmpWMS As MemoryStream = New MemoryStream()
        Dim outFile As MemoryStream = New MemoryStream()

        dt = SuirPlus.Empresas.ManejoArchivoPython.getArchivoRespuestaPago(p_referencia, p_tipo)

        If dt.Rows.Count > 0 Then

            If p_tipo = "N" Then
                arch_ne = dt.Rows(0)("ARCHIVO_RESPUESTA_NACHA").ToString
                nombre_archivo = dt.Rows(0)("nombre_archivo_nacha").ToString
            Else
                arch_ne = dt.Rows(0)("ARCHIVO_RESPUESTA").ToString
                nombre_archivo = dt.Rows(0)("nombre_archivo_respuesta").ToString
            End If

            tmpWMS = writeToStream(arch_ne)
            tmpWMS = New MemoryStream(tmpWMS.ToArray())

            outFile = SuirPlus.Empresas.ManejoArchivoPython.EncryptFile(tmpWMS)

            Response.Clear()
            Page.Controls.Clear()
            Response.ContentType = "text/plain"
            Response.AppendHeader("Content-Disposition", "attachment; filename=""" & nombre_archivo & """")
            Response.BinaryWrite(outFile.ToArray())
            Response.Flush()

            EnableViewState = False
        Else
            Throw New Exception("no existen registros.")
        End If
    End Sub

    Private Function getFileName(ByVal idReferencia As Integer, ByVal tipoArchivo As String) As String
        Return SuirPlus.Bancos.Dgii.getNombreArchivos(idReferencia, tipoArchivo)
    End Function

    Public Function writeToStream(data As String) As MemoryStream

        Using ms = New MemoryStream()
            sw = New StreamWriter(ms)
            sw.WriteLine(data)
            ' The string is currently stored in the 
            ' StreamWriters buffer. Flushing the stream will 
            ' force the string into the MemoryStream.
            sw.Flush()

            ' If we dispose the StreamWriter now, it will close 
            ' the BaseStream (which is our MemoryStream) which 
            ' will prevent us from reading from our MemoryStream
            'DON'T DO THIS - sw.Dispose();
            Return ms
        End Using
    End Function

End Class
