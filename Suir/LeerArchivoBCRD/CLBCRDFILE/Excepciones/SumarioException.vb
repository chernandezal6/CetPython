
Friend Class SumarioException
    Inherits Exception
    Friend Sub New(ByVal message As String)
        MyBase.New(message)
    End Sub
End Class
Friend Class DetalleException
    Inherits Exception
    Friend Sub New(ByVal message As String)
        MyBase.New(message)
    End Sub
End Class
Friend Class EncabezadoException
    Inherits Exception
    Friend Sub New(ByVal message As String)
        MyBase.New(message)
    End Sub
End Class
Friend Class ExceptionConcentracionFondos
    Inherits Exception
    Friend Sub New(ByVal Mensaje As String)
        MyBase.New(Mensaje)
    End Sub
End Class
Friend Class ExceptionLiquidacionFondos
    Inherits Exception
    Friend Sub New(ByVal Mensaje As String)
        MyBase.New(Mensaje)
    End Sub
End Class
