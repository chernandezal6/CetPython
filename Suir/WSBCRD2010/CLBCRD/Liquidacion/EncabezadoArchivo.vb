Imports Oracle
Imports Oracle.DataAccess
Imports Oracle.DataAccess.Client
Imports Oracle.DataAccess.Types
''' <summary>
''' Objecto para manejar todo el encabezado del archivo XML del Banco Central.
''' Developer: Francis R. Ramirez.
''' Fecha: 30/03/2009
''' </summary>
''' <remarks></remarks>
Partial Public Class EncabezadoArchivo

#Region "Atributos de la clase"
    Private _nombrearchivo As String
    Private _tipo As String
    Private _fechageneracion As String
    Private _horageneracion As String
    Private _nombrelote As Int32
    Private _conceptopago As String
    Private _codbicentidaddb As String
    Private _codbicentidadcr As String
    Private _trnopcrlbtr As String
    Private _fechavalorcrlbtr As String
    Private _totalregistroscontrol As Int32
    Private _totalmontoscontrol As Decimal
    Private _moneda As String
    Private _informadicional01 As String
    Private _estadoarchivoportal As String
    Private _cantdescargaarchivo As String
    Private _usuariodescargoarchivo As String
    Private _archivo_XML As String
#End Region
#Region "Propiedades de la clase"
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
    ''' Descripción del tipo de archivo
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property Tipo() As String
        Get
            Return _tipo
        End Get
        Set(ByVal value As String)
            If Not String.IsNullOrEmpty(value) Then
                _tipo = value
            End If
        End Set
    End Property
    ''' <summary>
    ''' Fecha de generación del archivo (en formato dd/mm/aaaa)
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property FechaGeneracion() As String
        Get
            Return _fechageneracion
        End Get
        Set(ByVal value As String)
            If Not String.IsNullOrEmpty(value.ToString) Then
                _fechageneracion = value
            End If
        End Set
    End Property
    ''' <summary>
    ''' Hora de generación de este archivo
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property HoraGeneracion() As String
        Get
            Return _horageneracion
        End Get
        Set(ByVal value As String)
            If Not String.IsNullOrEmpty(value.ToString) Then
                _horageneracion = value
            End If
        End Set
    End Property

    Public ReadOnly Property NombreEntidadRecaudadora() As String
        Get

            Dim ent As String = ""
            Dim a As String = ""

            Dim c As New BLArchivoXML()
            c.getEntidadNombrePorBic(Me.CodBicEntidadCR, ent, a)

            Return ent

        End Get
    End Property

    ''' <summary>
    ''' Nombre del lote
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property NombreLote() As Int32
        Get
            Return _nombrelote
        End Get
        Set(ByVal value As Int32)
            If Not String.IsNullOrEmpty(value.ToString) Then
                If Not value.Equals(0) Then
                    _nombrelote = value
                End If
            End If
        End Set
    End Property
    ''' <summary>
    ''' Concepto general del pago crédito a cuenta
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property ConceptoPago() As String
        Get
            Return _conceptopago
        End Get
        Set(ByVal value As String)
            If Not String.IsNullOrEmpty(value) Then
                _conceptopago = value
            End If
        End Set
    End Property
    ''' <summary>
    ''' Código BIC SWIFT de la Entidad Debitada
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property CodBicEntidadDB() As String
        Get
            Return _codbicentidaddb
        End Get
        Set(ByVal value As String)
            If Not String.IsNullOrEmpty(value) Then
                If value.Length.Equals(11) Then
                    _codbicentidaddb = value
                End If
            End If
        End Set
    End Property
    ''' <summary>
    ''' Código BIC SWIFT de la Entidad Acreditada.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property CodBicEntidadCR() As String
        Get
            Return _codbicentidadcr
        End Get
        Set(ByVal value As String)
            If Not String.IsNullOrEmpty(value) Then
                If value.Length.Equals(11) Then
                    _codbicentidadcr = value
                End If
            End If
        End Set
    End Property
    ''' <summary>
    '''  TRN de la operación crédito global aplicado a la Entidad vía LBTR, por concepto de estos pagos. Ejemplo: Nómina de pagos de empleados.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property TRNopcrlbtr() As String
        Get
            Return _trnopcrlbtr
        End Get
        Set(ByVal value As String)
            If Not String.IsNullOrEmpty(value) Then
                _trnopcrlbtr = value
            End If
        End Set
    End Property
    ''' <summary>
    ''' Fecha valor de la operación crédito global aplicado a la Entidad vía LBTR, por concepto de estos pagos. (en formato dd/mm/aaaa).
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property FechaValorCRLBTR() As String
        Get
            Return _fechavalorcrlbtr
        End Get
        Set(ByVal value As String)
            If Not String.IsNullOrEmpty(value) Then
                _fechavalorcrlbtr = value
            End If
        End Set
    End Property
    ''' <summary>
    ''' Cantidad total de pagos por crédito a cuenta a los beneficiarios.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property TotalRegistroscontrol() As Int32
        Get
            Return _totalregistroscontrol
        End Get
        Set(ByVal value As Int32)
            If Not String.IsNullOrEmpty(value.ToString) Then
                If Not value.Equals(0) Then
                    _totalregistroscontrol = value
                End If
            End If
        End Set
    End Property
    ''' <summary>
    ''' Monto totalizado de todos los pagos crédito a cuenta
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property TotalMontoControl() As Decimal
        Get
            Return _totalmontoscontrol
        End Get
        Set(ByVal value As Decimal)
            If Not String.IsNullOrEmpty(value.ToString) Then
                If Not value.Equals(0) Then
                    _totalmontoscontrol = value
                End If
            End If
        End Set
    End Property
    ''' <summary>
    ''' Código moneda (tres caracteres) correspondiente a la cuenta beneficiario final.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property Moneda() As String
        Get
            Return _moneda
        End Get
        Set(ByVal value As String)
            If Not String.IsNullOrEmpty(value) AndAlso value.Length.Equals(3) And value.Equals("DOP") Then
                _moneda = value
            End If
        End Set
    End Property
    ''' <summary>
    ''' Información adicional del encabezado (opcional). De no incluir informaciones, entonces se debe indicar "N/A"
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property InformacionAdicional() As String
        Get
            Return _informadicional01
        End Get
        Set(ByVal value As String)

            _informadicional01 = value


        End Set
    End Property
    ''' <summary>
    ''' Estado del archivo en el portal, al momento de realizar su descarga. El mismo puede ser "Nuevo", 
    ''' si es la primera vez que se descarga; o "Descargado" si ya fue previamente descargado.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property EstadoArchivoPortal() As String
        Get
            Return _estadoarchivoportal
        End Get
        Set(ByVal value As String)
            _estadoarchivoportal = value
        End Set
    End Property
    ''' <summary>
    ''' Número de veces que este archivo ha sido descargado del Portal.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property CantDescargaArchivo() As String
        Get
            Return _cantdescargaarchivo
        End Get
        Set(ByVal value As String)
            _cantdescargaarchivo = value
        End Set
    End Property
    ''' <summary>
    ''' Usuario que descargó el archivo del Portal.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property UsuarioDescargoArchivo() As String
        Get
            Return _usuariodescargoarchivo
        End Get
        Set(ByVal value As String)
            _usuariodescargoarchivo = value
        End Set
    End Property
    Public Property ArchivoXML() As String
        Get
            Return _archivo_XML
        End Get
        Set(ByVal value As String)
            _archivo_XML = value
        End Set
    End Property
#End Region
#Region "Contructor de la clase"
    Public Sub New()

    End Sub
    Public Sub New(ByVal nombrearchivo As String, ByVal tipo As String, ByVal fechageneracion As Date, ByVal horageneracion As Date, ByVal nombrelote As Int32, _
                  ByVal conceptopago As String, ByVal codbicentidaddb As String, ByVal codbicentidadcr As String, ByVal trnopcrlbtr As String, _
                  ByVal fechavalorcrlbtr As Date, ByVal totalregistroscontrol As Int32, ByVal totalmonteocontrol As Decimal, ByVal moneda As String, _
                  ByVal infoadicional01 As String, ByVal estadoenportal As String, ByVal cantdescargararchivo As Int32, ByVal usudescargaarchivo As String, ByVal XMLArchivo As String)


        Me.NombreArchivo = nombrearchivo
        Me.Tipo = tipo
        Me.FechaGeneracion = fechageneracion
        Me.HoraGeneracion = horageneracion
        Me.NombreLote = nombrearchivo
        Me.ConceptoPago = conceptopago
        Me.CodBicEntidadDB = codbicentidaddb
        Me.CodBicEntidadCR = codbicentidadcr
        Me.TRNopcrlbtr = trnopcrlbtr
        Me.FechaValorCRLBTR = fechavalorcrlbtr
        Me.TotalRegistroscontrol = totalregistroscontrol
        Me.TotalMontoControl = totalmonteocontrol
        Me.Moneda = moneda
        Me.InformacionAdicional = infoadicional01
        Me.EstadoArchivoPortal = estadoenportal
        Me.CantDescargaArchivo = cantdescargararchivo
        Me.UsuarioDescargoArchivo = usudescargaarchivo
        Me.ArchivoXML = XMLArchivo
    End Sub
#End Region


End Class
