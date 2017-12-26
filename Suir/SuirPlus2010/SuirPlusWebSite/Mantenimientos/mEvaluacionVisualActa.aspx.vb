Imports System.Data
Imports SuirPlus.Ars
Imports SuirPlus
Imports System.Collections.Generic
Imports SuirPlus.Exepciones


Partial Class Mantenimientos_mEvaluacionVisualActa
    Inherits BasePage
    Dim _IdRow As String
    Dim _casoEvaluacion As String
    Dim _regist As Integer
    Dim _SegundoNombre As String
    Dim CallMe As String

    Property idrow As String
        Get
            Return _IdRow
        End Get
        Set(ByVal value As String)
            _IdRow = value
        End Set
    End Property

    Property SegundoNombre As String
        Get
            Return _SegundoNombre
        End Get
        Set(ByVal value As String)
            _SegundoNombre = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CallMe = HttpContext.Current.Session("EvaluacionOrigen")
        If Not IsNothing(Request.QueryString("IdRow")) Then
            _IdRow = Request.QueryString("IdRow")
        End If
        If Not IsNothing(Request.QueryString("CasoEvaluacion")) Then
            _casoEvaluacion = Request.QueryString("CasoEvaluacion")
        End If
        If Not Page.IsPostBack Then
            CargaEvaluacion(_IdRow)
            CargarMotivoRechazo()
        End If
    End Sub
 

    Private Sub CargaEvaluacion(ByVal id As String)
        Dim dt As New DataTable
        dt = Ars.Consultas.getInfoEvaluacionActa(id)
        If dt.Rows.Count > 0 Then

            If IsDBNull(dt.Rows(0)("id_NSS")) Then
                LblNss1.Text = String.Empty
            Else
                LblNss1.Text = dt.Rows(0)("id_NSS")
            End If

            If IsDBNull(dt.Rows(0)("Desc_Error")) Then
                lblDescError.Text = String.Empty
            Else
                lblDescError.Text = dt.Rows(0)("Desc_Error")
            End If
            If IsDBNull(dt.Rows(0)("Primer_Nombre")) Then
                lblNombres1.Text = String.Empty
            Else
                lblNombres1.Text = dt.Rows(0)("Primer_Nombre")
            End If

            If Not IsDBNull(dt.Rows(0)("Segundo_Nombre")) Then
                lblNombres1.Text = lblNombres1.Text + " " + dt.Rows(0)("Segundo_Nombre")
            End If

            If IsDBNull(dt.Rows(0)("Primer_Apellido")) Then
                lblPrimerApellido1.Text = String.Empty
            Else
                lblPrimerApellido1.Text = dt.Rows(0)("Primer_Apellido")
            End If

            If IsDBNull(dt.Rows(0)("SEGUNDO_APELLIDO")) Then
                lblSegundoApellido1.Text = String.Empty
            Else
                lblSegundoApellido1.Text = dt.Rows(0)("SEGUNDO_APELLIDO")
            End If
            If IsDBNull(dt.Rows(0)("SEXO")) Then
                lblSexo1.Text = String.Empty
            Else
                lblSexo1.Text = dt.Rows(0)("Sexo")
            End If

            If IsDBNull(dt.Rows(0)("Fecha_Nacimiento")) Then
                lblFechaNac1.Text = String.Empty
            Else
                lblFechaNac1.Text = dt.Rows(0)("Fecha_Nacimiento")
            End If

            If IsDBNull(dt.Rows(0)("MUNICIPIO_ACTA")) Then
                lblMunicipio1.Text = String.Empty
            Else
                lblMunicipio1.Text = dt.Rows(0)("MUNICIPIO_ACTA")
            End If

            If IsDBNull(dt.Rows(0)("OFICIALIA_ACTA")) Then
                lblOficialia1.Text = String.Empty
            Else
                lblOficialia1.Text = dt.Rows(0)("OFICIALIA_ACTA")
            End If

            If IsDBNull(dt.Rows(0)("FOLIO_ACTA")) Then
                lblFolio1.Text = String.Empty
            Else
                lblFolio1.Text = dt.Rows(0)("FOLIO_ACTA")
            End If

            If IsDBNull(dt.Rows(0)("LIBRO_ACTA")) Then
                lblLibro1.Text = String.Empty
            Else
                lblLibro1.Text = dt.Rows(0)("LIBRO_ACTA")
            End If

            If IsDBNull(dt.Rows(0)("ANO_ACTA")) Then
                lblAno1.Text = String.Empty
            Else
                lblAno1.Text = dt.Rows(0)("ANO_ACTA")
            End If

            If IsDBNull(dt.Rows(0)("NUMERO_ACTA")) Then
                lblNroActa1.Text = String.Empty
            Else
                lblNroActa1.Text = dt.Rows(0)("NUMERO_ACTA")
            End If

        End If

        DetailsView1.DataSource = dt
        DetailsView1.DataBind()

        CargaEvaluacionCiudadanos(CInt(dt.Rows(0)("id_nss")))

        'Para llenar las propiedades
        idrow = dt.Rows(0)("idrow").ToString()
        If IsDBNull(dt.Rows(0)("SEGUNDO_NOMBRE")) Then
            SegundoNombre = String.Empty
        Else
            SegundoNombre = dt.Rows(0)("SEGUNDO_NOMBRE")
        End If


    End Sub

    Private Sub CargaEvaluacionCiudadanos(ByVal idNss As Integer)
        Dim dt As New DataTable
        dt = Ars.Consultas.getInfoEvaluacionActaCiudadanos(idNss)

        If dt.Rows.Count > 0 Then
            If IsDBNull(dt.Rows(0)("id_NSS")) Then
                lblNss.Text = String.Empty
            Else
                lblNss.Text = dt.Rows(0)("id_NSS")
            End If

            If IsDBNull(dt.Rows(0)("NO_DOCUMENTO")) Then
                lblCedula.Text = String.Empty
            Else
                lblCedula.Text = dt.Rows(0)("NO_DOCUMENTO")
            End If

            If IsDBNull(dt.Rows(0)("Nombres")) Then
                lblNombres.Text = String.Empty
            Else
                lblNombres.Text = dt.Rows(0)("Nombres")
            End If

            If IsDBNull(dt.Rows(0)("Primer_Apellido")) Then
                lblPrimerApellido.Text = String.Empty
            Else
                lblPrimerApellido.Text = dt.Rows(0)("Primer_Apellido")
            End If

            If IsDBNull(dt.Rows(0)("SEGUNDO_APELLIDO")) Then
                lblSegundoApellido.Text = String.Empty
            Else
                lblSegundoApellido.Text = dt.Rows(0)("SEGUNDO_APELLIDO")
            End If
            If IsDBNull(dt.Rows(0)("SEXO")) Then
                lblSexo.Text = String.Empty
            Else
                lblSexo.Text = dt.Rows(0)("Sexo")
            End If
            If IsDBNull(dt.Rows(0)("Fecha_Nacimiento")) Then
                lblFechaNacimiento.Text = String.Empty
            Else
                lblFechaNacimiento.Text = dt.Rows(0)("Fecha_Nacimiento")
            End If
            If IsDBNull(dt.Rows(0)("MUNICIPIO_ACTA")) Then
                lblMunicipio.Text = String.Empty
            Else
                lblMunicipio.Text = dt.Rows(0)("MUNICIPIO_ACTA")
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
            DetailsView2.DataSource = dt
            DetailsView2.DataBind()
        End If

    End Sub


    Protected Sub btnActualiza_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnActualiza.Click


        Dim result As String
        If ddlMotivo.SelectedValue <> "0" Then
            Me.lbl_error.Visible = True
            Me.lbl_error.Text = "Al aceptar una actualizacion de datos no puede existir un motivo de rechazo seleccionado"
            Exit Sub
        End If

        Try
            result = SuirPlus.Ars.Consultas.ActualizarEvalnActaCiudadanos(idrow, UsrUserName)
            'Dim ressultado As String
            'ressultado = SuirPlus.Ars.Consultas.RechazarEvaluacionActa(idrow, ddlMotivo.SelectedValue)
            'Response.Redirect("Listadoevaluacion.aspx?CasoEvaluacion=" & _casoEvaluacion)
            Response.Redirect(CallMe)

        Catch ex As Exception
            lblMsg.Visible = True
            lblMsg.Text = ex.Message

        End Try



    End Sub

    Protected Sub btnRechazar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRechazar.Click

        If ddlMotivo.SelectedValue = "0" Then
            Me.lbl_error.Visible = True
            Me.lbl_error.Text = " Debe seleccionar el Motivo de Rechazo"
            Exit Sub
        End If

        Try
            Dim ressultado As String
            ressultado = SuirPlus.Ars.Consultas.RechazarEvaluacionActa(idrow, "RE", ddlMotivo.SelectedValue, UsrUserName)
            'Response.Redirect("Listadoevaluacion.aspx?CasoEvaluacion=" & _casoEvaluacion)
            Response.Redirect(CallMe)
        Catch ex As Exception
            Me.lbl_error.Text = ex.Message
        End Try

    End Sub

    Private Sub CargarMotivoRechazo()

        Dim dt As New DataTable
        dt = Ars.Consultas.GetMotivoRechazoActa()

        If dt.Rows.Count > 0 Then
            ddlMotivo.DataSource = dt
            ddlMotivo.DataTextField = "error_des"
            ddlMotivo.DataValueField = "id_error"
            ddlMotivo.DataBind()
        End If
        ddlMotivo.Items.Insert(0, New ListItem("<-- Seleccione -->", "0"))
        ddlMotivo.SelectedValue = 0

    End Sub

    Protected Sub bntSalir_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles bntSalir.Click
        Response.Redirect(CallMe)
    End Sub
End Class
