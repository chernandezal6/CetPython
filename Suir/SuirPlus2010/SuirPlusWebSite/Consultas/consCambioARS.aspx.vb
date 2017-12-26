Imports SuirPlus.Ars.Consultas
Imports System.Data
Partial Class Consultas_conCambioARS
    Inherits BasePage
    Dim cambios As New DataTable
    Dim Resultado As String = String.Empty
    Dim Nombre As String = String.Empty
    Dim ARS As String = String.Empty
    Dim Status As String = String.Empty
    Dim tipo_afiliacion As String = String.Empty
    Dim Fecha_Afiliacion As String = String.Empty
    Dim NombreTitular As String = String.Empty
    Dim ARSTitular As String = String.Empty
    Dim StatusTitular As String = String.Empty
    Dim tipo_afiliacionTitular As String = String.Empty
    Dim Fecha_AfiliacionTitular As String = String.Empty
    Dim nucleo As New DataTable
    Dim titular As New DataTable
    Dim pagos As Integer
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        pagos = 0
        lblMensaje.Text = String.Empty
        divArs.Visible = False
        btnBuscar.Enabled = False
        Try

            nucleo = SuirPlus.Ars.Consultas.consultaAfilado(Me.txtNSSoCedula.Text, Nombre, ARS, Status, tipo_afiliacion, Fecha_Afiliacion, Resultado)
            If Resultado.StartsWith("0") Then
                Me.lblARS0.Text = ARS
                Me.lblNombre.Text = Nombre
                Me.lblStatus.Text = Status
                Me.lblTipoAfiliacion.Text = tipo_afiliacion
                If Fecha_Afiliacion <> String.Empty Then
                    Me.lblFechaAfiliacion.Text = String.Format("{0:d}", Fecha_Afiliacion)
                End If
                Me.pnlInfo.Visible = Not String.IsNullOrEmpty(lblNombre.Text)

                If Not String.IsNullOrEmpty(txtNSSoCedula.Text) Then
                    cambios = consultaARS(txtNSSoCedula.Text, NombreTitular, ARSTitular, StatusTitular, tipo_afiliacionTitular, Fecha_AfiliacionTitular)
                    'Llenar datos titular
                    Me.lblARSTitular.Text = ARSTitular
                    Me.lblNombreTitular.Text = NombreTitular
                    Me.lblStatusTitular.Text = StatusTitular
                    Me.lblTipoAfiliacionTitular.Text = tipo_afiliacionTitular
                    If Fecha_AfiliacionTitular <> String.Empty Then
                        Me.lblFechaAfiliacionTitular.Text = String.Format("{0:d}", Fecha_AfiliacionTitular)
                    End If
                    Me.divTitular.Visible = Not String.IsNullOrEmpty(lblNombreTitular.Text)
                    Mostrar_Resultados()
                Else
                    lblMensaje.Text = "Por favor especificar la cédula o NSS"
                    btnBuscar.Enabled = True
                End If
            Else
                lblMensaje.Text = Resultado.Split("|")(1).ToString()
                btnBuscar.Enabled = True
            End If
        Catch ex As Exception
            lblMensaje.Text = ex.Message
            btnBuscar.Enabled = True
        End Try

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Limpiar()
    End Sub
    Protected Sub Mostrar_Resultados()
        'If Not String.IsNullOrEmpty(PuedeCambiarArs) Then
        'Llenar indicativos de posibilidad
        'lblARS.Text = PuedeCambiarArs
        'Select Case PuedeCambiarArs
        '    Case "Si"
        '        si.Visible = True
        '        no.Visible = False
        '    Case "No"
        '        no.Visible = True
        '        si.Visible = False
        '    Case Else
        '        divArs.Visible = False
        '        lblMensaje.Text = PuedeCambiarArs
        '        Exit Sub
        'End Select

        'Llenar historico de cambios
        If Not cambios Is Nothing Then
            If cambios.Rows.Count > 0 Then
                gvARS.DataSource = cambios
                gvARS.DataBind()
                lblPagos.Text = pagos
                gridARS.Visible = True
            End If
        Else
            gridARS.Visible = False
        End If
        divArs.Visible = True

        'Else
        'divArs.Visible = False
        'End If
    End Sub
    Protected Sub Limpiar()
        Me.txtNSSoCedula.Text = String.Empty
        lblMensaje.Text = String.Empty
        divArs.Visible = False
        'si.Visible = False
        'no.Visible = False
        pnlInfo.Visible = False
        divTitular.Visible = False
        btnBuscar.Enabled = True
        '' CaptchaControl1.Visible = True
    End Sub

    Protected Sub gvARS_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvARS.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            pagos += IIf(e.Row.Cells(1).Text.Equals("No pago de c&#225;pita a ninguna ARS"), 0, 1)
        End If
    End Sub
End Class
