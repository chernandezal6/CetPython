''' <summary>
''' Objecto para manejar el sumario del archico de Concentracion de Aportes.
''' </summary>
''' <remarks></remarks>
Partial Public Class Sumario
    Private _numero_registros As Int32
    Private _total_liquidar_ajuste As Decimal
    Private _monto_aclarado As Decimal
    Private _total_ajuste As Decimal
    Private _total_liquidar As Decimal
    Public Sub New()

    End Sub
    Public Sub New(ByVal numeroregistros As Int32, ByVal total_liquidar_ajuste As Decimal, ByVal monto_aclarado As Decimal, ByVal total_ajuste As Decimal, ByVal total_liquidar As Decimal)
        Me.Numero_Registros = numeroregistros
        Me.Total_Liquidar_Ajuste = total_liquidar_ajuste
        Me.Monto_Aclarado = monto_aclarado
        Me.Total_Ajuste = total_ajuste
        Me.Total_Liquidar = total_liquidar
    End Sub
    Public Property Numero_Registros() As Int32
        Get
            Return _numero_registros
        End Get
        Set(ByVal value As Int32)
            _numero_registros = value
        End Set
    End Property
    Public Property Total_Liquidar_Ajuste() As Decimal
        Get
            Return _total_liquidar_ajuste
        End Get
        Set(ByVal value As Decimal)
            _total_liquidar_ajuste = value
        End Set
    End Property
    Public Property Monto_Aclarado() As Decimal
        Get
            Return _monto_aclarado
        End Get
        Set(ByVal value As Decimal)
            _monto_aclarado = value
        End Set
    End Property
    Public Property Total_Ajuste() As Decimal
        Get
            Return _total_ajuste
        End Get
        Set(ByVal value As Decimal)
            _total_ajuste = value
        End Set
    End Property
    Public Property Total_Liquidar() As Decimal
        Get
            Return _total_liquidar
        End Get
        Set(ByVal value As Decimal)
            _total_liquidar = value
        End Set
    End Property
End Class
