Imports SuirPlus
Imports SuirPlusEF.Service
Imports SuirPlusEF.Repositories
Imports System.Data

Partial Class Asignacion_NSS_ActualizacionMaestroCiu
    Inherits BasePage
    Public SolicitudAsignacion As New SolicitudAsignacion()

    Private Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        Response.Redirect("ActualizacionMaestroCiu.aspx")
    End Sub

    Private Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        Try
            Me.lblError.Text = String.Empty
            Me.lblError.Visible = False
            fsCiudadano.Visible = False
            pnlInfoTSS.Visible = False
            lblMsg.Text = String.Empty
            lblMsg.Visible = False
            lblmensaje.Visible = False
            btnActualizar.Enabled = True
            pnlSolicitarNss.Visible = False

            Dim repCiudadano As New CiudadanoRepository()
            If (txtNoDocumento.Text <> "") And (ddlTipoDocumento.SelectedValue = "C" Or ddlTipoDocumento.SelectedValue = "U") Then
                validarDocumento()
                'Dim ciu = repCiudadano.GetCiudadano(txtNoDocumento.Text, ddlTipoDocumento.SelectedValue)
                Dim ciu As DataTable = Utilitarios.TSS.getCiudadanoAsigNSS(ddlTipoDocumento.SelectedValue, txtNoDocumento.Text)
                If ciu.Rows.Count > 0 Then
                    If (ciu.Rows(0)("NO_DOCUMENTO") <> String.Empty) Then
                        lblCedula.Text = Utilitarios.Utils.FormatearCedula(ciu.Rows(0)("NO_DOCUMENTO"))
                    End If
                    lblNombres.Text = ciu.Rows(0)("NOMBRES").ToString()
                    lblPrimerApellido.Text = ciu.Rows(0)("PRIMER_APELLIDO").ToString()
                    lblSegundoApellido.Text = ciu.Rows(0)("SEGUNDO_APELLIDO").ToString()
                    If (ciu.Rows(0)("FECHA_NACIMIENTO") <> Date.MinValue) Then
                        Dim fecha As String = ciu.Rows(0)("FECHA_NACIMIENTO").ToString()
                        lblFechaNacimiento.Text = CDate(fecha).ToString("dd/MM/yyyy")
                    End If
                    lblSexo.Text = ciu.Rows(0)("SEXO").ToString()
                    lblOficialia.Text = ciu.Rows(0)("OFICIALIA_ACTA").ToString()
                    lblLibro.Text = ciu.Rows(0)("LIBRO_ACTA").ToString()
                    lblTipoLibro.Text = ciu.Rows(0)("TIPO_LIBRO_ACTA").ToString()
                    lblFolio.Text = ciu.Rows(0)("FOLIO_ACTA").ToString()
                    lblNroActa.Text = ciu.Rows(0)("NUMERO_ACTA").ToString()
                    lblAno.Text = ciu.Rows(0)("ANO_ACTA").ToString()
                    lblMunicipio.Text = ciu.Rows(0)("MUNICIPIO_ACTA").ToString()
                    lblNacionalidad.Text = ciu.Rows(0)("NACIONALIDAD_DES").ToString()
                    lblEstadoCivil.Text = ciu.Rows(0)("ESTADO_CIVIL").ToString()
                    lblCausaInhabilidad.Text = ciu.Rows(0)("CANCELACION_DES").ToString()
                    lblTipoCausa.Text = ciu.Rows(0)("TIPO_CAUSA").ToString()
                    lblEstatus.Text = ciu.Rows(0)("STATUS").ToString()
                    lblMadreNombres.Text = ciu.Rows(0)("NOMBRE_MADRE").ToString()
                    lblPadreNombre.Text = ciu.Rows(0)("NOMBRE_PADRE").ToString()

                    fsCiudadano.Visible = True
                    pnlInfoTSS.Visible = True
                    pnlSolicitarNss.Visible = False
                    lblmensaje.Visible = False
                Else
                    pnlInfoTSS.Visible = False
                    pnlSolicitarNss.Visible = True
                    lblMsg.Text = "El ciudadano NO existe en TSS"
                    lblMsg.Visible = True
                    lblmensaje.Visible = False
                End If
            Else
                Me.lblError.Text = "Ambos valores son requeridos"
                Me.lblError.Visible = True
            End If

        Catch ex As Exception
            lblError.Text = ex.Message
            lblError.Visible = True
        End Try

    End Sub

    Protected Sub SolicitudAsignacionNSS()
        Try
            Dim sol = SolicitudAsignacion.Crear(txtNoDocumento.Text, ddlTipoDocumento.SelectedValue, UsrUserName, UsrRegistroPatronal)

            txtNoDocumento.Text = String.Empty
            ddlTipoDocumento.SelectedValue = "0"
            Me.lblmensaje.Text = "Solicitud generada satisfactoriamente, su número de solicitud es " + sol.ToString()
            Me.lblmensaje.Visible = True

        Catch ex As Exception
            lblError.Text = "Error actualizando el maestro de cedulados."
            lblError.Visible = True
            Exepciones.Log.LogToDB("Error actualizando el maestro de cedulados. " + ex.ToString())
        End Try

    End Sub
    Protected Sub validarDocumento()
        Try
            If String.IsNullOrEmpty(txtNoDocumento.Text) = True Then
                Throw New Exception("El número de documento es requerido")
            ElseIf txtNoDocumento.Text.Length <> 11 Then
                Throw New Exception("El número de documento es inválido")
            ElseIf Not IsNumeric(txtNoDocumento.Text) Then
                Throw New Exception("El número de documento debe ser numérico")
            End If
        Catch ex As Exception
            Throw ex
        End Try

    End Sub

    Private Sub ddlTipoDocumento_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlTipoDocumento.SelectedIndexChanged
        txtNoDocumento.Focus()
        txtNoDocumento.Text = String.Empty
        lblmensaje.Text = String.Empty
        lblError.Text = String.Empty
    End Sub

    Private Sub btnActualizar_Click(sender As Object, e As EventArgs) Handles btnActualizar.Click
        SolicitudAsignacionNSS()
        fsCiudadano.Visible = False
        pnlInfoTSS.Visible = False
    End Sub

    Private Sub btnSolicitar_Click(sender As Object, e As EventArgs) Handles btnSolicitar.Click
        SolicitudAsignacionNSS()
        fsCiudadano.Visible = False
        pnlSolicitarNss.Visible = False
    End Sub
End Class
