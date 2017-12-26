Imports System.Data
Imports SuirPlus
Imports SuirPlus.Empresas
'Imports DateTime



Partial Class Certificaciones_ReporteCertificaciones
    Inherits BasePage

    Protected Property pageNum() As Integer
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

    Protected Property PageSize() As Int16
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

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Me.pageNum = 1
        Me.PageSize = BasePage.PageSize
        divCertificaciones.Visible = False

        If Not Page.IsPostBack Then
            txtFechaDesde.Text = DateTime.Now.ToString("dd/MM/yyyy")
            txtFechaHasta.Text = DateTime.Now.ToString("dd/MM/yyyy")
        End If
    End Sub

    Protected Sub BindCertificaciones()

        Dim dtcertificaciones As New DataTable
        Try
            dtcertificaciones = Empresas.Certificaciones.getTotalCert(txtFechaDesde.Text, txtFechaHasta.Text, Me.UsrUserName, Me.UsrRNC, Me.pageNum, Me.PageSize)

           
            If dtcertificaciones.Rows.Count > 0 Then
               
                Me.lblTotalRegistros.Text = dtcertificaciones.Rows(0)("RECORDCOUNT")
                Me.gvReporteCertificaciones.DataSource = dtcertificaciones
                Me.gvReporteCertificaciones.DataBind()
                divCertificaciones.Visible = True

            Else
                LblError.Visible = True
                LblError.Text = "No existen registros para esta busqueda"
            End If
            dtcertificaciones = Nothing
            setNavigation()

        Catch ex As Exception
            Me.LblError.Visible = True
            Me.LblError.Text = ex.Message
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
        BindCertificaciones()
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        If (txtFechaDesde.Text) = "" Or txtFechaHasta.Text = "" Then
            LblError.Visible = True
            LblError.Text = "Debe llenar ambas fechas"
        ElseIf Date.TryParse(txtFechaDesde.Text, Convert.ToDateTime(Me.UsrFechaLogin)) = False Or Date.TryParse(txtFechaHasta.Text, Convert.ToDateTime(Me.UsrFechaLogin)) = False Then
            LblError.Visible = True
            LblError.Text = "Fechas inválidas"
        Else
            BindCertificaciones()
        End If

    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        txtFechaDesde.Text = ""
        txtFechaHasta.Text = ""
        Response.Redirect("ReporteCertificaciones.aspx")
    End Sub

    Public Function formateaSalario(ByVal salario As String) As String
        Dim salFormatear As Double
        Dim res As String

        If Not IsNumeric(salario) Then
            Return salario
        Else
            salFormatear = CDbl(salario)
            res = String.Format("{0:c}", salFormatear)
            Return res
        End If



    End Function

End Class
