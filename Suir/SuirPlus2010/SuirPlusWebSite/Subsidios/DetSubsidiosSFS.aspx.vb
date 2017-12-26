Imports SuirPlus

Partial Class Subsidios_DetSubsidiosSFS
    Inherits BasePage
    Dim tipo As String
    Dim tipoSubsidio As String
    Dim IdSolicitud As Integer
    Dim regPatronal As String

    Protected Sub Subsidios_DetSubsidiosSFS_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (Request.QueryString.Get("IdSolicitud") IsNot Nothing) And (Request.QueryString.Get("Tipo") IsNot Nothing) Then
            IdSolicitud = CInt(Request.QueryString.Get("IdSolicitud"))
            tipo = HttpUtility.UrlDecode(Request.QueryString.Get("Tipo"))

            If Request.QueryString.Get("rnc") <> String.Empty Then
                regPatronal = Utilitarios.TSS.getRegistroPatronal(Request.QueryString.Get("rnc"))
                trCargarImagenEnf.Visible = False
                trCargarImagenMat.Visible = False
            Else
                regPatronal = UsrRegistroPatronal
                trCargarImagenEnf.Visible = True
                trCargarImagenMat.Visible = True
            End If
            pnlDetLactancia.Visible = False
            pnlDetMaternidad.Visible = False
            pnlDetEnfComun.Visible = False

            Select Case tipo

                Case "M"
                    tipoSubsidio = "M"
                    cargarDetMaternidad()

                Case "L"
                    tipoSubsidio = "L"
                    cargarDetLactancia()

                Case "E"
                    tipoSubsidio = "E"
                    cargarDetEnfComun()
                Case Else
                    lblMensaje.Text = "Tipo de Subsidio SFS Inválido"
                    Exit Sub
            End Select

        End If
        cargarCuotasSubsidios()
    End Sub

    Protected Sub cargarDetMaternidad()
        Try

            Dim dtMaternidad As Data.DataTable
            dtMaternidad = Empresas.SubsidiosSFS.Consultas.getDetSubsidiosSFS_M(IdSolicitud, regPatronal)

            If dtMaternidad.Rows.Count > 0 Then
                Me.pnlDetMaternidad.Visible = True
                Me.lblNroSolicitud.Text = dtMaternidad.Rows(0)("NRO_SOLICITUD")

                Me.lblTipoSubsidio.Text = "Maternidad"

                If dtMaternidad.Rows(0)("NOMBRE_SOLICITANTE").ToString() <> String.Empty Then
                    Me.lblNombreSolicitante.Text = dtMaternidad.Rows(0)("NOMBRE_SOLICITANTE")
                End If

                If dtMaternidad.Rows(0)("FECHA_ESTIMADA_PARTO").ToString() <> String.Empty Then
                    Me.lblFechaEstimadaParto.Text = dtMaternidad.Rows(0)("FECHA_ESTIMADA_PARTO")
                End If

                If dtMaternidad.Rows(0)("SALARIO_COTIZABLE").ToString() <> String.Empty Then
                    Me.lblSalarioCotizable.Text = String.Format("{0:n}", dtMaternidad.Rows(0)("SALARIO_COTIZABLE"))
                End If

                If dtMaternidad.Rows(0)("NSS_TUTOR").ToString() <> String.Empty Then
                    Me.lblNssTutor.Text = dtMaternidad.Rows(0)("NSS_TUTOR")
                End If

                If dtMaternidad.Rows(0)("TUTOR").ToString() <> String.Empty Then
                    Me.lblnombreTutor.Text = dtMaternidad.Rows(0)("TUTOR")
                End If

                If dtMaternidad.Rows(0)("ESTATUS_MATERNIDAD").ToString() <> String.Empty Then
                    Me.lblStatusMaternidad.Text = dtMaternidad.Rows(0)("ESTATUS_MATERNIDAD")
                End If

                If dtMaternidad.Rows(0)("FECHA_LICENCIA").ToString() <> String.Empty Then
                    Me.lblFechaLicencia.Text = dtMaternidad.Rows(0)("FECHA_LICENCIA")
                End If

                If dtMaternidad.Rows(0)("TIPO_LICENCIA").ToString() <> String.Empty Then
                    Me.lblTipoLicencia.Text = dtMaternidad.Rows(0)("TIPO_LICENCIA")
                End If

                If dtMaternidad.Rows(0)("FECHA_DIAGNOSTICO").ToString() <> String.Empty Then
                    Me.lblFechaDiagnostico.Text = dtMaternidad.Rows(0)("FECHA_DIAGNOSTICO")
                End If

                If dtMaternidad.Rows(0)("DOCUMENTO_SOLICITANTE").ToString() <> String.Empty Then
                    Me.lblCedulaSolicitante.Text = SuirPlus.Utilitarios.Utils.FormatearRNCCedula(dtMaternidad.Rows(0)("DOCUMENTO_SOLICITANTE"))
                End If

                If dtMaternidad.Rows(0)("DOCUMENTO_TUTOR").ToString() <> String.Empty Then
                    Me.lblCedulaTutor.Text = SuirPlus.Utilitarios.Utils.FormatearRNCCedula(dtMaternidad.Rows(0)("DOCUMENTO_TUTOR"))
                End If

                If dtMaternidad.Rows(0)("PIN").ToString() <> String.Empty Then
                    Me.lblPinMat.Text = dtMaternidad.Rows(0)("PIN")
                End If

                If dtMaternidad.Rows(0)("nombre_archivo").ToString() <> String.Empty Then

                    hfNombreImagen.Value = "1"
                Else
                    hfNombreImagen.Value = "0"
                End If

            Else
                Me.pnlDetMaternidad.Visible = False
                Throw New Exception("No hay datos para Mostrar")
            End If

        Catch ex As Exception
            lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub cargarDetLactancia()
        Try

            Dim dtLactancia As Data.DataTable
            dtLactancia = Empresas.SubsidiosSFS.Consultas.getDetSubsidiosSFS_L(IdSolicitud, regPatronal)

            If dtLactancia.Rows.Count > 0 Then
                Me.pnlDetLactancia.Visible = True
                Me.lblNroSolicitudL.Text = dtLactancia.Rows(0)("NRO_SOLICITUD")

                Me.lblTipoSubsidioL.Text = "Lactancia"

                If dtLactancia.Rows(0)("NOMBRE_SOLICITANTE").ToString() <> String.Empty Then
                    Me.lblNombreSolicitanteL.Text = dtLactancia.Rows(0)("NOMBRE_SOLICITANTE")
                End If

                If dtLactancia.Rows(0)("DOCUMENTO_SOLICITANTE").ToString() <> String.Empty Then
                    Me.lblCedulaSolicitanteL.Text = SuirPlus.Utilitarios.Utils.FormatearRNCCedula(dtLactancia.Rows(0)("DOCUMENTO_SOLICITANTE"))
                End If

                Me.lblCantLactantes.Text = dtLactancia.Rows(0)("CANT_LACTANTES")

                gvlactantes.DataSource = dtLactancia
                gvlactantes.DataBind()

            Else
                Me.pnlDetLactancia.Visible = False
                Throw New Exception("No hay datos para Mostrar")
            End If

        Catch ex As Exception
            lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub cargarDetEnfComun()
        Try
            Dim ambulatorio As String = String.Empty
            Dim hospitalizacion As String = String.Empty
            Dim dtEnfComun As Data.DataTable
            dtEnfComun = Empresas.SubsidiosSFS.Consultas.getDetSubsidiosSFS_E(IdSolicitud, regPatronal)

            If dtEnfComun.Rows.Count > 0 Then
                Me.pnlDetEnfComun.Visible = True
                Me.lblNroSolicitudE.Text = dtEnfComun.Rows(0)("NRO_SOLICITUD")
                Me.lblTipoSubsidioE.Text = "Enfermedad Común"
                Me.lblNombreSolicitanteE.Text = dtEnfComun.Rows(0)("NOMBRE_SOLICITANTE")

                If dtEnfComun.Rows(0)("NOMBRE_SOLICITANTE").ToString() <> String.Empty Then
                    Me.lblNombreSolicitanteE.Text = dtEnfComun.Rows(0)("NOMBRE_SOLICITANTE")
                End If
                If dtEnfComun.Rows(0)("FECHA_REGISTRO").ToString() <> String.Empty Then
                    Me.lblFechaRegistro.Text = dtEnfComun.Rows(0)("FECHA_REGISTRO")
                End If

                If dtEnfComun.Rows(0)("ESTATUS_REGISTRO").ToString() <> String.Empty Then
                    Me.lblStatusE.Text = dtEnfComun.Rows(0)("ESTATUS_REGISTRO")

                    If lblStatusE.Text <> "Completado" And lblStatusE.Text <> "Aprobado" And lblStatusE.Text <> "Rechazado" Then
                        tblInfo.Visible = False
                        divCuotas.Visible = False
                        divDatosPreliminares.Visible = True
                        cargarDatosPreliminares()
                    Else
                        tblInfo.Visible = True
                        divCuotas.Visible = True
                        cargarCuotasSubsidios()
                        divDatosPreliminares.Visible = False
                    End If
                End If

                If dtEnfComun.Rows(0)("PIN").ToString() <> String.Empty Then
                    Me.lblPin.Text = dtEnfComun.Rows(0)("PIN")
                End If

                If dtEnfComun.Rows(0)("CODIGOCIE10").ToString() <> String.Empty Then

                    Me.txtDescCodigoCIE.Text = dtEnfComun.Rows(0)("CODIGOCIE10")
                End If

                If dtEnfComun.Rows(0)("DOCUMENTO_SOLICITANTE").ToString() <> String.Empty Then
                    Me.lblCedulaSolicitanteE.Text = SuirPlus.Utilitarios.Utils.FormatearRNCCedula(dtEnfComun.Rows(0)("DOCUMENTO_SOLICITANTE"))
                End If

                If dtEnfComun.Rows(0)("TIPO_DISCAPACIDAD").ToString() <> String.Empty Then
                    Me.lblTipoDiscapacidad.Text = dtEnfComun.Rows(0)("TIPO_DISCAPACIDAD")
                End If

                If dtEnfComun.Rows(0)("AMBULATORIO").ToString() <> String.Empty Then
                    ambulatorio = dtEnfComun.Rows(0)("AMBULATORIO")
                    If ambulatorio = "Si" Then
                        lnkBtnASi.Visible = True
                        lnkBtnANo.Visible = False
                    Else
                        lnkBtnASi.Visible = False
                        lnkBtnANo.Visible = True
                    End If
                End If

                If dtEnfComun.Rows(0)("FECHA_INICIO_AMB").ToString() <> String.Empty Then
                    Me.lblFechaIniAmbulatorio.Text = dtEnfComun.Rows(0)("FECHA_INICIO_AMB")
                End If

                If dtEnfComun.Rows(0)("DIAS_CAL_AMB").ToString() <> String.Empty Then
                    Me.lblDiasLicAmbulatoria.Text = dtEnfComun.Rows(0)("DIAS_CAL_AMB")
                End If
                If dtEnfComun.Rows(0)("HOSPITALIZACION").ToString() <> String.Empty Then
                    hospitalizacion = dtEnfComun.Rows(0)("HOSPITALIZACION")
                    If hospitalizacion = "Si" Then
                        lnkBtnHSi.Visible = True
                        lnkBtnHNo.Visible = False
                    Else
                        lnkBtnHSi.Visible = False
                        lnkBtnHNo.Visible = True
                    End If
                End If
                If dtEnfComun.Rows(0)("FECHA_INICIO_HOS").ToString() <> String.Empty Then
                    Me.lblFechaIniHospitalizacion.Text = dtEnfComun.Rows(0)("FECHA_INICIO_HOS")
                End If
                If dtEnfComun.Rows(0)("DIAS_CAL_HOS").ToString() <> String.Empty Then
                    Me.lblDiasLicHospitalizacion.Text = dtEnfComun.Rows(0)("DIAS_CAL_HOS")
                End If

                If dtEnfComun.Rows(0)("FECHA_REINTEGRO").ToString() <> String.Empty Then
                    Me.lblFechaReintegro.Text = dtEnfComun.Rows(0)("FECHA_REINTEGRO")
                    trTituloReintegro.Visible = True
                    trReintegro.Visible = True
                Else
                    trTituloReintegro.Visible = False
                    trReintegro.Visible = False
                End If


                If dtEnfComun.Rows(0)("nombre_archivo").ToString() <> String.Empty Then
                    hfNombreImagenEnf.Value = "1"
                Else
                    hfNombreImagenEnf.Value = "0"
                End If

            Else
                Me.pnlDetEnfComun.Visible = False
                Throw New Exception("No hay datos para Mostrar")
            End If

        Catch ex As Exception
            lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub cargarDatosPreliminares()
        Dim dtCuotasPreliminares As Data.DataTable
        Dim regPat As String = String.Empty
        Try
            If tipoSubsidio <> "L" Then
                regPat = regPatronal
            End If

            dtCuotasPreliminares = Empresas.SubsidiosSFS.Consultas.getCuotasEnfComunPreliminares(IdSolicitud, regPat)

            If dtCuotasPreliminares.Rows.Count > 0 Then

                If dtCuotasPreliminares.TableName = "Error" Then
                    lblDatosPreliminares.Text = Utilitarios.Utils.sacarMensajeDeErrorDesdeTabla(dtCuotasPreliminares)
                    Throw New Exception(lblDatosPreliminares.Text)
                Else
                    gvDatosPreliminares.DataSource = dtCuotasPreliminares
                    gvDatosPreliminares.DataBind()
                End If

            Else
                Throw New Exception("No hay data para mostrar.")
            End If
        Catch ex As Exception
            lblDatosPreliminares.Visible = True
            lblDatosPreliminares.Text = ex.Message
        End Try

    End Sub

    Protected Sub cargarCuotasSubsidios()
        Dim dtCuotas As Data.DataTable
        Dim regPat As String = String.Empty
        Try


            If tipoSubsidio <> "L" Then
                regPat = regPatronal
            End If

            dtCuotas = Empresas.SubsidiosSFS.Consultas.getCuotasSubsidios(IdSolicitud, regPat, tipoSubsidio)

            If dtCuotas.Rows.Count > 0 Then
                gvCuotasSubsidios.DataSource = dtCuotas
                gvCuotasSubsidios.DataBind()
            Else
                Throw New Exception("No hay data para mostrar.")
            End If

        Catch ex As Exception
            lblmensajeCuotas.Visible = True
            lblmensajeCuotas.Text = ex.Message
        End Try
    End Sub

    Protected Sub gvCuotasSubsidios_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvCuotasSubsidios.RowDataBound
        Dim lblEstatusPago As Label = CType(e.Row.FindControl("lblEstatusPago"), Label)
        Dim lbtnSi As LinkButton = CType(e.Row.FindControl("lnkBtnSi"), LinkButton)
        Dim lbtnNo As LinkButton = CType(e.Row.FindControl("lnkBtnNo"), LinkButton)

        If lblEstatusPago IsNot Nothing Then
            If lblEstatusPago.Text = "P" Then
                lbtnSi.Visible = True
                lbtnNo.Visible = False
            Else
                lbtnSi.Visible = False
                lbtnNo.Visible = True
            End If
        End If
    End Sub

    Protected Sub lbRegresar_Click(sender As Object, e As System.EventArgs) Handles lbRegresar.Click

        If Request.QueryString.Get("rnc") <> String.Empty Then
            Response.Redirect("consSubsidiosSFSusr.aspx")
        Else
            Response.Redirect("consSubsidiosSFS.aspx")
        End If

    End Sub
End Class
