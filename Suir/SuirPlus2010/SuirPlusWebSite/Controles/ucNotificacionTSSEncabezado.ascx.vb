Imports SuirPlus.Empresas
Partial Class Controles_ucNotificacionTSSEncabezado
    Inherits BaseCtrlFacturaEncabezado

    Private myBotoneVisible As Boolean

    Public Property isBotonesVisibles() As Boolean
        Get
            Return myBotoneVisible
        End Get
        Set(ByVal Value As Boolean)
            myBotoneVisible = Value
            If myBotoneVisible = False Then
                Me.hlnkDetalle.Visible = False
                Me.hlnkDependiente.Visible = False
                Me.hlnkImprimir.Visible = False
                Me.hlnkDetalleAjuste.Visible = False
                Me.hlnkPagosARS.Visible = False

            End If
        End Set
    End Property

    Public Shadows Function MostrarEncabezado() As String

        If Not Me.NroReferencia = String.Empty Or Not Me.NroAutorizacion = 0 Then
            Me.pnlNotificacion.Visible = True

            Try
                Me.LlenarEncabezado()
                Return "0"
            Catch ex As Exception
                Me.pnlNotificacion.Visible = False
                Return "1|" & ex.ToString()
            End Try

        Else
            Me.mostrarMensajeError()
        End If

        Return "1|Error"

    End Function

    Protected Overrides Sub configurar()



        If Me.isDetalleHabilitado = False Then
            Me.hlnkDetalle.Visible = False
            Me.hlnkDependiente.Visible = False
        Else

            Dim ServerPath As String
            'Para obtener el virtual path del server
            ServerPath = Mid(Request.Path, 1, InStrRev(Request.Path, "/"))

            If Me.DetalleURL = "" Then
                Me.DetalleURL = Request.Path
                Me.DetalleURL = Replace(Me.DetalleURL, ServerPath, "")
            End If


            Me.hlnkDetalle.NavigateUrl = ServerPath & Me.DetalleURL & "?nro=" & Me.NroReferencia & "&tipo=sdss&sec=detalle"
            Me.hlnkDependiente.NavigateUrl = ServerPath & Me.DetalleURL & "?nro=" & Me.NroReferencia & "&tipo=sdss&sec=dependiente"
            Me.hlnkPagosARS.NavigateUrl = ServerPath & Me.DetalleURL & "?nro=" & Me.NroReferencia & "&tipo=sdss&sec=pagos"
            Me.hlnkDetalleAjuste.NavigateUrl = ServerPath & Me.DetalleURL & "?nro=" & Me.NroReferencia & "&tipo=sdss&sec=ajuste"

        End If



        Me.hlnkImprimir.NavigateUrl = Application("urlImprimir") & "?nro=" & Me.NroReferencia & "&tipo=tss&sec=encabezado&imp=si"

    End Sub

    Protected Overrides Sub LlenarEncabezado()

        Dim FacturaTSS As Facturacion.FacturaSS
        Dim OficiosMotivo As Facturacion.FacturaSS
        Dim EmpleadorTSS As Empleador

        'Si el número de referencia es nulo, buscamos por la numero de autorizacion.
        If Me.NroReferencia Is Nothing Or NroReferencia = String.Empty Then
            FacturaTSS = New Facturacion.FacturaSS(Me.NroAutorizacion)
            Me.NroReferencia = FacturaTSS.NroReferencia

            OficiosMotivo = New Facturacion.FacturaSS(Me.NroAutorizacion)
            Me.NroReferencia = OficiosMotivo.NroReferencia
        Else
            FacturaTSS = New Facturacion.FacturaSS(Me.NroReferencia)
            OficiosMotivo = New Facturacion.FacturaSS(Me.NroReferencia)
        End If

        'Para que le pase el nro de referencia a los links ya que dentro de este método se actualiza la variable Me.NroReferencia
        'Gregorio Herrera
        Me.configurar()

        EmpleadorTSS = New Empleador(FacturaTSS.RegistroPatronal)

        Me.lblPeriodo.Text = FacturaTSS.PeriodoFormateado
        Me.lblNoReferencia.Text = FacturaTSS.NroReferenciaFormateado
        Me.lblRazonSocial.Text = FacturaTSS.RazonSocial

        'validamos si el usuario logeado es un representante
        If CType(Me.Page(), BasePage).UsrIDTipoUsuario = 2 Then
            Me.lblRnc.Text = FacturaTSS.RNC
        Else
            Me.lblRnc.Text = "<a href=""consEmpleador.aspx?rnc=" & FacturaTSS.RNC & """ >" & FacturaTSS.RNC & "</a>"
        End If

        Me.lblDireccion.Text = StrConv(EmpleadorTSS.Direccion, VbStrConv.ProperCase)
        Me.lblMunicipio.Text = EmpleadorTSS.IDMunicipio & "-" & StrConv(EmpleadorTSS.Municipio, VbStrConv.ProperCase)
        Me.lblTotalTrabajadores.Text = FormatNumber(FacturaTSS.TotalAsalariados, 0)
        Me.lblFechaEmision.Text = CDate(FacturaTSS.FechaEmision).ToShortDateString
        'Me.lblFechaReportePago.Text = CDate(FacturaTSS.FechaReportePago).ToShortDateString
        'Me.lblFechaReportePago.Text = FacturaTSS.FechaReporte
        Me.lblFechaLimitePago.Text = FacturaTSS.FechaLimitePago
        Me.lblNomina.Text = FacturaTSS.Nomina & " (" & FacturaTSS.IDNomina & ")"
        Me.lblTipoNomina.Text = FacturaTSS.TipoNomina
        Me.lblEst.Text = FacturaTSS.Estatus
        Me.lblOrigenPago.Text = FacturaTSS.OrigenPago
        Me.lblTelefono.Text = SuirPlus.Utilitarios.Utils.FormatearTelefono(EmpleadorTSS.Telefono1)

        If FacturaTSS.NroAutorizacion <> Nothing Then
            If FacturaTSS.Estatus <> "Pagada" And FacturaTSS.Estatus <> "Cancelada" Then
                trAviso.Visible = True

                lblPagoBanco.Text = "Pago pendiente de ser reportado por el Banco."
            End If
        End If


        '        FacturaTSS.t()
        Try
            Me.pnlOficio.Visible = (OficiosMotivo.IdOficio.Length = 0)

            'If OficiosMotivo.IdOficio.Length = 0 Then
            'Me.lblNumOficio.Visible = False
            'Me.lblMotivoOficio.Visible = False
            'End If

        Catch ex As Exception

        End Try

        Me.lblNumOficio.Text = OficiosMotivo.IdOficio
        Me.lblMotivoOficio.Text = OficiosMotivo.Motivo

        'Verificamos si el empleador tiene telefono2 para desplegarlo.
        'If EmpleadorTSS.Telefono2 <> String.Empty Then
        '   Me.lblTelefono.Text = lblTelefono.Text & " / " & SuirPlus.Utilitarios.Utils.FormatearTelefono(EmpleadorTSS.Telefono2)
        'End If

        'Seccion de totales
        Me.lblRetTrabSFS.Text = String.Format("{0:n}", FacturaTSS.RetencionTrabajadoresSFS)
        Me.lblContrEmplSFS.Text = String.Format("{0:n}", FacturaTSS.ContribucionEmpleadorSFS)
        Me.lblRetTrabPension.Text = String.Format("{0:n}", FacturaTSS.RetencionTrabajadoresPension)
        Me.lblContEmplPension.Text = String.Format("{0:n}", FacturaTSS.ContribucionEmpleadorPension)
        Me.lblSRL.Text = String.Format("{0:n}", FacturaTSS.SRL)
        Me.lblPagoPerCapitaAdic.Text = String.Format("{0:n}", FacturaTSS.PagosPerCapitaAdicional)
        Me.lblAportesVoluntariosOrd.Text = String.Format("{0:n}", FacturaTSS.AportesVoluntariosOrdinarios)
        Me.lblInteresSFS.Text = String.Format("{0:n}", FacturaTSS.InteresesSFS)
        Me.lblRecargoSFS.Text = String.Format("{0:n}", FacturaTSS.RecargosSFS)
        Me.lblInteresPension.Text = String.Format("{0:n}", FacturaTSS.InteresPension)
        Me.lblRecargoPension.Text = String.Format("{0:n}", FacturaTSS.RecargoPension)
        Me.lblInteresSRL.Text = String.Format("{0:n}", FacturaTSS.InteresSRL)
        Me.lblRecargosSRL.Text = String.Format("{0:n}", FacturaTSS.RecargoSRL)
        Me.lblSubsidios.Text = String.Format("{0:n}", FacturaTSS.MontoAjuste)

        Me.lblTipo.Text = FacturaTSS.TipoFactura

        Me.lblTotalGral.Text = String.Format("{0:c}", FacturaTSS.TotalGeneral)

        If UCase(FacturaTSS.Estatus).Equals("CA") Then

            Me.lblEstatus.Text = "Notificación de Pago Revocada"
            Me.pnlEstatus.Visible = True
            Me.hlnkDetalle.Enabled = False
            Me.hlnkDependiente.Enabled = False

        ElseIf UCase(FacturaTSS.Estatus).Equals("RE") Then

            Me.lblEstatus.Text = "Notificación de Pago Recalculada"
            Me.pnlEstatus.Visible = True
            Me.hlnkDetalle.Enabled = False
            Me.hlnkDependiente.Enabled = False

        Else

            Me.lblEstatus.Text = String.Empty
            Me.pnlEstatus.Visible = False
            Me.hlnkDetalle.Enabled = True
            Me.hlnkDependiente.Enabled = True

        End If





    End Sub

    Private Sub mostrarMensajeError()

        Me.lblError.Text = "Nro de Referencia Invalido"
        Me.pnlError.Visible = True
        Me.pnlNotificacion.Visible = False

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        configurar()
    End Sub
End Class
