
Partial Class Oficios_reporteOficios
    Inherits BasePage


    Public idOficio As String

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click

        'Para limpiar los grid
        VaciarGrid()

        Me.lblMsg.Text = String.Empty

        If String.IsNullOrEmpty(txtRncCedula.Text) And String.IsNullOrEmpty(txtOficio.Text) And _
            String.IsNullOrEmpty(txtUsuario.Text) And String.IsNullOrEmpty(txtFechaDesde.Text) And _
            String.IsNullOrEmpty(txtFechaHasta.Text) Then
            Me.lblMsg.Text = "Debe completar uno de los campos para realizar una busqueda."
            Exit Sub
        End If

        Dim dt As New System.Data.DataTable
        Dim dtDocumentacion As New System.Data.DataTable
        Dim dtDetalle As New System.Data.DataTable
        Dim fDesde, fHasta As String
        Dim nIdOficio As Integer

        If Trim(Me.txtOficio.Text) = "" Then
            nIdOficio = 0
        Else
            nIdOficio = Me.txtOficio.Text
        End If

        fDesde = Trim(Me.txtFechaDesde.Text)
        fHasta = Trim(Me.txtFechaHasta.Text)

        Try
            Me.lblMsg.Text = String.Empty
            If fDesde <> String.Empty Then
                fDesde = String.Format("{0:MM/dd/yyyy}", CDate(fDesde))
            End If

            If fHasta <> String.Empty Then
                fHasta = String.Format("{0:MM/dd/yyyy}", CDate(fHasta))
            End If
        Catch ex As Exception
            Me.lblMsg.Text = "Favor verificar las fechas(Fecha Inicio " & fDesde & " Fecha Fin " & fHasta & ")"
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub
        End Try

        dt = SuirPlus.Empresas.Oficio.getOficio(Me.txtRncCedula.Text, fDesde, fHasta, Me.txtUsuario.Text, nIdOficio)

        If SuirPlus.Utilitarios.Utils.HayErrorEnDataTable(dt) = False Then
            Me.gvOficios.DataSource = dt
            Me.gvOficios.DataBind()
            'Cargar el Numero de Oficio
            idOficio = dt.Rows(0).Item("id_oficio").ToString()


            'cargar detalle
            dtDetalle = SuirPlus.Empresas.Oficio.getDetOficio(nIdOficio)

            If dtDetalle.Rows.Count > 0 Then
                Dim dtOficio = SuirPlus.Empresas.Oficio.getOficio(nIdOficio)
                If dtOficio.Rows(0).Item(1).ToString() = "9" Then
                    trDetalleOficio.Visible = True
                    gvDetalleOficio.DataSource = dtDetalle
                    gvDetalleOficio.DataBind()

                End If
            End If

            'Cargar Documentacion
            dtDocumentacion = SuirPlus.Empresas.Oficio.getDocumentacion(idOficio)

            If dtDocumentacion.Rows.Count > 0 Then
                trDocumentacion.Visible = True
                gvDocumentacion.DataSource = dtDocumentacion
                gvDocumentacion.DataBind()
            End If


        Else
            Me.lblMsg.Text = SuirPlus.Utilitarios.Utils.sacarMensajeDeErrorDesdeTabla(dt)
            Me.gvOficios.DataSource = Nothing
            Me.gvOficios.DataBind()
        End If

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Limpiar()
        Response.Redirect("reporteOficios.aspx")

    End Sub

    Sub Limpiar()
        Me.txtRncCedula.Text = ""
        Me.txtUsuario.Text = ""
        Me.txtFechaDesde.Text = String.Empty
        Me.txtFechaHasta.Text = String.Empty
        Me.txtOficio.Text = ""
        VaciarGrid()
    End Sub

    Sub VaciarGrid()
        Me.gvOficios.DataSource = Nothing
        Me.gvOficios.DataBind()
        Me.gvDocumentacion.DataSource = Nothing
        Me.gvDocumentacion.DataBind()
        gvDetalleOficio.DataSource = Nothing
        gvDetalleOficio.DataBind()
        trDetalleOficio.Visible = False
        trDocumentacion.Visible = False
    End Sub
End Class
