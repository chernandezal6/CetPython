Imports SuirPlus
Imports System.Data

Partial Class Reportes_CxC_Sector_Privado
    Inherits BasePage

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then

            getData(CInt(Me.txtDesde.Text), CInt(Me.txtHasta.Text))

        End If

    End Sub

    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click
        getData(CInt(Me.txtDesde.Text), CInt(Me.txtHasta.Text))
    End Sub

    Protected Sub getData(ByVal desde As Integer, ByVal hasta As Integer)
        Dim dt As New DataTable
        Try

            desde = Me.txtDesde.Text
            hasta = Me.txtHasta.Text
            dt = Empresas.Consultas.get_CxC_SectorPrivado(desde, hasta)

            If dt.Rows.Count > 0 Then
                Me.pnlCxCSectroPrivado.Visible = True
                Me.lblMsg.Visible = False
                rvCxCSectroPrivado.LocalReport.DataSources.Clear()
                rvCxCSectroPrivado.LocalReport.DataSources.Add(New Microsoft.Reporting.WebForms.ReportDataSource("CxCSectorPrivado_ds", dt))
                rvCxCSectroPrivado.LocalReport.Refresh()
            Else
                Me.pnlCxCSectroPrivado.Visible = False
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existe data para el rango seleccionado"
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
            Me.pnlCxCSectroPrivado.Visible = False
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.Response.Redirect("CxC_Sector_Privado.aspx")
    End Sub

End Class
