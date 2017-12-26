Partial Class Controles_ucTelefono2
    Inherits System.Web.UI.UserControl

    Public Property phoneNumber() As String
        Get
            Return Me.txtTelefono.Text
        End Get
        Set(ByVal value As String)
            Me.txtTelefono.Text = value
        End Set
    End Property

    Public Property isValidEmpty() As Boolean
        Get
            Return Me.ValidatePhone.IsValidEmpty
        End Get
        Set(ByVal value As Boolean)
            Me.ValidatePhone.IsValidEmpty = value
        End Set
    End Property

    Public Property ErrorMessage() As String
        Get
            Return Me.ValidatePhone.InvalidValueBlurredMessage
        End Get
        Set(ByVal value As String)
            Me.ValidatePhone.InvalidValueBlurredMessage = value
        End Set
    End Property

End Class
