Imports SuirPlus
Imports System
Imports System.Data
Partial Class Consultas_consSubCuentasPorPagar
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

        Me.CargarDatosCxP()

    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        Try
            
            If Not (txtDesde.Text = String.Empty) Or Not (txtHasta.Text = String.Empty) Or Not (Me.DropDownList1.SelectedValue = "") Or Not (Me.txtCedulaMadre.Text = String.Empty) Or Not (Me.txtRNC.Text = String.Empty) Then
                Me.CargarDatosCxP()
            Else
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "Debe especificar al menos un de los Campos."
                Me.pnlgvSubsidio.Visible = False
            End If
        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
        End Try

    End Sub

    Protected Sub CargarDatosCxP()

        Try
            Dim dtCxp As New DataTable
            dtCxp = Empresas.SubsidiosSFS.Consultas.getCuentasPorPagar(Me.txtDesde.Text, Me.txtHasta.Text, Me.txtRNC.Text, Me.txtCedulaMadre.Text, Me.DropDownList1.SelectedValue, Me.pageNum, Me.PageSize)

            If dtCxp.Rows.Count > 0 Then
                Me.pnlgvSubsidio.Visible = True
                Me.lblTotalRegistros.Text = dtCxp.Rows(0)("RECORDCOUNT")
                Me.gvDataCxC.DataSource = dtCxp
                Me.gvDataCxC.DataBind()
            Else
                Me.pnlgvSubsidio.Visible = False
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "No hay data para mostrar"
            End If
            setNavigation()
            dtCxp = Nothing
        Catch ex As Exception

            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message

        End Try
    End Sub

    Protected Function formateaCedula(ByVal rnc As Object) As String

        If Not IsDBNull(rnc) Then
            If rnc = String.Empty Then
                Return String.Empty
            Else
                Return Utilitarios.Utils.FormatearRNCCedula(rnc)
            End If
        Else
            Return String.Empty
        End If

    End Function

    Protected Function VerificaRNCoCedula(ByVal rnc As Object) As String
        If rnc.Equals(System.DBNull.Value) Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormatearRNCCedula(rnc)
        End If
    End Function

    Protected Function formateaRNC(ByVal rnc As Object) As String

        If Not IsDBNull(rnc) Then
            If rnc = String.Empty Then
                Return String.Empty
            Else
                Return Utilitarios.Utils.FormatearRNCCedula(rnc)
            End If
        Else
            Return String.Empty
        End If


    End Function

    Protected Function formateaPeriodo(ByVal Periodo As Object) As String
        If Not IsDBNull(Periodo) Then
            Return Utilitarios.Utils.FormateaPeriodo(Periodo)
        Else
            Return String.Empty
        End If
    End Function

    Protected Sub ucExportarExcel1_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel
        Dim Mexcel As New DataTable
        Mexcel = Empresas.SubsidiosSFS.Consultas.getCuentasPorPagar(Me.txtDesde.Text, Me.txtHasta.Text, Me.txtRNC.Text, Me.txtCedulaMadre.Text, Me.DropDownList1.SelectedValue, 1, Me.lblTotalRegistros.Text)
        ucExportarExcel1.FileName = "Datos generales de Cuentas por Pagar.xls"
        ucExportarExcel1.DataSource = Mexcel
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

    End Sub

    Protected Sub Button2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button2.Click
        Me.txtRNC.Text = String.Empty
        Me.txtCedulaMadre.Text = String.Empty
        Me.DropDownList1.SelectedValue = ""
        Me.txtDesde.Text = String.Empty
        Me.txtHasta.Text = String.Empty
        Me.pnlgvSubsidio.Visible = False
    End Sub

End Class
