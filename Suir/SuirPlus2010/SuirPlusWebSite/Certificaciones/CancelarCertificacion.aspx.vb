
Imports SuirPlus.Utilitarios
Imports SuirPlus

Partial Class Certificaciones_CancelarCertificacion
    Inherits BasePage

    Protected Certificacion As Empresas.Certificaciones

    Protected Sub Certificaciones_CancelarCertificacion_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            'este es el codigo para desarrollo y prueba 247
            If Not Me.IsInPermiso("253") Then
                divInfo.Visible = False
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "Usted no tiene los permisos necesarios para ver esta pagina."
                Exit Sub
            Else
                divInfo.Visible = True
            End If

        End If
    End Sub

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Try
            If txtNroCertificacion.Text <> String.Empty Then
                Session("idCert") = txtNroCertificacion.Text
                cargarCertificacion(CInt(txtNroCertificacion.Text))

            Else
                lblMsg.Visible = True
                lblMsg.Text = "Debe introducir un número de certificación"
                Exit Sub
            End If
        Catch ex As Exception
            lblMsg.Visible = True
            lblMsg.Text = ex.Message
        End Try



    End Sub

    Protected Sub cargarCertificacion(ByVal idCert As Integer)

        Dim dtInfo As New Data.DataTable
        Try

            Certificacion = New Empresas.Certificaciones(idCert)

            If Certificacion.Numero > 0 Then
                Me.lblMsg.Text = String.Empty
                divInfoCertificacion.Visible = True
                Me.lblTipoCert.Text = Certificacion.DescripcionTipo
                Me.lblTipoCertCiu.Text = Certificacion.DescripcionTipo
                If Certificacion.Cedula.Length = 11 Then
                    Me.lblTipoDocCiu.Text = "Cédula"
                    Me.lblNroDocCiu.Text = Utils.FormatearCedula(Certificacion.Cedula)
                Else
                    Me.lblNroDocCiu.Text = Certificacion.Cedula
                End If
                Me.lblNombreCiu.Text = Certificacion.Nombre
                Me.lblNssCiu.Text = Certificacion.NSS
                Me.lblRNC.Text = Utils.FormatearRNCCedula(Certificacion.RNC)
                Me.lblRazonSocial.Text = Certificacion.RazonSocial

                Me.lblFechaReg.Text = String.Format("{0:d}", Certificacion.FechaCreacion)
                Me.lblFechaRegCertCiu.Text = String.Format("{0:d}", Certificacion.FechaCreacion)

                'Solo para ciudadanos
                If (Certificacion.DescripcionTipo.ToUpper = "APORTE PERSONAL") Or _
                    (Certificacion.DescripcionTipo.ToUpper = "CIUDADANO SIN APORTES") Or _
                    (Certificacion.DescripcionTipo.ToUpper = "DISCAPACIDAD") Or _
                    (Certificacion.DescripcionTipo.ToUpper = "INGRESOS TARDIOS") Or _
                    (Certificacion.DescripcionTipo.ToUpper = "REGISTRO PERSONA FISICA SIN NOMINA") Then

                    Me.pnlInfoCiudadano.Visible = True
                    Me.pnlInfoEmpresa.Visible = False
                    'ciudadanos y empresas
                ElseIf (Certificacion.DescripcionTipo.ToUpper = "APORTE EMPLEADO POR EMPLEADOR") Or _
                    (Certificacion.DescripcionTipo.ToUpper = "REPORTE DE NO PAGO A EMPLEADOR") Then
                    Me.pnlInfoEmpresa.Visible = True
                    Me.pnlInfoCiudadano.Visible = True
                Else
                    'Solo empresas
                    Me.pnlInfoEmpresa.Visible = True
                    Me.pnlInfoCiudadano.Visible = False
                End If

            Else
                divInfoCertificacion.Visible = False
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existen registros"
            End If



        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub bntLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles bntLimpiar.Click
        Response.Redirect("CancelarCertificacion.aspx")
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click

        Try
            If txtComentario.Text <> String.Empty Then

                Dim res = Empresas.Certificaciones.CambiarStatusCert(CInt(Session("idCert")), 5, Me.UsrUserName, txtComentario.Text)
                If res <> 0 Then
                    divInfoCertificacion.Visible = False
                    Me.lblMsg.Visible = True
                    Me.lblMsg.Text = res
                    Throw New Exception(res)

                Else
                    divInfoCertificacion.Visible = False
                    Me.lblMsg.Visible = True
                    Me.lblMsg.Text = "La Certificación #" & CInt(Session("idCert")) & " ha sido cancelada."
                End If
                Session.Remove("idCert")
            Else

                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "El comentario es requerido."
            End If

        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try
    End Sub


End Class
