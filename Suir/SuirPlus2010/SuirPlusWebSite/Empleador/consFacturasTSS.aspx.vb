Imports SuirPlus
Imports System.Data
Partial Class Empleador_consFacturasTSS
    Inherits BasePage

#Region "Miembros y Propiedades"

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

    Dim nro As String = String.Empty
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim sec As String = ""
        sec = Request("sec")
        sec = Trim(sec)
        sec = sec.ToLower


        nro = Request("nro")
        nro = Trim(nro)
        nro = nro.ToLower




        Select Case sec
            Case "encabezado"

                Me.ucNotEncTSS.Visible = True
                Me.ucNotEncTSS.NroReferencia = nro
                Me.ucNotEncTSS.isBotonesVisibles = True
                Me.ucNotEncTSS.MostrarEncabezado()

            Case "detalle"

                Dim tipofactura As String = New SuirPlus.Empresas.Facturacion.FacturaSS(nro).IDTipoFacura

                If tipofactura = "U" Then

                    Me.ctrlNotificacionTSSDetalleAuditoria.Visible = True
                    Me.ctrlNotificacionTSSDetalleAuditoria.NroReferencia = nro
                    Me.ctrlNotificacionTSSDetalleAuditoria.DataBind()

                ElseIf tipofactura = "L" Then

                    Me.ctrlNotificacionTSSDetalleSIPEN.Visible = True
                    Me.ctrlNotificacionTSSDetalleSIPEN.NroReferencia = nro
                    Me.ctrlNotificacionTSSDetalleSIPEN.DataBind()
                Else

                    Me.ctrlNotificacionTSSDetalle.Visible = True
                    Me.ctrlNotificacionTSSDetalle.NroReferencia = nro
                    Me.ctrlNotificacionTSSDetalle.DataBind()

                End If


            Case "dependiente"

                Me.ucDetalleDep.IdReferencia = nro
                ''Me.ucDetalleDep.ShowNomina = True
                Me.ucDetalleDep.DataBind()

            Case "ajuste"
                Me.pnlDetalleAjuste.Visible = True
                Me.ucDetalleAjuste1.PaginaEncabezado = "consFacturas.aspx?Tipo=SDSS&sec=encabezado&nro="
                Me.ucDetalleAjuste1.NroReferencia = nro
                Me.ucDetalleAjuste1.DataBind()
                Me.ucDetalleAjuste1.Visible = True

            Case "pagos"
                Me.pnPagosARS.Visible = True
                Mostrar_Datos()

            Case Else
                Response.Redirect("consNotificaciones.aspx")
        End Select

    End Sub


    Private Sub Mostrar_Datos()
        Dim dt As New DataTable
        Try
            dt = Ars.Consultas.getPagosNoReferencia(nro, Me.pageNum, Me.PageSize)

            If dt.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
                gvDetallesARS.DataSource = dt
                setNavigation()
            Else
                gvDetallesARS.DataSource = Nothing
                Me.lblMensaje.Text = "No existen registro para este Número de Referencia"
                TABLE1.Visible = False
                UcExportarExcel.Visible = False
            End If
            gvDetallesARS.DataBind()

            dt = Nothing
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
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
        Mostrar_Datos()
    End Sub

    Protected Sub UcExp_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles UcExportarExcel.ExportaExcel
        Dim dt As New DataTable
        dt = Ars.Consultas.getPagosNoReferencia(nro, 1, lblTotalRegistros.Text)

        If dt.Rows.Count > 0 Then
            dt.Columns.Remove("recordcount")
            dt.Columns.Remove("num")

            UcExportarExcel.FileName = nro & ".xls"
            UcExportarExcel.DataSource = dt
        End If
    End Sub
End Class
