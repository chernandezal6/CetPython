Imports System.Data
Imports SuirPlus

Partial Class Consultas_consEstadisticas
    Inherits BasePage

    Private Sub CargarPeriodosDispersion()

        Dim dt As New DataTable
        dt = Ars.Consultas.getPeriodosDispersion()

        If dt.Rows.Count > 0 Then
            ddlPeriodos.DataSource = dt
            ddlPeriodos.DataTextField = "PERIODO_DISPERSION"
            ddlPeriodos.DataValueField = "PERIODO_DISPERSION"


            ddlPeriodos.DataBind()
        End If
        ddlPeriodos.Items.Insert(0, New ListItem("<-- Seleccione -->", "0"))
        ddlPeriodos.SelectedValue = 0

    End Sub

    Protected Sub BindEstadisticasTrabajador()

        Dim dtEstadisticas As New DataTable

        Try
            If ddlTipoConsulta.SelectedValue = "1" Then
                dtEstadisticas = Empresas.Empleador.getTrabajadorSalarioTipoEmpresa(ddlPeriodos.SelectedValue)
                If dtEstadisticas.Rows.Count > 0 Then
                    Me.gvEstadiscasTrabajador.DataSource = dtEstadisticas
                    Me.gvEstadiscasTrabajador.DataBind()
                    Me.pnlEstadistica.Visible = True
                Else
                    Me.lbl_error.Visible = True
                    lbl_error.Text = "No hay registros que cumplan con esta condición"
                    Me.pnlEstadistica.Visible = False
                End If

            End If

            If ddlTipoConsulta.SelectedValue = "2" Then
                dtEstadisticas = Empresas.Empleador.getTrabajadorRangoSalario(ddlPeriodos.SelectedValue)

                If dtEstadisticas.Rows.Count > 0 Then
                    Me.gvEstadisticasRangoSalarial.DataSource = dtEstadisticas
                    Me.gvEstadisticasRangoSalarial.DataBind()
                    Me.pnlEstadisticaRangoSalarial.Visible = True
                Else
                    Me.lbl_error.Visible = True
                    lbl_error.Text = "No hay registros que cumplan con esta condición"
                    Me.pnlEstadisticaRangoSalarial.Visible = False
                End If
            End If

            If ddlTipoConsulta.SelectedValue = "3" Then
                dtEstadisticas = Empresas.Empleador.getTrabajadorPorGenero(ddlPeriodos.SelectedValue)
                If dtEstadisticas.Rows.Count > 0 Then
                    Me.gvTrabajadorPorGenero.DataSource = dtEstadisticas
                    Me.gvTrabajadorPorGenero.DataBind()
                    Me.pnlTrabajadoresPorGenero.Visible = True
                Else
                    Me.lbl_error.Visible = True
                    lbl_error.Text = "No hay registros que cumplan con esta condición"
                    Me.pnlTrabajadoresPorGenero.Visible = False
                End If
            End If

            If ddlTipoConsulta.SelectedValue = "4" Then
                dtEstadisticas = Empresas.Empleador.getTrabajadorPorRangoEdad(ddlPeriodos.SelectedValue)
                If dtEstadisticas.Rows.Count > 0 Then
                    Me.gvTrabajadorRangoEdad.DataSource = dtEstadisticas
                    Me.gvTrabajadorRangoEdad.DataBind()
                    Me.pnlTrabajadoresRangoEdad.Visible = True
                Else
                    Me.lbl_error.Visible = True
                    lbl_error.Text = "No hay registros que cumplan con esta condición"
                    Me.pnlEstadistica.Visible = False
                End If
            End If

            'Aqui se hace referencia al segundo grid y el segundo panel por los parametros que en estos dos casos se presentan menos.
            If ddlTipoConsulta.SelectedValue = "5" Then
                dtEstadisticas = Empresas.Empleador.getCantidadTrabajadoresEmpresas(ddlPeriodos.SelectedValue)

                If dtEstadisticas.Rows.Count > 0 Then
                    Me.gvEmpresasCantTrabajadores.DataSource = dtEstadisticas
                    Me.gvEmpresasCantTrabajadores.DataBind()
                    Me.pnlEmpresasCantidadTrabajadores.Visible = True
                Else
                    Me.lbl_error.Visible = True
                    lbl_error.Text = "No hay registros que cumplan con esta condición"
                    Me.pnlEmpresasCantidadTrabajadores.Visible = False
                End If
            End If


            If ddlTipoConsulta.SelectedValue = "6" Then
                dtEstadisticas = Empresas.Empleador.getMasTrabajadoresEmpresas(ddlPeriodos.SelectedValue)

                If dtEstadisticas.Rows.Count > 0 Then
                    Me.gvEstadiscasTrabajadores.DataSource = dtEstadisticas
                    Me.gvEstadiscasTrabajadores.DataBind()
                    Me.pnlEstadisticasTrabajadores.Visible = True
                Else
                    Me.lbl_error.Visible = True
                    lbl_error.Text = "No hay registros que cumplan con esta condición"
                    Me.pnlEstadisticasTrabajadores.Visible = False
                End If

            End If
        Catch ex As Exception
            Me.lbl_error.Visible = True
            lbl_error.Text = ex.ToString()
        End Try


    End Sub

    Protected Sub Page_Load1(sender As Object, e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            CargarPeriodosDispersion()
        End If
    End Sub

    Protected Sub btBuscarRef_Click(sender As Object, e As EventArgs) Handles btBuscarRef.Click
        Me.lbl_error.Text = String.Empty
        Me.lbl_error.Visible = False

        'Limpiamos los grids y ocultamos los paneles.
        Me.gvEstadiscasTrabajador.DataSource = Nothing
        Me.gvEstadiscasTrabajador.DataBind()
        Me.pnlEstadistica.Visible = False

        Me.gvEstadiscasTrabajadores.DataSource = Nothing
        Me.gvEstadiscasTrabajadores.DataBind()
        Me.pnlEstadisticasTrabajadores.Visible = False

        Me.gvEstadisticasRangoSalarial.DataSource = Nothing
        Me.gvEstadisticasRangoSalarial.DataBind()
        Me.pnlEstadisticaRangoSalarial.Visible = False

        Me.gvTrabajadorPorGenero.DataSource = Nothing
        Me.gvTrabajadorPorGenero.DataBind()
        Me.pnlTrabajadoresPorGenero.Visible = False

        Me.gvTrabajadorRangoEdad.DataSource = Nothing
        Me.gvTrabajadorRangoEdad.DataBind()
        Me.pnlTrabajadoresRangoEdad.Visible = False


        If ddlPeriodos.SelectedValue = "0" Then
            Me.lbl_error.Visible = True
            Me.lbl_error.Text = "El periodo Período es requerido"
            Exit Sub
        End If

        If ddlTipoConsulta.SelectedValue = "0" Then
            Me.lbl_error.Visible = True
            Me.lbl_error.Text = "El Tipo de consulta es requerido"
            Exit Sub
        End If

        BindEstadisticasTrabajador()

    End Sub


    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.limpiar()
    End Sub

    Private Sub limpiar()
        Response.Redirect("~/Consultas/consEstadisticas.aspx")
    End Sub

    Protected Sub ucExportarExcel_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel.ExportaExcel
        Dim nucleo As DataTable
        nucleo = Empresas.Empleador.getTrabajadorSalarioTipoEmpresa(ddlPeriodos.SelectedValue)
        ucExportarExcel.FileName = "Trabajador por Rango salarial y tipo.xls"
        ucExportarExcel.DataSource = nucleo
    End Sub

    Protected Sub ucExportarExcel1_ExportaExcel(sender As Object, e As EventArgs) Handles ucExportarExcel1.ExportaExcel
        Dim nucleo As New DataTable
       
        If ddlTipoConsulta.SelectedValue = "6" Then
            nucleo = Empresas.Empleador.getMasTrabajadoresEmpresas(ddlPeriodos.SelectedValue)
            ucExportarExcel1.FileName = "Empresas con mas Trabajadores.xls"
            ucExportarExcel1.DataSource = nucleo
        End If

    End Sub

    Protected Sub ucExportarExcel2_ExportaExcel(sender As Object, e As EventArgs) Handles ucExportarExcel2.ExportaExcel
        Dim nucleo As New DataTable
        nucleo = Empresas.Empleador.getTrabajadorRangoSalario(ddlPeriodos.SelectedValue)
        ucExportarExcel2.FileName = "Rango Salarial Trabajadores.xls"
        ucExportarExcel2.DataSource = nucleo
    End Sub

    Protected Sub ucExportarExcel3_ExportaExcel(sender As Object, e As EventArgs) Handles ucExportarExcel3.ExportaExcel
        Dim nucleo As New DataTable
        nucleo = Empresas.Empleador.getTrabajadorPorGenero(ddlPeriodos.SelectedValue)
        ucExportarExcel3.FileName = "Listado de trabajadores por genero.xls"
        ucExportarExcel3.DataSource = nucleo
    End Sub

    Protected Sub ucExportarExcel4_ExportaExcel(sender As Object, e As EventArgs) Handles ucExportarExcel4.ExportaExcel
        Dim nucleo As New DataTable
        nucleo = Empresas.Empleador.getTrabajadorPorRangoEdad(ddlPeriodos.SelectedValue)
        ucExportarExcel4.FileName = "Listado de trabajadores por rango y edad.xls"
        ucExportarExcel4.DataSource = nucleo
    End Sub

    Protected Sub ucExportarExcel5_ExportaExcel(sender As Object, e As EventArgs) Handles ucExportarExcel5.ExportaExcel
        Dim nucleo As New DataTable

        If ddlTipoConsulta.SelectedValue = "5" Then
            nucleo = Empresas.Empleador.getCantidadTrabajadoresEmpresas(ddlPeriodos.SelectedValue)
            ucExportarExcel5.FileName = "Empresas por cantidad de trabajadores.xls"
            ucExportarExcel5.DataSource = nucleo
        End If
    End Sub
End Class





