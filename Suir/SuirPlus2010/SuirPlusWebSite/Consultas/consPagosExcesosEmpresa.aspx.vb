Imports System.Data
Imports SuirPlus

Partial Class Consultas_consPagosExcesosEmpresa
    Inherits BasePage
    Dim total As Decimal
    Protected Sub btBuscarRef_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btBuscarRef.Click

        Try
            If Me.txtnodocumento.Text = String.Empty Then
                Me.lblError.Visible = True
                Me.lblError.Text = "El RNC es requerido"
                Exit Sub
            Else
                Me.lblError.Visible = False
                Me.lblError.Text = String.Empty
            End If

            Dim dt As New DataTable
            dt = Finanzas.DevolucionAportes.GetPagosExcesoEmpresa(txtnodocumento.Text)

            If dt.Rows.Count > 0 Then

                lblRNC.Text = Utilitarios.Utils.FormatearRNCCedula(txtnodocumento.Text)
                lblRazonSocial.Text = dt.Rows(0)("razon_social").ToString()
                lblNombreComercial.Text = dt.Rows(0)("nombre_comercial").ToString()
                lblMontoEmpresa.Text = FormatNumber(dt.Rows(0)("MontoDevEmpresa").ToString())
                lblMontoTrabajador.Text = FormatNumber(dt.Rows(0)("MontoDevEmpleado").ToString())
                lblTotal.Text = FormatNumber(CDec(dt.Rows(0)("MontoDevEmpresa").ToString()) + CDec(dt.Rows(0)("MontoDevEmpleado").ToString()))

                pnlInfo.Visible = True
            Else
                lblError.Text = "No existen registro para esta búsqueda."
                lblError.Visible = True
            End If
            btBuscarRef.Enabled = False
            txtnodocumento.Enabled = False
        Catch ex As Exception
            lblError.Text = ex.Message
            lblError.Visible = True
        End Try


    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.limpiar()
    End Sub

    Private Sub limpiar()
        Response.Redirect("consPagosExcesosEmpresa.aspx")
    End Sub
End Class
