Imports System.Data
Imports SuirPlus.MDT
Imports SuirPlus
Imports SuirPlus.Utilitarios.Utils

Partial Class Consultas_ConsultaDetalleTrabajador
    Inherits BasePage


    'Propiedades de paginacion Movimientos DGT3
    Public Property pageNumMovDGT3() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNumMovDGT3.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNumMovDGT3.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNumMovDGT3.Text = value
        End Set
    End Property
    Public Property PageSizeMovDGT3() As Int16
        Get
            lblPageSizeMovDGT3.Text = ""
            If String.IsNullOrEmpty(Me.lblPageSizeMovDGT3.Text) Then
                'Return 25
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSizeMovDGT3.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSizeMovDGT3.Text = value
        End Set
    End Property

    'Propiedades de paginacion Movimientos DGT4
    Public Property pageNumMovDGT4() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNumMovDGT4.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNumMovDGT4.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNumMovDGT4.Text = value
        End Set
    End Property
    Public Property PageSizeMovDGT4() As Int16
        Get
            lblPageSizeMovDGT4.Text = ""
            If String.IsNullOrEmpty(Me.lblPageSizeMovDGT4.Text) Then
                'Return 25
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSizeMovDGT4.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSizeMovDGT4.Text = value
        End Set
    End Property

    'Propiedades de paginacion planillas DGT3
    Public Property pageNumDGT3() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNumDGT3.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNumDGT3.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNumDGT3.Text = value
        End Set
    End Property
    Public Property PageSizeDGT3() As Int16
        Get
            lblPageSizeDGT3.Text = ""
            If String.IsNullOrEmpty(Me.lblPageSizeDGT3.Text) Then
                ' Return 25
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSizeDGT3.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSizeDGT3.Text = value
        End Set
    End Property

    'Propiedades de paginacion planillas DGT4
    Public Property pageNumDGT4() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNumDGT4.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNumDGT4.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNumDGT4.Text = value
        End Set
    End Property
    Public Property PageSizeDGT4() As Int16
        Get
            lblPageSizeDGT4.Text = ""
            If String.IsNullOrEmpty(Me.lblPageSizeDGT4.Text) Then
                'Return 25
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSizeDGT4.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSizeDGT4.Text = value
        End Set
    End Property

    'Propiedades de paginacion Historico de errores
    Public Property pageNumHist() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPagenumHis.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPagenumHis.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPagenumHis.Text = value
        End Set
    End Property
    Public Property PageSizeHist() As Int16
        Get
            If String.IsNullOrEmpty(Me.lblPageSizeHis.Text) Then
                'Return 25
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSizeHis.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSizeHis.Text = value
        End Set
    End Property


    'Informacion del empleado
    Protected Sub BindInfoEmpleado()

        Dim dtInfoEmpleado As New DataTable
        Try
            dtInfoEmpleado = General.getNovedadesTrabajador(txtCedula.Text, "DGT3", 1, 1)

            If dtInfoEmpleado.Rows.Count > 0 Then

                Me.LblCedula.Text = Me.formateaRNC_Cedula(dtInfoEmpleado.Rows(0)("cedula").ToString)
                Me.lblNSS.Text = formateaNSS(dtInfoEmpleado.Rows(0)("nss").ToString)
                Me.LblNombres.Text = dtInfoEmpleado.Rows(0)("nombre_completo").ToString
                tblInfoTrabajador.Visible = True
                Me.divInfoTrabajador.Visible = True
                UpdatePanelInfoTrabajador.Visible = True
                BindMovEmpleadoDGT3()
                BindMovEmpleadoDGT4()
                BindPlanillaEmpleadoDGT3()
                BindPlanillaEmpleadoDGT4()
                BindHistErrores()

            Else

                Me.divInfoTrabajador.Visible = False
                Me.tblInfoTrabajador.Visible = False

                Me.LblError.Visible = True
                LblError.Text = "No existen registros para esta busqueda"
            End If

            'dtInfoEmpleado = Nothing

        Catch ex As Exception
            Me.LblError.Visible = True
            Me.LblError.Text = Split(ex.Message, "|")(1)

        End Try

    End Sub

    'Movimientos DGT3
    Protected Sub BindMovEmpleadoDGT3()

        Dim dtInfoMovEmpleado As New DataTable
        Try
            dtInfoMovEmpleado = General.getNovedadesTrabajador(txtCedula.Text, "DGT3", pageNumMovDGT3, PageSizeMovDGT3)

            'Gridview movimiento DGT3
            If dtInfoMovEmpleado.Rows.Count > 0 Then
                Me.lblTotalRegistrosMovDGT3.Text = dtInfoMovEmpleado.Rows(0)("RECORDCOUNT")
                Me.gvMovDGT3.DataSource = dtInfoMovEmpleado
                Me.gvMovDGT3.DataBind()
                Me.setNavigationMovDGT3()
            Else

                Me.LblErrorMovDGT3.Visible = True
                LblErrorMovDGT3.Text = "No existen movimientos para el DGT3"
            End If
            dtInfoMovEmpleado = Nothing

        Catch ex As Exception
            Me.LblErrorMovDGT3.Visible = True
            Me.LblErrorMovDGT3.Text = ex.Message
        End Try

    End Sub

    'Movimientos DGT4
    Protected Sub BindMovEmpleadoDGT4()

        Dim dtInfoMovEmpleado As New DataTable
        Try
            dtInfoMovEmpleado = General.getNovedadesTrabajador(txtCedula.Text, "DGT4", pageNumMovDGT4, PageSizeMovDGT4)

            'Gridview movimiento DGT3
            If dtInfoMovEmpleado.Rows.Count > 0 Then
                Me.lblTotalRegistrosMovDGT4.Text = dtInfoMovEmpleado.Rows(0)("RECORDCOUNT")
                Me.gvMovDGT4.DataSource = dtInfoMovEmpleado
                Me.gvMovDGT4.DataBind()
                setNavigationMovDGT4()
            Else

                Me.LblErrorMovDGT4.Visible = True
                LblErrorMovDGT4.Text = "No existen movimientos para el DGT4"
            End If
            dtInfoMovEmpleado = Nothing

        Catch ex As Exception
            Me.LblErrorMovDGT4.Visible = True
            Me.LblErrorMovDGT4.Text = ex.Message
        End Try

    End Sub

    'Planillas DGT3 
    Protected Sub BindPlanillaEmpleadoDGT3()

        Dim dtInfoPlanilla As New DataTable
        Try
            dtInfoPlanilla = General.getPlanillaTrabajador(txtCedula.Text, "DGT3", pageNumDGT3, PageSizeDGT3)

            If dtInfoPlanilla.Rows.Count > 0 Then
                Me.lblTotalRegistrosDGT3.Text = dtInfoPlanilla.Rows(0)("RECORDCOUNT")
                Me.gvPlanillaDGT3.DataSource = dtInfoPlanilla
                Me.gvPlanillaDGT3.DataBind()
                Me.setNavigationDGT3()

            Else

                Me.LblErrorDGT3.Visible = True
                LblErrorDGT3.Text = "No existen registros de planillas para DGT3"
            End If
            dtInfoPlanilla = Nothing

        Catch ex As Exception
            Me.LblErrorDGT3.Visible = True
            Me.LblErrorDGT3.Text = ex.Message
        End Try

    End Sub

    'Planillas DGT4
    Protected Sub BindPlanillaEmpleadoDGT4()

        Dim dtInfoPlanilla As New DataTable
        Try
            dtInfoPlanilla = General.getPlanillaTrabajador(txtCedula.Text, "DGT4", pageNumDGT4, PageSizeDGT4)

            If dtInfoPlanilla.Rows.Count > 0 Then
                Me.lblTotalRegistrosDGT4.Text = dtInfoPlanilla.Rows(0)("RECORDCOUNT")
                Me.gvPlanillaDGT4.DataSource = dtInfoPlanilla
                Me.gvPlanillaDGT4.DataBind()
                Me.setNavigationDGT4()

            Else

                Me.lblErrorDGT4.Visible = True
                lblErrorDGT4.Text = "No existen registros de planillas para DGT4"
            End If
            dtInfoPlanilla = Nothing

        Catch ex As Exception
            Me.lblErrorDGT4.Visible = True
            Me.lblErrorDGT4.Text = ex.Message
        End Try

    End Sub

    'Historico de errores
    Protected Sub BindHistErrores()

        Dim dtInfoHistorial As New DataTable
        Try
            dtInfoHistorial = General.getHistoricoError(txtCedula.Text, pageNumHist, PageSizeHist)
            If dtInfoHistorial.Rows.Count > 0 Then
                Me.lblTotalRegistrosHis.Text = dtInfoHistorial.Rows(0)("RECORDCOUNT")
                Me.gvHistorial.DataSource = dtInfoHistorial
                Me.gvHistorial.DataBind()
                Me.setNavigationHis()

            Else

                Me.lblErrorHis.Visible = True
                lblErrorHis.Text = "No existen registros de errores para el empleado"


            End If
            dtInfoHistorial = Nothing

        Catch ex As Exception
            Me.lblErrorHis.Visible = True
            Me.lblErrorHis.Text = ex.Message
        End Try

    End Sub

    'Metodos de paginacion movimientos DGT3
    Private Sub setNavigationMovDGT3()

        Dim totalRecords As Integer = 0

        If IsNumeric(Me.lblTotalRegistrosMovDGT3.Text) Then
            totalRecords = CInt(Me.lblTotalRegistrosMovDGT3.Text)
        End If

        Dim totalPages As Double = Math.Ceiling(Convert.ToDouble(totalRecords) / PageSizeMovDGT3)

        If totalRecords = 1 Or totalPages = 0 Then
            totalPages = 1
        End If

        If PageSizeMovDGT3 > totalRecords Then
            PageSizeMovDGT3 = Int16.Parse(totalPages)
        End If

        Me.LblCurrentPageMovDGT3.Text = pageNumMovDGT3
        Me.lblTotalPagesMovDGT3.Text = totalPages

        If pageNumMovDGT3 = 1 Then
            Me.btnlnkFirstPageMovDGT3.Enabled = False
            Me.btnlnkPreviousPageMovDGT3.Enabled = False
        Else
            Me.btnlnkFirstPageMovDGT3.Enabled = True
            Me.btnlnkPreviousPageMovDGT3.Enabled = True
        End If

        If pageNumMovDGT3 = totalPages Then
            Me.btnLnkNextPageMovDGT3.Enabled = False
            Me.btnLnkLastPageMovDGT3.Enabled = False
        Else
            Me.btnLnkNextPageMovDGT3.Enabled = True
            Me.btnLnkLastPageMovDGT3.Enabled = True
        End If

    End Sub

    Protected Sub NavigationLink_ClickMovDGT3(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First"
                pageNumMovDGT3 = 1
            Case "Last"
                pageNumMovDGT3 = Convert.ToInt32(lblTotalPagesMovDGT3.Text)
            Case "Next"
                pageNumMovDGT3 = Convert.ToInt32(LblCurrentPageMovDGT3.Text) + 1
            Case "Prev"
                pageNumMovDGT3 = Convert.ToInt32(LblCurrentPageMovDGT3.Text) - 1
        End Select

        'Aqui ponemos el metodo que cargara la informacion'
        'Le enviamos DGT3 como tipo de planilla ya que este metodo se llamara siempre que sean movimientos
        'relacionados al DGT3
        BindMovEmpleadoDGT3()

    End Sub

    'Metodos de paginacion movimientos DGT4
    Private Sub setNavigationMovDGT4()

        Dim totalRecords As Integer = 0

        If IsNumeric(Me.lblTotalRegistrosMovDGT4.Text) Then
            totalRecords = CInt(Me.lblTotalRegistrosMovDGT4.Text)
        End If

        Dim totalPages As Double = Math.Ceiling(Convert.ToDouble(totalRecords) / PageSizeMovDGT4)

        If totalRecords = 1 Or totalPages = 0 Then
            totalPages = 1
        End If

        If PageSizeMovDGT4 > totalRecords Then
            PageSizeMovDGT4 = Int16.Parse(totalPages)
        End If

        Me.lblCurrentPageMovDGT4.Text = pageNumMovDGT4
        Me.lblTotalPagesMovDGT4.Text = totalPages

        If pageNumMovDGT4 = 1 Then
            Me.btnlnkFirstPageMovDGT4.Enabled = False
            Me.btnlnkPreviousPageMovDGT4.Enabled = False
        Else
            Me.btnlnkFirstPageMovDGT4.Enabled = True
            Me.btnlnkPreviousPageMovDGT4.Enabled = True
        End If

        If pageNumMovDGT4 = totalPages Then
            Me.btnLnkNextPageMovDGT4.Enabled = False
            Me.btnLnkLastPageMovDGT4.Enabled = False
        Else
            Me.btnLnkNextPageMovDGT4.Enabled = True
            Me.btnLnkLastPageMovDGT4.Enabled = True
        End If

    End Sub

   Protected Sub NavigationLink_ClickMovDGT4(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First"
                pageNumMovDGT4 = 1
            Case "Last"
                pageNumMovDGT4 = Convert.ToInt32(lblTotalPagesMovDGT4.Text)
            Case "Next"
                pageNumMovDGT4 = Convert.ToInt32(lblCurrentPageMovDGT4.Text) + 1
            Case "Prev"
                pageNumMovDGT4 = Convert.ToInt32(lblCurrentPageMovDGT4.Text) - 1
        End Select

        'Aqui ponemos el metodo que cargara la informacion'
        BindMovEmpleadoDGT4()

    End Sub

    'Metodos de paginacion planilla DGT3
    Private Sub setNavigationDGT3()

        Dim totalRecords As Integer = 0

        If IsNumeric(Me.lblTotalRegistrosDGT3.Text) Then
            totalRecords = CInt(Me.lblTotalRegistrosDGT3.Text)
        End If

        Dim totalPages As Double = Math.Ceiling(Convert.ToDouble(totalRecords) / PageSizeDGT3)

        If totalRecords = 1 Or totalPages = 0 Then
            totalPages = 1
        End If

        If PageSizeDGT3 > totalRecords Then
            PageSizeDGT3 = Int16.Parse(totalPages)
        End If

        Me.lblCurrentPageDGT3.Text = pageNumDGT3
        Me.lblTotalPagesDGT3.Text = totalPages

        If pageNumDGT3 = 1 Then
            Me.btnLnkFirstPageDGT3.Enabled = False
            Me.btnLnkPreviousPageDGT3.Enabled = False
        Else
            Me.btnLnkFirstPageDGT3.Enabled = True
            Me.btnLnkPreviousPageDGT3.Enabled = True
        End If

        If pageNumDGT3 = totalPages Then
            Me.btnLnkNextPageDGT3.Enabled = False
            Me.btnLnkLastPageDGT3.Enabled = False
        Else
            Me.btnLnkNextPageDGT3.Enabled = True
            Me.btnLnkLastPageDGT3.Enabled = True
        End If

    End Sub

    Protected Sub NavigationLink_ClickDGT3(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First"
                pageNumDGT3 = 1
            Case "Last"
                pageNumDGT3 = Convert.ToInt32(lblTotalPagesDGT3.Text)
            Case "Next"
                pageNumDGT3 = Convert.ToInt32(lblCurrentPageDGT3.Text) + 1
            Case "Prev"
                pageNumDGT3 = Convert.ToInt32(lblCurrentPageDGT3.Text) - 1
        End Select

        'Aqui ponemos el metodo que cargara la informacion'
        BindInfoEmpleado()

    End Sub

    '------------------------------------------------------------------------------------------
    'Metodos de paginacion planilla DGT4
    Private Sub setNavigationDGT4()

        Dim totalRecords As Integer = 0

        If IsNumeric(Me.lblTotalRegistrosDGT4.Text) Then
            totalRecords = CInt(Me.lblTotalRegistrosDGT4.Text)
        End If

        Dim totalPages As Double = Math.Ceiling(Convert.ToDouble(totalRecords) / PageSizeDGT4)

        If totalRecords = 1 Or totalPages = 0 Then
            totalPages = 1
        End If

        If PageSizeDGT4 > totalRecords Then
            PageSizeDGT4 = Int16.Parse(totalPages)
        End If

        Me.lblCurrentPageDGT4.Text = pageNumDGT4
        Me.lblTotalPagesDGT4.Text = totalPages

        If pageNumDGT4 = 1 Then
            Me.btnLnkFirstPageDGT4.Enabled = False
            Me.btnLnkPreviousPageDGT4.Enabled = False
        Else
            Me.btnLnkFirstPageDGT4.Enabled = True
            Me.btnLnkPreviousPageDGT4.Enabled = True
        End If

        If pageNumDGT4 = totalPages Then
            Me.btnLnkNextPageDGT4.Enabled = False
            Me.btnLnkLastPageDGT4.Enabled = False
        Else
            Me.btnLnkNextPageDGT4.Enabled = True
            Me.btnLnkLastPageDGT4.Enabled = True
        End If

    End Sub

    Protected Sub NavigationLink_ClickDGT4(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First"
                pageNumDGT4 = 1
            Case "Last"
                pageNumDGT4 = Convert.ToInt32(lblTotalPagesDGT4.Text)
            Case "Next"
                pageNumDGT4 = Convert.ToInt32(lblCurrentPageDGT4.Text) + 1
            Case "Prev"
                pageNumDGT4 = Convert.ToInt32(lblCurrentPageDGT4.Text) - 1
        End Select

        'Aqui ponemos el metodo que cargara la informacion'
        BindInfoEmpleado()

    End Sub


    'Metodos de paginacion Historico de errores
    Private Sub setNavigationHis()

        Dim totalRecords As Integer = 0

        If IsNumeric(Me.lblTotalRegistrosHis.Text) Then
            totalRecords = CInt(Me.lblTotalRegistrosHis.Text)
        End If

        Dim totalPages As Double = Math.Ceiling(Convert.ToDouble(totalRecords) / PageSizeHist)

        If totalRecords = 1 Or totalPages = 0 Then
            totalPages = 1
        End If

        If PageSizeHist > totalRecords Then
            PageSizeHist = Int16.Parse(totalPages)
        End If

        Me.lblCurrentPageHis.Text = pageNumHist
        Me.lblTotalPagesHis.Text = totalPages

        If pageNumHist = 1 Then
            Me.btnLnkFirstPageHis.Enabled = False
            Me.btnLnkPreviousPageHis.Enabled = False
        Else
            Me.btnLnkFirstPageHis.Enabled = True
            Me.btnLnkPreviousPageHis.Enabled = True
        End If

        If pageNumHist = totalPages Then
            Me.btnLnkNextPageHis.Enabled = False
            Me.btnLnkLastPageHis.Enabled = False
        Else
            Me.btnLnkNextPageHis.Enabled = True
            Me.btnLnkLastPageHis.Enabled = True
        End If

    End Sub

    Protected Sub NavigationLink_ClickHis(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First"
                pageNumHist = 1
            Case "Last"
                pageNumHist = Convert.ToInt32(lblTotalPagesHis.Text)
            Case "Next"
                pageNumHist = Convert.ToInt32(lblCurrentPageHis.Text) + 1
            Case "Prev"
                pageNumHist = Convert.ToInt32(lblCurrentPageHis.Text) - 1
        End Select

        'Aqui ponemos el metodo que cargara la informacion'
        BindHistErrores()

    End Sub

    '-----------------------------------------------------------------------------------------
    'Funciones de formato
    Protected Function formateaPeriodo(ByVal Periodo As Object) As String
        If Not IsDBNull(Periodo) Then
            Return Utilitarios.Utils.FormateaPeriodo(Periodo)
        Else
            Return String.Empty
        End If
    End Function

    Public Function formateaSalario(ByVal salario As String) As String
        Dim salFormatear As Double
        Dim res As String

        If Not IsNumeric(salario) Then
            Return salario
        Else
            salFormatear = CDbl(salario)
            res = String.Format("{0:c}", salFormatear)
            Return res
        End If
    End Function

    Protected Function formateaRNC_Cedula(ByVal rnc As Object) As Object

        If Not rnc Is DBNull.Value Then

            Return Utilitarios.Utils.FormatearRNCCedula(rnc.ToString)

        End If

        Return rnc

    End Function


    Protected Function formateaNSS(ByVal nss As String) As String
        Return Utilitarios.Utils.FormatearNSS(nss)
    End Function

    Protected Function formateaReferencia(ByVal nroReferencia As Object) As String
        If Not IsDBNull(nroReferencia) Then
            Return Utilitarios.Utils.FormateaReferencia(nroReferencia)
        Else
            Return String.Empty
        End If
    End Function

    '-----------------------------------------------------------------------------------------
    'Evento de boton principal. Busqueda de datos.
    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click

        BindInfoEmpleado()
    End Sub

    Protected Sub Tabs_ActiveTabChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles tbContainer.ActiveTabChanged

        Dim tab As String = CType(sender, AjaxControlToolkit.TabContainer).ActiveTab.HeaderText
        Try

            Select Case tab

                Case "Novedades DGT3"
                    ' Me.BindMovEmpleadoDGT3()
                Case "Novedades DGT4"
                    'Me.BindMovEmpleadoDGT4()
                Case "Planillas DGT3"
                    ' Me.BindPlanillaEmpleadoDGT3()
                Case "Planillas DGT4"
                    'Me.BindPlanillaEmpleadoDGT4()
                Case "Historial de errores"
                    'Me.BindHistErrores()

            End Select

        Catch ex As Exception
            Me.LblError.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub BtnLimpiar_Click(sender As Object, e As EventArgs) Handles BtnLimpiar.Click
        Response.Redirect("ConsultaDetalleTrabajador.aspx")
    End Sub
End Class
