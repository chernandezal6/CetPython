Imports SuirPlus.FrameWork
Imports SuirPlus.Empresas.SubsidiosSFS.Maternidad
Imports SuirPlus.Utilitarios.TSS
Imports SuirPlus.Utilitarios.Utils
Partial Class Novedades_sfsConfirmacionMaternidad
    Inherits BasePage
    Dim DatosMaternidad As String
    Dim Usuario As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim maternidad As ConfirmarMaternidad = CType(Session("Maternidad"), ConfirmarMaternidad)

            ucInfoEmpleado1.NombreEmpleado = maternidad.NombreMadre
            ucInfoEmpleado1.NSS = maternidad.NSSMadre
            ucInfoEmpleado1.Cedula = maternidad.CedulaMadre.Replace("-", "")
            ucInfoEmpleado1.FechaNacimiento = maternidad.FechaNacimientoMadre
            ucInfoEmpleado1.Sexo = maternidad.SexoMare
            ucInfoEmpleado1.SexoEmpleado = maternidad.SexoEmpleadoMadre
            lblApellidoTutor.Text = ProperCase(maternidad.ApellidoTutor)
            lblCelular.Text = maternidad.Celular
            lblEmail.Text = maternidad.Email

            If maternidad.EmprezaReporteEmbarazo Is Nothing Then
                lblEmprezaReporteEmbarazo.Text = ProperCase(maternidad.EmpresaReportoLicencia)
            Else
                lblEmprezaReporteEmbarazo.Text = ProperCase(maternidad.EmprezaReporteEmbarazo)
            End If

            lblFechaDiagnostico.Text = maternidad.FechaDiagnostico
            lblFechaEstimadaParto.Text = maternidad.FechaEstimadaParto
            lblFechaLicencia.Text = maternidad.FechaLicencia
            lblIdEntidadRecaudadora.Text = ProperCase(maternidad.DisplayEntidadRecaudadora)
            ViewState("IdEntidadRecaudadora") = maternidad.EntidadRecaudadora
            lblNoDocumentoTutor.Text = maternidad.NoDocumentoTutor
            lblNombreTutor.Text = ProperCase(maternidad.NombreTutor)
            lblNroCuenta.Text = maternidad.NoCuenta

            If maternidad.EmprezaReporteEmbarazo Is Nothing Then
                lblRNC.Text = maternidad.RNCLicencia
            Else
                lblRNC.Text = maternidad.RNC
            End If

            lblEmpresaLicencia.Text = ProperCase(maternidad.EmpresaReportoLicencia)
            lblRNCLicencia.Text = maternidad.RNCLicencia
            lblTelefono.Text = maternidad.Telefono
            ViewState("TipoCuenta") = maternidad.TipoCuenta
            lblTipoCuenta.Text = maternidad.DisplayTipoCuenta
            ViewState("Titular") = maternidad.Destinatario
            lblTitular.Text = maternidad.DisplayDestinatario
            DatosMaternidad = maternidad.DatosMaternidad
            Usuario = maternidad.Usuario

        Catch ex As Exception
            lblMsg.Text = ex.Message
        End Try

    End Sub
    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRegistrar.Click

        Try
            Dim numeroSolicitud As String = String.Empty
            Dim resultado As String = ReporteMaternidadExtraordinaria(DatosMaternidad, ucInfoEmpleado1.Cedula.Replace("-", ""), getRegistroPatronal(lblRNCLicencia.Text), lblFechaDiagnostico.Text, _
                                            lblFechaEstimadaParto.Text, lblNoDocumentoTutor.Text, lblTelefono.Text, lblCelular.Text, _
                                            lblEmail.Text, Usuario, lblFechaLicencia.Text, ViewState("Titular").ToString(), ViewState("TipoCuenta").ToString(), _
                                            lblNroCuenta.Text, CInt(ViewState("IdEntidadRecaudadora")), numeroSolicitud)

            If resultado.Equals("OK") Then
                Response.Redirect("NovedadesAplicadas.aspx?msg=Su solicitud fue procesada, el numero es: " & numeroSolicitud)
            Else
                lblMsg.Text = resultado
            End If

        Catch ex As Exception
            lblMsg.Text = ex.Message
        End Try

    End Sub

    Protected Sub btnCancelarGeneral_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelarGeneral.Click

        Response.Redirect("~/Novedades/sfsMaternidadExtraordinario.aspx?confirmacion=1")

    End Sub
End Class
