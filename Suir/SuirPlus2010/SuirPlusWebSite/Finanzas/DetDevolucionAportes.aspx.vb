Imports SuirPlus.Finanzas
Imports System.Data
Imports SuirPlus
Imports System.Globalization

Partial Class Finanzas_DetDevolucionAportes
    Inherits BasePage
    Private reclamacion As String
    Private rnc As String
    Private razonSocial As String
    Private statusReclamacion As String
    Private statusDetalle As String
    Private TotalSalarioG As Decimal
    Private TotalMontoSolG As Decimal
    Private TotalApoVoluntarioG As Decimal
    Private TotalSalarioA As Decimal
    Private TotalMontoDevA As Decimal
    Private TotalMontoSolA As Decimal
    Private TotalApoVoluntarioA As Decimal
    Private TotalSalarioR As Decimal
    Private TotalMontoSolR As Decimal
    Private TotalApoVoluntarioR As Decimal

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        If Request.QueryString.Item("rec") <> String.Empty Then
            reclamacion = Request.QueryString.Item("rec")
            CargarInfoReclamacion(reclamacion)
            CargarDetReclamaciones()
        Else
            'poner mensaje aqui...
            Response.Redirect("~/finanzas/DevolucionAportes.aspx")
        End If

    End Sub
    Private Sub CargarInfoReclamacion(nroReclamacion As String)
        Dim dt As New DataTable
        Dim tipoDoc As String = String.Empty
        Dim NroDoc As String = String.Empty

        dt = DevolucionAportes.getReclamaciones(String.Empty, String.Empty, String.Empty, nroReclamacion, "T", 1, 9999)
        If dt.Rows.Count > 0 Then
            lblreclamacion.Text = reclamacion
            lblRnc.Text = dt.Rows(0)("rnc").ToString()
            lblRazonSocial.Text = dt.Rows(0)("razon_social").ToString()
            lblEstatus.Text = dt.Rows(0)("estatus").ToString()
            lblNroCheque.Text = dt.Rows(0)("nro_cheque").ToString()
            lblNroDocumento.Text = dt.Rows(0)("nro_documento").ToString()
            tipoDoc = dt.Rows(0)("tipo_documento").ToString()
            NroDoc = dt.Rows(0)("nro_documento").ToString()
            lblNombreCompleto.Text = StrConv(Utilitarios.TSS.getNombreCiudadano(tipoDoc, NroDoc), VbStrConv.ProperCase)
            If dt.Rows(0)("entregado_por").ToString() <> String.Empty Then
                lblEntregadoPor.Text = dt.Rows(0)("entregado_por").ToString().Split("|")(1)
            End If
            Session("rec") = reclamacion
        End If
        'validamos cuando mostrar el boton de entregar fondos
        If lblEstatus.Text.ToUpper = "PENDIENTE DEVOLUCION" Then
            lbtnEntregarFondos.Visible = True
            lbtnImprimir.Visible = False
            divInfoCheque.Visible = False
        ElseIf lblEstatus.Text.ToUpper = "COMPLETADA" Then
            lbtnEntregarFondos.Visible = False
            lbtnImprimir.Visible = True
            divInfoCheque.Visible = True
        End If

    End Sub

    Private Sub CargarDetReclamaciones()

        Dim dtG, dtA, dtR As New DataTable

        dtG = DevolucionAportes.getDetReclamaciones(Session("rec"), "GE", 1, 9999)
        dtA = DevolucionAportes.getDetReclamaciones(Session("rec"), "OK", 1, 9999)
        dtR = DevolucionAportes.getDetReclamaciones(Session("rec"), "RE", 1, 9999)

        'Cargamos los registros Generados
        If dtG.Rows.Count > 0 Then
            Me.gvDetDevolucionesG.DataSource = dtG
            Me.gvDetDevolucionesG.DataBind()
        Else
            lblErrMsgG.Text = "No existen Registros."
            Me.gvDetDevolucionesG.DataSource = Nothing
            Me.gvDetDevolucionesG.DataBind()
        End If
        'Cargamos los registros Aprobados
        If dtA.Rows.Count > 0 Then
            Me.gvDetDevolucionesA.DataSource = dtA
            Me.gvDetDevolucionesA.DataBind()
        Else
            lblErrMsgA.Text = "No existen Registros."
            Me.gvDetDevolucionesA.DataSource = Nothing
            Me.gvDetDevolucionesA.DataBind()
        End If
        'Cargamos los registros Rechazados
        If dtR.Rows.Count > 0 Then
            Me.gvDetDevolucionesR.DataSource = dtR
            Me.gvDetDevolucionesR.DataBind()
        Else
            lblErrMsgR.Text = "No existen Registros."
            Me.gvDetDevolucionesR.DataSource = Nothing
            Me.gvDetDevolucionesR.DataBind()
        End If
        dtG = Nothing
        dtA = Nothing
        dtR = Nothing

    End Sub

    Protected Sub gvDetDevolucionesG_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDetDevolucionesG.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            TotalSalarioG = TotalSalarioG + e.Row.Cells(4).Text
            TotalApoVoluntarioG = TotalApoVoluntarioG + e.Row.Cells(5).Text
            TotalMontoSolG = TotalMontoSolG + e.Row.Cells(6).Text

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(3).Text = "Totales:&nbsp;"
            e.Row.Cells(3).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(4).Text = FormatNumber(TotalSalarioG)
            e.Row.Cells(4).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(5).Text = FormatNumber(TotalApoVoluntarioG)
            e.Row.Cells(5).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(6).Text = FormatNumber(TotalMontoSolG)
            e.Row.Cells(6).HorizontalAlign = HorizontalAlign.Right

        End If
    End Sub

    Protected Sub gvDetDevolucionesA_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDetDevolucionesA.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            TotalSalarioA = TotalSalarioA + e.Row.Cells(4).Text
            TotalApoVoluntarioA = TotalApoVoluntarioA + e.Row.Cells(5).Text
            TotalMontoSolA = TotalMontoSolA + e.Row.Cells(6).Text
            TotalMontoDevA = TotalMontoDevA + e.Row.Cells(7).Text

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(3).Text = "Totales:&nbsp;"
            e.Row.Cells(3).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(4).Text = FormatNumber(TotalSalarioA)
            e.Row.Cells(4).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(5).Text = FormatNumber(TotalApoVoluntarioA)
            e.Row.Cells(5).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(6).Text = FormatNumber(TotalMontoSolA)
            e.Row.Cells(6).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(7).Text = FormatNumber(TotalMontoDevA)
            e.Row.Cells(7).HorizontalAlign = HorizontalAlign.Right

        End If
    End Sub

    Protected Sub gvDetDevolucionesR_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDetDevolucionesR.RowDataBound

        Dim MotivoRechazo As Label = CType(e.Row.FindControl("lblMotivoRechazo"), Label)
        If e.Row.RowType = DataControlRowType.DataRow Then
            If MotivoRechazo.Text <> String.Empty Then
                If MotivoRechazo.Text.Length > 35 Then
                    MotivoRechazo.Text = MotivoRechazo.Text.Substring(0, 35) & "..."
                End If
            Else
                MotivoRechazo.Text = "N/A"
            End If
            TotalSalarioR = TotalSalarioR + e.Row.Cells(5).Text
            TotalApoVoluntarioR = TotalApoVoluntarioR + e.Row.Cells(6).Text
            TotalMontoSolR = TotalMontoSolR + e.Row.Cells(7).Text

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(4).Text = "Totales:&nbsp;"
            e.Row.Cells(4).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(5).Text = FormatNumber(TotalSalarioR)
            e.Row.Cells(5).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(6).Text = FormatNumber(TotalApoVoluntarioR)
            e.Row.Cells(6).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(7).Text = FormatNumber(TotalMontoSolR)
            e.Row.Cells(7).HorizontalAlign = HorizontalAlign.Right

        End If
    End Sub

    Protected Sub lbtnEntregarFondos_Click(sender As Object, e As System.EventArgs) Handles lbtnEntregarFondos.Click
        reclamacion = Me.lblreclamacion.Text
        Response.Redirect("~/finanzas/EntregarFondos.aspx?rec=" & reclamacion)
    End Sub

    Protected Sub lbtnEncabezado_Click(sender As Object, e As System.EventArgs) Handles lbtnEncabezado.Click
        reclamacion = Me.lblreclamacion.Text
        Response.Redirect("~/finanzas/DevolucionAportes.aspx?rec=" & reclamacion)
        Session.Remove("rec")
    End Sub


End Class
