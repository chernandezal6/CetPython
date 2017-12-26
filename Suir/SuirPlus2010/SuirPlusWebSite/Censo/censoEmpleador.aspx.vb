Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios

Partial Class Censo_censoEmpleador
    Inherits BasePage
    Protected empresa As Empleador = Nothing

    Private Property RNC() As String
        Get
            Return ViewState("RNC")
        End Get
        Set(ByVal value As String)
            If Not String.IsNullOrEmpty(value) Then
                value = value.Replace("-", Nothing)
                ViewState("RNC") = value
            End If
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Me.IsPostBack Then
            'Si la pagina anterior es nula buscamos el RNC por la Session
            If Me.PreviousPage Is Nothing Then
                RNC = Session("CensoRNC")
                If RNC = Nothing Then
                    If Not String.IsNullOrEmpty(Request.QueryString("rnc")) Then
                        RNC = Request.QueryString("rnc")
                    End If
                End If

            Else
                Me.getRnc(Me.PreviousPage.Controls(0))
            End If

            Try
                CargarDatos()
                bindProvincia()
                bindMunProvincia()
                'BindRepresentantes()
                bindSectorEcon()
                binLlenarMotivosNoImpresion()
            Catch ex As Exception
                Me.lblMsg.Text = "Error Retornando Empleador  <br/>" & ex.Message
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

        End If

    End Sub

    Sub CargarDatos()

        empresa = New Empleador(RNC)

        'Cargamos los datos
        Me.lblRNC.Text = empresa.RNCCedula
        Me.lblRazonSocial.Text = empresa.RazonSocial

        Me.txtNombreComercial.Text = empresa.NombreComercial
        Me.lblNombreComercial.Text = empresa.NombreComercial
        Me.lblSectorEconomico.Text = empresa.SectorEconomico

        'Datos de la direccion
        Me.txtCalle.Text = empresa.Calle
        Me.lblCalle.Text = empresa.Calle
        Me.txtNumero.Text = empresa.Numero
        Me.lblNumero.Text = empresa.Numero
        Me.txtEdificio.Text = empresa.Edificio
        Me.lblEdificio.Text = empresa.Edificio
        Me.txtPiso.Text = empresa.Piso
        Me.lblPiso.Text = empresa.Piso
        Me.txtApto.Text = empresa.Apartamento
        Me.lblApartamento.Text = empresa.Apartamento
        Me.txtSector.Text = empresa.Sector
        Me.lblSector.Text = empresa.Sector
        Me.lblProvincia.Text = empresa.Provincia
        Me.lblMunicipio.Text = empresa.Municipio '& "/" & empresa.Provincia

        'Datos del telefono y el email
        Me.txtEmail.Text = empresa.Email
        Me.lblEmail.Text = empresa.Email
        Me.ucTelefono1.phoneNumber = empresa.Telefono1
        Me.lblTelefono1.Text = Utils.FormatearTelefono(empresa.Telefono1)
        Me.txtExt1.Text = Trim(empresa.Ext1)
        Me.lblExt1.Text = Trim(empresa.Ext1)

        Me.ucTelefono2.phoneNumber = empresa.Telefono2
        Me.lblTelefono2.Text = Utils.FormatearTelefono(empresa.Telefono2)
        Me.txtExt2.Text = Trim(empresa.Ext2)
        Me.lblExt2.Text = Trim(empresa.Ext2)

        Me.ucFax.phoneNumber = empresa.Fax
        Me.lblFax.Text = Utils.FormatearTelefono(empresa.Fax)

    End Sub

    Protected Sub getRnc(ByVal parent As Control)
        For Each ctrl As Control In parent.Controls
            If ctrl.ID = "lblRNC" Then
                RNC = CType(ctrl, Label).Text
                Exit For
            End If
            If ctrl.Controls.Count > 0 Then
                getRnc(ctrl)
            End If
        Next
    End Sub

    Sub bindProvincia()

        'Cargando DropDown de Provincias
        Me.ddProvincia.DataSource = SuirPlus.Utilitarios.TSS.getProvincias()
        Me.ddProvincia.DataValueField = "ID_PROVINCIA"
        Me.ddProvincia.DataTextField = "PROVINCIA_DES"
        Me.ddProvincia.DataBind()

        Me.ddProvincia.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
        Me.ddProvincia.SelectedIndex = 0

    End Sub

    Sub bindMunProvincia()

        If (empresa.IDMunicipio >= 1) Then

            Me.ddProvincia.SelectedValue = SuirPlus.Utilitarios.TSS.getProvinciaId(empresa.IDMunicipio)

            'Cargando DD de municipios
            Me.ddProvincia_SelectedIndexChanged(Me, Nothing)
            Me.ddMunicipio.SelectedValue = empresa.IDMunicipio


        End If

    End Sub

    Sub bindSectorEcon()

        Me.ddlSectorEconomico.DataSource = SuirPlus.Utilitarios.TSS.getSectoresEconomicos
        Me.ddlSectorEconomico.DataTextField = "SECTOR_ECONOMICO_DES"
        Me.ddlSectorEconomico.DataValueField = "ID_SECTOR_ECONOMICO"
        Me.ddlSectorEconomico.DataBind()

        Me.ddlSectorEconomico.Items.Add(New ListItem("-- Seleccionar --", -1))

        If (empresa.IDSectorEconomico >= 1) Then
            Me.ddlSectorEconomico.SelectedValue = empresa.IDSectorEconomico
        Else
            Me.ddlSectorEconomico.SelectedValue = -1
        End If

    End Sub

    Sub binLlenarMotivosNoImpresion()

        Try

            Me.ddlMotivoNoImpresion.DataSource = SuirPlus.Utilitarios.TSS.getMotivoNoImpresion
            Me.ddlMotivoNoImpresion.DataTextField = "MOTIVO_NO_IMPRESION_DES"
            Me.ddlMotivoNoImpresion.DataValueField = "ID_MOTIVO_NO_IMPRESION"
            Me.ddlMotivoNoImpresion.DataBind()
            Me.ddlMotivoNoImpresion.Enabled = False
        Catch ex As Exception
            Response.Write("Error cargando motivos de no impresion..")
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

        'Si el usuario que esta logueado tiene el role callcenter tss entoces habilitamos el ddlMotivoNoImpresion
        'If (Me.UsuarioActual.IsInRole("48")) Then
        '    Me.ddlMotivoNoImpresion.Enabled = True
        'End If

        If Not empresa.MotivoNoImpresion Is Nothing Then
            ddlMotivoNoImpresion.SelectedValue = empresa.MotivoNoImpresion
        End If

    End Sub

    Sub BindRepresentantes()

        Me.repRepresentante.DataSource = empresa.getRepresentantes
        Me.repRepresentante.DataBind()

    End Sub

    Private Function formateaTelefono(ByVal value As Object) As String

        If value Is DBNull.Value Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormatearTelefono(Convert.ToString(value))
        End If

    End Function

    Private Sub repRepresentante_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles repRepresentante.ItemDataBound

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then

            'No importa que tipo de item sea, le asignamos valores a los label que representan el valor actual.
            CType(e.Item.FindControl("lblRepTelefono1"), Label).Text = formateaTelefono(DataBinder.Eval(e.Item.DataItem, "TELEFONO"))

            'Evaluamos que el valor que venga de la base de datos no sea DBnull, si esto no se hace la aplicacion dispara una excepcion.
            CType(e.Item.FindControl("lblRepExt1"), Label).Text = IIf(DataBinder.Eval(e.Item.DataItem, "EXTENSION1") Is DBNull.Value, Nothing, DataBinder.Eval(e.Item.DataItem, "EXTENSION1"))
            CType(e.Item.FindControl("lblRepTelefono2"), Label).Text = formateaTelefono(DataBinder.Eval(e.Item.DataItem, "TELEFONO2"))
            CType(e.Item.FindControl("lblRepExt2"), Label).Text = IIf(DataBinder.Eval(e.Item.DataItem, "EXTENSION2") Is DBNull.Value, Nothing, DataBinder.Eval(e.Item.DataItem, "EXTENSION2"))
            CType(e.Item.FindControl("lblRepEmail"), Label).Text = IIf(DataBinder.Eval(e.Item.DataItem, "EMAIL") Is DBNull.Value, Nothing, DataBinder.Eval(e.Item.DataItem, "EMAIL"))

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

    Protected Sub btnActualizar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnActualizar.Click

        Dim emp As New Empleador(RNC)
        emp.NombreComercial = Utilitarios.Utils.LimpiarParametro(Me.txtNombreComercial.Text)
        emp.IDSectorEconomico = Me.ddlSectorEconomico.SelectedValue
        emp.IdMotivoNoImpresion = Me.ddlMotivoNoImpresion.SelectedValue
        emp.Calle = Utilitarios.Utils.LimpiarParametro(Me.txtCalle.Text)
        emp.Numero = Utilitarios.Utils.LimpiarParametro(Me.txtNumero.Text)
        emp.Edificio = Utilitarios.Utils.LimpiarParametro(Me.txtEdificio.Text)
        emp.Piso = Utilitarios.Utils.LimpiarParametro(Me.txtPiso.Text)
        emp.Apartamento = Utilitarios.Utils.LimpiarParametro(Me.txtApto.Text)
        emp.Sector = Utilitarios.Utils.LimpiarParametro(Me.txtSector.Text)
        emp.IDMunicipio = Me.ddMunicipio.SelectedValue
        emp.Email = Me.txtEmail.Text
        emp.Telefono1 = Me.ucTelefono1.phoneNumber.Replace("-", "")
        emp.Ext1 = Utilitarios.Utils.LimpiarParametro(Me.txtExt1.Text)
        emp.Telefono2 = Me.ucTelefono2.phoneNumber.Replace("-", "")
        emp.Ext2 = Utilitarios.Utils.LimpiarParametro(Me.txtExt2.Text)
        emp.Fax = Me.ucFax.phoneNumber.Replace("-", "")
        emp.isCensoCompletado = True

        For Each i As Web.UI.WebControls.RepeaterItem In Me.repRepresentante.Items

            Dim rep As New Representante(RNC, CType(i.FindControl("lblRepDocumento"), Label).Text)
            rep.Telefono1 = CType(i.FindControl("UcRepTel1"), Controles_ucTelefono2).phoneNumber
            rep.Ext1 = CType(i.FindControl("txtRepExt1"), TextBox).Text
            rep.Telefono2 = CType(i.FindControl("UcRepTel2"), Controles_ucTelefono2).phoneNumber
            rep.Ext2 = CType(i.FindControl("txtRepExt2"), TextBox).Text

            Try
                If rep.Email <> CType(i.FindControl("txtRepEmail"), TextBox).Text Then
                    Operaciones.RegistroLogAuditoria.CrearRegistro(Me.UsrRegistroPatronal, Me.UsrUserName, Me.UsrUserName, 5, Request.UserHostAddress, Request.UserHostName, "Anterior: " + rep.Email + " | Actual: " + CType(i.FindControl("txtRepEmail"), TextBox).Text, Request.ServerVariables("LOCAL_ADDR"))
                    ''Throw New Exception("cambio!")
                Else
                    ''Throw New Exception("NOcambio!")
                End If
            Catch ex As Exception
                Throw ex
            End Try

            rep.Email = CType(i.FindControl("txtRepEmail"), TextBox).Text

            Try
                rep.GuardarCambios(Me.UsrUserName)
                'rep.GuardarCambios(getUsuarioResponsable())
            Catch ex As Exception
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "Error actualizado los datos del representante. <br/> " & ex.Message
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                Exit Sub
            End Try
        Next

        Try
            emp.GuardarCambios(Me.UsrUserName)
            'emp.GuardarCambios(getUsuarioResponsable())
        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = "Error actualizando los datos del empleador. <br>" & ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub
        End Try

        If Me.UsrTipoUsuario = "Representante" Then
            Response.Redirect("../Empleador/consNotificaciones.aspx")
        Else
            Response.Redirect("../default.aspx")
        End If

    End Sub

End Class
