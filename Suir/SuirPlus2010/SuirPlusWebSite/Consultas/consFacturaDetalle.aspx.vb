Imports SuirPlus

Partial Class Consultas_consFacturaDetalle
    Inherits BasePage

    Private eConcepto As Empresas.Facturacion.Factura.eConcepto
    Private NroReferencia As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        'Put user code to initialize the page here
        Me.cargarValores()
        Me.MostrarFactura()

    End Sub

    Private Sub cargarValores()

        Me.NroReferencia = Request("nro")

        Select Case LCase(Request("tipo"))
            Case "isr"
                Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.ISR
            Case "sdss"
                Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.SDSS
            Case "inf"
                Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.INF
            Case "mdt"
                Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.MDT
        End Select

    End Sub

    Private Sub MostrarFactura()

        Select Case Me.eConcepto

            Case Empresas.Facturacion.Factura.eConcepto.ISR

                Me.ucLiqISRDetalle.NroReferencia = Me.NroReferencia
                Me.ucLiqISRDetalle.DataBind()
                Me.ucLiqISRDetalle.Visible = True

            Case Empresas.Facturacion.Factura.eConcepto.SDSS

                Dim tipofactura = New Empresas.Facturacion.FacturaSS(Me.NroReferencia).IDTipoFacura




                If tipofactura = "U" Or tipofactura = "L" Then
                    Me.ucNotTssDetalleAuditoria.NroReferencia = Me.NroReferencia
                    Me.ucNotTssDetalleAuditoria.DataBind()
                    Me.ucNotTssDetalleAuditoria.Visible = True
                Else
                    If LCase(Request("sec")) = "dependiente" Then

                        Me.ucDetDepReferencia.IdReferencia = Me.NroReferencia
                        Me.ucDetDepReferencia.DataBind()
                        Me.ucDetDepReferencia.Visible = True
                    ElseIf LCase(Request("sec")) = "ajuste" Then

                        Me.ucDetalleAjuste1.NroReferencia = Me.NroReferencia
                        Me.ucDetalleAjuste1.DataBind()
                        Me.ucDetalleAjuste1.Visible = True
                    Else

                        Me.ucNotTssDetalle.NroReferencia = Me.NroReferencia
                        Me.ucNotTssDetalle.DataBind()
                        Me.ucNotTssDetalle.Visible = True

                    End If
                End If

            Case Empresas.Facturacion.Factura.eConcepto.INF
                Me.ucLiqInfotepDetalle.NroReferencia = Me.NroReferencia
                Me.ucLiqInfotepDetalle.DataBind()
                Me.ucLiqInfotepDetalle.Visible = True

            Case Empresas.Facturacion.Factura.eConcepto.MDT
                Me.ucPlanillasMDTdetalle.NroReferencia = Me.NroReferencia
                Me.ucPlanillasMDTdetalle.DataBind()
                Me.ucPlanillasMDTdetalle.Visible = True

        End Select

    End Sub
End Class
