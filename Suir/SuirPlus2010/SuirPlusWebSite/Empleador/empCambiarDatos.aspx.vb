Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios
Imports SuirPlus.Operaciones
Imports SuirPlus.Empresas

Partial Class Empleador_empCambiarDatos
    Inherits BasePage

    Protected Property RegPat As Integer
        Get
            Return Convert.ToInt32(Me.ViewState("RegPat").ToString())
        End Get
        Set(ByVal value As Integer)
            Me.ViewState("RegPat") = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            Try
                'Cargando DropDown de Sectores Economicos
                Me.ddlSectorEconomico_save.DataSource = SuirPlus.Utilitarios.TSS.getSectoresEconomicos()
                Me.ddlSectorEconomico_save.DataValueField = "ID_SECTOR_ECONOMICO"
                Me.ddlSectorEconomico_save.DataTextField = "SECTOR_ECONOMICO_DES"

                'cargando sectores salariales
                ddlSectorSalarial_save.DataSource = Mantenimientos.SectoresSalariales.getSectoresSalariales()
                ddlSectorSalarial_save.DataTextField = "descripcion"
                ddlSectorSalarial_save.DataValueField = "id"

                Me.DataBind()
            Catch ex As Exception
                Me.lblFormError.Text = ex.Message
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If

    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        If String.IsNullOrEmpty(Me.txtRNC.Text) Then

            Me.lblMensaje.Text = "Debe especificar algún criterio."
            Exit Sub

        End If

        bindData()
        Me.lbl_mensaje.Visible = False

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click

        Me.txtRNC.Text = String.Empty
        Me.fs_datos.Visible = False
        Me.btnBuscar.Enabled = True
        Me.lbl_mensaje.Visible = False
        Me.txtRNC.Focus()

    End Sub

    Protected Sub bindData()

        Dim tmpDT As DataTable = Nothing
        Dim regPatronal As Integer = Nothing

        tmpDT = Empresas.Empleador.getEmpleador(regPatronal, txtRNC.Text)

        If tmpDT.Rows.Count > 0 Then

            If String.IsNullOrEmpty(tmpDT.Rows(0)("cod_sector").ToString()) Then
                Me.RegPat = 0
                Me.fs_datos.Visible = False
                Me.lblMensaje.Text = "Este empleador no tiene Sector Salarial asignado, debe utilizar la pantalla de Asignación de Sector Salarial."
                Me.btnBuscar.Enabled = True

                Exit Sub
            End If

            Me.RegPat = CInt(tmpDT.Rows(0)("id_registro_patronal").ToString())
            Me.txt_nombre_comercial_save.Text = tmpDT.Rows(0)("nombre_comercial").ToString()
            Me.txt_razon_social_save.Text = tmpDT.Rows(0)("razon_social").ToString()
            Me.txt_capital_contable_save.Text = tmpDT.Rows(0)("capital").ToString()
            'Me.ddlEstatusCobro_save.SelectedValue = tmpDT.Rows(0)("status_cobro").ToString()
            Me.ddlSectorEconomico_save.SelectedValue = tmpDT.Rows(0)("id_sector_economico").ToString()
            Me.ddlSectorSalarial_save.SelectedValue = tmpDT.Rows(0)("cod_sector").ToString()
            Me.ddlTipoEmpresa_save.SelectedValue = tmpDT.Rows(0)("tipo_empresa").ToString()

            Me.fs_datos.Visible = True
            Me.lblMensaje.Text = String.Empty
            Me.btnBuscar.Enabled = False

        Else

            Me.RegPat = 0
            Me.fs_datos.Visible = False
            Me.lblMensaje.Text = "No se encontró el empleador"
            Me.btnBuscar.Enabled = True

        End If

    End Sub

    Protected Sub btn_cancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btn_cancelar.Click

        Me.Response.Redirect("empCambiarDatos.aspx")

    End Sub

    Protected Sub btn_salvar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btn_salvar.Click

        Dim result As String
        result = SuirPlus.Empresas.Empleador.ActualizarEmpresa(Me.RegPat, Me.txt_razon_social_save.Text, txt_nombre_comercial_save.Text, CInt(ddlSectorSalarial_save.SelectedValue), CInt(ddlSectorEconomico_save.SelectedValue), Convert.ToDecimal(Me.txt_capital_contable_save.Text), ddlTipoEmpresa_save.SelectedValue)

        If result <> "0" Then
            Me.lblFormError.Text = result
        Else
            Me.btnLimpiar_Click(sender, e)
            Me.lbl_mensaje.Visible = True
        End If

    End Sub
End Class