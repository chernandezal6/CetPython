Imports System.Data
Imports SuirPlus.Utilitarios
Partial Class DGII_DetalleIR13
    Inherits BasePage

    Protected dtResumenIR13 As New DataTable
    'Private TieneSaldo As Boolean
    Protected custView As New DataView
    Protected strFiltro As String
    Protected paginaActual As Integer = 1
    Protected paginaTam As Integer
    Protected Status As String = String.Empty


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

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Status = Session("Status")
        Me.lblStatus.Text = Status


        If Not Page.IsPostBack Then

            CargarDetalle()
            'Utilizado para desactivar el boton de realizar declaracion
            'si el Saldo a Favor de la DGII es mayor que 0
            'Me.lblSaldoFavorDGII.Visible = False

            If Session("TieneSaldo") = True Then
                Me.lblSaldoFavorDGII.Visible = True
                Me.btDeclarar.Enabled = False
            End If

        End If
    End Sub

    Private Sub CargarDetalle()

        'Confirmamos si el estatus actual del archivo en cuestion es Procesado para bloquear automaticamente el boton para declarar

        If Status = "Procesado" Then
            Me.btDeclarar.Enabled = False
        Else
            Me.btDeclarar.Enabled = True
        End If

        If (Session("IR13Pendientes") = 1) Or (Session("IR13Nulos") = 1) Then
            Me.btDeclarar.Enabled = False
        End If


        If Not Page.IsPostBack Then
            BindIR13()
        Else
            Me.dtResumenIR13 = Session("dtIR13")
        End If


    End Sub

    Private Sub BindIR13()

        Try

            dtResumenIR13 = New SuirPlus.Empresas.Facturacion.ResumenDeclaracionIR13(Utils.getPeriodoIR13, Me.UsrRNC).PageDetalleIR13(Me.pageNum, Me.PageSize)

            If dtResumenIR13.Rows.Count > 0 Then
                Session("dtIR13") = dtResumenIR13
                Me.lblTotalRegistros.Text = dtResumenIR13.Rows(0)("RECORDCOUNT")
                Me.gvResumenIR13.Dispose()
                Me.gvResumenIR13.DataSource = dtResumenIR13
                Me.gvResumenIR13.DataBind()
                Me.gvResumenIR13.Visible = True
                Me.pnlIR13.Visible = True

            Else
                Me.pnlIR13.Visible = False
                Me.btDeclarar.Enabled = False
            End If

        Catch ex As Exception
            Response.Write(ex.ToString())
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

        setNavigation()
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

        BindIR13()

    End Sub

    Private Sub On_ExportaExcel(ByVal sender As Object, ByVal e As EventArgs) Handles ucExcel.ExportaExcel

        Dim dtResumenIR13Excel As New DataTable
        dtResumenIR13Excel = New SuirPlus.Empresas.Facturacion.ResumenDeclaracionIR13(Utils.getPeriodoIR13, Me.UsrRNC).getResumenIR13()
        ucExcel.FileName = "Detalle IR-4"
        ucExcel.DataSource = dtResumenIR13Excel
    End Sub

    Private Sub btDeclarar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btDeclarar.Click

        Response.Redirect("consRepIRDeclarar.aspx")

    End Sub


    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVolver.Click
        Response.Redirect("consRepIR.aspx")
    End Sub
End Class
