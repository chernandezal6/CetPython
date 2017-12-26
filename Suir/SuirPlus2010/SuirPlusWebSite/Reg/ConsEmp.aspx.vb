Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios
Imports System.Data
Imports System.IO


Partial Class Reg_ConsEmp
    Inherits System.Web.UI.Page

    Dim dt As New DataTable

    Protected Sub btnAceptar_Click(sender As Object, e As EventArgs) Handles btnAceptar.Click

        If String.IsNullOrEmpty(Me.txtNroSol.Text) Then
            Me.lblMsg.Text = "Debe Digitar el Código de Solicitud."
            Me.lblMsg.Visible = True
        End If
        If Me.Session("ConsOK") <> "valido" Then
            Me.lblMsg.Text = "Debe Digitar el Código del capcha."
            Me.lblMsg.Visible = True
        End If
        If recaptcha.IsValid Then
            Me.lblMsg.Text = String.Empty
            bindGrid()
            recaptcha.Visible = False
        End If

    End Sub

    Protected Sub bindGrid()

        Dim tmpDT As DataTable = Nothing
        Dim Nro_Solicitud As String = Nothing
        Dim result As String = Nothing

        If Not String.IsNullOrEmpty(Me.txtNroSol.Text) Then

        End If


        tmpDT = SolicitudesEnLinea.Solicitudes.getHistoricosolicitud(Me.txtNroSol.Text, result)

        If tmpDT.Rows.Count > 0 Then

            Me.gvDetalle.DataSource = tmpDT
            Me.gvDetalle.DataBind()
            Me.gvDetalle.Visible = True

        Else
            lblMsg.Text = "Código de Solicitud invalido."
            lblMsg.Visible = True

        End If

    End Sub

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        Me.txtNroSol.Text = String.Empty
        Me.gvDetalle.Visible = False
        lblMsg.Text = String.Empty
        lblMsg.Visible = False
        recaptcha.Visible = True
    End Sub
End Class
