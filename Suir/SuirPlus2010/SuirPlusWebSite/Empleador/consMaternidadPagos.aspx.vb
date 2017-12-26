Imports SuirPlus
Imports System.Data
Partial Class Empleador_consMaternidadPagos
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        gvCBanco()
        gvPagoN()
        gvPagoErrores()
    End Sub
    Protected Function formateaPeriodo(ByVal Periodo As String) As String

        If Periodo = String.Empty Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormateaPeriodo(Periodo)
        End If

    End Function
    Protected Function formateaRNC(ByVal rnc As String) As String

        If rnc = String.Empty Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormatearRNCCedula(rnc)
        End If

    End Function


#Region "Navegacion CuentaBancaria"
    Public Property pageNum() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNum.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNum.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNum.Text = value
        End Set
    End Property
    Public Property PageSize() As Int16
        Get
            If String.IsNullOrEmpty(Me.lblPageSize.Text) Then
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSize.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSize.Text = value
        End Set
    End Property

    Private Sub setNavigation()

        Dim totalRecords As Integer = 0

        If IsNumeric(Me.lblTotalRegistros.Text) Then
            totalRecords = CInt(Me.lblTotalRegistros.Text)
        End If

        Dim totalPages As Double = Math.Ceiling(Convert.ToDouble(totalRecords) / PageSize)

        If totalRecords = 1 Or totalPages = 0 Then
            totalPages = 1
        End If

        If PageSize > totalRecords Then
            PageSize = Int16.Parse(totalPages)
        End If

        Me.lblCurrentPage.Text = pageNum
        Me.lblTotalPages.Text = totalPages

        If pageNum = 1 Then
            Me.btnLnkFirstPage.Enabled = False
            Me.btnLnkPreviousPage.Enabled = False
        Else
            Me.btnLnkFirstPage.Enabled = True
            Me.btnLnkPreviousPage.Enabled = True
        End If

        If pageNum = totalPages Then
            Me.btnLnkNextPage.Enabled = False
            Me.btnLnkLastPage.Enabled = False
        Else
            Me.btnLnkNextPage.Enabled = True
            Me.btnLnkLastPage.Enabled = True
        End If

    End Sub
    Protected Sub NavigationLink_Click(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First"
                pageNum = 1
            Case "Last"
                pageNum = Convert.ToInt32(lblTotalPages.Text)
            Case "Next"
                pageNum = Convert.ToInt32(lblCurrentPage.Text) + 1
            Case "Prev"
                pageNum = Convert.ToInt32(lblCurrentPage.Text) - 1
        End Select

        gvCBanco()

    End Sub

    Private Sub gvCBanco()
        Try
            Dim dtCBanco As DataTable = Empresas.SubsidiosSFS.Consultas.getPagoCuentaBancaria(UsrRegistroPatronal, pageNumNP, PageSizeNP, txtCedula.Text)
            If dtCBanco.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dtCBanco.Rows(0)("RECORDCOUNT")
                Me.gvPagosCBanco.DataSource = dtCBanco
                Me.gvPagosCBanco.DataBind()
                Me.pnlMaternidadPago.Visible = True
                Me.lblMensajeMaternidadPago.Visible = False
            Else
                Me.pnlMaternidadPago.Visible = False
                Me.lblMensajeMaternidadPago.Text = "No hay data para mostrar"
            End If

        Catch ex As Exception
            Me.lblMensajeMaternidadPago.Text = ex.Message
        End Try

        setNavigation()

    End Sub
    Protected Sub UcExp_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel

        Dim dtCBanco As DataTable = Empresas.SubsidiosSFS.Consultas.getPagoCuentaBancaria(UsrRegistroPatronal, pageNumNP, PageSizeNP, txtCedula.Text)
        dtCBanco.Columns.Remove("RECORDCOUNT")
        dtCBanco.Columns.Remove("NUM")
        'TODO: lambda to replace codes with descriptions for tipocuenta
        ucExportarExcel1.FileName = "Banco_" & Me.UsrRNC & ".xls"
        ucExportarExcel1.DataSource = dtCBanco

    End Sub

    Private Sub LimpiarCBanco()
        PageSize = BasePage.PageSize
        lblMensajeMaternidadPago.Text = String.Empty
        pageNum = 1
        gvCBanco()
    End Sub
    Protected Sub gvPagosCBanco_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPagosCBanco.RowDataBound
        If e.Row.RowIndex > -1 Then
            e.Row.Cells(0).Text = Utilitarios.Utils.ProperCase(e.Row.Cells(0).Text)
            Select Case e.Row.Cells(2).Text
                Case "1"
                    e.Row.Cells(2).Text = "Cuenta Corriente"
                Case "2"
                    e.Row.Cells(2).Text = "Cuenta de Ahorro"
                Case Else
                    e.Row.Cells(2).Text = String.Empty
            End Select
        End If
    End Sub

#End Region

#Region "NP"
    Public Property pageNumNP() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNumNP.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNumNP.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNumNP.Text = value
        End Set
    End Property
    Public Property PageSizeNP() As Int16
        Get
            If String.IsNullOrEmpty(Me.lblPageSizeNP.Text) Then
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSizeNP.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSizeNP.Text = value
        End Set
    End Property

    Private Sub setNavigationNP()

        Dim totalRecordsNP As Integer = 0

        If IsNumeric(Me.lblTotalRegistrosNP.Text) Then
            totalRecordsNP = CInt(Me.lblTotalRegistrosNP.Text)
        End If

        Dim totalPagesNP As Double = Math.Ceiling(Convert.ToDouble(totalRecordsNP) / PageSizeNP)

        If totalRecordsNP = 1 Or totalPagesNP = 0 Then
            totalPagesNP = 1
        End If

        If PageSizeNP > totalRecordsNP Then
            PageSizeNP = Int16.Parse(totalPagesNP)
        End If

        Me.lblCurrentPageNP.Text = pageNumNP
        Me.lblTotalPagesNP.Text = totalPagesNP

        If pageNumNP = 1 Then
            Me.btnLnkFirstPageNP.Enabled = False
            Me.btnLnkPreviousPageNP.Enabled = False
        Else
            Me.btnLnkFirstPageNP.Enabled = True
            Me.btnLnkPreviousPageNP.Enabled = True
        End If

        If pageNumNP = totalPagesNP Then
            Me.btnLnkNextPageNP.Enabled = False
            Me.btnLnkLastPageNP.Enabled = False
        Else
            Me.btnLnkNextPageNP.Enabled = True
            Me.btnLnkLastPageNP.Enabled = True
        End If

    End Sub
    Protected Sub NavigationLinkNP_Click(ByVal s As Object, ByVal e As CommandEventArgs) Handles btnLnkFirstPageNP.Command, btnLnkPreviousPageNP.Command, btnLnkNextPageNP.Command, btnLnkLastPageNP.Command

        Select Case e.CommandName
            Case "First"
                pageNumNP = 1
            Case "Last"
                pageNumNP = Convert.ToInt32(lblTotalPagesNP.Text)
            Case "Next"
                pageNumNP = Convert.ToInt32(lblCurrentPageNP.Text) + 1
            Case "Prev"
                pageNumNP = Convert.ToInt32(lblCurrentPageNP.Text) - 1
        End Select

        gvPagoN()

    End Sub

    Private Sub gvPagoN()
        Try
            Dim dtPagoN As DataTable = Empresas.SubsidiosSFS.Consultas.getPagoNotificacionPago(UsrRegistroPatronal, pageNumNP, PageSizeNP, txtCedula.Text)

            If dtPagoN.Rows.Count > 0 Then
                Me.lblTotalRegistrosNP.Text = dtPagoN.Rows(0)("RECORDCOUNT")
                Me.gvPagosNotificaciones.DataSource = dtPagoN
                Me.gvPagosNotificaciones.DataBind()
                Me.pnlPagoNotificaiones.Visible = True
                Me.lblMensajeNotif.Visible = False
            Else
                Me.pnlPagoNotificaiones.Visible = False
                Me.lblMensajeNotif.Text = "No hay data para mostrar"
            End If
        Catch ex As Exception
            Me.lblMensajeNotif.Text = ex.Message
        End Try

        setNavigationNP()
    End Sub
    Protected Sub UcExp_ExportaExcel2(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel2.ExportaExcel

        Dim dtPagoN As DataTable = Empresas.SubsidiosSFS.Consultas.getPagoNotificacionPago(UsrRegistroPatronal, pageNumNP, PageSizeNP, txtCedula.Text)
        dtPagoN.Columns.Remove("RECORDCOUNT")
        dtPagoN.Columns.Remove("NUM")
        dtPagoN.Columns.Remove("NRO_REFERENCIA")
        ucExportarExcel2.FileName = "NP_" & Me.UsrRNC & ".xls"
        ucExportarExcel2.DataSource = dtPagoN

    End Sub

    Private Sub LimpiarNP()
        PageSizeNP = BasePage.PageSize
        lblMensajeNotif.Text = String.Empty
        pageNumNP = 1
        gvPagoN()
    End Sub
    Protected Sub gvPagosNotificaciones_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPagosNotificaciones.RowDataBound
        e.Row.Cells(0).Text = Utilitarios.Utils.ProperCase(e.Row.Cells(0).Text)
    End Sub
#End Region

#Region "Error"
    Public Property pageNumE() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNumE.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNumE.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNumE.Text = value
        End Set
    End Property
    Public Property PageSizeE() As Int16
        Get
            If String.IsNullOrEmpty(Me.lblPageSizeE.Text) Then
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSizeE.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSizeE.Text = value
        End Set
    End Property

    Private Sub setNavigationE()

        Dim totalRecordsE As Integer = 0

        If IsNumeric(Me.lblTotalRegistrosE.Text) Then
            totalRecordsE = CInt(Me.lblTotalRegistrosE.Text)
        End If

        Dim totalPagesE As Double = Math.Ceiling(Convert.ToDouble(totalRecordsE) / PageSizeE)

        If totalRecordsE = 1 Or totalPagesE = 0 Then
            totalPagesE = 1
        End If

        If PageSizeE > totalRecordsE Then
            PageSizeE = Int16.Parse(totalPagesE)
        End If

        Me.lblCurrentPageE.Text = pageNumE
        Me.lblTotalPagesE.Text = totalPagesE

        If pageNumE = 1 Then
            Me.btnLnkFirstPageE.Enabled = False
            Me.btnLnkPreviousPageE.Enabled = False
        Else
            Me.btnLnkFirstPageE.Enabled = True
            Me.btnLnkPreviousPageE.Enabled = True
        End If

        If pageNumE = totalPagesE Then
            Me.btnLnkNextPageE.Enabled = False
            Me.btnLnkLastPageE.Enabled = False
        Else
            Me.btnLnkNextPageE.Enabled = True
            Me.btnLnkLastPageE.Enabled = True
        End If

    End Sub
    Protected Sub NavigationLinkE_Click(ByVal s As Object, ByVal e As CommandEventArgs) Handles btnLnkFirstPageE.Command, btnLnkPreviousPageE.Command, btnLnkNextPageE.Command, btnLnkLastPageE.Command

        Select Case e.CommandName
            Case "First"
                pageNumE = 1
            Case "Last"
                pageNumE = Convert.ToInt32(lblTotalPagesE.Text)
            Case "Next"
                pageNumE = Convert.ToInt32(lblCurrentPageE.Text) + 1
            Case "Prev"
                pageNumE = Convert.ToInt32(lblCurrentPageE.Text) - 1
        End Select

        gvPagoErrores()

    End Sub

    Private Sub gvPagoErrores()
        Try
            Dim dtPagoErrores As DataTable = Empresas.SubsidiosSFS.Consultas.getPagoError(UsrRegistroPatronal, pageNumE, PageSizeE, txtCedula.Text)

            If dtPagoErrores.Rows.Count > 0 Then
                Me.lblTotalRegistrosE.Text = dtPagoErrores.Rows(0)("RECORDCOUNT")
                Me.gvPagosErrores.DataSource = dtPagoErrores
                Me.gvPagosErrores.DataBind()
                Me.pnlPagoErrores.Visible = True
                Me.lblMensajeError.Visible = False
            Else
                Me.pnlPagoErrores.Visible = False
                Me.lblMensajeError.Text = "No hay data para mostrar"
            End If
        Catch ex As Exception
            Me.lblMensajeError.Text = ex.Message
        End Try

        setNavigationE()

    End Sub
    Protected Sub UcExp_ExportaExcel3(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel3.ExportaExcel

        Dim dtPagoErrores As DataTable = Empresas.SubsidiosSFS.Consultas.getPagoError(UsrRegistroPatronal, pageNumE, PageSizeE, txtCedula.Text)
        dtPagoErrores.Columns.Remove("RECORDCOUNT")
        dtPagoErrores.Columns.Remove("NUM")
        'TODO: lambda to replace codes with descriptions for tipocuenta
        ucExportarExcel3.FileName = "Errores_" & Me.UsrRNC & ".xls"
        ucExportarExcel3.DataSource = dtPagoErrores

    End Sub

    Private Sub LimpiarError()
        PageSizeE = BasePage.PageSize
        lblMensajeError.Text = String.Empty
        pageNumE = 1
        gvPagoErrores()
    End Sub
    Protected Sub gvPagosErrores_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPagosErrores.RowDataBound

        If e.Row.RowIndex > -1 Then
            e.Row.Cells(3).Text = Utilitarios.Utils.ProperCase(e.Row.Cells(3).Text)
            Select Case e.Row.Cells(0).Text
                Case "1"
                    e.Row.Cells(0).Text = "Cuenta Corriente"
                Case "2"
                    e.Row.Cells(0).Text = "Cuenta de Ahorro"
                Case Else
                    e.Row.Cells(0).Text = String.Empty
            End Select
        End If
    End Sub
#End Region

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        LimpiarError()
        LimpiarCBanco()
        LimpiarNP()
    End Sub
    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        txtCedula.Text = String.Empty
        LimpiarError()
        LimpiarCBanco()
        LimpiarNP()
    End Sub
End Class
