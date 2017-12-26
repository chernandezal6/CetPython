''' <summary>
''' Objecto para manejar el detalle del archivo de concentracion de aportes
''' </summary>
''' <remarks></remarks>
Partial Public Class Detalle
    Private _fechasolicitud As String
    Private _tipoinstruccion As String
    Private _importe_instruccion As Decimal
    Private _cuenta_origen As String
    Private _cuenta_destino As String
    Private _tipo_entidad_destino As Int32
    Private _entidad_destino As Int32
    Private _tipo_entidad_origen As Int32
    Private _entidad_origen As Int32
    Public Sub New()

    End Sub
    Public Sub New(ByVal fechasolicitud As String, ByVal tipoinstruccion As String, ByVal montoinstruccion As Decimal, ByVal cuentaorigen As String, _
                   ByVal cuentadestino As String, ByVal tipoentidaddestino As Int32, ByVal entidaddestino As Int32, ByVal tipoentidadorigen As Int32, ByVal entidadorigen As Int32)
        Me.FechaSolicutud = fechasolicitud
        Me.Tipo_Instruccion = tipoinstruccion
        Me.Importe_Instruccion = montoinstruccion
        Me.Cuenta_Origen = cuentaorigen
        Me.Cuenta_Destino = cuentadestino
        Me.Tipo_Entidad_Origen = tipoentidadorigen
        Me.Tipo_Entidad_Destino = tipoentidaddestino
        Me.Entidad_Destino = entidaddestino
        Me.Entidad_Origen = Entidad_Origen
    End Sub
    Public Property FechaSolicutud() As String
        Get
            Return _fechasolicitud
        End Get
        Set(ByVal value As String)
            _fechasolicitud = value
        End Set
    End Property
    Public Property Tipo_Instruccion() As String
        Get
            Return _tipoinstruccion
        End Get
        Set(ByVal value As String)
            _tipoinstruccion = value
        End Set
    End Property
    Public Property Importe_Instruccion() As Decimal
        Get
            Return _importe_instruccion
        End Get
        Set(ByVal value As Decimal)
            _importe_instruccion = value
        End Set
    End Property
    Public Property Cuenta_Origen() As String
        Get
            Return _cuenta_origen
        End Get
        Set(ByVal value As String)
            _cuenta_origen = value
        End Set
    End Property
    Public Property Cuenta_Destino() As String
        Get
            Return _cuenta_destino
        End Get
        Set(ByVal value As String)
            _cuenta_destino = value
        End Set
    End Property
    Public Property Tipo_Entidad_Destino() As Int32
        Get
            Return _tipo_entidad_destino
        End Get
        Set(ByVal value As Int32)
            _tipo_entidad_destino = value
        End Set
    End Property
    Public Property Entidad_Destino() As Int32
        Get
            Return _entidad_destino
        End Get
        Set(ByVal value As Int32)
            _entidad_destino = value
        End Set
    End Property
    Public Property Tipo_Entidad_Origen() As Int32
        Get
            Return _tipo_entidad_origen
        End Get
        Set(ByVal value As Int32)
            _tipo_entidad_origen = value
        End Set
    End Property
    Public Property Entidad_Origen() As Int32
        Get
            Return _entidad_origen
        End Get
        Set(ByVal value As Int32)
            _entidad_origen = value
        End Set
    End Property
End Class
