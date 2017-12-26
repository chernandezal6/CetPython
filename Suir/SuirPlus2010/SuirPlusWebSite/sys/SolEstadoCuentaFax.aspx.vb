
Partial Class sys_SolEstadoCuentaFax
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Put user code to initialize the page here
    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.btBuscar.Visible = True
        Response.Redirect("SolEstadoCuentaFax.aspx")
    End Sub

    Private Sub btnEnviar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnEnviar.Click
        If Me.ctrlFax.PhoneNumber = Nothing Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "El Número fax es requerido"
            Exit Sub
        Else
            Me.lblMensaje.Visible = False
            Session("fax") = Me.ctrlFax.PhoneNumber
            Me.btBuscar.Visible = True
            Response.Redirect("Confirmacion.aspx")
        End If

    End Sub


    Private Sub btBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btBuscar.Click
        Me.btBuscar.Visible = False
        Me.pnlEnviaFax.Visible = False
        Me.ctrlFax.PhoneNumber = String.Empty

        If SuirPlus.SolicitudesEnLinea.Solicitudes.isRepresentanteEnEmpresa(Me.txtRnc.Text, Me.txtCedula.Text) Then
            Session("Rnc") = Me.txtRnc.Text
            Session("Cedula") = Me.txtCedula.Text

            Dim emp As New SuirPlus.Empresas.Empleador(Me.txtRnc.Text)
            Me.pnlEnviaFax.Visible = True

            Me.lblRazonSocial.Text = emp.RazonSocial
            Me.lblNombreComercial.Text = emp.NombreComercial
            Me.ctrlFax.PhoneNumber = emp.Fax
            Dim rep As New SuirPlus.Empresas.Representante(Me.txtRnc.Text, Me.txtCedula.Text)

            Me.lblRepresentante.Text = rep.NombreCompleto

            Me.lblMensaje.Visible = False
        Else
            Me.btBuscar.Visible = True
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "Esta cédula no es un representante para el empleador digitado."
        End If
    End Sub
End Class
