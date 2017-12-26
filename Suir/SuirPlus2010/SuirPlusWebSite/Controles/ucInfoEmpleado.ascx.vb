
Partial Class Controles_ucInfoEmpleado
    Inherits System.Web.UI.UserControl

    Public Property NombreEmpleado() As String
        Get
            Return Me.lblEmpleado.Text
        End Get
        Set(ByVal Value As String)
            Me.lblEmpleado.Text = Value
        End Set
    End Property

    Public Property Sexo() As String
        Get
            Return Me.lblSexo.Text
        End Get
        Set(ByVal Value As String)
            Me.lblSexo.Text = Value
        End Set
    End Property

    Public Property FechaNacimiento() As String
        Get
            Return Me.lblFechaNacimiento.Text
        End Get
        Set(ByVal Value As String)
            Me.lblFechaNacimiento.Text = Value
        End Set
    End Property

    Public Property Cedula() As String
        Get
            Return Me.lblCedula.Text
        End Get
        Set(ByVal Value As String)
            Me.lblCedula.Text = SuirPlus.Utilitarios.Utils.FormatearCedula(Value)
        End Set
    End Property

    Public Property NSS() As String
        Get
            Return Me.lblNSS.Text
        End Get
        Set(ByVal Value As String)
            Me.lblNSS.Text = SuirPlus.Utilitarios.Utils.FormatearNSS(Value)
        End Set
    End Property

    Public Property SexoEmpleado() As String
        Get
            Return Me.lblEmpleadolbl.Text
        End Get
        Set(ByVal value As String)
            Me.lblEmpleadolbl.Text = value
        End Set
    End Property

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        Me.lblEmpleadolbl.Text = "Empleado"

    End Sub

End Class
