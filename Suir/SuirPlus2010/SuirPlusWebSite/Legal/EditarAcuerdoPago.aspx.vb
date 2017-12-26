Imports System.Data
Imports SuirPlus

Partial Class Legal_EditarAcuerdoPago
    Inherits BasePage

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        BindControls()
    End Sub

    Private Sub BindControls()
        Dim AcuerdoPago As Legal.AcuerdosDePago
        Try
            Dim TipoAcuerdo As Legal.eTiposAcuerdos
            Dim IDAcuerdo As Integer
            Dim vec() As String

            'Validamos el tipo de acuerdo
            If Not String.IsNullOrEmpty(Me.txtAcuerdo.Text) Then
                vec = Legal.AcuerdosDePago.ValidateTipoAcuerdo(txtAcuerdo.Text).Split("|")
                IDAcuerdo = vec(0)
                TipoAcuerdo = CInt(vec(1))
            End If

            AcuerdoPago = New Legal.AcuerdosDePago(IDAcuerdo, TipoAcuerdo)
            'Si el status es generado procedemos a cargar los controles de lo contrario mostramos un mensaje de error
            If AcuerdoPago.Status = "Generado" Then
                Me.tblInfoAcuerdo.Visible = True

                lblRazonSocial.Text = AcuerdoPago.RazonSocial
                lblTelefono.Text = Utilitarios.Utils.FormatearTelefono(AcuerdoPago.Telefono1)

                txtCargo.Text = AcuerdoPago.Cargo
                txtDireccion.Text = AcuerdoPago.Direccion
                txtEstadoCivil.Text = AcuerdoPago.EstadoCivil
                txtNacionalidad.Text = AcuerdoPago.Nacionalidad

                CType(ucCiudadano.FindControl("txtRepDocumento"), TextBox).Text = AcuerdoPago.NoDocumento
                ucCiudadano.consultaPersona(CType(ucCiudadano.FindControl("ddRepTipoDoc"), DropDownList).SelectedValue, CType(ucCiudadano.FindControl("txtRepDocumento"), TextBox).Text)
            Else
                Me.lblMensajeError.Text = "No Puede Editar Este Acuerdo De Pago Por Que No Ha Sido Generado"
                Me.tblInfoAcuerdo.Visible = False
            End If
        Catch ex As Exception
            Me.lblMensajeError.Text = "No Existe Acuedo De Pago Para Este Numero"
            Me.tblInfoAcuerdo.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGuardar.Click
        GuardarDatos()
    End Sub

    Private Sub GuardarDatos()
        Dim AcuerdoPago As Legal.AcuerdosDePago
        Dim Resultado As String = String.Empty
        Dim TipoAcuerdo As SuirPlus.Legal.eTiposAcuerdos
        Dim IDAcuerdo As Integer
        Dim vec() As String

        'Validamos el tipo de acuerdo
        If Not String.IsNullOrEmpty(Me.txtAcuerdo.Text) Then
            vec = Legal.AcuerdosDePago.ValidateTipoAcuerdo(txtAcuerdo.Text).Split("|")
            IDAcuerdo = vec(0)
            TipoAcuerdo = CInt(vec(1))
        End If
        AcuerdoPago = New Legal.AcuerdosDePago(IDAcuerdo, TipoAcuerdo)
        AcuerdoPago.Cargo = txtCargo.Text
        AcuerdoPago.Direccion = txtDireccion.Text
        AcuerdoPago.EstadoCivil = txtEstadoCivil.Text
        AcuerdoPago.Nacionalidad = txtNacionalidad.Text
        AcuerdoPago.Nombres = ucCiudadano.getNombres & " " & ucCiudadano.getApellidos
        AcuerdoPago.NoDocumento = ucCiudadano.getDocumento
        AcuerdoPago.TipoDocumento = ucCiudadano.getTipoDoc


        Resultado = AcuerdoPago.EditarAcuerdoPago(Me.UsrUserName)
        If Resultado = "0" Then
            Me.lblMensajeError.Text = "Acuerdo de Pago Actualizado!!"
            Me.tblInfoAcuerdo.Visible = False
        Else
            Me.lblMensajeError.Text = Resultado
            Me.tblInfoAcuerdo.Visible = True
        End If
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.tblInfoAcuerdo.Visible = False
        Me.txtAcuerdo.Text = String.Empty
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Response.Redirect("EditarAcuerdoPago.aspx")
    End Sub
End Class
