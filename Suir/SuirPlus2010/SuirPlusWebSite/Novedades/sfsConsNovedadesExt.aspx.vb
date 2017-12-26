Imports SuirPlus
Imports System.Data
Imports SuirPlus.Utilitarios
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.SubsidiosSFS
Imports SuirPlus.Empresas.SubsidiosSFS.Maternidad
Partial Class Novedades_sfsConsNovedadesExt
    Inherits BasePage
    Protected empleado As Trabajador
    Protected madre As Maternidad
    Private countEvents As Int32 = 0

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
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        'Si se provee fecha desde, debe proveerse fecha hasta, y viceversa
        If (txtDesde.Text.Equals(String.Empty) And Not txtHasta.Text.Equals(String.Empty)) Or (Not txtDesde.Text.Equals(String.Empty) And txtHasta.Text.Equals(String.Empty)) Then
            lblMsg.Text = "Debe completar las fechas desde y hasta"
            Exit Sub
        End If
        Try
            lblMsg.Text = String.Empty

            Me.pageNum = 1
            Me.PageSize = BasePage.PageSize

            Buscar()

        Catch ex As Exception
            lblMsg.Text = ex.Message

        End Try
    End Sub
    Private Sub Buscar()
        Dim mensaje As String = String.Empty
        Dim dt As DataTable

        dt = Maternidad.GetSubsidiosExtraordinarios(txtDesde.Text, txtHasta.Text, IIf(ddlTipoSubsidio.SelectedValue.Equals("Todas"), String.Empty, ddlTipoSubsidio.SelectedValue), txtRegistroPatronal.Text, mensaje, IIf(Me.pageNum.Equals(0), 1, Me.pageNum), Me.PageSize)
        gvSubsidios.DataSource = dt
        gvSubsidios.DataBind()

        If Not mensaje.Equals("0") Then
            lblMsg.Text = mensaje
            divConsulta.Visible = False
        Else
            If gvSubsidios.Rows.Count > 0 Then
                divConsulta.Visible = True
                Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
                setNavigation()
            Else
                divConsulta.Visible = False
                lblMsg.Text = "No existen registros para estos criterios de búsqueda"
            End If
        End If
    End Sub

    Protected Sub gvSubsidios_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvSubsidios.RowCommand
        lblMsg.Text = String.Empty
        lblMsg2.visible = False
        If e.CommandName.Equals("Detalle") Then

            Dim empleadorMadre As New Empleador(Convert.ToInt32(Split(e.CommandArgument, "|")(2)))
            Dim nssConsulta As String = Split(e.CommandArgument, "|")(0)

            If Split(e.CommandArgument, "|")(1).Equals("Maternidad") Then
                Response.Redirect("~/novedades/sfsMaternidadExtraordinario.aspx?desde=" & txtDesde.Text & "&hasta=" & txtHasta.Text & "&tipo=" & ddlTipoSubsidio.SelectedValue & "&NSSconsulta=" & nssConsulta & "&RNC=" & empleadorMadre.RNCCedula & "&RegistroPatronal=" & txtRegistroPatronal.Text)
            Else
                Response.Redirect("~/novedades/sfsLactanciaExtraordinario.aspx?desde=" & txtDesde.Text & "&hasta=" & txtHasta.Text & "&tipo=" & ddlTipoSubsidio.SelectedValue & "&NSSconsulta=" & nssConsulta & "&RNC=" & empleadorMadre.RNCCedula & "&RegistroPatronal=" & txtRegistroPatronal.Text)
            End If
        ElseIf e.CommandName.Equals("Borrar") Then
            Try

                If Split(e.CommandArgument, "|")(1).Equals("Maternidad") Then
                    Dim resultado As String = BajaRepMaternidadExtraordinaria(Split(e.CommandArgument, "|")(0), Split(e.CommandArgument, "|")(2), UsrUserName, Split(e.CommandArgument, "|")(3))
                    If Not resultado.Equals("OK") Then
                        lblMsg.Text = resultado
                    Else
                        btnBuscar_Click(sender, e)
                        lblMsg2.Visible = True
                        lblMsg.Text = String.Empty
                    End If
                Else
                    Dim resultado As String = BajaRepLactanciaExtraordinario(Split(e.CommandArgument, "|")(0), Split(e.CommandArgument, "|")(2), UsrUserName, Split(e.CommandArgument, "|")(3))
                    If Not resultado.Equals("OK") Then
                        lblMsg.Text = resultado
                    Else
                        btnBuscar_Click(sender, e)
                        lblMsg2.Visible = True
                        lblMsg.Text = String.Empty
                    End If
                End If
            Catch ex As Exception
                lblMsg.Text = ex.Message
            End Try
        End If

    End Sub
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        For Each i As System.Web.UI.WebControls.GridViewRow In Me.gvSubsidios.Rows
            CType(i.FindControl("iBtnBorrar"), ImageButton).Attributes.Add("onClick", "return confirm('Esta seguro que desea eliminar dar de baja al subsidio?');")
        Next
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then

            If Not (String.IsNullOrEmpty(Request.QueryString("NSSconsulta"))) Then
                txtDesde.Text = IIf(Request.QueryString("desde") Is Nothing, String.Empty, Request.QueryString("desde").ToString())
                txtHasta.Text = IIf(Request.QueryString("hasta") Is Nothing, String.Empty, Request.QueryString("hasta").ToString())
                ddlTipoSubsidio.Text = IIf(Request.QueryString("tipo") Is Nothing, String.Empty, Request.QueryString("tipo").ToString())
                txtRegistroPatronal.Text = IIf(Request.QueryString("RegistroPatronal") Is Nothing, String.Empty, Request.QueryString("RegistroPatronal").ToString())

                btnBuscar_Click(sender, e)

            End If
        End If

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        txtDesde.Text = String.Empty
        txtHasta.Text = String.Empty
        txtRegistroPatronal.Text = String.Empty
        divConsulta.Visible = False
        ddlTipoSubsidio.Text = "M"
        gvSubsidios.DataSource = Nothing
        gvSubsidios.DataBind()
    End Sub

    Protected Sub NavigationLink_Click(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.CommandEventArgs) Handles btnLnkFirstPage.Command, btnLnkPreviousPage.Command
        If countEvents = 0 Then
            Select Case e.CommandName
                Case "First"
                    pageNum = 1
                    countEvents = countEvents + 1
                Case "Last"
                    pageNum = Convert.ToInt32(lblTotalPages.Text)
                Case "Next"
                    pageNum = Convert.ToInt32(lblCurrentPage.Text) + 1
                Case "Prev"
                    pageNum = Convert.ToInt32(lblCurrentPage.Text) - 1
                    countEvents = countEvents + 1
            End Select

            Buscar()
        End If
    End Sub
End Class
