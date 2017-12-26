Imports System.Data
Imports SuirPlus

Partial Class Mantenimientos_updTipoAjuste
    Inherits BasePage
    Private IdTipoAjuste As Integer = 0

    Protected Sub Mantenimientos_updTipoAjuste_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Request.QueryString("IdTipo") <> String.Empty Then
                Session("Id") = CInt(Request.QueryString("IdTipo"))
                CargarTipoAjuste()
            End If

        End If

    End Sub

    Protected Sub CargarTipoAjuste()

        Dim dt As New DataTable

        Dim tipoAjuste As New Mantenimientos.ManejoDeAjustes(CInt(Session("Id")))

        Try
            If tipoAjuste.IdTipoAjuste > 0 Then

                Me.txtDescripcion.Text = tipoAjuste.Descripcion
                Me.txtCuentaOrigen.Text = tipoAjuste.CuentaOrigen
                Me.txtCuentaDestino.Text = tipoAjuste.CuentaDestino
                Me.dlEstatus.SelectedValue = tipoAjuste.Estatus
                Me.dlTipoMovimiento.SelectedValue = tipoAjuste.TipoMovimiento
                
                Me.lblMsg.Visible = False
                Me.lblMsg.Text = String.Empty
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
        End Try

    End Sub

    Protected Sub btnRegresar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRegresar.Click
        Session.Remove("Id")
        Response.Redirect("TipoAjustes.aspx")
    End Sub

    Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGuardar.Click

        Dim result As String

        Try
            result = Mantenimientos.ManejoDeAjustes.actTipoAjuste(CInt(Session("Id")), Me.txtDescripcion.Text, Me.dlTipoMovimiento.SelectedValue, Me.dlEstatus.SelectedValue, CInt(Me.txtCuentaOrigen.Text), CInt(Me.txtCuentaDestino.Text), Me.UsrUserName)
            If result = "0" Then
                Me.lblMsg.Visible = True
                Me.lblMsg.ForeColor = Drawing.Color.Blue
                Me.lblMsg.Text = "Registro Actualizado!!!"
            Else
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = result
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
        End Try

    End Sub
End Class
