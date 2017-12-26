Imports SuirPlus.Empresas

Partial Class Controles_ucLiquidacionISRPEncabezado
    Inherits BaseCtrlFacturaEncabezado

    Private myBotonesVisibles As Boolean

    Public Property isBotonesVisibles() As Boolean
        Get
            Return myBotonesVisibles
        End Get
        Set(ByVal Value As Boolean)
            myBotonesVisibles = Value

            If myBotonesVisibles = False Then
                Me.hlnkDetalle.Visible = False
                Me.hlnkImprimir.Enabled = False
            End If

        End Set
    End Property


    Public Shadows Function MostrarEncabezado() As String

        If Not Me.Periodo = String.Empty Then
            Me.pnlLiquidacion.Visible = True

            Try
                Me.LlenarEncabezado()
                Return "0"
            Catch ex As Exception
                Me.pnlLiquidacion.Visible = False
                Return "1|" & ex.Message
            End Try

        Else
            Me.mostrarMensajeError()
        End If

        Return "1|Error"

    End Function

    Protected Overrides Sub configurar()

        If Me.isDetalleHabilitado = False Then
            Me.hlnkDetalle.Visible = False
        Else
            Dim ServerPath As String
            'Para obtener el virtual path del server
            ServerPath = Mid(Request.Path, 1, InStrRev(Request.Path, "/"))

            If Me.DetalleURL = "" Then
                Me.DetalleURL = Request.Path
                Me.DetalleURL = Replace(Me.DetalleURL, ServerPath, "")
            End If
            Me.hlnkDetalle.Visible = True
            Me.hlnkDetalle.NavigateUrl = ServerPath & Me.DetalleURL & "?nro=" & Me.Periodo & "&tipo=isrp&sec=detalle&tifa=" & Me.Tipo
        End If

        Me.hlnkImprimir.NavigateUrl = Application("urlImprimir") & "?nro=" & Me.Periodo & "&tipo=isrp&sec=encabezado&imp=si"

    End Sub

    Protected Overrides Sub LlenarEncabezado()

        Dim FacturaDGII As Facturacion.LiquidacionISRPRE

        Try

            FacturaDGII = New Facturacion.LiquidacionISRPRE(Periodo, RNC, Tipo)


            configurar()

        Catch ex As Exception
            Me.lblError.Text = ex.ToString()
            Me.mostrarMensajeError()
            Exit Sub
        End Try

        Dim EmpleadorDGII As New Empleador(RNC)


        Me.lblRazonSocial.Text = EmpleadorDGII.RazonSocial

        'validamos si el usuario logeado es un representante
        If CType(Me.Page(), BasePage).UsrIDTipoUsuario = 2 Then
            Me.lblCedulaRNC.Text = FacturaDGII.RNC
        Else
            Me.lblCedulaRNC.Text = "<a href=""consEmpleador.aspx?rnc=" & FacturaDGII.RNC & """>" & FacturaDGII.RNC & "</a>"
        End If

        Me.lblTipoLiqu.Text = FacturaDGII.TipoFactura
        Me.lblDireccion.Text = StrConv(EmpleadorDGII.Direccion, VbStrConv.ProperCase)
        Me.lblAdministracionLocal.Text = StrConv(EmpleadorDGII.AdministradoraLocal, VbStrConv.ProperCase)
        Me.lblTelefono.Text = SuirPlus.Utilitarios.Utils.FormatearTelefono(EmpleadorDGII.Telefono1)
      

        'Llenamos los label de los totales.
        Me.lblTotalAsalariado.Text = FacturaDGII.TotalAsalariados
        Me.lblSueldosPagadosAgenteRetencion.Text = String.Format("{0:n}", FacturaDGII.SueldoPagadosAgenteRetencion)
        Me.lblRemOtrosAgentes.Text = String.Format("{0:n}", FacturaDGII.RemuneracionesOtrosAgentes)
        Me.lblOtrasRemuneracion.Text = String.Format("{0:n}", FacturaDGII.OtrasRemuneraciones)
        Me.lblTotalPagado.Text = String.Format("{0:n}", FacturaDGII.TotalPagado)
        Me.lblTotalSujetoRetencion.Text = String.Format("{0:n}", FacturaDGII.TotalSujetoRetencion)
        Me.lblTotalRetencionSS.Text = String.Format("{0:n}", FacturaDGII.TotalRetencionSS)
     
        Me.lblIngresosExentosISR.Text = String.Format("{0:n}", FacturaDGII.TotalIngresosExtentosISR)



        'Total de la factua.
        Me.lblPeriodo.Text = FacturaDGII.PeriodoFormateado

        'Si la factura tiene estatus EX (Extenta) se muestra en un label, para informar al usuario.
        If UCase(FacturaDGII.Estatus).Equals("EX") Then
            Me.lblEstatus.Text = "Liquidación Extenta"
            Me.pnlEstatus.Visible = True
        Else
            Me.lblEstatus.Text = String.Empty
            Me.pnlEstatus.Visible = False
        End If

        'Si la factura tienes estatus CA (Cancelada) se muestra un label, para informar al usuario.
        If UCase(FacturaDGII.Estatus).Equals("CA") Then
            Me.lblEstatus.Text = "Liquidación Cancelada"
            Me.pnlEstatus.Visible = True
            Me.hlnkDetalle.Enabled = False
        Else
            Me.hlnkDetalle.Enabled = True
            Me.lblEstatus.Text = String.Empty
            Me.pnlEstatus.Visible = False
        End If

    End Sub

    Private Sub mostrarMensajeError()

        'Me.lblError.Text = "Nro de Referencia invalido"
        Me.pnlError.Visible = True
        Me.pnlLiquidacion.Visible = False

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.configurar()
    End Sub

End Class
