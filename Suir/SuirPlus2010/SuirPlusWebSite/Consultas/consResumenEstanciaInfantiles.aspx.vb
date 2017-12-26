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
        Me.gvResumeEstanciasInf.DataSource = Nothing
        Me.gvResumeEstanciasInf.DataBind()
        Me.pnlNucleo.Visible = False


        If ddlPeriodos.SelectedValue = "0" Then
            Me.lbl_error.Visible = True
            Me.lbl_error.Text = "La Período es requerido"
            Exit Sub
        End If

        Try
            Dim nucleo As New DataTable
            nucleo = SuirPlus.Ars.Consultas.getResumenEstanciaInfantiles(ddlPeriodos.SelectedValue)

            If nucleo.Rows.Count > 0 Then
                Me.gvResumeEstanciasInf.DataSource = nucleo
                Me.gvResumeEstanciasInf.DataBind()
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
        Response.Redirect("~/Consultas/consResumenEstanciaInfantiles.aspx")
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
        nucleo = SuirPlus.Ars.Consultas.getResumenEstanciaInfantiles(ddlPeriodos.SelectedValue)

        If nucleo.Rows.Count > 0 Then
            ucExportarExcel.FileName = "Resumen_Dispersion_Estancia_Infantil" + ddlPeriodos.SelectedValue + ".xls"

        End If
        ucExportarExcel.DataSource = nucleo


    End Sub


    Private Sub CargarPeriodosDispersion()

        Dim dt As New DataTable
        dt = Ars.Consultas.getPeriodosDispersion()

        If dt.Rows.Count > 0 Then
            ddlPeriodos.DataSource = dt
            ddlPeriodos.DataTextField = "periodo_dispersion"
            ddlPeriodos.DataValueField = "periodo_dispersion"
            ddlPeriodos.DataBind()
        End If
        ddlPeriodos.Items.Insert(0, New ListItem("<-- Seleccione -->", "0"))
        ddlPeriodos.SelectedValue = 0

    End Sub

End Class
