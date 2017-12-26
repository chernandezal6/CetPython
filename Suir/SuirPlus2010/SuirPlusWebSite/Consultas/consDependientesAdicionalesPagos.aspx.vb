Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios
Partial Class Consultas_consDependientesAdicionalesPagos
    Inherits BasePage
    Private dtDetNotificacion As New DataTable
    Private dtDetCarteraDispersion As New DataTable

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

    Public Property pageNum2() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNum2.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNum2.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNum2.Text = value
        End Set
    End Property

    Public Property PageSize2() As Int16
        Get
            If String.IsNullOrEmpty(Me.lblPageSize2.Text) Then
                Return BasePage.PageSize
            End If
            Return BasePage.PageSize
            'Return Int16.Parse(Me.lblPageSize2.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSize2.Text = value
        End Set

    End Property
#End Region


    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click


        If (Trim(Me.txtDocumento.Text) = String.Empty) Then
            lblError.Text = "Debe introducir una Cédula o un Número de seguridad social."
            Exit Sub
        End If

        If (Me.drpTipoConsulta.SelectedValue = "C") And (Me.txtDocumento.Text.Length <> 11) Then
            lblError.Text = "Debe introducir un número de cédula con 11 dígitos."

            Exit Sub
        End If

        If (Me.drpTipoConsulta.SelectedValue = "N") And (Me.txtDocumento.Text.Length > 9) Then
            lblError.Text = "Debe introducir un número de seguridad social válido."
            Exit Sub
        End If

        CargarInfo(Me.drpTipoConsulta.SelectedValue)
        BindGridView()

    End Sub

    Private Sub BindGridView()
        Try
            BindDetalleNotificacion()
            BindDetalleCarteraDispersion()

            If Not (Session("dtNotificacion") > 0) And Not (Session("dtCarteraDispersion") > 0) Then
                lblError.Text = "No existe registros para esta consulta."
                Exit Sub
            End If

        Catch ex As Exception
            lblError.Text = ex.Message
        End Try

    End Sub

    Protected Sub CargarInfo(ByVal id As String)

        Dim dtCargarInfo As New DataTable

        If id = "C" Then
            dtCargarInfo = Utilitarios.TSS.getConsultaNss(Me.txtDocumento.Text, Nothing, Nothing, Nothing, Nothing, 1, 1)
        Else
            dtCargarInfo = Utilitarios.TSS.getConsultaNss(Nothing, Me.txtDocumento.Text, Nothing, Nothing, Nothing, 1, 1)
        End If

        If dtCargarInfo.Rows.Count > 0 Then

            'Datos del Ciudadano
            Me.lblNombres.Text = dtCargarInfo.Rows(0)("NOMBRES").ToString()
            Me.lblApellidos.Text = dtCargarInfo.Rows(0)("APELLIDOS").ToString()
            Me.lblNss.Text = dtCargarInfo.Rows(0)("ID_NSS").ToString()
            Me.lblFechaNac.Text = String.Format("{0:d}", dtCargarInfo.Rows(0)("FECHA_NACIMIENTO"))
            Me.divInfo.Visible = True

        End If
    End Sub

    Protected Sub BindDetalleNotificacion()
        Try

            If Me.drpTipoConsulta.SelectedValue = "C" Then
                'llenamos el datatable via cedula
                dtDetNotificacion = Empresas.DependienteAdicional.getRefByDepAdicional(Me.txtDocumento.Text, Nothing, Me.pageNum, Me.PageSize)
            Else
                'llenamos el datatable via NSS y aseguramos que el nss se rellene de ceros a la izquierda cuando sea necesario
                If Trim(Me.txtDocumento.Text.Length) <> 9 Then
                    Me.txtDocumento.Text = Me.txtDocumento.Text.Trim.PadLeft(9, "0")
                End If
                dtDetNotificacion = Empresas.DependienteAdicional.getRefByDepAdicional(Nothing, Me.txtDocumento.Text, Me.pageNum, Me.PageSize)
            End If

            If (Me.dtDetNotificacion.Rows.Count > 0) Then
                'llenamos el primer grid
                Session("dtNotificacion") = dtDetNotificacion.Rows.Count
                Me.lblTotalRegistros.Text = dtDetNotificacion.Rows(0)("RECORDCOUNT")
                Me.gvDetalleNotificacionPago.DataSource = dtDetNotificacion
                Me.gvDetalleNotificacionPago.DataBind()
                Me.pnlDetalleNotificacionPago.Visible = True
                Me.pnlNavegacion.Visible = True
                lblError.Text = ""

            Else
                Session("dtNotificacion") = Nothing
                Me.pnlDetalleNotificacionPago.Visible = False
            End If
            dtDetNotificacion = Nothing
            setNavigation()
        Catch ex As Exception
            Throw ex

        End Try
    End Sub

    Protected Sub BindDetalleCarteraDispersion()
        Try

            If Me.drpTipoConsulta.SelectedValue = "C" Then
                'llenamos el datatable via cedula
                dtDetCarteraDispersion = Empresas.DependienteAdicional.getCarteraDispersion(Me.txtDocumento.Text, Nothing, Me.pageNum2, Me.PageSize2)

            Else
                'llenamos el datatable via NSS y aseguramos que el nss se rellene de ceros a la izquierda cuando sea necesario
                If Trim(Me.txtDocumento.Text.Length) <> 9 Then
                    Me.txtDocumento.Text = Me.txtDocumento.Text.Trim.PadLeft(9, "0")
                End If
                dtDetCarteraDispersion = Empresas.DependienteAdicional.getCarteraDispersion(Nothing, Me.txtDocumento.Text, Me.pageNum2, Me.PageSize2)
            End If

            If (Me.dtDetCarteraDispersion.Rows.Count > 0) Then
                'llenamos el segundo grid
                Session("dtCarteraDispersion") = dtDetCarteraDispersion.Rows.Count
                Me.lblTotalRegistros2.Text = dtDetCarteraDispersion.Rows(0)("RECORDCOUNT")
                Me.gvDetCarteraDispersion.DataSource = dtDetCarteraDispersion
                Me.gvDetCarteraDispersion.DataBind()
                Me.pnlDetCarteraDispersion.Visible = True
                Me.pnlNavegacion2.Visible = True
                lblError.Text = ""
            Else
                Session("dtCarteraDispersion") = Nothing
                Me.pnlDetCarteraDispersion.Visible = False

            End If
            dtDetCarteraDispersion = Nothing
            setNavigation2()
        Catch ex As Exception
            Throw ex
            'Me.lblError.Text = ex.Message
        End Try
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.Response.Redirect("consDependientesAdicionalesPagos.aspx")
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

    Private Sub setNavigation2()

        Dim totalRecords2 As Integer = 0

        If IsNumeric(Me.lblTotalRegistros2.Text) Then
            totalRecords2 = CInt(Me.lblTotalRegistros2.Text)
        End If

        Dim totalPages2 As Double = Math.Ceiling(Convert.ToDouble(totalRecords2) / PageSize2)

        If totalRecords2 = 1 Or totalPages2 = 0 Then
            totalPages2 = 1
        End If

        If PageSize2 > totalRecords2 Then
            PageSize2 = Int16.Parse(totalPages2)
        End If

        Me.lblCurrentPage2.Text = pageNum2
        Me.lblTotalPages2.Text = totalPages2

        If pageNum2 = 1 Then
            Me.btnLnkFirstPage2.Enabled = False
            Me.btnLnkPreviousPage2.Enabled = False
        Else
            Me.btnLnkFirstPage2.Enabled = True
            Me.btnLnkPreviousPage2.Enabled = True
        End If

        If pageNum2 = totalPages2 Then
            Me.btnLnkNextPage2.Enabled = False
            Me.btnLnkLastPage2.Enabled = False
        Else
            Me.btnLnkNextPage2.Enabled = True
            Me.btnLnkLastPage2.Enabled = True
        End If

    End Sub

    Protected Sub NavigationLink2_Click(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First2"
                pageNum2 = 1
            Case "Last2"
                pageNum2 = Convert.ToInt32(lblTotalPages2.Text)
            Case "Next2"
                pageNum2 = Convert.ToInt32(lblCurrentPage2.Text) + 1
            Case "Prev2"
                pageNum2 = Convert.ToInt32(lblCurrentPage2.Text) - 1
        End Select

        BindDetalleCarteraDispersion()

    End Sub

End Class


