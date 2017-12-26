Imports SuirPlus
Imports SuirPlus.Seguridad


Partial Class Empleador_LoginMaster
    Inherits BasePage

    Protected Sub btLogin_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btLogin.Click

        Dim user As String = Me.txtRncCedula.Text & Trim(Me.txtRepresentante.Text)
        Dim rep As New Empresas.Representante(Me.txtRncCedula.Text, Trim(Me.txtRepresentante.Text))
        Me.UsrImpersonandoUnRepresentante = True
        Me.UsrImpNSS = rep.IdNSS
        Me.UsrImpRegistroPatronal = rep.RegistroPatronal
        Me.UsrImpRNC = rep.RNC
        Me.UsrImpCedula = rep.Cedula


    End Sub
End Class
