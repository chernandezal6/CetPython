Partial Class Empleador_consNomina
    Inherits BasePage

    Protected viewCCC As String = String.Empty

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        viewCCC = Request("viewCCC")

        If viewCCC = "CedCan" Then

            Me.ctrlTrabajadoresCedCancelada.Visible = False
            Me.ctrlDependientesAdicionales.Visible = False

        ElseIf viewCCC = "DetDep" Then

            Me.ctrlNomina.Visible = False
            Me.ctrlTrabajadoresCedCancelada.Visible = False

        ElseIf viewCCC = "DetNom" Then

            Me.ctrlTrabajadoresCedCancelada.Visible = False
            Me.ctrlDependientesAdicionales.Visible = False

        End If

    End Sub

End Class
