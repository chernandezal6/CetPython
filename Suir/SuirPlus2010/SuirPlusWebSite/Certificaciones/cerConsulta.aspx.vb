Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios

Partial Class Certificaciones_cerConsulta
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

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim dt = Empresas.Certificaciones.getStatusCertificaciones()
            Dim dt2 As New DataTable

            'TODO: habilitar el estatus pendiente autorizacion para la consulta
            'Dim dr As DataRow
            'For Each dr In dt.Rows
            '    If dr.Item("status_Descripcion") = "Pendiente Autorización" Then
            '        dr.Delete()

            '    End If
            'Next
            dt2 = dt
            'Cargando el dropdownlist de status
            dlEstatus.DataSource = dt2
            dlEstatus.DataTextField = "status_Descripcion"
            dlEstatus.DataValueField = "Id_status"
            dlEstatus.DataBind()
            dlEstatus.Items.Insert(0, New ListItem("<--Todos-->", "0"))


            pageNum = 1
        End If

        PageSize = BasePage.PageSize

    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        lblMsg.Text = String.Empty
        divComentario.Visible = False
        divEntregar.Visible = False

        Try
            If (txtNumero.Text <> String.Empty) Then
                If (Trim(Me.txtNumero.Text).Length > 10) Then
                    Me.lblMsg.Visible = True
                    Me.lblMsg.Text = "El número de certificación no debe ser mayor de 10 dígitos."
                    gvCertificaciones.DataSource = Nothing
                    gvCertificaciones.DataBind()
                    Exit Sub
                End If

            End If


            If txtRnc.Text <> String.Empty Then
                If Not (Trim(Me.txtRnc.Text).Length = 9 Or Trim(Me.txtRnc.Text).Length = 11) Then
                    Me.lblMsg.Visible = True
                    Me.lblMsg.Text = "Error en el RNC o Cedula(debe ser sin espacios en blanco ni guiones)."
                    gvCertificaciones.DataSource = Nothing
                    gvCertificaciones.DataBind()
                    Exit Sub
                End If
            End If

            If (txtCedula.Text <> String.Empty) Then
                If (Trim(Me.txtCedula.Text).Length > 11) Then
                    Me.lblMsg.Visible = True
                    Me.lblMsg.Text = "La cédula no debe ser mayor de 11 dígitos(sin espacios en blanco ni guiones)."
                    gvCertificaciones.DataSource = Nothing
                    gvCertificaciones.DataBind()
                    Exit Sub
                End If
            End If


            Me.bind()

        Catch ex As Exception
            ' Throw New Exception(ex.Message)
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
        End Try

    End Sub

    Private Sub bind()
        Dim dt As New DataTable
        Try
            gvCertificaciones.DataSource = Nothing
            gvCertificaciones.DataBind()

            Dim No_Documento As String = ""
            Dim Id_Certificacion As String = ""

            If txtNumero.Text.Contains("-") Then
                No_Documento = txtNumero.Text
            Else
                Id_Certificacion = txtNumero.Text
            End If


            dt = Empresas.Certificaciones.getCertificaciones(Id_Certificacion, No_Documento, Me.txtRnc.Text, Me.txtCedula.Text, CInt(Me.dlEstatus.SelectedValue), "CAE", pageNum, PageSize, txtDesde.Text, txtHasta.Text)

            If dt.Rows.Count > 0 Then

                If Utilitarios.Utils.HayErrorEnDataTable(dt) = False Then
                    gvCertificaciones.DataSource = dt
                    gvCertificaciones.DataBind()
                    OcultarCeldas()
                    Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
                    Me.pnlNavegacion.Visible = True
                    Me.ucExportarExcel1.Visible = True

                Else
                    Me.pnlNavegacion.Visible = False
                    Me.lblMsg.Enabled = True
                    Me.lblMsg.Visible = True
                    Me.lblMsg.Text = Utilitarios.Utils.sacarMensajeDeErrorDesdeTabla(dt)
                    Me.ucExportarExcel1.Visible = False
                End If
            Else
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No hay data disponible."
                Me.pnlNavegacion.Visible = False
                Me.ucExportarExcel1.Visible = False
            End If

            dt = Nothing
            setNavigation()

        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try

    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.lblMsg.Visible = False
        Me.txtNumero.Text = String.Empty
        Me.txtRnc.Text = String.Empty
        Me.txtCedula.Text = String.Empty
        Me.gvCertificaciones.DataSource = Nothing
        Me.gvCertificaciones.DataBind()
        Me.divComentario.Visible = False
        pnlNavegacion.Visible = False
        divComentario.Visible = False
        divEntregar.Visible = False
        Me.dlEstatus.SelectedValue = 0
        txtDesde.Text = String.Empty
        txtHasta.Text = String.Empty

    End Sub

    Protected Sub gvCertificaciones_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvCertificaciones.RowCommand
        If e.CommandName = "Ver" Then
            Dim Cert() As String = e.CommandArgument.ToString.Split("|")
            divComentario.Visible = True
            lblIdCertComentario.Text = "Certificación #" & Cert(0)
            txtComentario.Text = Cert(1)
            divEntregar.Visible = False
        Else
            Me.divComentario.Visible = False
            lblIdCertComentario.Text = String.Empty
            txtComentario.Text = String.Empty
        End If

        If e.CommandName = "Entregar" Then
            divEntregar.Visible = True
            Session("IdCert") = e.CommandArgument.ToString
            lblIdCertComentEntrega.Text = "Certificación #" & e.CommandArgument.ToString
            Me.divComentario.Visible = False
        Else
            divEntregar.Visible = False
            lblIdCertComentEntrega.Text = String.Empty
            Session.Remove("IdCert")
        End If

        If e.CommandName = "Entregada" Then
            Dim b, c, d As String
            b = String.Empty
            c = String.Empty
            d = String.Empty

            Dim random = New Random(DateTime.Now.Millisecond)
            Dim rand As Random = New Random()
            Dim letras = Enumerable.Range(0, 20).Select(Function(i) (Chr(Asc("A") + rand.Next(0, 26)))).OrderBy(Function(x) random.Next()).ToList()
            Dim letras2 = Enumerable.Range(20, 40).Select(Function(i) (Chr(Asc("A") + rand.Next(0, 26)))).OrderBy(Function(x) random.Next()).ToList()
            Dim letras3 = Enumerable.Range(40, 60).Select(Function(i) (Chr(Asc("A") + rand.Next(0, 26)))).OrderBy(Function(x) random.Next()).ToList()

            For Each l As String In letras
                b = b & l
            Next

            For Each l As String In letras2
                c = c & l
            Next

            For Each l As String In letras3
                d = d & l
            Next


            Dim Resultado = Convert.ToBase64String(Encoding.ASCII.GetBytes(e.CommandArgument.ToString().ToCharArray()))
            Response.Redirect(Application("servidor") + "sys/ImpCertificacion.aspx?A=" + Resultado + "&b=" + b + "&C=" + c + "&D=" + d + "")

        End If

        upConsCertificacion.Update()

    End Sub

    Protected Sub gvCertificaciones_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvCertificaciones.RowDataBound

        Dim imprimir As Label = CType(e.Row.FindControl("lblprint"), Label)
        Dim coment As Label = CType(e.Row.FindControl("lblComentAjustado"), Label)
        Dim entregar As Label = CType(e.Row.FindControl("lblEntregar"), Label)
        Dim actualizar As Label = CType(e.Row.FindControl("lblActualizar"), Label)

        If e.Row.RowType = DataControlRowType.DataRow Then
            'TODO:Especificar cuales son los estatus que debe tene la cert. para poder ser impresa
            If e.Row.Cells(2).Text.ToUpper <> "VERIFICADA" Then
                imprimir.Text = ""
            End If
            '246 este el el permiso en desarollo y prueba
            'EN PRODUCCION 256

            If Not IsInPermiso("256") Then
                entregar.Text = ""
            Else
                ' entregar = CType(e.Row.FindControl("lblEntregar"), Label)
                If e.Row.Cells(2).Text.ToUpper = "VERIFICADA" Then
                    entregar.Text = "[Entregar]"
                End If
            End If

            If IsNumeric(e.Row.Cells(0).Text) Then

                If coment.Text <> String.Empty Then
                    If coment.Text.Length > 19 Then
                        coment.Text = coment.Text.Substring(0, 20) & "..."
                    End If
                Else
                    coment.Text = "N/A"
                End If
            End If
            'este es el perimiso en desarrollo y prueba 245
            'EN PRODUCCION 255
            If Not IsInPermiso("255") Then
                actualizar.Text = ""
            Else
                'TODO: solo se podran actualizar las verificadas y rechazadas 
                If e.Row.Cells(2).Text.ToUpper = "VERIFICADA" Or e.Row.Cells(2).Text.ToUpper = "RECHAZADA" Then
                    actualizar = CType(e.Row.FindControl("lblActualizar"), Label)
                Else
                    actualizar.Text = ""
                End If

            End If

        End If

    End Sub

    Protected Sub btnEntregar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEntregar.Click

        'actualizar estatus a entregado.
        'cambiamos el status de "verificada" a "Entregada"
        Try

            If CInt(Session("IdCert")) > 0 Then
                Dim coment = Me.txtComentarioEntrega.Text
                If coment = String.Empty Then
                    coment = "Certificación entregada."
                End If
                Dim result = Empresas.Certificaciones.CambiarStatusCert(CInt(Session("IdCert")), 4, Me.UsrUserName, coment)

                If result <> 0 Then
                    Me.lblMsg.Visible = True
                    Me.lblMsg.Text = result
                    Exit Sub
                Else
                    bind()
                    Session.Remove("IdCert")
                    divEntregar.Visible = False
                    txtComentarioEntrega.Text = String.Empty
                End If
            Else
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "Error entregando la certificación."
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
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
        bind()
    End Sub
    Protected Sub btnCancelarEntrega_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelarEntrega.Click
        txtComentarioEntrega.Text = String.Empty
        divEntregar.Visible = False
    End Sub
    Sub OcultarCeldas()
        For i = 0 To gvCertificaciones.Rows.Count - 1
            If gvCertificaciones.Rows(i).Cells(2).Text <> "Entregada" Then
                CType(gvCertificaciones.Rows(i).FindControl("ibDescargar"), ImageButton).Visible = False
                'CType(gvConsulta.Rows(i).FindControl("ibDescargar"), HyperLink).Visible = False
            End If
        Next
    End Sub

    Protected Sub ucExportarExcel1_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel
        Dim dtTSS As DataTable

        Dim No_Documento As String = ""
        Dim Id_Certificacion As String = ""

        If txtNumero.Text.Contains("-") Then
            No_Documento = txtNumero.Text
        Else
            Id_Certificacion = txtNumero.Text
        End If


        dtTSS = Empresas.Certificaciones.getCertificaciones(Id_Certificacion, No_Documento, Me.txtRnc.Text, Me.txtCedula.Text, CInt(Me.dlEstatus.SelectedValue), "CAE", pageNum, PageSize, txtDesde.Text, txtHasta.Text)
        dtTSS.Columns.Remove("RECORDCOUNT")
        dtTSS.Columns.Remove("NUM")
        dtTSS.Columns.Remove("PIN")


        If dtTSS.Rows.Count > 0 Then
            Me.ucExportarExcel1.FileName = "Listado de Certificaciones.xls"
            Me.ucExportarExcel1.DataSource = dtTSS
        End If
    End Sub
End Class
