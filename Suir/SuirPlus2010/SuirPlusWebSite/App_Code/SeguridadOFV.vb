Imports Microsoft.VisualBasic

Public Class SeguridadOFV
    Inherits System.Web.UI.Page
    Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim path As String = Request.Path


        If path.Contains("Oficina_Virtual") Then

            If Validado = 0 Then

                If path.Contains("LoginPage") Or path.Contains("RegUsuarioEmp") Then
                Else
                    'System.Web.Security.FormsAuthentication.SignOut()
                    'Session.Abandon()
                    'Session("LoginErrMsg") = "Usuario debe registrarse para poder acceder a este recurso."
                    'Response.Redirect(FormsAuthentication.LoginUrl & "?mensajeerror=Usted no tiene los permisos necesarios para acceder a este recurso.")
                    'Response.Redirect("LoginPage.aspx" & "?mensajeerror=Usted no tiene los permisos necesarios para acceder a este recurso.")
                End If

            End If
        End If
    End Sub
    'Public ReadOnly Property RegUserName() As String
    '    Get
    '        Return HttpContext.Current.Session("UserName")
    '    End Get
    'End Property
    'Public Function IsInPermiso(ByVal Permiso As String) As Boolean
    '    Return SuirPlus.Seguridad.Autorizacion.isInPermiso(UserNameOFV, Permiso)
    'End Function
    Public ReadOnly Property UserNameOFV() As String
        Get
            Return HttpContext.Current.Session("UserNameOFV")
        End Get
    End Property
    Public ReadOnly Property UserNoDocument() As String
        Get
            Return HttpContext.Current.Session("UserNoDocument")
        End Get
    End Property
    Public ReadOnly Property RegNombreCompleto() As String
        Get
            Return HttpContext.Current.Session("NombreCompleto")
        End Get
    End Property
    Public ReadOnly Property Validado() As Integer
        Get
            Return Convert.ToInt32(HttpContext.Current.Session("Estatus"))
            'Deben de declarar un hiddenfield para pasar este valor en la pagina RegNuevaEmpresa, porque sino lo hacen se pierde
        End Get

    End Property
    Sub AutenticarUsuario()
        FormsAuthentication.SetAuthCookie(UserNameOFV, False)

        Dim ticket1 = New FormsAuthenticationTicket(1, "UserNameOFV", DateTime.Now, DateTime.Now.AddMinutes(10), False, "OficinaVirtual")

        Dim cookie1 = New HttpCookie(FormsAuthentication.FormsCookieName, FormsAuthentication.Encrypt(ticket1))
        Response.Cookies.Add(cookie1)

        Dim returnUrl1 As String

        If (Request.QueryString("ReturnUrl") = String.Empty) Then
            returnUrl1 = "OficinaVirtual.aspx"
        Else
            returnUrl1 = "LoginOficinaVirtual.aspx"

        End If
        Response.Redirect(returnUrl1)
    End Sub
End Class
