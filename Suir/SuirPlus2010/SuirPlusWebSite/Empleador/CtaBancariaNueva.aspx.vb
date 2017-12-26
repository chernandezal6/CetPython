Imports System.Data
Imports SuirPlus.Empresas.CuentaBancaria
Imports SuirPlus
Imports System.Collections.Generic
Imports SuirPlus.Bancos.EntidadRecaudadora
Imports SuirPlus.Utilitarios

Partial Class Empleador_CtaBancariaNueva
    Inherits BasePage
    Dim cuentaBancaria As Empresas.CuentaBancaria
    Dim entidadesRecaudadoras As New DataTable()
    Delegate Sub DelPostConfirmacion()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not String.IsNullOrEmpty(Request.QueryString("Novedad")) Then
            lblCuentaNovededad.Visible = CType(Request.QueryString("Novedad"), Boolean)
        Else
            lblCuentaNovededad.Visible = False
        End If

        'Establecer valores de propiedades del control, para "Nueva Cuenta"
        ucCuentaBancaria1.BtnActualizarCuentaText = "Crear Cuenta"
        ucCuentaBancaria1.BtnCancelar0Visible = False
        ucCuentaBancaria1.UsrRegistroPatronal = UsrRegistroPatronal
        ucCuentaBancaria1.UsrRNC = UsrRNC
        ucCuentaBancaria1.UsrUserName = UsrRNC + UsrCedula

        Dim _delPostConfirmacion As New DelPostConfirmacion(AddressOf Me.PostConfirmacion)
        ucCuentaBancaria1.ConfirmarActualizacion = _delPostConfirmacion

    End Sub

    Private Sub PostConfirmacion()

        'Rutina a ejecutar despues de crear la cuenta

        If Session("urlPostConfirmacion") Is Nothing Then
            Response.Redirect("~/default.aspx")
        Else
            Response.Redirect(Session("urlPostConfirmacion").ToString)
        End If

    End Sub

End Class
