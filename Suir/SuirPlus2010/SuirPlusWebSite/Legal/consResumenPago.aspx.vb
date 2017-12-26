Imports SuirPlus
Imports System.Data
Partial Class Legal_consResumenPago
    Inherits BasePage
    Dim periodoINI As Integer = 0
    Dim periodoFIN As Integer = 0
    Protected Sub Page_Load1(sender As Object, e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim periodoINI = CInt((DateTime.Now.Year - 1) & "01")
            Dim dt As System.Data.DataTable = Utilitarios.Utils.getRangoPeriodos(periodoINI, CInt(Utilitarios.Utils.getPeriodoActual()))
            Session.Remove("periodoIni")
            Session.Remove("periodoFin")
            'Cargando el dropdownlist de periodo desde
            ddlPeriodoIni.DataSource = dt
            ddlPeriodoIni.DataTextField = "periodo"
            ddlPeriodoIni.DataValueField = "periodo"
            ddlPeriodoIni.DataBind()
            ddlPeriodoIni.Items.Insert(0, New ListItem("<--Seleccione-->", "0"))
            ddlPeriodoFin.Items.Insert(0, New ListItem("<--Seleccione-->", "0"))
        End If
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click

        Dim dt As DataTable
        If ddlPeriodoIni.SelectedValue <> "0" Then
            If ddlPeriodoFin.SelectedValue = "0" Then
                periodoFIN = CInt(Utilitarios.Utils.getPeriodoActual())
            Else
                periodoFIN = CInt(ddlPeriodoFin.SelectedValue)
            End If
            periodoINI = CInt(ddlPeriodoIni.SelectedValue)
            Session("periodoIni") = periodoINI
            Session("periodoFin") = periodoFIN
            dt = Legal.AcuerdosDePago.getResumenPago(periodoINI, periodoFIN)
            If dt.Rows.Count > 0 Then
                pnlResumenPago.Visible = True
                lblMensaje.Visible = False
                gvResumenPago.DataSource = dt
                gvResumenPago.DataBind()
                ucExportarExcel1.Visible = True
            Else
                pnlResumenPago.Visible = False
                lblMensaje.Visible = True
                lblMensaje.Text = "No hay data."
                ucExportarExcel1.Visible = False
            End If
        Else
            lblMensaje.Visible = True
            lblMensaje.Text = "El período desde es requerido"
            Exit Sub
        End If
    End Sub

    Protected Sub ddlPeriodoIni_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlPeriodoIni.SelectedIndexChanged
        If ddlPeriodoIni.SelectedValue = "0" Then
            lblMensaje.Visible = True
            lblMensaje.Text = "El período desde es requerido"
            ddlPeriodoFin.Enabled = False
            pnlResumenPago.Visible = False
            ddlPeriodoFin.SelectedValue = "0"
            Exit Sub
        End If
        Dim dt2 As System.Data.DataTable = Utilitarios.Utils.getRangoPeriodos(CInt(ddlPeriodoIni.SelectedValue), CInt(Utilitarios.Utils.getPeriodoActual()))
        'Cargando el dropdownlist de periodo hasta
        ddlPeriodoFin.DataSource = dt2
        ddlPeriodoFin.DataTextField = "periodo"
        ddlPeriodoFin.DataValueField = "periodo"
        ddlPeriodoFin.DataBind()
        ddlPeriodoFin.Items.Insert(0, New ListItem("<--Seleccione-->", "0"))
        ddlPeriodoFin.Enabled = True
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        Response.Redirect("consResumenPago.aspx")
    End Sub

    Protected Sub ucExportarExcel1_ExportaExcel(sender As Object, e As EventArgs) Handles ucExportarExcel1.ExportaExcel
        Dim dt = Legal.AcuerdosDePago.getResumenPago(CInt(Session("periodoIni")), CInt(Session("periodoFin")))
        ucExportarExcel1.FileName = "ResumenPago " & CInt(Session("periodoIni")) & "-" & CInt(Session("periodoFin")) & ".xls"
        ucExportarExcel1.DataSource = dt
    End Sub
End Class
