Imports System.IO
Imports System.Windows.Forms

Partial Class Reg_RegUsuarioEmp
    Inherits RegistroEmpresaSeguridad


    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If IsPostBack Then
            If Not ([String].IsNullOrEmpty(txtClave.Text.Trim())) Then
                txtClave.Attributes("value") = txtClave.Text
            End If
            If Not ([String].IsNullOrEmpty(txtClave3.Text.Trim())) Then
                txtClave3.Attributes("value") = txtClave3.Text
            End If
        End If

    End Sub


    Protected Sub radPasaporte_CheckedChanged(sender As Object, e As EventArgs)

        Cedulado.Visible = False
        tblButton.Visible = True
        tblmensaje.Visible = False

    End Sub

    Protected Sub radCedula_CheckedChanged(sender As Object, e As EventArgs)

        Cedulado.Visible = True
        tblButton.Visible = True

    End Sub

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        Response.Redirect("RegUsuarioEmp.aspx")
    End Sub

    Sub Limpiar()

        'Para la tabla de Cedula
        txtDocumento.Text = String.Empty
        txtClave.Text = String.Empty
        txtTelefono1.Text = String.Empty
        txtTelefono2.Text = String.Empty
        lblNombreCiudadano.Text = String.Empty
        txtNombre.Text = String.Empty
        txtApellido.Text = String.Empty
        txtEmail1.Text = String.Empty
        txtClave3.Text = String.Empty



    End Sub

    Protected Sub btnAceptar_Click(sender As Object, e As EventArgs) Handles btnAceptar.Click

        If ValidarLupa.Value <> 1 Then
            lblMensaje.Text = "Debe validar nro. de documento."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return

        End If

        If txtEmail1.Text = String.Empty Then
            lblMensaje.Text = "Digite la cuenta de correo electrónico."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True

            Return
        End If
        If txtClave.Text = String.Empty Then
            lblMensaje.Text = "Debe introducir una contraseña para continuar."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return
        End If

        If txtClave3.Text = String.Empty Then
            lblMensaje.Text = "Debe confirmar la contraseña."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return
        End If

        If txtClave.Text.Length < 6 Then
            lblMensaje.Text = "Su contraseña debe contener minimo 6 caracteres."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return
        End If

        If txtClave3.Text.Length < 6 Then
            lblMensaje.Text = "Su contraseña debe contener minimo 6 caracteres."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return
        End If

        If txtClave.Text.Length > 32 Then
            lblMensaje.Text = "Su contraseña no debe contener mas de 32 caracteres."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return
        End If

        If txtClave3.Text.Length > 32 Then
            lblMensaje.Text = "Su contraseña debe contener minimo 6 caracteres."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return
        End If

        If txtClave.Text <> txtClave3.Text Then
            lblMensaje.Text = "Sus contraseñas no coinciden."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return
        End If

        If ddlTipoDocumento.SelectedValue = "C" Then
            If txtDocumento.Text = String.Empty Then
                lblMensaje.Text = "Digite un número de documento para validar."
                lblMensaje.CssClass = "error"
                tblmensaje.Visible = True
                Return
            End If

        End If

        If ddlTipoDocumento.SelectedValue = "P" Then

            If txtDocumento.Text = String.Empty Then
                lblMensaje.Text = "Digite un número de documento para validar."
                lblMensaje.CssClass = "error"
                tblmensaje.Visible = True
                Return
            End If


            If PasaporteValidar.Value = "Incompleto" Then
                If txtNombre.Text = String.Empty Then
                    lblMensaje.Text = "Debe introducir el Nombre del ciudadano."
                    lblMensaje.CssClass = "error"
                    tblmensaje.Visible = True
                    Return

                End If

                If txtApellido.Text = String.Empty Then
                    lblMensaje.Text = "Debe introducir el Apellido del ciudadano."
                    lblMensaje.CssClass = "error"
                    tblmensaje.Visible = True
                    Return
                End If
            End If

        End If


        If txtTelefono1.Text = String.Empty Then
            lblMensaje.Text = "Debe digitar ambos números telefónicos."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True

            Return
        End If

        If txtTelefono2.Text = String.Empty Then
            lblMensaje.Text = "Debe digital ambos números telefónicos."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True

            Return
        End If

        Dim resultado2 As String
        resultado2 = SuirPlus.SolicitudesEnLinea.Solicitudes.isValidarUsuarioReg(txtEmail1.Text)
        If resultado2 = "0" Then
            lblMensaje.Text = "El Nombre de usuario que está registrando (email) ya existe en nuestra base de datos."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            Return
        End If

        Dim resultado1 As String
        resultado1 = SuirPlus.SolicitudesEnLinea.Solicitudes.isValidarUsuarioReg2(txtDocumento.Text)
        If resultado1 = "0" Then
            lblMensaje.Text = "El nro. de documento del usuario que está registrando, ya existe en nuestra base de datos."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            
            Return
        End If

        lblMensaje.Text = SuirPlus.Seguridad.Usuario.CrearUsuarioExterno(txtDocumento.Text, ddlTipoDocumento.SelectedValue, txtClave.Text, txtNombre.Text, txtApellido.Text, txtEmail1.Text, "I", "OPERACIONES")
        tblmensaje.Visible = True
        lblMensaje.CssClass = "error"

        If lblMensaje.Text = "0" Then
            txtClave.Attributes("value") = String.Empty
            txtClave3.Attributes("value") = String.Empty

            Dim resultado As String
            Dim valor As String
            resultado = SuirPlus.SolicitudesEnLinea.Solicitudes.ConfirmarEmailRegEmp(txtDocumento.Text, txtEmail1.Text, Nothing, "A")

            valor = Split(resultado, "|")(0)
            If valor = "0" Then
                lblMensaje.Text = "Se le ha enviado un correo electrónico para completar el proceso de activación de su cuenta, favor revisar en su correo."
                Me.Todo.Visible = False
            End If

            lblMensaje.CssClass = "label-Blue"
            HttpContext.Current.Session("UserName") = txtDocumento.Text
            HttpContext.Current.Session("Estatus") = 1
            Limpiar()

        End If


    End Sub

    Sub ActivarControles()
        txtClave.Enabled = True

        txtTelefono1.Enabled = True
        txtTelefono2.Enabled = True



    End Sub

    Sub ActivarContPasaporte()



    End Sub

    Protected Sub ImgDocumento_Click(sender As Object, e As ImageClickEventArgs) Handles ImgDocumento.Click
        lblMensaje.Text = String.Empty
        lblNombreCiudadano.Text = String.Empty

        If ddlTipoDocumento.SelectedValue = "C" Then
            If txtDocumento.Text.Length = 11 Then
                Dim Resultado = SuirPlus.Utilitarios.TSS.existeCiudadano("C", txtDocumento.Text)
                If Resultado = False Then
                    lblMensaje.Text = "Cédula de ciudadano inválida, favor verificar"
                    tblmensaje.Visible = True
                Else

                    lblNombreCiudadano.Text = SuirPlus.Utilitarios.TSS.getNombreCiudadano("C", txtDocumento.Text)
                    tblmensaje.Visible = False
                    ActivarControles()
                    ImgDocumento.Visible = False
                    txtDocumento.ReadOnly = True

                    Me.ddlTipoDocumento.Visible = False
                    txtDocumento.Visible = False

                    ValidarLupa.Value = "1"

                End If

            ElseIf txtDocumento.Text = String.Empty Then
                tblmensaje.Visible = False
            Else
                lblMensaje.Text = "Cédula debe constar de 11 caracteres, favor verificar"
                tblmensaje.Visible = True
            End If
        End If

        If ddlTipoDocumento.SelectedValue = "P" Then
            BuscarPasaporte()
        End If





    End Sub

    Sub BuscarPasaporte()


        Dim Resultado = SuirPlus.SolicitudesEnLinea.Solicitudes.isValidarUsuarioReg(txtDocumento.Text)
        If txtDocumento.Text.Length = 0 Then
            lblMensaje.Text = "Debe introducir un Nro. de Pasaporte."
        End If

        Dim resultado2 As String
        resultado2 = SuirPlus.SolicitudesEnLinea.Solicitudes.isValidarUsuarioReg(txtEmail1.Text)
        If resultado2 = "0" Then
            lblMensaje.Text = "El Nombre de usuario que está registrando (email) ya existe en nuestra base de datos."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
            
            Return
        End If

        Dim resultado1 As String
        resultado1 = SuirPlus.SolicitudesEnLinea.Solicitudes.isValidarUsuarioReg2(txtDocumento.Text)
        If resultado1 = "0" Then
            lblMensaje.Text = "El nro. de documento del usuario que está registrando, ya existe en nuestra base de datos."
            lblMensaje.CssClass = "error"
            tblmensaje.Visible = True
           
            Return
        End If


        Dim NombrePasaporte = SuirPlus.Utilitarios.TSS.getNombreCiudadano("P", txtDocumento.Text)


        If NombrePasaporte.Split("|")(0) <> "104" Then

            lblNombreCiudadano.Text = NombrePasaporte
            PasaporteValidar.Value = "Completo"
            tblmensaje.Visible = False
            ImgDocumento.Visible = False
            ActivarContPasaporte()
            txtDocumento.ReadOnly = True
            ValidarLupa.Value = "1"
        Else
            lblNombreCiudadano.Text = "Pasaporte no está registrado en nuestra base de datos, complete los siguientes campos."
            ActivarContPasaporte()
            liApellido.Visible = True
            liNombre.Visible = True
            PasaporteValidar.Value = "Incompleto"
            lblNombreCiudadano.Enabled = False
            txtDocumento.ReadOnly = True
            ImgDocumento.Visible = False
            ValidarLupa.Value = "1"
            Return
        End If

    End Sub

End Class
