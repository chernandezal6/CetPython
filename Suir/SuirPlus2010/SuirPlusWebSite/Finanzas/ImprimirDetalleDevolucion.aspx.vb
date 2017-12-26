Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.Certificaciones
Imports SuirPlus.Utilitarios.Utils
Imports System.Data
Imports SuirPlus.Finanzas

Partial Class Finanzas_ImprimirDetalleDevolucion
    Inherits System.Web.UI.Page

    Private reclamacion As String
    Private TotalSalarioG As Decimal
    Private TotalMontoDevG As Decimal
    ' Private TotalApoVoluntarioG As Decimal
    Private TotalSalarioA As Decimal
    Private TotalMontoSolA As Decimal
    Private TotalDevolverA As Decimal
    Private TotalSalarioR As Decimal
    Private TotalMontoDevR As Decimal
    'Private TotalApoVoluntarior As Decimal
    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            If Request.QueryString.Item("rec") <> String.Empty Then
                reclamacion = Request.QueryString.Item("rec")
                Session("rec") = reclamacion
                lblNroRelamacion.Text = reclamacion
                CargarInfoReclamacion(reclamacion)
                CargarDetReclamaciones()
            Else
                'poner mensaje aqui...
                Response.Redirect("~/finanzas/DevolucionAportes.aspx")
            End If
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


            If dt.Rows(0)("entregado_por").ToString() <> String.Empty Then
                lblEntregadoPor.Text = dt.Rows(0)("entregado_por").ToString().Split("|")(1)
                lblEntregadoPorEncabezado.Text = lblEntregadoPor.Text
            End If

            If dt.Rows(0)("nro_documento").ToString() <> String.Empty Then
                lblNroDocumento.Text = dt.Rows(0)("nro_documento").ToString()
                lblDocumentoTrabajador.Text = lblNroDocumento.Text
                tipoDoc = dt.Rows(0)("tipo_documento").ToString()
                lblRecibidoPor.Text = StrConv(Utilitarios.TSS.getNombreCiudadano(tipoDoc, lblNroDocumento.Text), VbStrConv.ProperCase)
                lblNombreCompleto.Text = lblRecibidoPor.Text
            End If

        End If


    End Sub

    Private Sub CargarDetReclamaciones()

        Dim dtG, dtA, dtR As New DataTable

        dtG = DevolucionAportes.getDetReclamaciones(Session("rec"), "GE", 1, 9999)
        dtA = DevolucionAportes.getDetReclamaciones(Session("rec"), "OK", 1, 9999)
        dtR = DevolucionAportes.getDetReclamaciones(Session("rec"), "RE", 1, 9999)

        'Cargamos los registros Generados
        If dtG.Rows.Count > 0 Then
            divGenerados.Visible = True
            Me.dlDetDevolucionesG.DataSource = dtG
            Me.dlDetDevolucionesG.DataBind()
        Else
            lblErrMsgG.Text = "No existen Registros."
            divGenerados.Visible = False
            Me.dlDetDevolucionesG.DataSource = Nothing
            Me.dlDetDevolucionesG.DataBind()
        End If
        'Cargamos los registros Aprobados
        If dtA.Rows.Count > 0 Then
            divAprobados.Visible = True
            dlDetDevolucionesA.DataSource = dtA
            dlDetDevolucionesA.DataBind()
        Else
            lblErrMsgA.Text = "No existen Registros."
            divAprobados.Visible = False
            dlDetDevolucionesA.DataSource = Nothing
            dlDetDevolucionesA.DataBind()
        End If
        'Cargamos los registros Rechazados
        If dtR.Rows.Count > 0 Then
            divRechazados.Visible = True
            dlDetDevolucionesR.DataSource = dtR
            dlDetDevolucionesR.DataBind()
        Else
            lblErrMsgR.Text = "No existen Registros."
            divRechazados.Visible = False
            dlDetDevolucionesR.DataSource = Nothing
            dlDetDevolucionesR.DataBind()
        End If
        dtG = Nothing
        dtA = Nothing
        dtR = Nothing

    End Sub
    Protected Sub dlDetDevolucionesA_ItemDataBound(sender As Object, e As System.Web.UI.WebControls.DataListItemEventArgs) Handles dlDetDevolucionesA.ItemDataBound
        Dim totalSalario = CType(e.Item.FindControl("lblTotalSalarioA"), Label)
        Dim totalMontoSolicitadoA = CType(e.Item.FindControl("lblTotalMontoSolicitadoA"), Label)
        Dim totalMontoDevolverA = CType(e.Item.FindControl("lblTotalMontoDevolverA"), Label)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then

            TotalSalarioA = TotalSalarioA + CType(e.Item.FindControl("lblSalarioA"), Label).Text
            TotalMontoSolA = TotalMontoSolA + CType(e.Item.FindControl("lblMontoSolicitadoA"), Label).Text
            TotalDevolverA = TotalDevolverA + CType(e.Item.FindControl("lblTotalDevolverA"), Label).Text

        ElseIf e.Item.ItemType = ListItemType.Footer Then
            totalSalario.Text = FormatCurrency(TotalSalarioA)
            totalMontoSolicitadoA.Text = FormatCurrency(TotalMontoSolA)
            totalMontoDevolverA.Text = FormatCurrency(TotalDevolverA)
        End If
    End Sub

    Protected Sub dlDetDevolucionesR_ItemDataBound(sender As Object, e As System.Web.UI.WebControls.DataListItemEventArgs) Handles dlDetDevolucionesR.ItemDataBound
        Dim MotivoRechazo As Label = CType(e.Item.FindControl("lblMotivoRechazo"), Label)
        Dim totalSalario = CType(e.Item.FindControl("lblTotalSalarioR"), Label)
        Dim totalMontoDev = CType(e.Item.FindControl("lblTotalMontoDevolucionR"), Label)
        ' Dim totalAporteVol = CType(e.Item.FindControl("lblTotalAporteVoluntarioR"), Label)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            If MotivoRechazo.Text <> String.Empty Then
                If MotivoRechazo.Text.Length > 35 Then
                    MotivoRechazo.Text = MotivoRechazo.Text.Substring(0, 35) & "..."
                End If
            Else
                MotivoRechazo.Text = "N/A"
            End If
            TotalSalarioR = TotalSalarioR + CType(e.Item.FindControl("lblSalarioR"), Label).Text
            TotalMontoDevR = TotalMontoDevR + CType(e.Item.FindControl("lblMontoDevolucionR"), Label).Text
            ' TotalApoVoluntarior = TotalApoVoluntarior + CType(e.Item.FindControl("lblAporteVoluntarioR"), Label).Text

        ElseIf e.Item.ItemType = ListItemType.Footer Then
            totalSalario.Text = FormatCurrency(TotalSalarioR)
            totalMontoDev.Text = FormatCurrency(TotalMontoDevR)
            ' totalAporteVol.Text = FormatCurrency(TotalApoVoluntarior)
        End If
    End Sub

    Protected Sub dlDetDevolucionesG_ItemDataBound(sender As Object, e As System.Web.UI.WebControls.DataListItemEventArgs) Handles dlDetDevolucionesG.ItemDataBound
        Dim totalSalario = CType(e.Item.FindControl("lblTotalSalarioG"), Label)
        Dim totalMontoDev = CType(e.Item.FindControl("lblTotalMontoDevolucionG"), Label)
        '  Dim totalAporteVol = CType(e.Item.FindControl("lblTotalAporteVoluntarioG"), Label)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then

            TotalSalarioG = TotalSalarioG + CType(e.Item.FindControl("lblSalarioG"), Label).Text
            TotalMontoDevG = TotalMontoDevG + CType(e.Item.FindControl("lblMontoDevolucionG"), Label).Text
            ' TotalApoVoluntarioG = TotalApoVoluntarioG + CType(e.Item.FindControl("lblAporteVoluntarioG"), Label).Text

        ElseIf e.Item.ItemType = ListItemType.Footer Then
            totalSalario.Text = FormatCurrency(TotalSalarioG)
            totalMontoDev.Text = FormatCurrency(TotalMontoDevG)
            '  totalAporteVol.Text = FormatCurrency(TotalApoVoluntarioG)
        End If
    End Sub
End Class
