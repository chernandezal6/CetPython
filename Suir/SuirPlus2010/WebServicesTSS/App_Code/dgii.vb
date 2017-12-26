Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Data
Imports SuirPlus
' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class dgii
    Inherits System.Web.Services.WebService
    Public ReadOnly Property IP() As String
        Get
            Return HttpContext.Current.Request.ServerVariables("LOCAL_ADDR")
        End Get
    End Property

    Private myFact As Empresas.Facturacion.LiquidacionISR
    <WebMethod(Description:="Consulta de notificaciones pendiente de pago por numero de referencia.<br><br>" & _
        "Esta función devuelve un dataset con el numero de referencia consultado, en caso de que haya un error se devuelve el codigo mas la descripción." & _
        "<br><br> Los Errores que devuelve son: <br> " & _
        "a) <b>804</b>|Error en el Usuario o Password <br>" & _
        "b) <b>16</b>|Esta Referencia no se encuentra en nuestras bases de datos <br>" & _
        "c) <b>803</b>|Esta Referencia ya fue autorizada <br>" & _
        "d) <b>801</b>|Esta Referencia ya fue pagada <br>" & _
        "e) <b>802</b>|Esta Referencia ya fue cancelada <br>" & _
        "")> _
    Public Function ConsultarPorReferencia(ByVal UserName As String, ByVal Password As String, ByVal NroReferencia As String) As DataSet

        Dim ds As New DataSet("ConsultaPorReferencia")

        Try
            ds.Tables.Add(Empresas.Facturacion.Factura.ConsultarPorReferenciaISR(NroReferencia, UserName, Password).Copy())
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, ex.Message)
        End Try

        Return ds

    End Function

    <WebMethod(Description:="Metodo para autorizar una referencia de pago de la ISR. <br><br>" & _
      "Esta función devuelve un String con el Numero de Autorización, en caso de que haya un error se devuelve el codigo mas la descripción." & _
      "<br><br> Los Errores que devuelve son: <br> " & _
       "a) <b>804</b>|Error en el Usuario o Password <br>" & _
       "b) <b>16</b>|Esta Referencia no se encuentra en nuestras bases de datos <br>" & _
       "c) <b>803</b>|Esta Referencia ya fue autorizada <br>" & _
       "d) <b>801</b>|Esta Referencia ya fue pagada <br>" & _
       "e) <b>802</b>|Esta Referencia ya fue cancelada <br>" & _
       "f) <b>17</b>|Esta factura debe estar vigente o su total debe ser mayor que 0 para ser autorizada <br>" & _
      "")> _
    Public Function AutorizarReferencia(ByVal UserName As String, ByVal Password As String, ByVal NroReferencia As String) As String

        Try
            Dim nroAutorizacion As String = String.Empty

            Dim resultado = Empresas.Facturacion.Factura.AutorizarReferencia(NroReferencia, UserName, Password, nroAutorizacion)

            If resultado = "0" Then
                Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.ISR, UserName, Password, nroAutorizacion & "|" & Msg.FacturaAutorizada, "A")

                Return nroAutorizacion & "|" & Msg.FacturaAutorizada
            Else
                Return resultado
            End If
        Catch ex12 As Exception
            Return ex12.Message
            SuirPlus.Exepciones.Log.LogToDB(ex12.ToString())
        End Try

    End Function

End Class