Imports SuirPlus
Imports System.Data

Partial Class ManejodeCartera
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

    Public Property ID_Cartera() As Integer
        Get
            Return ViewState("IDCartera")
        End Get
        Set(ByVal value As Integer)
            ViewState("IDCartera") = value
        End Set
    End Property

#Region "Paginación"

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

    Protected Sub NavigationLink_Click(ByVal s As Object, ByVal e As CommandEventArgs) Handles btnLnkFirstPage.Command, btnLnkPreviousPage.Command

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

        LoadData()

    End Sub

#End Region


    Protected Sub LoadData()
        Dim dt As New DataTable
        Dim NoEnvio As String = String.Empty
        Me.lblNoCartera.Text = Me.ID_Cartera

        Try

            dt = Legal.Cobro.getEmpresasAsignadas(Me.ID_Cartera, Me.txtRnc.Text, txtRazonSocial.Text, Me.ddlNoSeguimientos.SelectedValue, Me.pageNum, Me.PageSize)
            If dt.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
                Me.gvEmpresas.DataSource = dt
                Me.gvEmpresas.DataBind()
                Me.pnlNavigation.Visible = True
                setNavigation()
            Else
                Me.gvEmpresas.DataSource = dt
                Me.gvEmpresas.DataBind()
                Me.pnlNavigation.Visible = False
            End If
        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message

        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Not IsNothing(Request.QueryString("ID")) Then
                Me.ID_Cartera = Request.QueryString("ID")
                Me.pageNum = 1
                Me.PageSize = BasePage.PageSize
                Me.LoadData()
                Me.bindCRMDataList()
            End If
        End If
    End Sub

    Protected Function formateaRNC(ByVal rnc As String) As String

        If rnc = String.Empty Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormatearRNCCedula(rnc)
        End If

    End Function

    Protected Sub gvEmpresas_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvEmpresas.RowCommand
        If e.CommandName = "Trabajar" Then
            Dim vec() As String = e.CommandArgument.ToString.Split("|")

            Dim RNC As String = vec(0)
            Dim IDCartera As Integer = vec(1)
            Dim Num As Integer = vec(2)
            Dim Tot As Integer = vec(3)


            Response.Redirect("ManejoEmpleador.aspx?ID=" & IDCartera & "&IR=" & RNC & "&NO=" & Num & "&TO=" & Tot)

        End If
    End Sub

    Protected Sub bindCRMDataList()
        'Cargamos los ultimos registros
        Me.dlUltimosRegistros.DataSource = Legal.Cobro.getNotificacionesPendientes(Me.UsrUserName, Now.ToShortDateString(), Me.ID_Cartera)
        Me.dlUltimosRegistros.DataBind()
    End Sub

    Protected Sub btnFiltrar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFiltrar.Click
        LoadData()
    End Sub

  
    Protected Sub gvEmpresas_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvEmpresas.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim lblacuerdo As Label = CType(e.Row.FindControl("lblAcuerdo"), Label)
            Dim valor As String = lblacuerdo.Text
            If valor = "0" Then
                lblacuerdo.Text = "NO"
            Else
                lblacuerdo.Text = "SI"
            End If
        End If
    End Sub
End Class
