Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios

Partial Class Consultas_consDependienteAdicionalPagado
    Inherits BasePage
    Private dtDetNotificacion As New DataTable
    Private dtDetNotificacionRNC As New DataTable

#Region "Propiedades"
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
#End Region

    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load
        pageNum = 1
        PageSize = CInt(ConfigurationManager.AppSettings.Item("PAGE_SIZE"))
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As System.EventArgs) Handles btnBuscar.Click

        'Validamos que los campos de las cedulas estén llenos.'
        If (Trim(Me.txtDocumento.Text) = String.Empty) Or (Trim(Me.TxtDependiente.Text) = String.Empty) Then
            lblError.Text = "Debe introducir ambas cédulas."
            RequiredFieldValidator1.Enabled = True
            Exit Sub
        End If

        'Validamos que la cédula contenga 11 dígitos.'
        If (Me.txtDocumento.Text.Length <> 11 Or (Me.TxtDependiente.Text.Length <> 11)) Then
            lblError.Text = "Debe introducir un número de cédula con 11 dígitos."
            Exit Sub
        End If
        'Si el usuario logueado es representante solo podra ver las facturas que le corresponden a su RNC'
        'Aqui investigamos el usuario Logueado'
        If UsrIDTipoUsuario = 2 Then
            BindGridViewRNC()
            btnBuscar.Enabled = False
        Else
            BindGridView()
            btnBuscar.Enabled = False
        End If

    End Sub

    Private Sub BindGridView()
        Try
            BindDetalleNotificacion()

            If Not (Session("dtNotificacion") > 0) Then
                'lblError.Text = "No existen Notificaciones de Pago para este dependiente adicional."
                Dim res As String = String.Empty
                res = lblError.Text
                Throw New Exception(res)
                Exit Sub
            End If
        Catch ex As Exception
            lblError.Text = ex.Message

        End Try

    End Sub
    'Este es el GridView para si el usuario logueado es representante'
    Private Sub BindGridViewRNC()
        Try
            BindDetalleNotificacionRNC()

            If Not (Session("dtNotificacionRNC") > 0) Then

                'lblError.Text = "No existen registros para esta busqueda."
                Dim res As String = String.Empty
                res = lblError.Text
                Throw New Exception(res)
                Exit Sub
            End If

        Catch ex As Exception
            lblError.Text = ex.Message
        End Try

    End Sub
    Protected Sub BindDetalleNotificacion()


        Try
            dtDetNotificacion = Empresas.DependienteAdicional.getNotificacionesPagadasByDepAdicional(Me.txtDocumento.Text, Me.TxtDependiente.Text, Nothing, Me.pageNum, Me.PageSize)

            If (Me.dtDetNotificacion.Rows.Count > 0) Then
                'llenamos el grid y los labels'
                Me.lblNombreTitular.Text = dtDetNotificacion.Rows(0)("NOMBRE_TITULAR").ToString()
                Me.lblNombreDependiente.Text = dtDetNotificacion.Rows(0)("NOMBRE_DEPENDIENTE").ToString()
                Me.divInfo.Visible = True
                Session("dtNotificacion") = dtDetNotificacion.Rows.Count
                lblTotalRegistros.Text = dtDetNotificacion.Rows(0)("RECORDCOUNT")
                Me.gvDetalleNotificacionPago.DataSource = dtDetNotificacion
                Me.gvDetalleNotificacionPago.DataBind()
                Me.pnlDetalleNotificacionPago.Visible = True
                Me.pnlNavegacion.Visible = True
                lblError.Text = ""

            Else
                Session("dtNotificacion") = Nothing
                Me.pnlDetalleNotificacionPago.Visible = False
                lblError.Text = "No existen registros para esta búsqueda."

            End If
            dtDetNotificacion = Nothing
            dtDetNotificacion = Nothing
            setNavigation()

        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message
        End Try
    End Sub

    Protected Sub BindDetalleNotificacionRNC()
        Try
            dtDetNotificacionRNC = Empresas.DependienteAdicional.getNotificacionesPagadasByDepAdicional(Me.txtDocumento.Text, Me.TxtDependiente.Text, UsrRNC, Me.pageNum, Me.PageSize)

            If (Me.dtDetNotificacionRNC.Rows.Count > 0) Then
                'llenamos el grid'
                Me.lblNombreTitular.Text = dtDetNotificacionRNC.Rows(0)("NOMBRE_TITULAR").ToString()
                Me.lblNombreDependiente.Text = dtDetNotificacionRNC.Rows(0)("NOMBRE_DEPENDIENTE").ToString()
                Me.divInfo.Visible = True
                Session("dtNotificacionRNC") = dtDetNotificacionRNC.Rows.Count
                lblTotalRegistros.Text = dtDetNotificacionRNC.Rows(0)("RECORDCOUNT")
                Me.gvDetalleNotificacionPago.DataSource = dtDetNotificacionRNC
                Me.gvDetalleNotificacionPago.DataBind()
                Me.pnlDetalleNotificacionPago.Visible = True
                Me.pnlNavegacion.Visible = True
                lblError.Text = ""

            Else
                Session("dtNotificacion") = Nothing
                Me.pnlDetalleNotificacionPago.Visible = False
                lblError.Text = "No existen registros para esta búsqueda."
            End If
            dtDetNotificacion = Nothing
            dtDetNotificacion = Nothing
            setNavigation()

        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message
        End Try
    End Sub
    Protected Sub btnLimpiar_Click(sender As Object, e As System.EventArgs) Handles btnLimpiar.Click
        Me.Response.Redirect("consDependienteAdicionalPagado.aspx")
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

        BindDetalleNotificacion()

    End Sub

   

   
End Class
