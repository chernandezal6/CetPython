
Partial Class Controles_ucMensajeArchivo
    Inherits System.Web.UI.UserControl
    Public Property NombreArchivo() As String
        Get
            Return ViewState("NombreArchivo")
        End Get
        Set(ByVal value As String)
            ViewState("NombreArchivo") = value
        End Set
    End Property
    Public Property NumeroArchivo() As String
        Get
            Return ViewState("NumeroArchivo")
        End Get
        Set(ByVal value As String)
            ViewState("NumeroArchivo") = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        If ViewState("NumeroArchivo") IsNot Nothing Then
            pnlEstatus.Visible = True
            ''Utilizado para mostrar el popup
            Me.lblNombreArchivo.Text = NombreArchivo
            Me.lblNumeroArchivo.Text = NumeroArchivo
            Me.lblFechaCarga.Text = Date.Now.ToString()
        Else
            pnlEstatus.Visible = False
        End If
    End Sub

    Protected Sub lnkBtnCerrar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkBtnCerrar.Click
        Me.pnlEstatus.Visible = False

    End Sub

End Class
