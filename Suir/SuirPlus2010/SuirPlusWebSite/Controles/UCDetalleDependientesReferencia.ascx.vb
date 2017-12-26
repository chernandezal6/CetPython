Imports System
Imports System.Data

Partial Class Controles_UCDetalleDependientesReferencia
    Inherits System.Web.UI.UserControl

#Region "Miembros y Propiedades"

    Private mLastColumn As String = String.Empty
    Private myIdReferencia As String

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

    Public WriteOnly Property IdReferencia() As String
        Set(ByVal Value As String)
            myIdReferencia = Value
        End Set
    End Property

#End Region

    Public Overrides Sub DataBind()

        bindGrid()
    End Sub

    Protected Sub bindGrid()

        Dim dtDependientes As DataTable = Nothing

        Dim criterio As String = Me.txtCriterio.Text.Trim
        Dim tipoCriterio As String = Me.ddlBusqueda.SelectedValue

        Try
            Dim notificacion As New SuirPlus.Empresas.Facturacion.FacturaSS(Me.myIdReferencia)

            Me.lblEmpleador.Text = notificacion.RazonSocial
            Me.lblNomina.Text = notificacion.Nomina
            Me.lblReferencia.Text = notificacion.NroReferenciaFormateado

            SuirPlus.Operaciones.RegistroLogAuditoria.CrearRegistro(notificacion.RegistroPatronal, HttpContext.Current.Session("UsrUserName"), HttpContext.Current.Session("UsrUserName"), 4, Request.UserHostAddress, Request.UserHostName, Me.myIdReferencia, Request.ServerVariables("LOCAL_ADDR"))

            dtDependientes = SuirPlus.Empresas.Trabajador.getDependientes(Me.myIdReferencia, tipoCriterio, criterio, Me.pageNum, Me.PageSize)

            If dtDependientes.Rows.Count > 0 Then
                Me.pnlNomina.Visible = True

                Me.lblTotalRegistros.Text = dtDependientes.Rows(0)("RECORDCOUNT")
                Me.gvDetalleDependiente.DataSource = dtDependientes
                Me.gvDetalleDependiente.DataBind()
            Else
                Me.pnlNomina.Visible = True
                Me.lblTotalRegistros.Text = "0"
                Me.gvDetalleDependiente.DataSource = Nothing
                Me.gvDetalleDependiente.DataBind()
                Me.tblDependientes.Visible = False
                Me.lblMensaje.Text = "Esta Referencia no tiene Dependientes Adicionales."
            End If
        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
        End Try

        dtDependientes = Nothing
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

        bindGrid()

    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        Me.pageNum = 1
        Me.PageSize = BasePage.PageSize
        bindGrid()

    End Sub

    Protected Sub ucExportarExcel1_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel
        Dim dtTSS As DataTable

        dtTSS = SuirPlus.Empresas.Trabajador.getDependientes(Me.myIdReferencia)

        If dtTSS.Rows.Count > 0 Then
            Me.ucExportarExcel1.FileName = "DependientesAdicionales.xls"
            Me.ucExportarExcel1.DataSource = dtTSS
        End If
    End Sub
End Class
