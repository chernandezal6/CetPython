Imports System
Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios
Imports System.Data
Imports System.IO
Imports System.Linq

Partial Class SuirPlusOficinaVirtual
    Inherits System.Web.UI.MasterPage

    Dim ofvBasePage As New SeguridadOFV

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim path As String = Request.Path
        '   Dim nro_documento As String
        ' nro_documento = Request.QueryString("nro_documento")
        NoDocumento.Value = ofvBasePage.UserNameOFV


        If path.Contains("/Oficina_Virtual/OficinaVirtual") Or path.Contains("/Oficina_Virtual/ConsOficinaVirtual") Then
            If Me.ChangePassword(ofvBasePage.UserNameOFV) = True Then
                Response.Redirect("/Oficina_Virtual/CambiarcontraseñaOFV.aspx")
            End If
            GetNombreUsuario(ofvBasePage.UserNameOFV)
            divCerrarSesion.Visible = True
            'lnkCambiarPass.Visible = True
            lnkSignOut.Visible = True

        Else
            'lnkCambiarPass.Visible = False
            lnkSignOut.Visible = False
        End If


    End Sub

    Protected Sub GetNombreUsuario(documento As String)
        Dim res As New DataTable
        Dim tipo_documento As String

        If documento.Length < 11 Then
            tipo_documento = "N"
        Else
            tipo_documento = "C"
        End If

        Try
            res = SuirPlus.OficinaVirtual.OficinaVirtual.getCiudadanoValidoOFC(documento, tipo_documento)

            If res.Rows.Count > 0 Then
                lblBienvenido.Visible = True
                lblBienvenido.Text = "Bienvenido(a):" & " " & res.Rows(0)("NOMBRE_COMPLETO").ToString
            End If
        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message.ToString
        End Try
    End Sub

    Protected Sub lnkSignOut_Click(sender As Object, e As EventArgs) Handles lnkSignOut.Click
        System.Web.Security.FormsAuthentication.SignOut()
        Session.Abandon()
        Response.Redirect("LoginOficinaVirtual.aspx")
    End Sub

    'Para saber si un usuario necesita cambiar la clave debido al reseteo entonces le redirecciona a la pantalla de cambiar clave.
    Protected Function ChangePassword(documento As String) As Boolean
        Dim ChangePass As String

        Try
            ChangePass = OficinaVirtual.OficinaVirtual.CambiarClassUserOFV(documento, "", "")
            If ChangePass = "S" Then
                Return True
            End If
        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message.ToString
        End Try
        Return False
    End Function

End Class

