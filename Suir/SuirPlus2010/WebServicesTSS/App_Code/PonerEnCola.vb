Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports SuirPlus
Imports System.IO
Imports iTextSharp.text
Imports iTextSharp.tool.xml
Imports iTextSharp.text.pdf
Imports SuirPlus.Empresas
Imports System.Data
Imports System.Net
Imports SuirPlusEF.Models
Imports SuirPlusEF.Service
Imports RabbitMQ.Client

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")>
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)>
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Public Class PonerEnCola
    Inherits System.Web.Services.WebService

    <WebMethod(Description:="Método para poner en cola las solicitudes de asignacion de NSS para NUI. <br><br>" &
     "Esta función devuelve un OK." &
     "")>
    Public Function NUI(ByVal Mensaje As String) As String
        Dim ds As New Data.DataSet
        Try
            ' Llamar a RabbitMQ y pasarle el # de Solicitud
            SuirPlusEF.Service.RabbitMQ.EnviarMensaje(SuirPlusEF.Service.RabbitMQ.ColaAsignacionNSSEnum.asignacion_nss_NUI.ToString(), Mensaje)
            Return "OK"
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Return ex.Message.ToString()
        End Try

        Return String.Empty

    End Function

    <WebMethod(Description:="Método para poner en cola las solicitudes de asignacion de NSS para cedulados. <br><br>" &
     "Esta función devuelve un OK." &
     "")>
    Public Function Cedulado(ByVal Mensaje As String) As String
        Dim ds As New Data.DataSet
        Try
            ' Llamar a RabbitMQ y pasarle el # de Solicitud
            SuirPlusEF.Service.RabbitMQ.EnviarMensaje(SuirPlusEF.Service.RabbitMQ.ColaAsignacionNSSEnum.asignacion_nss_cedulado.ToString(), Mensaje)
            Return "OK"
        Catch ex As Exception
            Return ex.Message.ToString()
        End Try

        Return String.Empty

    End Function

    <WebMethod(Description:="Método para poner en cola las solicitudes de asignacion de NSS para extranjero. <br><br>" &
     "Esta función devuelve un OK." &
     "")>
    Public Function Extranjero(ByVal Mensaje As String) As String
        Dim ds As New Data.DataSet
        Try
            ' Llamar a RabbitMQ y pasarle el # de Solicitud
            SuirPlusEF.Service.RabbitMQ.EnviarMensaje(SuirPlusEF.Service.RabbitMQ.ColaAsignacionNSSEnum.asignacion_nss_extranjero.ToString(), Mensaje)
            Return "OK"
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Return ex.Message.ToString()
        End Try

        Return String.Empty

    End Function

    <WebMethod(Description:="Método para poner en cola las solicitudes de asignacion de NSS para menor con acta de nacimiento. <br><br>" &
     "Esta función devuelve un OK." &
     "")>
    Public Function MenorConActa(ByVal Mensaje As String) As String
        Dim ds As New Data.DataSet
        Try
            ' Llamar a RabbitMQ y pasarle el # de Solicitud
            SuirPlusEF.Service.RabbitMQ.EnviarMensaje(SuirPlusEF.Service.RabbitMQ.ColaAsignacionNSSEnum.asignacion_nss_menor_nac_acta.ToString(), Mensaje)
            Return "OK"
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Return ex.Message.ToString()
        End Try

        Return String.Empty

    End Function

    <WebMethod(Description:="Método para poner en cola las solicitudes de asignacion de NSS para menor extranjero. <br><br>" &
     "Esta función devuelve un OK." &
     "")>
    Public Function MenorExtranjero(ByVal Mensaje As String) As String
        Dim ds As New Data.DataSet
        Try
            ' Llamar a RabbitMQ y pasarle el # de Solicitud
            SuirPlusEF.Service.RabbitMQ.EnviarMensaje(SuirPlusEF.Service.RabbitMQ.ColaAsignacionNSSEnum.asignacion_nss_menor_extranjero.ToString(), Mensaje)
            Return "OK"
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Return ex.Message.ToString()
        End Try

        Return String.Empty

    End Function

    '<WebMethod(Description:="Método para poner en cola las solicitudes de asignacion de NSS. <br><br>" &
    ' "Esta función devuelve un OK." &
    ' "")>
    'Public Function SolicitudEnCola(ByVal Mensaje As String) As String
    '    Dim ds As New Data.DataSet
    '    Try
    '        ' Llamar a RabbitMQ y pasarle el # de Solicitud
    '        SuirPlusEF.Service.RabbitMQ.EnviarMensaje(SuirPlusEF.Service.RabbitMQ.ColaAsignacionNSSEnum.asignacion_nss.ToString(), Mensaje)
    '        Return "OK"
    '    Catch ex As Exception
    '        SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
    '        Return ex.Message.ToString()
    '    End Try

    '    Return String.Empty

    'End Function

End Class