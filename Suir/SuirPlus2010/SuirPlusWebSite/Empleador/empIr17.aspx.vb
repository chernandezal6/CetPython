
Partial Class Empleador_empIr17
    Inherits BasePage


    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        If Not IsPostBack Then

            'Colocando en session temporal el registro patronal del empleador en cuestion 
            'Este dato sera leido en el formulario de IR17
            'Seteando titulo del form
            Me.lblTitulo1.Text = "Formulario IR-17 - período " & SuirPlus.Utilitarios.Utils.FormateaPeriodo(SuirPlus.Utilitarios.Utils.getPeriodoAnterior(SuirPlus.Utilitarios.Utils.getPeriodoActual))

        End If

    End Sub
End Class
