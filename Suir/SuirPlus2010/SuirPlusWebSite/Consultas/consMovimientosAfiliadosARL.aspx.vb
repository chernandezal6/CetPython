Imports System.Data
Imports SuirPlus
Partial Class Consultas_consMovimientosAfiliadosARL
    Inherits BasePage

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


    Protected Sub btnBuscar_Click(sender As Object, e As System.EventArgs) Handles btnBuscar.Click
        If txtNss.Text = String.Empty Then
            LblError.Visible = True
            LblError.Text = "Debe completar el Nss"
            Exit Sub
        End If
        If txtRNC.Text = String.Empty Then
            LblError.Visible = True
            LblError.Text = "Debe completar el RNC o Cédula"
            Exit Sub
            'Else
            '    If Integer.TryParse(txtNss.Text, 0) = False Then
            '        LblError.Visible = True
            '        LblError.Text = "NSS Inválido"
            '        Exit Sub
            '    End If
        End If
        Me.BindDetalleAfiliado()
    End Sub


    Protected Sub BindDetalleAfiliado()
        Dim dt As New DataTable
        
        Try
            dt = SuirPlus.Afiliacion.Afiliaciones.getMovimientosAfiliadoARL(txtRNC.Text, Convert.ToInt64(txtNss.Text), Me.pageNum, Me.PageSize)
            If dt.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
                Me.gvDetalleAfiliado.DataSource = dt
                Me.gvDetalleAfiliado.DataBind()

                lblcedula.Text = SuirPlus.Utilitarios.Utils.FormatearCedula(dt.Rows(0)("NO_DOCUMENTO").ToString)
                lblnombres.Text = dt.Rows(0)("NOMBRES").ToString
                'lblRazonSocial.Text = dtDatos.Rows(0)("RAZON_SOCIAL").ToString
                'lblStatusPin.Text = formatea
                'lblFecha.Text = String.Format("{0:d}", dtDatos.Rows(0)("FECHA_VENTA"))
                'divInfoPin.Visible = True
                'tblInfoPin.Visible = True
                divInfoempleado.Visible = True
                divAfiliado.Visible = True
                LblError.Visible = False

            Else
                divAfiliado.Visible = False
                'tblInfoPin.Visible = False
                LblError.Visible = True
                LblError.Text = "No existen registros para esta busqueda"
            End If
            dt = Nothing

        Catch ex As Exception
            LblError.Visible = True
            Me.LblError.Text = Split(ex.Message, "|")(1)
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
        setNavigation()
    End Sub
    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load
        pageNum = 1
        PageSize = BasePage.PageSize
    End Sub
    Protected Sub BtnLimpiar_Click(sender As Object, e As System.EventArgs) Handles BtnLimpiar.Click
        Response.Redirect("consMovimientosAfiliadosARL.aspx")
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

        Me.BindDetalleAfiliado()


    End Sub
End Class
