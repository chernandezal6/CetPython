''' <summary>
''' Objecto para manejar el encabezado del archivo de Concentracion de aportes
''' </summary>
''' <remarks></remarks>
Partial Public Class Encabezado
    Inherits Sumario
    Private _nombrearchivo As String
    Private _proceso As String
    Private _subproceso As String
    Private _entidadfondos As String
    Private _fechatransmision As String
    Private _nrolote As String
    Public Sub New()

    End Sub
    Public Sub New(ByVal archivo As String, ByVal proceso As String, ByVal subproceso As String, ByVal entidadreceptora As String, ByVal fechatransmision As String, ByVal nrolote As String)


    End Sub
    Public Property NombreArchivo() As String
        Get
            Return Me._nombrearchivo
        End Get
        Set(ByVal value As String)
            _nombrearchivo = value
        End Set
    End Property
    Public Property Proceso() As String
        Get
            Return Me._proceso
        End Get
        Set(ByVal value As String)
            _proceso = value
        End Set
    End Property
    Public Property SubProceso() As String
        Get
            Return _subproceso
        End Get
        Set(ByVal value As String)
            _subproceso = value
        End Set
    End Property
    Public Property EntidadReceptora() As String
        Get
            Return _entidadfondos
        End Get
        Set(ByVal value As String)
            _entidadfondos = value
        End Set
    End Property
    Public Property FechaTransmision() As String
        Get
            Return _fechatransmision
        End Get
        Set(ByVal value As String)
            _fechatransmision = value
        End Set
    End Property
    Public Property NroLote() As String
        Get
            Return _nrolote
        End Get
        Set(ByVal value As String)
            _nrolote = value
        End Set
    End Property
End Class
