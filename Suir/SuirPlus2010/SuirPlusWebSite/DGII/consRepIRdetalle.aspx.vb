Imports SuirPlus.Utilitarios
Imports System.Data

Partial Class DGII_consRepIRdetalle
    Inherits BasePage
    Protected anoFiscal As Integer = Utils.getPeriodoIR13
    ' Protected dt As DataTable
    Protected per As Integer
    ' Dim ano As Integer

#Region "Miembros y Propiedades"

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

#End Region

    Private Sub cargarPeriodos()

        Dim dt As New Data.DataTable

        dt = New SuirPlus.Empresas.Facturacion.ResumenDeclaracionIR13(anoFiscal, Me.UsrRNC).getPeriodos()
        If dt.Rows.Count > 0 Then
            Me.drpPeriodo.DataSource = dt
            Me.drpPeriodo.DataTextField = "periodo"
            Me.drpPeriodo.DataBind()
            Me.drpPeriodo.Enabled = True
            Me.btnConsultar.Enabled = True
        Else
            Me.drpPeriodo.Enabled = False
            Me.btnConsultar.Enabled = False
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = "No existen períodos disponibles"
        End If

    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click

        'Me.UcExcel.Visible = True
        ' Me.pageNum = 1
        CargaInicial()
    End Sub

    Private Sub CargaInicial()

        per = Me.drpPeriodo.SelectedItem.Text
        Dim dtCarga As New DataTable


        'anoFiscal = 2005
        Try
            dtCarga = New SuirPlus.Empresas.Facturacion.ResumenDeclaracionIR13(anoFiscal, Me.UsrRNC).getPageDetallePorPeriodoIR13(per, Me.pageNum, Me.PageSize)
            If dtCarga.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dtCarga.Rows(0)("RECORDCOUNT")
                Me.gvResumenIR13.DataSource = dtCarga
                Me.gvResumenIR13.DataBind()
                Me.pnlMostrar.Visible = True

            Else
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existen registros para este período"

                Me.gvResumenIR13.DataSource = Nothing
                Me.gvResumenIR13.DataBind()
                Me.pnlMostrar.Visible = False

            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

        setNavigation()
        dtCarga = Nothing
    End Sub

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
        Else
            PageSize = 15
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

        Me.CargaInicial()


    End Sub

    Private Sub On_ExportaExcel(ByVal sender As Object, ByVal e As EventArgs) Handles ucExcel.ExportaExcel
        per = Me.drpPeriodo.SelectedItem.Text
        UcExcel.FileName = "Detalle IR-4 Período " & per
        ucExcel.DataSource = New SuirPlus.Empresas.Facturacion.ResumenDeclaracionIR13(anoFiscal, Me.UsrRNC).getDetallePorPeriodoIR13(per)

    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        If Not Page.IsPostBack Then
            cargarPeriodos()
            ' Dim anoFiscal As Integer = Utils.getPeriodoIR13
        End If
    End Sub
End Class
