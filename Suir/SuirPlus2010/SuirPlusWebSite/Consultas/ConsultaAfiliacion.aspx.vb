Imports SuirPlus
Imports System.Data
Partial Class Afiliacion_ConsultaAfiliacion
    Inherits BasePage

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("ConsultaAfiliacion.aspx")
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        If String.IsNullOrEmpty(txtCedula.Text) And String.IsNullOrEmpty(txtNoPensionado.Text) Then
            lblMensaje.Text = "Debe completar uno de los filtros."
        Else
            LoadData()
        End If
    End Sub

    Private Sub LoadData()
        Dim dt As New DataTable

        dt = Afiliacion.Afiliaciones.getInfoPensionado(Me.txtCedula.Text, Me.txtNoPensionado.Text)

        If dt.Rows.Count > 0 Then
            lblNombre.Text = dt.Rows(0)("nombre").ToString()
            lblEstatus.Text = IIf(IsDBNull(dt.Rows(0)("desc_status")), "N/A", dt.Rows(0)("desc_status").ToString())

            If IIf(IsDBNull(dt.Rows(0)("STATUS")), String.Empty, dt.Rows(0)("STATUS").ToString()) = "BA" Then
                lblDesc.Text = dt.Rows(0)("ID_MOTIVO_BAJA").ToString()
                trMotivo.Visible = True
            Else
                trMotivo.Visible = False
                lblDesc.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("FECHA_AFILIACION")) Then
                lblFechaAfiliacion.Text = dt.Rows(0)("FECHA_AFILIACION").ToString()
            Else
                lblFechaAfiliacion.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("FECHA_DESAFILIACION")) Then
                lblFechaDesafiliacion.Text = dt.Rows(0)("FECHA_DESAFILIACION").ToString()
            Else
                lblFechaDesafiliacion.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("FECHA_REGISTRO")) Then
                lblFechaRegistro.Text = dt.Rows(0)("FECHA_REGISTRO").ToString()
            Else
                lblFechaRegistro.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("ID_ARS")) Then
                lblARS.Text = dt.Rows(0)("ARS_DES").ToString()
            Else
                lblARS.Text = "N/A"
            End If

            If IIf(IsDBNull(dt.Rows(0)("ID_ARS")), String.Empty, dt.Rows(0)("ID_ARS")) = "52" Then
                lblDireccionARS.Text = "C/ Presidente González, Esq. Tiradentes #19, Ens. Naco, Distrito Nacional, República Dominicana"
                lblTelefonoARS.Text = "(809)732-3821"
            ElseIf IIf(IsDBNull(dt.Rows(0)("ID_ARS")), String.Empty, dt.Rows(0)("ID_ARS")) = "2" Then
                lblDireccionARS.Text = "Calle Pepillo Salcedo #22, Ensanche La Fe"
                lblTelefonoARS.Text = "(809)565-9666"
            ElseIf IIf(IsDBNull(dt.Rows(0)("ID_ARS")), String.Empty, dt.Rows(0)("ID_ARS")) = "42" Then
                lblDireccionARS.Text = "J J Pérez 152, Santo Domingo"
                lblTelefonoARS.Text = "(809)686-1705"
            Else
                lblDireccionARS.Text = "N/A"
                lblTelefonoARS.Text = "N/A"
            End If

            pnlDatos.Visible = True
        Else
            lblMensaje.Text = "No se encontraron registro para esta busqueda."
        End If
    End Sub
End Class
