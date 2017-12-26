Imports System
Imports System.IO
Imports SuirPlus.Config
Imports System.Data

Partial Class Bancos_consDescargaArchivosProcesados
    Inherits BasePage

    Protected idReferencia As String
    Protected tipoArchivo As String
    Protected fileName As String
    Protected pathFile As String = ConfigurationSettings.AppSettings.Item("FOLDER_ARCHIVOS_SUIR2")

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        idReferencia = Request.QueryString.Item("ref")
        tipoArchivo = Request.QueryString.Item("tipo")
        'fileName = Request.QueryString.Item("nacha").Split("|")(0)
        'tipoArchivo = Request.QueryString.Item("nacha").Split("|")(1)

        If idReferencia = Nothing Or idReferencia = String.Empty Then
            Exit Sub
        End If

        If tipoArchivo = Nothing Or tipoArchivo = String.Empty Then
            Exit Sub
        End If

        If Left(tipoArchivo.ToUpper, 1).Equals("R") Then
            pathFile += "archivos_respuestas\"

        ElseIf Left(tipoArchivo.ToUpper, 1).Equals("N") Then
            pathFile += "archivos_nacha\"
        End If

        fileName = getFileName(idReferencia, tipoArchivo)


        'If fileName = String.Empty Then
        '    Exit Sub
        'End If
        'If tipoArchivo.Equals("R") Then

        '    pathFile += "archivos_respuestas\"

        'ElseIf tipoArchivo.Equals("N") Then

        '    pathFile += "archivos_nacha\"

        'End If

        Response.Clear()
        Page.Controls.Clear()

        Response.ContentType = "text/plain"
        Response.AppendHeader("Content-Disposition", "attachment; filename=""" & Me.fileName & """")
        Response.WriteFile(pathFile & fileName)
        Response.Flush()

        Session.Remove("nacha")
        EnableViewState = False

    End Sub

    Private Function getFileName(ByVal idReferencia As Integer, ByVal tipoArchivo As String) As String
        Return SuirPlus.Bancos.Dgii.getNombreArchivos(idReferencia, tipoArchivo)

    End Function

End Class
