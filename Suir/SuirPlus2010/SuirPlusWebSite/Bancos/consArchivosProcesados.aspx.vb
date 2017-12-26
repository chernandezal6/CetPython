Imports System
Imports System.Data
Imports SuirPlus.Bancos


Partial Class Bancos_consArchivosProcesados
    Inherits BasePage
    Dim NoEnvio As String = String.Empty

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

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        'validamos los parametros
        Try

            If (Me.txtNoEnvio.Text = String.Empty) And (Me.txtDesde.Text = String.Empty) And (Me.txtHasta.Text = String.Empty) Then
                Me.divArchivos.Visible = False
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "Digite un criterio de busqueda correctamente."
                Exit Sub
            Else
                Me.divArchivos.Visible = True
            End If

            If (Me.txtDesde.Text <> String.Empty And Me.txtHasta.Text = String.Empty) Or (Me.txtDesde.Text = String.Empty And Me.txtHasta.Text <> String.Empty) Then
                Me.divArchivos.Visible = False
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "La fecha inicial y la fecha final son requeridas."
                Exit Sub
            Else
                Me.divArchivos.Visible = True
            End If

            If Not (Me.txtDesde.Text = String.Empty) And Not (Me.txtHasta.Text = String.Empty) Then
                If (CDate(Me.txtDesde.Text)) > (CDate(Me.txtHasta.Text)) Then
                    Me.divArchivos.Visible = False
                    Me.lblMensaje.Visible = True
                    Me.lblMensaje.Text = "La fecha inicial debe ser menor a la fecha final."
                    Exit Sub
                Else
                    Me.divArchivos.Visible = True
                End If
            End If
            Me.pageNum = 1
            Me.PageSize = BasePage.PageSize
            CargarArchivos()


        Catch ex As Exception
            Me.divArchivos.Visible = False
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "La fecha inicio y la fecha final son requeridas correctamente. " & ex.Message

        End Try

    End Sub
    Protected Sub CargarArchivos()
        Dim dt As New DataTable
        Dim NoEnvio As String = String.Empty
        Me.dgError.DataSource = Nothing
        Me.dgError.DataBind()
        Me.pnlResultado.Visible = False

        Try
            dt = SuirPlus.Bancos.Dgii.getArchivosDGII(Me.txtNoEnvio.Text, Me.txtDesde.Text, Me.txtHasta.Text, Me.UsrIDEntidadRecaudadora, Me.pageNum, PageSize)
            If dt.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
                Me.divArchivos.Visible = True
                Me.gvArchivos.DataSource = dt
                Me.gvArchivos.DataBind()
                Me.lblMensaje.Visible = False
                Me.pnlNavigation.Visible = True
                setNavigation()
            Else
                Me.pnlNavigation.Visible = False
                Me.divArchivos.Visible = False
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "No existen registros para esta busqueda."
            End If
        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message

        End Try
        dt = Nothing
    End Sub

#Region "Paginación"

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

        CargarArchivos()

    End Sub

#End Region

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.Response.Redirect("consArchivosProcesados.aspx")
    End Sub

    Protected Sub gvArchivos_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvArchivos.RowCommand
        Dim idRecepcion As Integer
        If e.CommandArgument <> String.Empty Then
            idRecepcion = Convert.ToInt32(e.CommandArgument)
            If e.CommandName = "status" Then
                    ArchivosError(CInt(idRecepcion))
            End If
        End If
    End Sub

    Protected Sub gvArchivos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvArchivos.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then

            If e.Row.Cells(3).Text.Equals("No procesado") Or e.Row.Cells(3).Text.Equals("Rechazado") Then

                CType(e.Row.Cells(4).FindControl("lbDetalleRechazo"), LinkButton).Visible = True
            Else

                CType(e.Row.Cells(4).FindControl("lbDetalleRechazo"), LinkButton).Visible = False
            End If

        End If
    End Sub

    Private Sub ArchivosError(ByVal idRecepcion As Integer)
        Dim dt As New DataTable
        Me.lblMensaje.Text = ""
        Try
            dt = SuirPlus.Empresas.ManejoArchivoPython.getArchivosErroresEpAC(idRecepcion)
            If dt.Rows.Count > 0 Then
                lblIdRecepcion.Text = idRecepcion
                lblRazonRechazo.Text = dt.Rows(0)("error_principal")
                Me.pnlResultado.Visible = True
                If dt.Rows(0)("error_des").ToString() <> String.Empty Then
                    Me.dgError.DataSource = dt
                    Me.dgError.DataBind()
                    Me.dgError.Visible = True
                Else
                    Me.dgError.Visible = False
                End If

            Else
                Me.pnlResultado.Visible = False
                lblIdRecepcion.Text = String.Empty
                Me.dgError.DataSource = Nothing
                Me.dgError.DataBind()
                Throw New Exception("No hay registros...")
            End If

        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub
End Class
