Imports SuirPlus
Imports SuirPlus.SolicitudesEnLinea
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios

Partial Class sys_SolicitudInformacion
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Put user code to initialize the page here
        ' Me.pnlConsulta.Visible = True
    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        'Me.btnConsultar.Visible = True
        Response.Redirect("SolicitudInformacion.aspx")
    End Sub

    Private Sub btnEnviar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnEnviar.Click

        Dim NumeroSolicitud As String
        Dim valor1 As String
        Dim valor2 As String
        Dim cblValor As String = String.Empty
        Dim Comentario As String

        If txtNombreCompleto.Text = String.Empty Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "El nombre completo del solicitante es requerido"
            Exit Sub
        End If
        If Me.ctrlTelefono.PhoneNumber = String.Empty Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "El Número de teléfono es requerido"
            Exit Sub
        End If

        If txtinfosolicitada.Text = String.Empty Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "La información solicitada es requerida"
            Exit Sub
        End If

        If txtMotivo.Text = String.Empty Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "El motivo es requerido"
            Exit Sub
        End If

        If cblMedio.SelectedValue = Nothing Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "El medio para recibir la información es requerido"
            Exit Sub
        Else
            Dim contador As Integer = 0
            For Each item As ListItem In cblMedio.Items
                If item.Selected Then
                    contador = contador + 1
                    If contador > 1 Then
                        cblValor += ", " + item.Value
                    Else
                        cblValor += item.Value
                    End If
                End If
            Next
        End If
        Comentario = "Solicitado por www.tss.gov.do"

        Try

            NumeroSolicitud = SuirPlus.SolicitudesEnLinea.Solicitudes.crearSolicitudInformacion(txtNombreCompleto.Text, txtNroDocumento.Text, Me.txtDireccion.Text, Me.ctrlTelefono.PhoneNumber.Replace("-", ""),
                                                                                                Me.ctrlCelular.PhoneNumber.Replace("-", ""), Me.ctrlFax.PhoneNumber.Replace("-", ""), txtEmail.Text,
                                                                                                Me.txtInstitucion.Text, String.Empty, Me.txtinfosolicitada.Text, Me.txtMotivo.Text, txtAutoridad.Text, cblValor, txtLugar.Text, Comentario, "")


            Dim Res As String()
            Res = NumeroSolicitud.Split("|")
            valor1 = Res(0)
            valor2 = Res(1)

            If valor1 = "0" Then
                'Me.ClientScript.RegisterStartupScript(Me.GetType, "", "<script language javascript>window.showModalDialog('SolicitudCreada.aspx?id=" & valor2 & "')</script>")

                'Verificamos si ya el script esta registrado, de lo contrario lo agregamos.
                Dim popupScript As String = "<script language=""javascript"">"
                popupScript += "window.open('SolicitudCreada.aspx?id=" & valor2 & "', 'Argumento1', " + "'height: 400px; width: 500px; top: 200px; center: yes;').print();"
                popupScript += "</script>"
                Me.ClientScript.RegisterStartupScript(Me.GetType(), "PopupScript", popupScript)

                Me.lblMensaje.Visible = False
                ' Me.pnlConsulta.Visible = True
                txtNombreCompleto.Text = String.Empty
                txtNroDocumento.Text = String.Empty
                txtDireccion.Text = String.Empty
                ctrlTelefono.PhoneNumber = String.Empty
                ctrlCelular.PhoneNumber = String.Empty
                ctrlFax.PhoneNumber = String.Empty
                txtEmail.Text = String.Empty
                txtInstitucion.Text = String.Empty
                'txtCargo.Text = String.Empty
                txtinfosolicitada.Text = String.Empty
                txtMotivo.Text = String.Empty
                txtAutoridad.Text = String.Empty
                cblMedio.SelectedValue = Nothing
                txtLugar.Text = String.Empty
                Return
            Else
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = valor2
            End If

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB("Error creando la solicitud... 0.crearSolPage -| " + ex.ToString())
            Response.Redirect("error.aspx?errMsg=" & ex.Message)

        End Try
    End Sub

End Class
