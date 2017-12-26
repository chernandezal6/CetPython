Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios
Imports SuirPlus.Mantenimientos
Imports System.Data
Partial Class Empleador_IngresarSectorEmpleadores
    Inherits BasePage
    Dim dt As New DataTable
    #Region "Metodos Internos de la pagina"
    Protected Sub showGridEmpleadores()
        If Not pnlGridEmpleadores Is Nothing Then
            pnlGridEmpleadores.Visible = True
            divDetalleEmpresa.Visible = False
            'upEmpleadores.Update()
        End If
    End Sub
    'Protected Sub ShowDetalleEmpleadores()
    'If Not pnlDetalleEmpresa Is Nothing Then
    'pnlDetalleEmpresa.Visible = True
    'upTabs.Update()
    'End If
    'End Sub
    'Protected Sub hideDetalleEmpleadores()
    'If Not pnlDetalleEmpresa Is Nothing Then
    'pnlDetalleEmpresa.Visible = False
    'upTabs.Update()
    'End If
    'End Sub

    Protected Sub hideGridEmpleadores()
        If Not pnlGridEmpleadores Is Nothing Then
            pnlGridEmpleadores.Visible = False
            ' upEmpleadores.Update()
        End If
    End Sub
    Protected Sub CargarDatosEmpleador(ByVal Registro_Patronal As Integer)
        'hideGridEmpleadores()
        'ShowDetalleEmpleadores()
        divDetalleEmpresa.Visible = True
        Dim emp = New Empleador(Registro_Patronal)
        Me.lblRNC.Text = emp.RNCCedula
        Me.lblRegPatronal.Text = emp.RegistroPatronal
        Me.lblRazonSocial.Text = emp.RazonSocial
        Me.lblNombreComercial.Text = emp.NombreComercial
        Me.lblSectorEconomico.Text = emp.SectorEconomico
        If emp.Estatus = "B" Then
            lblEstatus.CssClass = "error"
            lblEstatus.Font.Size = 10
        Else
            lblEstatus.CssClass = "labelData"
            lblEstatus.Font.Size = 8
        End If
        Me.lblEstatus.Text = IIf(emp.Estatus = "A", "ACTIVO", "DE BAJA")
        Me.lblTipoEmpresa.Text = emp.TipoEmpresaDescripcion
        Me.lblEmail.Text = emp.Email
        Me.lblTelefono1.Text = Utils.FormatearTelefono(emp.Telefono1)
        'Agregamos la extension al telefono 1
        If Not String.IsNullOrEmpty(emp.Ext1) Then
            Me.lblTelefono1.Text += " Ext. " & emp.Ext1
        End If

        Me.lblTelefono2.Text = Utils.FormatearTelefono(emp.Telefono2)

        If Not String.IsNullOrEmpty(emp.Ext2) Then
            Me.lblTelefono2.Text += " Ext. " & emp.Ext2
        End If

        Me.lblFax.Text = Utils.FormatearTelefono(emp.Fax)
        Me.lblAdministracionLocal.Text = emp.AdministradoraLocal
        Me.lblCalle.Text = emp.Calle
        Me.lblNumero.Text = emp.Numero
        Me.lblEdificio.Text = emp.Edificio
        Me.lblPiso.Text = emp.Piso
        Me.lblApartamento.Text = emp.Apartamento
        Me.lblSector.Text = emp.Sector
        Me.lblCapital.Text = FormatNumber(emp.Capital)
        Me.lblMunicipio.Text = emp.Municipio
        Me.lblProvincia.Text = emp.Provincia

        If emp.FechaRegistro <> Nothing Then
            Me.lblFechaRegistro.Text = String.Format("{0:d}", emp.FechaRegistro)
        End If

        If emp.FechaConstitucion <> Nothing Then
            Me.lblFechaConstitucion.Text = String.Format("{0:d}", emp.FechaConstitucion)
        End If

        If emp.FechaIniciaActividades <> Nothing Then
            Me.lblFechaInicioOperacion.Text = String.Format("{0:d}", _
                                                            emp.FechaIniciaActividades)
        End If
    End Sub
    Protected Sub CargarDatosEmpleador()
        dt = Empleador.ConsEmpleadorSinSectorSalarial(Me.txtRNC.Text, Me.txtRazonSocial.Text)

        If dt.Rows.Count > 0 Then
            showGridEmpleadores()
            gvEmpleadores.DataSource = dt.DefaultView
            gvEmpleadores.DataBind()
        Else
            lblMensaje.ForeColor = Drawing.Color.Red
            lblMensaje.Text = "No hay datos para mostrar"
        End If
       
    End Sub
    Protected Sub CargarSectoresSalariales()
        ddlescalasalarial.DataSource = SectoresSalariales.getSectoresSalariales
        ddlescalasalarial.DataTextField = "descripcion"
        ddlescalasalarial.DataValueField = "id"
        ddlescalasalarial.DataBind()

        ddlescalasalarial.Items.Insert(0, New ListItem("--No especificado--", "0"))
    End Sub
    Protected Sub CargarRepresentante(ByVal RegistroPatronal As Int32)
        Me.dtRepresentante.DataSource = Representante.getRepresentante(-1, RegistroPatronal)
        Me.dtRepresentante.DataBind()
    End Sub

    Protected Function formatCedula(ByVal cedula As Object) As String

        If cedula Is DBNull.Value Then
            Return String.Empty
        End If

        If cedula.ToString.Length = 11 Then
            Return Utils.FormatearCedula(cedula)
        Else
            Return cedula
        End If

    End Function

    Protected Function formatTelefono(ByVal telefono As Object) As String
        If telefono Is DBNull.Value Then
            Return String.Empty
        End If

        Return Utils.FormatearTelefono(telefono)


    End Function
#End Region
  
#Region "Metodos de la pagina"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
            CargarDatosEmpleador()
            CargarSectoresSalariales()
        End If
    End Sub
    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        txtRNC.Text = String.Empty
        txtRazonSocial.Text = String.Empty
        'CargarDatosEmpleador()
        dt = Nothing
        gvEmpleadores.DataSource = dt
        gvEmpleadores.DataBind()
        hideGridEmpleadores()
        divDetalleEmpresa.Visible = False
    End Sub
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        Try
            dt = Empleador.ConsEmpleadorSinSectorSalarial(Me.txtRNC.Text, Me.txtRazonSocial.Text)

            'Si solo viene un registro llenamos los paneles directamente y no mostramos el grid.
            If dt.Rows.Count = 1 Then
                CargarDatosEmpleador(dt.Rows(0).Field(Of Int32)("id_registro_patronal"))
                cargarRepresentante(dt.Rows(0).Field(Of Int32)("id_registro_patronal"))
            Else
                divDetalleEmpresa.Visible = False
                CargarDatosEmpleador()
            End If
        Catch ex As Exception
            lblMensaje.Text = ex.Message
        End Try
    End Sub
    Protected Sub gvEmpleadores_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvEmpleadores.RowCommand

        If e.CommandName.Equals("Ver") Then

            divDetalleEmpresa.Visible = True
            hideGridEmpleadores()

            Dim RegistroPatronal = e.CommandArgument.ToString

            CargarDatosEmpleador(RegistroPatronal)
            cargarRepresentante(RegistroPatronal)

        End If

    End Sub
  
    Protected Sub btnAsignarEscala_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAsignarEscala.Click
        lblMensaje.Text = String.Empty
        lblMensajeAsignacion.Text = String.Empty
        If ddlescalasalarial.SelectedValue <> "0" Then
            Try
                Dim usuario = UsrRNC + UsrUserName
                Dim result = Empleador.AsignarSectorSalarial(CInt(lblRegPatronal.Text), CInt(ddlescalasalarial.SelectedValue), usuario)


                If result.Equals("0") Then
                    lblMensajeAsignacion.Text = "Sector Salarial Asignado Correctamente..."
                    divDetalleEmpresa.Visible = False
                    CargarDatosEmpleador()
                    ddlescalasalarial.SelectedValue = "0"

                Else
                    lblMensajeAsignacion.Text = result
                End If

            Catch ex As Exception
                lblMensajeAsignacion.Text = ex.Message
            End Try
        Else
            lblMensaje.Text = "Debe seleccionar un sector salarial"
        End If
    End Sub
    Protected Sub btnvolverlistado_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnvolverlistado.Click
        showGridEmpleadores()
    End Sub
#End Region
   

 
End Class
