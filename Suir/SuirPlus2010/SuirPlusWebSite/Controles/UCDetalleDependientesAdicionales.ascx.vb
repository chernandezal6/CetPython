Imports System
Imports System.Data

Partial Class Controles_UCDetalleDependientesAdicionales
    Inherits System.Web.UI.UserControl

#Region "Miembros y Propiedades"

    Private myIdRegistroPatronal As Integer
    Private myIdNomina As Integer
    Private mLastColumn As String = String.Empty


    Public WriteOnly Property RegistroPatronal() As Integer
        Set(ByVal Value As Integer)
            myIdRegistroPatronal = Value
        End Set
    End Property

    Public WriteOnly Property IdNomina() As Integer
        Set(ByVal Value As Integer)
            myIdNomina = Value
        End Set
    End Property

    Public WriteOnly Property ShowNomina() As Boolean
        Set(ByVal Value As Boolean)
            pnlNomina.Visible = Value
        End Set
    End Property

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
    Dim LastColumn As String

    Public Overrides Sub DataBind()
        bindGrid()
    End Sub

    Protected Sub bindGrid()

        Dim dtDependientes As DataTable = Nothing

        Dim criterio As String = Me.txtCriterio.Text.Trim
        Dim tipoCriterio As String = Me.ddlBusqueda.SelectedValue

        Dim criterioDefault As String = "TODOS"

        If Me.txtCriterio.Text.ToUpper = criterioDefault Then
            criterio = String.Empty
        End If

        Try
            dtDependientes = SuirPlus.Empresas.Trabajador.getDependientes(Me.myIdRegistroPatronal, Me.myIdNomina, tipoCriterio, criterio, Me.pageNum, Me.PageSize)

            If dtDependientes.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dtDependientes.Rows(0)("RECORDCOUNT")
                Me.gvDetalleDependiente.DataSource = dtDependientes
                Me.gvDetalleDependiente.DataBind()
                Me.pnlDetalle.Visible = True

            Else
                Me.pnlDetalle.Visible = False
                'Me.tblDetalle.Visible = False
                Me.lblMensaje.Text = "No existen registros bajo este criterio " & """" & criterio & """" & ", la busqueda debe ser por apellidos o por cédulas."
                Me.txtCriterio.Text = criterioDefault
            End If
            setNavigation()

        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
        End Try

        dtDependientes = Nothing

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

        bindGrid()

    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        Me.pageNum = 1
        Me.PageSize = BasePage.PageSize
        bindGrid()

    End Sub

    Protected Sub gvDetalleDependiente_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDetalleDependiente.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then

            Dim CurrentColumn As String = e.Row.Cells(0).Text

            If CurrentColumn = LastColumn Then

                e.Row.Cells(0).Text = String.Empty
                e.Row.Cells(1).Text = String.Empty

            End If

            LastColumn = CurrentColumn

        End If

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        LastColumn = String.Empty
    End Sub


    Protected Sub ucExportarExcel1_ExportaExcel(sender As Object, e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel

        ucExportarExcel1.FileName = "Detalle_dependientes_adicionales.xls"
        ucExportarExcel1.DataSource = SuirPlus.Empresas.Trabajador.getDependientes(Me.myIdRegistroPatronal, Me.myIdNomina)

    End Sub
End Class
