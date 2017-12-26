Imports System.Data
Imports SuirPlus.Ars
Imports SuirPlus
Imports System.Collections.Generic
Imports SuirPlus.Exepciones

Partial Class Mantenimientos_MostrarImagen
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim id As String = Request.QueryString("id")
        ' Dim idSol As String = Request.QueryString("id_solicitud")

        Dim dt As New DataTable
        dt = Ars.Consultas.getInfoAsignacionNss(id)

        If dt.Rows.Count > 0 Then
            If Not IsDBNull(dt.Rows(0)("IMAGEN_ACTA")) Then
                Dim imgBuffer As Byte() = CType(dt.Rows(0)("IMAGEN_ACTA"), Byte())
                Response.ContentType = "image/jpeg"
                Response.BinaryWrite(imgBuffer)
                ' Else
                'NO EXISTE IMAGEN DE ACTA NACIMIENTO PARA ESTE CIUDADANO
            End If
        End If

    End Sub
    
End Class
