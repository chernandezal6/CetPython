
Partial Class sys_SolRecuperacionClave
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Put user code to initialize the page here
    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Me.btnConsultar.Visible = False

        If SuirPlus.SolicitudesEnLinea.Solicitudes.isRepresentanteEnEmpresa(Me.txtRnc.Text, Me.txtCedula.Text) Then
            Dim emp As New SuirPlus.Empresas.Empleador(Me.txtRnc.Text)
            Me.pnlRecuperaClass.Visible = True
            Me.lblMensaje.Visible = False

            Me.lblRazonSocial.Text = emp.RazonSocial
            Me.lblNombreComercial.Text = emp.NombreComercial

            Dim rep As New SuirPlus.Empresas.Representante(Me.txtRnc.Text, Me.txtCedula.Text)

            Me.lblRepresentante.Text = rep.NombreCompleto

        Else
            Me.btnConsultar.Visible = True
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "Error con el RNC o la Cedula del Representante"
            Exit Sub
        End If

    End Sub

    Private Sub btnProcesar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnProcesar.Click

        Dim NumeroSolicitud As String
        Dim valor1 As String
        Dim valor2 As String

        Try
            NumeroSolicitud = SuirPlus.SolicitudesEnLinea.Solicitudes.crearSolicitud(3, 0, Me.txtRnc.Text, Me.txtCedula.Text, "", "Solicitado por www.tss.gov.do")

            Dim Res As String()
            Res = NumeroSolicitud.Split("|")
            valor1 = Res(0)
            valor2 = Res(1)

            If valor1 = "0" Then

                Response.Redirect("SolicitudCreada.aspx?id=" & valor2)

            Else

                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = valor2

            End If
        Catch ex As Exception
            Response.Redirect("error.aspx?errMsg=" & ex.ToString())
        End Try
    End Sub

    Private Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.btnConsultar.Visible = True

        Response.Redirect("SolRecuperacionClave.aspx")
    End Sub
End Class
