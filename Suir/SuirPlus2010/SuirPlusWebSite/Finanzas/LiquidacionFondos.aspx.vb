Imports SuirPlus.Finanzas
Imports System.Data
Imports SuirPlus.XMLBC
Partial Class Finanzas_LiquidacionFondos
    Inherits BasePage

    Private nombreArchivo As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            nombreArchivo = Request.QueryString.Item("Arch")
            CargarLiquidacion(nombreArchivo)
        End If


    End Sub

    Private Sub CargarLiquidacion(ByVal NombreArchivo As String)

        Dim dt As New DataTable
        Dim liquidacion As ArchivoLiquidacion

        Try

            liquidacion = New ArchivoLiquidacion(NombreArchivo)

            'llenamos el encabezado
            If liquidacion.NombreArchivo <> String.Empty Then
                Me.fsInfoLiquidacion.Visible = True
                lblArchivo.Text = liquidacion.NombreArchivo
                lblProceso.Text = liquidacion.Proceso
                lblTRN.Text = liquidacion.TRNopcrlbtr
                lblTipo.Text = liquidacion.Tipo
                lblFechaGeneracion.Text = liquidacion.FechaGeneracion
                lblHoraGeneracion.Text = liquidacion.HoraGeneracion
                lblLote.Text = liquidacion.NombreLote
                lblConceptoPago.Text = liquidacion.ConceptoPago
                lblCodigoBicDeb.Text = liquidacion.CodBicEntidadDB
                lblCodigoBicAcr.Text = liquidacion.CodBicEntidadCR
                lblFechaOperacion.Text = liquidacion.FechaValorCRLBTR
                lblRegistros.Text = liquidacion.TotalRegistroscontrol
                lblTotal.Text = liquidacion.TotalMontoControl
                lblMoneda.Text = liquidacion.Moneda

                dt = liquidacion.getDetalle()

                If dt.Rows.Count > 0 Then

                    Me.gvLiquidacion.DataSource = dt
                    Me.gvLiquidacion.DataBind()
                Else
                    Me.gvLiquidacion.DataSource = Nothing
                    Me.gvLiquidacion.DataBind()
                    Me.lblMensaje.Visible = True
                    Me.lblMensaje.Text = "No existe detalle para este registro."
                    Exit Sub
                End If

                dt = Nothing
            Else
                Me.fsInfoLiquidacion.Visible = False
            End If

        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message

        End Try
    End Sub

    Protected Sub lnkEncabezado_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkEncabezado.Click

        Response.Redirect("~/finanzas/ConsArchivosRecibidos.aspx?tipoArchivo=Liquidacion")

    End Sub
End Class
