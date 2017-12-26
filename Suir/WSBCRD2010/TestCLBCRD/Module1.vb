Imports CLBCRD

Module Module1

    Sub Main()

        Dim m As New BLArchivoXML()
        Console.WriteLine("====================================================================")
        Console.WriteLine("                   Iniciando el proceso")
        Console.WriteLine("====================================================================")

        ' m.ProcesarArchivos()

        m.EnviarCorreo()

        'Console.WriteLine("Proceso terminado, presione cualquier tecla para salir")
        'Console.ReadLine()

        '' VB
        'Dim b As Nullable(Of Boolean) = Nothing

        'If b.HasValue Then
        'Console.WriteLine("b is {0}.", b.Value)
        'Else
        'Console.WriteLine("b is not set.")
        'End If

        'Dim result = String.Empty
        'Dim dt = New DataTable
        'dt = SuirPlus.Utilitarios.TSS.getconsultaCiudadanoAct("C", "00116490806", result)

        'For Each dr As DataRow In dt.Rows
        'Console.WriteLine("{0}, {1}", dr.Field(Of String)("Nombres"), dr.Field(Of String)("Primer_Apellido"))
        'Next
        'Console.ReadLine()

    End Sub
End Module
