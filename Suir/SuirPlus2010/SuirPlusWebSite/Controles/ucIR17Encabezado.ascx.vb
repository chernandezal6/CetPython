Imports SuirPlus.Empresas
Imports System.Data
Partial Class Controles_ucIR17Encabezado
    Inherits BaseCtrlFacturaEncabezado

    Public Property IsBtnImprimirVisible() As Boolean
        Get
            Return Me.hlnkImprimir.Visible
        End Get
        Set(ByVal Value As Boolean)
            Me.hlnkImprimir.Visible = Value
        End Set
    End Property

    Public Property isPanelInfoPagoVisible() As Boolean
        Get
            Return Me.pnlInfoPago.Visible
        End Get
        Set(ByVal Value As Boolean)
            Me.pnlInfoPago.Visible = Value
        End Set
    End Property

    Public Shadows Function MostrarEncabezado() As String

        If Not Me.NroReferencia = String.Empty Or Not Me.NroAutorizacion = 0 Then

            Me.pnlLiquidacion.Visible = True
            Me.pnlInfoPago.Visible = Me.isPanelInfoPagoVisible

            Try
                Me.LlenarEncabezado()
                Return "0"
            Catch ex As Exception
                Me.pnlLiquidacion.Visible = False
                Me.pnlError.Visible = True
                Return "1|" & ex.Message
            End Try

        Else
            Me.mostrarMensajeError()
        End If

        Return "1|Error"

    End Function

    Protected Overrides Sub configurar()

        Me.hlnkImprimir.NavigateUrl = Application("urlImprimir") & "?nro=" & Me.NroReferencia & "&tipo=ir17&sec=encabezado&imp=si"

    End Sub

    Protected Overrides Sub LlenarEncabezado()

        Dim IR17 As Facturacion.LiquidacionIR17

        Try
            'Si el no. de referencia esta vacio hacemos la instancia por el No. de autorizacion
            'De lo contrario hacemos la instancia por el No. de referencia.
            If Me.NroReferencia = String.Empty Or Me.NroReferencia Is Nothing Then
                IR17 = New Facturacion.LiquidacionIR17(Me.NroAutorizacion)
                Me.NroReferencia = IR17.NroReferencia
            Else
                IR17 = New Facturacion.LiquidacionIR17(Me.NroReferencia)
            End If

            Me.configurar()
        Catch ex As Exception
            Me.mostrarMensajeError()
            Exit Sub
        End Try

        'Instanciamos un objeto empleador para llenar las generales.
        Dim EmpleadorDGII As New Empleador(IR17.RegistroPatronal)

        Me.lblReferencia.Text = IR17.NroReferenciaFormateado
        Me.lblPeriodo.Text = IR17.PeriodoFormateado
        Me.lblRazonSocial.Text = IR17.RazonSocial

        'validamos si el usuario logeado es un representante
        If CType(Me.Page(), BasePage).UsrIDTipoUsuario = 2 Then
            Me.lblCedulaRNC.Text = IR17.RNC
        Else
            Me.lblCedulaRNC.Text = "<a href=""consEmpleador.aspx?rnc=" & IR17.RNC & """>" & IR17.RNC & "</a>"
        End If

        Me.lblDireccion.Text = StrConv(EmpleadorDGII.Direccion, VbStrConv.ProperCase)
        Me.lblAdministracionLocal.Text = StrConv(EmpleadorDGII.AdministradoraLocal, VbStrConv.ProperCase)
        Me.lblTelefono.Text = SuirPlus.Utilitarios.Utils.FormatearTelefono(EmpleadorDGII.Telefono1)
        Me.lblFechaEmision.Text = IR17.FechaEmision
        Me.lblFechaLimitePago.Text = IR17.FechaLimitePago
        Me.lblEst.Text = IR17.Estatus
        Me.lblOrigenPago.Text = IR17.OrigenPago

        'Llenamos la informacion correspondientes a los totales de la liquidacion.
        Me.lblAlquileres.Text = String.Format("{0:n}", IR17.Alquileres)
        Me.lblHonorarioServIndepen.Text = String.Format("{0:n}", IR17.HonorariosServicios)
        Me.lblPremios.Text = String.Format("{0:n}", IR17.Premios)
        Me.lblTransTituloPropiedades.Text = String.Format("{0:n}", IR17.TransferenciaTitulos)
        Me.lblDividendos.Text = String.Format("{0:n}", IR17.Dividendos)
        Me.lblInteresesInstCredExt.Text = String.Format("{0:n}", IR17.InteresExterior)
        Me.lblRemesasExterior.Text = String.Format("{0:n}", IR17.RemesesExterior)
        Me.lblRetencionesPagosProv.Text = String.Format("{0:n}", IR17.ProvedorEstado)
        Me.lblOtrasRentas.Text = String.Format("{0:n}", IR17.OtrasRentas)
        Me.lblOtrasRet.Text = String.Format("{0:n}", IR17.OtrasRetenciones)
        Me.lblTotalOtrasRet.Text = String.Format("{0:n}", IR17.TotalOtrasRetenciones)
        Me.lblRetribucionesComp.Text = String.Format("{0:n}", IR17.RetencionesComplementarias)
        Me.lblImpuestoPagar.Text = String.Format("{0:n}", IR17.Impuesto)
        Me.lblSaldosCompensables.Text = String.Format("{0:n}", IR17.SaldosCompensables)
        Me.lblSaldoFavorAnterior.Text = String.Format("{0:n}", IR17.SaldoFavorAnterior)
        Me.lblPagosComputables.Text = String.Format("{0:n}", IR17.PagosComputablesCuenta)
        Me.lblRecargos.Text = String.Format("{0:n}", IR17.TotalRecargos)
        Me.lblIntereses.Text = String.Format("{0:n}", IR17.TotalIntereses)
        Me.lblMontoPagar.Text = String.Format("{0:n}", IR17.TotalGeneral)

        If IR17.TotalGeneral < 0 Then
            'Este label se llena en base al siguiente calculo: (Impuesto a Pagar - Saldos Compensables Autorizados - Pagos computable a cuenta) * -1
            Me.lblNuevoSaldoFavor.Text = String.Format("{0:n}", IR17.TotalGeneral * -1)
            Me.lblMontoPagar.Text = "0.00"
        Else
            Me.lblNuevoSaldoFavor.Text = "0.00"
            Me.lblMontoPagar.Text = String.Format("{0:n}", IR17.TotalGeneral)
        End If

        If UCase(IR17.Estatus.Equals("CA")) Then
            Me.lblEstatus.Text = "Liquidación Cancelada"
            Me.pnlEstatus.Visible = True
        Else
            Me.pnlEstatus.Visible = False
        End If

        'Si se desea mostrar la informacion de pago, entonces se busca el datatable con la informacion de pago de la liquidacion.
        If Me.isPanelInfoPagoVisible Then

            Me.lblNoAutorizacion.Text = String.Empty
            Me.lblEntidadAutorizo.Text = String.Empty
            Me.lblUsuarioAutorizo.Text = String.Empty
            Me.lblFechaAut.Text = String.Empty
            Me.lblFechaPago.Text = String.Empty
            Me.lblFechaCancela.Text = String.Empty
            Me.lblFechaDesautorizo.Text = String.Empty
            Me.lblUsuarioDesautorizo.Text = String.Empty
            Me.lblFechaReportePago.Text = String.Empty

            Dim tmpDt As DataTable = SuirPlus.Empresas.Facturacion.Factura.consultaPago(Facturacion.Factura.eConcepto.IR17, Me.NroReferencia, Me.NroAutorizacion)
            If tmpDt.Rows.Count = 0 Then
                Exit Sub
            End If
            With tmpDt.Rows(0)
                Me.lblNoAutorizacion.Text = IIf(.Item("no_autorizacion") Is DBNull.Value, "", .Item("no_autorizacion"))
                Me.lblEntidadAutorizo.Text = IIf(.Item("ENTIDAD_RECAUDADORA_DES") Is DBNull.Value, "", .Item("ENTIDAD_RECAUDADORA_DES"))
                Me.lblUsuarioAutorizo.Text = IIf(.Item("Nombres") Is DBNull.Value, "", .Item("Nombres"))
                Me.lblFechaAut.Text = IIf(.Item("FECHA_AUTORIZACION") Is DBNull.Value, "", .Item("FECHA_AUTORIZACION"))
                Me.lblFechaPago.Text = IIf(.Item("FECHA_PAGO") Is DBNull.Value, "", .Item("FECHA_PAGO"))
                Me.lblFechaCancela.Text = IIf(.Item("FECHA_CANCELA") Is DBNull.Value, "", .Item("FECHA_CANCELA"))
                Me.lblFechaDesautorizo.Text = IIf(.Item("FECHA_DESAUTORIZACION") Is DBNull.Value, "", .Item("FECHA_DESAUTORIZACION"))
                Me.lblUsuarioDesautorizo.Text = IIf(.Item("Nombre_Desautorizo") Is DBNull.Value, "", .Item("Nombre_Desautorizo"))
                Me.lblFechaReportePago.Text = IIf(.Item("FECHA_REPORTE_PAGO") Is DBNull.Value, "", .Item("FECHA_REPORTE_PAGO"))
            End With

        End If

    End Sub

    Private Sub mostrarMensajeError()

        Me.lblError.Text = "Nro. de Referencia inválido"
        Me.pnlError.Visible = True
        Me.pnlLiquidacion.Visible = False
        Me.pnlInfoPago.Visible = False

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        configurar()
    End Sub

End Class
