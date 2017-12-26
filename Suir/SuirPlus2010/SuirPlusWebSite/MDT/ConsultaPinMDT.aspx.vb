Imports System.Data
Imports SuirPlus.MDT
Imports SuirPlus
Imports SuirPlus.Utilitarios.Utils




Partial Class MDT_ConsultaPinMDT
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


    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            BindPinMDT(UsrRegistroPatronal)
            BindDetPinMDT(UsrRegistroPatronal, Me.pageNum, Me.PageSize)

        End If
        pageNum = 1
        PageSize = BasePage.PageSize
    End Sub


    Protected Sub BindPinMDT(registro_patronal As Integer)
        Dim dtPinMDT As New DataTable
        Try
            dtPinMDT = General.getPinMDT(UsrRegistroPatronal)

            If dtPinMDT.Rows.Count > 0 Then
                'llenamos el grid y los labels'
                'Me.lblTotalRegistros.Text = dtPinMDT.Rows(0)("RECORDCOUNT")
                Me.gvPinMDT.DataSource = dtPinMDT
                Me.gvPinMDT.DataBind()
                divPin.Visible = True
            Else
                divPin.Visible = True
                lblError.Text = "No existen registros para esta busqueda"
            End If
            'setNavigation()
            dtPinMDT = Nothing


        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message
        End Try
    End Sub
    Protected Sub BindDetPinMDT(registro_patronal As Integer, pagenum As Integer, pagesize As Integer)
        Dim dtdetPinMDT As New DataTable
        Try
            dtdetPinMDT = General.getDetPinMDT(UsrRegistroPatronal, Me.pageNum, Me.PageSize)

            If dtdetPinMDT.Rows.Count > 0 Then
                'llenamos el grid y los labels'
                Me.lblTotalRegistros.Text = dtdetPinMDT.Rows(0)("RECORDCOUNT")
                Me.gvDetPinMDT.DataSource = dtdetPinMDT
                Me.gvDetPinMDT.DataBind()
                divDetPin.Visible = True


            Else
                divDet.Visible = True
                LblErrorDet.Text = "No existen registros para esta busqueda"        
            End If
            setNavigation()
            dtdetPinMDT = Nothing


        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message
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

        'Aqui ponemos el metodo que cargara la informacion'
        BindDetPinMDT(CInt(UsrRegistroPatronal), Me.pageNum, Me.PageSize)
    End Sub


    Protected Function formateaPeriodo(ByVal Periodo As Object) As String
        If Not IsDBNull(Periodo) Then
            Return Utilitarios.Utils.FormateaPeriodo(Periodo)
        Else
            Return String.Empty
        End If
    End Function

    Protected Function formateaReferencia(ByVal nroReferencia As Object) As String
        If Not IsDBNull(nroReferencia) Then
            Return Utilitarios.Utils.FormateaReferencia(nroReferencia)
        Else
            Return String.Empty
        End If
    End Function
End Class
