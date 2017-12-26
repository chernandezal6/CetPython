Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.SubsidiosSFS
Imports SuirPlus.Empresas.SubsidiosSFS.Maternidad

Partial Class Novedades_sfsCambioCuentaTutor
    Inherits BasePage
    Protected empleado As Trabajador
    Protected madre As Maternidad
    Protected tutor As Tutor
  
    Private Property idCiudadano() As String
        Get
            Return CType(viewstate("idCiudadano"), String)
        End Get
        Set(ByVal Value As String)
            viewstate("idCiudadano") = Value
        End Set
    End Property
    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        lblMsg.Text = String.Empty
        lblMsgTutor.Text = String.Empty
        Me.idCiudadano = Me.txtCedulaNSS.Text
        Try
            Dim mensaje As String = ValidarCambioCuentaTutor(txtCedulaNSS.Text, UsrRegistroPatronal)

            If mensaje.Equals("OK") Then
                lblMsg.Text = String.Empty

                If idCiudadano.Length < 11 Then
                    empleado = New Trabajador(Convert.ToInt32(idCiudadano))
                ElseIf idCiudadano.Length = 11 Then
                    empleado = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, idCiudadano)
                End If

                Me.errorSta.Visible = False
                Me.errorG.Visible = False
                Me.errorSexo.Visible = False
                Me.divConsulta.Visible = True
                Me.Table2.Visible = True
                Me.txtCedTutor.Focus()
                Me.txtCedulaNSS.ReadOnly = True

                Me.txtCedulaNSS.ReadOnly = True

                UcEmpleado.NombreEmpleado = String.Concat(empleado.Nombres, " ", empleado.PrimerApellido, " ", empleado.SegundoApellido)
                UcEmpleado.NSS = empleado.NSS.ToString
                UcEmpleado.Cedula = empleado.Documento
                UcEmpleado.Sexo = empleado.Sexo
                UcEmpleado.FechaNacimiento = empleado.FechaNacimiento
                UcEmpleado.SexoEmpleado = "Empleada"

            Else
                lblMsg.Text = mensaje

                Me.divConsulta.Visible = False
                Me.fiedlsetDatos.Visible = False

            End If

        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            Me.divConsulta.Visible = False
            Me.fiedlsetDatos.Visible = False
            Me.errorG.Visible = False
            Me.errorSexo.Visible = False
            Me.errorSta.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())

        End Try

    End Sub
    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Me.errorG.Visible = False
        Dim m As String = String.Empty

        Try
            m = CambioCuentaTutor(Me.idCiudadano, Me.txtCedTutor.Text, Me.txtCuenta.Text, Me.txtComentario.Text, Me.UsrUserName)

            Select Case m
                Case "OK"
                    Me.errorG.Visible = False
                    Me.errorSexo.Visible = False
                    Me.Table2.Visible = False
                    Me.divConsulta.Visible = False
                    Me.divConsultaTutor.Visible = False
                    Me.fiedlsetDatos.Visible = False
                    Me.txtCedulaNSS.Text = String.Empty
                    Me.txtCuenta.Text = String.Empty
                    Me.txtCedTutor.Text = String.Empty
                    Me.txtCedTutor.ReadOnly = False
                    Me.txtCedulaNSS.ReadOnly = False
                    Me.txtCedulaNSS.Focus()
                    Me.txtComentario.Text = String.Empty
                    Me.lblMsg.Text = "Se aplico el cambio de cuenta correctamente."

                Case Else
                    Me.errorG.Visible = True
                    Me.errorG.InnerText = m

            End Select

        Catch ex As Exception
            Me.errorG.Visible = True
            Me.errorG.InnerText = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        lblMsgTutor.Text = String.Empty
        Try
            Dim mensaje As String = ValidarTutorCuenta(txtCedulaNSS.Text, txtCedTutor.Text)

            If mensaje.Equals("OK") Then

                If txtCedulaNSS.Text.Length < 11 Then
                    madre = New Maternidad(Convert.ToInt32(txtCedulaNSS.Text))
                ElseIf txtCedulaNSS.Text.Length = 11 Then
                    madre = New Maternidad(txtCedulaNSS.Text)
                End If

                Me.divConsultaTutor.Visible = True
                Me.fiedlsetDatos.Visible = True
                Me.nombreTutor.InnerText = madre.getTutorActivo(0)(2).ToString()
                Me.cedTutor.InnerText = madre.getTutorActivo(0)(3).ToString()
                Me.lblNumCuentaActual.Text = madre.getTutorActivo(0)(9).ToString()
                Me.errorG.Visible = False
                Me.txtCedTutor.ReadOnly = True

            Else
                lblMsgTutor.Text = mensaje

            End If
        Catch ex As Exception
            lblMsg.Text = ex.Message
            Me.divConsulta.Visible = False
            Me.fiedlsetDatos.Visible = False
        End Try


    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.txtCedulaNSS.Focus()
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Me.txtCedTutor.Text = String.Empty
        Me.txtCedTutor.ReadOnly = False
        Me.errorG.Visible = False
        Me.txtCedTutor.Focus()
        Me.fiedlsetDatos.Visible = False
        Me.divConsultaTutor.Visible = False
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.errorG.Visible = False
        Me.errorSexo.Visible = False
        Me.errorSta.Visible = False
        Me.Table2.Visible = False
        Me.divConsulta.Visible = False
        Me.divConsultaTutor.Visible = False
        Me.fiedlsetDatos.Visible = False
        Me.txtCedulaNSS.Text = String.Empty
        Me.txtCedTutor.Text = String.Empty
        Me.txtCuenta.Text = String.Empty
        Me.txtCedulaNSS.ReadOnly = False
        Me.txtCedTutor.ReadOnly = False
        Me.txtCedulaNSS.Focus()
        lblMsg.Text = String.Empty
    End Sub

    Protected Sub btnCancelar1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar1.Click
        Me.txtCuenta.Text = String.Empty
        Me.txtCuenta.Focus()
    End Sub
  
End Class
