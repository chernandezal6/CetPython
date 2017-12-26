Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios

Partial Class Empleador_empRegistrodgii
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            cargaDropDowns()
        End If

    End Sub

    'Cargar drop downs de la pagina
    Private Sub cargaDropDowns()

        'Cargando DropDown de Provincias
        Me.ddProvincia.DataSource = SuirPlus.Utilitarios.TSS.getProvincias()
        Me.ddProvincia.DataValueField = "ID_PROVINCIA"
        Me.ddProvincia.DataTextField = "PROVINCIA_DES"

        Me.DataBind()

        Me.ddProvincia.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
        Me.ddProvincia.SelectedIndex = 0

        Me.ddMunicipio.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
        Me.ddMunicipio.SelectedIndex = 0

    End Sub

    Private Sub limpiaForm()

        Me.txtRncCedula.Text = ""
        Me.txtRazonSocial.Text = ""
        Me.txtNombreComercial.Text = ""
        Me.txtCalle.Text = ""
        Me.txtNumero.Text = ""
        Me.txtEdificio.Text = ""
        Me.txtPiso.Text = ""
        Me.txtApartamento.Text = ""
        Me.txtSector.Text = String.Empty
        Me.ddProvincia.SelectedIndex = 0
        Me.Telefono.phoneNumber = ""
        Me.txtEmail.Text = ""
        Me.txtFechaConstitucion.Text = String.Empty
        Me.txtFechaAct.Text = String.Empty
        Me.ddlTipoEmpresa.SelectedIndex = 0
        Me.ddMunicipio.Items.Clear()
        Me.ddMunicipio.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
        Me.ddMunicipio.SelectedIndex = 0

        Me.lblRNCCedula.Text = String.Empty
        Me.lblRS.Text = String.Empty
        Me.lblNC.Text = String.Empty
        Me.lblCalle.Text = String.Empty
        Me.lblNumero.Text = String.Empty
        Me.lblEdificio.Text = String.Empty
        Me.lblPiso.Text = String.Empty
        Me.lblApartamento.Text = String.Empty
        Me.lblSector.Text = String.Empty
        Me.lblProvincia.Text = String.Empty
        Me.lblMunicipio.Text = String.Empty
        Me.lblTelefono.Text = String.Empty
        Me.lblEmail.Text = String.Empty
        Me.lblFechaCont.Text = String.Empty
        Me.lblFechaAct.Text = String.Empty
        Me.lblTipoEmp.Text = String.Empty

        Me.pnlConfirmacion.Visible = False
        Me.pnlRegistro.Visible = True

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click

        Me.limpiaForm()

    End Sub

    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        Me.lblRNCCedula.Text = Utils.FormatearRNCCedula(Me.txtRncCedula.Text)
        Me.lblRS.Text = Me.txtRazonSocial.Text
        Me.lblNC.Text = Me.txtNombreComercial.Text
        Me.lblTipoEmp.Text = Me.ddlTipoEmpresa.SelectedItem.Text
        Me.lblTelefono.Text = Utils.FormatearTelefono(Me.Telefono.phoneNumber)
        Me.lblEmail.Text = Me.txtEmail.Text.ToLower()
        Me.lblFechaCont.Text = Me.txtFechaConstitucion.Text
        Me.lblFechaAct.Text = Me.txtFechaAct.Text
        Me.lblCalle.Text = Me.txtCalle.Text
        Me.lblNumero.Text = Me.txtNumero.Text
        Me.lblEdificio.Text = Me.txtEdificio.Text
        Me.lblPiso.Text = Me.txtPiso.Text
        Me.lblApartamento.Text = Me.txtApartamento.Text
        Me.lblSector.Text = Me.txtSector.Text
        Me.lblProvincia.Text = Me.ddProvincia.SelectedItem.Text
        Me.lblMunicipio.Text = Me.ddMunicipio.SelectedItem.Text
        Me.pnlRegistro.Visible = False
        Me.pnlConfirmacion.Visible = True
        Me.upFormulario.Update()

    End Sub

    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        'Refrescamos el panel de error para que borre cualquier mensaje.
        Me.upError.Update()
        If Me.Telefono.phoneNumber = String.Empty Then
            showError("Debe introducir el telefono del empleador.")
            Exit Sub
        End If

        'Si es de 9 digitos que no inicie con cero 0
        If Me.txtRncCedula.Text.Length = 9 And Me.txtRncCedula.Text.Substring(0, 1) = "0" Then
            showError("El RNC no debe iniciar con cero 0.")
            Exit Sub
        End If

        If Me.txtFechaConstitucion.Text = String.Empty Then
            showError("Debe introducir la fecha de constitución")
            Exit Sub
        Else
            If Not IsDate(Me.txtFechaConstitucion.Text) Then
                showError("Debe introducir una fecha de constitución válida.")
                Exit Sub
            End If
        End If

        If Me.txtFechaAct.Text = String.Empty Then
            showError("Debe introducir la fecha de inicio de actividades.")
            Exit Sub
        Else
            If Not IsDate(Me.txtFechaAct.Text) Then
                showError("Debe introducir una fecha de actividades válida.")
                Exit Sub
            End If
        End If

        Dim ret As String = Empleador.insertaEmpleadorDGII(Me.txtRncCedula.Text, _
                                                        Me.txtRazonSocial.Text, _
                                                        Me.txtNombreComercial.Text, _
                                                        Me.txtCalle.Text, _
                                                        Me.txtNumero.Text, _
                                                        Me.txtEdificio.Text, _
                                                        Me.txtPiso.Text, _
                                                        Me.txtApartamento.Text, _
                                                        Me.ddMunicipio.SelectedValue.ToString, _
                                                        Me.Telefono.phoneNumber, _
                                                        Me.txtEmail.Text, _
                                                        Me.ddlTipoEmpresa.SelectedValue, _
                                                        CDate(Me.txtFechaConstitucion.Text), _
                                                        CDate(Me.txtFechaAct.Text))
        If ret = "0" Then

            Me.lblFormError.CssClass = "label-Blue"
            showError("El Empleador fue registrado satisfactoriamente en DGII.")
            Me.limpiaForm()

        Else
            showError(Split(ret, "|")(1).ToString())
        End If

    End Sub

    Protected Sub btnActualizar_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        Me.pnlConfirmacion.Visible = False
        Me.pnlRegistro.Visible = True

    End Sub

    Protected Sub showError(ByVal msg As String)

        Me.lblFormError.Text = msg
        Me.upError.Update()

    End Sub

    Private Sub ddProvincia_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ddProvincia.SelectedIndexChanged

        If Me.ddProvincia.SelectedValue = "-1" Then

            Me.ddMunicipio.Items.Clear()
            Me.ddMunicipio.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
            Me.ddMunicipio.SelectedIndex = 0

        Else

            'Cargando dd de municipios 
            Me.ddMunicipio.DataSource = SuirPlus.Utilitarios.TSS.getMunicipios(Me.ddProvincia.SelectedValue, "")
            Me.ddMunicipio.DataValueField = "ID_MUNICIPIO"
            Me.ddMunicipio.DataTextField = "MUNICIPIO_DES"
            Me.ddMunicipio.DataBind()

            Me.ddMunicipio.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
            Me.ddMunicipio.SelectedIndex = 0

        End If

    End Sub

End Class
