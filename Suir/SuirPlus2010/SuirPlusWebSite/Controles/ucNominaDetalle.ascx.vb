Imports System
Imports System.Data

Partial Class Controles_ucNominaDetalle
    Inherits System.Web.UI.UserControl

#Region "Miembros y Propiedades"

    Private myIdRegistroPatronal As Integer
    Private myIdNomina As Integer
   

    Public WriteOnly Property RegistroPatronal() As Integer
        Set(ByVal Value As Integer)
            myIdRegistroPatronal = Value
        End Set
    End Property

    Public WriteOnly Property IdNomina() As Integer
        Set(ByVal Value As Integer)
            myIdNomina = Value
        End Set
    End Property

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

    Public Overrides Sub DataBind()
        'Me.pageNum = 1
        'Me.PageSize = BasePage.PageSize

        SuirPlus.Operaciones.RegistroLogAuditoria.CrearRegistro(Me.myIdRegistroPatronal, HttpContext.Current.Session("UsrUserName"), HttpContext.Current.Session("UsrUserName"), 3, Request.UserHostAddress, Request.UserHostName, Me.myIdNomina, Request.ServerVariables("LOCAL_ADDR"))

        bindGrid()
    End Sub

    Protected Sub bindGrid()

        Dim dtDetalle As DataTable = Nothing

        Dim criterio As String = Me.txtCriterio.Text
        Dim tipoCriterio As String = Me.ddlBusqueda.SelectedValue.ToString
        Dim criterioDefault As String = "TODOS"

        If Me.txtCriterio.Text.ToUpper = criterioDefault Then
            criterio = String.Empty
        End If

        Try
            dtDetalle = SuirPlus.Empresas.Nomina.getDetalleNomina(Me.myIdRegistroPatronal, Me.myIdNomina, tipoCriterio, criterio, Me.pageNum, Me.PageSize)

            If dtDetalle.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dtDetalle.Rows(0)("RECORDCOUNT")
                Me.gvNomina.DataSource = dtDetalle
                Me.gvNomina.DataBind()
                Me.pnlDetalle.Visible = True

            Else
                Me.pnlDetalle.Visible = False
                'Me.tblDetalle.Visible = False
                Me.lblMensaje.Text = "No existen registros bajo este criterio " & """" & criterio & """" & ", la busqueda debe ser por Apellidos o por Cédulas."
                Me.txtCriterio.Text = criterioDefault
            End If

            setNavigation()

        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
        End Try

        dtDetalle = Nothing

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

        bindGrid()

    End Sub

    Protected Function formateaNSS(ByVal NSS As Object) As Object

        If Not NSS Is DBNull.Value Then

            Return SuirPlus.Utilitarios.Utils.FormatearNSS(NSS.ToString)

        End If

        Return NSS

    End Function

    Protected Function formateaDocumento(ByVal documento As String) As String

        'Si el documento que se envia no tiene 11 digitos asumimos que es un pasaporte.
        If documento.Length <> 11 Then
            Return documento
        End If

        Return SuirPlus.Utilitarios.Utils.FormatearCedula(documento)

    End Function

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        Me.pageNum = 1
        Me.PageSize = BasePage.PageSize
        Me.lblTotalRegistros.Text = 0
        bindGrid()

    End Sub

    Private Sub UcExportarExcel_ExportaExcel(ByVal sender As Object, ByVal e As EventArgs) Handles UcExportarExcel.ExportaExcel

        Me.UcExportarExcel.FileName = "Nomina_" & myIdNomina.ToString & ".xls"
        Me.UcExportarExcel.DataSource = SuirPlus.Empresas.Nomina.getNominaDetalle(myIdRegistroPatronal, myIdNomina)

    End Sub

End Class
