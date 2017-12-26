
Partial Class Controles_ucInfoUsuario
    Inherits System.Web.UI.UserControl

    Public Enum TipoUsuario
        REPRESENTANTE = 0
        USUARIO = 1
        ADMINISTRADOR = 2
    End Enum

    Private Property estatuUsuario() As String
        Get
            Return viewState("HAY_USUARIO")
        End Get
        Set(ByVal Value As String)
            viewState("HAY_USUARIO") = Value
        End Set
    End Property

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not IsPostBack Then Me.cargaControl()
        ''Response.Write(Application("urlIconoUsr"))

    End Sub

    'Determina si hay un usuario en el sistema y coloca su informacion 
    'de lo contrario coloca los accesos del sistema
    Private Sub cargaControl()

        If hayUsuario() Then
            'Cargando panel con informacion de usuario
            setInfoUsuario()
        Else
            'Cargando panel con accesos del sistema
            Me.setAccesos()
        End If

    End Sub

    'Cargando los accesos al sistema
    Private Sub setAccesos()
        Me.pnlInfoUsuario.Visible = False
        Me.pnlAccesoSistema.Visible = True
    End Sub

    'Carga el control con la informacion del usuario actual
    Private Sub setInfoUsuario()

        Me.imgUsuario.ImageUrl = Application("urlIconoUsr")
        Me.lblNombreUsuario.Text = SuirPlus.Utilitarios.Utils.ProperCase(Me.getNombreUsuario)



        Me.lblTipoUsuario.Text = Me.getDescripcionTipoUsuario
        Me.lblFechaActual.Text = getFechaLogIn()

        Me.pnlInfoUsuario.Visible = True
        Me.pnlAccesoSistema.Visible = False



    End Sub

    Private Function getIconoUsuarioUrl() As String

        Dim retorno As String = String.Empty
        Dim bPage As New BasePage
        Select Case Me.getTipoUsuario

            Case "2"
                'Return System.Configuration.ConfigurationSettings.AppSettings("ICONO_REPRESENTANTE")
                retorno = bPage.urlIconoRep
            Case "1"
                'Return System.Configuration.ConfigurationSettings.AppSettings("ICONO_USUARIO")
                retorno = bPage.urlIconoUsr
        End Select

        Return retorno

    End Function

    Public Function getTipoUsuario() As String

        Dim bPage As New BasePage
        Return bPage.UsrIDTipoUsuario

    End Function

    Private Function getDescripcionTipoUsuario() As String

        Dim bPage As New BasePage
        Return bPage.UsrTipoUsuario

    End Function


    Private Function getFechaLogIn() As String

        Dim bPage As New BasePage
        Dim tmpFecha As Date = bPage.UsrFechaLogin
        Return tmpFecha.ToString("hh:mm | dd-MM-yyyy")

    End Function

    Private Function getNombreUsuario() As String

        Dim bPage As New BasePage
        Return bPage.UsrNombreCompleto

    End Function

    Private Function hayUsuario() As Boolean

        Dim Usr As String = ""
        Usr = HttpContext.Current.Session("UsrNombreCompleto")

        If Usr Is Nothing Then
            Return False
        Else
            Return True
        End If


    End Function

End Class
