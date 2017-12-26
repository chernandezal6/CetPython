Public Class Form1
    Private c As New CLBCRD.BLArchivoXML

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        c.ProcesarArchivos()
        MsgBox("Proceso terminado")
    End Sub

    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button2.Click
        c.EnviarCorreo()
    End Sub
End Class
