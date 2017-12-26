Imports SuirPlus
Imports System.Data

Partial Class Reportes_CxC_Sector_Publico
    Inherits BasePage

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then

            'Cargando DropDown de Acciones
            Me.dlTipoReferencia.DataValueField = "ID"
            Me.dlTipoReferencia.DataTextField = "DESCRIPCION"
            Me.dlTipoReferencia.DataSource = Empresas.Consultas.get_TipoFactura()
            Me.dlTipoReferencia.DataBind()
            Me.dlTipoReferencia.Items.Insert(0, New System.Web.UI.WebControls.ListItem("Todos", "TODOS"))
        End If

    End Sub

    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click
        getData(Me.dlTipoEmpresa.SelectedValue, Me.dlTipoReferencia.SelectedValue, Me.dlEstatus.SelectedValue)
    End Sub

    Protected Sub getData(ByVal TipoEmpresa As String, ByVal TipoFactura As String, ByVal Status As String)
        Dim dt As New DataTable
        Try
            dt = Empresas.Consultas.get_CxC_SectorPublico(TipoEmpresa, TipoFactura, Status)

            If dt.Rows.Count > 0 Then
                Me.pnlReporte.Visible = True
                Me.lblMsg.Visible = False
                rvCxCSectorPublico.LocalReport.DataSources.Clear()
                rvCxCSectorPublico.LocalReport.DataSources.Add(New Microsoft.Reporting.WebForms.ReportDataSource("CxC_SectorPublico_ds", dt))
                rvCxCSectorPublico.LocalReport.Refresh()
            Else
                Me.pnlReporte.Visible = False
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existe data para los parametros especificados"
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.Response.Redirect("CxC_Sector_Publico.aspx")
    End Sub
End Class
