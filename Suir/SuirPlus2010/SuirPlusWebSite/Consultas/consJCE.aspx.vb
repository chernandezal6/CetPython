Imports System.Data
Imports SuirPlus.Ars
Imports SuirPlus
Imports System.Collections.Generic
Imports SuirPlus.Exepciones
Imports System.IO
Imports System.Net
Imports System.Xml
Imports System.Security.Cryptography.X509Certificates
Imports System.Globalization


Partial Class Consultas_consJCE
    Inherits BasePage
    Private procesar As Boolean = True
    Public Rs As HttpWebResponse
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        lblMsg.Visible = False
        lblMsg.CssClass = "error"
        btnActualizar.Visible = False
        btnInsertar.Visible = False
        btnCancelar.Visible = False

        hfCedulaJCE.Value = String.Empty
        hfCedulaTSS.Value = String.Empty
        hfNombreJCE.Value = String.Empty
        hfNombreTSS.Value = String.Empty

    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As System.EventArgs) Handles btnBuscar.Click
        'limpiamos los controles para luego realizar la nueva busqueda
        lblMsg.Visible = False
        lblMsg.Text = String.Empty
        limpiarJCE()
        limpiarTSS()
        btnCancelar.Visible = True
        btnCancelar.Text = "Cancelar"
        Try
            ''validamos el nro de documento
            validarDocumento()
            ''verificamos que el usuario logueado tenga el permiso requerido
            verificarPermisos()
        Catch ex As Exception
            fsTSS.Visible = False
            fsJCE.Visible = False
            lblMsg.Visible = True
            lblMsg.Text = ex.Message
            Exit Sub
        End Try

        ''buscamos el ciudadano en JCE
        Try
            consCiudadanoJCE(txtDocumento.Text)

            fsJCE.Visible = True
            pnlInfoJCE.Visible = True
            divmsgJCE.Visible = False
        Catch ex As Exception
            pnlInfoJCE.Visible = False
            fsJCE.Visible = True
            lblmsgJCE.Text = ex.Message
            divmsgJCE.Visible = True
        End Try

        ''buscamos el ciudadano en TSS
        Try
            CargarNSSDuplicados(txtDocumento.Text, lblNombres.Text, lblPrimerApellido.Text, lblSegundoApellido.Text, lblFechaNac.Text, lblSexo.Text, lblCodMunicipio.Text, lblAno.Text, lblFolio.Text, lblNroActa.Text, lblLibro.Text, lblOficialia.Text)

            fsTSS.Visible = True
            pnlInfoTSS.Visible = True
            divmsgTSS.Visible = False
        Catch ex As Exception
            pnlInfoTSS.Visible = False
            fsTSS.Visible = True
            lblmsgTSS.Text = ex.Message
            divmsgTSS.Visible = True
        End Try
        ''organizamos el display de los botones
        ordenarBotones()

    End Sub
    'cargar datos desde JCE via webservice  
    Protected Sub consCiudadanoJCE(ByVal documento As String)
        Try

            Dim ID1 As String = documento.Substring(0, 3)
            Dim ID2 As String = documento.Substring(3, 7)
            Dim ID3 As String = documento.Substring(10, 1)
            Dim url As String = String.Empty

            'buscamos los parametros necesarios para la conección con el webservice de la JCE
            Dim dt = Utilitarios.TSS.getWS_JCE_Parametros("WS JCE")
            If dt.Rows.Count > 0 Then
                Dim urlParam = dt.Rows(0)("field1").ToString()
                Dim serviceIdParam = dt.Rows(0)("field2").ToString()
                If (urlParam <> String.Empty) And (serviceIdParam <> String.Empty) Then
                    url = urlParam & serviceIdParam & "&ID1=" & ID1 & "&ID2=" & ID2 & "&ID3=" & ID3
                Else
                    Throw New Exception("Error de conección al webservice.")
                End If
            Else
                Throw New Exception("Error de conección al webservice.")
            End If

            Dim prxInternet As New SuirPlus.Config.Configuracion(Config.ModuloEnum.ProxyInternet)
            Dim infoWS As New SuirPlus.Config.Configuracion(Config.ModuloEnum.WS_JCE)

            Dim ProxyUser As String = prxInternet.FTPUser
            Dim ProxyIP As String = prxInternet.FTPHost
            Dim ProxyDomain As String = prxInternet.FTPDir
            Dim ProxyPort As String = prxInternet.FTPPort
            Dim ProxyPass As String = prxInternet.FTPPass
            Dim dataPass As Byte() = Convert.FromBase64String(ProxyPass)
            ProxyPass = System.Text.ASCIIEncoding.ASCII.GetString(dataPass)

            Dim Autenticacion As New NetworkCredential(ProxyUser, ProxyPass, ProxyDomain) 'poner usuario y password de la red
            Dim ProxyServer As New WebProxy(ProxyIP, Convert.ToInt32(ProxyPort))
            ProxyServer.Credentials = Autenticacion

            Dim rd As XmlTextReader
            Dim wrq As HttpWebRequest
            wrq = WebRequest.Create(url)
            wrq.Proxy = ProxyServer
            wrq.Proxy.Credentials = ProxyServer.Credentials
            wrq.UserAgent = "RobotTSS"

            rd = New XmlTextReader(wrq.GetResponse.GetResponseStream)

            rd.WhitespaceHandling = WhitespaceHandling.None
            Dim ced1 As String = String.Empty
            Dim ced2 As String = String.Empty
            Dim ced3 As String = String.Empty
            Dim sex As String = String.Empty
            Dim result As String = String.Empty
            Dim nombreP As String = String.Empty
            Dim apellidoP1 As String = String.Empty
            Dim apellidop2 As String = String.Empty
            Dim cedulaP As String = String.Empty
            Dim nombreM As String = String.Empty
            Dim apellidoM1 As String = String.Empty
            Dim apellidoM2 As String = String.Empty
            Dim cedulaM As String = String.Empty
            Dim cedulaC As String = String.Empty

            hfCodSex.Value = String.Empty

            Rs = wrq.GetResponse()
            'se ejecuta un metodo de la base de datos que consume webservice e inserta en sre_trans_jce_t como XML
            SuirPlus.Operaciones.ConsultasJCE.gettranslimite(documento, "C")

            While rd.Read()
                If rd.Name = "root" Then
                    Continue While
                End If

                If rd.Name = "success" Then
                    result = rd.ReadElementString("success")
                    If result = "false" Then
                        pnlInfoJCE.Visible = False

                        Throw New Exception("Este ciudadano no existe en la base de datos de la JCE.")
                    End If
                End If
                If rd.Name = "" Then
                    Continue While
                End If

                If rd.Name = "mun_ced" Then
                    ced1 = rd.ReadElementString("mun_ced")
                End If
                If rd.Name = "seq_ced" Then
                    ced2 = rd.ReadElementString("seq_ced")
                End If
                If rd.Name = "ver_ced" Then
                    ced3 = rd.ReadElementString("ver_ced")
                    lblCedula.Text = ced1 + "-" + ced2 + "-" + ced3
                    hfCedulaJCE.Value = lblCedula.Text
                End If
                If rd.Name = "nombres" Then
                    lblNombres.Text = rd.ReadElementString("nombres")
                    hfNombreJCE.Value = lblNombres.Text
                End If
                If rd.Name = "apellido1" Then
                    lblPrimerApellido.Text = rd.ReadElementString("apellido1")
                End If
                If rd.Name = "apellido2" Then
                    lblSegundoApellido.Text = rd.ReadElementString("apellido2")
                End If
                If rd.Name = "fecha_nac" Then
                    Dim fecha = rd.ReadElementString("fecha_nac")

                    If fecha <> Nothing Then
                        Dim parts As String() = fecha.Split(New Char() {"/"})
                        Dim mes As String = parts(0)
                        Dim dias As String = parts(1)
                        Dim ano As String = parts(2)
                        lblFechaNac.Text = dias.PadLeft(2, "0") + "/" + mes.PadLeft(2, "0") + "/" + ano.Substring(0, 4)
                    End If

                End If

                If rd.Name = "cod_sangre" Then
                    lblCodSangre.Text = rd.ReadElementString("cod_sangre")
                End If

                If rd.Name = "sexo" Then

                    If rd.ReadElementString("sexo").ToString() = "F" Then
                        sex = "FEMENINO"
                        hfCodSex.Value = "F"
                    Else
                        sex = "MASCULINO"
                        hfCodSex.Value = "M"
                    End If
                    lblSexo.Text = sex
                End If

                If rd.Name = "cod_nacion" Then
                    lblCodNacion.Text = rd.ReadElementString("cod_nacion")
                End If

                If rd.Name = "est_civil" Then
                    lblEstadoCivil.Text = rd.ReadElementString("est_civil")
                End If
                If rd.Name = "cedula_padre" Then
                    cedulaP = rd.ReadElementString("cedula_padre")
                End If

                If rd.Name = "cedula_madre" Then
                    cedulaM = rd.ReadElementString("cedula_madre")
                End If
                If rd.Name = "cedula_conyugue" Then
                    cedulaC = rd.ReadElementString("cedula_conyugue")
                End If

                If rd.Name = "tipo_causa" Then
                    lblTipoCausa.Text = rd.ReadElementString("tipo_causa")
                End If

                If rd.Name = "cod_causa" Then
                    lblCodCausa.Text = rd.ReadElementString("cod_causa")
                End If

                If rd.Name = "acta_mun" Then
                    lblCodMunicipio.Text = rd.ReadElementString("acta_mun")
                End If

                If rd.Name = "acta_ofic" Then
                    lblOficialia.Text = rd.ReadElementString("acta_ofic")
                End If
                If rd.Name = "acta_libro" Then
                    lblLibro.Text = rd.ReadElementString("acta_libro")
                End If
                If rd.Name = "acta_folio" Then
                    lblFolio.Text = rd.ReadElementString("acta_folio")
                End If
                If rd.Name = "acta_numero" Then
                    lblNroActa.Text = rd.ReadElementString("acta_numero")
                End If
                If rd.Name = "acta_ano" Then
                    lblAno.Text = rd.ReadElementString("acta_ano")
                End If

                If rd.Name = "estatus" Then
                    lblEstatus.Text = rd.ReadElementString("estatus")
                End If
                If rd.Name = "desc_estatus" Then
                    lblEstatusDesc.Text = rd.ReadElementString("desc_estatus")
                End If
                If rd.Name = "fecha_cancelacion" Then
                    hfFechaCancelacion.Value = rd.ReadElementString("fecha_cancelacion")
                End If

                If rd.Name = "padre_nombres" Then
                    nombreP = rd.ReadElementString("padre_nombres")
                End If
                If rd.Name = "padre_apellido1" Then
                    apellidoP1 = rd.ReadElementString("padre_apellido1")
                End If
                If rd.Name = "padre_apellido2" Then
                    apellidop2 = " " + rd.ReadElementString("padre_apellido2")
                End If
                If nombreP <> "" Then
                    lblPadreNombre.Text = apellidoP1 + apellidop2 + ", " + nombreP
                    If cedulaP <> "" Then
                        lblCedulaP.Text = cedulaP
                    End If
                End If

                If rd.Name = "madre_nombres" Then
                    nombreM = rd.ReadElementString("madre_nombres")
                End If
                If rd.Name = "madre_apellido1" Then
                    apellidoM1 = rd.ReadElementString("madre_apellido1")
                End If
                If rd.Name = "madre_apellido2" Then
                    apellidoM2 = " " + rd.ReadElementString("madre_apellido2")
                End If
                If nombreM <> "" Then
                    lblMadreNombres.Text = apellidoM1 + apellidoM2 + ", " + nombreM
                    If cedulaM <> "" Then
                        lblCedulaM.Text = cedulaM
                    End If
                End If

            End While
            rd.Close()
            'para complementar datos del ciudadano(descripcion:municipio,tipo sangre,nacionalidad,causa inhabilidad)

            Dim dtComplemento = Utilitarios.TSS.getComplementoCiudadano(lblCodMunicipio.Text, lblCodSangre.Text, lblCodNacion.Text, lblCodCausa.Text, lblTipoCausa.Text)
            If dtComplemento.Rows.Count > 0 Then
                lblMunicipio.Text = dtComplemento(0)("desc_Municipio").ToString()
                lblSangre.Text = dtComplemento(0)("desc_Sangre").ToString()
                lblNacionalidad.Text = dtComplemento(0)("desc_Nacionalidad").ToString()
                lblCausaInhabilidad.Text = dtComplemento(0)("desc_CausaInhabilidad").ToString()

            End If

        Catch ex As System.Net.WebException
            Rs = ex.Response
            Throw New Exception(ex.Message)
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        limpiarJCE()
        limpiarTSS()
        Response.Redirect("consJCE.aspx")
    End Sub

    Protected Sub btnInsertar_Click(sender As Object, e As System.EventArgs) Handles btnInsertar.Click
        Try
            procesarCiudadano("I")
            txtDocumento.Text = hfCedulaJCE.Value
            'buscamos el ciudadano en TSS
            CargarInfoNss(hfNSS.Value)
            hfNSS.Value = String.Empty
            lblMsg.Visible = True
            lblMsg.Text = "Registro Insertado satisfactoriamente.!!!"
            lblMsg.CssClass = "subHeader"
            fsTSS.Visible = True
            pnlInfoTSS.Visible = True
            divmsgTSS.Visible = False
            btnCancelar.Visible = True
            btnCancelar.Text = "Limpiar..."
        Catch ex As Exception
            btnActualizar.Visible = False
            btnInsertar.Visible = False
            btnCancelar.Visible = True
            pnlInfoTSS.Visible = False
            fsTSS.Visible = True
            divmsgTSS.Visible = True
            lblmsgTSS.Text = ex.Message
        End Try


    End Sub

    Protected Sub btnActualizar_Click(sender As Object, e As System.EventArgs) Handles btnActualizar.Click
        Try
            procesarCiudadano("A")
            txtDocumento.Text = hfCedulaJCE.Value
            CargarInfoNss(hfNSS.Value)
            hfNSS.Value = String.Empty
            tdNssDuplicados.Visible = False
            lblMsg.Visible = True
            lblMsg.Text = "Registro Actualizado satisfactoriamente.!!!"
            lblMsg.CssClass = "subHeader"
            fsTSS.Visible = True
            pnlInfoTSS.Visible = True
            divmsgTSS.Visible = False
            btnCancelar.Visible = True
            btnCancelar.Text = "Limpiar..."
        Catch ex As Exception
            btnActualizar.Visible = False
            btnInsertar.Visible = False
            btnCancelar.Visible = True
            pnlInfoTSS.Visible = False
            fsTSS.Visible = True
            divmsgTSS.Visible = True
            lblmsgTSS.Text = ex.Message
        End Try
    End Sub

    Protected Sub procesarCiudadano(ByVal accion As String)
        Try
            Dim result As String = String.Empty
            Dim fechaNacimiento As Date
            Dim fechaCancelacion As Date

            If lblFechaNac.Text <> "" Then
                fechaNacimiento = CDate(lblFechaNac.Text)
            End If
            If hfFechaCancelacion.Value <> "" Then
                fechaCancelacion = Date.Parse(hfFechaCancelacion.Value, System.Globalization.CultureInfo.InvariantCulture)
            End If
            hfCedulaJCE.Value = lblCedula.Text.Replace("-", "")
            result = Utilitarios.TSS.procesarCiudadano(lblCedula.Text.Replace("-", ""), lblNombres.Text, lblPrimerApellido.Text,
                                              lblSegundoApellido.Text, lblEstadoCivil.Text, fechaNacimiento, hfCodSex.Value,
                                              lblCodSangre.Text, lblCodNacion.Text, Trim(lblPadreNombre.Text), Trim(lblMadreNombres.Text),
                                              lblCodMunicipio.Text, lblOficialia.Text, lblLibro.Text, lblFolio.Text, lblNroActa.Text,
                                              lblAno.Text, lblTipoCausa.Text, lblCodCausa.Text, lblEstatus.Text, UsrUserName, accion, fechaCancelacion, hfNSS.Value)

            If Split(result, "|")(0) = "0" Then
                If accion = "I" Then
                    hfNSS.Value = Split(result, "|")(1)
                End If
            Else
                Throw New Exception(result)
            End If
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try
    End Sub

    Protected Sub validarDocumento()
        Try
            If String.IsNullOrEmpty(txtDocumento.Text) = True Then
                Throw New Exception("El número de documento es requerido")
            ElseIf txtDocumento.Text.Length <> 11 Then
                Throw New Exception("El número de documento es inválido")
            ElseIf Not IsNumeric(txtDocumento.Text) Then
                Throw New Exception("El número de documento debe ser numérico")
            End If
        Catch ex As Exception
            Throw ex
        End Try

    End Sub

    Protected Sub verificarPermisos()
        'verificamos el permiso para saber la infomacion que se mostrará, si existe, 
        'es un representante o una entidad externa, por lo que solo se muestra el nombre, apellidos y fecha de nacimiento del ciudadano, de lo contrario, mostrará toda la información del ciudadano
        If Not IsInPermiso("352") Then
            pnlMasInfoJCE.Visible = True
            pnlMasInfoTSS.Visible = True
        Else
            pnlMasInfoJCE.Visible = False
            pnlMasInfoTSS.Visible = False
        End If


        'verificamos si puede hacer insert en ciudadanos TSS
        If Not IsInPermiso("321") Then
            btnInsertar.Enabled = False
            btnInsertar.ForeColor = Drawing.Color.DimGray
        Else
            btnInsertar.Enabled = True
        End If

        'verificamos si puede hacer update en ciudadano TSS
        If Not IsInPermiso("322") Then
            btnActualizar.Enabled = False
            btnActualizar.ForeColor = Drawing.Color.DimGray
        Else
            btnActualizar.Enabled = True
        End If


    End Sub

    Protected Sub ordenarBotones()

        If (lblNombres.Text <> String.Empty) And (lblNombres1.Text <> String.Empty) Then
            btnActualizar.Visible = True
            btnInsertar.Visible = False
        ElseIf (lblNombres.Text = String.Empty) And (lblNombres1.Text <> String.Empty) Then
            btnActualizar.Visible = False
            btnInsertar.Visible = False
        ElseIf (lblNombres.Text <> String.Empty) And (lblNombres1.Text = String.Empty) Then
            If lblmsgTSS.Text.StartsWith("Este ciudadano no existe") Then
                btnActualizar.Visible = False
                btnInsertar.Visible = True
            Else
                btnActualizar.Visible = False
                btnInsertar.Visible = False
            End If
        End If

        btnCancelar.Visible = True
    End Sub

    Protected Sub limpiarJCE()
        hfCodSex.Value = String.Empty
        pnlInfoJCE.Visible = False
        lblCedula.Text = String.Empty
        hfCedulaJCE.Value = String.Empty
        hfNombreJCE.Value = String.Empty
        lblCedula.Text = String.Empty
        lblNombres.Text = String.Empty
        lblPrimerApellido.Text = String.Empty
        lblSegundoApellido.Text = String.Empty
        lblFechaNac.Text = String.Empty
        lblCodMunicipio.Text = String.Empty
        lblMunicipio.Text = String.Empty
        lblCodSangre.Text = String.Empty
        lblSangre.Text = String.Empty
        hfCodSex.Value = String.Empty
        hfCodSex.Value = String.Empty
        lblSexo.Text = String.Empty
        lblCodNacion.Text = String.Empty
        lblNacionalidad.Text = String.Empty
        lblEstadoCivil.Text = String.Empty
        lblTipoCausa.Text = String.Empty
        lblCodCausa.Text = String.Empty
        lblCausaInhabilidad.Text = String.Empty
        lblOficialia.Text = String.Empty
        lblLibro.Text = String.Empty
        lblFolio.Text = String.Empty
        lblNroActa.Text = String.Empty
        lblAno.Text = String.Empty
        lblEstatus.Text = String.Empty
        lblEstatusDesc.Text = String.Empty
        lblPadreNombre.Text = String.Empty
        lblCedulaP.Text = String.Empty
        lblMadreNombres.Text = String.Empty
    End Sub

    Protected Sub limpiarTSS()
        tdNssDuplicados.Visible = False
        hfNSS.Value = String.Empty
        lblCedula1.Text = String.Empty
        hfCedulaTSS.Value = String.Empty
        hfNombreTSS.Value = String.Empty
        lblNombres1.Text = String.Empty
        lblPrimerApellido1.Text = String.Empty
        lblSegundoApellido1.Text = String.Empty
        lblEstadoCivil1.Text = String.Empty
        lblFechaNacimiento1.Text = String.Empty
        lblSexo1.Text = String.Empty
        lblCodSangre1.Text = String.Empty
        lblSangre1.Text = String.Empty
        lblCodCausa1.Text = String.Empty
        lblCausaInhabilidad1.Text = String.Empty
        lblCodNacion1.Text = String.Empty
        lblNacionalidad1.Text = String.Empty
        lblPadreNombre1.Text = String.Empty
        lblMadreNombres1.Text = String.Empty
        lblCodMunicipio1.Text = String.Empty
        lblMunicipio1.Text = String.Empty
        lblAno1.Text = String.Empty
        lblNroActa1.Text = String.Empty
        lblFolio1.Text = String.Empty
        lblLibro1.Text = String.Empty
        lblOficialia1.Text = String.Empty
        lblEstatus1.Text = String.Empty
        lblTipoCausa1.Text = String.Empty

    End Sub

    '**************************************************
    Private Sub CargarNSSDuplicados(ByVal documento As String, ByVal nombres As String, ByVal primerApellido As String, ByVal segundo_apellido As String, ByVal fechaNacimiento As String,
                                    ByVal sexo As String, munActa As String, anoActa As String, folioActa As String, numeroActa As String, libroActa As String, oficialiaActa As String)
        Dim dt As New DataTable
        Dim sex As String = String.Empty
        If sexo = "MASCULINO" Then
            sex = "M"
        ElseIf sexo = "FEMENINO" Then
            sex = "F"
        End If

        dt = Utilitarios.TSS.getCiudadanoDup(documento, nombres, primerApellido, segundo_apellido, fechaNacimiento, sex, munActa, anoActa, folioActa, numeroActa, libroActa, oficialiaActa)

        If dt.Rows.Count > 0 Then
            'llenamos combo de nss encontrados con el mismo criterio
            ddlNSSDuplicados.DataSource = dt
            ddlNSSDuplicados.DataTextField = "id_nss"
            ddlNSSDuplicados.DataValueField = "id_nss"
            ddlNSSDuplicados.DataBind()

            'llenar data nss duplicado default
            CargarInfoNss(Convert.ToInt32(dt.Rows(0)("id_nss")))
            If dt.Rows.Count > 1 Then
                tdNssDuplicados.Visible = True
            Else
                tdNssDuplicados.Visible = False
            End If
        Else
            Throw New Exception("Este ciudadano no existe en la base de datos TSS.")
        End If

    End Sub

    Protected Sub ddlNSSDuplicados_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlNSSDuplicados.SelectedIndexChanged
        Try
            CargarInfoNss(CInt(ddlNSSDuplicados.SelectedValue.ToString()))
        Catch ex As Exception
            pnlInfoTSS.Visible = False
            fsTSS.Visible = True
            lblmsgTSS.Text = ex.Message
            divmsgTSS.Visible = True
        End Try
        ''organizamos el display de los botones
        ordenarBotones()
    End Sub

    Private Sub CargarInfoNss(ByRef idNss As Integer)
        Try
            Dim dt As New DataTable
            dt = Utilitarios.TSS.getCiudadanoNSS(idNss)

            If dt.Rows.Count = 0 Then
                Throw New Exception("Este ciudadano no existe en la base de datos TSS.")
            Else

                If Not IsDBNull(dt.Rows(0)("no_documento")) Then
                    lblCedula1.Text = Utilitarios.Utils.FormatearCedula(dt.Rows(0)("no_documento").ToString())
                    hfCedulaTSS.Value = lblCedula1.Text
                End If

                If Not IsDBNull(dt.Rows(0)("nombres")) Then
                    lblNombres1.Text = dt.Rows(0)("nombres")
                    hfNombreTSS.Value = lblNombres1.Text
                    hfNSS.Value = dt.Rows(0)("id_nss")
                End If

                lblPrimerApellido1.Text = dt.Rows(0)("primer_apellido").ToString()
                lblSegundoApellido1.Text = dt.Rows(0)("segundo_apellido").ToString()
                lblEstadoCivil1.Text = dt.Rows(0)("estado_civil").ToString()
                If Not IsDBNull(dt.Rows(0)("fecha_nacimiento")) Then
                    lblFechaNacimiento1.Text = CDate(dt.Rows(0)("fecha_nacimiento").ToString())
                End If

                lblSexo1.Text = dt.Rows(0)("sexo_des").ToString()
                lblCodSangre1.Text = dt.Rows(0)("id_tipo_sangre").ToString()
                lblSangre1.Text = dt.Rows(0)("tipo_sangre_des").ToString()
                lblCodCausa1.Text = dt.Rows(0)("id_causa_inhabilidad").ToString()
                lblCausaInhabilidad1.Text = dt.Rows(0)("cancelacion_des").ToString()
                lblCodNacion1.Text = dt.Rows(0)("id_nacionalidad").ToString()
                lblNacionalidad1.Text = dt.Rows(0)("nacionalidad_des").ToString()
                lblPadreNombre1.Text = dt.Rows(0)("nombre_padre").ToString()
                lblMadreNombres1.Text = dt.Rows(0)("nombre_madre").ToString()
                lblCodMunicipio1.Text = dt.Rows(0)("id_municipio").ToString()
                lblMunicipio1.Text = dt.Rows(0)("municipio_des").ToString()
                lblAno1.Text = dt.Rows(0)("ano_acta").ToString()
                lblNroActa1.Text = dt.Rows(0)("numero_acta").ToString()
                lblFolio1.Text = dt.Rows(0)("folio_acta").ToString()
                lblLibro1.Text = dt.Rows(0)("libro_acta").ToString()
                lblOficialia1.Text = dt.Rows(0)("oficialia_acta").ToString()
                lblEstatus1.Text = dt.Rows(0)("status").ToString()
                lblTipoCausa1.Text = dt.Rows(0)("tipo_causa").ToString()

            End If

        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try
    End Sub

End Class

