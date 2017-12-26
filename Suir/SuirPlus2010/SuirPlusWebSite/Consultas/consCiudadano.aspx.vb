Imports System.Data
Imports SuirPlus

Partial Class Consultas_consCiudadano
    Inherits BasePage
    Dim qsNoDocumento As String = String.Empty
    Dim qsNSS As String = String.Empty
    Dim dt As New DataTable

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

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not (String.IsNullOrEmpty(Request.QueryString("NSS"))) Or Not (String.IsNullOrEmpty(Request.QueryString("NoDocumento"))) Then
            qsNSS = Request.QueryString("NSS")
            Me.txtNSS.Text = qsNSS
            qsNoDocumento = Request.QueryString("NoDocumento")
            Me.txtDocumento.Text = qsNoDocumento

            Buscar()

        End If

    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        If String.IsNullOrEmpty(Me.txtDocumento.Text) _
        AndAlso String.IsNullOrEmpty(Me.txtNSS.Text) _
        AndAlso String.IsNullOrEmpty(Me.txtNombres.Text) _
        AndAlso String.IsNullOrEmpty(Me.txtPrimerApellido.Text) _
        AndAlso String.IsNullOrEmpty(Me.txtSegundoApellido.Text) Then

            Me.lblMsg.Text = "Debe específicar un criterio."
            Exit Sub

        End If

        Me.pageNum = 1
        Me.PageSize = BasePage.PageSize

        Buscar()

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click

        'Me.txtDocumento.Text = String.Empty
        'Me.txtNSS.Text = String.Empty
        'Me.txtNombres.Text = String.Empty
        'Me.txtPrimerApellido.Text = String.Empty
        'Me.txtSegundoApellido.Text = String.Empty

        'Me.gvCiuidadanos.DataSource = Nothing
        'Me.gvCiuidadanos.DataBind()
        'Me.pnlNavegacion.Visible = False

        '  Me.udpBuscar.Visible = False
        Response.Redirect("consCiudadano.aspx")

    End Sub

    Protected Sub Buscar()

        Try
            'si la busqueda se está realizando por Nro. de Documento verificamos si está cancelada.
            If Not String.IsNullOrEmpty(Me.txtDocumento.Text) Then
                Dim tmpDt As DataTable = Utilitarios.TSS.CedulaCancelada(Me.txtDocumento.Text)
                If tmpDt.Rows.Count > 0 Then
                    If tmpDt.Rows(0)("tipo_causa").ToString() <> "H" Then
                        Select Case tmpDt.Rows(0)("tipo_causa").ToString()
                            Case "I"
                                Me.lblMsg.Text = "Cédula Inhabilitada, Razón: " & tmpDt.Rows(0)("cancelacion_des").ToString()
                            Case "C"
                                Me.lblMsg.Text = "Cédula Cancelada, Razón: " & tmpDt.Rows(0)("cancelacion_des").ToString()
                        End Select

                    End If
                End If
            End If

            BindGrid()

        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub BindGrid()
        'Aqui se le agregan ceros a la izquierda siempre y cuando sea los digitos menor que 9 para el NSS
        If Trim(Me.txtNSS.Text.Length) <> 9 Then
            'Me.txtNSS = String.Format("{0:000000000}", Convert.ToInt32(Me.txtNSS.Text))
            Me.txtNSS.Text.Trim.PadLeft(9, "0")
        End If

        'realizamos una consulta dinamicamente a ciudadanos por el criterio o parametro que se le pasa.
        dt = Nothing
        dt = Utilitarios.TSS.getConsultaNss(Me.txtDocumento.Text, _
                                            Me.txtNSS.Text, Me.txtNombres.Text, _
                                            Me.txtPrimerApellido.Text, _
                                            Me.txtSegundoApellido.Text, Me.pageNum, Me.PageSize)

        If dt.Rows.Count > 0 Then
            ViewState("dt") = dt
            ViewState("Sort") = "ASC"

            Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
            Me.gvCiuidadanos.DataSource = dt
            Me.gvCiuidadanos.DataBind()
            Me.pnlNavegacion.Visible = True
        Else
            Me.pnlNavegacion.Visible = False
            Me.gvCiuidadanos.DataSource = Nothing
            Me.gvCiuidadanos.DataBind()
            Me.lblMsg.Text = "Este Ciudadano no Existe"
        End If

        dt = Nothing
        setNavigation()

    End Sub

    Protected Sub gvCiuidadanos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvCiuidadanos.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then

            e.Row.Cells(0).Text = Utilitarios.Utils.FormatearNSS(e.Row.Cells(0).Text)

            If e.Row.Cells(1).Text <> "Menor" Then
                e.Row.Cells(6).Text = String.Empty
                e.Row.Cells(9).Text = String.Empty
                ' gvCiuidadanos.Columns.Item(5).Visible = False
            End If

            If e.Row.Cells(1).Text = "C&#233;dula" Then
                e.Row.Cells(2).Text = Utilitarios.Utils.FormatearRNCCedula(e.Row.Cells(2).Text)
            End If

            If e.Row.Cells(1).Text = "Titular" Then
                e.Row.Cells(2).Text = Utilitarios.Utils.FormatearNSS(e.Row.Cells(0).Text)
            End If

            Dim esMadre As String = CType(e.Row.FindControl("lblEsMadre"), Label).Text

            If esMadre = "No" Then
                e.Row.Cells(8).Text = String.Empty
                'gvCiuidadanos.Columns.Item(8).Visible = False
            Else

            End If

            If (e.Row.Cells(10).Text.Equals("Cancelacion")) Then
                e.Row.Cells(10).BackColor = Drawing.Color.Salmon
                e.Row.Cells(11).BackColor = Drawing.Color.Salmon
                e.Row.BackColor = Drawing.Color.WhiteSmoke
                'e.Row.ForeColor = Drawing.Color.White
                ' gvCiuidadanos.Columns.Item(10).Visible = True
                ' gvCiuidadanos.Columns.Item(11).Visible = True
                ' Else
                ' gvCiuidadanos.Columns.Item(10).Visible = False
                'gvCiuidadanos.Columns.Item(11).Visible = False
            End If

        End If

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

        Buscar()

    End Sub

    Private Function Sort() As String

        Dim newSortDirection = String.Empty

        If Not ViewState("Sort") Is Nothing Then

            Select Case ViewState("Sort").ToString
                Case "ASC"
                    newSortDirection = "ASC"
                    ViewState("Sort") = "DESC"


                Case "DESC"
                    newSortDirection = "DESC"
                    ViewState("Sort") = "ASC"
                Case Else
                    newSortDirection = "ASC"
            End Select
        Else
            newSortDirection = "ASC"
        End If

        Return newSortDirection

    End Function

    Protected Sub gvCiuidadanos_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvCiuidadanos.Sorting
        'Dim dt As New DataTable
        'dt = ViewState("dt")

        'If dt IsNot Nothing Then
        '    Dim dataView As DataView = New DataView(dt)
        '    dataView.Sort = e.SortExpression + " " + Sort()
        '    gvCiuidadanos.DataSource = dataView
        '    gvCiuidadanos.DataBind()
        'End If

        Dim sortExpression As String = e.SortExpression

        If GridViewSortDirection = SortDirection.Ascending Then

            GridViewSortDirection = SortDirection.Descending

            SortGridView(sortExpression, "DESC")

        Else

            GridViewSortDirection = SortDirection.Ascending

            SortGridView(sortExpression, "ASC")

        End If

    End Sub

    Public Property GridViewSortDirection() As SortDirection

        Get

            If ViewState("sort") Is Nothing Then

                ViewState("sort") = SortDirection.Ascending

            End If

            Return DirectCast(ViewState("sort"), SortDirection)

        End Get

        Set(ByVal value As SortDirection)

            ViewState("sort") = value

        End Set

    End Property

    Private Sub SortGridView(ByVal sortExpression As String, ByVal direction As String)
        Dim dt As New DataTable
        dt = ViewState("dt")

        If dt IsNot Nothing Then
            Dim dataView As DataView = New DataView(dt)
            dataView.Sort = sortExpression + " " + direction
            gvCiuidadanos.DataSource = dataView
            gvCiuidadanos.DataBind()
        End If

    End Sub


    Public Function IsNull(ByVal valor As Object) As Boolean
        Dim oResult As Boolean = False
        If IsDBNull(valor) Then
            oResult = True
        End If

        Return oResult
    End Function

End Class
