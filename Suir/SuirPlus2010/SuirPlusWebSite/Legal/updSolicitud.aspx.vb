Imports SuirPlus
Partial Class Legal_updSolicitud
    Inherits BasePage
    Private Property idRegPatronal() As Integer

        Get
            Return ViewState("IdRegPatronal")
        End Get
        Set(ByVal value As Integer)
            ViewState("IdRegPatronal") = value
        End Set
    End Property
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        Try
            Me.hlImage.Visible = False

            If Me.txtRNC.Text = String.Empty And Me.txtSolicitud.Text = String.Empty Then
                Exit Sub
            End If

            Dim RegPat As Nullable(Of Integer) = Nothing
            Dim IDSol As Nullable(Of Integer) = Nothing

            If Not Me.txtRNC.Text = String.Empty Then
                RegPat = Empresas.Empleador.getEmpleadorDatos(Me.txtRNC.Text).Rows(0)("ID_Registro_Patronal")
            End If

            If Not Me.txtSolicitud.Text = String.Empty Then
                IDSol = CInt(Me.txtSolicitud.Text)
            End If

            Dim Sol As System.Data.DataTable = Legal.LeyFacilidadesPago.getSolicitudFacilidadesPago(IDSol, RegPat, Nothing, Nothing, Nothing, "A")

            If Sol.Rows.Count = 0 Then
                If Me.txtRNC.Text <> String.Empty And Me.txtSolicitud.Text = String.Empty Then
                    Me.lblMensaje.Text = "Este empleador no ha solicitado acogerse a la ley de facilidades de pago."
                ElseIf Me.txtRNC.Text = String.Empty And Me.txtSolicitud.Text <> String.Empty Then
                    Me.lblMensaje.Text = "La solicitud digitada no existe."
                Else
                    Me.lblMensaje.Text = "No se encontró información con los datos suministrados."
                End If

                Me.tblInfoEmpleador.Visible = False
                Me.tblInfoSolicitud.Visible = False
                Me.tblEscaneo.Visible = False
                Return
            End If

            Me.lblNroSol.Text = String.Format("{0:000000000}", Sol.Rows(0)("id_solicitud"))
            Me.lblFechaSol.Text = String.Format("{0:d}", Sol.Rows(0)("fecha_solicitud"))
            Me.lblNombre.Text = Sol.Rows(0)("nombre_solicitante").ToString
            Me.lblRazonSocial.Text = Sol.Rows(0)("Razon_Social").ToString
            Me.lblNombreComercial.Text = Sol.Rows(0)("Nombre_Comercial").ToString
            Me.lblRnc2.Text = Sol.Rows(0)("rnc_o_cedula")

            If Sol.Rows(0)("Telefono_1").ToString IsNot Nothing Then
                Me.lblTelefono.Text = Utilitarios.Utils.FormatearTelefono(Sol.Rows(0)("Telefono_1").ToString)
            Else
                Me.lblTelefono.Text = String.Empty
            End If

            Me.txtRNC.ReadOnly = True
            Me.txtSolicitud.ReadOnly = True
            Me.btnBuscar.Enabled = False
            Me.tblInfoEmpleador.Visible = True
            Me.tblInfoSolicitud.Visible = True
            Me.tblEscaneo.Visible = True
            Me.idRegPatronal = Sol.Rows(0)("ID_Registro_Patronal")
            'Me.updBuscar.Update()

            'Para mostrar la imagen previamente escaneada
            Try
                Dim Img As Byte() = Legal.LeyFacilidadesPago.getImagenesLeyFacilidadesPago(Me.lblNroSol.Text, Me.idRegPatronal)
                If Img.LongLength > 0 Then
                    Me.lblMensaje.Text = "Este empleador YA tiene un archivo de imagen anexado."
                    Me.hlImage.CssClass = "label-Resaltado"
                    Me.hlImage.Text = " Pulse aquí para ver la imagen"
                    Me.hlImage.NavigateUrl = "viewDocumento.aspx?id=" & CType(Me.lblNroSol.Text, Int32)
                    Me.hlImage.Visible = True

                End If
            Catch ex As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

        Catch ex As Exception

            Me.lblMensaje.Text = "Este empleador no se encuentra registrado en nuestra base de datos."
            Me.lblMensaje.Visible = True
            Me.txtRNC.ReadOnly = False
            Me.txtSolicitud.ReadOnly = False
            Me.tblInfoEmpleador.Visible = False
            Me.tblInfoSolicitud.Visible = False
            Me.tblEscaneo.Visible = False
            Me.idRegPatronal = Nothing
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub
    Protected Sub btnSubir_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubir.Click

        Try
            If FileUpload.PostedFile.FileName <> String.Empty Then
                Dim imgStream As System.IO.Stream = FileUpload.PostedFile.InputStream
                Dim imgLength As Integer = FileUpload.PostedFile.ContentLength
                Dim imgContentType As String = FileUpload.PostedFile.ContentType
                Dim imgFileName As String = FileUpload.PostedFile.FileName

                'validamos los tipos de archivos que deseamos aceptar
                If imgContentType = "image/jpeg" Or _
                   imgContentType = "image/pjpeg" Or _
                   imgContentType = "image/gif" Or _
                   imgContentType = "application/octet-stream" Or _
                   imgContentType = "image/tif" Or _
                   imgContentType = "image/tiff" Or _
                   imgContentType = "image/bmp" Then

                    Dim imgContent(imgLength) As System.Byte
                    imgStream.Read(imgContent, 0, imgLength)

                    'Para restringir el tamaño de la imagen a subir a no mas de 500KB
                    If (imgLength / 1024) > 500 Then
                        Me.lblMensaje.Text = "El tamaño del archivo de imagen no debe superar los 500 KB, por favor contacte a mesa de ayuda."

                    Else
                        'actualizamos el registro de la solicitud
                        Legal.LeyFacilidadesPago.updSolicitudLeyFacilidadesPago(CType(Me.lblNroSol.Text, Integer), imgContent, Me.UsrUserName, String.Empty)

                        'Insertamos el registro del CRM
                        Empresas.CRM.insertaRegistroCRM(Me.idRegPatronal, "Solicitud de Acuerdo de Pago", 8, 0, Me.lblNombre.Text, _
                                                                 "Subida del Archivo de Imagen <" & Mid(imgFileName, imgFileName.LastIndexOf("\") + 2) & "> como Documento Soporte para Acogerse a la Ley Facilidades de Pago.", _
                                                                 Me.UsrUserName, Nothing, Nothing, Nothing)

                        Me.divHeader.Visible = False
                        Me.tblRnc.Visible = False
                        Me.tblInfoEmpleador.Visible = False
                        Me.tblInfoSolicitud.Visible = False
                        Me.tblEscaneo.Visible = False



                        Me.Timer1.Enabled = True
                        Me.lblMensaje.CssClass = "label-Resaltado"
                        Me.lblMensaje.Text = "Archivo de Imagen Procesado Satisfactoriamente."


                    End If
                Else
                    Me.lblMensaje.Text = "Formato de Imagen Desconocido, Trate Nuevamente."
                End If
            End If
        Catch ex As Exception
            Me.lblMensaje.Text = "Error tratando de actualizar la solicitud." & "<br>" & ex.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click, btncancelar.Click
        Me.txtRNC.Text = String.Empty
        Me.txtSolicitud.Text = String.Empty
        Me.txtRNC.ReadOnly = False
        Me.txtSolicitud.ReadOnly = False
        Me.btnBuscar.Enabled = True
        Me.txtRNC.Focus()
        Me.tblInfoEmpleador.Visible = False
        Me.tblInfoSolicitud.Visible = False
        Me.tblEscaneo.Visible = False
        Me.hlImage.Visible = False

        'Me.updBuscar.Update()
    End Sub

    Protected Sub displayMessage(ByVal sender As Object, ByVal e As System.EventArgs)
        Me.Timer1.Enabled = False
        Me.Response.Redirect("updSolicitud.aspx")
    End Sub
End Class
