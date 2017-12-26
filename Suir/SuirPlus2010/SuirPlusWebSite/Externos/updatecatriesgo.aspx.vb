
Partial Class Externos_updatecatriesgo
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Put user code to initialize the page here


    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.txtRNC.Text = String.Empty
        Me.lblMsg.Text = String.Empty
        Me.pnlConsulta.Visible = False

    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Me.btnActualizar.Enabled = False

        Dim IdEmpleador As String = Me.txtRNC.Text

        If IdEmpleador = String.Empty Or IdEmpleador Is Nothing Then
            Me.lblMsg.Text = SuirPlus.Utilitarios.TSS.getErrorDescripcion(150)
            Me.pnlConsulta.Visible = False
        End If

        cargarDatosEmpleador(IdEmpleador)

    End Sub

    'Metodo utilizado para cargar los datos generales del empleador
    Private Sub cargarDatosEmpleador(ByVal rnc As String)

        Dim empleador As SuirPlus.Empresas.Empleador = Nothing

        Try
            empleador = New SuirPlus.Empresas.Empleador(rnc)
        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            Me.pnlConsulta.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

        If Not empleador Is Nothing Then
            Me.lblRnc.Text = empleador.RNCCedula
            Me.lblNomComercial.Text = empleador.NombreComercial
            Me.lblRazonSocial.Text = empleador.RazonSocial
            Me.lblRegPatronal.Text = empleador.RegistroPatronal
            Me.lblActEconomica.Text = empleador.ActividadEconomica
            Me.lblTipoEmpresa.Text = empleador.TipoEmpresaDescripcion
            Me.lblEstatus.Text = IIf(empleador.Estatus = "A", "Activo", "de Baja")
            Me.lblEmail.Text = empleador.Email
            Me.lblTelefono1.Text = SuirPlus.Utilitarios.Utils.FormatearTelefono(empleador.Telefono1)
            Me.lblExt1.Text = empleador.Ext1
            Me.lblTelefono2.Text = SuirPlus.Utilitarios.Utils.FormatearTelefono(empleador.Telefono2)
            Me.lblExt2.Text = SuirPlus.Utilitarios.Utils.FormatearTelefono(empleador.Ext2)
            Me.lblFax.Text = SuirPlus.Utilitarios.Utils.FormatearTelefono(empleador.Fax)
            Me.lblCalle.Text = empleador.Calle
            Me.lblNumero.Text = empleador.Numero
            Me.lblEdificio.Text = empleador.Edificio
            Me.lblPiso.Text = empleador.Piso
            Me.lblApto.Text = empleador.Apartamento
            Me.lblSector.Text = empleador.Sector
            Me.lblMunicipio.Text = empleador.Municipio
            Me.lblProvincia.Text = empleador.Provincia
            Me.lblFechaRegistro.Text = String.Format("{0:d}", empleador.FechaRegistro)
            Me.pnlConsulta.Visible = True
            BindCategoria()
            Me.drpCategoria.SelectedValue = empleador.IDRiesgo

        End If

    End Sub

    Sub BindCategoria()

        Me.drpCategoria.DataSource = SuirPlus.Mantenimientos.Parametro.getCategoriaRiesgo
        Me.drpCategoria.DataTextField = "riesgo_des"
        Me.drpCategoria.DataValueField = "id_riesgo"
        Me.drpCategoria.DataBind()

    End Sub

    Private Sub btnActualizar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnActualizar.Click

        Dim empleado As New SuirPlus.Empresas.Empleador(CInt(Me.lblRegPatronal.Text))
        Dim retorno As String
        empleado.IDRiesgo = Me.drpCategoria.SelectedValue
        retorno = empleado.GuardarCambios(Me.UsrUserName)

        If retorno = "0" Then
            Me.lblMsg.Text = "La categoria fue actualizada satisfactoriamente."
            Me.btnActualizar.Enabled = False

        Else
            Dim errMsg As String = retorno.Split("|")(1)
            Me.lblMsg.Text = "La categoria no pudo ser actualizada... " & " " & errMsg
        End If

        cargarDatosEmpleador(empleado.RNCCedula)

    End Sub

    Protected Sub drpCategoria_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpCategoria.SelectedIndexChanged
        Me.btnActualizar.Enabled = True
    End Sub
End Class

