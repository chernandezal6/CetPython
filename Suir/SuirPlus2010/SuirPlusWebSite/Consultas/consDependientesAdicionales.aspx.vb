
Imports System.Data
Imports SuirPlus
Imports SuirPlus.Empresas



Partial Class Consultas_ConsultaDependientesAdicionales
    Inherits BasePage


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



    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        'If Me.IsInPermiso("350") Then
        BindDependienteAdicional()
        'Else
        'tblinicial.Visible = False
        'lblError.Visible = True
        'lblError.Text = "No tiene permisos para ver esta consulta"
        'Exit Sub
        'End If
    End Sub

    Protected Sub BindDependienteAdicional()
        Dim dtdDependiente As New DataTable
        Try
            dtdDependiente = Empresas.Trabajador.getDependienteAdicional(UsrRegistroPatronal, Me.pageNum, Me.PageSize)

            If dtdDependiente.Rows.Count > 0 Then

                Me.lblTotalRegistros.Text = dtdDependiente.Rows(0)("RECORDCOUNT")
                Me.gvDependientes.DataSource = dtdDependiente
                Me.gvDependientes.DataBind()
                divDependientes.Visible = True
            Else
                lblError.Text = "No existen registros para esta búsqueda"
            End If

            setNavigation()
            dtdDependiente = Nothing
        Catch ex As Exception
            Throw ex
        End Try
    End Sub
    Protected Sub BindBuscarDependienteAdicional()
        Dim dtdBuscarDependiente As New DataTable
        Dim nombres As String = txtNombres.Text

        Try
            dtdBuscarDependiente = Empresas.Trabajador.BuscarDependienteAdicional (nombres, UsrRegistroPatronal, Me.pageNum , Me.PageSize)

            If dtdBuscarDependiente.Rows.Count > 0 Then

                Me.lblTotalRegistros.Text = dtdBuscarDependiente.Rows(0)("RECORDCOUNT")
                Me.gvDependientes.DataSource = dtdBuscarDependiente
                Me.gvDependientes.DataBind()
                divDependientes.Visible = True
            Else
                LblErrorBuscar.Text = "No existen registros para esta búsqueda"
                divDependientes.Visible = False

            End If

            setNavigation()
            dtdBuscarDependiente = Nothing
        Catch ex As Exception
            Throw ex
        End Try



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

        'Aqui ponemos el metodo que cargara la informacion'
        BindDependienteAdicional()
    End Sub
    Protected Sub ucExportarExcel1_ExportaExcel(sender As Object, e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel

        Dim dt = Empresas.Trabajador.getDependienteAdicional(UsrRegistroPatronal, 1, 9999)

        dt.Columns.RemoveAt(0)
        dt.Columns.RemoveAt(0)

        ucExportarExcel1.FileName = "Listado_de_Dependientes.xls"
        ucExportarExcel1.DataSource = dt
    End Sub

  
    Protected Sub btnBuscar_Click(sender As Object, e As System.EventArgs) Handles btnBuscar.Click
        BindBuscarDependienteAdicional()

    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("consDependientesAdicionales.aspx")
    End Sub
End Class
