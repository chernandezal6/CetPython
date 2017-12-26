Imports SuirPlus.Empresas
Partial Class Controles_ucLiquidacionInfotepEnc
    Inherits BaseCtrlFacturaEncabezado

    Public Property isBtnDetalleEnable() As Boolean
        Get
            Return Me.hlnkDetalle.Enabled
        End Get
        Set(ByVal Value As Boolean)
            Me.hlnkDetalle.Enabled = Value
        End Set
    End Property

    Public Property isBtnImprimirVisible() As Boolean
        Get
            Return Me.hlnkImprimir.Visible
        End Get
        Set(ByVal Value As Boolean)
            Me.hlnkImprimir.Visible = Value
        End Set
    End Property

    Public Shadows Function MostrarEncabezado() As String

        If Not Me.NroReferencia = String.Empty Or Not Me.NroAutorizacion = 0 Then

            Me.pnlLiquidacion.Visible = True

            Try
                Me.LlenarEncabezado()
                Return "0"
            Catch ex As Exception
                Me.pnlLiquidacion.Visible = False
                Return "1|" & ex.Message

            End Try

        Else
            Return "1|" & "Nro. de Referencia no especificado."
        End If

    End Function

    Protected Overrides Sub Configurar()

        Dim ServerPath As String
        'Para obtener el virtual path del server
        ServerPath = Mid(Request.Path, 1, InStrRev(Request.Path, "/"))

        If Me.DetalleURL = "" Then
            Me.DetalleURL = Request.Path
            Me.DetalleURL = Replace(Me.DetalleURL, ServerPath, "")
        End If

        Me.hlnkDetalle.NavigateUrl = ServerPath & Me.DetalleURL & "?nro=" & Me.NroReferencia & "&tipo=inf&sec=detalle"
        Me.hlnkImprimir.NavigateUrl = Application("urlImprimir") & "?nro=" & Me.NroReferencia & "&tipo=inf&sec=encabezado&imp=si"

    End Sub

    Protected Overrides Sub LlenarEncabezado()

        Dim factInfotep As Facturacion.LiquidacionInfotep

        If Me.NroReferencia = String.Empty Or Me.NroReferencia Is Nothing Then
            factInfotep = New Facturacion.LiquidacionInfotep(Me.NroAutorizacion)
            Me.NroReferencia = factInfotep.NroReferencia
        Else
            factInfotep = New Facturacion.LiquidacionInfotep(Me.NroReferencia)
        End If

        Me.Configurar()



        Dim empleadorTSS As New Empleador(factInfotep.RegistroPatronal)
        Me.lblReferencia.Text = factInfotep.NroReferenciaFormateado
        Me.lblPeriodo.Text = factInfotep.PeriodoFormateado
        Me.lblRazonSocial.Text = factInfotep.RazonSocial

        'validamos si el usuario logeado es un representante
        If CType(Me.Page(), BasePage).UsrIDTipoUsuario = 2 Then
            Me.lblCedulaRNC.Text = factInfotep.RNC
        Else
            Me.lblCedulaRNC.Text = "<a href=""consEmpleador.aspx?rnc=" & factInfotep.RNC & """>" & factInfotep.RNC & "</a>"
        End If

        Me.lblDireccion.Text = StrConv(empleadorTSS.Direccion, VbStrConv.ProperCase)
        Me.lblTelefono.Text = SuirPlus.Utilitarios.Utils.FormatearTelefono(empleadorTSS.Telefono1)
        Me.lblFechaEmision.Text = CDate(factInfotep.FechaEmision).ToShortDateString
        Me.lblFechaLimitePago.Text = factInfotep.FechaLimitePago
        Me.lblTipoLiq.Text = factInfotep.TipoFactura
        Me.lblEst.Text = factInfotep.Estatus

        'Seccion de totales

        If factInfotep.Tipo = "B" Then
            Me.lblItemFact.Text = " Total Bonificación Trabajadores"
        Else
            Me.lblItemFact.Text = " Total Salarios Trabajadores"
        End If

        If factInfotep.Tipo = "E" Then
            Me.tblRenglones.Rows(1).Visible = False
            Me.hlnkDetalle.Enabled = False
        End If

        Me.lblTotalAsalariado.Text = factInfotep.TotalAsalariados
        Me.lblTotalBonificacion.Text = String.Format("{0:n}", factInfotep.TotalSalariosBonificacion)
        Me.lblTotalGral.Text = "RD$ " & String.Format("{0:n}", factInfotep.TotalGeneral)

        'Si la factura tienes estatus CA (Cancelada) se muestra un label, para informar al usuario.
        If UCase(factInfotep.Estatus).Equals("CA") Then
            Me.lblEstatus.Text = "Liquidación Cancelada"
            Me.pnlEstatus.Visible = True
        Else
            Me.lblEstatus.Text = String.Empty
            Me.pnlEstatus.Visible = False
        End If



    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.Configurar()
    End Sub

End Class
