Imports System.Data
Imports SuirPlus
Partial Class Empleador_ConsultaArchivos
    Inherits BasePage

#Region "Paginación"

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

    Private Sub setNavigation()

        Dim totalRecords As Integer = 0

        If IsNumeric(Me.lblTotalRegistros.Text) Then
            totalRecords = CInt(Me.lblTotalRegistros.Text)
        End If

        Dim totalPages As Double = Math.Ceiling(Convert.ToDouble(totalRecords) / PageSize)

        If totalRecords = 1 Or totalPages = 0 Then
            totalPages = 1
        End If

        'If PageSize > totalRecords Then
        '    PageSize = Int16.Parse(totalPages)
        'End If

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

        LoadData()

    End Sub

#End Region

    Private Sub LoadData()
        Dim dtTSS As DataTable

        Dim desde = Nothing
        If Not String.IsNullOrEmpty(Me.txtDesde.Text) = True Then
            desde = CDate(Me.txtDesde.Text)
        End If

        Dim hasta = Nothing
        If Not String.IsNullOrEmpty(Me.txtHasta.Text) = True Then
            hasta = CDate(Me.txtHasta.Text)
        End If

        Dim idrecepcion As Integer = 0

        If Not String.IsNullOrEmpty(txtNoReferencia.Text) Then
            idrecepcion = txtNoReferencia.Text
        End If


        dtTSS = Empresas.ManejoArchivoPython.getArchivosPaginados(idrecepcion, ddlTipo.SelectedValue, desde, hasta, Me.PageSize, Me.pageNum)

        If dtTSS.Rows.Count > 0 Then
            Me.lblTotalRegistros.Text = dtTSS.Rows(0)("RECORDCOUNT")
            Me.gvArchivos.DataSource = dtTSS
            Me.gvArchivos.DataBind()
            Me.pnlNavegacion.Visible = True
            setNavigation()
        Else
            lblMensaje.Text = "No existen registro para esta busqueda."
            Me.gvArchivos.DataSource = dtTSS
            Me.gvArchivos.DataBind()
            Me.pnlNavegacion.Visible = False
        End If

    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        If Not String.IsNullOrEmpty(Me.txtDesde.Text) Or Not String.IsNullOrEmpty(Me.txtHasta.Text) Or Not String.IsNullOrEmpty(Me.txtNoReferencia.Text) Then
            LoadData()
        Else
            lblMensaje.Text = "Debe completar uno de los datos"
        End If
    End Sub

    Protected Sub gvArchivos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvArchivos.RowCommand
        If e.CommandName = "Ver" Then
            Dim ImgAcuerdo As Byte()
            Dim IDArchivo As Integer
            Dim Nombre As String



            IDArchivo = Split(e.CommandArgument, "|")(0)
            Nombre = Split(e.CommandArgument, "|")(1)
            Try

                ImgAcuerdo = Empresas.ManejoArchivoPython.getArchivoVS(IDArchivo)
                If ImgAcuerdo IsNot Nothing Then

                    Response.Clear()
                    Response.AddHeader("content-disposition", "attachment;filename=" & Nombre)
                    Response.Charset = ""
                    Response.Cache.SetCacheability(HttpCacheability.NoCache)
                    Response.ContentType = "application/vnd.text"
                    Response.BinaryWrite(ImgAcuerdo)
                    Response.End()


                Else
                    lblMensaje.Text = "No Existe el archivo"
                End If

            Catch ex As Exception
                lblMensaje.Text = ex.Message
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

        End If
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("ConsultaArchivos.aspx")
    End Sub

End Class
