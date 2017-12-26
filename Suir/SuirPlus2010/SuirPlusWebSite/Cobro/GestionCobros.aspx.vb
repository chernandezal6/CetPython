Imports SuirPlus
Imports System.Data
Partial Class Cobro_GestionCobros
    Inherits BasePage

    Dim i As Integer = 0
    Dim monto As Double = 0.0

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
            Return Int16.Parse(Me.lblPageSize2.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSize2.Text = value
        End Set
    End Property

    Protected Sub Cobro_GestionCobros_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            getUsuariosCartera()
            getPeriodos()
        End If

    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        Try
            If ddlUsuariosCartera.SelectedValue <> String.Empty Then
                bindGestionCobros()
            Else
                Throw New Exception("Usuario inválido.")
            End If
        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
        End Try


    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("GestionCobros.aspx")
    End Sub

    Protected Sub getUsuariosCartera()
        Dim dt As New DataTable
        ddlUsuariosCartera.DataSource = Legal.Cobro.getUsuariosCarteras()
        ddlUsuariosCartera.DataTextField = "NombreUsuario"
        ddlUsuariosCartera.DataValueField = "IdUsuario"
        ddlUsuariosCartera.DataBind()
        'ddlUsuariosCartera.Items.Insert(0, New ListItem("Seleccione", ""))
        'ddlUsuariosCartera.SelectedIndex = 0

    End Sub

    Protected Sub getPeriodos()
        'periodoDesde
        ddlPeriodoDesde.DataSource = generarPeridos(Now().Year)
        ddlPeriodoDesde.DataTextField = "Periodo"
        ddlPeriodoDesde.DataValueField = "Periodo"
        ddlPeriodoDesde.DataBind()
        'ddlPeriodoDesde.Items.Insert(0, New ListItem("Seleccione", ""))
        'ddlPeriodoDesde.SelectedIndex = 0
    End Sub

    Protected Sub bindGestionCobros()
        Dim dt As New DataTable

        Try
            dt = Legal.Cobro.getGestionCobros(ddlUsuariosCartera.SelectedValue, ddlPeriodoDesde.SelectedValue, ddlPeriodoHasta.SelectedValue)

            If dt.Rows.Count > 0 Then
                Me.pnlInfoGestionCobros.Visible = True
                Me.pnlDetGestionCobros.Visible = False
                Me.pnlNavegacion2.Visible = False
                trPeriodoHasta.Visible = True
                Me.lblMensaje.Visible = False
                gvInfoGestionCobros.DataSource = dt
                gvInfoGestionCobros.DataBind()
            Else
                Me.pnlInfoGestionCobros.Visible = False
                Me.pnlDetGestionCobros.Visible = False
                Me.pnlNavegacion2.Visible = False
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "No existen registros"
                trPeriodoHasta.Visible = False
                gvInfoGestionCobros.DataSource = Nothing
                gvInfoGestionCobros.DataBind()

            End If

        Catch ex As Exception
            Throw ex

        End Try

    End Sub

    Protected Sub bindDetGestionCobros(ByVal ParamDetalle As String)
        Dim dt2 As New DataTable
        Session.Remove("ParamDetalle")


        Me.lblCartera.Text = Split(ParamDetalle, "|")(0)
        Me.lblUsuario.Text = Split(ParamDetalle, "|")(1)
        Me.lblPeriodo.Text = Split(ParamDetalle, "|")(2)

        Session("ParamDetalle") = ParamDetalle

        Try
            dt2 = Legal.Cobro.getDetGestionCobros(CInt(Me.lblCartera.Text), Me.lblUsuario.Text, CInt(Me.lblPeriodo.Text), pageNum2, PageSize2)
            If dt2.Rows.Count > 0 Then

                Me.pnlDetGestionCobros.Visible = True
                Me.pnlNavegacion2.Visible = True
                Me.pnlInfoGestionCobros.Visible = False
                Me.lblTotalRegistros2.Text = dt2.Rows(0)("RECORDCOUNT")
                Me.lblMensaje.Visible = False
                trPeriodoHasta.Visible = True
                gvDetGestionCobros.DataSource = dt2
                gvDetGestionCobros.DataBind()


            Else
                Me.pnlDetGestionCobros.Visible = False
                Me.pnlNavegacion2.Visible = False
                Me.pnlInfoGestionCobros.Visible = False
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "No existen registros"
                trPeriodoHasta.Visible = False
                gvDetGestionCobros.DataSource = Nothing
                gvDetGestionCobros.DataBind()
            End If

            dt2 = Nothing
            setNavigation2()

        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message

        End Try


    End Sub

    Protected Sub gvInfoGestionCobros_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvInfoGestionCobros.RowCommand
        If e.CommandName = "VerDetalle" Then

            Me.pageNum2 = 1
            Me.PageSize2 = BasePage.PageSize

            bindDetGestionCobros(e.CommandArgument)

        End If
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

    Protected Sub NavigationLink_Click2(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First"
                pageNum2 = 1
            Case "Last"
                pageNum2 = Convert.ToInt32(lblTotalPages2.Text)
            Case "Next"
                pageNum2 = Convert.ToInt32(lblCurrentPage2.Text) + 1
            Case "Prev"
                pageNum2 = Convert.ToInt32(lblCurrentPage2.Text) - 1
        End Select

        bindDetGestionCobros(Session("ParamDetalle"))

    End Sub

    Protected Sub lbVolverEncabezado_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbVolverEncabezado.Click
        Me.btnBuscar_Click(Nothing, Nothing)
    End Sub

    Protected Function generarPeridos(ByVal ano As String) As DataTable

        Session.Remove("UltimoPeriodo")
        Dim i As Integer = 0
        Dim mes As String = String.Empty
        Dim m As Integer
        Dim Periodo As String = String.Empty
        Dim anoPeriodo As Integer
        Dim arrAnoPeriodo() As Integer = Nothing
        ReDim arrAnoPeriodo(4)

        ' creamos el DataTable.
        Dim dt As New DataTable
        ' creamos la columna en el DataTable.
        dt.Columns.Add("Periodo", GetType(String))

        If ano <> String.Empty Then
            'asignamos de valores el arreglo
            arrAnoPeriodo(0) = ano
            arrAnoPeriodo(1) = ano - 1
            arrAnoPeriodo(2) = ano - 2
            arrAnoPeriodo(3) = ano - 3
            arrAnoPeriodo(4) = ano - 4


            'recorremos el arreglo y concatenamos los doce periodo correpondientes por cada ano
            For Each anoPeriodo In arrAnoPeriodo
                ano = anoPeriodo
                'identificamos los periodos transcurridos del ano en curso
                If ano = Now().Year Then
                    m = Now().Month
                Else
                    m = 12
                End If

                For i = 1 To m
                    If i < 10 Then
                        mes = "0" & i
                    Else
                        mes = i
                    End If
                    Periodo = ano & mes
                    'llenamos el datatable anteriormente declarado, para guardar los periodos generados
                    dt.Rows.Add(Periodo)
                    dt.DefaultView.Sort = "Periodo Desc"
                Next
            Next

        End If

        Session("UltimoPeriodo") = Periodo
        Return dt
    End Function

    Protected Function generarLimitePeridos(ByVal periodoSeleccionado As String, ByVal ultimoPeriodo As String) As DataTable

        Dim i As Integer = 0
        Dim x As Integer = 0
        Dim mes As String = String.Empty
        Dim m As Integer
        Dim Periodo As String = String.Empty
        Dim arrAnoPeriodo() As Integer = Nothing
        ReDim arrAnoPeriodo(4)

        ' creamos el DataTable.
        Dim dt As New DataTable
        ' creamos la columna en el DataTable.
        dt.Columns.Add("Periodo", GetType(String))

        Dim ano As String = periodoSeleccionado.Substring(0, 4)

        'asignamos de valores el arreglo
        arrAnoPeriodo(0) = ano
        arrAnoPeriodo(1) = ano + 1
        arrAnoPeriodo(2) = ano + 2
        arrAnoPeriodo(3) = ano + 3
        arrAnoPeriodo(4) = ano + 4


        For x = 0 To arrAnoPeriodo.LongCount
            If x > 4 Then Exit For

            If arrAnoPeriodo(x) <= Now().Year Then
                ano = arrAnoPeriodo(x)

                'determinamos los periodos faltantes hasta el periodo actual
                If (ano = periodoSeleccionado.Substring(0, 4)) And (ano = Now().Year) Then
                    m = Now().Month
                    For i = CInt(periodoSeleccionado.Substring(4, 2)) To m
                        If i < 10 Then
                            mes = "0" & i
                        Else
                            mes = i
                        End If
                        Periodo = ano & mes
                        'llenamos el datatable anteriormente declarado, para guardar los periodos generados
                        dt.Rows.Add(Periodo)
                        dt.DefaultView.Sort = "Periodo Desc"
                    Next

                ElseIf ano = periodoSeleccionado.Substring(0, 4) Then
                    m = periodoSeleccionado.Substring(4, 2)
                    For i = m To 12
                        If i < 10 Then
                            mes = "0" & i
                        Else
                            mes = i
                        End If
                        Periodo = ano & mes
                        'llenamos el datatable anteriormente declarado, para guardar los periodos generados
                        dt.Rows.Add(Periodo)
                        dt.DefaultView.Sort = "Periodo Desc"
                    Next
                ElseIf ano = Now().Year Then
                    m = Now().Month
                    For i = 1 To m
                        If i < 10 Then
                            mes = "0" & i
                        Else
                            mes = i
                        End If
                        Periodo = ano & mes
                        'llenamos el datatable anteriormente declarado, para guardar los periodos generados
                        dt.Rows.Add(Periodo)
                        dt.DefaultView.Sort = "Periodo Desc"
                    Next
                Else
                    m = 1
                    For i = m To 12
                        If i < 10 Then
                            mes = "0" & i
                        Else
                            mes = i
                        End If
                        Periodo = ano & mes
                        'llenamos el datatable anteriormente declarado, para guardar los periodos generados
                        dt.Rows.Add(Periodo)
                        dt.DefaultView.Sort = "Periodo Desc"
                    Next
                End If
            Else
                Exit For
            End If

        Next
        
        Return dt
    End Function

    Protected Sub ucExportarExcel1_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel

        Dim dtExportar As New DataTable

        'cargamos el datatable con la información a exportar a excel
        dtExportar = Legal.Cobro.getDetGestionCobros(CInt(Me.lblCartera.Text), Me.lblUsuario.Text, CInt(Me.lblPeriodo.Text), 1, 9999)

        'quitamos las columnas que no necesitamos del datatable
        dtExportar.Columns.Remove("RECORDCOUNT")
        dtExportar.Columns.Remove("NUM")

        'procedemos a exportar a excel con el nombre del archivo customisado
        ucExportarExcel1.FileName = "Reporte Gestión Cobros.xls"
        ucExportarExcel1.DataSource = dtExportar



    End Sub

    Protected Sub ddlPeriodoDesde_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPeriodoDesde.SelectedIndexChanged
        pnlInfoGestionCobros.Visible = False


        If ddlPeriodoDesde.SelectedValue <> "" Then
            trPeriodoHasta.Visible = True
            'periodoHasta
            ddlPeriodoHasta.DataSource = generarLimitePeridos(ddlPeriodoDesde.SelectedValue, Session("UltimoPeriodo"))
            ddlPeriodoHasta.DataTextField = "Periodo"
            ddlPeriodoHasta.DataValueField = "Periodo"
            ddlPeriodoHasta.DataBind()
            ddlPeriodoHasta.Items.Insert(0, New ListItem("Seleccione", ""))
        Else
            trPeriodoHasta.Visible = False
            'periodoHasta
            ddlPeriodoHasta.DataSource = Nothing
            ddlPeriodoHasta.DataTextField = "Periodo"
            ddlPeriodoHasta.DataValueField = "Periodo"
            ddlPeriodoHasta.DataBind()
            ddlPeriodoHasta.Items.Insert(0, New ListItem("Seleccione", ""))
        End If

    End Sub

    Protected Sub gvInfoGestionCobros_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvInfoGestionCobros.RowDataBound


        If e.Row.RowType = DataControlRowType.DataRow Then
            i = i + 1
            lblcantRegistros.Text = i
            monto = monto + CDbl(e.Row.Cells(6).Text.Replace("&nbsp;", "0"))
            lblMontoTotal.Text = System.String.Format("{0:c}", monto)

        End If

    End Sub
End Class
