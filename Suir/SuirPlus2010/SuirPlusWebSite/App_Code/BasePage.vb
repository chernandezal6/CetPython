Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Net

Public Class BasePage
    Inherits System.Web.UI.Page

    ' Variables para pasar la Info de autenticacion
    Public RoleRequerido As String
    Public PermisoRequerido As String

    Public RolesRequeridos As String()
    Public PermisosRequeridos As String()

    Public RolesOpcionales As String()
    Public PermisosOpcionales As String()

    Public Shared ReadOnly Property PageSize() As Integer
        Get
            Return 15
        End Get
    End Property

    Public ReadOnly Property UsrUserName() As String
        Get
            Return HttpContext.Current.Session("UsrUserName")
        End Get
    End Property
    Public ReadOnly Property UsrTipoUsuario() As String
        Get
            Return HttpContext.Current.Session("TipoUsuario")
        End Get
    End Property
    Public ReadOnly Property UsrNombreCompleto() As String
        Get
            Return HttpContext.Current.Session("UsrNombreCompleto")
        End Get
    End Property
    Public ReadOnly Property UsrRNC() As String
        Get
            If Me.UsrImpersonandoUnRepresentante = True Then
                Return HttpContext.Current.Session("ImpRNC")
            Else
                Return HttpContext.Current.Session("UsrRNC")
            End If
        End Get
    End Property
    Public ReadOnly Property UsrCedula() As String
        Get
            If Me.UsrImpersonandoUnRepresentante = True Then
                Return HttpContext.Current.Session("ImpCedula")
            Else
                Return HttpContext.Current.Session("UsrCedula")
            End If
        End Get
    End Property
    Public ReadOnly Property UsrNSS() As String
        Get
            If Me.UsrImpersonandoUnRepresentante = True Then
                Return HttpContext.Current.Session("ImpNSS")
            Else
                Return HttpContext.Current.Session("UsrNSS")
            End If

        End Get
    End Property
    Public ReadOnly Property UsrRegistroPatronal() As String
        Get
            If Me.UsrImpersonandoUnRepresentante = True Then
                Return HttpContext.Current.Session("ImpRegistroPatronal")
            Else
                Return HttpContext.Current.Session("UsrRegistroPatronal")
            End If
        End Get
    End Property
    Public ReadOnly Property UsrFechaLogin() As String
        Get
            Return HttpContext.Current.Session("FechaLogin")
        End Get
    End Property
    Public ReadOnly Property UsrIDTipoUsuario() As String
        Get
            Return HttpContext.Current.Session("IDTipoUsuario")
        End Get
    End Property
    Public ReadOnly Property UsrIDEntidadRecaudadora() As String
        Get
            Return HttpContext.Current.Session("IDEntidadRecaudadora")
        End Get
    End Property
    Public Property UsrImpersonandoUnRepresentante() As Boolean
        Get
            If HttpContext.Current.Session("ImpersonandoUnRepresentante") = "S" Then
                Return True
            Else
                Return False
            End If
        End Get
        Set(ByVal value As Boolean)
            If value = True Then
                HttpContext.Current.Session("ImpersonandoUnRepresentante") = "S"
            Else
                HttpContext.Current.Session("ImpersonandoUnRepresentante") = "N"
                HttpContext.Current.Session("ImpRNC") = ""
                HttpContext.Current.Session("ImpCedula") = ""
                HttpContext.Current.Session("ImpRegistroPatronal") = "'"
                HttpContext.Current.Session("ImpNSS") = ""
            End If
        End Set
    End Property
    Public Property UsrImpRNC() As String
        Set(ByVal value As String)
            HttpContext.Current.Session("ImpRNC") = value
        End Set
        Get
            Return HttpContext.Current.Session("ImpRNC")
        End Get

    End Property
    Public Property MenorACedulado() As String
        Set(ByVal value As String)
            HttpContext.Current.Session("MenorAC") = value
        End Set
        Get
            Return HttpContext.Current.Session("MenorAC")
        End Get

    End Property
    Public Property UsrImpCedula() As String
        Get
            Return HttpContext.Current.Session("ImpCedula")
        End Get
        Set(ByVal value As String)
            HttpContext.Current.Session("ImpCedula") = value
        End Set
    End Property
    Public ReadOnly Property UsrImpUserName() As String
        Get
            Return Me.UsrImpRNC & Me.UsrImpCedula
        End Get
    End Property
    Public WriteOnly Property UsrImpRegistroPatronal() As String
        Set(ByVal value As String)
            HttpContext.Current.Session("ImpRegistroPatronal") = value
        End Set
    End Property
    Public Property UsrImpNSS() As String
        Set(ByVal value As String)
            HttpContext.Current.Session("ImpNSS") = value
        End Set
        Get
            Return HttpContext.Current.Session("ImpNSS")
        End Get

    End Property
    Public ReadOnly Property SuirPlus_Status() As String
        Get
            Return HttpContext.Current.Session("SuirPlus-Status")
        End Get

    End Property

    Public ReadOnly Property SuirPlusMANTENIMIENTO() As String
        Get
            Return HttpContext.Current.Session("SuirPlus-MANTENIMIENTO")
        End Get

    End Property
    Public ReadOnly Property SuirPlusREDUCIDO() As String
        Get
            Return HttpContext.Current.Session("SuirPlus-REDUCIDO")
        End Get

    End Property

    ''' <summary>
    ''' 'Funcion para Validar que el Usuario tenga los permisos requeridos para entrar a la pagina
    ''' </summary>
    ''' <returns>Retorna verdadero si se cumplen todos los requisitos y falso de lo contrario</returns>
    ''' <remarks></remarks>
    Public Function CheckSecurity() As Boolean

        Try
            Dim url As String = Request.Path.Replace("/SuirPlusWebSite", "").ToUpper

            If Left(url, 4) = "SYS/" Then Return True
            If Left(url, 3) = "SYS" Then Return True
            If Left(url, 4) = "/SYS" Then Return True

            url = Right(url, url.Length - 1)
            If ((url <> "DEFAULT.ASPX") And (url <> "/DEFAULT.ASPX")) Then

                ''Return SuirPlus.Seguridad.Autorizacion.isUsuarioAutorizado(Me.UsrUserName, url)
                'comparamos valores de session
                If ((HttpContext.Current.Session("CambiarEmail") = "S") And (url.ToUpper() <> "EMPLEADOR/EMPACTUALIZAREMAIL.ASPX")) Then
                    Return False
                End If

                Try
                    If SuirPlus.Seguridad.Autorizacion.isUsuarioAutorizado(Me.UsrUserName, url).ToString() Then
                        Return True
                    Else
                        SuirPlus.Exepciones.Log.LogToDB(url, Me.UsrUserName)
                        Return False
                    End If

                Catch ex2 As Exception
                    SuirPlus.Exepciones.Log.LogToDB(ex2.ToString())
                End Try
            End If

            If Me.UsrUserName = "" Then
                Return False
            End If

            Return True

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Return False
        End Try

    End Function

    Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim path As String = Request.Path
        path = path.ToUpper
        path = Left(path, 11)

        Dim path2 As String = Request.Path
        path2 = path.ToUpper

        Dim DondeViene As String = Request.Path
        DondeViene = Right(DondeViene, 10)
        DondeViene = DondeViene.ToUpper

        If (DondeViene <> "LOGIN.ASPX") Then
            If Me.CheckSecurity = False Then
                System.Web.Security.FormsAuthentication.SignOut()
                Session.Abandon()
                Session("LoginErrMsg") = "Usted no tiene los permisos necesarios para acceder a este recurso."
                Response.Redirect(FormsAuthentication.LoginUrl & "?mensajeerror=Usted no tiene los permisos necesarios para acceder a este recurso.")
            End If

            If SuirPlus_Status = "MANTENIMIENTO" Then
                If Not IsInRole("800") Then
                    Response.Redirect(FormsAuthentication.LoginUrl)
                End If
            End If
        End If

        'setHighLightTextBox(Nothing)
    End Sub

    Enum Modo
        Nuevo = 1
        Edicion = 2
    End Enum

    ' Imagenes del Sistema
    Public ReadOnly Property urlLogoSuirPlus() As String
        Get
            Return Application("urlLogoSuirPlus")
        End Get
    End Property
    Public ReadOnly Property urlLogoTSS() As String
        Get
            Return Application("urlLogoTSS")
        End Get
    End Property
    Public ReadOnly Property urlLogoTSSDocumento() As String
        Get
            Return Application("urlLogoTSSDocumento")
        End Get
    End Property
    Public ReadOnly Property urlLogoDGII() As String
        Get
            Return Application("urlLogoDGII")
        End Get
    End Property
    Public ReadOnly Property urlLogoDGIIDocumento() As String
        Get
            Return Application("urlLogoDGIIDocumento")
        End Get
    End Property
    Public ReadOnly Property urlLogoINF() As String
        Get
            Return Application("urlLogoINF")
        End Get
    End Property
    Public ReadOnly Property urlLogoINFDocumento() As String
        Get
            Return Application("urlLogoINFDocumento")
        End Get
    End Property


    Public ReadOnly Property urlLogoMDT() As String
        Get
            Return Application("urlLogoMDT")
        End Get
    End Property
    Public ReadOnly Property urlLogoMDTDocumento() As String
        Get
            Return Application("urlLogoMDTDocumento")
        End Get
    End Property
    Public ReadOnly Property urlGradienteHeader() As String
        Get
            Return Application("urlGradienteHeader")
        End Get
    End Property
    Public ReadOnly Property urlBarraMenuHeader() As String
        Get
            Return Application("urlBarraMenuHeader")
        End Get
    End Property
    Public ReadOnly Property urlLogOff() As String
        Get
            Return Application("urlLogOff")
        End Get
    End Property
    Public ReadOnly Property urlBarraFooter() As String
        Get
            Return Application("urlBarraFooter")
        End Get
    End Property
    Public ReadOnly Property urlImgOK() As String
        Get
            Return Application("urlImgOK")
        End Get
    End Property
    Public ReadOnly Property urlImgCancelar() As String
        Get
            Return Application("urlImgCancelar")
        End Get
    End Property
    Public ReadOnly Property urlImgBusqueda() As String
        Get
            Return Application("urlImgBusqueda")
        End Get
    End Property
    Public ReadOnly Property urlIconoRep() As String
        Get
            Return Application("urlIconoRep")
        End Get
    End Property
    Public ReadOnly Property urlIconoUsr() As String
        Get
            Return Application("urlIconoUsr")
        End Get
    End Property
    Public ReadOnly Property urlComprobacionRep() As String
        Get
            Return Application("urlComprobacionRep")
        End Get
    End Property
    Public ReadOnly Property urlLogin() As String
        Get
            Return Application("urlLogin")
        End Get
    End Property
    Public ReadOnly Property urlLoginRep() As String
        Get
            Return Application("urlLogin") & "?log=r"
        End Get
    End Property
    Public ReadOnly Property urlLoginTMP() As String
        Get
            Return Application("LoginImp")
        End Get
    End Property
    Public ReadOnly Property urlCambioClassUsuario() As String
        Get
            Return Application("CambioClassUsuario")
        End Get
    End Property
    Public ReadOnly Property urlCambioClassRep() As String
        Get
            Return Application("CambioClassRepresentante")
        End Get
    End Property
    Public ReadOnly Property urlImprimir() As String
        Get
            Return Application("urlImprimir")
        End Get
    End Property

    Public Function IsInRole(ByVal Role As String) As Boolean
        Return SuirPlus.Seguridad.Autorizacion.isInRol(Me.UsrUserName, Role)
    End Function
    Public Function IsInAllRoles(ByVal Roles As String()) As Boolean
        Return True
    End Function
    Public Function IsInAnyRole(ByVal Roles As String()) As Boolean
        Return True
    End Function


    Public Function IsInPermiso(ByVal Permiso As String) As Boolean
        Return SuirPlus.Seguridad.Autorizacion.isInPermiso(Me.UsrUserName, Permiso)
    End Function
    Public Function IsInAllPermiso(ByVal Permisos As String()) As Boolean
        Return True
    End Function
    Public Function IsInAnyPermiso(ByVal Permisos As String()) As Boolean
        Return True
    End Function
    Public Function GetIPAddress() As String

        'Dim IP4Address As String = String.Empty

        'For Each IPA As IPAddress In Dns.GetHostAddresses(HttpContext.Current.Request.UserHostAddress)
        '    If IPA.AddressFamily.ToString() = "InterNetwork" Then
        '        IP4Address = IPA.ToString()
        '        Exit For
        '    End If
        'Next

        'If IP4Address <> String.Empty Then
        '    Return IP4Address
        'End If

        'For Each IPA As IPAddress In Dns.GetHostAddresses(Dns.GetHostName())
        '    If IPA.AddressFamily.ToString() = "InterNetwork" Then
        '        IP4Address = IPA.ToString()
        '        Exit For
        '    End If
        'Next

        'Return IP4Address

        Return Request.ServerVariables.Get("REMOTE_ADDR")

    End Function

    'Valores Constantes
    Public Const constIDRoleAdmin As String = "10"
    Public Const constIDRoleBanco As String = "56"
    Public Const constIDRoleDGII As String = "46"
    Public Const constIDRoleTSS As String = "47"
    Public Const constIDRoleCGG As String = "235"
    Public Const constIDRoleAFP As String = "699"
    Public Const constIDRoleDIDA As String = "135"

    Public Sub highLigthTextbox(ByVal parent As Control)

        For Each child As Control In parent.Controls
            If TypeOf child Is TextBox Then
                Dim TempTextBox As TextBox
                TempTextBox = CType(child, TextBox)
                TempTextBox.Attributes.Add("onFocus", "DoFocus(this);")
                TempTextBox.Attributes.Add("onBlur", "DoBlur(this);")
            End If
            If child.Controls.Count > 0 Then
                highLigthTextbox(child)
            End If
        Next

    End Sub

    Private Sub Page_PreInit(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreInit

        'If (Request.ServerVariables("htt_user_agent").IndexOf("Safari", StringComparison.CurrentCultureIgnoreCase) <> -1) Then
        '    Page.ClientTarget = "uplevel"
        'End If

        Try
            If Page.Request.ServerVariables("http_user_agent").ToLower.Contains("safari") Then
                Page.ClientTarget = "uplevel"
            End If
        Catch ex As Exception

        End Try


    End Sub
End Class
