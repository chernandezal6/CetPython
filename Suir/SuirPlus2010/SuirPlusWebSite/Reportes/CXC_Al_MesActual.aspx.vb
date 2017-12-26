Imports SuirPlus
Imports System.Data

Partial Class Reportes_CXC_Al_MesActual
    Inherits BasePage

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            CargarProvincias()
            ' getData(Me.ddlProvincia.SelectedValue, CInt(Me.txtMonto.Text))
        End If

    End Sub
    Protected Sub CargarProvincias()

        Me.ddlProvincia.DataSource = SuirPlus.Utilitarios.TSS.getProvincias()
        Me.ddlProvincia.DataTextField = "PROVINCIA_DES"
        Me.ddlProvincia.DataValueField = "Id_provincia"
        Me.ddlProvincia.DataBind()
        Me.ddlProvincia.Items.Insert(0, New System.Web.UI.WebControls.ListItem("Todos", "-1"))

        Me.ddlProvincia.SelectedValue = ""
    End Sub

    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click
        Dim desde As Integer
        Dim hasta As Integer

        If Not IsNumeric(txtMonto.Text) Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = "Monto inválido"
            Me.pnlCxCMesActual.Visible = False
            Exit Sub
        End If
        If (txtDesde.Text = String.Empty And txtHasta.Text <> String.Empty) Or (txtDesde.Text <> String.Empty And txtHasta.Text = String.Empty) Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = "El Rango de períodos atrazados es inválido"
            Me.pnlCxCMesActual.Visible = False
            Exit Sub
        End If
        If (txtDesde.Text <> String.Empty And Not IsNumeric(txtDesde.Text)) Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = "El Rango de períodos atrazados es inválido"
            Me.pnlCxCMesActual.Visible = False
            Exit Sub
        End If
        If (txtHasta.Text <> String.Empty And Not IsNumeric(txtHasta.Text)) Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = "El Rango de períodos atrazados es inválido"
            Me.pnlCxCMesActual.Visible = False
            Exit Sub
        End If

        If txtDesde.Text <> String.Empty And txtHasta.Text <> String.Empty Then
            desde = CInt(txtDesde.Text)
            hasta = CInt(txtHasta.Text)
        End If

        getData(Me.ddlProvincia.SelectedValue, CInt(Me.txtMonto.Text), desde, hasta)
    End Sub

    Protected Sub getData(ByVal IdProvincia As String, ByVal Monto As Integer, ByVal Desde As Integer, ByVal Hasta As Integer)
        Dim dt As New DataTable
        Try
            dt = Empresas.Consultas.get_CxC_MesActual(IdProvincia, Monto, desde, hasta)
            If dt.Rows.Count > 0 Then
                Me.pnlCxCMesActual.Visible = True
                Me.lblMsg.Visible = False
                ReportViewer1.LocalReport.DataSources.Clear()
                ReportViewer1.LocalReport.DataSources.Add(New Microsoft.Reporting.WebForms.ReportDataSource("DSCxC_AlMesActual_ds", dt))
                ReportViewer1.LocalReport.Refresh()

            Else
                Me.pnlCxCMesActual.Visible = False
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existe data para los parametros seleccionado"
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
            Me.pnlCxCMesActual.Visible = False
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.Response.Redirect("CxC_Al_MesActual.aspx")
    End Sub


End Class
