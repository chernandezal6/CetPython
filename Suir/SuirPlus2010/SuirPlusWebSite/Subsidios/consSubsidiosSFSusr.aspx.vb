Imports System.Data
Imports SuirPlus.Empresas
Partial Class Subsidios_consSubsidiosSFSusr
    Inherits BasePage

    Private flagBack As Boolean
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

    Protected Sub Subsidios_consSubsidiosSFS_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            CargarEstatusSubsidios()

            If Not IsNothing(Session("flagBack")) Then
                flagBack = Convert.ToBoolean(Session("flagBack"))
            Else
                Session("flagBack") = False
            End If

            If flagBack Then
                GetSearchCriteria()
                CargarSubsidiosSFS()
                Session("flagBack") = False
            End If
        End If
        pageNum = 1
        PageSize = BasePage.PageSize

    End Sub
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        Session("flagBack") = False
        CargarSubsidiosSFS()
    End Sub
    Protected Sub CargarEstatusSubsidios()
        Dim dtEstatus = SubsidiosSFS.Consultas.getStatusSubsidiosSFS()
        'Cargando el dropdownlist de status
        ddlEstatusSubsidios.DataSource = dtEstatus
        ddlEstatusSubsidios.DataTextField = "descripcion"
        ddlEstatusSubsidios.DataValueField = "Id"
        ddlEstatusSubsidios.DataBind()
        ddlEstatusSubsidios.Items.Insert(0, New ListItem("<--Todos-->", ""))
    End Sub

    Protected Sub CargarSubsidiosSFS()
        Try
            If txtrncCedula.Text = String.Empty Then
                Me.pnlSubsidiosSFS.Visible = False
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "El RNC es requerido"
                Exit Sub
            End If
            SetSearchCriteria()

            Dim dtSubsidiosSFS As New DataTable
            dtSubsidiosSFS = SubsidiosSFS.Consultas.getSubsidiosSFS(txtrncCedula.Text, txtCedula.Text, ddlEstatusSubsidios.SelectedValue, ddlTipoSubsidio.SelectedValue, Me.txtFechaDesde.Text, Me.txtFechaHasta.Text, Me.pageNum, Me.PageSize)

            If dtSubsidiosSFS.Rows.Count > 0 Then
                Me.pnlSubsidiosSFS.Visible = True
                Me.lblTotalRegistros.Text = dtSubsidiosSFS.Rows(0)("RECORDCOUNT")
                Me.gvSubsidiosSFS.DataSource = dtSubsidiosSFS
                Me.gvSubsidiosSFS.DataBind()
            Else
                Me.pnlSubsidiosSFS.Visible = False
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "No hay data para mostrar"

            End If
            setNavigation()
            dtSubsidiosSFS = Nothing

            SetSearchCriteria()
        Catch ex As Exception
            Me.pnlSubsidiosSFS.Visible = False
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message

        End Try
    End Sub

    Private Sub SetSearchCriteria()
        Session("txtrncCedula") = txtrncCedula.Text
        Session("txtCedula") = txtCedula.Text
        Session("ddlEstatusSubsidios") = ddlEstatusSubsidios.SelectedValue
        Session("ddlTipoSubsidio") = ddlTipoSubsidio.SelectedValue
        Session("txtFechaDesde") = txtFechaDesde.Text
        Session("txtFechaHasta") = txtFechaHasta.Text
        Session("pageNum") = pageNum

    End Sub

    Private Sub GetSearchCriteria()
        txtrncCedula.Text = Session("txtrncCedula").ToString()
        txtCedula.Text = Session("txtCedula").ToString()
        ddlEstatusSubsidios.SelectedValue = Session("ddlEstatusSubsidios").ToString()
        ddlTipoSubsidio.SelectedValue = Session("ddlTipoSubsidio").ToString()
        txtFechaDesde.Text = Session("txtFechaDesde").ToString()
        txtFechaHasta.Text = Session("txtFechaHasta").ToString()
        pageNum = Int16.Parse(Session("pageNum"))

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

        CargarSubsidiosSFS()

    End Sub

    Protected Sub gvSubsidiosSFS_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvSubsidiosSFS.RowCommand
        Dim idSol As String = Split(e.CommandArgument, "|")(0)
        Dim tipo As String = Split(e.CommandArgument, "|")(1)

        Try
            If e.CommandName = "VerDetalle" Then
                'Activar carga de criterios de busqueda desde las
                'variables de sesion
                Session("flagBack") = True
                Response.Redirect("DetSubsidiosSFS.aspx?IdSolicitud=" & idSol & "&Tipo=" & tipo & "&rnc=" & Session("txtrncCedula"))

            End If
        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
        End Try

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("consSubsidiosSFSusr.aspx")
    End Sub

    Protected Sub gvSubsidiosSFS_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSubsidiosSFS.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            '  Dim RechazoDefinitivo As String = CType(e.Row.FindControl("lbldefinitivo"), Label).Text
            Dim TieneImagen As String = CType(e.Row.FindControl("lblTieneImagen"), Label).Text
            'Dim EstatusDesc As String = CType(e.Row.FindControl("lblEstatus"), Label).Text

            ' ''se valida el estatus del subsidio en curso para determinar si se habilita el link para la reconsideración. 
            ' ''si esta rechazado, se valida si este rechazo es definitivo, si es definitvo no se mostrará el link.

            ' ''temporalmente se pondra visible=false al templateField del linkbutton de reconsideracion al mismo tiempo que se comentan las lineas de codigo corresponientes
            ' ''cuando se decida que se puede recosiderar nuevamente, solo hay que deshacer lo anteriormente descrito.
            'If EstatusDesc <> "Rechazado" Then
            '    e.Row.Cells(10).Text = String.Empty
            'Else
            '    If RechazoDefinitivo = "S" Then
            '        e.Row.Cells(10).Text = String.Empty
            '    End If
            'End If
            If TieneImagen = "" Then
                e.Row.Cells(9).Text = String.Empty
            End If
        End If
    End Sub
End Class

