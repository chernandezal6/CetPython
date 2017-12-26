Imports System.Data
Partial Class Controles_ucEnfermedadComun
    Inherits System.Web.UI.UserControl


    Public Property TrabajadorCelular() As String
        Get
            Return txtTrabajadorCelular.phoneNumber
        End Get
        Set(ByVal Value As String)
            txtTrabajadorCelular.phoneNumber = Value
        End Set
    End Property

    Public Property TrabajadorTelefono() As String
        Get
            Return txtTrabajadorTelefono.phoneNumber
        End Get
        Set(ByVal Value As String)
            txtTrabajadorTelefono.phoneNumber = Value
        End Set
    End Property

    Public Property TrabajadorCorreo() As String
        Get
            Return txtTrabajadorCorreo.Text
        End Get
        Set(ByVal Value As String)
            txtTrabajadorCorreo.Text = Value
        End Set
    End Property

    Public Property TrabajadorDireccion() As String
        Get
            Return txtTrabajadorDireccion.Text
        End Get
        Set(ByVal Value As String)
            txtTrabajadorDireccion.Text = Value
        End Set
    End Property

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not IsPostBack Then

        End If

    End Sub
    Public Sub LoadDatosIniciales(ByVal formulario As DataTable)
        LimpiarDatosIniciales()
        CargarDatosIniciales(formulario)
    End Sub
    Public Sub LoadNuevoFormulario()
        LimpiarDatosIniciales()
        MostrarDatosIniciales()
    End Sub
    Private Sub MostrarDatosIniciales()

        btnRegistrarDatosIniciales.Visible = False
        btnCompletar.Visible = True

        Me.divBotonesDatosIniciales.Visible = True
        Me.divDatosIniciales.Visible = True
        Me.divSolicitudRegistrada.Visible = True

        'Me.divCompletar.Visible = False
        'Me.divConfirmar.Visible = False
        'Me.divDatosMedico.Visible = False
        'Me.divDiscapacidad.Visible = False
        'Me.divFechaDiasAmbulatorio.Visible = False
        'Me.divFechaDiasHospitalizacion.Visible = False
        'Me.divMedico.Visible = False
        'Me.divPadecimientos.Visible = False
        'Me.divPSS.Visible = False
    End Sub
    Private Sub LimpiarDatosIniciales()
        Me.txtTrabajadorDireccion.Text = String.Empty
        Me.txtTrabajadorCelular.phoneNumber = String.Empty
        Me.txtTrabajadorCorreo.Text = String.Empty
        Me.txtTrabajadorTelefono.phoneNumber = String.Empty
    End Sub
    Private Sub CargarDatosIniciales(ByVal formulario As DataTable)
        'Mostrar datos en los controles de la info inicial
        Me.txtTrabajadorDireccion.Text = formulario.Rows(0)("Direccion").ToString
        Me.txtTrabajadorCelular.phoneNumber = formulario.Rows(0)("Celular").ToString
        Me.txtTrabajadorCorreo.Text = formulario.Rows(0)("Email").ToString
        Me.txtTrabajadorTelefono.phoneNumber = formulario.Rows(0)("Telefono").ToString
        'Me.numeroFormulario = formulario.Rows(0)("NroSolicitud").ToString

        'Llenar ViewStates con datos iniciales para verificar que no se hayan cambiado
        'antes de imprimir el formulario, en dicho caso, se hace un update con los cambios
        ViewState("direccion") = formulario.Rows(0)("Direccion").ToString
        ViewState("celular") = formulario.Rows(0)("Celular").ToString
        ViewState("email") = formulario.Rows(0)("Email").ToString
        ViewState("telefono") = formulario.Rows(0)("Telefono").ToString
        ViewState("NumeroFormulario") = formulario.Rows(0)("NroSolicitud").ToString
        ViewState("tipoSolicitud") = "Nueva"
    End Sub
End Class
