Imports System.Data

Partial Class Controles_UCInfoPagoRef
    Inherits System.Web.UI.UserControl
    Public Property noReferencia() As String
        Get
            Return viewstate("NO_REFERENCIA")
        End Get
        Set(ByVal Value As String)
            viewstate("NO_REFERENCIA") = Value
        End Set
    End Property

    Public Property noAutorizacion() As String
        Get
            Return viewstate("NO_AUTORIZACION")
        End Get
        Set(ByVal Value As String)
            viewstate("NO_AUTORIZACION") = Value
        End Set
    End Property

    Public Property entidad() As SuirPlus.Empresas.Facturacion.Factura.eConcepto
        Get
            Return ViewState("ENTIDAD")
        End Get
        Set(ByVal Value As SuirPlus.Empresas.Facturacion.Factura.eConcepto)
            ViewState("ENTIDAD") = Value
        End Set
    End Property

    Public Sub mostrarDatos()
        Dim tmpDt As DataTable

        Me.lblCodigoError.Text = String.Empty
        Me.lblNoAutorizacion.Text = String.Empty
        Me.lblEntidadAutorizo.Text = String.Empty
        Me.lblEstatusFacUnipago.Text = String.Empty
        Me.lblFechaAut.Text = String.Empty
        Me.lblFechaEnvio.Text = String.Empty
        Me.lblFechaPago.Text = String.Empty
        Me.lblUsuarioAutorizo.Text = String.Empty

        Me.lblFechaCancela.Text = String.Empty
        Me.lblReferenciaOrigen.Text = String.Empty
        Me.lblFechaDesautorizo.Text = String.Empty
        Me.lblUsuarioDesautorizo.Text = String.Empty
        Me.lblFechaReportePago.Text = String.Empty

        If Me.entidad = SuirPlus.Empresas.Facturacion.Factura.eConcepto.SDSS Then

            tmpDt = SuirPlus.Empresas.Facturacion.Factura.consultaPago(Me.entidad, Me.noReferencia, Me.noAutorizacion)

            If tmpDt.Rows.Count > 0 Then

                With tmpDt.Rows(0)

                    Me.lblCodigoError.Text = IIf(.Item("N_ERROR_CARGA") Is DBNull.Value, "", .Item("N_ERROR_CARGA"))
                    Me.lblNoAutorizacion.Text = IIf(.Item("no_autorizacion") Is DBNull.Value, "", .Item("no_autorizacion"))
                    Me.lblEntidadAutorizo.Text = IIf(.Item("ENTIDAD_RECAUDADORA_DES") Is DBNull.Value, "", .Item("ENTIDAD_RECAUDADORA_DES"))
                    Me.lblEstatusFacUnipago.Text = IIf(.Item("C_STATUS_CARGA") Is DBNull.Value, "", .Item("C_STATUS_CARGA"))
                    Me.lblFechaAut.Text = IIf(.Item("FECHA_AUTORIZACION") Is DBNull.Value, "", .Item("FECHA_AUTORIZACION"))
                    Me.lblFechaEnvio.Text = IIf(.Item("D_FECHA_ENVIO") Is DBNull.Value, "", .Item("D_FECHA_ENVIO"))
                    Me.lblFechaPago.Text = IIf(.Item("FECHA_PAGO") Is DBNull.Value, "", .Item("FECHA_PAGO"))
                    Me.lblUsuarioAutorizo.Text = IIf(.Item("Nombres") Is DBNull.Value, "", .Item("Nombres"))

                    Me.lblFechaCancela.Text = IIf(.Item("FECHA_CANCELA") Is DBNull.Value, "", .Item("FECHA_CANCELA"))
                    Me.lblReferenciaOrigen.Text = IIf(.Item("ID_REFERENCIA_ORIGEN") Is DBNull.Value, "", .Item("ID_REFERENCIA_ORIGEN"))
                    Me.lblFechaDesautorizo.Text = IIf(.Item("FECHA_DESAUTORIZACION") Is DBNull.Value, "", .Item("FECHA_DESAUTORIZACION"))
                    Me.lblUsuarioDesautorizo.Text = IIf(.Item("Nombre_Desautorizo") Is DBNull.Value, "", .Item("Nombre_Desautorizo"))
                    Me.lblFechaReportePago.Text = IIf(.Item("FECHA_REPORTE_PAGO") Is DBNull.Value, "", .Item("FECHA_REPORTE_PAGO"))

                End With

            End If


            Dim tDt As DataTable = SuirPlus.Empresas.Facturacion.Factura.consultaEnvios(Me.noReferencia)

            If tDt.Rows.Count > 1 Then
                Me.DataGrid1.DataSource = tDt
                Me.DataGrid1.DataBind()
                Me.lblTituloEnvio.Visible = True
            Else
                Me.DataGrid1.DataSource = Nothing
                Me.DataGrid1.DataBind()
                Me.lblTituloEnvio.Visible = False
            End If
        ElseIf Me.entidad = SuirPlus.Empresas.Facturacion.Factura.eConcepto.ISR Then
            tmpDt = SuirPlus.Empresas.Facturacion.LiquidacionISR.consultaPago(Me.entidad, Me.noReferencia, Me.noAutorizacion)

            If tmpDt.Rows.Count > 0 Then

                With tmpDt.Rows(0)

                    Me.lblCodigoError.Text = IIf(.Item("N_ERROR_CARGA") Is DBNull.Value, "", .Item("N_ERROR_CARGA"))
                    Me.lblNoAutorizacion.Text = IIf(.Item("no_autorizacion") Is DBNull.Value, "", .Item("no_autorizacion"))
                    Me.lblEntidadAutorizo.Text = IIf(.Item("ENTIDAD_RECAUDADORA_DES") Is DBNull.Value, "", .Item("ENTIDAD_RECAUDADORA_DES"))
                    Me.lblEstatusFacUnipago.Text = IIf(.Item("C_STATUS_CARGA") Is DBNull.Value, "", .Item("C_STATUS_CARGA"))
                    Me.lblFechaAut.Text = IIf(.Item("FECHA_AUTORIZACION") Is DBNull.Value, "", .Item("FECHA_AUTORIZACION"))
                    Me.lblFechaEnvio.Text = IIf(.Item("D_FECHA_ENVIO") Is DBNull.Value, "", .Item("D_FECHA_ENVIO"))
                    Me.lblFechaPago.Text = IIf(.Item("FECHA_PAGO") Is DBNull.Value, "", .Item("FECHA_PAGO"))
                    Me.lblUsuarioAutorizo.Text = IIf(.Item("Nombres") Is DBNull.Value, "", .Item("Nombres"))

                    Me.lblFechaCancela.Text = IIf(.Item("FECHA_CANCELA") Is DBNull.Value, "", .Item("FECHA_CANCELA"))
                    Me.lblReferenciaOrigen.Text = IIf(.Item("ID_REFERENCIA_ORIGEN") Is DBNull.Value, "", .Item("ID_REFERENCIA_ORIGEN"))
                    Me.lblFechaDesautorizo.Text = IIf(.Item("FECHA_DESAUTORIZACION") Is DBNull.Value, "", .Item("FECHA_DESAUTORIZACION"))
                    Me.lblUsuarioDesautorizo.Text = IIf(.Item("Nombre_Desautorizo") Is DBNull.Value, "", .Item("Nombre_Desautorizo"))
                    Me.lblFechaReportePago.Text = IIf(.Item("FECHA_REPORTE_PAGO") Is DBNull.Value, "", .Item("FECHA_REPORTE_PAGO"))

                End With
            End If
        ElseIf Me.entidad = SuirPlus.Empresas.Facturacion.Factura.eConcepto.IR17 Then
            tmpDt = SuirPlus.Empresas.Facturacion.LiquidacionIR17.consultaPago(Me.entidad, Me.noReferencia, Me.noAutorizacion)

            If tmpDt.Rows.Count > 0 Then

                With tmpDt.Rows(0)

                    Me.lblCodigoError.Text = IIf(.Item("N_ERROR_CARGA") Is DBNull.Value, "", .Item("N_ERROR_CARGA"))
                    Me.lblNoAutorizacion.Text = IIf(.Item("no_autorizacion") Is DBNull.Value, "", .Item("no_autorizacion"))
                    Me.lblEntidadAutorizo.Text = IIf(.Item("ENTIDAD_RECAUDADORA_DES") Is DBNull.Value, "", .Item("ENTIDAD_RECAUDADORA_DES"))
                    Me.lblEstatusFacUnipago.Text = IIf(.Item("C_STATUS_CARGA") Is DBNull.Value, "", .Item("C_STATUS_CARGA"))
                    Me.lblFechaAut.Text = IIf(.Item("FECHA_AUTORIZACION") Is DBNull.Value, "", .Item("FECHA_AUTORIZACION"))
                    Me.lblFechaEnvio.Text = IIf(.Item("D_FECHA_ENVIO") Is DBNull.Value, "", .Item("D_FECHA_ENVIO"))
                    Me.lblFechaPago.Text = IIf(.Item("FECHA_PAGO") Is DBNull.Value, "", .Item("FECHA_PAGO"))
                    Me.lblUsuarioAutorizo.Text = IIf(.Item("Nombres") Is DBNull.Value, "", .Item("Nombres"))

                    Me.lblFechaCancela.Text = IIf(.Item("FECHA_CANCELA") Is DBNull.Value, "", .Item("FECHA_CANCELA"))
                    Me.lblReferenciaOrigen.Text = IIf(.Item("ID_REFERENCIA_ORIGEN") Is DBNull.Value, "", .Item("ID_REFERENCIA_ORIGEN"))
                    Me.lblFechaDesautorizo.Text = IIf(.Item("FECHA_DESAUTORIZACION") Is DBNull.Value, "", .Item("FECHA_DESAUTORIZACION"))
                    Me.lblUsuarioDesautorizo.Text = IIf(.Item("Nombre_Desautorizo") Is DBNull.Value, "", .Item("Nombre_Desautorizo"))
                    Me.lblFechaReportePago.Text = IIf(.Item("FECHA_REPORTE_PAGO") Is DBNull.Value, "", .Item("FECHA_REPORTE_PAGO"))

                End With
            End If
        ElseIf Me.entidad = SuirPlus.Empresas.Facturacion.Factura.eConcepto.INF Then
            tmpDt = SuirPlus.Empresas.Facturacion.LiquidacionInfotep.consultaPago(Me.entidad, Me.noReferencia, Me.noAutorizacion)

            If tmpDt.Rows.Count > 0 Then

                With tmpDt.Rows(0)

                    Me.lblCodigoError.Text = IIf(.Item("N_ERROR_CARGA") Is DBNull.Value, "", .Item("N_ERROR_CARGA"))
                    Me.lblNoAutorizacion.Text = IIf(.Item("no_autorizacion") Is DBNull.Value, "", .Item("no_autorizacion"))
                    Me.lblEntidadAutorizo.Text = IIf(.Item("ENTIDAD_RECAUDADORA_DES") Is DBNull.Value, "", .Item("ENTIDAD_RECAUDADORA_DES"))
                    Me.lblEstatusFacUnipago.Text = IIf(.Item("C_STATUS_CARGA") Is DBNull.Value, "", .Item("C_STATUS_CARGA"))
                    Me.lblFechaAut.Text = IIf(.Item("FECHA_AUTORIZACION") Is DBNull.Value, "", .Item("FECHA_AUTORIZACION"))
                    Me.lblFechaEnvio.Text = IIf(.Item("D_FECHA_ENVIO") Is DBNull.Value, "", .Item("D_FECHA_ENVIO"))
                    Me.lblFechaPago.Text = IIf(.Item("FECHA_PAGO") Is DBNull.Value, "", .Item("FECHA_PAGO"))
                    Me.lblUsuarioAutorizo.Text = IIf(.Item("Nombres") Is DBNull.Value, "", .Item("Nombres"))

                    Me.lblFechaCancela.Text = IIf(.Item("FECHA_CANCELA") Is DBNull.Value, "", .Item("FECHA_CANCELA"))
                    Me.lblReferenciaOrigen.Text = IIf(.Item("ID_REFERENCIA_ORIGEN") Is DBNull.Value, "", .Item("ID_REFERENCIA_ORIGEN"))
                    Me.lblFechaDesautorizo.Text = IIf(.Item("FECHA_DESAUTORIZACION") Is DBNull.Value, "", .Item("FECHA_DESAUTORIZACION"))
                    Me.lblUsuarioDesautorizo.Text = IIf(.Item("Nombre_Desautorizo") Is DBNull.Value, "", .Item("Nombre_Desautorizo"))
                    Me.lblFechaReportePago.Text = IIf(.Item("FECHA_REPORTE_PAGO") Is DBNull.Value, "", .Item("FECHA_REPORTE_PAGO"))

                End With
            End If
        ElseIf Me.entidad = SuirPlus.Empresas.Facturacion.Factura.eConcepto.MDT Then
            tmpDt = SuirPlus.Empresas.Facturacion.PlanillaMDT.consultaPago(Me.entidad, Me.noReferencia, Me.noAutorizacion)

            If tmpDt.Rows.Count > 0 Then

                With tmpDt.Rows(0)

                    Me.lblCodigoError.Text = IIf(.Item("N_ERROR_CARGA") Is DBNull.Value, "", .Item("N_ERROR_CARGA"))
                    Me.lblNoAutorizacion.Text = IIf(.Item("no_autorizacion") Is DBNull.Value, "", .Item("no_autorizacion"))
                    Me.lblEntidadAutorizo.Text = IIf(.Item("ENTIDAD_RECAUDADORA_DES") Is DBNull.Value, "", .Item("ENTIDAD_RECAUDADORA_DES"))
                    Me.lblEstatusFacUnipago.Text = IIf(.Item("C_STATUS_CARGA") Is DBNull.Value, "", .Item("C_STATUS_CARGA"))
                    Me.lblFechaAut.Text = IIf(.Item("FECHA_AUTORIZACION") Is DBNull.Value, "", .Item("FECHA_AUTORIZACION"))
                    Me.lblFechaEnvio.Text = IIf(.Item("D_FECHA_ENVIO") Is DBNull.Value, "", .Item("D_FECHA_ENVIO"))
                    Me.lblFechaPago.Text = IIf(.Item("FECHA_PAGO") Is DBNull.Value, "", .Item("FECHA_PAGO"))
                    Me.lblUsuarioAutorizo.Text = IIf(.Item("Nombres") Is DBNull.Value, "", .Item("Nombres"))

                    Me.lblFechaCancela.Text = IIf(.Item("FECHA_CANCELA") Is DBNull.Value, "", .Item("FECHA_CANCELA"))
                    Me.lblReferenciaOrigen.Text = IIf(.Item("ID_REFERENCIA_ORIGEN") Is DBNull.Value, "", .Item("ID_REFERENCIA_ORIGEN"))
                    Me.lblFechaDesautorizo.Text = IIf(.Item("FECHA_DESAUTORIZACION") Is DBNull.Value, "", .Item("FECHA_DESAUTORIZACION"))
                    Me.lblUsuarioDesautorizo.Text = IIf(.Item("Nombre_Desautorizo") Is DBNull.Value, "", .Item("Nombre_Desautorizo"))
                    Me.lblFechaReportePago.Text = IIf(.Item("FECHA_REPORTE_PAGO") Is DBNull.Value, "", .Item("FECHA_REPORTE_PAGO"))

                End With
            End If
        End If

    End Sub
End Class
