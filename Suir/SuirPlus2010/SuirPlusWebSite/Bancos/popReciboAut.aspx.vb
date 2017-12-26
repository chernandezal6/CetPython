Imports SuirPlus
Partial Class Bancos_popReciboAut
    Inherits System.Web.UI.Page

    Private eConcepto As Empresas.Facturacion.Factura.eConcepto


    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Dim tt As String = Request("tt")

        Select Case tt
            Case "SDSS"
                Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.SDSS
            Case "ISR"
                Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.ISR
            Case "IR17"
                Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.IR17
            Case "INF"
                Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.INF
        End Select

        If Not Page.IsPostBack Then
            Me.cargaInicial(Request("nroref"))
        End If

    End Sub

    Private Sub cargaInicial(ByVal NroRef As String)

        Dim fc As Empresas.Facturacion.Factura = Nothing

        Select Case Me.eConcepto
            Case Empresas.Facturacion.Factura.eConcepto.ISR
                fc = New Empresas.Facturacion.LiquidacionISR(NroRef)
                Me.imgTitle.Src = Application("urlLogoDGII")
                Me.imgTitle2.Src = Application("urlLogoDGII")

                Me.lblTituloV.Text = "Volante de Pago de Retenciones ISR"
                Me.lblTituloV2.Text = "Volante de Pago de Retenciones ISR"

                Me.lblNroAut.Text = CType(fc, Empresas.Facturacion.LiquidacionISR).NroAutorizacionFormateado
                Me.lblNroAut2.Text = CType(fc, Empresas.Facturacion.LiquidacionISR).NroAutorizacionFormateado

            Case Empresas.Facturacion.Factura.eConcepto.SDSS

                Try
                    fc = New Empresas.Facturacion.FacturaSS(NroRef)
                Catch ex As Exception
                    Response.Write("Error en el Sistema, favor contactar a Mesa de Ayuda al 809-567-5049 ext3043." & "<br>")
                    Response.Write(NroRef)
                    Response.Write(ex.ToString)
                    Response.End()
                    SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                    Exit Sub

                End Try

                Me.imgTitle.Src = Application("urlLogoTSS")
                Me.imgTitle2.Src = Application("urlLogoTSS")

                Me.lblTituloV.Text = "Volante de Pago de la Seguridad Social"
                Me.lblTituloV2.Text = "Volante de Pago de la Seguridad Social"

                Me.lblNroAut.Text = fc.NroAutorizacion
                Me.lblNroAut2.Text = fc.NroAutorizacion

            Case Empresas.Facturacion.Factura.eConcepto.IR17

                fc = New Empresas.Facturacion.LiquidacionIR17(NroRef)
                Me.imgTitle.Src = Application("urlLogoDGII")
                Me.imgTitle2.Src = Application("urlLogoDGII")

                Me.lblTituloV.Text = "Volante de Pago de Declaración IR17"
                Me.lblTituloV2.Text = "Volante de Pago de Declaración IR17"

                Me.lblNroAut.Text = fc.NroAutorizacion
                Me.lblNroAut2.Text = fc.NroAutorizacion
                Me.lblTxtTipoFactura.Visible = False
                Me.lblTxtTipoFactura2.Visible = False

            Case Empresas.Facturacion.Factura.eConcepto.INF

                fc = New Empresas.Facturacion.LiquidacionInfotep(NroRef)
                Me.imgTitle.Src = Application("urlLogoINF")
                Me.imgTitle2.Src = Application("urlLogoINF")

                Me.lblTituloV.Text = "Volante de Pago del INFOTEP"
                Me.lblTituloV2.Text = "Volante de Pago del INFOTEP"

                Me.lblNroAut.Text = fc.NroAutorizacion
                Me.lblNroAut2.Text = fc.NroAutorizacion
                Me.lblTxtTipoFactura.Visible = False
                Me.lblTxtTipoFactura2.Visible = False

        End Select

        Me.lblInstitucionAutoriza.Text = fc.EntidadRecaudadora
        Me.lblFecha.Text = fc.FechaAutorizacion
        Me.lblImportePagar.Text = System.String.Format("{0:C}", fc.TotalGeneral)
        Me.lblNomina.Text = fc.Nomina
        Me.lblNroDeReferencia.Text = fc.NroReferenciaFormateado
        Me.lblPeriodo.Text = fc.PeriodoFormateado
        Me.lblRazonSocial.Text = fc.RazonSocial
        Me.lblRNC.Text = fc.RNC
        Me.lblTipoFactura.Text = fc.TipoFactura
        Me.lblRNC.Text = fc.RNC
        Me.lblRazonSocial.Text = fc.RazonSocial
        If Me.eConcepto <> Empresas.Facturacion.Factura.eConcepto.IR17 Then Me.lblNomina.Text = fc.IDNomina & " - " & fc.Nomina
        Me.lblTipoFactura.Text = fc.TipoFactura

        'Info para la copia de abajo

        Me.lblInstitucionAutoriza2.Text = fc.EntidadRecaudadora
        Me.lblFecha2.Text = fc.FechaAutorizacion
        Me.lblImportePagar2.Text = System.String.Format("{0:C}", fc.TotalGeneral)
        Me.lblNomina2.Text = fc.Nomina
        Me.lblNroDeReferencia2.Text = fc.NroReferenciaFormateado
        Me.lblPeriodo2.Text = fc.PeriodoFormateado
        Me.lblRazonSocial2.Text = fc.RazonSocial
        Me.lblRNC2.Text = fc.RNC
        Me.lblTipoFactura2.Text = fc.TipoFactura
        Me.lblRNC2.Text = fc.RNC
        Me.lblRazonSocial2.Text = fc.RazonSocial
        If Me.eConcepto <> Empresas.Facturacion.Factura.eConcepto.IR17 Then Me.lblNomina2.Text = fc.IDNomina & " - " & fc.Nomina
        Me.lblTipoFactura2.Text = fc.TipoFactura

        If Me.eConcepto <> Empresas.Facturacion.Factura.eConcepto.SDSS Then
            Me.lblNomina.Visible = False
            Me.lblNomina2.Visible = False
            Me.lblNominaText.Visible = False
            Me.lblNominaText2.Visible = False
        End If

    End Sub

End Class
