Imports System.Data

Partial Class Solicitudes_ManejoSolicitudes
    Inherits BasePage


    'Protected WithEvents ucSol As ucSolicitud

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents gvSolicitudes As System.Web.UI.WebControls.DataGrid
    'Protected WithEvents lblMensaje As System.Web.UI.WebControls.Label
    'Protected WithEvents btnConsultar As System.Web.UI.WebControls.Button
    'Protected WithEvents txtIDSolicitud As System.Web.UI.WebControls.TextBox
    'Protected WithEvents ddlEstatus As System.Web.UI.WebControls.DropDownList
    'Protected WithEvents ddlTipo As System.Web.UI.WebControls.DropDownList
    'Protected WithEvents pnlStatus As System.Web.UI.WebControls.Panel
    'Protected WithEvents txtComentario As System.Web.UI.WebControls.TextBox
    'Protected WithEvents ddlEst As System.Web.UI.WebControls.DropDownList
    'Protected WithEvents btAct As System.Web.UI.WebControls.Button
    'Protected WithEvents Button1 As System.Web.UI.WebControls.Button
    'Protected WithEvents ddlProvincia As System.Web.UI.WebControls.DropDownList
    'Protected WithEvents lblIntro As System.Web.UI.WebControls.Label
    'Protected WithEvents pnlBusqueda As System.Web.UI.WebControls.Panel

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Page.IsPostBack Then
            Me.CargarDropDowns()
            cargarGrid()
        End If
        'If Me.getUsuarioActual.IsInRole("235") Then
        'Me.ddlEst.Enabled = False
        ' End If

    End Sub

    Private Sub cargarGrid()
        'valores esperados por default
        Dim NroSol As Integer = 0
        Dim status As Integer = 0
        Dim tipo As Integer = 0
        Dim prov As String = "0"
        Dim idStatus As String = "0"
        Dim idtipo As Integer = 0
        Dim idprov As String = "0"
        Dim dtSol As DataTable = Nothing


        If Me.txtIDSolicitud.Text.Length > 0 Then
            NroSol = Me.txtIDSolicitud.Text
            status = 99
            tipo = 0
            prov = "0"

        Else
            If Not (Me.ddlEstatus.SelectedValue = 0) Then
                status = Me.ddlEstatus.SelectedValue
            End If

            If Not (Me.ddlTipo.SelectedValue = 0) Then
                tipo = Me.ddlTipo.SelectedValue
            End If

            If Not (Me.ddlProvincia.SelectedValue = 0) Then
                prov = Me.ddlProvincia.SelectedValue
            End If
        End If
        'Me.pnlFormulario.Visible = True


        Try
            dtSol = SuirPlus.SolicitudesEnLinea.Solicitudes.getSolicitud(NroSol, status, tipo, 99, prov, Me.ddlCantRegistros.SelectedValue)

            'obtenemos el status de la solicitud actual
            'llenamos los dropdowns con los valores correspondientes a la solicitud digitada

            If (Me.txtIDSolicitud.Text.Length > 0) Then

                If dtSol.Rows.Count > 0 Then
                    idStatus = dtSol.Rows(0).Item(3)
                    Me.ddlEstatus.SelectedValue = idStatus
                Else
                    Me.ddlEstatus.SelectedValue = status
                End If

                Me.ddlTipo.SelectedValue = 0
                Me.ddlProvincia.SelectedValue = 0

            Else

                Me.ddlEstatus.SelectedValue = status
                Me.ddlTipo.SelectedValue = tipo
                Me.ddlProvincia.SelectedValue = prov
            End If

            If (status = 99) And (prov = 0) And (tipo = 0) And (NroSol = 0) Then
                Me.ddlEstatus.SelectedValue = 99

            End If

            Me.gvSolicitudes.DataSource = dtSol
            Me.gvSolicitudes.DataBind()
            Me.gvSolicitudes.Visible = True

        Catch Iex As InvalidCastException
            Me.lblMensaje.Text = "El Nro. de Solicitud debe ser numérico."
        Catch Ex As Exception
            Me.lblMensaje.Text = Ex.Message
            SuirPlus.Exepciones.Log.LogToDB(Ex.ToString())
        End Try


    End Sub

    Private Sub cargarFormulario()


        Try
        Catch Iex As InvalidCastException
            Me.lblMensaje.Text = "El Nro. de Solicitud debe ser numérico."
        Catch Ex As Exception
            Me.lblMensaje.Text = Ex.Message
            SuirPlus.Exepciones.Log.LogToDB(Ex.ToString())
        End Try



    End Sub

    'Private Sub CargarDropDowns()

    '    Dim dtStatus As DataTable
    '    Dim dtOficina As DataTable = Nothing
    '    Dim dtTipo As DataTable
    '    Dim dtSectorSalarial As DataTable
    '    Dim dtSectorEconomico As DataTable
    '    Dim dtActividad As DataTable

    '    dtStatus = SuirPlus.SolicitudesEnLinea.Solicitudes.getStatus()
    '    'dtOficina = SuirPlus.SolicitudesEnLinea.Solicitudes.getOficinas()
    '    dtTipo = SuirPlus.SolicitudesEnLinea.Solicitudes.getTiposSolicitudes()
    '    dtSectorSalarial = SuirPlus.Mantenimientos.SectoresSalariales.getSectoresSalariales()
    '    dtSectorEconomico = SuirPlus.Utilitarios.TSS.getSectoresEconomicos()
    '    dtActividad = SuirPlus.MDT.General.listarActividad()


    '    Me.ddlEstatus.DataSource = dtStatus
    '    Me.ddlEstatus.DataTextField = "descripcion"
    '    Me.ddlEstatus.DataValueField = "id_status"
    '    Me.ddlEstatus.DataBind()
    '    Me.ddlEstatus.Items.Add(New WebControls.ListItem("Todos", 99))
    '    Me.ddlEstatus.SelectedValue = 0

    '    'Me.ddlTipo.ClearSelection()
    '    Me.ddlTipo.Items.Add(New WebControls.ListItem("Todos", 0))
    '    'Me.ddlTipo.SelectedValue = 0      
    '    'Me.ddlTipo.Items.Insert(0, New ListItem("Seleccione", "0"))
    '    Me.ddlTipo.DataSource = dtTipo
    '    Me.ddlTipo.DataTextField = "TIPOSOLICITUD"
    '    Me.ddlTipo.DataValueField = "IDTIPO"
    '    Me.ddlTipo.DataBind()
    '    Me.ddlTipo.SelectedValue = 0


    '    Me.ddlProvincia.Items.Add(New WebControls.ListItem("Todos", 0))
    '    Me.ddlProvincia.DataSource = SuirPlus.Utilitarios.TSS.getProvincias()
    '    Me.ddlProvincia.DataTextField = "PROVINCIA_DES"
    '    Me.ddlProvincia.DataValueField = "Id_provincia"

    '    Me.ddlProvincia.DataBind()
    '    Me.ddlProvincia.SelectedValue = 0



    '    'Me.ddlSectorSalarial.Items.Add(New WebControls.ListItem("Todos", 0))
    '    Me.ddlSectorSalarial.DataSource = dtSectorSalarial
    '    Me.ddlSectorSalarial.DataTextField = "descripcion"
    '    Me.ddlSectorSalarial.DataValueField = "id"

    '    Me.ddlSectorSalarial.DataBind()
    '    'Me.ddlSectorSalarial.SelectedValue = 0

    '    'Me.ddlSectorEconomico.Items.Add(New WebControls.ListItem("Todos", 0))
    '    Me.ddlSectorEconomico.DataSource = dtSectorEconomico
    '    Me.ddlSectorEconomico.DataTextField = "SECTOR_ECONOMICO_DES"
    '    Me.ddlSectorEconomico.DataValueField = "ID_SECTOR_ECONOMICO"

    '    Me.ddlSectorEconomico.DataBind()
    '    'Me.ddlSectorEconomico.SelectedValue = 0

    '    'Me.ddlActividad.Items.Add(New WebControls.ListItem("Todos", 0))
    '    Me.ddlActividad.DataSource = dtActividad
    '    Me.ddlActividad.DataTextField = "descripcion"
    '    Me.ddlActividad.DataValueField = "id"

    '    Me.ddlActividad.DataBind()
    '    'Me.ddlActividad.SelectedValue = 0

    'End Sub

   
    Private Sub CargarDropDowns()

        Dim dtStatus As DataTable
        Dim dtOficina As DataTable = Nothing
        Dim dtTipo As DataTable

        dtStatus = SuirPlus.SolicitudesEnLinea.Solicitudes.getStatus()
        'dtOficina = SuirPlus.SolicitudesEnLinea.Solicitudes.getOficinas()
        dtTipo = SuirPlus.SolicitudesEnLinea.Solicitudes.getTiposSolicitudes

        Me.ddlEstatus.DataSource = dtStatus
        Me.ddlEstatus.DataTextField = "descripcion"
        Me.ddlEstatus.DataValueField = "id_status"
        Me.ddlEstatus.DataBind()
        Me.ddlEstatus.Items.Add(New WebControls.ListItem("Todos", 99))
        Me.ddlEstatus.SelectedValue = 0

        Me.ddlTipo.DataSource = dtTipo
        Me.ddlTipo.DataTextField = "TipoSolicitud"
        Me.ddlTipo.DataValueField = "IdTipo"
        Me.ddlTipo.DataBind()
        Me.ddlTipo.Items.Add(New WebControls.ListItem("Todos", 0))
        Me.ddlTipo.SelectedValue = 0

        Me.ddlProvincia.DataSource = SuirPlus.Utilitarios.TSS.getProvincias()
        Me.ddlProvincia.DataTextField = "PROVINCIA_DES"
        Me.ddlProvincia.DataValueField = "Id_provincia"
        Me.ddlProvincia.DataBind()
        Me.ddlProvincia.Items.Add(New WebControls.ListItem("Todos", 0))
        Me.ddlProvincia.SelectedValue = 0

    End Sub

    Private Sub CargarSolicitud()

        Dim solicitud = SuirPlus.SolicitudesEnLinea.Solicitudes.getInfoEmpresa(txtIDSolicitud.Text)

    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click

        Me.cargarGrid()

    End Sub


    Protected Sub gvSolicitudes_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvSolicitudes.RowCommand
        Dim Nro As Integer = e.CommandArgument
        If e.CommandName = "Ver" Then
            Response.Redirect("ManejoSolicitudesDetalle.aspx?NroSol=" & Nro)
            'CargarSolicitud()


        End If

    End Sub


End Class
