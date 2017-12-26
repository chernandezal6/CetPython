
Imports System
Imports System.Data

Partial Class Bancos_consArchivosProcesadosDiv
    Inherits BasePage

    Protected fechaInicial As String
    Protected fechaFinal As String
    Protected referencia As String
    Public idRecepcion As String
    Protected valores As String
    Protected dt As DataTable = Nothing

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

    Protected Property idEntidad() As String
        Get
            If ViewState("IdEntidad") Is Nothing Then
                Return String.Empty
            Else
                Return ViewState("IdEntidad")
            End If
        End Get
        Set(ByVal value As String)
            ViewState("IdEntidad") = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        fechaInicial = Request("Inicial")
        fechaFinal = Request("Final")
        referencia = Request("refer")
        idRecepcion = Request("ref")
        valores = Request("valor")

        If (valores = "M") Then

            If fechaInicial Is Nothing Or fechaInicial = String.Empty Then Exit Sub
            If fechaFinal Is Nothing Or fechaFinal = String.Empty Then Exit Sub

            If Not idRecepcion = String.Empty Or Not idRecepcion = Nothing Then
                Me.ArchivosError(CInt(idRecepcion))
            End If

            Me.ArchivosFechas()
            Me.ucFechaIni.dateValue = CDate(fechaInicial)
            Me.ucFechaFinal.dateValue = CDate(fechaFinal)
        End If

        If (valores = "U") Then
            Me.pnlResultado.Visible = True
            Me.dgDetalle1.Visible = True

            'Utilizado para mostrar el panel de consulta.
            If Not idRecepcion = String.Empty Or Not idRecepcion = Nothing Then
                Me.ArchivosError(CInt(idRecepcion))
            End If
            Me.ArchivosReferencia()

            If fechaInicial Is Nothing Or fechaInicial = String.Empty Then Exit Sub
            If fechaFinal Is Nothing Or fechaFinal = String.Empty Then Exit Sub

        End If

    End Sub

    Private Sub ArchivosReferencia()

        If (idRecepcion = String.Empty) Then
            Me.lblFormError.Text = "Debe Introducir un número de referencia"
            Exit Sub
        End If

        Dim usuario As SuirPlus.Seguridad.Usuario

        Try
            usuario = New SuirPlus.Seguridad.Usuario(Me.UsrUserName)
            idEntidad = usuario.IDEntidadRecaudadora
            dt = SuirPlus.Bancos.Dgii.getArchivosReferencia((CInt(idRecepcion)), CInt(idEntidad))
            Me.dgDetalle1.DataSource = dt
            Me.dgDetalle1.DataBind()
        Catch ex As Exception
            setFormError(ex.Message)
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        Finally
            dt = Nothing
            usuario = Nothing
        End Try

    End Sub

    Private Sub ArchivosError(ByVal idRecepcion As Integer)

        Me.dgError.Visible = False
        Me.pnlResultado.Visible = True

        Me.lblFormError.Text = ""
        Try
            dt = SuirPlus.Bancos.Dgii.getArchivosErrores(CInt(idRecepcion))
            Me.dgError.DataSource = dt
            Me.dgError.DataBind()

            Me.lblEstatus.Text = dt.Rows(0)("status")
            Me.lblMensajeResultado.Text = dt.Rows(0)("error_des")
            Me.lblUsuario.Text = dt.Rows(0)("Usuario_Carga")

        Catch ex As Exception
            setFormError("Referencia inválida")
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub ArchivosFechas()

        Try
            If String.IsNullOrEmpty(Me.idEntidad) Then
                Dim usuario As New SuirPlus.Seguridad.Usuario(Me.UsrUserName)
                Me.idEntidad = usuario.IDEntidadRecaudadora
            End If

            dt = SuirPlus.Bancos.Dgii.getArchivosFechas(CDate(fechaInicial), CDate(fechaFinal), CInt(idEntidad), Me.pageNum, Me.PageSize)

            If Me.dt.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
                Me.dgDetalle.DataSource = dt
                Me.dgDetalle.DataBind()
                Me.pnlNavigation.Visible = True
                setNavigation()
            Else
                Me.pnlNavigation.Visible = False
            End If

        Catch ex As Exception
            setFormError(ex.Message)
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        Finally
            dt = Nothing
        End Try

    End Sub

    Private Sub setFormError(ByVal msg As String)
        Me.lblFormError.Text = "<br>" + msg + "<br>"
    End Sub

    Public Function getArchivoCorrecto(ByVal fileName As Object) As String

        If Not fileName Is DBNull.Value Then
            If (fileName = "\") Or (fileName = ".tsse") Or (fileName = ".tss") Then
                fileName = String.Empty
            End If
        End If
        'Session("nacha") = fileName
        Return fileName 'Session("nacha")

    End Function

    Protected Sub btBuscarRef_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btBuscarRef.Click
        Response.Redirect("consArchivosProcesadosDiv.aspx?ref=" & Me.txtLote.Text & "&Incial=" & Me.ucFechaIni.dateValue & "&Final=" & Me.ucFechaFinal.dateValue & "&valor=" & "U")
    End Sub

    Protected Sub btBuscarFecha_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btBuscarFecha.Click
        Response.Redirect("consArchivosProcesadosDiv.aspx?Inicial=" & Me.ucFechaIni.dateValue & "&Final=" & Me.ucFechaFinal.dateValue & "&valor=" & "M")
    End Sub

    Protected Sub dgDetalle_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgDetalle.RowCommand

        Dim index As Integer = Convert.ToInt32(e.CommandArgument)
        Dim row As GridViewRow = dgDetalle.Rows(index)

        If e.CommandName = "nacha" Then
            Response.Redirect("consDescargaArchivosProcesados.aspx?ref=" & row.Cells(0).Text & "&tipo=" & "N" & """>" & row.Cells(6).Text)
        End If

        If e.CommandName = "respuesta" Then
            Response.Redirect("consDescargaArchivosProcesados.aspx?ref=" & row.Cells(0).Text & "&tipo=" & "R" & """>" & row.Cells(7).Text)
        End If

    End Sub

    Protected Sub dgDetalle_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgDetalle.RowCreated

        If e.Row.RowType = DataControlRowType.DataRow Then
            CType(e.Row.Cells(6).FindControl("lnkRespuesta"), LinkButton).CommandArgument = e.Row.RowIndex
            CType(e.Row.Cells(7).FindControl("lnkNacha"), LinkButton).CommandArgument = e.Row.RowIndex
        End If

    End Sub

    Protected Sub dgDetalle_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgDetalle.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.Cells(3).Text.Equals("No procesado") Or e.Row.Cells(3).Text.Equals("Rechazado") Then
                e.Row.Cells(3).Text = "<a href=""consArchivosProcesadosDiv.aspx?ref=" & e.Row.Cells(0).Text & "&Inicial=" & Request("Inicial") & "&Final=" & Request("Final") & "&valor=" & "M" & """>" & e.Row.Cells(3).Text & "</a>"

            End If
        End If
    End Sub

    Protected Sub dgDetalle1_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgDetalle1.RowCommand

        Dim index As Integer = Convert.ToInt32(e.CommandArgument)
        Dim row As GridViewRow = dgDetalle1.Rows(index)
        Dim nacha As String = String.Empty

        If e.CommandName = "nacha1" Then
            Response.Redirect("consDescargaArchivosProcesados.aspx?ref=" & row.Cells(0).Text & "&tipo=" & "N")
        End If

        If e.CommandName = "respuesta1" Then
            Response.Redirect("consDescargaArchivosProcesados.aspx?ref=" & row.Cells(0).Text & "&tipo=" & "R")
        End If

    End Sub

    Protected Sub dgDetalle1_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgDetalle1.RowCreated

        If e.Row.RowType = DataControlRowType.DataRow Then
            CType(e.Row.Cells(6).FindControl("linkrespuesta1"), LinkButton).CommandArgument = e.Row.RowIndex
            CType(e.Row.Cells(7).FindControl("lnkNacha1"), LinkButton).CommandArgument = e.Row.RowIndex
        End If
    End Sub

    Protected Sub dgDetalle1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgDetalle1.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then

            If e.Row.Cells(3).Text.Equals("No procesado") Or e.Row.Cells(3).Text.Equals("Rechazado") Then
                e.Row.Cells(3).Text = "<a href=""consArchivosProcesadosDiv.aspx?ref=" & e.Row.Cells(0).Text & "&Inicial=" & Request("Inicial") & "&Final=" & Request("Final") & "&valor=" & "U" & """>" & e.Row.Cells(3).Text & "</a>"
            End If

        End If

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

        ArchivosFechas()

    End Sub

#End Region

End Class
