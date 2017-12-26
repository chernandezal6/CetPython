Imports System.Data
Imports SuirPlus.Ars
Imports SuirPlus
Imports System.Collections.Generic
Imports SuirPlus.Exepciones


Partial Class Mantenimientos_mEvaluarFallecido
    Inherits BasePage
    Dim CallMe As String
    Dim Novedad As Integer

    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load
        CallMe = HttpContext.Current.Session("EvaluacionOrigen")
        If (CallMe = "Evaluacionvisual.aspx") Then
        Else
            CallMe = "mEvaluarFallecido.aspx"
        End If



        lbl_error.Visible = False
        If Not Page.IsPostBack Then
            Me.BindEvaluacionFallecido()
            Me.CargarMotivoRechazo()
        End If

    End Sub

    Private Sub BindEvaluacionFallecido()
        Dim dt As New DataTable
        dt = Ars.Consultas.getInfoEvaluacionActaFallecido()

        If dt.Rows.Count > 0 Then
            If IsDBNull(dt.Rows(0)("id_NSS")) Then
                lblNss.Text = String.Empty
            Else
                lblNss.Text = formateaNSS(dt.Rows(0)("id_NSS"))
            End If

            If IsDBNull(dt.Rows(0)("NO_DOCUMENTO")) Then
                lblCedula.Text = String.Empty
            Else
                lblCedula.Text = Me.formateaCedula(dt.Rows(0)("NO_DOCUMENTO"))
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

            If IsDBNull(dt.Rows(0)("Sexo")) Then
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

            If IsDBNull(dt.Rows(0)("FECHA_DEFUNCION")) Then
                LblFechaDefuncion.Text = String.Empty
            Else
                LblFechaDefuncion.Text = dt.Rows(0)("FECHA_DEFUNCION")
            End If

            If IsDBNull(dt.Rows(0)("id_det_novedad_fallecido")) Then
                LblNovedad.Text = String.Empty
            Else
                LblNovedad.Text = dt.Rows(0)("id_det_novedad_fallecido")
            End If


            DetailsView1.DataSource = dt
            DetailsView1.DataBind()

        Else
            divDatosCiudadano.Visible = False
            divImagenActa.Visible = False
            lbl_error.Visible = True
            lbl_error.Text = "No existen registros para este proceso"
        End If

    End Sub

    Private Sub CargarMotivoRechazo()

        Dim dt As New DataTable
        dt = Ars.Consultas.GetMotivosRechazoFallecimiento()

        If dt.Rows.Count > 0 Then
            ddlMotivo.DataSource = dt
            ddlMotivo.DataTextField = "descripcion"
            ddlMotivo.DataValueField = "id_motivo"
            ddlMotivo.DataBind()
        End If
        ddlMotivo.Items.Insert(0, New ListItem("<-- Seleccione -->", "0"))
        ddlMotivo.SelectedValue = 0

    End Sub

    Protected Sub btnRechazar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRechazar.Click
        Lblmsj.Text = String.Empty

        If ddlMotivo.SelectedIndex = "0" Then
            Me.Lblmsj.Visible = True
            Me.Lblmsj.Text = " Debe seleccionar el Motivo de Rechazo"
            Exit Sub

           
        End If

        Try
            Dim ressultado As String
            ressultado = SuirPlus.Ars.Consultas.RechazarEvaluacionFallecido(Convert.ToInt32(LblNovedad.Text), ddlMotivo.SelectedValue, Me.UsrUserName)
            Me.BindEvaluacionFallecido()
            lbl_error.Visible = True

            lbl_error.Text = "Registro Rechazado satisfactoriamente"
            Response.Redirect(CallMe)

        Catch ex As Exception
            Me.lbl_error.Visible = True
            Me.lbl_error.Text = ex.Message
        End Try

    End Sub

    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        Lblmsj.Text = String.Empty

        If ddlMotivo.SelectedIndex = 0 Then
            Try

                Dim result As String
                result = SuirPlus.Ars.Consultas.ActualizarFallecimientoCiudadanos(Convert.ToInt32(LblNovedad.Text), Me.UsrUserName)

                If result = "0" Then
                    Me.BindEvaluacionFallecido()
                    lbl_error.Visible = True
                    lbl_error.Text = "Registro Aceptado satisfactoriamente"
                    Response.Redirect(CallMe)

                End If

            Catch ex As Exception
                lbl_error.Visible = True
                lbl_error.Text = ex.Message

            End Try
        Else
            Lblmsj.Visible = True
            Lblmsj.Text = "No puede aceptar este fallecido con este motivo"
        End If



    End Sub
    
    Protected Function formateaCedula(ByVal Cedula As String) As String

        If Cedula = String.Empty Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormatearCedula(Cedula)
        End If

    End Function

    Protected Function formateaNSS(ByVal NSS As String) As String
        If NSS = "" Then
            NSS = String.Empty
        Else
            NSS = NSS.PadLeft(9, "0"c)

            If NSS.Length.Equals(9) Then
                NSS = NSS.Substring(0, 8) + "-" + NSS.Substring(8, 1)

            End If
        End If
        Return NSS
    End Function

    Protected Sub btnDescargar_Click(sender As Object, e As System.EventArgs) Handles btnDescargar.Click
        Response.Redirect("MostrarEvaluacionFallecido.aspx")
    End Sub

End Class
