
Imports System.Globalization
Imports System.Threading
Imports SuirPlusEF
Imports SuirPlusEF.Models
Imports System.Data
Imports System.Drawing

Partial Class Asignacion_NSS_ConsAsignacionNssLote
    Inherits BasePage

    Dim lote As String = String.Empty
    Dim registro As String = String.Empty

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
    Public Overloads Property PageSize() As Int16
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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        pageNum = 1
        PageSize = BasePage.PageSize
    End Sub

    Private Sub CargarSolicitudes(ByVal lote As String, ByVal registro As String)
        Dim repSolicitud As New SuirPlusEF.Repositories.SolicitudNSSRepository()
        Dim solicitud As String = String.Empty

        Dim sol = repSolicitud.GetSolicitud(solicitud, "", "", lote, registro, pageNum, PageSize)
        If sol IsNot Nothing Then
            If sol.Rows.Count > 0 Then
                gvSolicitudGeneral.DataSource = sol
                gvSolicitudGeneral.DataBind()
                gvSolicitudGeneral.Visible = True
                lblMensajeError.Text = String.Empty
                pnlNavegacion.Visible = True
                lblTotalRegistros.Text = sol.Rows(0)("RECORDCOUNT")
                lblTotalRegistros.Visible = True
            Else
                lblMensajeError.Text = "No existe registro"
                lblMensajeError.Visible = True
                gvSolicitudGeneral.Visible = False
                pnlNavegacion.Visible = False
                lblTotalRegistros.Visible = False
            End If
        Else
            lblMensajeError.Text = "No existe registro"
            lblMensajeError.Visible = True
            gvSolicitudGeneral.Visible = False
            pnlNavegacion.Visible = False
            lblTotalRegistros.Visible = False
        End If
        sol = Nothing
        setNavigation()

    End Sub
    Private Sub btBuscar_Click(sender As Object, e As EventArgs) Handles btBuscar.Click
        If (txtLote.Text <> String.Empty Or txtLote.Text = String.Empty) And ((txtRegistro.Text <> String.Empty) Or (txtRegistro.Text = String.Empty)) Then
            If (Trim(txtLote.Text) = String.Empty) And (txtRegistro.Text <> String.Empty) Then
                lblMensajeError.Text = "El número de Lote es obligatorio"
                lblMensajeError.Visible = True
                gvSolicitudGeneral.Visible = False
                Return
            End If

            If (Trim(txtLote.Text) = String.Empty) And (Trim(txtRegistro.Text) = String.Empty) Then
                lblMensajeError.Text = "Debe digitar al menos uno de los criterios de busqueda."
                lblMensajeError.Visible = True
                gvSolicitudGeneral.Visible = False
                Return
            End If

            If (txtLote.Text) <> String.Empty Then
                    lote = (txtLote.Text)
                Else
                    lote = String.Empty
                End If

                If (txtRegistro.Text) <> String.Empty Then
                    registro = (txtRegistro.Text)
                Else
                    registro = String.Empty
                End If

                CargarSolicitudes(lote, registro)

            Else
                lblMensajeError.Text = "Debe introducir al menos un filtro"
            lblMensajeError.Visible = True
            gvSolicitudGeneral.Visible = False
        End If
    End Sub

    Private Sub btLimpiar_Click(sender As Object, e As EventArgs) Handles btLimpiar.Click
        txtLote.Text = String.Empty
        txtRegistro.Text = String.Empty
        lblMensajeError.Visible = False
        gvSolicitudGeneral.Visible = False
        pnlNavegacion.Visible = False

    End Sub

    Private Sub gvSolicitudGeneral_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSolicitudGeneral.RowCommand
        Dim solicitud As String = String.Empty
        If e.CommandName = "Ver" Then
            solicitud = e.CommandArgument.ToString

            Dim script As String = "<script Language=JavaScript>" + "window.open('ImagenSolicitud.aspx?solicitud=" & solicitud & "')</script>"
            Me.ClientScript.RegisterStartupScript(Me.GetType, "popup", script)

        End If
    End Sub

    Private Sub gvSolicitudGeneral_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSolicitudGeneral.RowDataBound

        Dim curCulture As CultureInfo = Thread.CurrentThread.CurrentCulture
        Dim tInfo As TextInfo = curCulture.TextInfo()

        Dim ImgSolicitud As ImageButton = CType(e.Row.FindControl("ibImagen"), ImageButton)
        Dim Solicitud As New DetalleSolicitudes()
        Dim repDetSolicitud As New Repositories.DetalleSolicitudesRepository()

        If e.Row.RowType = DataControlRowType.DataRow Then

            e.Row.Cells(1).Text = tInfo.ToTitleCase(e.Row.Cells(1).Text.ToLower())
            e.Row.Cells(4).Text = tInfo.ToTitleCase(e.Row.Cells(4).Text.ToLower())
            e.Row.Cells(5).Text = tInfo.ToTitleCase(e.Row.Cells(5).Text.ToLower())
            e.Row.Cells(6).Text = tInfo.ToTitleCase(e.Row.Cells(6).Text.ToLower())
            e.Row.Cells(9).Text = tInfo.ToTitleCase(e.Row.Cells(9).Text.ToLower())
            e.Row.Cells(10).Text = tInfo.ToTitleCase(e.Row.Cells(10).Text.ToLower())

            Solicitud = repDetSolicitud.GetBySolicitud(e.Row.Cells(0).Text)
            If Solicitud.IMAGEN_SOLICITUD IsNot Nothing Then
                ImgSolicitud.Visible = True
            Else
                ImgSolicitud.Visible = False
            End If
        End If
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

        btBuscar_Click(Nothing, Nothing)
    End Sub
End Class
