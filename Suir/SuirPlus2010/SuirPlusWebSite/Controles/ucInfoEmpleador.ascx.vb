
Partial Class Controles_ucInfoEmpleador
    Inherits System.Web.UI.UserControl


    Public Property RazonSocial() As String
        Get
            Return Me.lblRegPatronal.Text
        End Get
        Set(ByVal Value As String)
            Me.lblRazonSocial.Text = Value
        End Set
    End Property

    Public Property NombreComercial() As String
        Get
            Return Me.lblNombreComercial.Text
        End Get
        Set(ByVal Value As String)
            Me.lblNombreComercial.Text = Value
        End Set
    End Property

    Public Property RNC() As String
        Get
            Return Me.lblRNC.Text
        End Get
        Set(ByVal Value As String)
            Me.lblRNC.Text = Value
        End Set
    End Property

    Public Property RegistroPatronal() As String
        Get
            Return Me.lblRegPatronal.Text
        End Get
        Set(ByVal Value As String)
            Me.lblRegPatronal.Text = Value
        End Set
    End Property

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Put user code to initialize the page here
    End Sub

End Class
