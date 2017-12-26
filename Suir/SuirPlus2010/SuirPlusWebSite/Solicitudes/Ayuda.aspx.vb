
Partial Class Solicitudes_Ayuda
    Inherits BasePage


    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Select Case Request("H")

            Case "1"
                Me.lblInfo.Text = "El número de RNC es el número único que identifica una empresa o negocio y es otorgado por la Dirección General de Impuestos Internos, en el caso de los negocios de único dueño, el número que identifica el negocio es el número de cédula del dueño."
            Case "2"
                Me.lblInfo.Text = "El representante es la persona que representa la empresa o negocio ante la TSS, es la persona encagada de reportar mensualmente los cambios en la nómina (entradas, salidas o cambios de salario)."

        End Select
    End Sub
End Class
