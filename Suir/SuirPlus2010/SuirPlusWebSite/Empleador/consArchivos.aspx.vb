
Partial Class Empleador_consArchivos
    Inherits BasePage

    Protected idReferencia As Integer
    Protected RNC As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load


        If LCase(Request("ref")) <> String.Empty Then

            idReferencia = Request("ref")
            Me.txtReferencia.Text = idReferencia
            MostrarConsulta()

            If LCase(Request("det")) = "si" Then

                'Verificamos si el detalle a mostrar es de tipo dependiente
                If LCase(Request("dep")) = "si" Then
                    ctrlArchivos.isDetalleDependiente = True
                End If

                ctrlArchivos.IdReferencia = idReferencia
                ctrlArchivos.DataBind()
                ctrlArchivos.Visible = True

            End If

        End If

    End Sub

    Private Sub llenarUltimosRegistros()

        Me.gvUltimosArchivos.DataSource = SuirPlus.Empresas.ManejoArchivoPython.getLast5Archivos(getRNC)
        Me.gvUltimosArchivos.DataBind()

    End Sub

    Protected Sub gvUltimosArchivos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvUltimosArchivos.RowDataBound

        If e.Row.RowType = ListItemType.Item Or e.Row.RowType = ListItemType.AlternatingItem Then

            e.Row.Cells(0).Text = "<a href=consArchivos.aspx?ref=" & e.Row.Cells(0).Text & ">" & e.Row.Cells(0).Text & "</a>"

        End If

    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click

        If Not IsNumeric(Me.txtReferencia.Text) Then
            Me.lblResultado.Text = "El Nro. de Referencia debe ser númerico."
            Me.lblResultado.CssClass = "error"
            Exit Sub
        End If

        Try
            idReferencia = Me.txtReferencia.Text
        Catch oEx As OverflowException
            Me.lblResultado.Text = "El Nro. de Referencia inválido."
            Me.lblResultado.CssClass = "error"
            Exit Sub
        Catch ex As Exception
            Me.lblResultado.Text = ex.Message
            Me.lblResultado.CssClass = "error"
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub
        End Try

        Response.Redirect("consArchivos.aspx?ref=" & idReferencia.ToString)

    End Sub

    Private Sub MostrarConsulta()

        Dim archivo As SuirPlus.Empresas.ManejoArchivoPython

        Try

            archivo = New SuirPlus.Empresas.ManejoArchivoPython(idReferencia, getRNC())

        Catch ex As Exception

            Me.lblResultado.Text = ex.Message.ToString
            Me.lblResultado.CssClass = "error"
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub

        End Try

        Me.lblusuario.Text = archivo.UsuarioCarga
        Me.lblProceso.Text = archivo.Proceso
        Me.lblTipoProceso.Text = archivo.TipoProceso
        If archivo.FechaCarga <> Date.MinValue Then
            Me.lblFechaCarga.Text = String.Format("{0:d}", archivo.FechaCarga)
        End If

        Me.lblEstatus.Text = archivo.Estatus
        Me.lblMensajeResultado.Text = archivo.Resultado
        Me.lblTotalRegistros.Text = archivo.TotalRegistros
        Me.lblRegistrosValidos.Text = archivo.RegistrosValidos
        Me.lblRegistrosInvalidos.Text = archivo.RegistrosInvalidos
        Me.lblResultado.Text = "Resultado de la referencia " & idReferencia

        If archivo.RegistrosInvalidos > 0 Then
            Me.lnkVerRegistros.Visible = True
        End If

        Me.pnlResultado.Visible = True

    End Sub

    Private Function getRNC() As String

        If (CType(Me.Page, BasePage).IsInRole(520)) Then
            Return "CERSS"
        Else
            Return Me.UsrRNC
        End If

    End Function

    Private Sub lnkVerRegistros_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lnkVerRegistros.Click

        If Me.lblTipoProceso.Text = "RD" Then
            Response.Redirect("consArchivos.aspx?ref=" & Me.txtReferencia.Text & "&det=si&" & "dep=si")
        Else
            Response.Redirect("consArchivos.aspx?ref=" & Me.txtReferencia.Text & "&det=si")
        End If


    End Sub

    Protected Overrides Sub OnPreRender(ByVal e As System.EventArgs)

        If Not Page.IsPostBack Then
            llenarUltimosRegistros()
        End If

    End Sub

End Class