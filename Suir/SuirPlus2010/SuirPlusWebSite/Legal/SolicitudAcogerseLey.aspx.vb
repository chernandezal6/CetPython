Imports SuirPlus
Partial Class Legal_SolicitudAcogerseLey
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

            Dim emp As New Empresas.Empleador(Me.txtRNC.Text)

            If Legal.LeyFacilidadesPago.getSolicitudFacilidadesPago(Nothing, emp.RegistroPatronal, Nothing, Nothing, Nothing, "A").Rows.Count > 0 Then
                Me.lblMensaje.Text = "Este empleador ha solicitado anteriormente acogerse a la ley de facilidades de pago."
                Me.lbltxtInfoAcuerdoPago.Visible = False
                Me.tblInfoSolicitud.Visible = False
                Return
            End If

            Me.lblTelefono.Text = Utilitarios.Utils.FormatearTelefono(emp.Telefono1)
            Me.lblRazonSocial.Text = emp.RazonSocial
            Me.lblNombreComercial.Text = emp.NombreComercial
            Me.txtRNC.ReadOnly = True
            Me.btnBuscar.Enabled = False
            Me.btnLimpiar.Enabled = False
            Me.lbltxtInfoAcuerdoPago.Visible = True
            Me.tblInfoSolicitud.Visible = True
            Me.idRegPatronal = emp.RegistroPatronal

            Dim dtDeuda As System.Data.DataTable = Legal.LeyFacilidadesPago.getDeudaEmpleador(Me.idRegPatronal)
            Me.gvDeuda.DataSource = dtDeuda
            Me.gvDeuda.DataBind()

        Catch ex As Exception

            Me.lblMensaje.Text = "Este empleador no se encuentra registrado en nuestras base de datos. <br />" & ex.Message.ToString()
            Me.lblMensaje.Visible = True
            Me.txtRNC.ReadOnly = False
            Me.lbltxtInfoAcuerdoPago.Visible = False
            Me.tblInfoSolicitud.Visible = False
            Me.idRegPatronal = 0
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub
    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click, btnCancelar.Click
        Me.txtRNC.Text = String.Empty
        Me.txtRNC.ReadOnly = False
        Me.btnBuscar.Enabled = True
        Me.btnLimpiar.Enabled = True
        Me.txtRNC.Focus()
        Me.lblMensaje.Visible = False
        Me.lbltxtInfoAcuerdoPago.Visible = False
        Me.tblInfoSolicitud.Visible = False
        Me.gvDeuda.DataSource = Nothing
        Me.gvDeuda.DataBind()
    End Sub
    Protected Sub btnGrabar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGrabar.Click

        Try
            If Me.UCCiudadano.getDocumento = String.Empty Then
                Me.lblMensaje.Text = "Debes digitar el documento del solicitante"
                Return
            End If

            Me.btnGrabar.Enabled = False
            Me.updMain.Update()

            'Insertamos la solicitud
            Dim resultado As String = Legal.LeyFacilidadesPago.insertarSolicitudLeyFacilidadesPago(Me.idRegPatronal, UCCiudadano.getDocumento, UCCiudadano.getTipoDoc, Me.UsrUserName)

            'Insertamos el registro del CRM
            Empresas.CRM.insertaRegistroCRM(Me.idRegPatronal, "Solicitud para Acogerse a la Ley No. 189-07.", 8, 0, UCCiudadano.getNombres & " " & UCCiudadano.getNombres, _
                                                     "Solicitud para Acogerse a la Ley No. 189-07 que facilita el pago a los empleadores con deudas pendientes con el Sistema Dominicano de Seguridad Social.", _
                                                     Me.UsrUserName, Nothing, Nothing, Nothing)

            Response.Redirect("SolicitudAcogerseLeyConfirmacion.aspx?id=" & resultado & "&rnc=" & Me.txtRNC.Text)

        Catch ex As Exception
            Me.lblMensaje.Text = "Error al crear la solicitud. <br />" & ex.Message.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub
    Protected Sub UCCiudadano_BusquedaCancelada(ByVal sender As Object, ByVal e As System.EventArgs) Handles UCCiudadano.BusquedaCancelada
        Me.btnGrabar.Enabled = False
        Me.updMain.Update()
    End Sub
    Protected Sub UCCiudadano_CiudadanoEncontrado(ByVal sender As Object, ByVal e As System.EventArgs) Handles UCCiudadano.CiudadanoEncontrado
        Me.btnGrabar.Enabled = True
        Me.updMain.Update()
    End Sub
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        'Atributo agregado para desabilitar el button una vez se la haya dado click.
        Me.btnGrabar.Attributes.Add("onclick", "this.disabled=true;")

    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.btnBuscar.Enabled = False
    End Sub
End Class
