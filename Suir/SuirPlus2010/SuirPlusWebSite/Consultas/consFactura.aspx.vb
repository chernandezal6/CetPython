Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.Facturacion
Imports SuirPlus.Utilitarios

Partial Class Consultas_consFactura
    Inherits BasePage

    Protected imprimir As String
    Private NroReferencia As String
    Private NroAutorizacion As Int64
    Private eConcepto As Empresas.Facturacion.Factura.eConcepto

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        imprimir = Request("imp")
        Me.configurar()
        If (Request("nro") <> "") Or (Request("nroaut") <> "") Then
            Me.cargarValores()
        End If
    End Sub

    Private Sub configurar()

        If Me.IsInPermiso("97") Then

            Me.ucLiqISR.isDetalleHabilitado = True
            Me.ucLiqISR.DetalleURL = "consFacturaDetalle.aspx"

            Me.ucNotTSS.isDetalleHabilitado = True
            Me.ucNotTSS.DetalleURL = "consFacturaDetalle.aspx"

            Me.UcIR17Encabezado.isDetalleHabilitado = True

            Me.ucLiqInfotep.isBtnDetalleEnable = True
            Me.ucLiqInfotep.DetalleURL = "consFacturaDetalle.aspx"

            Me.ucPlanillasMDT.isBtnDetalleEnable = True
            Me.ucPlanillasMDT.DetalleURL = "consFacturaDetalle.aspx"

        Else

            Me.ucLiqISR.isDetalleHabilitado = False
            Me.ucNotTSS.isDetalleHabilitado = False
            Me.ucLiqInfotep.isBtnDetalleEnable = False

        End If

        Me.ucInfoPago.Visible = False

    End Sub

    Private Sub cargarValores()


        If Request("nro") <> "" Then

            Me.NroReferencia = Request("nro")
            Me.txtReferencia.Text = Request("nro")
            Me.txtReferencia.Enabled = False
            Me.drpTipoConsulta.SelectedValue = "R"

        ElseIf Request("nroaut") <> "" Then

            Me.NroAutorizacion = Request("nroaut")
            Me.txtReferencia.Text = Request("nroaut")
            Me.txtReferencia.Enabled = False
            Me.drpTipoConsulta.SelectedValue = "A"

        End If

        If Me.txtReferencia.Text <> "" And Me.drpTipoConsulta.SelectedValue = "R" Then

            Select Case Mid(Trim(Me.txtReferencia.Text), 1, 1)
                Case "0"
                    Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.SDSS
                Case "1"
                    Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.SDSS
                Case "2"
                    Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.ISR
                Case "3"
                    Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.IR17
                Case "5"
                    Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.INF
                Case "6"
                    Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.MDT
            End Select


            If Utilitarios.Utils.isNroReferenciaValido(Me.txtReferencia.Text, Me.eConcepto) Then
                Me.NroReferencia = Me.txtReferencia.Text
            Else
                Me.lblMensaje.Text = "Nro. de Referencia Inválido"
                Exit Sub
            End If

        ElseIf Me.txtReferencia.Text <> "" And Me.drpTipoConsulta.SelectedValue = "A" Then

            If Utilitarios.Utils.isNroAutorizacionValido(Me.txtReferencia.Text) Then
                Me.NroAutorizacion = Me.txtReferencia.Text
            Else
                Me.lblMensaje.Text = "Nro. de Autorización Inválido"
                Exit Sub
            End If

        End If

        If Not Me.txtReferencia.Text = String.Empty Then
            Me.mostrarNotificacion()
        End If

    End Sub


    Private Sub mostrarNotificacion()

        If Me.drpTipoConsulta.SelectedValue = "R" Then
            Select Case eConcepto
                Case Empresas.Facturacion.Factura.eConcepto.ISR
                    Me.mostrarLiqISR()
                Case Empresas.Facturacion.Factura.eConcepto.SDSS
                    Me.mostrarNotTSS()
                Case Empresas.Facturacion.Factura.eConcepto.IR17
                    Me.mostrarNotIR17()
                Case Empresas.Facturacion.Factura.eConcepto.INF
                    Me.mostrarInfotep()
                Case Empresas.Facturacion.Factura.eConcepto.MDT
                    Me.mostrarMDT()
            End Select
        Else
            'Buscamos la Referencia en TSS
            Try
                Dim sTemp As Empresas.Facturacion.FacturaSS

                sTemp = New Empresas.Facturacion.FacturaSS(Me.NroAutorizacion)
                If sTemp.NroReferencia <> String.Empty Then
                    Me.eConcepto = Factura.eConcepto.SDSS
                    Me.mostrarNotTSS()
                    Exit Sub
                End If
            Catch ex As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

            'Buscamos la Referencia en ISR
            Try
                Dim sTemp As Empresas.Facturacion.LiquidacionISR

                sTemp = New Empresas.Facturacion.LiquidacionISR(Me.NroAutorizacion)
                If sTemp.NroReferencia <> String.Empty Then
                    Try
                        Me.eConcepto = Factura.eConcepto.ISR
                        Me.mostrarLiqISR()
                    Catch ex As Exception
                        SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                    End Try
                    Exit Sub
                End If
            Catch ex As Exception
            End Try

            'Buscamos la Referencia en IR17
            Try
                Dim sTemp As Empresas.Facturacion.LiquidacionIR17

                sTemp = New Empresas.Facturacion.LiquidacionIR17(Me.NroAutorizacion)
                If sTemp.NroReferencia <> String.Empty Then
                    Me.eConcepto = Factura.eConcepto.IR17
                    Me.mostrarNotIR17()
                    Exit Sub
                End If

            Catch ex As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

            'Buscamos la Referencia en INFOTEP
            Try
                Dim sTemp As Empresas.Facturacion.LiquidacionInfotep

                sTemp = New Empresas.Facturacion.LiquidacionInfotep(Me.NroAutorizacion)
                If sTemp.NroReferencia <> String.Empty Then
                    Me.eConcepto = Factura.eConcepto.INF
                    Me.mostrarInfotep()
                    Exit Sub
                End If
            Catch ex As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try


            'Buscamos la Referencia en MDT
            Try
                Dim sTemp As Empresas.Facturacion.PlanillaMDT

                sTemp = New Empresas.Facturacion.PlanillaMDT(Me.NroAutorizacion)
                If sTemp.NroReferencia <> String.Empty Then
                    Me.eConcepto = Factura.eConcepto.MDT
                    Me.mostrarMDT()
                    Exit Sub
                End If
            Catch ex As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try


            Me.lblMensaje.Text = "Nro. de Autorización Inválido"
        End If
    End Sub

    Private Sub mostrarNotIR17()

        'En caso de que se quiera imprimir la factura.
        If Not imprimir Is Nothing Or Not imprimir = String.Empty Then
            If imprimir.Equals("si") Then
                Dim Script As String = "<script language='javascript'>window.print()</script>"
                Me.ClientScript.RegisterStartupScript(Me.GetType(), "Onload", Script)
                Me.lblTitulo.Visible = False

                UcIR17Encabezado.IsBtnImprimirVisible = False
            End If
        End If

        Me.MostrarControles(Empresas.Facturacion.Factura.eConcepto.IR17)

        Try
            If Me.NroReferencia <> "" Then
                Me.UcIR17Encabezado.NroReferencia = Me.NroReferencia
            ElseIf Me.NroAutorizacion <> 0 Then
                Me.UcIR17Encabezado.NroAutorizacion = Me.NroAutorizacion
            End If

            'Me.UcIR17Encabezado.isPanelInfoPagoVisible = False

            'Verificamos si la referencia esta autorizada para mostrar el panel de pago.
            'If Me.NroAutorizacion = Nothing Then
            '    If Factura.isReferenciaAutorizada(Empresas.Facturacion.Factura.eConcepto.IR17, Me.NroReferencia) Then
            '        Me.UcIR17Encabezado.isPanelInfoPagoVisible = True
            '    End If
            'Else
            '    Me.UcIR17Encabezado.isPanelInfoPagoVisible = True
            'End If

            Me.UcIR17Encabezado.isPanelInfoPagoVisible = True

            Dim str As String = Me.UcIR17Encabezado.MostrarEncabezado()

            If Split(str, "|")(0) <> "0" Then

                Me.MostrarControles("NONE")
                Me.lblMensaje.Text = "No se encontró la referencia."

            End If

        Catch ex As Exception
            Me.MostrarControles("NONE")
            Me.lblMensaje.Text = "No se encontró la referencia."
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub mostrarInfotep()

        'Para el caso que se quiera imprimir la factura
        If Not imprimir Is Nothing Or Not imprimir = String.Empty Then
            If imprimir.Equals("si") Then
                Dim script As String = "<script language='javascript'>window.print()</script>"
                Me.ClientScript.RegisterStartupScript(Me.GetType(), "Onload", script)
                Me.lblTitulo.Visible = False
                Me.ucLiqInfotep.isBtnImprimirVisible = False
            End If
        End If

        Me.MostrarControles(Empresas.Facturacion.Factura.eConcepto.INF)

        Try

            If Me.NroReferencia <> "" Then
                Me.ucLiqInfotep.NroReferencia = Me.NroReferencia
            ElseIf Me.NroAutorizacion <> 0 Then
                Me.ucLiqInfotep.NroAutorizacion = Me.NroAutorizacion
            End If

            Dim str As String = Me.ucLiqInfotep.MostrarEncabezado()

            If Split(str, "|")(0).Equals("1") Then
                Me.ucLiqInfotep.Visible = False
                Me.ucInfoPago.Visible = False
                Me.lblMensaje.Text = Split(str, "|")(1)
                Exit Sub
            End If

            'Verificamos si la referencia esta autorizada para mostrar el panel de pago.
            'If Me.NroAutorizacion = Nothing Then
            '    If Factura.isReferenciaAutorizada(Empresas.Facturacion.Factura.eConcepto.INF, Me.NroReferencia) Then
            '        mostrarInfoPago()
            '    End If
            'Else
            '    mostrarInfoPago()
            'End If

            mostrarInfoPago()

        Catch ex As Exception
            Me.MostrarControles("NONE")
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub


    Private Sub mostrarMDT()

        'Para el caso que se quiera imprimir la factura
        If Not imprimir Is Nothing Or Not imprimir = String.Empty Then
            If imprimir.Equals("si") Then
                Dim script As String = "<script language='javascript'>window.print()</script>"
                Me.ClientScript.RegisterStartupScript(Me.GetType(), "Onload", script)
                Me.lblTitulo.Visible = False
                Me.ucPlanillasMDT.isBtnImprimirVisible = False
            End If
        End If

        Me.MostrarControles(Empresas.Facturacion.Factura.eConcepto.MDT)

        Try

            If Me.NroReferencia <> "" Then
                Me.ucPlanillasMDT.NroReferencia = Me.NroReferencia
            ElseIf Me.NroAutorizacion <> 0 Then
                Me.ucPlanillasMDT.NroAutorizacion = Me.NroAutorizacion
            End If

            Dim str As String = Me.ucPlanillasMDT.MostrarEncabezado()

            If Split(str, "|")(0).Equals("1") Then
                Me.ucPlanillasMDT.Visible = False
                Me.ucInfoPago.Visible = False
                Me.lblMensaje.Text = Split(str, "|")(1)
                Exit Sub
            End If

            'Verificamos si la referencia esta autorizada para mostrar el panel de pago.
            'If Me.NroAutorizacion = Nothing Then
            '    If Factura.isReferenciaAutorizada(Empresas.Facturacion.Factura.eConcepto.INF, Me.NroReferencia) Then
            '        mostrarInfoPago()
            '    End If
            'Else
            '    mostrarInfoPago()
            'End If

            mostrarInfoPago()

        Catch ex As Exception
            Me.MostrarControles("NONE")
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub mostrarNotTSS()

        'En caso de que se quiera imprimir la factura.
        If Not imprimir Is Nothing Or Not imprimir = String.Empty Then

            If imprimir.Equals("si") Then
                Dim Script As String = "<script language='javascript'>window.print()</script>"
                Me.ClientScript.RegisterStartupScript(Me.GetType(), "Onload", Script)
                Me.lblTitulo.Visible = False
                ucNotTSS.isBotonesVisibles = False
            End If
        
        End If

        Me.MostrarControles(Empresas.Facturacion.Factura.eConcepto.SDSS)

        If Me.NroReferencia <> "" Then
            Me.ucNotTSS.NroReferencia = Me.NroReferencia
        ElseIf Me.NroAutorizacion <> 0 Then
            Me.ucNotTSS.NroAutorizacion = Me.NroAutorizacion
        End If

        Dim str As String = Me.ucNotTSS.MostrarEncabezado()

        If Split(str, "|")(0) = "0" Then

            ''Verificamos si la referencia esta autorizada para mostrar el panel de pago.
            'If Me.NroAutorizacion = Nothing Then
            '    If Factura.isReferenciaAutorizada(Empresas.Facturacion.Factura.eConcepto.SDSS, Me.NroReferencia) Then
            '        mostrarInfoPago()
            '    End If
            'Else
            '    mostrarInfoPago()
            'End If

            mostrarInfoPago()

        Else

            Me.MostrarControles("NONE")
            Me.lblMensaje.Text = "No se encontró la referencia. " & "<BR>" & str

        End If

    End Sub

    Private Sub mostrarLiqISR()

        'En caso de que se quiera imprimir la factura.
        If Not imprimir Is Nothing Or Not imprimir = String.Empty Then

            If imprimir.Equals("si") Then

                Dim Script As String = "<script language='javascript'>window.print()</script>"
                Me.ClientScript.RegisterStartupScript(Me.GetType(), "Onload", Script)
                Me.lblTitulo.Visible = False

                ucLiqISR.isBotonesVisibles = False

            End If

        End If

        Me.MostrarControles(Empresas.Facturacion.Factura.eConcepto.ISR)

        If Me.NroReferencia <> "" Then
            Me.ucLiqISR.NroReferencia = Me.NroReferencia
        ElseIf Me.NroAutorizacion <> 0 Then
            Me.ucLiqISR.NroAutorizacion = Me.NroAutorizacion
        End If

        Me.ucInfoPago.Visible = False

        Dim str As String = Me.ucLiqISR.MostrarEncabezado()

        If Split(str, "|")(0) = "0" Then

            'Verificamos si la referencia esta autorizada para mostrar el panel de pago.
            'If Me.NroAutorizacion = Nothing Then
            '    If Factura.isReferenciaAutorizada(Empresas.Facturacion.Factura.eConcepto.ISR, Me.NroReferencia) Then
            '        mostrarInfoPago()
            '    End If
            'Else
            '    mostrarInfoPago()
            'End If

            mostrarInfoPago()

        Else

            Me.MostrarControles("NONE")
            Me.lblMensaje.Text = "No se encontró la referencia."

        End If

    End Sub

    Private Sub mostrarInfoPago()

        Me.ucInfoPago.Visible = True
        Me.ucInfoPago.noReferencia = Me.NroReferencia
        Me.ucInfoPago.noAutorizacion = Me.NroAutorizacion
        Me.ucInfoPago.entidad = Me.eConcepto
        Me.ucInfoPago.mostrarDatos()

    End Sub

    Private Sub btBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btBuscar.Click

        txtReferencia.Enabled = False
        Me.cargarValores()

    End Sub

    Protected Sub btLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btLimpiar.Click

        'Me.txtReferencia.Text = String.Empty
        'Me.lblMensaje.Text = String.Empty
        'Me.MostrarControles("NONE")
        Response.Redirect("consfactura.aspx")

    End Sub

    Private Sub MostrarControles(ByVal tipo As String)
        Select Case tipo
            Case Empresas.Facturacion.Factura.eConcepto.SDSS

                Me.ucNotTSS.Visible = True
                Me.ucLiqISR.Visible = False
                Me.ucLiqInfotep.Visible = False
                Me.UcIR17Encabezado.Visible = False
                Me.ucPlanillasMDT.Visible = False
            Case Empresas.Facturacion.Factura.eConcepto.ISR

                Me.ucLiqISR.Visible = True
                Me.ucNotTSS.Visible = False
                Me.UcIR17Encabezado.Visible = False
                Me.ucLiqInfotep.Visible = False
                Me.ucInfoPago.Visible = False
                Me.ucPlanillasMDT.Visible = False
            Case Empresas.Facturacion.Factura.eConcepto.IR17

                Me.UcIR17Encabezado.Visible = True
                Me.ucNotTSS.Visible = False
                Me.ucLiqISR.Visible = False
                Me.ucLiqInfotep.Visible = False
                Me.ucPlanillasMDT.Visible = False
            Case Empresas.Facturacion.Factura.eConcepto.INF

                Me.ucLiqInfotep.Visible = True
                Me.ucNotTSS.Visible = False
                Me.ucLiqISR.Visible = False
                Me.UcIR17Encabezado.Visible = False
                Me.ucPlanillasMDT.Visible = False

            Case Empresas.Facturacion.Factura.eConcepto.MDT
                Me.ucPlanillasMDT.Visible = True
                Me.ucLiqInfotep.Visible = False
                Me.ucNotTSS.Visible = False
                Me.ucLiqISR.Visible = False
                Me.UcIR17Encabezado.Visible = False

            Case "NONE"

                Me.ucNotTSS.Visible = False
                Me.ucLiqISR.Visible = False
                Me.UcIR17Encabezado.Visible = False
                Me.ucLiqInfotep.Visible = False
                Me.ucInfoPago.Visible = False
                Me.ucPlanillasMDT.Visible = False

        End Select
    End Sub

End Class
