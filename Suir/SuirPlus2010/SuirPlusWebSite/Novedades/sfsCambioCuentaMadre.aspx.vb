Imports SuirPlus
Imports SuirPlus.Utilitarios
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.SubsidiosSFS
Imports SuirPlus.Empresas.SubsidiosSFS.Maternidad

Partial Class Novedades_sfsCambioCuentaMadre
    Inherits BasePage

#Region "Variables"
    Protected empleado As Trabajador
    Protected madre As Maternidad

    Private Property idCiudadano() As String
        Get
            Return CType(ViewState("idCiudadano"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("idCiudadano") = Value
        End Set
    End Property
#End Region

#Region "Funciones"
    Private Sub clearControls()
        Me.divConsulta.Visible = False
        Me.fiedlsetDatos.Visible = False
        Me.dInfoActual.Visible = False
        Me.txtComentario.Text = String.Empty
        txtCedulaNSS.Text = ""
        Me.tbNumCuenta.Text = ""
        Me.txtCedulaNSS.Focus()
        Me.txtCedulaNSS.Enabled = True
        lblMsg.Text = String.Empty
    End Sub

#End Region

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        lblMsg.Text = String.Empty
        Me.idCiudadano = Me.txtCedulaNSS.Text

        Try
            Dim mensaje As String = ValidarCambioCuentaTutor(txtCedulaNSS.Text, UsrRegistroPatronal)

            If mensaje.Equals("OK") Then
                lblMsg.Text = String.Empty

                If idCiudadano.Length < 11 Then
                    empleado = New Trabajador(Convert.ToInt32(idCiudadano))
                    madre = New Maternidad(Convert.ToInt32(idCiudadano))
                ElseIf idCiudadano.Length = 11 Then
                    empleado = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, idCiudadano)
                    madre = New Maternidad(idCiudadano)
                End If

                lblNumCuentaActual.Text = madre.CuentaBanco

                Me.divConsulta.Visible = True
                Me.fiedlsetDatos.Visible = True
                Me.dInfoActual.Visible = Not madre.CuentaBanco.Equals(String.Empty)

                Me.txtCedulaNSS.ReadOnly = True

                ucInfoEmpleado1.NombreEmpleado = String.Concat(empleado.Nombres, " ", empleado.PrimerApellido, " ", empleado.SegundoApellido)
                ucInfoEmpleado1.NSS = empleado.NSS.ToString
                ucInfoEmpleado1.Cedula = empleado.Documento
                ucInfoEmpleado1.Sexo = empleado.Sexo
                ucInfoEmpleado1.FechaNacimiento = empleado.FechaNacimiento
                ucInfoEmpleado1.SexoEmpleado = "Empleada"

            Else
                lblMsg.Text = mensaje

                Me.dInfoActual.Visible = False
                Me.divConsulta.Visible = False
                Me.fiedlsetDatos.Visible = False

            End If

        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            Me.divConsulta.Visible = False
            Me.fiedlsetDatos.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.clearControls()
    End Sub

    Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGuardar.Click
        Dim m As String = String.Empty
        Try
            m = CambioCuentaMadre(txtCedulaNSS.Text, tbNumCuenta.Text, Me.txtComentario.Text, Me.UsrUserName)

            Select Case m
                Case "OK"
                    Me.lblMsg.Text = "Se aplico el cambio de cuenta correctamente."
                    Me.txtComentario.Text = String.Empty
                    txtCedulaNSS.Text = String.Empty
                    Me.tbNumCuenta.Text = String.Empty
                    txtNumeroCuenta2.Text = String.Empty
                    Me.txtCedulaNSS.Focus()
                    Me.txtCedulaNSS.Enabled = True
                Case Else
                    Me.lblMsg.Text = m
            End Select

        Catch ex As Exception
            lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.txtCedulaNSS.Focus()
    End Sub
    
End Class
