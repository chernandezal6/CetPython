Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Collections.Generic
Imports SuirPlus
Imports SuirPlus.Empresas
Imports System

<WebService(Namespace:="http://suirplus/Webservices/", Description:="Servicio Web para ofrecer autocompletado.")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
<System.Web.Script.Services.ScriptService()> _
Public Class AutoComplete
    Inherits System.Web.Services.WebService

    <WebMethod(Description:="Se obtiene un listado de empleador via Razón Social.")> _
    Public Function getRSList(ByVal prefixText As String, ByVal count As Int16) As String()

        Dim dt = New Data.DataTable
        Try
            dt.Load(Empleador.getRazonSocialList(prefixText, count))
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Throw New Exception(ex.ToString())
            'Return New String() {}
        End Try

        Dim sugerencia As New List(Of String)

        If dt.Rows.Count > 0 Then

            For Each dr As Data.DataRow In dt.Rows
                sugerencia.Add(dr("razon_social").ToString())
            Next
        End If

        dt.Dispose()

        Return sugerencia.ToArray()



    End Function

    <WebMethod(Description:="Se obtiene un listado de empleador via Nombre Comercial.")> _
    Public Function getNCList(ByVal prefixText As String, ByVal count As Int16) As String()
        Dim dt = New Data.DataTable

        Try
            dt.Load(Empleador.getNombreComercialList(prefixText, count))
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Throw New Exception(ex.ToString())
            'Return New String() {}
        End Try

        Dim sugerencia As New List(Of String)

        If dt.Rows.Count > 0 Then

            For Each dr As Data.DataRow In dt.Rows
                sugerencia.Add(dr("nombre_comercial").ToString())
            Next
        End If

        dt.Dispose()

        Return sugerencia.ToArray()

    End Function


    <WebMethod(Description:="Se obtiene un listado de PSS via Nombre de la misma.")> _
    Public Function getPSSList(ByVal prefixText As String, ByVal count As Int16) As String()

        Dim dt = New Data.DataTable

        Try
            dt.Load(Empleador.getNombrePSS(prefixText, count))

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Throw New Exception(ex.ToString())
            'Return New String() {}
        End Try

        Dim sugerencia As New List(Of String)

        If dt.Rows.Count > 0 Then

            For Each dr As Data.DataRow In dt.Rows
                sugerencia.Add(dr("prestadora_nombre").ToString())
            Next
        End If

        dt.Dispose()

        Return sugerencia.ToArray()

    End Function
End Class
