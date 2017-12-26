Imports System.Data
Imports SuirPlus.Empresas.SubsidiosSFS.Maternidad
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.SubsidiosSFS
Imports SuirPlus.Utilitarios.Utils
Partial Class Novedades_sfsBajaNovedad
    Inherits BasePage
    Private idNss As String = String.Empty
    Private TipoNovedad As String = String.Empty
    Dim empleada As Trabajador
    Dim madre As Maternidad
    Private Property panelActivo() As String
        Get
            Return CType(ViewState("panelActivo"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("panelActivo") = Value
        End Set
    End Property

    Private Property NoDocumento() As String
        Get
            Return CType(ViewState("NoDocumento"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("NoDocumento") = Value
        End Set
    End Property

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
  
        Me.lblMensaje.Visible = False
        Me.btnBajaNovedad.Visible = True
        If Not (Session("idNss") = String.Empty) And Not (Session("TipoNovedad") = String.Empty) Then
            idNss = Session("idNss")
            TipoNovedad = Session("TipoNovedad")
            Me.lblMensaje.Visible = False
            Try
                If Not Page.IsPostBack Then
                    'Cargamos el panel correspondiente a la novedad en curso
                    CargarDatosMadre()
                    CargarPanel()
                End If


            Catch ex As Exception
                lblMensaje.Text = ex.Message
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                Exit Sub
            End Try


        Else
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "Error con los datos de confirmación de la baja de novedades."
            Exit Sub

        End If

        If Page.IsPostBack = False Then
            Me.bindNovedades(Session("TipoNovedad"))
            Me.btnBajaNovedad.Attributes.Add("onclick", "return confirm('¿Esta seguro que quiere continuar con darle de baja a esta novedad?')")
        End If
    End Sub

    Protected Sub CargarPanel()
        Me.panelActivo = String.Empty
        Me.lblMensaje.Visible = True

        'RE = Registro de embarazo
        'LM = LICENCIA X MATERNIDAD
        'NC = Nacimiento
        'PE = Perdida de embarazo
        'ML = Muerte del lactante
        'MM = Muerte de la madre
        Select Case Session("TipoNovedad").ToString
            Case "RE"
                CargarDatosEmbarazo()
                Me.pnlEmbarazo.Visible = True
                panelActivo = 1
            Case "LM"
                CargarDatosLicencia()
                Me.pnlLicencia.Visible = True
                panelActivo = 2

            Case "NC"
                CargarDatosNacimiento()
                Me.pnlNacimiento.Visible = True
                panelActivo = 3

            Case "PE"
                CargarDatosPerdidaEmbarazo()
                Me.pnlPerdidaEmbarazo.Visible = True
                panelActivo = 4

            Case "ML"
                CargarDatosMuerteLactante()
                Me.pnlMuerteLactante.Visible = True
                panelActivo = 5

            Case "MM"
                CargarDatosMuerteMadre()
                Me.pnlMuerteMadre.Visible = True
                panelActivo = 6

        End Select
    End Sub

    Private Sub CargarDatosMadre()


        If idNss.Length > 0 Then
            If idNss.Length < 9 Then
                empleada = New Trabajador(CInt(idNss))
                madre = New Maternidad(CInt(idNss))
            ElseIf idNss.Length = 11 Then
                empleada = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, idNss)
                madre = New Maternidad(CInt(idNss))
            End If

            ucInfoEmpleado1.NombreEmpleado = String.Concat(empleada.Nombres, " ", empleada.PrimerApellido, " ", empleada.SegundoApellido)
            ucInfoEmpleado1.NSS = empleada.NSS.ToString
            ucInfoEmpleado1.Cedula = empleada.Documento
            ucInfoEmpleado1.Sexo = empleada.Sexo
            ucInfoEmpleado1.FechaNacimiento = empleada.FechaNacimiento
            ucInfoEmpleado1.SexoEmpleado = "Empleada"
            NoDocumento = empleada.Documento

            divMadre.Visible = True

        Else
            divMadre.Visible = False

        End If

    End Sub

    Private Sub CargarDatosEmbarazo()
        If Not madre Is Nothing Then
            lblFechaDiagnostico.Text = madre.FechaDiagnostico.ToShortDateString
            lblFechaEstimadaParto.Text = madre.FechaEstimadaParto.ToShortDateString
            lblFechaRegistroEmbarazo.Text = madre.FechaRegistroRegistroEmbarazo.ToShortDateString

            Dim empleador As New Empleador(CType(madre.EmpleadorRegistroEmbarazo, Int32))
            lblRazonSocialEmbarazo.Text = ProperCase(empleador.RazonSocial)

        End If

    End Sub

    Private Sub CargarDatosLicencia()
        If Not madre Is Nothing Then
            Dim empleador As New Empleador(CType(madre.EmpleadorRegistroEmbarazo, Int32))
            Dim licencia As New DataView
            licencia = getLicenciaEmpleador(madre.Cedula, empleador.RazonSocial)
            lblFechaLicencia.Text = CDate(licencia(0)("FECHA_LICENCIA")).ToShortDateString
            lblFechaRegistroLicencia.Text = CDate(licencia(0)("FECHA_REGISTRO")).ToShortDateString
            lblRazonSocialLicencia.Text = ProperCase(empleador.RazonSocial)

        End If
    End Sub

    Private Sub CargarDatosNacimiento()
        If Not madre Is Nothing Then
            If madre.getLactantes().Rows.Count > 0 Then
                Me.gvNacimientoLactantes.DataSource = madre.getLactantesVivos()
                Me.gvNacimientoLactantes.DataBind()
            End If

        End If

    End Sub

    Private Sub CargarDatosPerdidaEmbarazo()
        If Not madre Is Nothing Then
            lblFechaPerdidaEmbarazo.Text = madre.FechaPerdida.ToShortDateString
            lblFechaRegistroPerdida.Text = madre.FechaRegistroPerdidaEmbarazo.ToShortDateString

            Dim empleador As New Empleador(CType(madre.EmpleadorPerdidaEmbarazo, Int32))
            lblRazonSocialPerdida.Text = ProperCase(empleador.RazonSocial)

        End If
    End Sub

    Private Sub CargarDatosMuerteMadre()
        If Not madre Is Nothing Then

            If madre.FechaDefuncionMadre <> Nothing Then
                Me.lblFechaMuerteMadre.Text = String.Format("{0:d}", madre.FechaDefuncionMadre)
            End If

            If madre.FechaRegistroMuerteMadre <> Nothing Then
                Me.lblFechaRegistroMuerte.Text = String.Format("{0:d}", madre.FechaRegistroMuerteMadre)
            End If

            Dim empleador As New Empleador(CType(madre.EmpleadorMuerteMadre, Int32))
            lblRazonSocialMuerte.Text = ProperCase(empleador.RazonSocial)

        End If
    End Sub

    Private Sub CargarDatosMuerteLactante()

        If Not madre Is Nothing Then
            If madre.getLactantesFallecidos().Count > 0 Then
                Me.gvMuerteLactantes.DataSource = madre.getLactantesFallecidos()
                Me.gvMuerteLactantes.DataBind()
            End If

        End If
    End Sub


    Protected Sub btnBajaNovedad_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBajaNovedad.Click
        Me.lblMensaje.Text = String.Empty
        Me.btnBajaNovedad.Visible = False
        Me.divMadre.Visible = False
        Select Case panelActivo
            Case "1"
                BajaEmbarazo()
                Me.pnlEmbarazo.Visible = False
            Case "2"
                BajaLicencia()
                Me.pnlLicencia.Visible = False
            Case "3"
                BajaNacimiento()
                Me.pnlNacimiento.Visible = False
            Case "4"
                BajaPerdidaEmbarazo()
                Me.pnlPerdidaEmbarazo.Visible = False
            Case "5"
                BajaMuerteLactante()
                Me.pnlMuerteLactante.Visible = False
            Case "6"
                BajaMuerteMadre()
                Me.pnlMuerteMadre.Visible = False

        End Select

    End Sub

    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVolver.Click
        Session("nss") = idNss
        Response.Redirect("~/Novedades/sfsConsNovedades.aspx")
    End Sub

    Private Sub BajaEmbarazo()
        Dim resultado As String = String.Empty

        resultado = Maternidad.BajaReporteEmbarazo(NoDocumento, Me.UsrRegistroPatronal, Me.UsrRNC & Me.UsrCedula)

        ShowMovimientos(resultado)
    End Sub

    Private Sub BajaLicencia()
        Dim resultado As String = String.Empty

        resultado = Maternidad.BajaReporteLicencia(NoDocumento, Me.UsrRegistroPatronal, Me.UsrRNC & Me.UsrCedula)

        ShowMovimientos(resultado)
    End Sub

    Private Sub BajaNacimiento()
        'en caso de baja nacimiento

        Dim i As Integer = 1
        Dim gvrNac As GridViewRow
        For Each gvrNac In gvNacimientoLactantes.Rows
            Dim cbNac As CheckBox = DirectCast(gvrNac.FindControl("cbNacimiento"), CheckBox)

            If cbNac.Checked Then
                Dim resultado As String = String.Empty

                resultado = Maternidad.BajaReporteNacimiento(NoDocumento, Me.UsrRegistroPatronal, DirectCast(gvrNac.FindControl("lblSecuencia"), Label).Text, Me.UsrRNC & Me.UsrCedula)

                ShowMovimientos(resultado)

                'borrar el nacimiento seleccionado
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "Cantidad de Lactantes recien nacidos dados de baja: " & i
                i = i + 1
            End If
        Next


        
    End Sub

    Private Sub BajaPerdidaEmbarazo()
        Dim resultado As String = String.Empty

        resultado = Maternidad.BajaPerdidaEmbarazo(NoDocumento, Me.UsrRegistroPatronal, Me.UsrRNC & Me.UsrCedula)

        ShowMovimientos(resultado)
    End Sub

    Private Sub BajaMuerteLactante()
        ''en caso de baja lactante
        Dim j As Integer = 1
        Dim gvrLac As GridViewRow
        For Each gvrLac In gvMuerteLactantes.Rows
            Dim cbLac As CheckBox = DirectCast(gvrLac.FindControl("cbLactante"), CheckBox)

            If cbLac.Checked Then
                Dim resultado As String = String.Empty
                resultado = Maternidad.BajaReporteMuerteLactante(NoDocumento, Me.UsrRegistroPatronal, DirectCast(gvrLac.FindControl("lblSecuencia"), Label).Text, Me.UsrRNC & Me.UsrCedula)

                ShowMovimientos(resultado)

                'borrar el nacimiento seleccionado
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "Cantidad de Lactantes fallecidos dados de baja: " & j
                j = j + 1
            End If
        Next
    End Sub

    Private Sub BajaMuerteMadre()
        Dim resultado As String = String.Empty

        resultado = Maternidad.BajaReporteMuerteMadre(NoDocumento, Me.UsrRegistroPatronal, Me.UsrRNC & Me.UsrCedula)

        ShowMovimientos(resultado)

    End Sub

    Private Sub bindNovedades(ByVal tipoNovedad As String)
        Me.ucGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, "NV", "RE", "R", Me.UsrRNC & Me.UsrCedula)
        If Me.ucGridNovPendientes1.CantidadRecords > 0 Then
            Me.fiedlsetDatos1.Visible = True
        End If
    End Sub

    Private Sub ShowMovimientos(ByVal respuesta As String)

        If respuesta.Equals("OK") Then
            Me.bindNovedades(Session("TipoNovedad"))
            If Me.ucGridNovPendientes1.CantidadRecords > 0 Then
                Me.fiedlsetDatos1.Visible = True
            Else
                ucGridNovPendientes1.Mensaje = "Ha ocurrido un error, por favor intente nuevamente."
                ucGridNovPendientes1.Visible = True
                lblMsg.Text = "Grid no tiene datos!!"
            End If
        Else
            lblMsg.Text = respuesta
        End If

    End Sub

    Protected Sub btnAplicar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAplicar.Click
        Dim ret As String = SuirPlus.Empresas.Trabajador.aplicarMovimientos(Me.UsrRegistroPatronal, Me.UsrRNC & Me.UsrCedula)
        Response.Redirect("NovedadesAplicadas.aspx?msg=Novedades aplicadas satisfactoriamente.")
    End Sub
End Class
