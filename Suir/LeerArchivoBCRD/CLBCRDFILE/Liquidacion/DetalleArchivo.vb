Imports Oracle.DataAccess
Imports Oracle.DataAccess.Client
Imports Oracle.DataAccess.Server
Imports Oracle.DataAccess.Types
''' <summary>
''' Objecto para manejar todo el detalle del archivo XML del Banco Central.
''' Fecha: 30/03/2009
''' </summary>
''' <remarks></remarks>
Partial Public Class DetalleArchivo
#Region "Atributos de la clase"
    Private _nombrelote As Int32
    Private _nombrearchivo As String
    Private _nombrebeneficiario As String
    Private _identificacionbeneficiario As String
    Private _montodepositar As Decimal
    Private _numeroctaestandar As String
    Private _tipocuenta As String
    Private _conceptodetallado As String
    Private _informacionadicionalpago01 As String
    Private _informacionadicionalpago02 As String
    Private _digitocontrol As Int32
#End Region
#Region "Propiedades de la clase"
    ''' <summary>
    ''' Numero del Lote
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property NombreLote() As Int32
        Get
            Return _nombrelote
        End Get
        Set(ByVal value As Int32)
            _nombrelote = value
        End Set
    End Property
    ''' <summary>
    ''' Nombre del Archivo.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property NombreArchivo() As String
        Get
            Return _nombrearchivo
        End Get
        Set(ByVal value As String)
            If Not String.IsNullOrEmpty(value) Then
                _nombrearchivo = value
            End If
        End Set
    End Property
    ''' <summary>
    ''' Nombre del beneficiario final.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property NombreBeneficairio() As String
        Get
            Return _nombrebeneficiario
        End Get
        Set(ByVal value As String)
            If Not String.IsNullOrEmpty(value) Then
                _nombrebeneficiario = value
            End If
        End Set
    End Property
    ''' <summary>
    ''' No. de identificación del beneficiario final
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property IdentificacionBeneficiario() As String
        Get
            Return _identificacionbeneficiario
        End Get
        Set(ByVal value As String)
            If Not String.IsNullOrEmpty(value) Then
                _identificacionbeneficiario = value
            End If
        End Set
    End Property
    ''' <summary>
    ''' Monto a depositar en la cuenta del beneficiario final
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property MontoDepositar() As Decimal
        Get
            Return _montodepositar
        End Get
        Set(ByVal value As Decimal)
            If Not String.IsNullOrEmpty(value.ToString) AndAlso value > 0.0 Then
                _montodepositar = value
            End If
        End Set
    End Property
    ''' <summary>
    ''' Cuenta estandarizada del beneficiario final en la Entidad
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property NumeroCuentaEstandar() As String
        Get
            Return _numeroctaestandar
        End Get
        Set(ByVal value As String)
            If Not String.IsNullOrEmpty(value) Then

                _numeroctaestandar = value

            End If
        End Set
    End Property
    ''' <summary>
    ''' Tipo de cuenta del beneficiario final
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property TipoCuenta() As String
        Get
            Return _tipocuenta
        End Get
        Set(ByVal value As String)

            _tipocuenta = value

        End Set
    End Property
    ''' <summary>
    ''' Concepto detallado del Pago
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property ConceptoDetallado() As String
        Get
            Return _conceptodetallado
        End Get
        Set(ByVal value As String)
            If Not String.IsNullOrEmpty(value) Then
                _conceptodetallado = value
            End If
        End Set
    End Property
    ''' <summary>
    ''' Información adicional del Pago individual (opcional). De no incluir informaciones, entonces se debe indicar 'N/A'.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property InformAdicionalPago01() As String
        Get
            Return _informacionadicionalpago01
        End Get
        Set(ByVal value As String)
            If String.IsNullOrEmpty(value) Then
                _informacionadicionalpago01 = "N/A"
            End If
            _informacionadicionalpago01 = value
        End Set
    End Property
    ''' <summary>
    ''' Información adicional del Pago individual (opcional). De no incluir informaciones, entonces se debe indicar 'N/A'.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property InformAdicionalPago02() As String
        Get
            Return _informacionadicionalpago02
        End Get
        Set(ByVal value As String)
            If String.IsNullOrEmpty(value) Then
                _informacionadicionalpago02 = "N/A"
            End If
            _informacionadicionalpago02 = value
        End Set
    End Property
    ''' <summary>
    ''' Verificador de cada instrucción de pagos para garantizar la integridad de cada registro.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property DigitosControl() As Int32
        Get
            Return _digitocontrol
        End Get
        Set(ByVal value As Int32)
            If Not String.IsNullOrEmpty(value.ToString) AndAlso value > 0 Then
                _digitocontrol = value
            End If
        End Set
    End Property
#End Region

#Region "Contructore de la clase"
    Public Sub New()

    End Sub
    Public Sub New(ByVal nombrelote As Int32, ByVal nombrebeneficiario As String, ByVal identificacionbenefiario As String, ByVal montodepositar As Decimal, _
                   ByVal nroctaestandar As String, ByVal tipocuenta As String, ByVal conceptodetallado As String, ByVal inforadicional01 As String, _
                   ByVal inforadicional02 As String, ByVal digitoscontrol As Int32)

        Me.NombreLote = nombrelote
        Me.NombreBeneficairio = nombrebeneficiario
        Me.IdentificacionBeneficiario = identificacionbenefiario
        Me.MontoDepositar = montodepositar
        Me.NumeroCuentaEstandar = nroctaestandar
        Me.TipoCuenta = tipocuenta
        Me.ConceptoDetallado = conceptodetallado
        Me.InformAdicionalPago01 = inforadicional01
        Me.InformAdicionalPago02 = inforadicional02
        Me.DigitosControl = digitoscontrol
    End Sub
#End Region


End Class
