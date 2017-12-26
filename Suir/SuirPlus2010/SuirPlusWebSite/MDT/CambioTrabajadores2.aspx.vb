
Partial Class MDT_CambioTrabajadores2
    Inherits BasePage


    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Dim pagaMDT As Boolean
        divNovedadesPendientes.Visible = True
       
        If UsrRegistroPatronal <> String.Empty Then
            Dim emp As New SuirPlus.Empresas.Empleador(CInt(UsrRegistroPatronal))
            ucNovedadesPendientesaCambiar.RegistroPatronal = CInt(UsrRegistroPatronal)
            ucNovedadesPendientesaCambiar.usrUsernameControl = UsrUserName

            pagaMDT = emp.PagaMDT
            Dim GetData = SuirPlus.MDT.General.getNovedadesPendientesaCambio(CInt(UsrRegistroPatronal))

              If Not pagaMDT Then
                Response.Redirect("../Empleador/consNotificaciones.aspx")
            End If

        Else
            Response.Redirect("../Empleador/consNotificaciones.aspx")

        End If



        'If Page.IsPostBack Then
        '    divNovedadesPendientes.Visible = False
        'End If
    End Sub
    Public Function formateaSalario(ByVal salario As String) As String
        Dim salFormatear As Double
        Dim res As String

        If Not IsNumeric(salario) Then
            Return salario
        Else
            salFormatear = CDbl(salario)
            res = String.Format("{0:c}", salFormatear)
            Return res
        End If
    End Function
  
End Class
