Imports System.Data
Imports System.Globalization
Imports System.Threading
Imports SuirPlus
Imports SuirPlusEF
Partial Class Evaluacion_Visual_EvaVisualMaster
    Inherits BasePage
    Dim solicitud As Long = 0
    Dim tipo As Integer = 0

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

        If Not Page.IsPostBack Then
            CargarDatos()
            If (Request.QueryString.Get("IdTipo") IsNot Nothing) Then
                Dim tipoSol = Request.QueryString.Get("IdTipo")
                ddlTipoSol.SelectedValue = tipoSol.ToString()
                btBuscar_Click(Nothing, Nothing)
            End If
        End If
        pageNum = 1
        PageSize = BasePage.PageSize

    End Sub

    Private Sub CargarDatos()
        CargarDdlTipoSolicitud()
    End Sub

    Private Sub CargarDdlTipoSolicitud()
        Try
            Dim TipoSolicitud As New SuirPlusEF.Repositories.TipoSolicitudNSSRepository()
            ddlTipoSol.DataSource = TipoSolicitud.GetTipoSolicitud()
            ddlTipoSol.DataTextField = "Descripcion"
            ddlTipoSol.DataValueField = "IdTipo"
            ddlTipoSol.DataBind()
            ddlTipoSol.Items.Add(New ListItem("Seleccione", ""))
            ddlTipoSol.SelectedValue = ""
        Catch ex As Exception
            Throw ex.InnerException
        End Try
    End Sub

    Private Sub CargarEvaluaciones(ByVal solicitud As String, ByVal tipo As String)

        Dim solicitud1 As New Repositories.DetEvaluacionVisualRepository()
        Dim sol = solicitud1.GetNssEvaluacion(solicitud, tipo, pageNum, PageSize)

        If sol.Rows.Count > 0 Then
            gvEvaluaciones.DataSource = sol
            gvEvaluaciones.DataBind()
            gvEvaluaciones.Visible = True
            lblerror.Visible = False
            pnlNavegacion.Visible = True
            lblTotalRegistros.Text = sol.Rows(0)("RECORDCOUNT")
            lblTotalRegistros.Visible = True
            tipo = ""
        Else
            lblerror.Text = "No existen registros para evaluar"
            lblerror.Visible = True
            gvEvaluaciones.Visible = False
            pnlNavegacion.Visible = False
        End If
        sol = Nothing
        setNavigation()
    End Sub

    Protected Sub btBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btBuscar.Click

        Dim tipoSolicitud As New Repositories.TipoSolicitudNSSRepository()
        Dim tipoSol As String = String.Empty
        Dim sol As String = String.Empty

        If (txtSolicitud.Text.Trim()) > "9999999998" Then
            lblerror.Text = "Cantidad de caracgteres debe ser menor a 9999999999."
            lblerror.Visible = True
            gvEvaluaciones.Visible = False
            pnlNavegacion.Visible = False
            Return
        End If

        'If (txtSolicitud.Text.Trim()) = "" And ddlTipoSol.SelectedValue = "" Then
        '    lblerror.Text = "Debe elegir por lo menos un filtro de busqueda"
        '    lblerror.Visible = True
        '    gvEvaluaciones.Visible = False
        '    pnlNavegacion.Visible = False
        '    Return
        If (txtSolicitud.Text.Trim() <> "") And (ddlTipoSol.SelectedValue <> "") Then
            sol = (txtSolicitud.Text)
            tipoSol = (ddlTipoSol.SelectedValue)
        ElseIf (txtSolicitud.Text.Trim() = "") And (ddlTipoSol.SelectedValue <> "") Then
            tipoSol = (ddlTipoSol.SelectedValue)
        ElseIf (txtSolicitud.Text.Trim() <> "") And (ddlTipoSol.SelectedValue = "") Then
            sol = (txtSolicitud.Text)
        End If

        CargarEvaluaciones(sol, tipoSol)

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

        btBuscar_Click(Nothing, Nothing)

    End Sub
    Public Sub gvEvaluaciones_Command(sender As Object, e As GridViewCommandEventArgs) Handles gvEvaluaciones.RowCommand

        If e.CommandName = "E" Then
            Dim Sol() As String = e.CommandArgument.ToString.Split(",")
            ID = Sol(0)
            Dim TipoSol As String
            TipoSol = Sol(1)
            Response.Redirect("~/Asignacion_NSS/EvaVisualDetalle.aspx?Registro=" & ID)
        End If
    End Sub

    Private Sub btLimpiar_Click(sender As Object, e As EventArgs) Handles btLimpiar.Click
        txtSolicitud.Text = String.Empty
        ddlTipoSol.SelectedValue = ""
        gvEvaluaciones.Visible = False
        pnlNavegacion.Visible = False
        lblerror.Text = String.Empty
        lblerror.Visible = False
    End Sub
End Class
