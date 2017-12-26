Imports System.Data
Imports SuirPlus
Partial Class Legal_SolicitarAcuerdoPago
    Inherits BasePage
    Public i As Double
    Protected qstring As String = String.Empty
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        Dim dt As New DataTable
        Try
            Dim emp As New Empresas.Empleador(Me.txtRNC.Text)
            dt = Legal.LeyFacilidadesPago.getSolicitudFacilidadesPago(Nothing, emp.RegistroPatronal, Nothing, Nothing, Nothing, "A")
            If Utilitarios.Utils.HayErrorEnDataTable(dt) = False Then

                If dt.Rows.Count = 0 Then
                    Me.lblMensaje.Text = "Este Empleador NO ha solicitado anteriormente acogerse a la ley de facilidades de pago."
                    Me.lblMensaje.Visible = True
                    Exit Sub
                End If
            Else

                Me.lblMensaje.Text = Utilitarios.Utils.sacarMensajeDeErrorDesdeTabla(dt)
                Me.lblMensaje.Visible = True
                Exit Sub
            End If


            If emp.TieneAcuerdoDePago = True Then
                Me.lblMensaje.Text = "Este empleador ya tiene un acuerdo de pago"
                Me.lblMensaje.Visible = True
                Exit Sub
            End If

            Me.lblTelefono.Text = Utilitarios.Utils.FormatearTelefono(emp.Telefono1)
            Me.lblRazonSocial.Text = emp.RazonSocial
            Me.lblNombreComercial.Text = emp.NombreComercial
            Me.txtRNC.ReadOnly = True
            Me.btnBuscar.Enabled = False
            Me.Labels(True)

        Catch ex As Exception

            Me.lblMensaje.Text = "Este empleador no se encuentra registrado en nuestras base de datos." & "<br>" & ex.ToString()
            Me.lblMensaje.Visible = True
            Me.LimpiarCampos()
            Me.Labels(False)
            Me.txtRNC.ReadOnly = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

        Me.CargarNotificaciones()

    End Sub
    Private Sub LimpiarCampos()

        Me.lblNombreComercial.Text = ""
        Me.lblRazonSocial.Text = ""
        Me.lblTelefono.Text = ""
        Me.lblCantidadMeses.Text = ""
        Me.lblCantidadNotificaciones.Text = ""
        Me.txtRNC.ReadOnly = False
        Me.btnBuscar.Enabled = True

    End Sub
    Private Sub Labels(ByVal Mostrar As Boolean)

        Me.lbltxtInfoAcuerdoPago.Visible = Mostrar
        Me.lbltxtNombreComercial.Visible = Mostrar
        Me.lbltxtRazonSocial.Visible = Mostrar
        Me.lbltxtTelefono.Visible = Mostrar

        If Mostrar = True Then
            Me.lbltxtRNC.Font.Bold = False
        End If

        Me.tblInfoAcuerdo.Visible = Mostrar

    End Sub
    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click

        Me.txtRNC.ReadOnly = False
        Me.btnBuscar.Enabled = True
        Me.LimpiarCampos()
        Me.Labels(False)
        Me.txtRNC.Text = ""
        Me.gvNotificaciones.DataSource = Nothing
        Me.gvNotificaciones.DataBind()

    End Sub
    Private Sub CargarNotificaciones()

        Dim dt As New DataTable("Notificaciones")
        Dim dummy As String = ""
        dt = Empresas.Facturacion.Factura.getReferenciasDisponiblesParaPago(Empresas.Facturacion.Factura.eConcepto.SDSS, Me.txtRNC.Text, 6321, SuirPlus.Legal.eTiposAcuerdos.Ley189, dummy, dummy)

        If dt.Rows.Count <= 0 Then
            Me.lblMensaje.Text = "Este empleador no puede entrar en un Acuerdo de Pago debido a que no tiene <br>" & _
                                  "notificaciones pendiente de pago."
            Me.lblMensaje.Visible = True

            Me.tblInfoAcuerdo.Visible = False
            Me.lbltxtInfoAcuerdoPago.Visible = False
            Exit Sub
        End If

        If Utilitarios.Utils.HayErrorEnDataTable(dt) = False Then

            'Dim dv As New DataView(dt)
            'dv.Sort = "periodo_factura,Nomina_DES asc"

            Me.lblCantidadNotificaciones.Text = dt.Rows.Count

            Dim dt2 As New DataTable("Conteo")
            dt2 = SuirPlus.Utilitarios.dt.SelectDistinct(dt, "periodo_factura")

            ' Buscar el ultimo Periodo
            Dim PeriodoMax As String = dt.Compute("MAX(periodo_factura)", "")

            ' Buscar todas las NP del ultimo Periodo
            Dim dvMax As New DataView(dt, "periodo_factura = " + PeriodoMax, "", DataViewRowState.None)

            ' Buscar todas las NP, menos del ultimo Periodo
            Dim dvInicio As New DataView(dt, "periodo_factura != " + PeriodoMax, "", DataViewRowState.None)

            ' Unificar los DV, colocando los ultimos al principio
            Dim dtFinal As New DataTable

            dtFinal = dvMax.ToTable()
            dtFinal.Merge(dvInicio.ToTable())

            Me.lblCantidadMeses.Text = dt2.Rows.Count

            ''Me.gvNotificaciones.DataSource = dt
            Me.gvNotificaciones.DataSource = dtFinal
            Me.gvNotificaciones.DataBind()

            Me.lblMontoTotal.Text = i.ToString("C")

        Else

            Me.lblMensaje.Text = "Este empleador no puede entrar en un Acuerdo de Pago debido a que no tiene <br>" & _
                                  "notificaciones pendiente de pago."
            Me.lblMensaje.Visible = True

            Me.tblInfoAcuerdo.Visible = False
            Me.lbltxtInfoAcuerdoPago.Visible = False
            Exit Sub
        End If

    End Sub
    Protected Sub gvNotificaciones_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNotificaciones.RowDataBound

        Dim ii As String
        If e.Row.RowType = DataControlRowType.DataRow Then
            ii = e.Row.Cells(4).Text
            ii = ii.Replace("RD$", "")
            ii = ii.Replace(",", "")
            ii = ii.Trim

            i = i + Convert.ToDouble(ii)

            Dim dd As DropDownList = e.Row.Cells(0).FindControl("DropDownList1")
            dd.Items.Add(New ListItem("<-- Seleccione -->", 0))

            Dim lt As Integer = 0
            For lt = 1 To Math.Ceiling((Convert.ToInt16(Me.lblCantidadMeses.Text) / 2))
                dd.Items.Add(New ListItem(lt, lt))
            Next

        End If

    End Sub
    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click

        'Ver si se introdujo el Representante Legal
        Try
            If Me.ucCiudadano.getNombres.ToString().Length < 1 Then
                Me.lblMensajeError2.Text = "Debe introducir un representante Legal"
                Me.lblMensajeError2.Visible = True
                Return
            End If

        Catch ex As Exception
            Me.lblMensajeError2.Text = "Debe introducir un representante Legal"
            Me.lblMensajeError2.Visible = True
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Return
        End Try

        Me.lblMensaje.Visible = False

        Me.ConfirmarInfo()

    End Sub
    Private Sub ConfirmarInfo()

        Dim ds As New AcuerdoPago
        Dim CuotaAnterior As Integer = 0

        For Each fila As System.Web.UI.WebControls.GridViewRow In Me.gvNotificaciones.Rows

            Dim dp As System.Web.UI.WebControls.DropDownList
            dp = fila.Cells(0).FindControl("DropDownList1")

            If dp.SelectedValue <= 0 Then
                Me.lblMensaje.Text = "Hay un error en el orden de las cuotas favor verificar y generar nuevamente."
                Me.lblMensaje.Visible = True
                Exit Sub
            End If
            If (dp.SelectedValue < CuotaAnterior) Or (dp.SelectedValue >= CuotaAnterior + 2) Then
                Me.lblMensaje.Text = "Hay un error en el orden de las cuotas favor verificar y generar nuevamente."
                Me.lblMensaje.Visible = True
                Exit Sub
            End If

            ds.Cuotas.AddCuotasRow(dp.SelectedValue, fila.Cells(1).Text, fila.Cells(2).Text, fila.Cells(3).Text, fila.Cells(4).Text, DateTime.Now())

            CuotaAnterior = dp.SelectedValue

        Next

        ds.AcceptChanges()

        Session("acpAcuerdoPago") = ds
        Session("acpRNC") = Me.txtRNC.Text
        Session("acpRazonSocial") = Me.lblRazonSocial.Text
        Session("acpRepresentanteLegalDoc") = Me.ucCiudadano.getDocumento
        Session("acpRepresentanteLegalnombre") = Me.ucCiudadano.getNombres & " " & Me.ucCiudadano.getApellidos
        Session("acpCargo") = Me.txtCargo.Text
        Session("acpDireccion") = Me.txtDireccion.Text
        Session("acpNacionalidad") = Me.txtNacionalidad.Text
        Session("acpEstadoCivil") = Me.txtEstadoCivil.Text

        Response.Redirect("ConfirmarDatosAcuerdoDePago.aspx")


    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            Session("acpAcuerdoPago") = ""
            Session("acpRNC") = ""
            Session("acpRazonSocial") = ""
            Session("acpRepresentanteLegalDoc") = ""
            Session("acpRepresentanteLegalnombre") = ""
            Session("acpCargo") = ""
            Session("acpDireccion") = ""
            Session("acpNacionalidad") = ""
            Session("acpEstadoCivil") = ""

        End If
    End Sub
End Class
