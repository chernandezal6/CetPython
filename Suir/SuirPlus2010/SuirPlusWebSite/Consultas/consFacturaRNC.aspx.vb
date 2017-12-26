Imports SuirPlus
Imports System.Data
Imports System.Collections.Generic

Partial Class Consultas_consFacturaRNC
    Inherits BasePage

#Region "Miembros y Propiedades"

    Private tipoFactura As Empresas.Facturacion.Factura.eConcepto

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

    Dim nomina As Integer = Nothing
    Public Shared Tabs As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Me.IsPostBack Then
            cargaInicial()
            cargarFromQS()
        End If

        Me.txtRnc.Focus()

    End Sub

    Private Sub cargaInicial()

        'Cargamos los estatus de la factura
        Me.drpEstatus.DataTextField = "Descripcion"
        Me.drpEstatus.DataValueField = "Status"
        Me.drpEstatus.DataSource = Empresas.Facturacion.Factura.getStatusFacturas
        Me.drpEstatus.DataBind()

        'Cargamos los conceptos
        Me.drpConcepto.DataSource = Empresas.Facturacion.Factura.getConceptos
        Me.drpConcepto.DataTextField = "Concepto"
        Me.drpConcepto.DataValueField = "Valor"
        Me.drpConcepto.DataBind()

    End Sub

    Private Sub cargarFromQS()

        'Verificamos si viene por Querystring el parámetro del RNC
        If Not String.IsNullOrEmpty(Request("rnc")) Then

            Me.txtRnc.Text = Request("rnc")
            If Me.drpConcepto.Items.FindByValue(Request("tipo")) IsNot Nothing Then
                Me.drpConcepto.SelectedValue = Me.drpConcepto.Items.FindByValue(Request("tipo")).Value

                If Request("tipo") = "TSS" Then
                    'Si el tipo de consulta es TSS verificamos el parametro de la nomina o
                    'traemos todos los registros.
                    If Not Request("nom") = String.Empty Then
                        Me.bindNominas()
                        If Me.drpNominas.Items.FindByValue(Request("nom")) IsNot Nothing Then
                            Me.drpNominas.SelectedValue = Request("nom")
                        End If
                    Else
                        bindNominas()
                        Me.drpNominas.SelectedValue = "6321"
                    End If
                End If

            End If

            If Not Request("status") = String.Empty Then
                If Me.drpEstatus.Items.FindByValue(Request("status")) IsNot Nothing Then
                    Me.drpEstatus.SelectedValue = Request("status")
                End If
            End If

            If Not Request("pageNum") = String.Empty Then
                Me.pageNum = Request("pageNum")
            Else
                Me.pageNum = 1
            End If

            Me.PageSize = BasePage.PageSize
            Me.lblTotalRegistros.Text = 0
            cargaDatosEmpleador()

        End If

    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        Try
            If String.IsNullOrEmpty(txtRnc.Text) Then
                Me.lblMsg.Text = "Debe específicar un RNC/Cédula"
                Exit Sub
            End If

            Me.pageNum = 1
            Me.PageSize = BasePage.PageSize
            Me.lblTotalRegistros.Text = 0

            cargaDatosEmpleador()
            Me.lblMsg.Text = String.Empty

            upNotificaciones.Update()
            upEncabezado.Update()
            up.Update()
        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
        End Try


    End Sub

    Protected Sub txtRnc_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        If Me.drpNominas.Items.Count > 0 Then
            If Me.txtRnc.Text <> Session("cnsFacRNCBuscado") Then bindNominas()
        Else
            bindNominas()
        End If

    End Sub

    Private Sub cargaDatosEmpleador()

        Select Case Me.drpConcepto.SelectedValue
            Case "TSS"
                Me.tipoFactura = Empresas.Facturacion.Factura.eConcepto.SDSS
            Case "ISR"
                Me.tipoFactura = Empresas.Facturacion.Factura.eConcepto.ISR
            Case "IR17"
                Me.tipoFactura = Empresas.Facturacion.Factura.eConcepto.IR17
            Case "INF"
                Me.tipoFactura = Empresas.Facturacion.Factura.eConcepto.INF
            Case "MDT"
                Me.tipoFactura = Empresas.Facturacion.Factura.eConcepto.MDT

        End Select

        Try


            If Not Me.drpNominas.SelectedValue = String.Empty Then
                nomina = CInt(Me.drpNominas.SelectedValue)
            End If
            'Recibimos nuestra lista de string con la informacion necesaria para llenar el encabezado o resumen.
            Dim DatosEmp As List(Of String) = Empresas.Facturacion.Factura.getTotalesNotificacion(tipoFactura, Me.txtRnc.Text.Trim, nomina, drpEstatus.SelectedValue)

            If DatosEmp.Count > 0 Then

                'Llenamos la informacion del encabezado y el grid
                Me.pnlResumen.Visible = True
                Me.lnkRazonSocial.Text = DatosEmp.Item(0)
                Me.lnkRazonSocial.NavigateUrl = "consEmpleador.aspx?rnc=" & txtRnc.Text

                If DatosEmp.Item(1).ToString() = "null" Then
                    Me.lnkNombreComercial.Text = "N/A"
                Else
                    Me.lnkNombreComercial.Text = DatosEmp.Item(1).ToString
                End If

                Me.lnkNombreComercial.NavigateUrl = "consEmpleador.aspx?rnc=" & txtRnc.Text

                Me.lblTotalRef.Text = DatosEmp.Item(2)
                Me.lblImporte.Text = FormatNumber(DatosEmp.Item(3), 2)
                Me.lblRecargo.Text = FormatNumber(DatosEmp.Item(4), 2)
                Me.lblIntereses.Text = FormatNumber(DatosEmp.Item(5), 2)
                Me.lblTotalGeneral.Text = "RD$ " & FormatNumber(DatosEmp.Item(6), 2)
                Me.lblEstatus.Text = Me.drpEstatus.SelectedItem.Text
                Me.lblTipoRef.Text = Me.drpConcepto.SelectedItem.Text
                Me.bindGrid(False)

            Else
                ' Me.lblMsg.Text = "No se encontró registro(s)"
                'Me.pnlResumen.Visible = False
                'Me.gvNotificaciones.DataSource = Nothing
                'Me.gvNotificaciones.DataBind()
                'tcNp.Visible = False
                Throw New Exception("No se encontró registro(s)")
            End If
        Catch ex As Exception

            Me.pnlResumen.Visible = False
            Me.pnlNavigation.Visible = False
            Me.gvNotificaciones.DataSource = Nothing
            Me.gvNotificaciones.DataBind()
            upNotificaciones.Update()
            upEncabezado.Update()
            up.Update()
            tcNp.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())

            Me.lblMsg.Text = ex.Message

        End Try

        ' upEncabezado.Update()

    End Sub

    Protected Sub bindGrid(ByVal IsPaging As Boolean)

        Select Case Me.drpConcepto.SelectedValue
            Case "TSS"
                Me.tipoFactura = Empresas.Facturacion.Factura.eConcepto.SDSS
            Case "ISR"
                Me.tipoFactura = Empresas.Facturacion.Factura.eConcepto.ISR
            Case "IR17"
                Me.tipoFactura = Empresas.Facturacion.Factura.eConcepto.IR17
            Case "INF"
                Me.tipoFactura = Empresas.Facturacion.Factura.eConcepto.INF
            Case "MDT"
                Me.tipoFactura = Empresas.Facturacion.Factura.eConcepto.MDT

        End Select

        If Not Me.drpNominas.SelectedValue = String.Empty Then
            nomina = CInt(Me.drpNominas.SelectedValue)
        End If

        Dim dt As Data.DataTable = Empresas.Facturacion.Factura.getConsultaNotificaionesPorRNC(tipoFactura, txtRnc.Text, nomina, drpEstatus.SelectedValue, PageSize, pageNum)
        If dt.Rows.Count > 0 Then
            tcNp.Visible = True


            If Not IsPaging Then
                'Cargando las NP por años en el tabpanel
                Dim ano As Integer
                Dim anoactual As Integer = 1
                For Each dr As DataRow In dt.Rows
                    ano = Convert.ToInt32(dr("periodo_factura").ToString().Substring(3, 4))

                    If anoactual <> ano Then
                        Dim tp As New AjaxControlToolkit.TabPanel
                        tp.HeaderText = ano.ToString()

                        Dim gv As New GridView
                        Dim dv As DataView = dt.DefaultView

                        AddHandler gv.RowDataBound, New GridViewRowEventHandler(AddressOf gvNotificaciones_RowDataBound)

                        gv.AutoGenerateColumns = False
                        gv.CssClass = "gridBorder"
                        gv.SelectedRowStyle.CssClass = "listSelItem"
                        gv.AlternatingRowStyle.CssClass = "listAltItem"
                        gv.RowStyle.CssClass = "listItem"
                        gv.HeaderStyle.CssClass = "listheadermultiline"
                        gv.FooterStyle.CssClass = "listFooterItem"

                        For Each column As DataControlField In gvNotificaciones.Columns
                            gv.Columns.Add(column)
                        Next

                        dv.RowFilter = "SUBSTRING(PERIODO_FACTURA,4,4) = '" & ano & "'"

                        gv.DataSource = dv
                        gv.DataBind()

                        tp.Controls.Add(gv)
                        tcNp.Tabs.Add(tp)
                        anoactual = ano
                        Tabs = Tabs + 1
                    End If
                Next
            End If


            'Cargando las NP sin filtro
            dt.DefaultView.RowFilter = ""
            If dt.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
                Me.gvNotificaciones.DataSource = dt
                Me.gvNotificaciones.DataBind()
                Me.pnlNavigation.Visible = True
            Else
                Me.gvNotificaciones.DataSource = Nothing
                Me.gvNotificaciones.DataBind()
                Me.pnlNavigation.Visible = False
            End If

            setNavigation()
            Me.upNotificaciones.Update()
            Me.lblMsg.Text = String.Empty
        Else
            tcNp.Visible = False
            Me.lblMsg.Text = "No hay data para mostrar"
            Me.gvNotificaciones.DataSource = Nothing
            Me.gvNotificaciones.DataBind()
            Me.pnlNavigation.Visible = False
            '  Exit Sub
        End If
    End Sub

    Protected Sub bindNominas()

        Me.drpNominas.Items.Clear()
        If Regex.IsMatch(Me.txtRnc.Text, "^(\d{9}|\d{11})$") Then
            If Me.drpConcepto.SelectedValue = "TSS" Then

                Dim ds As Data.DataSet = Nothing
                ds = Empresas.Nomina.getNominaPorRNC(Me.txtRnc.Text)
                Me.drpNominas.DataValueField = "id_nomina"
                Me.drpNominas.DataTextField = "nomina_des"

                If ds.Tables.Count > 0 Then
                    Me.drpNominas.DataSource = ds
                    Me.drpNominas.DataBind()
                Else
                    Me.drpNominas.DataSource = Nothing
                    Me.drpNominas.DataBind()
                End If

                Me.drpNominas.Items.Insert(0, New ListItem("<-- Todas -->", "6321"))

            End If
        End If

        Session("cnsFacRNCBuscado") = Me.txtRnc.Text

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click

        Me.txtRnc.Text = String.Empty
        Me.drpConcepto.SelectedIndex = 0
        Me.drpNominas.Items.Clear()
        Me.drpEstatus.SelectedIndex = 0
        Me.pnlResumen.Visible = False
        Me.gvNotificaciones.DataSource = Nothing
        Me.gvNotificaciones.DataBind()
        Me.pnlnavigation.visible = False
        upEncabezado.Update()
        upNotificaciones.Update()
        tcNp.Visible = False

    End Sub

    Protected Sub drpConcepto_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpConcepto.SelectedIndexChanged

        If drpConcepto.SelectedValue = "TSS" Then
            Me.trNomina.Visible = True
        Else
            Me.trNomina.Visible = False
        End If

    End Sub

    Protected Sub gvNotificaciones_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNotificaciones.RowDataBound

        If (e.Row.RowType = DataControlRowType.DataRow) Then

            If e.Row.Cells(2).Text.Length > 20 Then
                e.Row.Cells(2).Text = Left(e.Row.Cells(2).Text, 20) & " ..."
            End If

            Select Case Me.drpConcepto.SelectedValue
                Case "TSS"
                    gvNotificaciones.Columns(1).Visible = True
                    gvNotificaciones.Columns(2).Visible = True
                    gvNotificaciones.Columns(3).Visible = True
                    gvNotificaciones.Columns(4).Visible = True
                    gvNotificaciones.Columns(7).Visible = True
                    gvNotificaciones.Columns(9).Visible = True
                    gvNotificaciones.Columns(10).Visible = True
                    gvNotificaciones.Columns(11).Visible = True
                    gvNotificaciones.Columns(13).Visible = True
                    e.Row.Cells(13).Text = "<a href=""consFacturaRNCDetalle.aspx?rnc=" & Me.txtRnc.Text & "&nro=" & e.Row.Cells(0).Text & _
                    "&tipo=" & Me.drpConcepto.SelectedValue & "&nom=" & Me.drpNominas.SelectedValue & _
                    "&status=" & Me.drpEstatus.SelectedValue & "&page=" & Me.pageNum & """>" & "[Ver]" & "</a>"
                    e.Row.Cells(0).Text = "<a href=""consFactura.aspx?tipo=" & Me.drpConcepto.SelectedValue & "&nro=" & e.Row.Cells(0).Text & """>" & e.Row.Cells(0).Text & "</a>"

                Case "ISR"
                    gvNotificaciones.Columns(1).Visible = True
                    gvNotificaciones.Columns(2).Visible = True
                    gvNotificaciones.Columns(3).Visible = False
                    gvNotificaciones.Columns(4).Visible = False
                    gvNotificaciones.Columns(7).Visible = False
                    gvNotificaciones.Columns(9).Visible = False
                    gvNotificaciones.Columns(10).Visible = False
                    gvNotificaciones.Columns(11).Visible = False
                    gvNotificaciones.Columns(13).Visible = False
                    e.Row.Cells(0).Text = "<a href=""consFactura.aspx?tipo=" & Me.drpConcepto.SelectedValue & "&nro=" & e.Row.Cells(0).Text & """>" & e.Row.Cells(0).Text & "</a>"
                Case "IR17"
                    gvNotificaciones.Columns(1).Visible = False
                    gvNotificaciones.Columns(2).Visible = False
                    gvNotificaciones.Columns(3).Visible = False
                    gvNotificaciones.Columns(4).Visible = False
                    gvNotificaciones.Columns(7).Visible = False
                    gvNotificaciones.Columns(9).Visible = False
                    gvNotificaciones.Columns(10).Visible = False
                    gvNotificaciones.Columns(11).Visible = False
                    gvNotificaciones.Columns(13).Visible = False
                    e.Row.Cells(0).Text = "<a href=""consFactura.aspx?tipo=" & Me.drpConcepto.SelectedValue & "&nro=" & e.Row.Cells(0).Text & """>" & e.Row.Cells(0).Text & "</a>"
                Case "INF"
                    gvNotificaciones.Columns(1).Visible = True
                    gvNotificaciones.Columns(2).Visible = True
                    gvNotificaciones.Columns(3).Visible = False
                    gvNotificaciones.Columns(4).Visible = False
                    gvNotificaciones.Columns(7).Visible = False
                    gvNotificaciones.Columns(9).Visible = False
                    gvNotificaciones.Columns(10).Visible = False
                    gvNotificaciones.Columns(11).Visible = False
                    gvNotificaciones.Columns(13).Visible = False
                    e.Row.Cells(0).Text = "<a href=""consFactura.aspx?tipo=" & Me.drpConcepto.SelectedValue & "&nro=" & e.Row.Cells(0).Text & """>" & e.Row.Cells(0).Text & "</a>"
                Case "MDT"
                    gvNotificaciones.Columns(1).Visible = True
                    gvNotificaciones.Columns(2).Visible = True
                    gvNotificaciones.Columns(3).Visible = True
                    gvNotificaciones.Columns(4).Visible = True
                    gvNotificaciones.Columns(7).Visible = True
                    gvNotificaciones.Columns(9).Visible = True
                    gvNotificaciones.Columns(10).Visible = True
                    gvNotificaciones.Columns(11).Visible = True
                    gvNotificaciones.Columns(13).Visible = True
                    e.Row.Cells(13).Text = "<a href=""consFacturaRNCDetalle.aspx?rnc=" & Me.txtRnc.Text & "&nro=" & e.Row.Cells(0).Text & _
                    "&tipo=" & Me.drpConcepto.SelectedValue & "&nom=" & Me.drpNominas.SelectedValue & _
                    "&status=" & Me.drpEstatus.SelectedValue & "&page=" & Me.pageNum & """>" & "[Ver]" & "</a>"
                    e.Row.Cells(0).Text = "<a href=""consFactura.aspx?tipo=" & Me.drpConcepto.SelectedValue & "&nro=" & e.Row.Cells(0).Text & """>" & e.Row.Cells(0).Text & "</a>"
            End Select

        End If

    End Sub

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        For i As Integer = 0 To Tabs
            Dim tp As New AjaxControlToolkit.TabPanel
            tp.Visible = False
            tcNp.Tabs.Add(tp)
        Next
    End Sub

#Region "Grid Navigation"

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

        bindGrid(True)

    End Sub

#End Region

End Class
