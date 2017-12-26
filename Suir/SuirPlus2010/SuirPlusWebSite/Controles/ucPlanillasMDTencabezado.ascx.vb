Imports SuirPlus.Empresas

Partial Class Controles_ucPlanillasMDTencabezado
    Inherits BaseCtrlFacturaEncabezado


    Private v_estatus As String
    Public Property EstatusValor() As String
        Get
            Return v_estatus

        End Get
        Set(ByVal value As String)
            v_estatus = value
        End Set
    End Property

    Private v_TipoFactura As String
    Public Property TipoFactura() As String
        Get
            Return v_TipoFactura

        End Get
        Set(ByVal value As String)
            v_TipoFactura = value
        End Set
    End Property


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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.Configurar()
    End Sub

    Protected Overrides Sub Configurar()

        Dim ServerPath As String
        'Para obtener el virtual path del server
        ServerPath = Mid(Request.Path, 1, InStrRev(Request.Path, "/"))

        If Me.DetalleURL = "" Then
            Me.DetalleURL = Request.Path
            Me.DetalleURL = Replace(Me.DetalleURL, ServerPath, "")
        End If

        Me.hlnkDetalle.NavigateUrl = ServerPath & Me.DetalleURL & "?nro=" & Me.NroReferencia & "&tipo=MDT&sec=detalle"
        Me.hlnkImprimir.NavigateUrl = Application("urlImprimir") & "?nro=" & Me.NroReferencia & "&tipo=MDT&sec=encabezado&imp=si"

    End Sub




    Public Shadows Function MostrarEncabezado() As String

        If Not Me.NroReferencia = String.Empty Or Not Me.NroAutorizacion = 0 Then

            Me.pnlPlanilla.Visible = True

            Try
                Me.LlenarEncabezado()
                Return "0"
            Catch ex As Exception
                Me.pnlPlanilla.Visible = False
                Return "1|" & ex.Message

            End Try

        Else
            Return "1|" & "Nro. de Referencia no especificado."
        End If

    End Function



    Protected Overrides Sub LlenarEncabezado()

        Dim factMDT As Facturacion.PlanillaMDT

        If Me.NroReferencia = String.Empty Or Me.NroReferencia Is Nothing Then
            factMDT = New Facturacion.PlanillaMDT(Me.NroAutorizacion)
            Me.NroReferencia = factMDT.NroReferencia



        Else
            factMDT = New Facturacion.PlanillaMDT(Me.NroReferencia)
        End If

        Me.Configurar()



        Dim empleadorTSS As New Empleador(factMDT.RegistroPatronal)
        Me.lblIdPlanilla.Text = factMDT.IdPlanilla
        Me.lblReferencia.Text = factMDT.NroReferenciaFormateado
        Me.lblPeriodo.Text = factMDT.PeriodoFormateado
        Me.lblRazonSocial.Text = factMDT.RazonSocial

        'validamos si el usuario logeado es un representante
        If CType(Me.Page(), BasePage).UsrIDTipoUsuario = 2 Then
            Me.lblCedulaRNC.Text = factMDT.RNC
        Else
            Me.lblCedulaRNC.Text = "<a href=""consEmpleador.aspx?rnc=" & factMDT.RNC & """>" & factMDT.RNC & "</a>"
        End If

        Me.lblDireccion.Text = StrConv(empleadorTSS.Direccion, VbStrConv.ProperCase)
        Me.lblTelefono.Text = SuirPlus.Utilitarios.Utils.FormatearTelefono(empleadorTSS.Telefono1)
        Me.lblFechaEmision.Text = CDate(factMDT.FechaEmision).ToShortDateString
        Me.lblFechaLimitePago.Text = factMDT.FechaLimitePago
        Me.lblTipoLiq.Text = factMDT.TipoFactura
        Me.lblEst.Text = factMDT.Estatus
        v_estatus = factMDT.Estatus
        v_TipoFactura = factMDT.TipoFactura
        'Seccion de totales

        If factMDT.Tipo = "B" Then
            Me.lblItemFact.Text = " Total Bonificación"
        Else
            Me.lblItemFact.Text = " Total Salarios"
        End If

        If factMDT.Tipo = "E" Then
            Me.tblRenglones.Rows(1).Visible = False
            Me.hlnkDetalle.Enabled = False
        End If


        Me.lblTotalAsalariado.Text = factMDT.TotalAsalariados
        Me.lblToralLocalidades.Text = factMDT.TotalLocalidades

        Me.lblTotalBonificacion.Text = String.Format("{0:n}", factMDT.TotalSalariosBonificacion)
        Me.lblTotalGral.Text = "RD$ " & String.Format("{0:n}", factMDT.TotalGeneral)


        'Si la factura tienes estatus CA (Cancelada) se muestra un label, para informar al usuario.
        If UCase(factMDT.Estatus).Equals("CA") Then
            Me.lblEstatus.Text = "Planilla Cancelada"
            Me.pnlEstatus.Visible = True
        Else
            Me.lblEstatus.Text = String.Empty
            Me.pnlEstatus.Visible = False
        End If

        'Si la factura tienes estatus CA (Cancelada) se muestra un label, para informar al usuario.
        If UCase(factMDT.Estatus).Equals("PAGADA") Then
            pnlComentario.Visible = True
            Me.lblComentario.Text = factMDT.Observacion
        Else
            pnlComentario.Visible = False
        End If

    End Sub


End Class
