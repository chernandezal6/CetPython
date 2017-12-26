Imports SuirPlus
Imports SuirPlus.Seguridad


Partial Class Empleador_LoginTMPrep
    Inherits BasePage

    Protected Property PreviousURL() As String
        Get
            Return ViewState("URL").ToString()
        End Get
        Set(ByVal value As String)
            ViewState("URL") = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Me.IsPostBack Then
            If Session("URL") IsNot Nothing Then

                Me.PreviousURL = Session("URL")
            Else

                If Request.UrlReferrer IsNot Nothing Then
                    Me.PreviousURL = Request.UrlReferrer.ToString()
                End If
            End If
        End If

    End Sub

    Protected Sub btLogin_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btLogin.Click

        validaRepresentante()

    End Sub

    ''' <summary>
    ''' Metodo utilizado para validar e inicializar las variables de un representante impersonado.
    ''' </summary>
    ''' <remarks>
    ''' By Ronny Carreras June-01-2007
    ''' </remarks>
    Private Sub validaRepresentante()

        If Not String.IsNullOrEmpty(Me.txtRepresentante.Text) AndAlso Not String.IsNullOrEmpty(Me.txtRncCedula.Text) Then

            Dim user As String = Me.txtRncCedula.Text & Trim(Me.txtRepresentante.Text)

            Try

                If Autenticacion.Login(user, Me.txtClass.Text, Request.UserHostAddress, "2", Request.ServerVariables("LOCAL_ADDR")) Then
                    Dim rep As New Empresas.Representante(Me.txtRncCedula.Text, Trim(Me.txtRepresentante.Text))
                    Me.UsrImpersonandoUnRepresentante = True
                    Me.UsrImpNSS = rep.IdNSS
                    Me.UsrImpRegistroPatronal = rep.RegistroPatronal
                    Me.UsrImpRNC = rep.RNC
                    Me.UsrImpCedula = rep.Cedula
                    Response.Redirect(Me.PreviousURL)
                Else
                    Me.lblMensaje.Text = "Usuario o Class inválido"
                End If

            Catch ex As Exception
                Me.lblMensaje.Text = "Usuario o Class inválido"
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

        Else
            Me.lblMensaje.Text = "Usuario o Class inválido"
        End If

    End Sub

End Class
