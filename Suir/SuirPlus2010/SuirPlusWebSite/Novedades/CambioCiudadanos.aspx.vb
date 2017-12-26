Imports System.Data
Partial Class CambioCiudadanos
    Inherits BasePage


#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    ''Private Property setRepError As String
    ''Private Property lblPeriodo As Object
    
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

    Public ReadOnly Property getIdNSS() As String

        Get
            Return Me.txtIdNss.Text
        End Get

    End Property
    Public ReadOnly Property getDoc() As String

        Get
            Return Me.TxtDoc.Text
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

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        If Not Page.IsPostBack Then
            Me.iniForm()
            'Por default no se ve el nss
            Me.showNSS = False

            Me.lblMsg.Text = ""

        End If


        'MOSTRAR CIUDADANOS PENDIENTES DE ACTUALIZACION


    End Sub


    Private Sub btnRepBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRepBuscar.Click

        '  Dim dt = New DataTable

        Me.txtIdNss.Text = UCase(Trim(Me.txtIdNss.Text + ""))

        Me.consultaPersona(Me.txtIdNss.Text)

        'Me.consultaPersonaCambio(Me.txtIdNss.Text)


    End Sub

    'Prepara el control para consultar persona
    Public Sub iniForm()

        'Apagando imagen
        Me.imgRepBusca.Visible = False

        'Apagando panel de info persona
        Me.pnlInfoPersona.Visible = True
        Me.pnlNuevaPersona.Visible = False

        'Limpiando controles de consulta
        Me.txtIdNss.Text = ""
        Me.txtIdNss.ReadOnly = False
        Me.lblNss.Text = ""

        'Limpiando controles
        Me.lblNombres.Text = ""
        Me.lblApellidos.Text = ""
        Me.lblNss.Text = ""
        Me.txtNombres.Text = ""
        Me.txtApellidoPat.Text = ""
        Me.txtApellidoMat.Text = ""
        Me.ddSexo.SelectedIndex = 0
        Me.txtFeNac.Text = ""

        Me.btnRepBuscar.Enabled = True

    End Sub

    Public Sub consultaPersona(ByVal idnss As String)

        Me.lblMsg.Text = String.Empty
        Me.lblNombres.Text = String.Empty
        Me.lblApellidos.Text = String.Empty
        Me.lblIdNss.Text = String.Empty

        If idnss = "" Then
            Me.lblMsg.Text = "Debe ingresar el número de documento."
            Exit Sub
        End If

        'Buscando ciudadano
        Dim result As String = String.Empty
        Dim dt As New DataTable

        dt = SuirPlus.Utilitarios.TSS.getconsultaCiudadanoAct(idnss, result)


        'El ciudadano fue encontrado
        If result = "0" Then
            'Presenta info de la persona

            Me.imgRepBusca.ImageUrl = CType(Me.Page(), BasePage).urlImgOK
            Me.imgRepBusca.Visible = True

            Me.lblNombres.Text = dt.Rows(0)("Nombres").ToString()
            Me.lblApellidos.Text = dt.Rows(0)("PRIMER_APELLIDO").ToString() & " " & dt.Rows(0)("SEGUNDO_APELLIDO").ToString()
            Me.TxtDoc.Text = dt.Rows(0)("no_documento").ToString()
            Me.txtNombres.Text = dt.Rows(0)("Nombres").ToString()
            Me.txtApellidoPat.Text = dt.Rows(0)("PRIMER_APELLIDO").ToString()
            Me.txtApellidoMat.Text = dt.Rows(0)("SEGUNDO_APELLIDO").ToString()
            Me.ddSexo.Text = dt.Rows(0)("sexo").ToString()
            Me.txtFeNac.Text = dt.Rows(0)("fecha_nacimiento").ToString().Substring(0, 10)



            ' Me.ddRepTipoDoc.Enabled = False
            Me.btnRepBuscar.Enabled = False
            Me.txtIdNss.Text = idnss
            Me.txtIdNss.ReadOnly = True
            Me.pnlInfoPersona.Visible = True
            Me.pnlNuevaPersona.Visible = True

        Else
            Me.imgRepBusca.ImageUrl = CType(Me.Page(), BasePage).urlImgCancelar
            Me.imgRepBusca.Visible = True
            Me.lblMsg.Text = "La persona no fue encontrada."
            Exit Sub
        End If

    End Sub

    Public Sub consultaPersonaCambio(ByVal idnss As String)

        If idnss = "" Then
            Me.lblMsg.Text = "Debe ingresar el número de documento."
            Exit Sub
        End If

        'Buscando ciudadano
        Dim result As String = String.Empty
        Dim dt As New DataTable
        dt = SuirPlus.Utilitarios.TSS.getconsultaCiudadanoCambio(idnss, result)



        'El ciudadano fue encontrado
        If dt.Rows.Count > 0 Then

            'Presenta info de la persona
            Me.imgRepBusca.ImageUrl = CType(Me.Page(), BasePage).urlImgOK
            Me.imgRepBusca.Visible = True

            Me.lblNombres.Text = dt.Rows(0)("Nombres").ToString()
            Me.lblApellidos.Text = dt.Rows(0)("PRIMER_APELLIDO").ToString() & " " & dt.Rows(0)("SEGUNDO_APELLIDO").ToString()
            Me.TxtDoc.Text = dt.Rows(0)("no_documento").ToString()
            Me.txtNombres.Text = dt.Rows(0)("Nombres").ToString()
            Me.txtApellidoPat.Text = dt.Rows(0)("PRIMER_APELLIDO").ToString()
            Me.txtApellidoMat.Text = dt.Rows(0)("SEGUNDO_APELLIDO").ToString()
            Me.ddSexo.Text = dt.Rows(0)("sexo").ToString()
            Me.txtFeNac.Text = dt.Rows(0)("fecha_nacimiento").ToString()



            Me.btnRepBuscar.Enabled = False
            Me.txtIdNss.Text = idnss
            Me.txtIdNss.ReadOnly = True
            Me.pnlInfoPersona.Visible = True
            Me.pnlNuevaPersona.Visible = True

        Else
            Me.imgRepBusca.ImageUrl = CType(Me.Page(), BasePage).urlImgCancelar
            Me.imgRepBusca.Visible = True
            Me.lblMsg.Text = "La persona no fue encontrada."
            Exit Sub
        End If

    End Sub

    'presenta el formulario para actualizar el ciudadano
    Private Sub setNuevaPersona()

        Me.imgRepBusca.Visible = False

        Me.btnRepBuscar.Enabled = False
        Me.txtIdNss.ReadOnly = True
        Me.pnlInfoPersona.Visible = False
        Me.pnlNuevaPersona.Visible = True

        'Limpiando controles
        Me.lblNombres.Text = ""
        Me.lblApellidos.Text = ""
        Me.lblNss.Text = ""
        Me.txtNombres.Text = ""
        Me.txtApellidoPat.Text = ""
        Me.txtApellidoMat.Text = ""
        Me.ddSexo.SelectedIndex = 0
        Me.txtFeNac.Text = ""

    End Sub

    Private Sub btnRepCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRepCancelar.Click, btnCancelarNP.Click

        Me.iniForm()
        Me.lblMsg.Text = String.Empty
        RaiseEvent BusquedaCancelada(Me, Nothing)

    End Sub

    Private Sub btnAgregar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAgregar.Click
        If SuirPlus_Status = "REDUCIDO" Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = SuirPlusREDUCIDO
            Exit Sub
        End If

        Dim nombres, pApellido, sApellido As String

        'Validando campos obligatorios
        nombres = UCase(Trim(Me.txtNombres.Text))
        pApellido = UCase(Trim(Me.txtApellidoPat.Text))
        sApellido = UCase(Trim(Me.txtApellidoMat.Text))

        If nombres = "" Then
            Me.lblMsg.Text = "Debe introducir el nombre del ciudadano."
            Exit Sub
        End If

        If pApellido = "" Then
            Me.lblMsg.Text = "Debe introducir el primer apellido del ciudadano."
            Exit Sub
        End If

        Try

        Catch ex As Exception
            Me.lblMsg.Text = "La fecha de nacimiento es invalida."
            Exit Sub
        End Try

        'La fecha no puede ser mayor que la actual
        If Me.txtFeNac.Text > Now.Date.AddYears(10) Then
            Me.lblMsg.Text = "La fecha de nacimiento no puede ser menor de 10 años."
            Exit Sub
        End If


        Dim ret As String

        Try

            ret = SuirPlus.Utilitarios.TSS.InsertarCiudadanoAct( Me.txtIdNss.Text,Me.TxtDoc.Text, Me.txtNombres.Text, Me.txtApellidoMat.Text, Me.txtApellidoPat.Text, Me.ddSexo.SelectedValue, CDate(Me.txtFeNac.Text), Me.getUsuario)

            'Todo bien
            If Split(ret, "|")(0) = "0" Then

                Me.consultaPersona(Me.txtIdNss.Text)
                Me.consultaPersonaCambio(Me.txtIdNss.Text)

                Response.Redirect("CambioCiudadanosAplicar.aspx")
            Else 'Ocurrio un error

                Me.lblMsg.Text = Split(ret, "|")(1)

            End If


        Catch ex As Exception

            Me.lblMsg.Text = ex.ToString

        End Try



    End Sub



    Private Function getUsuario() As String

        'Return CType(Me.Parent, BasePage).UsrUserName
        Return HttpContext.Current.Session("UsrUserName")

    End Function



   

End Class

