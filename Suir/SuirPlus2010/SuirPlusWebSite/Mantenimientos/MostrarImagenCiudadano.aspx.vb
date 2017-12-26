Imports System.Data
Imports SuirPlus.Ars
Imports SuirPlus
Imports System.Collections.Generic
Imports SuirPlus.Exepciones

Partial Class Mantenimientos_MostrarImagenCiudadano
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim idNss As String = Request.QueryString("id")

        Dim dt As New DataTable
        dt = Ars.Consultas.getInfoEvaluacionActaCiudadanos(CType(idNss, Integer))

        If dt.Rows.Count > 0 Then
            If Not IsDBNull(dt.Rows(0)("IMAGEN_ACTA")) Then
                Dim imgBuffer As Byte() = CType(dt.Rows(0)("IMAGEN_ACTA"), Byte())
                Response.ContentType = "image/jpeg"
                Response.BinaryWrite(imgBuffer)
            End If
        End If
    End Sub

End Class
