Imports SuirPlus.Finanzas
Imports System.Data
Imports SuirPlus.XMLBC

Partial Class Finanzas_ConcentracionFondos
    Inherits BasePage
    Private nombreArchivo As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            nombreArchivo = Request.QueryString.Item("Arch")
            CargarConcetracion(nombreArchivo)
        End If


    End Sub

    Private Sub CargarConcetracion(ByVal NombreArchivo As String)

        Dim dt As New DataTable
        Dim concentracion As ArchivoConcentracion

        Try
            concentracion = New ArchivoConcentracion(NombreArchivo)
            'llenamos el encabezado
            If concentracion.NombreArchivo <> String.Empty Then
                Me.fsInfoConcentracion.Visible = True
                lblArchivo.Text = concentracion.NombreArchivo
                lblProceso.Text = concentracion.Proceso
                lblSubProceso.Text = concentracion.SubProceso
                lblFechaTransaccion.Text = concentracion.FechaTransmision
                lblEntidadReceptora.Text = concentracion.EntidadReceptora
                lblLote.Text = concentracion.NroLote
                lblTotalRegistros.Text = concentracion.Numero_Registros
                lblTotalSinAjuste.Text = concentracion.Total_Liquidar_Ajuste
                lblMontoAclarado.Text = concentracion.Monto_Aclarado
                lblTotalAjuste.Text = concentracion.Total_Ajuste
                lblTotalLiquidar.Text = concentracion.Total_Liquidar


                dt = concentracion.getDetalle()

                If dt.Rows.Count > 0 Then

                    Me.gvConcentracion.DataSource = dt
                    Me.gvConcentracion.DataBind()
                Else
                    Me.gvConcentracion.DataSource = Nothing
                    Me.gvConcentracion.DataBind()
                    Me.lblMensaje.Visible = True
                    Me.lblMensaje.Text = "No existe detalle para este registro."
                    Exit Sub
                End If

                dt = Nothing
            Else
                Me.fsInfoConcentracion.Visible = False
            End If


        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message

        End Try
    End Sub

    Protected Sub lnkEncabezado_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkEncabezado.Click

        Response.Redirect("~/finanzas/ConsArchivosRecibidos.aspx?tipoArchivo=Concentracion")

    End Sub
End Class
