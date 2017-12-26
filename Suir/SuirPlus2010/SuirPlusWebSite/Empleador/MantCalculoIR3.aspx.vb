Imports SuirPlus.Utilitarios

Partial Class Empleador_MantCalculoIR3
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.lblFormError.Text = ""
    End Sub
    Protected Sub btCalculoIR3_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btCalculoIR3.Click
        Try

            Dim StatusIR3 As New SuirPlus.Empresas.Facturacion.ResumenDeclaracionIR13(Utils.getPeriodoIR13, Me.txtRNC.Text)

            If StatusIR3.Status = "Pendiente" Then
                Dim CalcularIR3 = StatusIR3.ReProcesar(Me.txtRNC.Text, Utils.getPeriodoIR13)
                Me.lblFormError.Text = "Proceso Ejecutado Satisfactoriamente"
            Else
                Me.lblFormError.Text = "Calculo realizado previamente."
            End If

        Catch ex As Exception
            Me.lblFormError.Text = "Problemas al ejecutar proceso."
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub


End Class
