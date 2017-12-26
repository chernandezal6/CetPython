Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios.Utils


Partial Class Consultas_consReportedePagosdeSubsidiosdelSFS
    Inherits BasePage

    Dim FechaDesde As String
    Dim FechaHasta As String

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

        pageNum = 1
        PageSize = BasePage.PageSize
    End Sub

    Protected Sub BindPagosSubsidiosSFs()
        Dim dtPagosSubsidiosSfs As New DataTable

       

        Try
            dtPagosSubsidiosSfs = Empresas.SubsidiosSFS.Consultas.GetPagosSubsidiosSFS(UsrRegistroPatronal, Session("txtCedula"), Session("ddlTipoSubsidio"), Session("txtFechaDesde"), Session("txtFechaHasta"), Session("txtFechaDesdePago"), Session("txtFechaHastaPago"), Me.pageNum, Me.PageSize)

            If dtPagosSubsidiosSfs.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dtPagosSubsidiosSfs.Rows(0)("RECORDCOUNT")
                Me.gvPagosSubsidios.DataSource = dtPagosSubsidiosSfs
                Me.gvPagosSubsidios.DataBind()
                divPagos.Visible = True

            Else
                pnlPagosSubsidiosSFS.Visible = False
                lblError.Visible = True
                lblError.Text = "No existen registros para esta búsqueda"

            End If
            setNavigation()
           
        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message

        End Try


    End Sub
    Private Sub SetSearchCriteria()

        Session("txtCedula") = txtCedula.Text
        Session("ddlTipoSubsidio") = ddlTipoSubsidio.SelectedValue
        Session("txtFechaDesde") = txtFechaDesde.Text
        Session("txtFechaHasta") = txtFechaHasta.Text
        Session("txtFechaDesdePago") = txtFechaDesdePago.Text
        Session("txtFechaHastaPago") = txtFechaHastaPago.Text
        
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
        BindPagosSubsidiosSFs()
    End Sub

    'Funcion para formatear el nro de la referencia'
    Protected Function formateaReferencia(ByVal nroReferencia As Object) As String
        If Not IsDBNull(nroReferencia) Then
            Return Utilitarios.Utils.FormateaReferencia(nroReferencia)
        Else
            Return String.Empty
        End If
    End Function

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
    Protected Sub ucExportarExcel1_ExportaExcel(sender As Object, e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel

        Dim dt = Empresas.SubsidiosSFS.Consultas.GetPagosSubsidiosSFS(UsrRegistroPatronal, txtCedula.Text, ddlTipoSubsidio.SelectedValue.ToString, txtFechaDesde.Text, txtFechaHasta.Text, txtFechaDesdePago.Text, txtFechaHastaPago.Text, 1, 9999)

        dt.Columns.RemoveAt(0)
        dt.Columns.RemoveAt(0)
        dt.Columns.RemoveAt(0)
        dt.Columns.RemoveAt(0)
        
        ucExportarExcel1.FileName = "Reporte de pagos de subsidios del SFS.xls"
        ucExportarExcel1.DataSource = dt
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As System.EventArgs) Handles btnBuscar.Click
        pnlPagosSubsidiosSFS.Visible = True
        Me.SetSearchCriteria()
        BindPagosSubsidiosSFs()
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("consReportedePagosdeSubsidiosdelSFS.aspx")
    End Sub
End Class




