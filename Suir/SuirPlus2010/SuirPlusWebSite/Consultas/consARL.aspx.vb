Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios.Utils
Partial Class Consultas_consARL
    Inherits BasePage



    Protected Sub btnBuscar_Click(sender As Object, e As System.EventArgs) Handles btnBuscar.Click
        If txtNss.Text = String.Empty Then
            LblError.Visible = True
            LblError.Text = "Debe completar el Nss"
            Exit Sub
        End If
        If txtRNC.Text = String.Empty Then
            LblError.Visible = True
            LblError.Text = "Debe completar el RNC o Cédula"
            Exit Sub

            'Else
            '    If SuirPlus.Empresas.SubsidiosSFS.Consultas.ValidarRNCoCedula(txtRNC.Text) = "0" Then
            '        LblError.Text = "RNC Inválido"
            '        Exit Sub
            '    End If
        End If
        Me.BindDetalleEmpleado()
    End Sub


    Protected Sub BindDetalleEmpleado()
        Dim dt As New datatable
        Try
            dt = SuirPlus.Afiliacion.Afiliaciones.getAfiliadoARL(txtRNC.Text, Convert.ToInt64(txtNss.Text))
            If dt.Rows.Count > 0 Then
                Me.gvDetalleEmpleado.DataSource = dt
                Me.gvDetalleEmpleado.DataBind()

                'LblMonto.Text = Me.formateaSalario(dtDatos.Rows(0)("MONTO").ToString)
                'LblBalance.Text = Me.formateaSalario(dtDatos.Rows(0)("BALANCE").ToString)
                'lblRazonSocial.Text = dtDatos.Rows(0)("RAZON_SOCIAL").ToString
                'lblStatusPin.Text = formatea
                'lblFecha.Text = String.Format("{0:d}", dtDatos.Rows(0)("FECHA_VENTA"))
                'divInfoPin.Visible = True
                'tblInfoPin.Visible = True
                divEmpleado.Visible = True
                LblError.Visible = False

            Else
                divEmpleado.Visible = False
                'tblInfoPin.Visible = False
                LblError.Visible = True
                LblError.Text = "No existen registros para esta busqueda"
            End If
            dt = Nothing

        Catch ex As Exception
            LblError.Visible = True
            Me.LblError.Text = Split(ex.Message, "|")(1)
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub
    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load

    End Sub
    Protected Function formateaRNC_Cedula(ByVal rnc As Object) As Object

        If Not rnc Is DBNull.Value Then

            Return Utilitarios.Utils.FormatearRNCCedula(rnc.ToString)

        End If

        Return rnc

    End Function


    Protected Sub BtnLimpiar_Click(sender As Object, e As System.EventArgs) Handles BtnLimpiar.Click
        Response.Redirect("consARL.aspx")
    End Sub
End Class
