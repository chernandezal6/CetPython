Imports SuirPlus
Imports System.Data
Imports SuirPlus.Utilitarios
Imports SuirPlus.Empresas.SubsidiosSFS
Imports SuirPlus.Utilitarios.Utils

Partial Class Novedades_sfsConsSubsidiados
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

        Buscar()

    End Sub


    Private Sub Buscar()
        Dim dt As DataTable

        dt = EnfermedadComun.GetSubsidiadoEmpresa(Me.UsrRegistroPatronal, Me.pageNum, Me.PageSize, Me.txtCedula.Text)
        gvSubsidios.DataSource = dt
        gvSubsidios.DataBind()

        If gvSubsidios.Rows.Count > 0 Then
            divConsulta.Visible = True
            Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
            setNavigation()
        Else
            divConsulta.Visible = False
            lblMsg.Text = "No existen registros para estos criterios de búsqueda"
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Buscar()
        End If
    End Sub

    Protected Sub gvSubsidios_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSubsidios.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then

            CType(e.Row.FindControl("lblNombre"), Label).Text = ProperCase(CType(e.Row.FindControl("lblNombre"), Label).Text)
            CType(e.Row.FindControl("lblCedula"), Label).Text = FormatearCedula(CType(e.Row.FindControl("lblCedula"), Label).Text)

            Dim NroSolicitud As String = CType(e.Row.FindControl("lblNoSolicitud"), Label).Text
            Dim Cedula As String = CType(e.Row.FindControl("lblCedula"), Label).Text
            Dim Nombre As String = CType(e.Row.FindControl("lblNombre"), Label).Text
            Dim FechaRegistro As String = CType(e.Row.FindControl("lblFechaRegistro"), Label).Text
            Dim FechaRespuesta As String = CType(e.Row.FindControl("lblFechaRespuesta"), Label).Text
            Dim Pin As String = CType(e.Row.FindControl("lblPin"), Label).Text
            Dim Status As String = CType(e.Row.FindControl("lblStatus"), Label).Text
           
            Dim hl As System.Web.UI.WebControls.HyperLink = CType(e.Row.FindControl("lnkDetalle"), HyperLink)
            hl.NavigateUrl = "javascript:modelesswin('sfsDetalleSubsidiado.aspx?Nro=" & NroSolicitud & "&Ced=" & Cedula & "&Nom=" & Nombre & "&Fre=" & FechaRegistro & "&Frp=" & FechaRespuesta & "&Pin=" & Pin & "&Sta=" & Status & "')"
        End If
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.txtCedula.Text = String.Empty
        Me.PageSize = BasePage.PageSize
        Me.pageNum = 1
        Buscar()
    End Sub

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Me.pageNum = 1
        Buscar()
    End Sub

End Class
