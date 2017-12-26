Imports System.Data
Imports Microsoft.VisualBasic


Public Class BaseCtrlFactura
    Inherits System.Web.UI.UserControl

    Private myNroReferencia As String
    Private myNroAutorizacion As String
    Private myEstatus As String
    Private myPeriodo As String
    Private myRNC As String
    Private myTipo As String


    Public Property Estatus() As String
        Get
            Return Me.myEstatus
        End Get
        Set(ByVal Value As String)
            Me.myEstatus = Value
        End Set
    End Property

    Public Property NroReferencia() As String
        Get
            Return Me.myNroReferencia
        End Get
        Set(ByVal Value As String)
            Me.myNroReferencia = Value
        End Set
    End Property

    Public Property NroAutorizacion() As Int64
        Get
            Return Me.myNroAutorizacion
        End Get
        Set(ByVal Value As Int64)
            Me.myNroAutorizacion = Value
        End Set
    End Property

    Public Property Periodo() As String
        Get
            Return Me.myPeriodo
        End Get
        Set(ByVal Value As String)
            Me.myPeriodo = Value
        End Set
    End Property

    Public Property RNC() As String
        Get
            Return Me.myRNC
        End Get
        Set(ByVal Value As String)
            Me.myRNC = Value
        End Set
    End Property

    Public Property Tipo() As String
        Get
            Return Me.myTipo
        End Get
        Set(ByVal Value As String)
            Me.myTipo = Value
        End Set
    End Property

    Protected Overridable Sub configurar()

    End Sub


End Class

Public Class BaseCtrlFacturaEncabezado
    Inherits BaseCtrlFactura

    Public isDetalleHabilitado As Boolean = True
    Public DetalleURL As String

    Public Overridable Sub MostrarEncabezado()

    End Sub
    Protected Overridable Sub LlenarEncabezado()

    End Sub


End Class

Public Class BaseCtrlFacturaDetalle
    Inherits BaseCtrlFactura

    Protected dt As DataTable
    Protected paginaActual As Int32 = 1
    Protected paginaTam As Int32 '= Application("dgPageSize")

    Public EncabezadoURL As String


    Public Overridable Sub MostrarDetalle()

    End Sub
    Protected Overridable Sub CalcularVista()

    End Sub
    Protected Overridable Sub CargaInicial()

    End Sub

    Protected Overridable Sub Bind()

    End Sub


End Class

