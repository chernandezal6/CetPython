Imports SuirPlus.Finanzas
Imports System.Data
Imports SuirPlus.XMLBC

Partial Class Finanzas_ConsArchivosRecibidos
    Inherits BasePage

    Private tipoArchivo As String
    Private fechaDesde As String
    Private fechaHasta As String

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
        Me.pageNum = 1
        Me.PageSize = BasePage.PageSize

        If Not Page.IsPostBack Then
            If Not (String.IsNullOrEmpty(Request.QueryString("tipoArchivo"))) Then

                Me.ddlTipoArchivo.SelectedValue = Request.QueryString.Item("tipoArchivo")
                Me.btnBuscar_Click(Nothing, Nothing)

            End If
        End If
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        Try
            'Limpiamos el contenido de la busqueda anterior
            Session.Remove("tipoArchivo")
            Session.Remove("fechaDesde")
            Session.Remove("fechaHasta")
            pnlNavegacion.Visible = False

            'validamos las fechas

            If (Me.txtDesde.Text <> String.Empty) And (Me.txtHasta.Text <> String.Empty) Then

                If (CDate(Me.txtHasta.Text)) < (CDate(Me.txtDesde.Text)) Then
                    Me.lblMensaje.Text = "La fecha hasta, debe ser mayor que la fecha desde."
                    Exit Sub
                ElseIf (CDate(Me.txtDesde.Text)) > (CDate(Me.txtHasta.Text)) Then
                    Me.lblMensaje.Text = "La fecha desde, debe ser menor que la fecha hasta."
                    Exit Sub
                End If

            End If
            'llenamos las variables para los parametros esperados en la busqueda de reclamaciones
            Session("tipoArchivo") = Me.ddlTipoArchivo.SelectedValue
            Session("fechaDesde") = Me.txtDesde.Text
            Session("fechaHasta") = Me.txtHasta.Text

            CargarArchivosRecibidos(Session("tipoArchivo"), Session("fechaDesde"), Session("fechaHasta"))

        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
        End Try

    End Sub

    Private Sub CargarArchivosRecibidos(ByRef tipoArchivo As String, ByVal fechadesde As String, ByVal fechahasta As String)

        Dim dt As New DataTable

        Try
            dt = ArchivosBC.getArchivosRecibidos(tipoArchivo, fechadesde, fechahasta, Me.pageNum, Me.PageSize)

            If dt.Rows.Count > 0 Then

                Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
                Me.gvArchivos.DataSource = dt
                Me.gvArchivos.DataBind()
                Me.pnlNavegacion.Visible = True
            Else
                Me.pnlNavegacion.Visible = False
                Me.gvArchivos.DataSource = Nothing
                Me.gvArchivos.DataBind()
                Me.lblMensaje.Text = "No existen registros para esta busqueda"
            End If

            dt = Nothing
            setNavigation()
        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message

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

        CargarArchivosRecibidos(Session("tipoArchivo"), Session("fechaDesde"), Session("fechaHasta"))

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("consArchivosRecibidos.aspx")
    End Sub

    Protected Sub gvArchivos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvArchivos.RowCommand

        Dim nombArchivo = e.CommandArgument.ToString.Split("|")(0)
        Dim TipoArch = e.CommandArgument.ToString.Split("|")(1)

        Try
            If TipoArch = "CONCENTRACION" Then
                Response.Redirect("~/finanzas/ConcentracionFondos.aspx?arch=" & nombArchivo)
            ElseIf TipoArch = "LIQUIDACION" Then
                Response.Redirect("~/finanzas/LiquidacionFondos.aspx?arch=" & nombArchivo)
            End If

        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
        End Try
    End Sub

    Protected Sub gvArchivos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvArchivos.RowDataBound


        'If e.Row.RowType = DataControlRowType.DataRow Then
        If Me.ddlTipoArchivo.SelectedValue <> "Todos" Then
            e.Row.Cells(0).Visible = False

        Else
            e.Row.Cells(0).Visible = True
        End If

        'End If
    End Sub

    Protected Sub ddlTipoArchivo_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlTipoArchivo.SelectedIndexChanged
        'llenamos las variables para los parametros esperados en la busqueda de reclamaciones
        Session("tipoArchivo") = Me.ddlTipoArchivo.SelectedValue
        Session("fechaDesde") = Me.txtDesde.Text
        Session("fechaHasta") = Me.txtHasta.Text
        CargarArchivosRecibidos(Session("tipoArchivo"), Session("fechaDesde"), Session("fechaHasta"))

    End Sub
End Class
