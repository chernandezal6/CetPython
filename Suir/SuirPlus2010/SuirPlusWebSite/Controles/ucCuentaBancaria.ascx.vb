Imports SuirPlus
Imports System.Data
Imports SuirPlus.Bancos.EntidadRecaudadora
Imports SuirPlus.Utilitarios.Utils
Partial Class Controles_ucCuentaBancaria
    Inherits System.Web.UI.UserControl

#Region "Propiedades"
    Public Property NumeroCuenta() As String
        Get
            Return Me.txtNumeroCuenta.Text
        End Get
        Set(ByVal Value As String)
            Me.txtNumeroCuenta.Text = Value
        End Set
    End Property
    Public ReadOnly Property TipoCuenta() As String
        Get
            Return Me.ddTipo_Cuentas.SelectedValue
        End Get
    End Property
    Public Property RNCoCedulaTitular() As String
        Get
            Return Me.txtRNCoCedulaTitular.Text
        End Get
        Set(ByVal Value As String)
            Me.txtRNCoCedulaTitular.Text = Value
        End Set
    End Property
    Public Property EntidadRecaudadora() As String
        Get
            Return Me.ddlEntidadRecaudadora.Text()
        End Get
        Set(ByVal Value As String)
            Me.ddlEntidadRecaudadora.Text = Value
        End Set
    End Property
    Public Property NumeroCuentaConfirmacion() As String
        Get
            Return Me.lblNroCuenta.Text
        End Get
        Set(ByVal Value As String)
            Me.lblNroCuenta.Text = Value
        End Set
    End Property
    Public Property RNCoCedulaTitularConfirmacion() As String
        Get
            Return Me.lblRNCoCedulaDuenoCuenta.Text
        End Get
        Set(ByVal Value As String)
            Me.lblRNCoCedulaDuenoCuenta.Text = Value
        End Set
    End Property
    Public Property EntidadRecaudadoraConfirmacion() As String
        Get
            Return Me.lblIdEntidadRecaudadora.Text
        End Get
        Set(ByVal Value As String)
            Me.lblIdEntidadRecaudadora.Text = Value
        End Set
    End Property

    Dim _usrRegistroPatronal As String
    Public Property UsrRegistroPatronal() As String
        Get
            Return _usrRegistroPatronal
        End Get
        Set(ByVal value As String)
            _usrRegistroPatronal = value
        End Set
    End Property

    Dim _usrRNC As String
    Public Property UsrRNC() As String
        Get
            Return _usrRNC
        End Get
        Set(ByVal value As String)
            _usrRNC = value
        End Set
    End Property

    Dim _usrUserName As String
    Public Property UsrUserName() As String
        Get
            Return _usrUserName
        End Get
        Set(ByVal value As String)
            _usrUserName = value
        End Set
    End Property

    Dim _confirmarActualizacion As System.Delegate
    Public WriteOnly Property ConfirmarActualizacion() As System.Delegate
        Set(ByVal Value As System.Delegate)
            _confirmarActualizacion = Value
        End Set
    End Property

    Dim _btnCancelar0_Click As System.Delegate
    Public WriteOnly Property BtnCancelar0Click() As System.Delegate
        Set(ByVal Value As System.Delegate)
            _btnCancelar0_Click = Value
        End Set
    End Property

    Public WriteOnly Property BtnCancelar0Visible() As Boolean
        Set(ByVal Value As Boolean)
            Me.btnCancelar0.Visible = Value
        End Set
    End Property

    Public WriteOnly Property BtnActualizarCuentaText() As String
        Set(ByVal Value As String)
            Me.btnActualizarCuenta.Text = Value
        End Set
    End Property

#End Region

    Protected Sub btnActualizarCuenta_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnActualizarCuenta.Click
        Try
            If ValidarTipoCuenta() Then
                'validaciones de cedula que se encuentre en trabajadores y rnc en empleadores
                'Dim validaRncCedula As String
                'validaRncCedula = Empresas.SubsidiosSFS.Consultas.validaRNCoCedula(Me.txtRNCoCedulaTitular.Text)

                Me.lblMensaje.Text = String.Empty
                'Presentar datos suplidos en view de confirmacion
                Me.lblIdEntidadRecaudadora.Text = ddlEntidadRecaudadora.SelectedItem.ToString()
                Me.lblNroCuenta.Text = IIf(String.IsNullOrEmpty(lblPrefijo.Text), txtNumeroCuenta.Text, lblPrefijo.Text & txtNumeroCuenta.Text)
                Me.lblRNCoCedulaDuenoCuenta.Text = ProperCase(Me.txtRNCoCedulaTitular.Text)
                Me.lblTipoCuenta.Text = ddTipo_Cuentas.SelectedItem.ToString()

                mvNuevaCuenta.SetActiveView(vwConfirmacion)
                lblMensaje.Visible = False
            End If
        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message

        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click

        mvNuevaCuenta.SetActiveView(vwNuevaCuenta)

    End Sub

    Protected Sub btnConfirmar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConfirmar.Click

        'Actualizar datos de cuenta 
        Dim cuentaBancaria As New Empresas.CuentaBancaria()
        cuentaBancaria.NroCuenta = lblNroCuenta.Text.Replace("-", String.Empty)
        cuentaBancaria.RegistroPatronal = UsrRegistroPatronal
        cuentaBancaria.IdEntidadRecaudadora = CType(ddlEntidadRecaudadora.SelectedValue, Int16)
        cuentaBancaria.RNCoCedulaDuenoCuenta = txtRNCoCedulaTitular.Text
        cuentaBancaria.TipoCuenta = ddTipo_Cuentas.SelectedValue
        cuentaBancaria.RNC = UsrRNC

        Dim resultado As String = cuentaBancaria.GuardarCambios(UsrUserName)

        If resultado.Equals("0") Then

            Operaciones.RegistroLogAuditoria.CrearRegistro(UsrRegistroPatronal, UsrUserName, String.Empty, 3, Request.UserHostAddress, Request.UserHostName, cuentaBancaria.NroCuenta, Request.ServerVariables("LOCAL_ADDR"))


            _confirmarActualizacion.DynamicInvoke(Nothing)
        Else
            lblMensaje.Text = resultado
        End If

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            mvNuevaCuenta.SetActiveView(vwNuevaCuenta)
            Try
                Dim entidadesRecaudadoras As New DataTable
                entidadesRecaudadoras = getEntidadesParaSFS()
                ddlEntidadRecaudadora.DataSource = entidadesRecaudadoras
                ddlEntidadRecaudadora.DataTextField = "ENTIDAD_RECAUDADORA_DES"
                ddlEntidadRecaudadora.DataValueField = "ID_ENTIDAD_RECAUDADORA"
                ddlEntidadRecaudadora.DataBind()
                ddlEntidadRecaudadora.Items.Insert(0, New ListItem("Seleccione", "0"))
            Catch ex As Exception
                Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If

    End Sub

    Protected Sub btnCancelar0_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar0.Click

        _btnCancelar0_Click.DynamicInvoke()

    End Sub

    Protected Sub ddlEntidadRecaudadora_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEntidadRecaudadora.SelectedIndexChanged
        ValidarCuentaBanco()
    End Sub

    Private Sub ValidarCuentaBanco()
        lblPrefijo.Text = String.Empty
        lblPrefijo0.Text = String.Empty
        'Banco del Reservas
        'If ddlEntidadRecaudadora.SelectedValue = 1 Then
        '    If ddTipo_Cuentas.SelectedValue = 1 Then
        '        lblPrefijo.Text = "100-01-"
        '        lblPrefijo0.Text = "100-01-"
        '    Else
        '        lblPrefijo.Text = "200-01-"
        '        lblPrefijo0.Text = "200-01-"
        '    End If
        '    regexNumber.ValidationExpression = "[0-9]{10}"
        '    regexNumber.ErrorMessage = "Formato incorrecto, debe contener 10 caracteres numericos!!"
        '    'Banco CITIBank or Banco del Progreso or Banco BDI
        'ElseIf ddlEntidadRecaudadora.SelectedValue = 40 Or ddlEntidadRecaudadora.SelectedValue = 11 Or _
        'ddlEntidadRecaudadora.SelectedValue = 44 Then
        '    regexNumber.ValidationExpression = "[0-9]{10}"
        '    regexNumber.ErrorMessage = "Formato incorrecto, debe contener 10 caracteres numericos!!"
        '    '    'Banco BHD
        '    'ElseIf ddlEntidadRecaudadora.SelectedValue = 23 Then
        '    '    regexNumber.ValidationExpression = "[0-9]{11}"
        '    '    regexNumber.ErrorMessage = "Formato incorrecto, debe contener 11 caracteres numericos!!"
        '    'Banco Santa Cruz
        'ElseIf ddlEntidadRecaudadora.SelectedValue = 34 Then
        '    regexNumber.ValidationExpression = "[0-9]{14}"
        '    regexNumber.ErrorMessage = "Formato incorrecto, debe contener 14 caracteres numericos!!"
        'Else
        '    regexNumber.ValidationExpression = "^[0-9]+$"
        '    regexNumber.ErrorMessage = "Formato incorrecto, debe contener solo caracteres numericos!!"
        'End If
    End Sub

    Private Function ValidarTipoCuenta() As Boolean
        lblMensaje.Text = String.Empty

        ''Banco CITIBank
        'If ddlEntidadRecaudadora.SelectedValue = 40 Then
        '    If ddTipo_Cuentas.SelectedValue = 2 Then
        '        If Not txtNumeroCuenta.Text.Substring(0, 1) = 5 Then
        '            lblMensaje.Text = "Formato incorrecto, Las cuentas de ahorro contienen el dígito '5' en la posición resaltada, en lugar de '" & txtNumeroCuenta.Text.Substring(0, 1) & "'"
        '            lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= <span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta.Text.Substring(0, 1) & "</span>" & txtNumeroCuenta.Text.Substring(1, 9) & "</div>"
        '            Return False
        '        End If
        '    End If

        '    'Banco del Progreso
        'ElseIf ddlEntidadRecaudadora.SelectedValue = 11 Then
        '    If ddTipo_Cuentas.SelectedValue = 1 Then
        '        If Not txtNumeroCuenta.Text.Substring(2, 1) = 1 Then
        '            If Not txtNumeroCuenta.Text.Substring(2, 1) = 2 Then
        '                lblMensaje.Text = "Formato incorrecto, Las cuentas corriente contienen  el dígito  '1' o '2' en la posición resaltada, en lugar de '" & txtNumeroCuenta.Text.Substring(2, 1) & "'"
        '                lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= " & txtNumeroCuenta.Text.Substring(0, 2) & "<span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta.Text.Substring(2, 1) & "</span>" & txtNumeroCuenta.Text.Substring(3, 7) & "</div>"
        '                Return False
        '            End If
        '        End If
        '    Else
        '        If Not txtNumeroCuenta.Text.Substring(2, 1) = 3 Then
        '            lblMensaje.Text = "Formato incorrecto, Las cuentas de ahorro contienen el dígito '3' en la posición resaltada, en lugar de '" & txtNumeroCuenta.Text.Substring(2, 1) & "'"
        '            lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= " & txtNumeroCuenta.Text.Substring(0, 2) & "<span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta.Text.Substring(2, 1) & "</span>" & txtNumeroCuenta.Text.Substring(3, 7) & "</div>"
        '            Return False
        '        End If
        '    End If

        '    ''Banco BHD
        '    'ElseIf ddlEntidadRecaudadora.SelectedValue = 23 Then
        '    '    If ddTipo_Cuentas.SelectedValue = 1 Then
        '    '        If Not txtNumeroCuenta.Text.Substring(7, 3) = "001" Then
        '    '        lblMensaje.Text = "Formato incorrecto, Las cuentas corriente contienen los dígitos '001' en la posición resaltada, en lugar de '" & txtNumeroCuenta.Text.Substring(7, 3) & "'"
        '    '            lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= " & txtNumeroCuenta.Text.Substring(0, 6) & "<span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta.Text.Substring(7, 3) & "</span>" & txtNumeroCuenta.Text.Substring(10, 1) & "</div>"
        '    '            Return False
        '    '        End If
        '    '    Else
        '    '        If Not txtNumeroCuenta.Text.Substring(7, 3) = "004" Then
        '    '        lblMensaje.Text = "Formato incorrecto, Las cuentas de ahorro contienen los dígitos  '004' en la posición resaltada, en lugar de '" & txtNumeroCuenta.Text.Substring(7, 3) & "'"
        '    '            lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= " & txtNumeroCuenta.Text.Substring(0, 6) & "<span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta.Text.Substring(7, 3) & "</span>" & txtNumeroCuenta.Text.Substring(10, 1) & "</div>"
        '    '            Return False
        '    '        End If
        '    '    End If

        '    'Banco Santa Cruz
        '    ElseIf ddlEntidadRecaudadora.SelectedValue = 34 Then
        '        If ddTipo_Cuentas.SelectedValue = 1 Then
        '        If Not txtNumeroCuenta.Text.Substring(4, 3) = "101" And Not txtNumeroCuenta.Text.Substring(4, 3) = "103" _
        '        And Not txtNumeroCuenta.Text.Substring(4, 3) = "100" And Not txtNumeroCuenta.Text.Substring(4, 3) = "102" Then
        '            lblMensaje.Text = "Formato incorrecto, Las cuentas corriente contienen los dígitos '101' o '103' o '100' o '102' en la posición resaltada, en lugar de '" & txtNumeroCuenta.Text.Substring(4, 3) & "'"
        '            lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= " & txtNumeroCuenta.Text.Substring(0, 4) & "<span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta.Text.Substring(4, 3) & "</span>" & txtNumeroCuenta.Text.Substring(7, 7) & "</div>"
        '            Return False
        '        End If
        '    Else
        '        If Not txtNumeroCuenta.Text.Substring(4, 3) = "200" And Not txtNumeroCuenta.Text.Substring(4, 3) = "500" Then
        '            lblMensaje.Text = "Formato incorrecto, Las cuentas de ahorro contienen los dígitos  '200' o '500' en la posición resaltada, en lugar de " & txtNumeroCuenta.Text.Substring(4, 3)
        '            lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= " & txtNumeroCuenta.Text.Substring(0, 4) & "<span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta.Text.Substring(4, 3) & "</span>" & txtNumeroCuenta.Text.Substring(7, 7) & "</div>"
        '            Return False
        '        End If
        '    End If

        '    'Banco BDI
        '    ElseIf ddlEntidadRecaudadora.SelectedValue = 44 Then
        '        If ddTipo_Cuentas.SelectedValue = 1 Then
        '            If Not txtNumeroCuenta.Text.Substring(0, 3) = "410" And Not txtNumeroCuenta.Text.Substring(0, 3) = "404" _
        '            And Not txtNumeroCuenta.Text.Substring(0, 3) = "406" And Not txtNumeroCuenta.Text.Substring(0, 3) = "409" Then
        '            lblMensaje.Text = "Formato incorrecto, Las cuentas corriente contienen los dígitos '410' o '404' o '406' o '409' en la posición resaltada, en lugar de '" & txtNumeroCuenta.Text.Substring(0, 3) & "'"
        '                lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= <span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta.Text.Substring(0, 3) & "</span>" & txtNumeroCuenta.Text.Substring(3, 7) & "</div>"
        '                Return False
        '            End If
        '        Else
        '            If Not txtNumeroCuenta.Text.Substring(0, 3) = "401" And Not txtNumeroCuenta.Text.Substring(0, 3) = "407" Then
        '            lblMensaje.Text = "Formato incorrecto, Las cuentas de ahorro contienen los dígitos '401' o '407' en la posición resaltada, en lugar de '" & txtNumeroCuenta.Text.Substring(0, 3) & "'"
        '                lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= <span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta.Text.Substring(0, 3) & "</span>" & txtNumeroCuenta.Text.Substring(3, 7) & "</div>"
        '                Return False
        '            End If
        '        End If

        '        'Banco Leon
        '    ElseIf ddlEntidadRecaudadora.SelectedValue = 37 Then
        '        If Me.txtNumeroCuenta.Text.Length < 7 Then
        '            ddTipo_Cuentas.SelectedValue = 1
        '        Else
        '            ddTipo_Cuentas.SelectedValue = 2
        '        End If
        '    End If

            Return True

    End Function

    Protected Sub ddTipo_Cuentas_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddTipo_Cuentas.SelectedIndexChanged
        ValidarCuentaBanco()
    End Sub
End Class
