Imports SuirPlus
Imports SuirPlus.Utilitarios

Partial Class Operaciones_consArchivoAuditoria
    Inherits BasePage

    Dim idReferencia As String = String.Empty

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            If LCase(Request("ref")) <> String.Empty Then

                idReferencia = Request("ref")
                Me.txtReferencia.Text = idReferencia
                MostrarConsulta()
                Me.upMain.Update()
                If LCase(Request("det")) = "si" Then
                    UCArchivosDet.IdReferencia = idReferencia
                    UCArchivosDet.DataBind()
                    UCArchivosDet.Visible = True
                    Me.upDetalle.Update()
                End If
            Else
                llenarUltimosRegistros()
            End If
        End If

    End Sub
    Private Sub llenarUltimosRegistros()
        Try
            Dim dt As New Data.DataTable
            dt = SuirPlus.Empresas.Archivo.getLast5ArchivosAuditoria()
            If dt.Rows.Count > 0 Then
                pnlUltimosArchivosAuditoria.Visible = True
                Me.gvUltimosArchivos.DataSource = dt
                Me.gvUltimosArchivos.DataBind()
            Else
                pnlUltimosArchivosAuditoria.Visible = False
                lblResultado.Text = "no existen archivos de auditoría."
            End If


        Catch ex As Exception
            lblResultado.Text = ex.Message
        End Try


    End Sub
    Protected Sub gvUltimosArchivos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvUltimosArchivos.RowDataBound

        If e.Row.RowType = ListItemType.Item Or e.Row.RowType = ListItemType.AlternatingItem Then

            e.Row.Cells(0).Text = "<a href=consArchivoAuditoria.aspx?ref=" & e.Row.Cells(0).Text & ">" & e.Row.Cells(0).Text & "</a>"

        End If

    End Sub

    Private Sub MostrarConsulta()

        Dim dt As Data.DataTable

        If Not IsNumeric(Me.txtReferencia.Text) Then
            lblResultado.Text = "Nro. de envío inválido."
            Exit Sub
        End If

        Try

            dt = SuirPlus.Empresas.Archivo.getInfoArchivoAuditoria(CInt(Me.txtReferencia.Text))
            If dt.Rows.Count > 0 Then
                Me.lblusuario.Text = dt.Rows(0).Item("USUARIO_CARGA").ToString
                Me.lblProceso.Text = dt.Rows(0).Item("TIPO_MOVIMIENTO_DES").ToString
                Me.lblFechaCarga.Text = dt.Rows(0).Item("FECHA_CARGA").ToString
                Me.lblEstatus.Text = dt.Rows(0).Item("STATUS").ToString
                Me.lblMensajeResultado.Text = dt.Rows(0).Item("ERROR_DES").ToString
                Me.lblRegistrosValidos.Text = dt.Rows(0).Item("REGISTROS_OK").ToString
                Me.lblRegistrosInvalidos.Text = dt.Rows(0).Item("REGISTROS_BAD").ToString
                Me.lblTotalRegistros.Text = dt.Rows(0).Item("TOTAL_REGISTROS").ToString
                Me.lblRNC.Text = Utils.FormatearRNCCedula(dt.Rows(0).Item("ID_RNC_CEDULA").ToString())
                Me.lblRazonSocial.Text = dt.Rows(0).Item("RAZON_SOCIAL").ToString
                If CInt(lblRegistrosInvalidos.Text) > 0 Then
                    Me.lnkVerRegistros.Visible = True
                End If

                Me.pnlResultado.Visible = True
                Me.pnlUltimosArchivosAuditoria.Visible = False

            Else
                Me.lblResultado.Text = "Su búsqueda no arrojó ningún resultado."
                Me.pnlResultado.Visible = False
                Me.pnlUltimosArchivosAuditoria.Visible = True
            End If


        Catch ex As Exception

            Me.lblResultado.Text = ex.Message
            Me.lblResultado.CssClass = "error"
            Me.pnlResultado.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub

        End Try



    End Sub

    'Boton consultar
    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        limpiarForm()
        If Not Me.txtReferencia.Text = String.Empty Then

            MostrarConsulta()
        Else
            Me.lblResultado.Text = "El Nro. de envío es requerido."
        End If

    End Sub

    Protected Sub lnkVerRegistros_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkVerRegistros.Click
        If Not Me.txtReferencia.Text = String.Empty Then
            UCArchivosDet.IdReferencia = Me.txtReferencia.Text
            Try
                UCArchivosDet.DataBind()
            Catch ex As Exception
                Me.lblResultado.Text = ex.Message
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
            UCArchivosDet.Visible = True

        End If
    End Sub

    Sub limpiarForm()
        Me.lblusuario.Text = String.Empty
        Me.lblProceso.Text = String.Empty
        Me.lblRNC.Text = String.Empty
        Me.lblFechaCarga.Text = String.Empty
        Me.lblRazonSocial.Text = String.Empty
        Me.lblTotalRegistros.Text = String.Empty
        Me.lblEstatus.Text = String.Empty
        Me.lblMensajeResultado.Text = String.Empty
        Me.lblRegistrosValidos.Text = String.Empty
        Me.lblRegistrosInvalidos.Text = String.Empty
        Me.UCArchivosDet.Visible = False
    End Sub

    Protected Sub lnkVolver_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkVolver.Click
        Response.Redirect("consArchivoAuditoria.aspx")
    End Sub
End Class
