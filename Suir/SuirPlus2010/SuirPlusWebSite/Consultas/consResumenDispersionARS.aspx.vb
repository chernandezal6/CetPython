Imports System.Data
Imports SuirPlus


Partial Class sys_consARS
    Inherits BasePage

    Protected Sub sys_consARS_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            ' cargar periodos
            CargarPeriodosDispersion()
        End If
    End Sub


    Protected Sub btBuscarRef_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btBuscarRef.Click


        Me.lbl_error.Text = String.Empty
        Me.lbl_error.Visible = False
        Me.gvResumeCartera.DataSource = Nothing
        Me.gvResumeCartera.DataBind()
        Me.pnlNucleo.Visible = False


        If ddlPeriodos.SelectedValue = "0" Then
            Me.lbl_error.Visible = True
            Me.lbl_error.Text = "La Período es requerido"
            Exit Sub
        End If

        If ddlTipo.SelectedValue = "0" Then
            Me.lbl_error.Visible = True
            Me.lbl_error.Text = "El Tipo Dispersión es requerido"
            Exit Sub
        End If

        Try
            Dim nucleo As New DataTable
            nucleo = SuirPlus.Ars.Consultas.getResumenCartera(ddlPeriodos.SelectedValue, ddlresumen.SelectedValue, ddlTipo.SelectedValue)

            If nucleo.Rows.Count > 0 Then
                Me.gvResumeCartera.DataSource = nucleo
                Me.gvResumeCartera.DataBind()
                Me.pnlNucleo.Visible = True
            Else
                Me.lbl_error.Visible = True
                lbl_error.Text = "No hay registros que cumplan con esta condición"
                Me.pnlNucleo.Visible = False
            End If
        Catch ex As Exception
            Me.lbl_error.Visible = True
            lbl_error.Text = ex.ToString()
        End Try


    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.limpiar()
    End Sub

    Private Sub limpiar()
        Response.Redirect("~/Consultas/consResumenDispersionARS.aspx")
    End Sub

    Protected Function ValidarNull(ByVal texto As Object) As String

        If IsDBNull(texto) Then
            Return String.Empty
        Else
            Return CStr(texto)
        End If
        Return String.Empty
    End Function

    Protected Sub ucExportarExcel_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel.ExportaExcel
        Dim nucleo As DataTable
        nucleo = SuirPlus.Ars.Consultas.getResumenCartera(ddlPeriodos.SelectedValue, ddlresumen.SelectedValue, ddlTipo.SelectedValue)

        If nucleo.Rows.Count > 0 Then
            If ddlresumen.SelectedValue = 0 Then
                ucExportarExcel.FileName = "Consolidado_ARS" + ddlPeriodos.SelectedValue + ".xls"
            ElseIf ddlresumen.SelectedValue = 1 Then
                ucExportarExcel.FileName = "Primera_Dispersión" + ddlPeriodos.SelectedValue + ".xls"
            ElseIf ddlresumen.SelectedValue = 2 Then
                ucExportarExcel.FileName = "Segunda_Dispersión" + ddlPeriodos.SelectedValue + ".xls"
            End If
            ucExportarExcel.DataSource = nucleo
        End If

    End Sub


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

End Class
