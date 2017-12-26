
Imports SuirPlus

Partial Class Controles_UCCiudadano
    Inherits System.Web.UI.UserControl


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

    Public Event CiudadanoEncontrado(ByVal sender As Object, ByVal e As EventArgs)
    Public Event BusquedaCancelada(ByVal sender As Object, ByVal e As EventArgs)

    Public Property showNSS() As Boolean
        Get
            Return Me.pnlNSS.Visible
        End Get
        Set(ByVal Value As Boolean)
            Me.pnlNSS.Visible = Value
        End Set
    End Property

    Public ReadOnly Property getSexo() As String
        Get
            Return Me.ddSexo.Text
        End Get
    End Property

    Public ReadOnly Property getNSS() As String
        Get
            Return Me.lblNss.Text
        End Get
    End Property

    Public ReadOnly Property getDocumento() As String

        Get
            Return Me.txtRepDocumento.Text
        End Get

    End Property

    Public ReadOnly Property getTipoDoc() As String

        Get
            Return Me.ddRepTipoDoc.SelectedValue
        End Get

    End Property

    Public ReadOnly Property getNombres() As String

        Get
            Return Me.lblNombres.Text
        End Get

    End Property

    Public ReadOnly Property getApellidos() As String

        Get
            Return Me.lblApellidos.Text
        End Get

    End Property

    Public Sub updatePanelCiudadano()
        Me.updGeneral.Update()
    End Sub

    Private _showPasaporte As Boolean = True

    Public Property ShowPasaporte() As Boolean
        Get
            Return _showPasaporte
        End Get
        Set(value As Boolean)
            _showPasaporte = value
        End Set
    End Property


    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load



        If Not IsPostBack Then

            Me.iniForm()
            'Por default no se ve el nss
            Me.showNSS = False

        End If




        Me.lblRepError.Text = ""

        If ShowPasaporte Then

        Else
            If Me.ddRepTipoDoc.Items.Count > 1 Then
                Me.ddRepTipoDoc.Items.RemoveAt(1)
            End If
        End If

    End Sub

    Private Sub setRepError(ByVal msg As String)
        Me.lblRepError.Text = msg
    End Sub

    Private Sub btnRepBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRepBuscar.Click

        Me.txtRepDocumento.Text = UCase(Trim(Me.txtRepDocumento.Text + ""))
        Me.consultaPersona(Me.ddRepTipoDoc.SelectedValue, Me.txtRepDocumento.Text)

    End Sub

    'Prepara el control para consultar persona
    Public Sub iniForm()

        'Apagando imagen
        Me.imgRepBusca.Visible = False

        'Apagando panel de info persona
        Me.pnlInfoPersona.Visible = False
        Me.pnlNuevaPersona.Visible = False
        Me.lblNombres.Text = String.Empty

        'Limpiando controles de consulta
        Me.ddRepTipoDoc.SelectedIndex = 0
        'Me.ddRepTipoDoc.Enabled = True
        Me.txtRepDocumento.Text = ""
        Me.txtRepDocumento.ReadOnly = False
        Me.lblNss.Text = ""

        Me.btnRepBuscar.Enabled = True

    End Sub

    'Ejecuta la consulta de personas y setea el control tanto 
    'para mostrar informacion como para captura de nuevos individuos
    'en los casos que sea necesario.
    Public Sub consultaPersona(ByVal tipoDoc As String, ByVal doc As String)

        If Me.txtRepDocumento.Text = "" Then
            Me.setRepError("Debe ingresar el número de documento.")
            Return
        End If
        If ddRepTipoDoc.SelectedValue = "P" Then
            If Len(txtRepDocumento.Text) = 9 Or Len(txtRepDocumento.Text) = 11 Then
                lblRepError.Text = Utilitarios.TSS.getErrorDescripcion(61)
                lblRepError.Visible = True
                Return
            End If
        End If

        'Buscando ciudadano
        Dim tmpstr As String = SuirPlus.Utilitarios.TSS.consultaCiudadano(Me.ddRepTipoDoc.SelectedValue, Me.txtRepDocumento.Text)
        Dim retStr As String() = Split(tmpstr, "|")

        'El ciudadano fue encontrado
        If retStr(0) = "0" Then
            'Presenta info de la persona
            Me.setInfoPersona(retStr(1), retStr(2), retStr(3))

        Else 'Si no fue encontrado permite agregarlo

            If Me.ddRepTipoDoc.SelectedValue = "P" Then
                Me.setNuevaPersona()
            Else
                'Me.imgRepBusca.ImageUrl = System.Configuration.ConfigurationSettings.AppSettings("IMG_CANCELAR")
                Me.imgRepBusca.ImageUrl = CType(Me.Page(), BasePage).urlImgCancelar
                Me.imgRepBusca.Visible = True
                Me.setRepError("La persona no fue encontrada.")
            End If

        End If

    End Sub

    'Prepara y presenta el formulario para captura de nuevas personas
    Private Sub setNuevaPersona()

        Me.imgRepBusca.Visible = False

        Me.ddRepTipoDoc.Enabled = False
        Me.btnRepBuscar.Enabled = False
        Me.txtRepDocumento.ReadOnly = True
        Me.pnlInfoPersona.Visible = False
        Me.pnlNuevaPersona.Visible = True

        'Limpiando controles
        Me.txtNombres.Text = ""
        Me.txtApellidoPat.Text = ""
        Me.txtApellidoMat.Text = ""
        Me.ddSexo.SelectedIndex = 0
        Me.ucFechaNac.setSeleccionar()

    End Sub

    'Prepara y presenta informacion de la persona
    Private Sub setInfoPersona(ByVal nombres As String, ByVal apellidos As String, ByVal nss As String)

        Me.imgRepBusca.ImageUrl = CType(Me.Page(), BasePage).urlImgOK
        Me.imgRepBusca.Visible = True

        Me.lblNombres.Text = nombres
        Me.lblApellidos.Text = apellidos
        Me.lblNss.Text = nss

        Me.ddRepTipoDoc.Enabled = False
        Me.btnRepBuscar.Enabled = False
        Me.txtRepDocumento.ReadOnly = True
        Me.pnlInfoPersona.Visible = True
        Me.pnlNuevaPersona.Visible = False

        'Dispara el evento  CiudadanoEncontrado
        RaiseEvent CiudadanoEncontrado(Me, Nothing)


    End Sub

    Private Sub btnRepCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRepCancelar.Click, btnCancelarNP.Click

        Me.iniForm()

        'Dispara el evento  BusquedaCancelada
        RaiseEvent BusquedaCancelada(Me, Nothing)

    End Sub

    Private Sub btnAgregar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAgregar.Click

        Dim nombres, pApellido, sApellido As String
        Dim fechaNac As Date

        'Validando campos obligatorios
        nombres = UCase(Trim(Me.txtNombres.Text))
        pApellido = UCase(Trim(Me.txtApellidoPat.Text))
        sApellido = UCase(Trim(Me.txtApellidoMat.Text))

        If nombres = "" Then
            Me.setRepError("Debe introducir el nombre del ciudadano.")
            Return
        End If

        If pApellido = "" Then
            Me.setRepError("Debe introducir el primer apellido del ciudadano.")
            Return
        End If

        If Me.ddSexo.SelectedIndex = 0 Then
            Me.setRepError("Debe introducir el sexo del ciudadano.")
            Return
        End If

        Try
            fechaNac = Me.ucFechaNac.dateValue
        Catch ex As Exception
            Me.setRepError("La fecha de nacimiento es invalida.")
            Return
        End Try

        If Not Me.ucFechaNac.isValid Then
            Me.setRepError("Debe ingresar la fecha de nacimiento.")
            Return
        Else

            'La fecha no puede ser mayor que la actual
            If Me.ucFechaNac.dateValue > Now.Date.AddYears(-10) Then
                Me.setRepError("La fecha de nacimiento no puede ser menor de 10 años.")
                Return
            End If

        End If

        Dim ret As String

        Try

            ret = SuirPlus.Utilitarios.TSS.insertaCiudadano(Me.ddRepTipoDoc.SelectedValue, Me.txtRepDocumento.Text, Me.txtNombres.Text, Me.txtApellidoMat.Text, Me.txtApellidoPat.Text, Me.ddSexo.SelectedValue, Me.ucFechaNac.stringDate, Me.getUsuario)

            'Todo bien
            If Split(ret, "|")(0) = "0" Then

                Me.consultaPersona(Me.ddRepTipoDoc.SelectedValue, Me.txtRepDocumento.Text)

            Else 'Ocurrio un error

                Me.setRepError(Split(ret, "|")(1))

            End If

        Catch ex As Exception

            Me.setRepError(ex.ToString)

        End Try

    End Sub

    Private Function getUsuario() As String

        'Return CType(Me.Parent, BasePage).UsrUserName
        Return HttpContext.Current.Session("UsrUserName")

    End Function

End Class

