Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios
Imports SuirPlus.Mantenimientos
Imports System.Data
Partial Class Empleador_CompletarDatosEmpleador
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim regPatronal As String = String.Empty

        If Not Me.IsPostBack Then
            If Not String.IsNullOrEmpty(UsrRegistroPatronal) Then
                Try
                    regPatronal = UsrRegistroPatronal

                    CargarSectoresSalariales()
                    CargarDatosEmpleador(CInt(regPatronal))
                    CargarRepresentante(CInt(regPatronal))
                    divDetalleEmpresa.Visible = True
                    lblMensaje.Text = ""
                Catch ex As Exception
                    lblMensaje.Text = ex.Message
                End Try
            Else
                divDetalleEmpresa.Visible = False
                lblMensaje.Text = "Error cargando los datos del empleador"
            End If
        End If
    End Sub

    Protected Sub btnAsignarEscala_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAsignarEscala.Click
        lblMensaje.Text = String.Empty
        If ddlescalasalarial.SelectedValue <> "0" Then
            Try
                Dim usuario = UsrUserName
                Dim result = Empleador.AsignarSectorSalarial(CInt(lblRegPatronal.Text), CInt(ddlescalasalarial.SelectedValue), usuario)

                If result.Equals("0") Then
                    '"Sector Salarial Asignado Correctamente...", continuar al suirplus...
                    Response.Redirect("consNotificaciones.aspx")
                Else
                    lblMensaje.Text = result
                End If

            Catch ex As Exception
                lblMensaje.Text = ex.Message
            End Try
        Else
            lblMensaje.Text = "Debe seleccionar un sector salarial"
        End If
    End Sub
    Protected Sub CargarSectoresSalariales()
        ddlescalasalarial.DataSource = SectoresSalariales.getSectoresSalariales
        ddlescalasalarial.DataTextField = "descripcion"
        ddlescalasalarial.DataValueField = "id"
        ddlescalasalarial.DataBind()
        ddlescalasalarial.Items.Insert(0, New ListItem("--No especificado--", "0"))
    End Sub
    Protected Sub CargarDatosEmpleador(ByVal Registro_Patronal As Integer)

        Dim emp = New Empleador(Registro_Patronal)
        If emp.RNCCedula <> String.Empty Then
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
            ' Me.lblCapital.Text = FormatNumber(emp.Capital)
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
        Else
            divDetalleEmpresa.Visible = False
            Throw New Exception("Empleador inválido")
        End If

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
End Class
