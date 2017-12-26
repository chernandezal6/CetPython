Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios.Utils
Imports System.Windows.Forms.MessageBox



Partial Class Empleador_empManejoMensajes
    Inherits BasePage

    'Para la paginacion del GRID de mensajes archivados
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

    'Para la paginacion del GRID de mensajes Pendientes y Leidos
    Public Property pageNum1() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNum1.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNum1.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNum1.Text = value
        End Set
    End Property

    Public Property PageSize1() As Int16
        Get
            If String.IsNullOrEmpty(Me.lblPageSize1.Text) Then
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSize1.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSize1.Text = value
        End Set
    End Property



    Protected Sub Page_Load1(sender As Object, e As EventArgs) Handles Me.Load

        Me.lblError.Visible = False
        If Not Page.IsPostBack Then
            BindMensajesLeidosyPendientes()
            BindMensajesArchivados()
        End If
        pageNum = 1
        pageNum1 = 1
       
    End Sub

    Public status As String

    Protected Sub BindMensajesLeidosyPendientes()


        PageSize1 = BasePage.PageSize

        Dim dtMensajes As New DataTable
        Try
            dtMensajes = SuirPlus.Empresas.Empleador.getMensajesLeidosyPendientes(UsrRegistroPatronal, pageNum1, PageSize1)


            If dtMensajes.Rows.Count > 0 Then
                'llenamos el grid y los labels'

                Me.lblTotalRegistros1.Text = dtMensajes.Rows(0)("RECORDCOUNT")
                Me.gvMensajesLeidosyPendientes.DataSource = dtMensajes
                Me.gvMensajesLeidosyPendientes.DataBind()
                Me.divPagMsjsPendientes.Visible = True
                '  divMensajes.Visible = True
                'divInfoEmpleador.Visible = True
                'lblRnc.Text = UsrRNC.ToString()
                ' lblrazonsocial.Text = dtMensajes.Rows(0)("razon_social").ToString()
                'LnkBtvolver1.Visible = True

            Else
                Me.lblError.Visible = True
                Me.lblErrorMsjsPendientes.Text = "Usted no tiene mensajes pendientes"
            End If

            setNavigation1()
            dtMensajes = Nothing


        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message
        End Try
    End Sub


    Protected Sub BindMensajesArchivados()

        PageSize = BasePage.PageSize


        Dim dtMensajes As New DataTable
        Try
            dtMensajes = SuirPlus.Empresas.Empleador.getMensajesArchivados(UsrRegistroPatronal, pageNum, PageSize)


            If dtMensajes.Rows.Count > 0 Then
                'llenamos el grid y los labels'

                Me.lblTotalRegistros.Text = dtMensajes.Rows(0)("RECORDCOUNT")
                Me.gvMensajesArchivados.DataSource = dtMensajes
                Me.gvMensajesArchivados.DataBind()
                Me.divPagMsjsArchivados.Visible = True
                'LnkBtvolver.Visible = True
                '   divMensajesArchivados.Visible = True
                'divInfoEmpleador.Visible = True
                'lblRnc.Text = UsrRNC.ToString()
                ' lblrazonsocial.Text = dtMensajes.Rows(0)("razon_social").ToString()


            Else
                Me.lblError.Visible = True
                Me.lblErrorMsjsArchivados.Text = "Este empleador no tiene mensajes archivados"
            End If

            setNavigation()
            dtMensajes = Nothing


        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message
        End Try
    End Sub


  
   
    Protected Sub gvMensajes_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvMensajesLeidosyPendientes.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            status = CType(e.Row.FindControl("lblEstatus"), Label).Text
            If status = "Pendiente" Then
                '  e.Row.Cells(0).Font.Underline = True
                e.Row.Cells(0).Font.Bold = True
            End If
        End If


    End Sub

    Protected Sub gvMensajes_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvMensajesLeidosyPendientes.RowCommand
        Dim id_mensaje As Integer = Split(e.CommandArgument, "|")(0)
        Dim id_registro_patronal As Integer = Split(e.CommandArgument, "|")(1)

        Try
            If e.CommandName = "Leer" Then

                Response.Redirect("verMensajeEmpleador.aspx?id=" & id_mensaje)

            End If

            If e.CommandName = "LeerMensaje" Then

                Response.Redirect("verMensajeEmpleador.aspx?id=" & id_mensaje)

            End If


        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message
        End Try
    End Sub


    
  
    Protected Sub gvMensajesArchivados_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvMensajesArchivados.RowCommand

        Dim id_mensaje As Integer = Split(e.CommandArgument, "|")(0)
        Dim id_registro_patronal As Integer = Split(e.CommandArgument, "|")(1)

        Try
            If e.CommandName = "Leer" Then

                Response.Redirect("verMensajeEmpleador.aspx?id=" & id_mensaje)

            End If

            If e.CommandName = "LeerMensaje" Then

                Response.Redirect("verMensajeEmpleador.aspx?id=" & id_mensaje)

            End If


        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message
        End Try
    End Sub

    Protected Sub gvMensajesArchivados_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvMensajesArchivados.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            status = CType(e.Row.FindControl("lblEstatus"), Label).Text
            If status = "Pendiente" Then
                '  e.Row.Cells(0).Font.Underline = True
                e.Row.Cells(0).Font.Bold = True
            End If
        End If
    End Sub

    Protected Sub tbContainer_ActiveTabChanged(sender As Object, e As EventArgs) Handles tbContainer.ActiveTabChanged
        Me.lblError.Text = String.Empty
        Me.lblErrorMsjsPendientes.Text = String.Empty
        Me.lblErrorMsjsArchivados.Text = String.Empty

        Dim tab As String = CType(sender, AjaxControlToolkit.TabContainer).ActiveTab.HeaderText
        Try

            Select Case tab

                Case "LeidosyPendientes"
                    Me.BindMensajesLeidosyPendientes()
                Case "Archivados"
                    Me.BindMensajesArchivados()
                    'Case "IR17"
                    'Me.CargarDatosIR17()

            End Select

        Catch ex As Exception
            Me.lblError.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    'Parte de la paginacion para el GRID de mensajes ARCHIVADOS
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

        'Aqui ponemos el metodo que cargara la informacion'
        BindMensajesArchivados()
    End Sub


    'Parte de la paginacion para el GRID de mensajes LEIDOS Y PENDIENTES
    Private Sub setNavigation1()

        Dim totalRecords As Integer = 0

        If IsNumeric(Me.lblTotalRegistros1.Text) Then
            totalRecords = CInt(Me.lblTotalRegistros1.Text)
        End If

        Dim totalPages As Double = Math.Ceiling(Convert.ToDouble(totalRecords) / PageSize1)

        If totalRecords = 1 Or totalPages = 0 Then
            totalPages = 1
        End If

        If PageSize1 > totalRecords Then
            PageSize1 = Int16.Parse(totalPages)
        End If

        Me.lblCurrentPage1.Text = pageNum1
        Me.lblTotalPages1.Text = totalPages

        If pageNum1 = 1 Then
            Me.btnLnkFirstPage1.Enabled = False
            Me.btnLnkPreviousPage1.Enabled = False
        Else
            Me.btnLnkFirstPage1.Enabled = True
            Me.btnLnkPreviousPage1.Enabled = True
        End If

        If pageNum1 = totalPages Then
            Me.btnLnkNextPage1.Enabled = False
            Me.btnLnkLastPage1.Enabled = False
        Else
            Me.btnLnkNextPage1.Enabled = True
            Me.btnLnkLastPage1.Enabled = True
        End If

    End Sub

    Protected Sub NavigationLink_Click1(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First"
                pageNum1 = 1
            Case "Last"
                pageNum1 = Convert.ToInt32(lblTotalPages1.Text)
            Case "Next"
                pageNum1 = Convert.ToInt32(lblCurrentPage1.Text) + 1
            Case "Prev"
                pageNum1 = Convert.ToInt32(lblCurrentPage1.Text) - 1
        End Select

        'Aqui ponemos el metodo que cargara la informacion'
        BindMensajesLeidosyPendientes()
    End Sub

    'Protected Sub LnkBtvolver_Click(sender As Object, e As System.EventArgs) Handles LnkBtvolver.Click

    'End Sub



    'Protected Sub LnkBtvolver_Click1(sender As Object, e As System.EventArgs) Handles LnkBtvolver.Click

    'End Sub

End Class
