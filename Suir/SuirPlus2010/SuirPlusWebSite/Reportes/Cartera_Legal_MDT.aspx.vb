Imports SuirPlus
Imports System.Data

Partial Class Reportes_Cartera_Legal_MDT
    Inherits BasePage

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            cargarDatosEstadisticos()
            CargarPeriodos()
            CargarProvincias()

        End If

    End Sub
    Protected Sub cargarDatosEstadisticos()
        cargarGridView()
        cargarEmpMontoCarteraLegal()
        cargarEmpMontoEnviadosMDT()
    End Sub

    Protected Sub cargarGridView()
        Try
            Dim dt = SuirPlus.Legal.Cobro.getGestionCobrosPorResultado()
            If dt.Rows.Count > 0 Then
                lblMsgGV.Visible = False
                gvGestionCobros.DataSource = dt
                gvGestionCobros.DataBind()
            Else
                Throw New Exception("No hay registros.")
            End If
        Catch ex As Exception
            lblMsgGV.Visible = True
            lblMsgGV.Text = ex.Message
        End Try

    End Sub

    Protected Sub cargarEmpMontoCarteraLegal()
        Try
            Dim totalEmp As Integer
            Dim montoCartera As Decimal

            Dim res = SuirPlus.Empresas.Consultas.getEmpMontoCarteraLegal(totalEmp, montoCartera)

            If totalEmp > 0 Then
                lblTotalEmpCartera.Text = String.Format("{0:N0}", totalEmp)
                lblMontoCartera.Text = String.Format("{0:C}", montoCartera)
            Else
                lblTotalEmpCartera.Text = 0
                lblMontoCartera.Text = 0
            End If
        Catch ex As Exception
            lblTotalEmpCartera.Text = 0
            lblMontoCartera.Text = 0
        End Try

    End Sub

    Protected Sub cargarEmpMontoEnviadosMDT()
        Try
            Dim totalEmp As Integer
            Dim montoCartera As Decimal

            Dim res = SuirPlus.Empresas.Consultas.getEmpMontoEnviadosMDT(totalEmp, montoCartera)

            If totalEmp > 0 Then
                lblEmpresasEnviadasMDT.Text = String.Format("{0:N0}", totalEmp)
                lblMontoEmpresasEnviadasMDT.Text = String.Format("{0:C}", montoCartera)
            Else
                lblEmpresasEnviadasMDT.Text = 0
                lblMontoEmpresasEnviadasMDT.Text = 0
            End If
        Catch ex As Exception
            lblTotalEmpCartera.Text = 0
            lblMontoCartera.Text = 0
        End Try

    End Sub

    Protected Sub CargarProvincias()

        Me.ddlProvincia.DataSource = SuirPlus.Utilitarios.TSS.getProvincias()
        Me.ddlProvincia.DataTextField = "PROVINCIA_DES"
        Me.ddlProvincia.DataValueField = "Id_provincia"
        Me.ddlProvincia.DataBind()
        Me.ddlProvincia.Items.Insert(0, New System.Web.UI.WebControls.ListItem("Todos", "-1"))

        Me.ddlProvincia.SelectedValue = "-1"
    End Sub

    Protected Sub CargarPeriodos()

        Me.ddlPeriodos.DataSource = SuirPlus.Empresas.Consultas.getPeriodosCarteraLegal()
        Me.ddlPeriodos.DataTextField = "PERIODO"
        Me.ddlPeriodos.DataValueField = "PERIODO"
        Me.ddlPeriodos.DataBind()
        Me.ddlPeriodos.Items.Insert(0, New System.Web.UI.WebControls.ListItem("Todos", "-1"))

        Me.ddlPeriodos.SelectedValue = "-1"
    End Sub

    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click
        If rblTipoReporte.SelectedValue = Nothing Then
            Me.lblMsg.Visible = True
            lblMsg.Text = "Debe seleccionar un tipo de reporte."
            Exit Sub
        End If
        getData(Me.ddlProvincia.SelectedValue, ddlTipoEmpresa.SelectedValue, rblTipoReporte.SelectedValue, ddlPeriodos.SelectedValue)
    End Sub

    Protected Sub getData(ByVal IdProvincia As String, ByVal TipoEmpresa As String, ByVal TipoReporte As String, ByVal periodo As String)
        Dim dt As New DataTable
        Try

            dt = Empresas.Consultas.get_Cartera_Legal_MDT(IdProvincia, TipoEmpresa, TipoReporte, periodo)

            If dt.Rows.Count > 0 Then
                pnlCarteraLegalMDT.Visible = True
                Me.lblMsg.Visible = False

                ReportViewer1.LocalReport.DataSources.Clear()
                ReportViewer1.LocalReport.DataSources.Add(New Microsoft.Reporting.WebForms.ReportDataSource("Cartera_Legal_ds", dt))
                ReportViewer1.LocalReport.Refresh()
            Else
                pnlCarteraLegalMDT.Visible = False
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existe data para los parametros seleccionado"
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
            Me.pnlCarteraLegalMDT.Visible = False
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.Response.Redirect("Cartera_Legal_MDT.aspx")
    End Sub


End Class
