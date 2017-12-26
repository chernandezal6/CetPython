Imports System.Data
Imports SuirPlus
Imports SuirPlus.SolicitudesEnLinea

Partial Class Controles_ucSolicitudByRNC
    Inherits System.Web.UI.UserControl


#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents txtRNC As System.Web.UI.WebControls.TextBox
    'Protected WithEvents gvSolicitudes As System.Web.UI.WebControls.DataGrid

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

#Region "Miembros y Propiedades"

    Public Property RNC() As String
        Get
            Return Me.txtRNC.Text
        End Get
        Set(ByVal Value As String)
            Me.txtRNC.Text = Value
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

    Public WriteOnly Property MostrarUltimaColumna() As Boolean
        Set(ByVal value As Boolean)
            Me.gvSolicitudes.Columns(5).Visible = value
        End Set
    End Property

#End Region

    Public Sub Ocultar()

        Me.pnlMostrar.Visible = False

    End Sub

    Public Sub Mostrar()
        Me.pnlMostrar.Visible = False

        Dim dt As DataTable = Nothing
        Dim err As String = String.Empty

        Try
            Me.PageSize = 20

            dt = SuirPlus.SolicitudesEnLinea.Solicitudes.getPageSolicitud_RNC(Me.txtRNC.Text, Me.pageNum, Me.PageSize)

            If SuirPlus.Utilitarios.Utils.HayErrorEnDataTable(dt) = False Then

                err = String.Empty
                If dt.Rows.Count > 0 Then
                    Me.pnlMostrar.Visible = True
                    Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
                    Me.gvSolicitudes.DataSource = dt
                    Me.DataBind()
                    setNavigation()
                Else
                    err = "No existen registros para este empleador"
                    Throw New Exception(err)
                End If

            Else

                err = SuirPlus.Utilitarios.Utils.sacarMensajeDeErrorDesdeTabla(dt)
                Me.gvSolicitudes.DataSource = Nothing
                Me.DataBind()
                Me.pnlMostrar.Visible = False

                Throw New Exception(err)
            End If

        Catch ex As Exception
            Throw New Exception(err)
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

        Mostrar()

    End Sub

End Class


