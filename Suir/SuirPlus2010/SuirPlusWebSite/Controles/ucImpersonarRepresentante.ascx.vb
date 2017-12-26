
Partial Class Controles_ucImpersonarRepresentante
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        Dim url As String = Request.Path.Replace("/SuirPlusWebSite/", "").ToUpper

        Session("URL") = Request.Path

        If (CType(Me.Page, BasePage).IsInRole(56)) Or (CType(Me.Page, BasePage).IsInRole(134)) Or (CType(Me.Page, BasePage).IsInRole(520)) Or (CType(Me.Page, BasePage).IsInRole(702)) Then
            If (url = "EMPLEADOR/EMPMANEJOARCHIVOPY.ASPX") Or (url = "/EMPLEADOR/EMPMANEJOARCHIVOPY.ASPX") Or (url = "EMPLEADOR/EMPMANEJOARCHIVO.ASPX") Or (url = "/EMPLEADOR/EMPMANEJOARCHIVO.ASPX") Or (url = "EMPLEADOR/CONSARCHIVOS.ASPX") Or (url = "/EMPLEADOR/CONSARCHIVOS.ASPX") Then
                Exit Sub
            End If
        End If

        If Me.isRepresentante = False Then
            If Me.isImpersonado = False Then
                Me.EnviarAlLoginTMP()
            End If
        End If

    End Sub

    Private Function isRepresentante() As Boolean

        If HttpContext.Current.Session("IDTipoUsuario") = 2 Then
            Return True
        Else
            Return False
        End If

    End Function

    Private Function isImpersonado() As Boolean

        If HttpContext.Current.Session("ImpersonandoUnRepresentante") = "S" Then
            Return True
        Else
            Return False
        End If

    End Function

    Private Sub EnviarAlLoginTMP()

        Response.Redirect(Application("LoginImp"))

    End Sub

End Class
