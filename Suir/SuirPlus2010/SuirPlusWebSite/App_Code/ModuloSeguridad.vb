Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Web.Script.Services
Imports System.Data
Imports SuirPlus.Seguridad
Imports System.Web.Script.Serialization
Imports SuirPlus.Utilitarios

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
 Public Class ModuloSeguridad
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)> _
    Public Function listarUsuarios(pCriterio As String, pPageSize As Integer, pCurrentPage As Integer, pSortColumn As String, pSortOrder As String) As String
        Try
            Dim cantidadRegistros As String = String.Empty
            Dim totalPaginas As String = String.Empty

            Dim dt = Usuario.listarUsuarios(pCriterio, pCurrentPage, pPageSize)
            If dt.Rows.Count > 0 Then
                cantidadRegistros = dt.Rows(0)("RECORDCOUNT").ToString()
                totalPaginas = Convert.ToInt32(cantidadRegistros / pPageSize)
            End If

            Dim jArray As String()() = New String(dt.Rows.Count - 1)() {}

            Dim i As Integer = 0

            For Each rs As DataRow In dt.Rows
                jArray(i) = New String() {rs("ID_USUARIO").ToString(), rs("NOMBRE").ToString(), rs("STATUS").ToString(), rs("EMAIL").ToString()}
                i = i + 1
            Next

            Dim jsonData = New With { _
                    Key .total = totalPaginas, _
                    Key .page = pCurrentPage, _
                    Key .records = cantidadRegistros, _
                    Key .rows = jArray
                }

            Return New JavaScriptSerializer().Serialize(jsonData)

        Catch ex As Exception
            Throw ex
        End Try

    End Function

End Class