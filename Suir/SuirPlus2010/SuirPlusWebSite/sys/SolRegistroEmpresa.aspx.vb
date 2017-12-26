Imports SuirPlus
Imports SuirPlus.SolicitudesEnLinea
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios
Partial Class sys_SolRegistroEmpresa
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Put user code to initialize the page here
        Me.txtRnc.ReadOnly = False
        Me.txtCedula.ReadOnly = False
    End Sub

    Private Sub btnProcesar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnProcesar.Click
        Me.btnConsultar.Visible = True

        If Me.ctrlTelefono1.PhoneNumber = Nothing Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "El Número del primer teléfono es requerido"
            Exit Sub
        Else
            Me.lblMensaje.Visible = False

        End If

        Me.pnlPrincipal.Visible = False
        Me.pnlRegistroEmp.Visible = False
        Me.pnlconfirmacion.Visible = True
        Me.lblRncRegistro.Text = Utils.FormatearRNCCedula(Me.txtRnc.Text)
        Me.lblRazonSocialRegistro.Text = Me.txtRazonSocial.Text
        Me.lblNombreComercialRegistro.Text = Me.txtNombreComercial.Text
        Me.lblRepresentanteRegistro.Text = Me.lblRepresentante.Text
        Me.lblTelefono1Registro.Text = Me.ctrlTelefono1.PhoneNumber
        Me.lblTelefono2Registro.Text = Me.ctrlTelefono2.PhoneNumber
    End Sub
    Private Sub btnAceptarRegistro_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptarRegistro.Click
        Me.RegistrarEmpresa()
    End Sub
    Private Sub RegistrarEmpresa()

        Dim NumeroSolicitud As String
        Dim valor1 As String
        Dim valor2 As String

        Try
            NumeroSolicitud = SuirPlus.SolicitudesEnLinea.Solicitudes.crearRegistroEmpresa(Me.txtRnc.Text, Me.txtRazonSocial.Text, Me.txtNombreComercial.Text, Me.txtCedula.Text, Me.ctrlTelefono1.PhoneNumber.Replace("-", ""), Me.ctrlTelefono2.PhoneNumber.Replace("-", ""), "", "")

            Dim Res As String()
            Res = NumeroSolicitud.Split("|")
            valor1 = Res(0)
            valor2 = Res(1)

            If valor1 = "0" Then
                'Response.Redirect("SolicitudCreada.aspx?tipo=2&id=" & valor2)
                'Verificamos si ya el script esta registrado, de lo contrario lo agregamos.
                Dim popupScript As String = "<script language=""javascript"">"
                popupScript += "window.open('SolicitudCreada.aspx?tipo=2&id=" & valor2 & "', 'Argumento1', " + "'height: 400px; width: 500px; top: 200px; center: yes;')"
                popupScript += "</script>"
                Me.ClientScript.RegisterStartupScript(Me.GetType(), "PopupScript", popupScript)

                Me.pnlconfirmacion.Visible = False
                Me.pnlPrincipal.Visible = True
                Me.txtCedula.Text = String.Empty
                Me.txtRnc.Text = String.Empty


            Else
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = valor2
            End If


        Catch ex As Exception
            Response.Redirect("error.aspx?errMsg=" & ex.Message)
        End Try
    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.btnConsultar.Visible = True

        Me.lblMensaje.Visible = False
        Response.Redirect("SolRegistroEmpresa.aspx")
    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click

        ' Verificar que no este registrado ya este RNC
        If Empresas.Empleador.isRegistrado(Me.txtRnc.Text) Then

            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "Ya este RNC está registrado en la TSS."

            Exit Sub

        End If

        Me.btnConsultar.Visible = False

        Me.pnlRegistroEmp.Visible = True

        Dim NombreRep As String

        'Buscamos ciudadano e la base de datos
        NombreRep = Utilitarios.TSS.getNombreCiudadano("C", Me.txtCedula.Text)

        'verificamos que no traiga el error 104
        If NombreRep.Split("|")(0) <> "104" Then
            Me.pnlRegistroEmp.Visible = True
            Me.lblRepresentante.Text = NombreRep
            Me.lblMensaje.Visible = False
            Me.txtRnc.ReadOnly = True
            Me.txtCedula.ReadOnly = True
        Else
            Me.txtRnc.ReadOnly = False
            Me.txtCedula.ReadOnly = False
            Me.btnConsultar.Visible = True
            Me.pnlRegistroEmp.Visible = False
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "Cédula inválida"
            Exit Sub

        End If

        Dim razonsocial As String

        'Buscamos la razon social en DGII del RNC
        razonsocial = Empresas.Empleador.getRazonSocialEnDGII(Me.txtRnc.Text)

        'Verificamos que no traiga el error 179
        If razonsocial.Split("|")(0) <> "179" Then
            Me.txtRazonSocial.Text = razonsocial
        Else
            Me.pnlRegistroEmp.Visible = True
            Me.lblMensaje.Visible = False
            Me.txtRazonSocial.Text = String.Empty
        End If

    End Sub
End Class
