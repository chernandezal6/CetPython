Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.Facturacion
Imports SuirPlus.Utilitarios

Partial Class StatusFacturaAuditoria
    Inherits BasePage

    Private Property NroReferencia As String
        Get
            If ViewState("NroReferencia") Is Nothing Then
                Return String.Empty
            Else
                Return ViewState("NroReferencia")
            End If
        End Get
        Set(ByVal value As String)
            ViewState("NroReferencia") = value
        End Set
    End Property

    Public Property RegistroPatronal() As Integer
        Get
            Return ViewState("RegistroPatronal")
        End Get
        Set(ByVal value As Integer)
            ViewState("RegistroPatronal") = value
        End Set
    End Property


    Private Sub cargarValores()

        If Me.txtReferencia.Text <> "" Then

            If Utilitarios.Utils.isNroReferenciaValido(Me.txtReferencia.Text, Empresas.Facturacion.Factura.eConcepto.SDSS) Then
                Me.NroReferencia = Me.txtReferencia.Text
            Else
                Me.lblMensaje.Text = "Nro. de Referencia Inválido"
                Exit Sub
            End If
        End If

        If Not Me.txtReferencia.Text = String.Empty Then
            Me.mostrarNotificacion()
        End If

    End Sub


    Private Sub mostrarNotificacion()

        'Buscamos la Referencia en TSS
        Try
            Dim sTemp As Empresas.Facturacion.FacturaSS

            sTemp = New Empresas.Facturacion.FacturaSS(Me.NroReferencia)
            If sTemp.NroReferencia <> String.Empty Then

                If sTemp.IDTipoFacura <> "U" Then
                    Me.lblMensaje.Text = "El Tipo de Factura no es de Auditoria"
                    Exit Sub
                End If

                If sTemp.Estatus = "Pagada" Then
                    Me.lblMensaje.Text = "La Factura no puede ser estar Pagada"
                    Exit Sub
                End If

                If sTemp.Estatus = "Revocada" Then
                    Me.lblMensaje.Text = "La Factura no puede ser estar Revocada"
                    Exit Sub
                End If


                If sTemp.Estatus = "Recalculada" Then
                    Me.lblMensaje.Text = "La Factura no puede ser estar Recalculada"
                    Exit Sub
                End If

                If sTemp.NroAutorizacion > 0 Then
                    Me.lblMensaje.Text = "La Factura no puede ser estar Autorizada"
                    Exit Sub
                End If

                If sTemp.StatusGeneracion = "D" Then
                    Me.lblMensaje.Text = "Esta Factura ya fue actualizada"
                    Exit Sub
                End If



                Me.RegistroPatronal = sTemp.RegistroPatronal

                Me.mostrarNotTSS()
                Exit Sub
            End If
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

        Me.lblMensaje.Text = "Nro. de Referencia Inválido"

    End Sub


    Private Sub mostrarNotTSS()

        Me.ucNotTSS.Visible = True
        Me.btnMarcarEstatus.Visible = True

        If Me.NroReferencia <> "" Then
            Me.ucNotTSS.NroReferencia = Me.NroReferencia
        End If

        Dim str As String = Me.ucNotTSS.MostrarEncabezado()
        Me.ucNotTSS.isBotonesVisibles = False

    End Sub


    Private Sub btBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btBuscar.Click

        txtReferencia.Enabled = False
        Me.cargarValores()

    End Sub

    Protected Sub btLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btLimpiar.Click

        Response.Redirect("StatusFacturaAuditoria.aspx")

    End Sub

    Protected Sub btnMarcarEstatus_Click(sender As Object, e As System.EventArgs) Handles btnMarcarEstatus.Click

        Try
            Dim str As String = SuirPlus.Empresas.Facturacion.FacturaSS.MarcarRefAuditoriaDefinitiva(NroReferencia, Me.UsrUserName)


            If str = "0" Then
                str = Empresas.CRM.insertaRegistroCRM(Me.RegistroPatronal, "Proceso de auditoria", 3, 0, String.Empty, "Marca Referencia Auditoria #" + NroReferencia + " Definitiva", Me.UsrUserName, Nothing, String.Empty, String.Empty)

                If Split(str, "|")(0) = "0" Then
                    Me.lblMensaje.CssClass = "LabelDataGreen"
                    Me.lblMensaje.Text = "Registro Actualizado Correctamente"
                Else
                    Me.lblMensaje.Text = Split(str, "|")(1)
                End If

            Else
                Me.lblMensaje.Text = str
            End If
        Catch ex As Exception
            Me.lblMensaje.Text = "Ha ocurrido un error actualizando la notificacion"
        End Try

    End Sub
End Class
