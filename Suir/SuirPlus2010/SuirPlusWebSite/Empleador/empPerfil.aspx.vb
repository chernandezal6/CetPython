
Partial Class Empleador_empPerfil
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not IsPostBack Then

            Me.cargaDropDowns()

            'Setear controles de telefono
            Me.ucTelefono1.Separador = ""
            Me.ucTelefono2.Separador = ""
            Me.ucFax.Separador = ""

            'Abilitando el dropdown solo si tiene el permiso 99
            'If Me.UsuarioActual.IsInPermiso("99") Then
            '    Me.ddlTipoEmpresa.Enabled = True
            'Else
            '    Me.ddlTipoEmpresa.Enabled = False
            'End If

        End If

        'Limpiando mensajes de error
        Me.lblFormMSG.Text = ""

    End Sub

    'Cargar drop downs de la pagina
    Private Sub cargaDropDowns()

        'Cargando DropDown de Sectores Economicos
        Me.ddlSectorEconomico.DataSource = SuirPlus.Utilitarios.TSS.getSectoresEconomicos()
        Me.ddlSectorEconomico.DataValueField = "ID_SECTOR_ECONOMICO"
        Me.ddlSectorEconomico.DataTextField = "SECTOR_ECONOMICO_DES"

        'Cargando DropDown de Provincias
        Me.ddProvincia.DataSource = SuirPlus.Utilitarios.TSS.getProvincias()
        Me.ddProvincia.DataValueField = "ID_PROVINCIA"
        Me.ddProvincia.DataTextField = "PROVINCIA_DES"

        Me.DataBind()

        Me.ddProvincia.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
        Me.ddProvincia.SelectedIndex = 0

        Me.ddlSectorEconomico.Items.Add(New ListItem("<-- Seleccione -->", "-1"))
        Me.ddlSectorEconomico.SelectedIndex = Me.ddlSectorEconomico.Items.Count - 1

    End Sub

    'Setea los controles de la pagina con las informaciones generales del empleador
    Private Sub cargarForm()


        Dim tmpEmpleador As New SuirPlus.Empresas.Empleador(Me.UsrRNC)
        
        'Cargando controles

        'Labels
        Me.lblRncCedula.Text = SuirPlus.Utilitarios.Utils.FormatearRNCCedula(Me.UsrRNC)
        Me.lblRNL.Text = Me.UsrRegistroPatronal
        Me.lblRazonSocial.Text = tmpEmpleador.RazonSocial
        Me.lblRiesgo.Text = tmpEmpleador.IDRiesgo.ToString() & " Factor de riesgo (" & tmpEmpleador.FactorRiesgo & "%)"

        'TextBox's
        Me.txtNombreComercial.Text = tmpEmpleador.NombreComercial
        Me.txtCalle.Text = tmpEmpleador.Calle
        Me.txtNumero.Text = tmpEmpleador.Numero
        Me.txtEdificio.Text = tmpEmpleador.Edificio
        Me.txtPiso.Text = tmpEmpleador.Piso
        Me.txtApartamento.Text = tmpEmpleador.Apartamento
        Me.txtSector.Text = tmpEmpleador.Sector
        Me.txtExt1.Text = tmpEmpleador.Ext1
        Me.txtExt2.Text = tmpEmpleador.Ext2
        Me.txtEmail.Text = tmpEmpleador.Email

        'Telefonos
        Me.ucTelefono1.PhoneNumber = tmpEmpleador.Telefono1
        Me.ucTelefono2.PhoneNumber = tmpEmpleador.Telefono2
        Me.ucFax.PhoneNumber = tmpEmpleador.Fax

        'DropDowns
        Me.ddlTipoEmpresa.SelectedValue = tmpEmpleador.TipoEmpresa
        Me.ddProvincia.SelectedValue = SuirPlus.Utilitarios.TSS.getProvinciaId(tmpEmpleador.IDMunicipio)
        Me.ddlSectorEconomico.SelectedValue = tmpEmpleador.IDSectorEconomico

        'Cargando DD de municipios
        Me.ddProvincia_SelectedIndexChanged(Me, Nothing)
        Me.ddMunicipio.SelectedValue = tmpEmpleador.IDMunicipio

    End Sub

    Private Sub btnActualizar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnActualizar.Click

        Dim tmpEmpleador As New SuirPlus.Empresas.Empleador(Me.UsrRNC)

        With tmpEmpleador

            .NombreComercial = Me.txtNombreComercial.Text
            .TipoEmpresa = Me.ddlTipoEmpresa.SelectedValue
            .IDSectorEconomico = Me.ddlSectorEconomico.SelectedValue
            .Calle = Me.txtCalle.Text
            .Numero = Me.txtNumero.Text
            .Edificio = Me.txtEdificio.Text
            .Piso = Me.txtPiso.Text
            .Apartamento = Me.txtApartamento.Text
            .Sector = Me.txtSector.Text
            .IDMunicipio = Me.ddMunicipio.SelectedValue
            .Telefono1 = Me.ucTelefono1.PhoneNumber
            .Ext1 = Me.txtExt1.Text
            .Telefono2 = Me.ucTelefono2.PhoneNumber
            .Ext2 = Me.txtExt2.Text
            .Fax = Me.ucFax.PhoneNumber
            .Email = Me.txtEmail.Text

        End With

        Dim ret As String
        Try

            'TODO Obtener el usuario logeado.
            ret = tmpEmpleador.GuardarCambios(Me.UsrUserName)

            If ret = "0" Then
                Me.setMsg("N", "La información fue almacenada satisfactoriamente.")
            Else
                Me.setMsg("E", "La información no pudo ser almacenada.")
            End If

        Catch ex As Exception
            Me.setMsg("E", ex.Message)
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try


    End Sub

    'Coloca un mensaje, si es de error (E) lo pone en rojo si es normal (N) en azul.
    Private Sub setMsg(ByVal tipo As String, ByVal msg As String)

        If tipo = "N" Then
            Me.lblFormMSG.ForeColor = Drawing.Color.Blue
        Else
            Me.lblFormMSG.ForeColor = Drawing.Color.Red
        End If

        Me.lblFormMSG.Text = msg

    End Sub

    Private Sub btnDesCambios_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDesCambios.Click
        Me.cargarForm()
    End Sub

    Protected Overrides Sub OnPreRender(ByVal e As System.EventArgs)

        If Not IsPostBack Then

            'Cargando Formulario con las informaciones del empleador
            Me.cargarForm()

        End If

    End Sub

    Private Sub ddProvincia_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ddProvincia.SelectedIndexChanged
        If Me.ddProvincia.SelectedValue <> "-1" Then

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
