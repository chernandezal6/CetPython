Imports System

Partial Class Controles_CaptchaImage
    Inherits System.Web.UI.UserControl

    Private Random As Random = New Random()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.Session("ConsOK") = Nothing
        Me.MessageLabel.CssClass = "error"
        Me.MessageLabel.Text = "Favor insertar los números que muestra la imagen"
        If Not Page.IsPostBack Then
            'Create a random code and store it in the Session object.
            Me.Session("CaptchaImageText") = GenerateRandomCode()
            Exit Sub
        End If

        If Me.CodeNumberTextBox.Text = Me.Session("CaptchaImageText") Then

            ' Display an informational message.
            Me.MessageLabel.CssClass = "subHeader"
            Me.MessageLabel.Text = "Correcto!"
            Me.Session("ConsOK") = "valido"
            Exit Sub
        End If

        If Me.CodeNumberTextBox.Text = String.Empty Then
            Me.MessageLabel.CssClass = "error"
            Me.MessageLabel.Text = "Favor insertar los números que muestra la imagen"
            Exit Sub
        End If

        If Not (Me.CodeNumberTextBox.Text = Me.Session("CaptchaImageText")) Then
            ' Display an error message.
            Me.MessageLabel.CssClass = "error"
            Me.MessageLabel.Text = "ERROR: Dígitos Incorrectos, Trate de nuevo."

            'Clear the input and create a new random code.
            Me.CodeNumberTextBox.Text = ""
            Me.Session("CaptchaImageText") = GenerateRandomCode()
            Exit Sub
        End If
    End Sub

    Private Function GenerateRandomCode() As String
        Dim s As String = String.Empty
        Dim i As Integer
        For i = 0 To 3
            s = String.Concat(s, Me.Random.Next(10).ToString())
        Next

        Return s
    End Function

End Class
