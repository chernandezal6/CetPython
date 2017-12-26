Partial Class Certificaciones_ConsultaCerSolicitudes
    Inherits BasePage
#Region "Propiedades"

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

    ''' <summary>
    ''' Propiedad de Registro Patronal guardada en el Viewstate.
    ''' </summary>
    ''' <value>Un integer que respresenta el Registro Patronal</value>
    ''' <returns>Un integer que respresenta el Registro Patronal</returns>
    ''' <remarks></remarks>
    Protected Property RegistroPatronal() As Integer
        Get
            Return ViewState("RegPatronal")
        End Get
        Set(ByVal value As Integer)
            ViewState("RegPatronal") = value
        End Set
    End Property

    ''' <summary>
    ''' Propiedad de RNC guardada en el Viewstate.
    ''' </summary>
    ''' <value>Una Cadena que representa el RNC</value>
    ''' <returns>Una Cadena que representa el RNC</returns>
    ''' <remarks></remarks>
    Public Property RNC() As String
        Get
            Return ViewState("RNC")
        End Get
        Set(ByVal value As String)
            ViewState("RNC") = value
        End Set
    End Property

    ''' <summary>
    ''' Propiedad de IDRepresentante guardada en el Viewstate.
    ''' </summary>  
    Public Property IDRepresentante() As String
        Get
            Return ViewState("IDRepresentante")
        End Get
        Set(ByVal value As String)
            ViewState("IDRepresentante") = value
        End Set
    End Property

#End Region

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            CargarTipoCertificacion()
            CargarCertificaciones()
        End If

    End Sub
    Sub CargarTipoCertificacion()

        ddlTipoCertificacion.DataValueField = "TIPO_CERTIFICACION"
        ddlTipoCertificacion.DataTextField = "DESCRIPCION_CERTIFICACION"
        ddlTipoCertificacion.DataSource = SuirPlus.Empresas.Certificaciones.GetDescripcionTipoCertificacion(UsrRNC, UsrUserName)
        ddlTipoCertificacion.DataBind()
        ddlTipoCertificacion.Items.Add(New ListItem("<--TODOS-->", ""))
        ddlTipoCertificacion.SelectedValue = ""

    End Sub


    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click

        Dim No_Autorizacion As String = String.Empty
        Dim Certificacion As Integer = 0
        Me.lblTotalRegistros.Text = 0

        Me.pageNum = 1
        Me.PageSize = BasePage.PageSize

        If txtNroDocumento.Text <> String.Empty Then
            lblMensaje.Text = String.Empty

            If txtNroDocumento.Text.Contains("-") Then
                No_Autorizacion = txtNroDocumento.Text

            Else
                If Not IsNumeric(txtNroDocumento.Text) Then
                    lblMensaje.Text = "Los valores para la busqueda son inválidos"
                    Return
                Else
                    Certificacion = Convert.ToInt32(txtNroDocumento.Text)
                End If
            End If
        End If


        gvConsulta.DataSource = SuirPlus.Empresas.Certificaciones.GetSolicitudCertificacion(ddlTipoCertificacion.SelectedValue, UsrRNC, UsrUserName, "", Certificacion, No_Autorizacion, txtFechaDesde.Text, txtFechaHasta.Text, pageNum, PageSize)
        gvConsulta.DataBind()
        OcultarCeldas()
        If SuirPlus.Empresas.Certificaciones.GetSolicitudCertificacion(ddlTipoCertificacion.SelectedValue, UsrRNC, UsrUserName, "", Certificacion, No_Autorizacion, txtFechaDesde.Text, txtFechaHasta.Text, pageNum, PageSize).Rows.Count > 0 Then
            Me.lblTotalRegistros.Text = SuirPlus.Empresas.Certificaciones.GetSolicitudCertificacion(ddlTipoCertificacion.SelectedValue, UsrRNC, UsrUserName, "", Certificacion, No_Autorizacion, txtFechaDesde.Text, txtFechaHasta.Text, pageNum, PageSize).Rows(0)("RECORDCOUNT")
        End If

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

    Sub CargarCertificaciones()

        If SuirPlus.Empresas.Certificaciones.GetSolicitudCertificacion(ddlTipoCertificacion.SelectedValue, UsrRNC, UsrUserName, "", 0, "", txtFechaDesde.Text, txtFechaHasta.Text, pageNum, PageSize).Rows.Count > 0 Then
            Me.lblTotalRegistros.Text = SuirPlus.Empresas.Certificaciones.GetSolicitudCertificacion(ddlTipoCertificacion.SelectedValue, UsrRNC, UsrUserName, "", 0, "", txtFechaDesde.Text, txtFechaHasta.Text, pageNum, PageSize).Rows(0)("RECORDCOUNT")
        End If

        gvConsulta.DataSource = SuirPlus.Empresas.Certificaciones.GetSolicitudCertificacion(ddlTipoCertificacion.SelectedValue, UsrRNC, UsrUserName, "", 0, "", txtFechaDesde.Text, txtFechaHasta.Text, pageNum, PageSize)
        gvConsulta.DataBind()
        OcultarCeldas()

        setNavigation()
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

        CargarCertificaciones()

    End Sub

    Protected Sub gvConsulta_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvConsulta.RowCommand
        If e.CommandName = "Entregada" Then
            Dim b, c, d As String
            b = String.Empty
            c = String.Empty
            d = String.Empty

            Dim random = New Random(DateTime.Now.Millisecond)
            Dim rand As Random = New Random()
            Dim letras = Enumerable.Range(0, 20).Select(Function(i) (Chr(Asc("A") + rand.Next(0, 26)))).OrderBy(Function(x) random.Next()).ToList()
            Dim letras2 = Enumerable.Range(20, 40).Select(Function(i) (Chr(Asc("A") + rand.Next(0, 26)))).OrderBy(Function(x) random.Next()).ToList()
            Dim letras3 = Enumerable.Range(40, 60).Select(Function(i) (Chr(Asc("A") + rand.Next(0, 26)))).OrderBy(Function(x) random.Next()).ToList()

            For Each l As String In letras
                b = b & l
            Next

            For Each l As String In letras2
                c = c & l
            Next

            For Each l As String In letras3
                d = d & l
            Next


            Dim Resultado = Convert.ToBase64String(Encoding.ASCII.GetBytes(e.CommandArgument.ToString().ToCharArray()))
            Response.Redirect(Application("servidor") + "sys/ImpCertificacion.aspx?A=" + Resultado + "&b=" + b + "&C=" + c + "&D=" + d + "")
        Else

        End If

    End Sub

    Sub OcultarCeldas()

        For i = 0 To gvConsulta.Rows.Count - 1
            If gvConsulta.Rows(i).Cells(3).Text <> "Entregada" Then
                CType(gvConsulta.Rows(i).FindControl("ibDescargar"), ImageButton).Visible = False
                'CType(gvConsulta.Rows(i).FindControl("ibDescargar"), HyperLink).Visible = False
            End If

        Next

        For i = 0 To gvConsulta.Rows.Count - 1
            If gvConsulta.Rows(i).Cells(3).Text <> "Rechazada" Then
                gvConsulta.Rows(i).Cells(4).Text = String.Empty
            End If

        Next


    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        txtFechaDesde.Text = ""
        txtFechaHasta.Text = ""
        ddlTipoCertificacion.SelectedValue = ""
        Response.Redirect("ConsultaCerSolicitudes.aspx")


    End Sub
End Class
