Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Data
Imports SuirPlus

<WebService(Namespace:="http://www.tss2.gov.do/Seguridad/TSS")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class Seguridad
    Inherits System.Web.Services.WebService

    <WebMethod(Description:="Metodo para cambiar el CLASS de un usuario." & _
     "<br><br> Devuelve: <br> " & _
    "a) <b>0</b>|Si se cambio el CLASS correctamente <br>" & _
    "b) <b>Un mensaje</b>|Si ocurrio un error. <br>")> _
    Public Function CambioClass(ByVal UserName As String, ByVal PasswordNuevo As String, ByVal PasswordViejo As String) As String

        Dim resultado As String
        resultado = SuirPlus.Seguridad.Usuario.CambiarClass(UserName, PasswordNuevo, PasswordViejo)

        If resultado = "0" Then
            Return "0"
        Else
            Return (Split(resultado, "|")(1))
        End If

    End Function

End Class
