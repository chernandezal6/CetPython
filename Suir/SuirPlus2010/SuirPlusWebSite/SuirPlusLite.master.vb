
Partial Class SuirPlusLite
    Inherits System.Web.UI.MasterPage

    Dim bPage As New BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If bPage.UsrIDTipoUsuario = 2 Then
            Me.UCSubEncabezadoEmp1.Visible = False
        Else

            If bPage.UsrImpersonandoUnRepresentante = True Then
                Me.UCSubEncabezadoEmp1.Visible = True
            Else
                Me.UCSubEncabezadoEmp1.Visible = False
            End If

        End If

        Dim quien As String

        Select Case Request.ServerVariables("LOCAL_ADDR")
            'SATURN
            Case "172.16.5.59"
                quien = "N|SuirPlus"
            Case "172.16.5.70"
                quien = "N|SuirPlus02"
            Case "172.16.5.71"
                quien = "N|SuirPlus03"
            Case "172.16.5.72"
                quien = "N|SuirPlus04"
            Case "172.16.5.73"
                quien = "N|SuirPlus05"
            Case "172.16.5.74"
                quien = "N|SuirPlus06"
            Case "172.16.5.75"
                quien = "N|SuirPlus07"
            Case "172.16.5.76"
                quien = "N|SuirPlus08"
            Case "172.16.5.77"
                quien = "N|SuirPlus09"
            Case "172.16.5.78"
                quien = "N|SuirPlus10"

                'SAAB
            Case "172.16.5.62"
                quien = "B|SuirPlus"
            Case "172.16.5.79"
                quien = "B|SuirPlus02"
            Case "172.16.5.83"
                quien = "B|SuirPlus03"
            Case "172.16.5.84"
                quien = "B|SuirPlus04"
            Case "172.16.5.85"
                quien = "B|SuirPlus05"
            Case "172.16.5.86"
                quien = "B|SuirPlus06"
            Case "172.16.5.87"
                quien = "B|SuirPlus07"
            Case "172.16.5.88"
                quien = "B|SuirPlus08"
            Case "172.16.5.89"
                quien = "B|SuirPlus09"
            Case "172.16.5.91"
                quien = "B|SuirPlus10"

            Case Else
                quien = "N/A"
        End Select

        Me.lblUsuarios.Text = "Usuarios en linea: " & Application("ActiveUsers")
        Me.lblServer.Text = Application("servidor") & " | " & Request.ServerVariables("HTTP_HOST") & " | " & quien

    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        bPage.highLigthTextbox(Me.MainContent)

    End Sub
End Class

