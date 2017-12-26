Imports SuirPlus.Utilitarios
Imports SuirPlus
Partial Class Certificaciones_AutorizarCertificacion
    Inherits BasePage
    Dim idCert As Integer
    Dim tipoCert As String = String.Empty
    Protected Certificacion As Empresas.Certificaciones


    Protected Sub Certificaciones_AutorizarCertificacion_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Me.Request("Id") = String.Empty Then
            idCert = CInt(Request("Id"))
            tipoCert = Request("tipo")
            Me.lblIdCertificacion.Text = idCert
            Me.lblTipoCert.Text = tipoCert
            Me.lblTipoCertCiu.Text = tipoCert

            cargarCertificacion()
        Else

        End If

    End Sub

    Protected Sub cargarCertificacion()

        Dim dtInfo As New Data.DataTable
        Try

            Certificacion = New Empresas.Certificaciones(idCert)

            If Certificacion.Numero > 0 Then
                'Me.lblTipoCert.Text = Certificacion.Tipo
                'Me.lblTipoCertCiu.Text = Certificacion.Tipo
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
            Else
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existen registros"
            End If
            'Solo para ciudadanos
            If (Certificacion.DescripcionTipo.ToUpper = "APORTE PERSONAL") Or _
                (Certificacion.DescripcionTipo.ToUpper = "CIUDADANO SIN APORTES") Or _
                (Certificacion.DescripcionTipo.ToUpper = "DISCAPACIDAD") Or _
                (Certificacion.DescripcionTipo.ToUpper = "INGRESOS TARDIOS") Or _
                (Certificacion.DescripcionTipo.ToUpper = "REGISTRO PERSONA FISICA SIN NOMINA")  Then

                Me.pnlInfoCiudadano.Visible = True
                Me.pnlInfoEmpresa.Visible = False
                'ciudadanos y empresas
            ElseIf (Certificacion.DescripcionTipo.ToUpper = "APORTE EMPLEADO POR EMPLEADOR") Or _
                (Certificacion.DescripcionTipo.ToUpper = "REPORTE DE NO PAGO A EMPLEADOR") Or _
                (Certificacion.DescripcionTipo.ToUpper = "CIUDADANO SIN APORTE POR EMPLEADOR") Then
                Me.pnlInfoEmpresa.Visible = True
                Me.pnlInfoCiudadano.Visible = True
            Else
                'Solo empresas
                Me.pnlInfoEmpresa.Visible = True
                Me.pnlInfoCiudadano.Visible = False
            End If


        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub btnRegresar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRegresar.Click
        Response.Redirect("verCertificacionAutorizar.aspx")
    End Sub


    Protected Sub btnAutorizar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAutorizar.Click
        Try
            Dim coment = Me.txtComentario.Text
            If coment = String.Empty Then
                coment = "Certificación Verificada"
            End If

            CambiarStatus(CInt(Me.lblIdCertificacion.Text), 3, coment)
            Response.Redirect("verCertificacionAutorizar.aspx")
        Catch ex As Exception
            Throw New Exception(ex.Message)
            Me.lblMsg.Text = ex.Message
        End Try

    End Sub

    Protected Sub btnRechazar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRechazar.Click
        Try
            CambiarStatus(CInt(Me.lblIdCertificacion.Text), 2, Me.txtComentario.Text)
            Response.Redirect("verCertificacionAutorizar.aspx")
        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try
    End Sub

    Protected Sub CambiarStatus(ByVal idCert As Integer, ByVal idStatus As Integer, ByVal Comentario As String)
        Try
            Dim res = Empresas.Certificaciones.CambiarStatusCert(idCert, idStatus, Me.UsrUserName, Comentario)
            If res <> 0 Then
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = res
                Throw New Exception(res)
            End If

        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try

    End Sub

    Protected Sub lnkVerDocRequeridos_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkVerDocRequeridos.Click
        Response.Redirect("verImagenCertificacion.aspx?idCertificacion=" & Me.lblIdCertificacion.Text)
    End Sub
    Protected Sub lnkVerCertificacion_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkVerCertificacion.Click

        Response.Redirect("/sys/ImpCertificacion.aspx?B=GtIFyg&A=" & Convert.ToBase64String(Encoding.ASCII.GetBytes(Me.lblIdCertificacion.Text.ToCharArray())))
        'Response.Redirect("verCertificacion.aspx?codCert=" & Me.lblIdCertificacion.Text)
    End Sub
End Class
