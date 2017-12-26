
Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios
Imports SuirPlus.Ars.Consultas

Partial Class Mantenimientos_AsignacionNss
    Inherits BasePage

    Dim _idsolicitud As String
    Dim _casoEvaluacion As String
    Dim CallMe As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        CallMe = HttpContext.Current.Session("EvaluacionOrigen")

        If Not IsNothing(Request.QueryString("id_solicitud")) Then
            _idsolicitud = Request.QueryString("id_solicitud")
        End If
        If Not IsNothing(Request.QueryString("CasoEvaluacion")) Then
            _casoEvaluacion = Request.QueryString("CasoEvaluacion")
        End If

        If Not Page.IsPostBack Then
            CargaSolicitud(CInt(_idsolicitud))
            CargarNSSDuplicados(CInt(_idsolicitud))
            Session("contador") = String.Empty
        End If
    End Sub

    Private Sub CargaSolicitud(ByVal idsolicitud As Integer)

        Dim dt As New DataTable
        dt = Ars.Consultas.getInfoAsignacionNss(idsolicitud)

        If dt.Rows.Count > 0 Then

            If dt.Rows(0)("Extranjero") = "Si" Then
                fsNSSExtranjero.Visible = True
                fsAsignacionNSS.Visible = False

                If IsDBNull(dt.Rows(0)("Desc_Error")) Then
                    lblDescError.Text = String.Empty
                Else
                    lblDescError.Text = dt.Rows(0)("Desc_Error")
                End If

                If IsDBNull(dt.Rows(0)("ARS_DES")) Then
                    lblARSExt.Text = String.Empty
                Else
                    lblARSExt.Text = dt.Rows(0)("ARS_DES")
                End If

                lblNombresExt.Text = dt.Rows(0)("Nombres")
                lblPrimerApellidoExt.Text = dt.Rows(0)("Primer_Apellido")

                If IsDBNull(dt.Rows(0)("SEGUNDO_APELLIDO")) Then
                    lblSegundoApellidoExt.Text = String.Empty
                Else
                    lblSegundoApellidoExt.Text = dt.Rows(0)("SEGUNDO_APELLIDO")
                End If

                lblSexoExt.Text = dt.Rows(0)("Sexo")
                lblFechaNacExt.Text = dt.Rows(0)("Fecha_Nacimiento")

                If IsDBNull(dt.Rows(0)("Id_Nacionalidad")) Then
                    lblNacionalidadExt.Text = String.Empty
                Else
                    lblNacionalidadExt.Text = dt.Rows(0)("Id_Nacionalidad")
                End If

                If IsDBNull(dt.Rows(0)("no_documento_titular")) Then
                    lblDocumentoTitular.Text = String.Empty
                Else
                    If dt.Rows(0)("tipo_documento_titular").ToString() = "C" Then
                        lblDocumentoTitular.Text = Utils.FormatearCedula(dt.Rows(0)("no_documento_titular"))
                    Else
                        lblDocumentoTitular.Text = dt.Rows(0)("no_documento_titular")
                    End If
                End If

                If IsDBNull(dt.Rows(0)("NOMBRES_TITULAR")) Then
                    lblNombresTitular.Text = String.Empty
                Else
                    lblNombresTitular.Text = dt.Rows(0)("NOMBRES_TITULAR")
                End If
                If IsDBNull(dt.Rows(0)("PRIMER_APELLIDO_TITULAR")) Then
                    lblPrimerApellidoTitular.Text = String.Empty
                Else
                    lblPrimerApellidoTitular.Text = dt.Rows(0)("PRIMER_APELLIDO_TITULAR")
                End If
                If IsDBNull(dt.Rows(0)("SEGUNDO_APELLIDO_TITULAR")) Then
                    lblSegundoApellidoTitular.Text = String.Empty
                Else
                    lblSegundoApellidoTitular.Text = dt.Rows(0)("SEGUNDO_APELLIDO_TITULAR")
                End If
                If IsDBNull(dt.Rows(0)("NACIONALIDAD_TITULAR")) Then
                    lblNacionalidadTitular.Text = String.Empty
                Else
                    lblNacionalidadTitular.Text = dt.Rows(0)("NACIONALIDAD_TITULAR")
                End If

            Else
                fsNSSExtranjero.Visible = False
                fsAsignacionNSS.Visible = True

                If IsDBNull(dt.Rows(0)("Desc_Error")) Then
                    lblDescError.Text = String.Empty
                Else
                    lblDescError.Text = dt.Rows(0)("Desc_Error")
                End If

                If IsDBNull(dt.Rows(0)("ARS_DES")) Then
                    lblARS.Text = String.Empty
                Else
                    lblARS.Text = dt.Rows(0)("ARS_DES")
                End If

                If IsDBNull(dt.Rows(0)("NO_DOCUMENTO")) Then
                    lblDocumento.Text = String.Empty
                Else
                    If dt.Rows(0)("NO_DOCUMENTO").ToString().Length = 11 Then
                        lblDocumento.Text = Utils.FormatearCedula(dt.Rows(0)("NO_DOCUMENTO"))
                    Else
                        lblDocumento.Text = dt.Rows(0)("NO_DOCUMENTO")
                    End If
                End If

                lblNombres.Text = dt.Rows(0)("Nombres")
                lblPrimerApellido.Text = dt.Rows(0)("Primer_Apellido")

                If IsDBNull(dt.Rows(0)("SEGUNDO_APELLIDO")) Then
                    lblSegundoApellido.Text = String.Empty
                Else
                    lblSegundoApellido.Text = dt.Rows(0)("SEGUNDO_APELLIDO")
                End If

                lblSexo.Text = dt.Rows(0)("Sexo")
                lblFechaNac.Text = dt.Rows(0)("Fecha_Nacimiento")

                If IsDBNull(dt.Rows(0)("Nombre_Padre")) Then
                    lblPadre.Text = String.Empty
                Else
                    lblPadre.Text = dt.Rows(0)("Nombre_Padre")
                End If

                If IsDBNull(dt.Rows(0)("Nombre_Madre")) Then
                    lblMadre.Text = String.Empty
                Else
                    lblMadre.Text = dt.Rows(0)("Nombre_Madre")
                End If

                If IsDBNull(dt.Rows(0)("Id_Nacionalidad")) Then
                    lblNacionalidad.Text = String.Empty
                Else
                    lblNacionalidad.Text = dt.Rows(0)("Id_Nacionalidad")
                End If

                If IsDBNull(dt.Rows(0)("ID_PROVINCIA")) Then
                    lblProvincia.Text = String.Empty
                Else
                    lblProvincia.Text = dt.Rows(0)("ID_PROVINCIA")
                End If

                If IsDBNull(dt.Rows(0)("PROVINCIA_DES")) Then
                    lblProvinciaDes.Text = String.Empty
                Else
                    lblProvinciaDes.Text = " - " + dt.Rows(0)("PROVINCIA_DES")
                End If

                If IsDBNull(dt.Rows(0)("MUNICIPIO_ACTA")) Then
                    lblMunicipio.Text = String.Empty
                Else
                    lblMunicipio.Text = dt.Rows(0)("MUNICIPIO_ACTA")
                End If
                If IsDBNull(dt.Rows(0)("MUNICIPIO_DES")) Then
                    lblMunicipioDes.Text = String.Empty
                Else
                    lblMunicipioDes.Text = " - " + dt.Rows(0)("MUNICIPIO_DES")
                End If
                If IsDBNull(dt.Rows(0)("OFICIALIA_ACTA")) Then
                    lblOficialia.Text = String.Empty
                Else
                    lblOficialia.Text = dt.Rows(0)("OFICIALIA_ACTA")
                End If

                If IsDBNull(dt.Rows(0)("FOLIO_ACTA")) Then
                    lblFolio.Text = String.Empty
                Else
                    lblFolio.Text = dt.Rows(0)("FOLIO_ACTA")
                End If

                If IsDBNull(dt.Rows(0)("LIBRO_ACTA")) Then
                    lblLibro.Text = String.Empty
                Else
                    lblLibro.Text = dt.Rows(0)("LIBRO_ACTA")
                End If

                If IsDBNull(dt.Rows(0)("ANO_ACTA")) Then
                    lblAno.Text = String.Empty
                Else
                    lblAno.Text = dt.Rows(0)("ANO_ACTA")
                End If

                If IsDBNull(dt.Rows(0)("NUMERO_ACTA")) Then
                    lblNroActa.Text = String.Empty
                Else
                    lblNroActa.Text = dt.Rows(0)("NUMERO_ACTA")
                End If
            End If

            DetailsView1.DataSource = dt
            DetailsView1.DataBind()
        End If
    End Sub
    Protected Sub btnAsignacion_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAsignacion.Click

        If Session("contador").ToString() = "1" Then
            Response.Redirect(CallMe + "?CasoEvaluacion=" & _casoEvaluacion)
        End If
        Session("contador") = 1
        Try
            Dim result As String
            If ddlMotivo.SelectedValue <> "0" Then
                Me.lbl_error.Visible = True
                Me.lbl_error.Text = "Al asignar un nss no puede existir un motivo de rechazo seleccionado"
                Exit Sub
            End If

            result = SuirPlus.Ars.Consultas.AsignacionNssCiudadanos(_idsolicitud, UsrUserName)

            If Split(result, "|")(0) = "0" Then
                Session.Remove("contador")
                Response.Redirect(CallMe)
            Else
                Throw New Exception("Error asignando el NSS al ciudadano...")
            End If

        Catch ex As Exception
            Me.lbl_error.Visible = True
            Me.lbl_error.Text = ex.Message
        End Try

    End Sub
    Protected Sub btnSalir_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSalir.Click
        Response.Redirect(CallMe)
    End Sub
    Protected Sub btnRechazar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRechazar.Click
        Dim nssDuplicado As Integer = 0

        If ddlMotivo.SelectedValue = "0" Then
            Me.lbl_error.Visible = True
            Me.lbl_error.Text = " Debe seleccionar el Motivo de Rechazo"
            Exit Sub
        End If

        If ddlNSSDuplicados.SelectedValue <> "" Then
            nssDuplicado = CInt(ddlNSSDuplicados.SelectedValue.ToString())
        End If

        Try
            Dim ressultado As String
            ressultado = SuirPlus.Ars.Consultas.RechazarEvaluacionAsig(_idsolicitud, nssDuplicado, ddlMotivo.SelectedValue, UsrUserName)
            Response.Redirect(CallMe)

        Catch ex As Exception
            Me.lbl_error.Visible = True
            Me.lbl_error.Text = ex.Message
        End Try
    End Sub
    Private Sub CargarMotivoRechazo(ByVal tipoMotivos As String)

        Dim dt As New DataTable
        dt = Ars.Consultas.GetMotivoRechazoAsignacion(tipoMotivos)

        If dt.Rows.Count > 0 Then
            ddlMotivo.DataSource = dt
            ddlMotivo.DataTextField = "error_des"
            ddlMotivo.DataValueField = "id_error"
            ddlMotivo.DataBind()
        End If
        ddlMotivo.Items.Insert(0, New ListItem("<-- Seleccione -->", "0"))
        ddlMotivo.SelectedValue = 0

    End Sub
    Private Sub CargarNSSDuplicados(ByVal idsolicitud As Integer)
        Dim dt As New DataTable
        dt = Ars.Consultas.GetNSSDuplicados(idsolicitud)

        If dt.Rows.Count > 0 Then
            fsNSSDuplicado.Visible = True
            ddlNSSDuplicados.DataSource = dt
            ddlNSSDuplicados.DataTextField = "nss"
            ddlNSSDuplicados.DataValueField = "nss"
            ddlNSSDuplicados.DataBind()

            'llenar data nss duplicado default
            CargarInfoNSSDuplicado(Convert.ToInt32(dt.Rows(0)("nss")))
            'cargar motivos de rechazos para casos con duplicidad de nss en ciudadanos
            CargarMotivoRechazo("N")
        Else
            fsNSSDuplicado.Visible = False
            'cargar motivos de rechazos para casos sin duplicidad de nss en ciudadanos
            CargarMotivoRechazo("S")
        End If

    End Sub
    Private Sub CargarInfoNSSDuplicado(ByVal idNSS As Integer)

        Dim dt As New DataTable
        dt = Ars.Consultas.getInfoNSSDuplicado(idNSS)

        If dt.Rows.Count > 0 Then
            btnActualizar.Visible = True

            If IsDBNull(dt.Rows(0)("NO_DOCUMENTO")) Then
                lblDocumentoNSS.Text = String.Empty
            Else
                If dt.Rows(0)("NO_DOCUMENTO").ToString().Length = 11 Then
                    lblDocumentoNSS.Text = Utils.FormatearCedula(dt.Rows(0)("NO_DOCUMENTO"))
                Else
                    lblDocumentoNSS.Text = dt.Rows(0)("NO_DOCUMENTO")
                End If
            End If

            lblNombresNSS.Text = dt.Rows(0)("Nombres")
            lblPrimerApellidoNSS.Text = dt.Rows(0)("Primer_Apellido")

            If IsDBNull(dt.Rows(0)("SEGUNDO_APELLIDO")) Then
                lblSegundoApellidoNSS.Text = String.Empty
            Else
                lblSegundoApellidoNSS.Text = dt.Rows(0)("SEGUNDO_APELLIDO")
            End If

            lblSexoNSS.Text = dt.Rows(0)("Sexo")
            lblFechaNacNSS.Text = dt.Rows(0)("Fecha_Nacimiento")

            If IsDBNull(dt.Rows(0)("Nombre_Padre")) Then
                lblPadreNSS.Text = String.Empty
            Else
                lblPadreNSS.Text = dt.Rows(0)("Nombre_Padre")
            End If

            If IsDBNull(dt.Rows(0)("Nombre_Madre")) Then
                lblMadreNSS.Text = String.Empty
            Else
                lblMadreNSS.Text = dt.Rows(0)("Nombre_Madre")
            End If

            If IsDBNull(dt.Rows(0)("Id_Nacionalidad")) Then
                lblNacionalidadNSS.Text = String.Empty
            Else
                lblNacionalidadNSS.Text = dt.Rows(0)("Id_Nacionalidad")
            End If

            If IsDBNull(dt.Rows(0)("ID_PROVINCIA")) Then
                lblProvinciaNSS.Text = String.Empty
            Else
                lblProvinciaNSS.Text = dt.Rows(0)("ID_PROVINCIA")
            End If
            If IsDBNull(dt.Rows(0)("PROVINCIA_DES")) Then
                lblProvinciaNSSDes.Text = String.Empty
            Else
                lblProvinciaNSSDes.Text = " - " + dt.Rows(0)("PROVINCIA_DES")
            End If

            If IsDBNull(dt.Rows(0)("MUNICIPIO_ACTA")) Then
                lblMunicipioNSS.Text = String.Empty
            Else
                lblMunicipioNSS.Text = dt.Rows(0)("MUNICIPIO_ACTA")
            End If
            If IsDBNull(dt.Rows(0)("MUNICIPIO_DES")) Then
                lblMunicipioNSSDes.Text = String.Empty
            Else
                lblMunicipioNSSDes.Text = " - " + dt.Rows(0)("MUNICIPIO_DES")
            End If

            If IsDBNull(dt.Rows(0)("OFICIALIA_ACTA")) Then
                lblOficialiaNSS.Text = String.Empty
            Else
                lblOficialiaNSS.Text = dt.Rows(0)("OFICIALIA_ACTA")
            End If

            If IsDBNull(dt.Rows(0)("FOLIO_ACTA")) Then
                lblFolioNSS.Text = String.Empty
            Else
                lblFolioNSS.Text = dt.Rows(0)("FOLIO_ACTA")
            End If

            If IsDBNull(dt.Rows(0)("LIBRO_ACTA")) Then
                lblLibroNSS.Text = String.Empty
            Else
                lblLibroNSS.Text = dt.Rows(0)("LIBRO_ACTA")
            End If

            If IsDBNull(dt.Rows(0)("ANO_ACTA")) Then
                lblAnoNSS.Text = String.Empty
            Else
                lblAnoNSS.Text = dt.Rows(0)("ANO_ACTA")
            End If

            If IsDBNull(dt.Rows(0)("NUMERO_ACTA")) Then
                lblNroActaNSS.Text = String.Empty
            Else
                lblNroActaNSS.Text = dt.Rows(0)("NUMERO_ACTA")
            End If
            If (dt.Rows(0)("TIENE_IMAGEN").ToString() = "N") Then
                lbVerActa.Visible = False
            Else
                lbVerActa.Visible = True
            End If
        Else
            btnActualizar.Visible = False
        End If
    End Sub

    Protected Sub ddlNSSDuplicados_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlNSSDuplicados.SelectedIndexChanged
        CargarInfoNSSDuplicado(CInt(ddlNSSDuplicados.SelectedItem.ToString()))
    End Sub

    Protected Sub lbHistóricoARS_Click(sender As Object, e As EventArgs) Handles lbHistóricoARS.Click
        Response.Redirect("~\consultas\consARS.aspx?id_nss=" & ddlNSSDuplicados.SelectedItem.ToString())
    End Sub

    Protected Sub ddlMotivo_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlMotivo.SelectedIndexChanged
        If lbl_error.Text <> String.Empty Then
            lbl_error.Text = String.Empty
        End If
    End Sub

    Protected Sub btnActualizar_Click(sender As Object, e As EventArgs) Handles btnActualizar.Click
        Try
            SuirPlus.Ars.Consultas.ActualizarCiudadanoDuplicado(_idsolicitud, ddlNSSDuplicados.SelectedValue, 429, UsrUserName)
            Response.Redirect(CallMe)
        Catch ex As Exception
            Me.lbl_error.Visible = True
            Me.lbl_error.Text = ex.Message
        End Try
    End Sub

    Protected Sub lbVerActa_Click(sender As Object, e As EventArgs) Handles lbVerActa.Click
        Dim url As String = "VerActaCiudadano.aspx?idNSS=" & ddlNSSDuplicados.SelectedValue
        Dim s As String = "window.open('" & url + "', 'popup_window', 'width=600,height=500,resizable=yes');"
        ScriptManager.RegisterClientScriptBlock(upnlNSSDuplicado, upnlNSSDuplicado.GetType(), "script", s, True)
    End Sub

End Class

