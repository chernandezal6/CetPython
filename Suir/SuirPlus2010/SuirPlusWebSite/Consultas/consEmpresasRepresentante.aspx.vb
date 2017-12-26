Imports System.Data
Imports SuirPlus.Empresas

Partial Class Consultas_consEmpresasRepresentante
    Inherits BasePage

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        CargarEmpresasRepresentante(txtCedula.Text)

    End Sub

    Protected Sub CargarEmpresasRepresentante(ByVal cedula As String)
        Try
            Dim dtEmpresasRepresentante As DataTable
            dtEmpresasRepresentante = Representante.getEmpresasRepresentate(cedula)


            If dtEmpresasRepresentante.Rows.Count > 0 Then

                Me.pnlEmpresasRepresentante.Visible = True
                lblNombre.Text = dtEmpresasRepresentante.Rows(0).Item(6).ToString()
                lblNSS.Text = dtEmpresasRepresentante.Rows(0).Item(0).ToString()

                Me.gvEmpresasRepresentante.DataSource = dtEmpresasRepresentante
                Me.gvEmpresasRepresentante.DataBind()
            Else

                Me.pnlEmpresasRepresentante.Visible = False
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "No hay data para mostrar"
                dtEmpresasRepresentante = Nothing

            End If


        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
        End Try
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("consEmpresasRepresentante.aspx")

    End Sub
End Class
