Imports System.Data
Imports SuirPlus.Mantenimientos

Partial Class Solicitudes_ManejoSolicitudesDetalle
    Inherits BasePage
    Dim IdSolicitud As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        IdSolicitud = Request.QueryString("NroSol")

        If Not IsNumeric(IdSolicitud) Then
            Me.lblMensaje.Text = "El Nro. de solicitud no es válido"
            Exit Sub
        End If

        If Not Page.IsPostBack Then
            'iniForm()
            CargarDropDowns()
            cargaSolicitudDrops()
            BindDetalle(IdSolicitud)



        End If

        TrTipo.Visible = False
        TrParque.Visible = False

    End Sub

    Private Sub BindDetalle(ByVal Nro As Integer)

        Me.ucSol.NroSolicitud = Nro
        Me.ucSol.Visible = True
        Me.ucSol.Mostrar()

        Try
            Dim Sol As New SuirPlus.SolicitudesEnLinea.Solicitudes(Nro)
            Me.ddlEst.SelectedValue = Sol.IdStatus

            If Me.ddlEst.SelectedValue = 3 Then
                Me.ddlEst.Enabled = False
            End If


            If Sol.TipoSolicitud = "Registro de Empresa" Then

                If (Sol.Status = "Abierta") Or (Sol.Status = "En Proceso") Or (Sol.Status = "Entregada") Or (Sol.Status = "Rechazado") Then
                    'status1.Visible = False
                End If

                'btnEditar.Visible = True
                'pnlFormulario.Visible = True
                'cargarSolicitud(IdSolicitud)
                'gvarchivos.DataSource = SuirPlus.SolicitudesEnLinea.Solicitudes.CargarAdjuntos(IdSolicitud)
                'gvarchivos.DataBind()
                'Table2.Visible = False
                'status1.Visible = False
                Table1.Visible = True
                'Me.ddlEst.SelectedValue = dt.Rows(0)("idStatus").ToString()

            End If

            Me.txtComentario.Text = String.Empty

            If String.IsNullOrEmpty(Sol.TipoSolicitud) Then

                CargarMaco(Nro)
            End If

        Catch ex As Exception
            '' No encontro el detalle de la Solicitud en la Tabla.....Pero lo buscamos en la tabla general           
            CargarMaco(Nro)
        End Try


    End Sub

    Private Sub CargarMaco(ByVal Nro As Integer)
        Try
            Dim dt As New DataTable

            dt = SuirPlus.SolicitudesEnLinea.Solicitudes.CargarDatos(Nro)


            If dt.Rows.Count > 0 Then



                If dt.Rows(0).Item(2).ToString() = "Registro de Empresa" Then


                    If dt.Rows(0).Item(3).ToString() = "Completada" Then
                        'btnEditar.Visible = True
                        'pnlFormulario.Visible = True
                        'cargarSolicitud(IdSolicitud)
                        'gvarchivos.DataSource = SuirPlus.SolicitudesEnLinea.Solicitudes.CargarAdjuntos(IdSolicitud)
                        'gvarchivos.DataBind()
                        'Table2.Visible = False
                        'status1.Visible = False

                        Table1.Visible = True
                        Me.ddlEst.SelectedValue = dt.Rows(0)("idStatus").ToString()
                    Else
                        If (dt.Rows(0)(3).ToString() = "Abierta") Or (dt.Rows(0)(3).ToString() = "En Proceso") Or (dt.Rows(0)(3).ToString() = "Entregada") Or (dt.Rows(0)(3).ToString() = "Rechazado") Then
                            'status1.Visible = False
                            'Me.ddlEst.SelectedValue = dt.Rows(0)(2).ToString()
                            Me.ddlEst.SelectedValue = dt.Rows(0)("idStatus").ToString()
                        End If

                    End If

                Else
                    Me.ddlEst.SelectedValue = dt.Rows(0)("idStatus").ToString()
                    'status1.Visible = False

                    If Me.ddlEst.SelectedValue = 3 Then
                        Me.ddlEst.Enabled = False
                    End If

                End If

                Me.txtComentario.Text = IIf(IsDBNull(dt.Rows(0)("comentarios")), String.Empty, dt.Rows(0)("comentarios").ToString())

                End If
        Catch exs As Exception
            Me.txtComentario.Text = exs.Message
        End Try
    End Sub

    Protected Sub btAct_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btAct.Click

        Dim mensaje As String

        mensaje = SuirPlus.SolicitudesEnLinea.Solicitudes.CambiarStatus(IdSolicitud, _
                                                                        Me.ddlEst.SelectedValue, _
                                                                        MyBase.UsrUserName, _
                                                                        Me.txtComentario.Text)

        Try
            If mensaje.Split("|")(0) <> "0" Then

                Me.lblMensaje.Text = mensaje.Split("|")(1)
                Me.lblMensaje.Visible = True

            End If
        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            Me.lblMensaje.Visible = True
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

        Me.ucSol.Visible = False

        Response.Redirect("ManejoSolicitudes.aspx")
    End Sub

    Private Sub CargarDropDowns()

        Dim dtStatus As DataTable

        dtStatus = SuirPlus.SolicitudesEnLinea.Solicitudes.getStatus()

        Me.ddlEst.DataSource = dtStatus
        Me.ddlEst.DataTextField = "descripcion"
        Me.ddlEst.DataValueField = "id_status"
        Me.ddlEst.DataBind()


    End Sub
    Protected Sub ChkEsZonaFranca_CheckedChanged(sender As Object, e As EventArgs)
        If ChkEsZonaFranca.Checked = True Then
            TrTipo.Visible = True
            TrParque.Visible = True
        Else
            TrTipo.Visible = False
            TrParque.Visible = False
        End If
    End Sub

    Protected Sub cargaSolicitudDrops()
        Try
            'Cargando DropDown de Sectores Economicos
            Me.ddlSectorEconomico.DataSource = SuirPlus.Utilitarios.TSS.getSectoresEconomicos()
            Me.ddlSectorEconomico.DataValueField = "ID_SECTOR_ECONOMICO"
            Me.ddlSectorEconomico.DataTextField = "SECTOR_ECONOMICO_DES"

            'Cargando DropDown de Provincias
            Me.ddlProvincia.DataSource = SuirPlus.Utilitarios.TSS.getProvincias()
            Me.ddlProvincia.DataValueField = "ID_PROVINCIA"
            Me.ddlProvincia.DataTextField = "PROVINCIA_DES"

            'cargando sectores salariales
            ddlSectorSalarial.DataSource = SuirPlus.Mantenimientos.SectoresSalariales.getSectoresSalariales()
            ddlSectorSalarial.DataTextField = "descripcion"
            ddlSectorSalarial.DataValueField = "id"

            'cargando actividad economica
            ddlActividad.DataSource = SuirPlus.MDT.General.listarActividad()
            ddlActividad.DataTextField = "descripcion"
            ddlActividad.DataValueField = "id"

            'cargamos los parques zona franca
            ddlParque.DataSource = SuirPlus.MDT.General.listarParqueZonaFranca
            ddlParque.DataTextField = "descripcion"
            ddlParque.DataValueField = "id"


            'Cargando dd de municipios 
            'Me.ddlMunicipio.DataSource = SuirPlus.Utilitarios.TSS.getMunicipios(Me.ddlProvincia.SelectedValue, "")
            'Me.ddlMunicipio.DataValueField = "ID_MUNICIPIO"
            'Me.ddlMunicipio.DataTextField = "MUNICIPIO_DES"


            'Cargamos los valores del ddlTipoZona
            ddlTipoZonaFranca.Items.Insert(0, "Comercial")
            ddlTipoZonaFranca.Items.Insert(1, "Normal")



            Me.DataBind()

            'asignamos default value en los dropdowns

            ddlSectorSalarial.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
            ddlSectorSalarial.SelectedIndex = 0

            Me.ddlProvincia.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
            Me.ddlProvincia.SelectedIndex = 0

            Me.ddlSectorEconomico.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
            Me.ddlSectorEconomico.SelectedIndex = 0

            Me.ddlActividad.Items.Insert(0, New ListItem("<-- Seleccione -->", ""))
            Me.ddlActividad.SelectedIndex = 0

            Me.ddlParque.Items.Insert(0, New ListItem("<-- Seleccione -->", ""))
            Me.ddlParque.SelectedIndex = 0

            Me.ddlTipoZonaFranca.Items.Insert(0, New ListItem("<-- Seleccione -->", ""))
            Me.ddlTipoZonaFranca.SelectedIndex = 0



        Catch ex As Exception
            'Me.lblFormError.Text = ex.Message
            'SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub iniForm()

        Me.ddlProvincia.SelectedIndex = 0
        Me.ddlMunicipio.Items.Clear()
        Me.ddlMunicipio.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
        Me.ddlMunicipio.SelectedIndex = 0
        Me.txtRazonSocial.Text = ""
        Me.txtNombreComercial.Text = ""
        Me.ddlSectorEconomico.SelectedIndex = 0
        Me.ddlSectorSalarial.SelectedIndex = 0
        Me.txtCalle.Text = ""
        Me.txtNumero.Text = ""
        Me.txtEdificio.Text = ""
        Me.txtPiso.Text = ""
        Me.txtApartamento.Text = ""
        Me.txtSector.Text = ""
        Me.ddlProvincia.SelectedIndex = 0
        Me.Telefono1.phoneNumber = String.Empty
        Me.Telefono2.phoneNumber = String.Empty
        Me.Fax.phoneNumber = String.Empty

        Me.txtEmail.Text = String.Empty


        'Me.imgBusqueda.Visible = False

        'Seteando paneles
        'Me.pnlFormulario.Visible = True

        'Me.upFormulario.Update()

    End Sub

    Protected Sub ddlProvincia_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlProvincia.SelectedIndexChanged
        If Me.ddlProvincia.SelectedValue = "-1" Then

            Me.ddlMunicipio.Items.Clear()
            Me.ddlMunicipio.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
            Me.ddlMunicipio.SelectedIndex = 0

        Else

            'Cargando dd de municipios 
            Me.ddlMunicipio.DataSource = SuirPlus.Utilitarios.TSS.getMunicipios(Me.ddlProvincia.SelectedValue, "")
            Me.ddlMunicipio.DataValueField = "ID_MUNICIPIO"
            Me.ddlMunicipio.DataTextField = "MUNICIPIO_DES"

            Me.ddlMunicipio.DataBind()

            Me.ddlMunicipio.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
            Me.ddlMunicipio.SelectedIndex = 0

        End If

    End Sub

    Protected Sub LimpiarControles()

        txtRazonSocial.Text = String.Empty
        txtNombreComercial.Text = String.Empty
        txtRNCCedula.Text = String.Empty
        ddlSectorSalarial.Visible = False
        ddlSectorEconomico.Visible = False
        ddlActividad.Visible = False
        ddlTipoZonaFranca.Visible = False
        ddlParque.Visible = False
        txtCalle.Text = String.Empty
        txtNumero.Text = String.Empty
        txtApartamento.Text = String.Empty
        txtSector.Text = String.Empty
        ddlProvincia.Visible = False
        Telefono1.phoneNumber = String.Empty
        txtExt1.Text = String.Empty
        Telefono2.phoneNumber = String.Empty
        txtExt2.Text = String.Empty
        Fax.phoneNumber = String.Empty
        txtEmail.Text = String.Empty
        ddlMunicipio.Visible = False
        txtComentario1.Text = String.Empty


    End Sub



    Protected Sub cargarSolicitud(ByVal solicitud As Integer)
        Dim empresa As DataTable = Nothing

        Try
            empresa = SuirPlus.SolicitudesEnLinea.Solicitudes.getInfoEmpresaEdit(solicitud)
            If empresa.ToString <> String.Empty Then

                txtRazonSocial.Text = empresa.Rows(0).Item(0).ToString()
                txtNombreComercial.Text = empresa.Rows(0).Item(1).ToString()
                txtRNCCedula.Text = empresa.Rows(0).Item(2).ToString()
                ddlSectorSalarial.SelectedValue = empresa.Rows(0).Item(3)
                ddlSectorEconomico.SelectedValue = empresa.Rows(0).Item(4)
                ddlActividad.SelectedValue = empresa.Rows(0).Item(5)
                ddlTipoZonaFranca.SelectedValue = empresa.Rows(0).Item(6)
                ddlParque.SelectedValue = empresa.Rows(0).Item(7)
                txtCalle.Text = empresa.Rows(0).Item(8).ToString()
                txtNumero.Text = empresa.Rows(0).Item(9).ToString()
                txtApartamento.Text = empresa.Rows(0).Item(10).ToString()
                txtSector.Text = empresa.Rows(0).Item(11).ToString()
                ddlProvincia.SelectedValue = empresa.Rows(0).Item(12)
                Telefono1.phoneNumber = empresa.Rows(0).Item(14).ToString()
                txtExt1.Text = empresa.Rows(0).Item(15).ToString()
                Telefono2.phoneNumber = empresa.Rows(0).Item(16).ToString()
                txtExt2.Text = empresa.Rows(0).Item(17).ToString()
                Fax.phoneNumber = empresa.Rows(0).Item(18).ToString()
                txtEmail.Text = empresa.Rows(0).Item(19).ToString()
                txtNroDocuemnto.Text = empresa.Rows(0).Item(20).ToString()
                RepTelefono1.phoneNumber = empresa.Rows(0).Item(21).ToString()
                txtRepExt1.Text = empresa.Rows(0).Item(22).ToString()
                RepTelefono2.phoneNumber = empresa.Rows(0).Item(23).ToString()
                txtRepExt2.Text = empresa.Rows(0).Item(24).ToString()
                LblRepr.Text = SuirPlus.SolicitudesEnLinea.Solicitudes.GetRepresentante(txtNroDocuemnto.Text).Rows(0).Item(0).ToString()

                ''Cargando dd de municipios 
                Me.ddlMunicipio.DataSource = SuirPlus.Utilitarios.TSS.getMunicipios(Me.ddlProvincia.SelectedValue, "")
                Me.ddlMunicipio.DataValueField = "ID_MUNICIPIO"
                Me.ddlMunicipio.DataTextField = "MUNICIPIO_DES"
                Me.ddlMunicipio.DataBind()
                ddlMunicipio.SelectedValue = empresa.Rows(0).Item(13)


            End If

        Catch Ex As Exception
            Me.lblMensaje.Text = Ex.Message
            SuirPlus.Exepciones.Log.LogToDB(Ex.ToString())
        End Try

    End Sub


    Protected Sub btnAprobar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAprobar.Click

        ' Actualizamos los datos de la empresa en la tabla de sel_empleadores_tmp en caso que el representante de TSS
        ' le halla hecho algun cambio a la informacion antes de su aprobacion

        SuirPlus.SolicitudesEnLinea.Solicitudes.ActualizaDatosEmpresa(txtRazonSocial.Text,
                                                                      txtNombreComercial.Text,
                                                                      ddlSectorSalarial.SelectedValue,
                                                                    ddlSectorEconomico.SelectedValue,
                                                                    ddlActividad.SelectedValue,
                                                                    ddlTipoZonaFranca.SelectedValue,
                                                                    ddlParque.SelectedValue,
                                                                    txtCalle.Text,
                                                                    txtNumero.Text,
                                                                    txtApartamento.Text,
                                                                    txtSector.Text,
                                                                    ddlProvincia.SelectedValue,
                                                                    ddlMunicipio.SelectedValue,
                                                                    Telefono1.phoneNumber,
                                                                    txtExt1.Text,
                                                                    Telefono2.phoneNumber,
                                                                    txtExt2.Text,
                                                                    Fax.phoneNumber,
                                                                    txtEmail.Text,
                                                                    txtNroDocuemnto.Text,
                                                                    RepTelefono1.phoneNumber,
                                                                    txtRepExt1.Text,
                                                                    RepTelefono2.phoneNumber,
                                                                    txtRepExt2.Text,
                                                                    IdSolicitud)

        ' Insertamos en el empleador en sre_empleadores_t

        Dim strRet As String = SuirPlus.Empresas.Empleador.insertaEmpleador(Me.ddlSectorSalarial.SelectedValue,
                                                                                 ddlMunicipio.SelectedValue,
                                                                                 txtRNCCedula.Text,
                                                                                 txtRazonSocial.Text,
                                                                                 txtNombreComercial.Text,
                                                                                 txtCalle.Text,
                                                                                 txtNumero.Text,
                                                                                 txtEdificio.Text,
                                                                                 txtPiso.Text,
                                                                                 txtApartamento.Text,
                                                                                 txtSector.Text,
                                                                                 Telefono1.phoneNumber,
                                                                                 txtExt1.Text,
                                                                                 Telefono2.phoneNumber,
                                                                                 txtExt2.Text,
                                                                                 Fax.phoneNumber,
                                                                                 txtEmail.Text,
                                                                                 "PR",
                                                                                 ddlSectorSalarial.SelectedValue,
                                                                                 Nothing,
                                                                                 ddlActividad.SelectedValue,
                                                                                 ddlParque.SelectedValue,
                                                                                 Nothing,
                                                                                 ddlTipoZonaFranca.SelectedValue,
                                                                                 "HMINAYA")



        If Split(strRet, "|")(0) = "0" Then
            'Obteniendo el nuevo codigo de Registro Patronal
            Dim tmpRegistroPatronal As Integer = Integer.Parse(Split(strRet, "|")(1))
            Dim tmpIdNomina As Integer
            Dim retRep As String

            SuirPlus.Empresas.CRM.insertaRegistroCRM(tmpRegistroPatronal, "Solicitud registro nueva empresa", Nothing, 2, Nothing, "Empleador generado correctamente", "HMINAYA", Nothing, Nothing, Nothing)

            'Insertando Representante
            retRep = SuirPlus.Empresas.Representante.insertaRepresentante(txtNroDocuemnto.Text,
                                                                          tmpRegistroPatronal,
                                                                              "A",
                                                                              "N",
                                                                              RepTelefono1.phoneNumber,
                                                                              txtRepExt1.Text,
                                                                              RepTelefono2.phoneNumber,
                                                                              txtRepExt2.Text,
                                                                              txtEmail.Text,
                                                                              "OPERACIONES")



            ''Verificando posibles errores al crear el representante
            If Split(retRep, "|")(0) = "0" Then
                Dim Mensaje = Split(retRep, "|")(1)

                SuirPlus.Empresas.CRM.insertaRegistroCRM(tmpRegistroPatronal, "Solicitud registro nueva empresa", Nothing, 2, Nothing, " Representante creado correctamente", "HMINAYA", Nothing, Nothing, Nothing)

                'Insertando Nomina
                SuirPlus.Empresas.Nomina.insertaNomina(tmpRegistroPatronal, "Nómina Principal", "A", "N", Nothing)

                'Opteniendo el nuevo numero de nomina
                tmpIdNomina = Integer.Parse(SuirPlus.Empresas.Nomina.getNomina(tmpRegistroPatronal, -1).Rows(0).Item(1))

                'Consultamos el representante insertado para obtener su NSS'
                Dim ciudadano = SuirPlus.Utilitarios.TSS.consultaCiudadano("C", txtNroDocuemnto.Text)
                Dim nss As String = String.Empty

                If Not ciudadano = String.Empty Then
                    nss = Split(ciudadano, "|")(3)
                End If

                'Dando acceso a nomina
                'El usuario ha utilizar debe ser creado para el manejo de este servicio

                SuirPlus.Empresas.Representante.darAccesoNomina(tmpRegistroPatronal, tmpIdNomina, Integer.Parse(nss), "HMINAYA")

                ' Insertando CRM 
                SuirPlus.Empresas.CRM.insertaRegistroCRM(tmpRegistroPatronal, "Solicitud registro nueva empresa", Nothing, 2, Nothing, "Nomina creada correctamente", "HMINAYA", Nothing, Nothing, Nothing)

                'Actualizamos el ststus en sel_solicitudes_t
                SuirPlus.SolicitudesEnLinea.Solicitudes.CambiarStatus(Me.IdSolicitud, "4", Me.User.ToString, Me.txtComentario1.Text)

                ' Actualizamos el status en sel_empleadores_TMP_t
                SuirPlus.SolicitudesEnLinea.Solicitudes.ActStatusTmp(IdSolicitud, "A")

                'Return New JavaScriptSerializer().Serialize(Mensaje)
                LimpiarControles()
                InfArchivos.Visible = False
                InfoDatos.Visible = False
                InfoRepresenatnte.Visible = False
                btnAprobar.Visible = False
                btnRechazar.Visible = False
                InfoEmpleador.Visible = False
                InfoComentarioSol.Visible = False
                lblregistro.Text = "Empleador registrado sastifactoriamente."
                Response.Redirect("ManejoSolicitudes.aspx")


            Else
                lblerror.Text = "El Empleador ya existe"
                lblerror.Visible = True
            End If
        End If

    End Sub

    Protected Sub btnRechazar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRechazar.Click


        ' Actualizamos los datos de la solicitud en la tabla de sel_empleadores_tmp

        SuirPlus.SolicitudesEnLinea.Solicitudes.ActualizaDatosEmpresa(txtRazonSocial.Text,
                                                                      txtNombreComercial.Text,
                                                                      ddlSectorSalarial.SelectedValue,
                                                                    ddlSectorEconomico.SelectedValue,
                                                                    ddlActividad.SelectedValue,
                                                                    ddlTipoZonaFranca.SelectedValue,
                                                                    ddlParque.SelectedValue,
                                                                    txtCalle.Text,
                                                                    txtNumero.Text,
                                                                    txtApartamento.Text,
                                                                    txtSector.Text,
                                                                    ddlProvincia.SelectedValue,
                                                                    ddlMunicipio.SelectedValue,
                                                                    Telefono1.phoneNumber,
                                                                    txtExt1.Text,
                                                                    Telefono2.phoneNumber,
                                                                    txtExt2.Text,
                                                                    Fax.phoneNumber,
                                                                    txtEmail.Text,
                                                                    txtNroDocuemnto.Text,
                                                                    RepTelefono1.phoneNumber,
                                                                    txtRepExt1.Text,
                                                                    RepTelefono2.phoneNumber,
                                                                    txtRepExt2.Text,
                                                                    IdSolicitud)

        ' Actualizamos el status de la solicitud a rechazada
        SuirPlus.SolicitudesEnLinea.Solicitudes.CambiarStatus(Me.IdSolicitud, "5", Me.User.ToString, Me.txtComentario1.Text)

        ' Actualizamos el status en sel_empleadores_TMP_t
        SuirPlus.SolicitudesEnLinea.Solicitudes.ActStatusTmp(IdSolicitud, "R")


        LimpiarControles()
        InfArchivos.Visible = False
        InfoDatos.Visible = False
        InfoRepresenatnte.Visible = False
        btnAprobar.Visible = False
        btnRechazar.Visible = False
        InfoEmpleador.Visible = False
        InfoComentarioSol.Visible = False

        lblregistro.Text = "El registro de empleador ha sido rechazado."
        Response.Redirect("ManejoSolicitudes.aspx")

    End Sub




    Protected Sub gvarchivos_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvarchivos.RowCommand

        Dim Resultado1 = e.CommandArgument.ToString()
        Dim resultado2 = e.CommandName.ToString()
        'Response.Redirect(Application("servidor") + "Solicitudes/ImgManejoSolicitudes.aspx?idDoc=" + Resultado1 + "&req=" + resultado2)

        Response.Write("<script>")
        Response.Write("window.open('" + Application("servidor") + "Solicitudes/ImgManejoSolicitudes.aspx?idDoc=" + Resultado1 + "&req=" + resultado2 + "','_blank')")
        Response.Write("</script>")

    End Sub

End Class
