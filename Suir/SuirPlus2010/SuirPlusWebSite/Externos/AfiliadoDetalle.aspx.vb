Imports System.Data

Partial Class Externos_AfiliadoDetalle
    Inherits BasePage

    Protected empleado As SuirPlus.Empresas.Trabajador

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Dim idCiudadano As String = Request.QueryString.Item("idEmp")
        Dim regPatronal As String = Request.QueryString.Item("patreg")
        Dim idNomina As String = Request.QueryString.Item("nom")

        If idCiudadano = String.Empty Or regPatronal = String.Empty Or idNomina = String.Empty Then
            'Manejar esta excepcion
            Exit Sub
        End If

        cargarDatosTrabajador(idCiudadano, CInt(regPatronal), CInt(idNomina))
        cargarDatosEmpleador(CInt(regPatronal))

    End Sub

    Sub cargarDatosTrabajador(ByVal idCiudadano As String, ByVal regPatronal As Integer, ByVal idNomina As Integer)

        Dim dtEmpleado As DataTable

        If idCiudadano.Length = 9 Then
            empleado = New SuirPlus.Empresas.Trabajador(Convert.ToInt32(idCiudadano))
        ElseIf idCiudadano.Length = 11 Then
            empleado = New SuirPlus.Empresas.Trabajador(SuirPlus.Empresas.Trabajador.TrabajadorDocumentoType.Cedula, idCiudadano)
        End If

        Me.lblTrabajador.Text = empleado.Nombres + " " + empleado.PrimerApellido + " " + empleado.SegundoApellido
        Me.lblNSS.Text = SuirPlus.Utilitarios.Utils.FormatearNSS(empleado.NSS)
        Me.lblCedula.Text = SuirPlus.Utilitarios.Utils.FormatearCedula(empleado.Documento)
        dtEmpleado = empleado.getInfoNominaEmpleador(regPatronal, idNomina)
        Me.lblSalario.Text = String.Format("{0:c}", dtEmpleado.Rows(0).Item("salario_ss"))
        Me.lblNomina.Text = dtEmpleado.Rows(0).Item("nomina_des").ToString
        Me.lblFechaIngreso.Text = String.Format("{0:d}", dtEmpleado.Rows(0).Item("fecha_ingreso"))

        Me.lblFechaReingreso.Text = String.Format("{0:d}", dtEmpleado.Rows(0).Item("Fecha_Ult_Reintegro"))

        Me.lblFechaRegistro.Text = dtEmpleado.Rows(0).Item("fecha_registro").ToString
        Me.lblEstatus.Text = dtEmpleado.Rows(0).Item("status").ToString


    End Sub

    Sub cargarDatosEmpleador(ByVal idRegistroPatronal As String)

        Dim empleador As New SuirPlus.Empresas.Empleador(CInt(idRegistroPatronal))
        Me.lblNombreComercial.Text = empleador.NombreComercial
        Me.lblRazonSocial.Text = empleador.RazonSocial
        Me.lblActividadEconomica.Text = empleador.ActividadEconomica
        Me.lblInsitucion.Text = empleador.TipoEmpresaDescripcion
        Me.lblTelefono1.Text = SuirPlus.Utilitarios.Utils.FormatearTelefono(empleador.Telefono1)
        Me.lblExt1.Text = empleador.Ext1
        Me.lblTelefono2.Text = SuirPlus.Utilitarios.Utils.FormatearTelefono(empleador.Telefono2)
        Me.lblExt2.Text = empleador.Ext2
        Me.lblCalle.Text = empleador.Calle
        Me.lblEdificio.Text = empleador.Edificio
        Me.lblPiso.Text = empleador.Piso
        Me.lblApartamento.Text = empleador.Apartamento
        Me.lblSector.Text = empleador.Sector
        Me.lblMunicipo.Text = empleador.Municipio
        Me.lblProvincia.Text = empleador.Provincia

        Me.gvRepresentante.DataSource = empleador.getRepresentantes
        Me.gvRepresentante.DataBind()


    End Sub

    Protected Function formateaTelefono(ByVal tel As Object) As Object

        If Not tel Is DBNull.Value Then

            Return SuirPlus.Utilitarios.Utils.FormatearTelefono(tel.ToString)

        End If

        Return tel

    End Function
End Class

