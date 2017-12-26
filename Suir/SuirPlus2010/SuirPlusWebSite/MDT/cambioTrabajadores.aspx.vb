
Partial Class MDT_cambioTrabajadores
    Inherits BasePage

    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load
        Dim pagaMDT As Boolean

        If UsrRegistroPatronal <> String.Empty Then
            Dim emp As New SuirPlus.Empresas.Empleador(CInt(UsrRegistroPatronal))
            ucNovedadesPendientes1.RegistroPatronal = CInt(UsrRegistroPatronal)
            ucNovedadesPendientes1.usrUsernameControl = UsrUserName

            pagaMDT = emp.PagaMDT
            If Not pagaMDT Then
                Response.Redirect("../Empleador/consNotificaciones.aspx")
            End If

        Else
            Response.Redirect("../Empleador/consNotificaciones.aspx")

        End If
    End Sub
End Class
