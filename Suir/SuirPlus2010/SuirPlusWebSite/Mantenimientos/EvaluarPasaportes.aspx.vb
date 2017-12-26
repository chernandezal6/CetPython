Imports System.Data
Imports SuirPlus.Ars
Imports SuirPlus
Imports System.Collections.Generic
Imports SuirPlus.Exepciones


Partial Class Mantenimientos_EvaluarPasaportes
    Inherits BasePage

    Dim Novedad As Integer
    Dim _idsolicitud As String
    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load

        If Not IsNothing(Request.QueryString("id_solicitud")) Then
            _idsolicitud = Request.QueryString("id_solicitud")
        End If

        lbl_error.Visible = False
        If Not Page.IsPostBack Then
            Me.BindEvaluacionPasaporte()
            Me.CargarMotivoRechazo()

        End If

    End Sub

    Private Sub BindEvaluacionPasaporte()
        Dim dt As New DataTable
        Dim dtImagenes As New DataTable


        dt = SuirPlus.Mantenimientos.Mantenimientos.getInfoEvaluacionPasaportes(_idsolicitud)

        If dt.Rows.Count > 0 Then
            If IsDBNull(dt.Rows(0)("ID_SOLICITUD")) Then
                lblSolicitud.Text = String.Empty
            Else
                lblSolicitud.Text = dt.Rows(0)("ID_SOLICITUD")
            End If
            If IsDBNull(dt.Rows(0)("PASAPORTE")) Then
                lblPasaporte.Text = String.Empty
            Else
                lblPasaporte.Text = dt.Rows(0)("PASAPORTE")
            End If

            If IsDBNull(dt.Rows(0)("NOMBRES")) Then
                lblNombres.Text = String.Empty
            Else
                lblNombres.Text = dt.Rows(0)("NOMBRES")
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

            If IsDBNull(dt.Rows(0)("Sexo_des")) Then
                lblSexo.Text = String.Empty
            Else
                lblSexo.Text = dt.Rows(0)("Sexo_des")
            End If

            If IsDBNull(dt.Rows(0)("Fecha_Nacimiento")) Then
                lblFechaNacimiento.Text = String.Empty
            Else
                lblFechaNacimiento.Text = dt.Rows(0)("Fecha_Nacimiento")
            End If

            If IsDBNull(dt.Rows(0)("NACIONALIDAD_DES")) Then
                lblNacionalidad.Text = String.Empty
            Else
                lblNacionalidad.Text = dt.Rows(0)("NACIONALIDAD_DES")
            End If

            If IsDBNull(dt.Rows(0)("email")) Then
                lblEmail.Text = String.Empty
            Else
                lblEmail.Text = dt.Rows(0)("email")
            End If

            If IsDBNull(dt.Rows(0)("numero_contacto")) Then
                lblNumeroContacto.Text = String.Empty
            Else
                lblNumeroContacto.Text = dt.Rows(0)("numero_contacto")
            End If

            If IsDBNull(dt.Rows(0)("FECHA_REGISTRO")) Then
                lblFechaRegistro.Text = String.Empty
            Else
                lblFechaRegistro.Text = String.Format("{0:d}", dt.Rows(0)("FECHA_REGISTRO"))

            End If

            'lblContador.Text = dt.Rows.Count
            dtImagenes = SuirPlus.Mantenimientos.Mantenimientos.getImagenesPasaportes(lblSolicitud.Text)

            If dtImagenes.Rows.Count > 0 Then
                Dim Numero As Integer = 0
                For Numero = 0 To dtImagenes.Rows.Count - 1

                    Dim Req = dtImagenes.Rows(Numero).Item("ID_REQUISITO").ToString()
                    Dim Sol = dtImagenes.Rows(Numero).Item("ID_SOLICITUD").ToString()

                    Dim Imagenes = New Image
                    'Agregamos los UL
                    Dim literalUl = New Literal()
                    literalUl.Text = "<li><a href='#ctl00_MainContent_tabs-" + Numero.ToString() + "' req='" + Req + "' sol='" + Sol + "'>Adjunto #" + (Numero + 1).ToString() + "</a></li>"
                    ulTabs.Controls.Add(literalUl)

                    'Agregamos el DIV
                    Dim dvImage = New HtmlGenericControl("div")
                    dvImage.ID = "tabs-" + Numero.ToString() + ""

                    tabs.Controls.Add(dvImage)

                    'Agregamos la Imagen
                    Imagenes.ImageUrl = "/Mantenimientos/MostrarEvaluacionPasaporte.aspx?id_solicitud=" + lblSolicitud.Text + "&id_requisito=" + Req
                    Imagenes.Height = "350"
                    Imagenes.Width = "567"
                    dvImage.Controls.Add(Imagenes)

                Next
            Else
                Dim Imagenes = New Image

                'Agregamos el DIV
                Dim dvImage = New HtmlGenericControl("div")
                dvImage.ID = "ImagenNoGenerada"

                tabs.Controls.Add(dvImage)

                Imagenes.ImageUrl = "~/images/Sin_imagen.jpg"
                Imagenes.Height = "350"
                Imagenes.Width = "567"
                dvImage.Controls.Add(Imagenes)
                btnDescargar.Enabled = False
                btnDescargar.CssClass = "ui-state-disabled"
            End If



        Else
            divDatosPasaportes.Visible = False
            divImagenActa.Visible = False
            lbl_error.Visible = True
            lbl_error.Text = "No existen registros para este proceso"
        End If

    End Sub

    Private Sub CargarMotivoRechazo()

        Dim dt As New DataTable
        dt = SuirPlus.Mantenimientos.Mantenimientos.getMotivosPasaportes()

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
            Dim result As String
            result = SuirPlus.Mantenimientos.Mantenimientos.RechazarPasaporte(lblPasaporte.Text, ddlMotivo.SelectedValue)
            If result = "OK" Then
                lbl_error.Visible = True
                lbl_error.Text = "Registro Rechazado satisfactoriamente"
                lbl_error.CssClass = "error"
                Limpiar()
                Response.Redirect("EvaluacionVisual.aspx")
            Else
                lbl_error.Visible = True
                lbl_error.Text = SuirPlus.Mantenimientos.Mantenimientos.RechazarPasaporte(lblPasaporte.Text, ddlMotivo.SelectedValue).ToString()
            End If

        Catch ex As Exception
            Me.lbl_error.Text = ex.Message
            lbl_error.CssClass = "error"
        End Try

    End Sub

    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        Lblmsj.Text = String.Empty
        Try
            Dim result As String
            result = SuirPlus.Mantenimientos.Mantenimientos.AprobarPasaporte(lblPasaporte.Text, ddlMotivo.SelectedValue, UsrUserName)
            If result = "OK" Then
                lbl_error.Visible = True
                lbl_error.Text = "Registro Aceptado satisfactoriamente"
                lbl_error.CssClass = "subHeader"
                Limpiar()
                Response.Redirect("EvaluacionVisual.aspx")
            Else
                lbl_error.Visible = True
                lbl_error.Text = SuirPlus.Mantenimientos.Mantenimientos.AprobarPasaporte(lblPasaporte.Text, ddlMotivo.SelectedValue, UsrUserName).ToString()
            End If

        Catch ex As Exception
            lbl_error.Visible = True
            lbl_error.Text = ex.Message
            lbl_error.CssClass = "error"

        End Try


    End Sub

    Protected Sub btnDescargar_Click(sender As Object, e As System.EventArgs) Handles btnDescargar.Click
        Session("Req") = HDRequisito.Value
        Session("Sol") = HDSolicitud.Value
        If HDRequisito.Value = Nothing Then

        Else
            Response.Redirect("MostrarEvaluacionPasaporte.aspx")
        End If
    End Sub
    Sub Limpiar()
        Me.CargarMotivoRechazo()
        lblSolicitud.Text = ""
        lblFechaNacimiento.Text = ""
        lblFechaRegistro.Text = ""
        lblNacionalidad.Text = ""
        lblNombres.Text = ""
        lblPasaporte.Text = ""
        lblPrimerApellido.Text = ""
        lblSegundoApellido.Text = ""
        lblSexo.Text = ""
        lblEmail.Text = ""
        lblNumeroContacto.Text = ""
    End Sub

End Class
