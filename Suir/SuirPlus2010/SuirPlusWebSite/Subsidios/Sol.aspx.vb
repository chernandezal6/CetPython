Imports SuirPlus
Imports SuirPlus.Empresas

Partial Class Subsidios_Sol
    Inherits BasePage

    Protected Sub Subsidios_Sol_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Si la empresa no tiene una cuenta bancaria asignada, se redirecciona a la pagina de nueva
        'cuenta bancaria
        If Not UsrRegistroPatronal Is Nothing Then

            Dim cuentaBancaria As New CuentaBancaria(CType(UsrRegistroPatronal, Integer))

            If String.IsNullOrEmpty(cuentaBancaria.NroCuenta) Then
                Response.Redirect("~/subsidios/CuentaBancariaNueva.aspx?url=sol")
                Response.Write("Mas")
            End If

        End If

    End Sub
End Class
