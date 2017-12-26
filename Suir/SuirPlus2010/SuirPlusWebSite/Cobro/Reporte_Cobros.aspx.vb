Imports SuirPlus
Imports SuirPlus.Legal
Imports System.Data

Partial Class ReporteCobros
    Inherits BasePage

#Region "Paginacion"
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
    Protected Sub setNavigation()
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
    Protected Sub NavigationLink_Click(ByVal s As Object, ByVal e As CommandEventArgs) Handles btnLnkFirstPage.Command, btnLnkPreviousPage.Command, btnLnkNextPage.Command, btnLnkLastPage.Command

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

        Dim cartera = CType(ViewState("Catera"), Int32)

        Dim usuario = CStr(ViewState("Usuario"))

        LoadData(cartera, usuario)

    End Sub
    Protected Sub LoadData(ByVal Cartera As Int32, ByVal Usuario As String)

        Dim dt = Cobro.getReporteCobros(Cartera, Usuario, Me.pageNum, Me.PageSize)

        If dt.Rows.Count > 0 Then

            If Utilitarios.Utils.HayErrorEnDataTable(dt) = False Then
                gvcrmseguimiento.DataSource = dt.DefaultView
                gvcrmseguimiento.DataBind()
                lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
                pnlNavigation.Visible = True
                setNavigation()
            Else
                lblMensaje.Visible = True
                lblMensaje.Text = Utilitarios.Utils.sacarMensajeDeErrorDesdeTabla(dt)
                pnlNavigation.Visible = False
            End If


        Else
            lblMensaje.Visible = True
            lblMensaje.Text = "No hay data disponible."
            lblTotalRegistros.Text = String.Empty
            gvcrmseguimiento.DataSource = Nothing
            gvcrmseguimiento.DataBind()
            pnlNavigation.Visible = False

        End If

    End Sub
#End Region
#Region "Metodos de la pagina"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then

            divdetseguimiento.Visible = False
            divcrmseguimiento.Visible = False

            Dim dt As New DataTable

            Dim tipo As Integer = 0
            If Seguridad.Autorizacion.isInRol(UsrUserName, "318") Then tipo = 232
            If Seguridad.Autorizacion.isInRol(UsrUserName, "298") Then tipo = 213

            If tipo > 0 Then
                Dim rol As New Seguridad.Role(tipo)

                dt = rol.getUsuariosTienenRole()

                If dt.Rows.Count > 0 Then
                    ddlusuarios.DataSource = dt
                    ddlusuarios.DataTextField = "nombre"
                    ddlusuarios.DataValueField = "id_usuario"
                    ddlusuarios.DataBind()
                    ddlusuarios.Items.Insert(0, New ListItem("Seleccione", "0"))
                End If
            Else
                ddlusuarios.Items.Insert(0, New ListItem("Seleccione", "0"))
            End If


         

        End If

    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        divcarteraasignadas.Visible = True

        DesahabilitarControles()

        Dim dt = Cobro.getReporteCobros(ddlusuarios.SelectedItem.Value)

        If dt.Rows.Count > 0 Then

            If Utilitarios.Utils.HayErrorEnDataTable(dt) = False Then
                gvCobros.DataSource = dt.DefaultView
                gvCobros.DataBind()
                lblMensaje.Text = String.Empty
            Else
                divcarteraasignadas.Visible = False
                lblMensaje.Visible = True
                lblMensaje.Text = Utilitarios.Utils.sacarMensajeDeErrorDesdeTabla(dt)
            End If
        Else
            lblMensaje.Visible = True
            lblMensaje.Text = "No hay data disponible."
            divcarteraasignadas.Visible = False
        End If
        dt.Dispose()

    End Sub

    Protected Sub gvCobros_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvCobros.RowCommand

        divdetseguimiento.Visible = True
        divcrmseguimiento.Visible = False
        pnlNavigation.Visible = False
        gvcrmseguimiento.DataSource = Nothing
        gvcrmseguimiento.DataBind()

        If e.CommandName = "DetalleSeguimieto" Then

            Dim dt = Cobro.getReporteCobros(CInt(e.CommandArgument.ToString()))

            If dt.Rows.Count > 0 Then

                If Utilitarios.Utils.HayErrorEnDataTable(dt) = False Then

                    gvdetalleseguimiento.DataSource = dt.DefaultView
                    gvdetalleseguimiento.DataBind()
                    lblMensaje.Text = String.Empty

                Else
                    divdetseguimiento.Visible = False
                    lblMensaje.Visible = True
                    lblMensaje.Text = Utilitarios.Utils.sacarMensajeDeErrorDesdeTabla(dt)
                End If

            Else
                divdetseguimiento.Visible = False
                lblMensaje.Visible = True
                lblMensaje.Text = "No hay data disponible."
                gvdetalleseguimiento.DataSource = Nothing
                gvdetalleseguimiento.DataBind()
            End If

            dt.Dispose()
        End If

    End Sub

    Protected Sub gvdetalleseguimiento_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvdetalleseguimiento.RowCommand

        divcrmseguimiento.Visible = True

        Dim params() As String = e.CommandArgument.ToString.Split("|")
        Dim cartera = CInt(params(0))
        Dim usuario = params(1)

        ViewState("Catera") = cartera
        ViewState("Usuario") = usuario
        PageSize = BasePage.PageSize
        lblMensaje.Text = String.Empty
        pageNum = 1
        LoadData(cartera, usuario)

    End Sub

    Protected Sub btncancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btncancelar.Click
        divcarteraasignadas.Visible = False
        divdetseguimiento.Visible = False
        divcrmseguimiento.Visible = False
        pnlNavigation.Visible = False
        ddlusuarios.SelectedIndex = -1
        lblMensaje.Text = String.Empty
    End Sub
#End Region
#Region "Metodos Privados de la pagina"
    Private Sub DesahabilitarControles()
        divdetseguimiento.Visible = False
        divcrmseguimiento.Visible = False
        pnlNavigation.Visible = False
        gvcrmseguimiento.DataSource = Nothing
        gvcrmseguimiento.DataBind()
        gvdetalleseguimiento.DataSource = Nothing
        gvdetalleseguimiento.DataBind()
    End Sub
#End Region

End Class
