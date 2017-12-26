Imports System.Data
Imports SuirPlus
Partial Class Empleador_consNotificaciones
    Inherits BasePage

    Private totalNot As Double
    Private recargoNOT As Double
    Private interesNOT As Double
    Private creditosNOT As Double

    Private totalLiq As Double
    Private recargoLiq As Double
    Private interesLiq As Double

    Private totalIR As Double
    Private recargoIR As Double
    Private interesIR As Double
    Private totalINF As Double
    Private totalMDT As Double

    Private totalISRP As Double


    Dim usuario As String = String.Empty

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        Me.totalNot = 0
        Me.recargoNOT = 0
        Me.interesNOT = 0
        Me.creditosNOT = 0

        Me.totalIR = 0
        Me.recargoIR = 0
        Me.interesIR = 0

        Me.totalLiq = 0
        Me.recargoLiq = 0
        Me.interesLiq = 0

        Me.totalINF = 0
        Me.totalMDT = 0


        If Me.UsrImpersonandoUnRepresentante Then
            usuario = Me.UsrImpUserName

            'Completando los datos de la empresa
            Dim empresa As New Empresas.Empleador(Me.UsrImpRNC)
            Me.lblRNC.Text = "<b>RNC:</b> " & empresa.RNCCedula
            Me.lblRazonSocial.Text = "<b>Razon Social:</b> " & empresa.RazonSocial

        Else
            usuario = Me.UsrUserName

            'Completando los datos de la empresa
            Dim empresa As New Empresas.Empleador(Me.UsrRNC)
            Me.lblRNC.Text = "<b>RNC:</b> " & empresa.RNCCedula
            lblRazonSocial.Text = "<b>Razon Social:</b> " & empresa.RazonSocial
        End If

        If Not Page.IsPostBack Then
            Me.CargarDatosNotificacionesTSS()
        End If



    End Sub

    Private Sub dgLiq_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgLiquidaciones.RowDataBound

        If (e.Row.RowType = DataControlRowType.DataRow) Then

            e.Row.Cells(0).Text = "<a href=""consFacturas.aspx?tipo=isr&sec=encabezado&nro=" & e.Row.Cells(0).Text & """>" & e.Row.Cells(0).Text & "</a>"

            Me.recargoLiq = Me.recargoLiq + e.Row.Cells(5).Text
            Me.interesLiq = Me.interesLiq + e.Row.Cells(6).Text
            Me.totalLiq = Me.totalLiq + e.Row.Cells(7).Text

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(4).Text = "Total: "
            e.Row.Cells(5).Text = String.Format("{0:c}", Me.recargoLiq)
            e.Row.Cells(6).Text = String.Format("{0:c}", Me.interesLiq)
            e.Row.Cells(7).Text = String.Format("{0:c}", totalLiq)
        End If

    End Sub

    'Private Sub dgLiqIR17_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgLiqIR17.RowDataBound

    'If (e.Row.RowType = DataControlRowType.DataRow) Then

    'e.Row.Cells(0).Text = "<a href=""consFacturas.aspx?tipo=ir17&sec=encabezado&nro=" & e.Row.Cells(0).Text & """>" & e.Row.Cells(0).Text & "</a>"

    'Me.recargoIR = Me.recargoIR + e.Row.Cells(5).Text
    'Me.interesIR = Me.interesIR + e.Row.Cells(6).Text
    'Me.totalIR = Me.totalIR + e.Row.Cells(7).Text

    'ElseIf e.Row.RowType = DataControlRowType.Footer Then
    'e.Row.Cells(4).Text = "Total: "
    'e.Row.Cells(5).Text = String.Format("{0:c}", Me.recargoIR)
    'e.Row.Cells(6).Text = String.Format("{0:c}", Me.interesIR)
    'e.Row.Cells(7).Text = String.Format("{0:c}", totalIR)
    'End If

    'End Sub

    Private Sub dgLiqINF_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgLiqINF.RowDataBound

        If (e.Row.RowType = DataControlRowType.DataRow) Then

            e.Row.Cells(0).Text = "<a href=""consFacturas.aspx?tipo=INF&sec=encabezado&nro=" & e.Row.Cells(0).Text & """>" & e.Row.Cells(0).Text & "</a>"

            totalINF = totalINF + e.Row.Cells(4).Text

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(3).Text = "Total: "
            e.Row.Cells(3).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(4).Text = String.Format("{0:c}", totalINF)
        End If

    End Sub

    Private Sub dgNot_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgNotificaciones.RowDataBound

        If (e.Row.RowType = DataControlRowType.DataRow) Then
            e.Row.Cells(0).Text = "<a href=""consFacturas.aspx?tipo=sdss&sec=encabezado&nro=" & e.Row.Cells(0).Text & """>" & e.Row.Cells(0).Text & "</a>"

            Me.recargoNOT = Me.recargoNOT + e.Row.Cells(6).Text
            Me.interesNOT = Me.interesNOT + e.Row.Cells(7).Text
            Me.creditosNOT = Me.creditosNOT + e.Row.Cells(8).Text
            Me.totalNot = Me.totalNot + e.Row.Cells(9).Text

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(5).Text = "Total: "
            e.Row.Cells(6).Text = String.Format("{0:c}", Me.recargoNOT)
            e.Row.Cells(7).Text = String.Format("{0:c}", Me.interesNOT)
            e.Row.Cells(8).Text = String.Format("{0:c}", Me.creditosNOT)
            e.Row.Cells(9).Text = String.Format("{0:c}", Me.totalNot)
        End If

    End Sub


    'Protected Sub dgPlanillasMDT_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgPlanillasMDT.RowDataBound
    '    If (e.Row.RowType = DataControlRowType.DataRow) Then

    '        e.Row.Cells(0).Text = "<a href=""consFacturas.aspx?tipo=MDT&sec=encabezado&nro=" & e.Row.Cells(0).Text & """>" & e.Row.Cells(0).Text & "</a>"

    '        totalMDT = totalMDT + e.Row.Cells(5).Text

    '    ElseIf e.Row.RowType = DataControlRowType.Footer Then
    '        e.Row.Cells(4).Text = "Total: "
    '        e.Row.Cells(4).HorizontalAlign = HorizontalAlign.Right
    '        e.Row.Cells(5).Text = String.Format("{0:c}", totalMDT)
    '    End If
    'End Sub

    Private Sub dgLiqISRP_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPreLiquidaciones.RowDataBound

        If (e.Row.RowType = DataControlRowType.DataRow) Then
            e.Row.Cells(0).Text = "<a href=""consFacturas.aspx?tipo=isrp&sec=encabezado&nro=" & CType(e.Row.FindControl("lblPeriodo"), Label).Text & "&tifa=" & CType(e.Row.FindControl("lblTipo"), Label).Text & """>" & FormatearPeriodo(CType(e.Row.FindControl("lblPeriodo"), Label).Text) & "</a>"
        End If

    End Sub

    Private Sub CargarDatosNotificacionesTSS()
        Try
            Me.recargoNOT = 0
            Me.interesNOT = 0
            Me.totalNot = 0

            Dim dtTSS As DataTable

            dtTSS = Empresas.Facturacion.Factura.getNotificaciones(SuirPlus.Empresas.Facturacion.Factura.eConcepto.SDSS, Convert.ToInt32(Me.UsrRegistroPatronal), Me.usuario, Me.ddlStatusTSS.SelectedValue)

            Me.dgNotificaciones.DataSource = dtTSS
            Me.dgNotificaciones.DataBind()



        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub CargarDatosLiquidacionesISR()

       

        Try

            Me.recargoLiq = 0
            Me.interesLiq = 0
            Me.totalLiq = 0

            Dim dtDGII As DataTable
            dtDGII = Empresas.Facturacion.Factura.getNotificaciones(SuirPlus.Empresas.Facturacion.Factura.eConcepto.ISR, Convert.ToInt32(Me.UsrRegistroPatronal), Me.usuario, Me.ddlStatusISR.SelectedValue)

            Me.dgLiquidaciones.DataSource = dtDGII
            Me.dgLiquidaciones.DataBind()

        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub CargarDatosIR17()

        'Me.recargoIR = 0
        'Me.interesIR = 0
        'Me.totalIR = 0

        'Dim dtIR17 As DataTable
        'dtIR17 = Empresas.Facturacion.Factura.getNotificaciones(SuirPlus.Empresas.Facturacion.Factura.eConcepto.IR17, Convert.ToInt32(Me.UsrRegistroPatronal), Me.usuario, Me.ddlStatusIR17.SelectedValue)

        'Try
        'Dim dtIR17f As New DataTable
        'dtIR17f = dtIR17.Clone

        'Dim dr As DataRow

        'Dim strFiltro As String = ""

        'Select Case Me.ddlStatusIR17.SelectedValue
        'Case "VIVE"
        'strFiltro = "CodStatus in ('VI', 'VE') and NO_AUTORIZACION  is null "
        'Case "PAAC"
        'strFiltro = "CodStatus in ('PA', 'AC') or NO_AUTORIZACION is not Null"
        'Case "EX"
        'strFiltro = "CodStatus in ('EX')"
        'End Select

        'dtIR17f.DefaultView.Sort = "periodo_factura Desc, Fecha_Emision Desc"

        'For Each dr In dtIR17.Select(strFiltro)
        'dtIR17f.ImportRow(dr)
        'Next

        'Me.dgLiqIR17.DataSource = dtIR17f
        'Me.dgLiqIR17.DataBind()


        'Catch ex As Exception
        'Me.lblMensaje.Text = ex.Message
        'SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        'End Try

    End Sub

    Private Sub CargarDatosInfotep()

       
        Try
            Me.totalINF = 0
            Dim dtINF As DataTable
            dtINF = Empresas.Facturacion.Factura.getNotificaciones(SuirPlus.Empresas.Facturacion.Factura.eConcepto.INF, Convert.ToInt32(Me.UsrRegistroPatronal), Me.usuario, Me.ddlStatusINF.SelectedValue)

            Me.dgLiqINF.DataSource = dtINF
            Me.dgLiqINF.DataBind()

        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try


    End Sub

    'Private Sub CargarDatosMDT()
    '    Try
    '        Me.totalMDT = 0
    '        Dim dtMDT As DataTable
    '        dtMDT = Empresas.Facturacion.Factura.getNotificaciones(SuirPlus.Empresas.Facturacion.Factura.eConcepto.MDT, Convert.ToInt32(Me.UsrRegistroPatronal), Me.usuario, Me.ddlStatusMDT.SelectedValue)

    '        Me.dgPlanillasMDT.DataSource = dtMDT
    '        Me.dgPlanillasMDT.DataBind()

    '    Catch ex As Exception
    '        Me.lblMensaje.Text = ex.Message
    '        SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
    '    End Try


    'End Sub
    ' SE COMENTO A SOLICITUD DEL TASK 8194


    Private Sub CargarDatosLiquidacionesISRPre()

        Dim dtDGII As DataTable
        Try

            Me.totalISRP = 0
            dtDGII = Empresas.Facturacion.Factura.getNotificaciones(SuirPlus.Empresas.Facturacion.Factura.eConcepto.ISRP, Convert.ToInt32(Me.UsrRegistroPatronal), Me.usuario, "")

            If dtDGII.Rows.Count > 0 Then
                Me.gvPreLiquidaciones.DataSource = dtDGII
                Me.gvPreLiquidaciones.DataBind()
            End If

        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try


        dtDGII = Nothing
    End Sub

    Public Sub CargarCRM()

        Dim dt As DataTable = SuirPlus.Empresas.CRM.getCRMs(Me.UsrRegistroPatronal)

        Me.gvCRM.DataSource = dt
        Me.gvCRM.DataBind()

    End Sub

    Public Sub CargarCertificaciones()

        Dim dt As DataTable = SuirPlus.Empresas.Empleador.getUtimosCert(Me.UsrRegistroPatronal)

        Me.GridView1.DataSource = dt
        Me.GridView1.DataBind()

    End Sub

    Public Sub CargarSolicitudes()

        Me.ucSolByRNC.RNC = Me.UsrRNC
        Me.ucSolByRNC.MostrarUltimaColumna = False
        Me.ucSolByRNC.Mostrar()

    End Sub

    Protected Sub Tabs_ActiveTabChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles tbContainer.ActiveTabChanged

        Dim tab As String = CType(sender, AjaxControlToolkit.TabContainer).ActiveTab.HeaderText
        Try

            Select Case tab

                Case "EstadoDeCuentas"
                    Me.CargarDatosNotificacionesTSS()
                Case "Liquidaciones"
                    Me.CargarDatosLiquidacionesISR()
                    'Case "IR17"
                    'Me.CargarDatosIR17()
                Case "INFOTEP"
                    Me.CargarDatosInfotep()
                Case "Registros en Nuestro CRM"
                    Me.CargarCRM()
                Case "Certificaciones"
                    Me.CargarCertificaciones()
                Case "Solicitudes"
                    Me.CargarSolicitudes()
                    'Case "MDT"
                    '    CargarDatosMDT()
                    ' SE COMENTO A SOLICITUD DEL TASK 8194
                Case "Pre-Liquidación"
                    CargarDatosLiquidacionesISRPre()
            End Select

        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub ddlStatusTSS_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Me.CargarDatosNotificacionesTSS()
    End Sub

    Protected Sub ddlStatusISR_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Me.CargarDatosLiquidacionesISR()
    End Sub

    'Protected Sub ddlStatusIR17_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
    'Me.CargarDatosIR17()
    'End Sub
    ' SE COMENTO A SOLICITUD DEL TASK 8194

    Protected Sub ddlStatusINF_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Me.CargarDatosInfotep()
    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        If Not Page.IsPostBack Then

            Me.tbContainer.ActiveTabIndex = 0

        End If
    End Sub

    Protected Function FormatearPeriodo(ByVal periodo As String) As String

        Return Utilitarios.Utils.FormateaPeriodo(periodo)

    End Function


    'Protected Sub ddlStatusMDT_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles ddlStatusMDT.SelectedIndexChanged
    '    CargarDatosMDT()
    'End Sub

    ' SE COMENTO A SOLICITUD DEL TASK 8194
End Class
