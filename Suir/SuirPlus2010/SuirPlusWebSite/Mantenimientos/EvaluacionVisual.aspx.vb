Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios
Imports SuirPlus.Ars.Consultas
Partial Class Mantenimientos_EvaluacionVisual
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

    Protected Sub Page_Load1(sender As Object, e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Not IsNothing(Request.QueryString("CasoEvaluacion")) Then
                ddlCasosEvaluacion.SelectedValue = Request.QueryString("CasoEvaluacion")
            End If
            cargarDatos()
        End If
        Session("EvaluacionOrigen") = "Evaluacionvisual.aspx"
    End Sub

    Private Sub cargarDatos()
        'llenar el gridview
        Dim dt As New DataTable

        dt = Ars.Consultas.GetEvaluarDataActa(ddlCasosEvaluacion.SelectedValue, pageNum, PageSize)

        If dt.Rows.Count > 0 Then
            Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
            Me.gvListado.DataSource = dt
            Me.gvListado.DataBind()
            Me.pnlNavegacion.Visible = True
            Me.lbl_error.Visible = False
        Else
            Me.pnlNavegacion.Visible = False
            Me.gvListado.DataSource = Nothing
            Me.gvListado.DataBind()
            Me.lbl_error.Visible = True
            Me.lbl_error.Text = "No existen casos de evaluación disponibles."
        End If

        dt = Nothing
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
        cargarDatos()

    End Sub

    Protected Sub gvListado_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvListado.RowCommand
        Dim id As String = String.Empty
        If e.CommandName = "A" Then
            id = e.CommandArgument.ToString()
            Response.Redirect("~/Mantenimientos/AsignacionNSS.aspx?id_solicitud=" & id & "&CasoEvaluacion=" & ddlCasosEvaluacion.SelectedValue.ToString())
        ElseIf e.CommandName = "E" Then
            id = e.CommandArgument.ToString()
            Response.Redirect("~/Mantenimientos/mEvaluacionVisualActa.aspx?IdRow=" & HttpUtility.UrlEncode(id) & "&CasoEvaluacion=" & ddlCasosEvaluacion.SelectedValue.ToString())
        ElseIf e.CommandName = "F" Then
            id = e.CommandArgument.ToString()
            Response.Redirect("~/Mantenimientos/mEvaluarFallecido.aspx?IdRow=" & id & "&CasoEvaluacion=" & ddlCasosEvaluacion.SelectedValue.ToString())
        ElseIf e.CommandName = "N" Then
            id = e.CommandArgument.ToString()
            MenorACedulado = id
            Response.Redirect("~/Mantenimientos/MenorAMayorCedulado.aspx?IdRow=" & id & "&CasoEvaluacion=" & ddlCasosEvaluacion.SelectedValue.ToString())
        ElseIf e.CommandName = "P" Then
            id = e.CommandArgument.ToString()
            Response.Redirect("~/Mantenimientos/EvaluarPasaportes.aspx?id_solicitud=" & id & "&CasoEvaluacion=" & ddlCasosEvaluacion.SelectedValue.ToString())
        End If

    End Sub

    Protected Sub gvListado_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvListado.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim id As String = CType(e.Row.Cells(7).FindControl("lblId"), Label).Text
            If id = "1" Then
                CType(e.Row.Cells(7).FindControl("ibAsignarNss"), ImageButton).Visible = True
            ElseIf id = "2" Then
                CType(e.Row.Cells(7).FindControl("ibEvaluarCiudadanos"), ImageButton).Visible = True
            ElseIf id = "4" Then
                CType(e.Row.Cells(7).FindControl("ibEvaluarMayoriaEdad"), ImageButton).Visible = True
            ElseIf id = "3" Then
                CType(e.Row.Cells(7).FindControl("ibEvaluarFallecido"), ImageButton).Visible = True
            ElseIf id = "5" Then
                CType(e.Row.Cells(7).FindControl("ibEvaluarPasaporte"), ImageButton).Visible = True
                'Else

            End If
        End If
    End Sub

    Protected Sub ddlCasosEvaluacion_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlCasosEvaluacion.SelectedIndexChanged
        pageNum = 1
        PageSize = BasePage.PageSize
        cargarDatos()
    End Sub

End Class
