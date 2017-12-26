Imports System.Data
Imports SuirPlus.Empresas.CuentaBancaria
Imports SuirPlus
Imports System.Collections.Generic
Imports SuirPlus.Bancos.EntidadRecaudadora

Partial Class Empleador_CtaBancariaMantenimiento
    Inherits BasePage
    Dim cuentaBancaria As Empresas.CuentaBancaria
    Delegate Sub DelPostConfirmacion()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim em As New Empresas.Empleador(CInt(Me.UsrRegistroPatronal))
        If em.TipoEmpresa = "PC" Then
            Me.btnCambiarCuenta.Enabled = False
        Else
            Me.btnCambiarCuenta.Enabled = True
        End If

        cuentaBancaria = New Empresas.CuentaBancaria(CInt(Me.UsrRegistroPatronal))
        CargarDetallesCuenta()

        'Establecer valores de propiedades del control, para "Nueva Cuenta"
        ucCuentaBancaria1.BtnActualizarCuentaText = "Procesar"
        ucCuentaBancaria1.BtnCancelar0Visible = True
        ucCuentaBancaria1.UsrRegistroPatronal = UsrRegistroPatronal
        ucCuentaBancaria1.UsrRNC = UsrRNC
        ucCuentaBancaria1.UsrUserName = UsrRNC + UsrCedula

        Dim _delPostConfirmacion As New DelPostConfirmacion(AddressOf Me.PostConfirmacion)
        ucCuentaBancaria1.ConfirmarActualizacion = _delPostConfirmacion

    End Sub
    Private Sub PostConfirmacion()

        'Rutina a ejecutar despues de crear la cuenta
        cuentaBancaria = New Empresas.CuentaBancaria(CInt(Me.UsrRegistroPatronal))
        CargarDetallesCuenta()
        divCambiarCuenta.Visible = False

    End Sub
    Private Sub CargarDetallesCuenta()

        'Popular controles de detalle cuenta
        Me.lblIdEntidadRecaudadora.Text = cuentaBancaria.IdEntidadRecaudadora
        Me.lblNroCuenta.Text = cuentaBancaria.NroCuenta
        Me.lblRNCoCedulaDuenoCuenta.Text = cuentaBancaria.RNCoCedulaDuenoCuenta
        Me.lblTipoCuenta.Text = cuentaBancaria.TipoCuenta

        Try
            gvHistoricoCuentas.DataSource = GetHistoricoCuentas(cuentaBancaria.RegistroPatronal)
            Me.gvHistoricoCuentas.DataBind()

            If gvHistoricoCuentas.Rows.Count > 0 Then
                divHistoricoCuentas.Visible = True
            End If
        Catch ex As Exception

        End Try


    End Sub
    Protected Sub btnCambiarCuenta_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCambiarCuenta.Click

        divCambiarCuenta.Visible = True

    End Sub

    Protected Sub gvHistoricoCuentas_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvHistoricoCuentas.RowDataBound
        If e.Row.Cells(2).Text = "1" Then
            e.Row.Cells(2).Text = "Cuenta Corriente"
        ElseIf e.Row.Cells(2).Text = "2" Then
            e.Row.Cells(2).Text = "Cuenta de Ahorro"
        End If
    End Sub
End Class
