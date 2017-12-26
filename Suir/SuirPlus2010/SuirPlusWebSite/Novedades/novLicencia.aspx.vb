Imports System.Data

Partial Class Novedades_novLicencia
    Inherits BasePage


#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub


    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Private Sub iniForm()

        If Me.ddNomina.Items.Count > 0 Then Me.ddNomina.SelectedIndex = 0
        If Me.ddTipoNovedad.Items.Count > 0 Then Me.ddTipoNovedad.SelectedIndex = 0
        Me.ucEmpleado.iniForm()
        Me.ucFechaIni.dateValue = Now.Date
        Me.ucFechaFin.dateValue = Now.Date

    End Sub


    Private Sub novedadesPendientes()

        Try

            'Obteniendo novedades pendientes
            Dim tmpDataTable As DataTable
            tmpDataTable = SuirPlus.Empresas.Trabajador.getMovimientos(Me.UsrRegistroPatronal, "NV", "", "L", Me.UsrRNC & Me.UsrCedula)

            If tmpDataTable.Rows.Count > 0 Then
                Me.pnlPendiente.Visible = True
                Me.lblPendientes.Visible = True
                Me.btnAplicar.Visible = True
                Me.gvNovedades.Visible = True
            Else
                Me.pnlPendiente.Visible = False
                Me.lblPendientes.Visible = False
                Me.btnAplicar.Visible = False
                Me.gvNovedades.Visible = False
            End If

            Me.gvNovedades.DataSource = tmpDataTable
            Me.gvNovedades.DataBind()
            tmpDataTable = Nothing
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub cargarNominas()

        Dim tmpRep As SuirPlus.Empresas.Representante

        tmpRep = New SuirPlus.Empresas.Representante(Me.UsrRNC, Me.UsrCedula)

        Me.ddNomina.DataSource = tmpRep.getAccesos()
        Me.ddNomina.DataTextField = "nomina_des"
        Me.ddNomina.DataValueField = "id_nomina"
        Me.ddNomina.DataBind()
        tmpRep = Nothing

    End Sub

    Private Sub cargarNovedades()

        Me.ddTipoNovedad.DataSource = SuirPlus.Empresas.Trabajador.getNovedades("", "L")
        Me.ddTipoNovedad.DataTextField = "TIPO_NOVEDAD_DES"
        Me.ddTipoNovedad.DataValueField = "ID_TIPO_NOVEDAD"
        Me.ddTipoNovedad.DataBind()

        'Agregando item adicional de seleccion
        Me.ddTipoNovedad.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Seleccione una Novedad --", "-1"))

    End Sub

    Private Sub btnAceptar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar.Click
        If SuirPlus_Status = "REDUCIDO" Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = SuirPlusREDUCIDO
            Exit Sub
        End If

        'Validando que ingresen un ciudadano valido
        If Me.ucEmpleado.getNSS = "" Then
            Me.lblMsg.Text = "Debe seleccionar un individuo."
            Return
        End If

        Dim ret As String = SuirPlus.Empresas.Trabajador.novedadLicencia(Me.UsrRegistroPatronal, Me.ddNomina.SelectedValue, Me.ucEmpleado.getNSS, Me.ddTipoNovedad.SelectedValue, Me.ucFechaIni.dateValue, Me.ucFechaFin.dateValue, Me.UsrUserName, Me.GetIPAddress())

        If Split(ret, "|")(0) = "0" Then
            Me.lblMsg.ForeColor = Drawing.Color.Blue
            Me.lblMsg.Text = "La licencia fue ingresada satisfactoriamente."
            Me.novedadesPendientes()
            Me.iniForm()
        Else
            Me.lblMsg.ForeColor = Drawing.Color.Red
            Me.lblMsg.Text = Split(ret, "|")(1)
            Me.novedadesPendientes()
        End If

    End Sub

    Protected Overrides Sub OnPreRender(ByVal e As System.EventArgs)
        If Not IsPostBack() Then
            cargarNominas()
            novedadesPendientes()
        End If

        For Each i As System.Web.UI.WebControls.GridViewRow In Me.gvNovedades.Rows
            CType(i.FindControl("iBtnBorrar"), ImageButton).Attributes.Add("onClick", "return confirm('Esta seguro que desea eliminar esta novedad?');")
        Next

    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.iniForm()
    End Sub

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        If Not IsPostBack Then
            Me.iniForm()
        End If

        Me.lblMsg.Text = ""
        Me.lblMsg.ForeColor = Drawing.Color.Red

    End Sub

    Protected Sub gvNovedades_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvNovedades.RowCommand

        Dim Row As GridViewRow = CType(CType(e.CommandSource, Control).NamingContainer, GridViewRow)
        Dim idMov As Int32 = CType(Row.FindControl("lblIdMov"), Label).Text.ToString()
        Dim idLinia As Int32 = CType(Row.FindControl("lblIdLinia"), Label).Text.ToString()

        SuirPlus.Empresas.Trabajador.borraNovedad(idMov, idLinia)
        Me.novedadesPendientes()

    End Sub

    Private Sub btnAplicar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAplicar.Click
        Dim ret As String = SuirPlus.Empresas.Trabajador.aplicarMovimientos(Me.UsrRegistroPatronal, Me.UsrUserName)
        Me.lblMsg.ForeColor = Drawing.Color.Blue
        Me.lblMsg.Text = "Novedades aplicadas satisfactoriamente."
        Me.novedadesPendientes()
    End Sub

End Class

