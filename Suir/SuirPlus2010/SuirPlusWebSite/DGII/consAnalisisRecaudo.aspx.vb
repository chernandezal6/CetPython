Imports SuirPlus
Imports System.data
Partial Class DGII_consAnalisisRecaudo
    Inherits BasePage

    ' Private Liquidaciones As SuirPlus.Empresas.Facturacion.LiquidacionesISR_IR17
    'Private Liquidacion As SuirPlus.Empresas.Facturacion.LiquidacionesISR_IR17
    Dim dt As DataTable
    Dim factISR As SuirPlus.Empresas.Facturacion.LiquidacionISR = Nothing
    Dim factIR17 As SuirPlus.Empresas.Facturacion.LiquidacionIR17 = Nothing
    Dim factInfotep As SuirPlus.Empresas.Facturacion.LiquidacionInfotep = Nothing
    Private eConcepto As SuirPlus.Empresas.Facturacion.Factura.eConcepto

    Private Sub setFormError(ByVal msg As String)
        Me.lblFormError.Text = "<br>" + msg + "<br>"
    End Sub

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.lblFormError.Text = ""
    End Sub

    Protected Sub btBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btBuscar.Click
        Validar()
    End Sub


    Private Sub Validar()


        If Me.txtNro.Text <> String.Empty And Me.drpTipoConsulta.SelectedValue = "R" Then

            Try
                Me.cargarDatos()
            Catch ex As Exception
                limpiarControles()
                Me.pnlResultado.Visible = False
                Me.lblFormError.Text = "Datos no encontrados"
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

        ElseIf Me.txtNro.Text <> String.Empty And Me.drpTipoConsulta.SelectedValue = "A" Then

            If Not (Utilitarios.Utils.isNroAutorizacionValido(Me.txtNro.Text)) Then
                Me.lblMensaje.Text = "Nro. de Autorización Inválido"
                Exit Sub
            End If

            Try
                Me.cargarAutorizacion()
            Catch ex As Exception
                limpiarControles()
                Me.pnlResultado.Visible = False
                Me.lblFormError.Text = "Datos no encontrados"
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If

    End Sub

    Private Sub cargarDatos()

        Try
            factISR = New Empresas.Facturacion.LiquidacionISR(Me.txtNro.Text)
            If Not factISR.RNC = String.Empty Then
                Me.CargarDatosReferencia("ISR")

                'Else
                '    factIR17 = New Empresas.Facturacion.LiquidacionIR17(Me.txtNro.Text)
                '    If Not factIR17.RNC = String.Empty Then
                '        Me.CargarDatosReferencia("IR17")
            Else
                factInfotep = New Empresas.Facturacion.LiquidacionInfotep(Me.txtNro.Text)
                If Not factInfotep.RNC = String.Empty Then
                    Me.CargarDatosReferencia("INF")
                Else
                    Me.lblFormError.Text = "Datos no encontrados"
                End If
            End If
            'End If

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Throw New Exception(ex.ToString)
        End Try

    End Sub

    Private Sub CargarDatosReferencia(ByVal Tipo_referencia As String)

        Try
            'Dim fact As SuirPlus.Empresas.Facturacion.Factura = Nothing

            If Tipo_referencia = "ISR" Then
                'fact = factISR
                Me.pnlResultado.Visible = True
                Me.lblrnc.Text = Utilitarios.Utils.FormatearRNCCedula(factISR.RNC)
                Me.lblrazonsocial.Text = factISR.RazonSocial
                Me.lblfechaemision.Text = String.Format("{0:d}", factISR.FechaEmision)
                Me.lblIntereses.Text = String.Format("{0:c}", factISR.TotalIntereses)
                Me.lbltotalapagar.Text = String.Format("{0:c}", factISR.TotalGeneral)
                Me.lblnumeroautorizacion.Text = factISR.NroAutorizacion
                Me.lblfechaautorizo.Text = String.Format("{0:d}", factISR.FechaAutorizacion)
                Me.lblfechadesautorizo.Text = String.Format("{0:d}", factISR.FechaDesAutorizacion)
                Me.lblentidadrecaudadora.Text = factISR.EntidadRecaudadora
                Me.lblstatus.Text = factISR.Estatus
                Me.lblusuariodesautorizo.Text = factISR.UsuarioDesAutorizo
                Me.lblusuarioautorizo.Text = factISR.UsuarioAutorizo
                Me.lblimporte.Text = String.Format("{0:c}", factISR.ImpuestoSobreLaRenta)
                Me.lblrecargo.Text = String.Format("{0:c}", factISR.TotalRecargos)
                'ElseIf Tipo_Autorizacion = "IR17" Then
                '    'fact = factIR17
                '    Me.pnlResultado.Visible = True
                '    Me.lblrnc.Text = Utilitarios.Utils.FormatearRNCCedula(factIR17.RNC)
                '    Me.lblrazonsocial.Text = factIR17.RazonSocial
                '    Me.lblfechaemision.Text = String.Format("{0:d}", factIR17.FechaEmision)
                '    Me.lblIntereses.Text = factIR17.TotalIntereses
                '    Me.lbltotalapagar.Text = String.Format("{0:c}", factIR17.TotalGeneral)
                '    Me.lblnumeroautorizacion.Text = factIR17.NroAutorizacion
                '    Me.lblfechaautorizo.Text = String.Format("{0:d}", factIR17.FechaAutorizacion)
                '    Me.lblfechadesautorizo.Text = String.Format("{0:d}", factIR17.FechaDesAutorizacion)
                '    Me.lblentidadrecaudadora.Text = factIR17.EntidadRecaudadora
                '    Me.lblstatus.Text = factIR17.Estatus
                '    Me.lblusuariodesautorizo.Text = factIR17.UsuarioDesautorizo
                '    Me.lblusuarioautorizo.Text = factIR17.UsuarioAutorizo
                '    Me.lblimporte.Text = 0
                '    Me.lblrecargo.Text = factIR17.TotalRecargos
            ElseIf Tipo_referencia = "INF" Then
                ' fact = factInfotep
                Me.pnlResultado.Visible = True
                Me.lblrnc.Text = Utilitarios.Utils.FormatearRNCCedula(factInfotep.RNC)
                Me.lblrazonsocial.Text = factInfotep.RazonSocial
                Me.lblfechaemision.Text = String.Format("{0:d}", factInfotep.FechaEmision)
                Me.lblIntereses.Text = String.Format("{0:c}", factInfotep.TotalIntereses)
                Me.lbltotalapagar.Text = String.Format("{0:c}", factInfotep.TotalGeneral)
                Me.lblnumeroautorizacion.Text = factInfotep.NroAutorizacion
                Me.lblfechaautorizo.Text = String.Format("{0:d}", factInfotep.FechaAutorizacion)
                Me.lblfechadesautorizo.Text = String.Format("{0:d}", factInfotep.FechaDesAutorizacion)
                Me.lblentidadrecaudadora.Text = factInfotep.EntidadRecaudadora
                Me.lblstatus.Text = factInfotep.Estatus
                Me.lblusuariodesautorizo.Text = factInfotep.UsuarioDesautorizo
                Me.lblusuarioautorizo.Text = factInfotep.UsuarioAutorizo
                Me.lblimporte.Text = String.Format("{0:c}", factInfotep.TotalGeneral)
                Me.lblrecargo.Text = String.Format("{0:c}", factInfotep.TotalRecargos)
            End If
            Dim dt As DataTable = Empresas.Facturacion.Factura.getEnviosAnalisisRecaudo(Me.txtNro.Text)

            Me.gvDetalle.DataSource = dt
            Me.gvDetalle.DataBind()
            Me.pnlResultado.Visible = True

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Throw New Exception(ex.ToString)

        End Try

    End Sub

    Private Sub cargarAutorizacion()
        Try
            Dim nroAut As Integer = CInt(Me.txtNro.Text)

            factISR = New Empresas.Facturacion.LiquidacionISR(nroAut)
            If Not factISR.RNC = String.Empty Then
                Me.CargarDatosAutorizacion("ISR")
                'Else
                '    factIR17 = New Empresas.Facturacion.LiquidacionIR17(nroAut)
                '    If Not factIR17.RNC = String.Empty Then
                '        Me.CargarDatosAutorizacion("IR17")
            Else
                factInfotep = New Empresas.Facturacion.LiquidacionInfotep(nroAut)
                If Not factInfotep.RNC = String.Empty Then
                    Me.CargarDatosAutorizacion("INF")
                Else
                    Me.lblFormError.Text = "Datos no encontrados"
                End If
            End If
            'End If

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Throw New Exception(ex.ToString)
        End Try

    End Sub

    Private Sub CargarDatosAutorizacion(ByVal Tipo_Autorizacion As String)

        Try

            ' Dim fact As SuirPlus.Empresas.Facturacion.Factura = Nothing

            If Tipo_Autorizacion = "ISR" Then
                'fact = factISR
                Me.pnlResultado.Visible = True
                Me.lblrnc.Text = Utilitarios.Utils.FormatearRNCCedula(factISR.RNC)
                Me.lblrazonsocial.Text = factISR.RazonSocial
                Me.lblfechaemision.Text = String.Format("{0:d}", factISR.FechaEmision)
                Me.lblIntereses.Text = String.Format("{0:c}", factISR.TotalIntereses)
                Me.lbltotalapagar.Text = String.Format("{0:c}", factISR.TotalGeneral)
                Me.lblnumeroautorizacion.Text = factISR.NroAutorizacion
                Me.lblfechaautorizo.Text = String.Format("{0:d}", factISR.FechaAutorizacion)
                Me.lblfechadesautorizo.Text = String.Format("{0:d}", factISR.FechaDesAutorizacion)
                Me.lblentidadrecaudadora.Text = factISR.EntidadRecaudadora
                Me.lblstatus.Text = factISR.Estatus
                Me.lblusuariodesautorizo.Text = factISR.UsuarioDesAutorizo
                Me.lblusuarioautorizo.Text = factISR.UsuarioAutorizo
                Me.lblimporte.Text = String.Format("{0:c}", factISR.ImpuestoSobreLaRenta)
                Me.lblrecargo.Text = String.Format("{0:c}", factISR.TotalRecargos)
                'ElseIf Tipo_Autorizacion = "IR17" Then
                '    'fact = factIR17
                '    Me.pnlResultado.Visible = True
                '    Me.lblrnc.Text = Utilitarios.Utils.FormatearRNCCedula(factIR17.RNC)
                '    Me.lblrazonsocial.Text = factIR17.RazonSocial
                '    Me.lblfechaemision.Text = String.Format("{0:d}", factIR17.FechaEmision)
                '    Me.lblIntereses.Text = factIR17.TotalIntereses
                '    Me.lbltotalapagar.Text = String.Format("{0:c}", factIR17.TotalGeneral)
                '    Me.lblnumeroautorizacion.Text = factIR17.NroAutorizacion
                '    Me.lblfechaautorizo.Text = String.Format("{0:d}", factIR17.FechaAutorizacion)
                '    Me.lblfechadesautorizo.Text = String.Format("{0:d}", factIR17.FechaDesAutorizacion)
                '    Me.lblentidadrecaudadora.Text = factIR17.EntidadRecaudadora
                '    Me.lblstatus.Text = factIR17.Estatus
                '    Me.lblusuariodesautorizo.Text = factIR17.UsuarioDesautorizo
                '    Me.lblusuarioautorizo.Text = factIR17.UsuarioAutorizo
                '    Me.lblimporte.Text = 0
                '    Me.lblrecargo.Text = factIR17.TotalRecargos
            ElseIf Tipo_Autorizacion = "INF" Then
                ' fact = factInfotep
                Me.pnlResultado.Visible = True
                Me.lblrnc.Text = Utilitarios.Utils.FormatearRNCCedula(factInfotep.RNC)
                Me.lblrazonsocial.Text = factInfotep.RazonSocial
                Me.lblfechaemision.Text = String.Format("{0:d}", factInfotep.FechaEmision)
                Me.lblIntereses.Text = String.Format("{0:c}", factInfotep.TotalIntereses)
                Me.lbltotalapagar.Text = String.Format("{0:c}", factInfotep.TotalGeneral)
                Me.lblnumeroautorizacion.Text = factInfotep.NroAutorizacion
                Me.lblfechaautorizo.Text = String.Format("{0:d}", factInfotep.FechaAutorizacion)
                Me.lblfechadesautorizo.Text = String.Format("{0:d}", factInfotep.FechaDesAutorizacion)
                Me.lblentidadrecaudadora.Text = factInfotep.EntidadRecaudadora
                Me.lblstatus.Text = factInfotep.Estatus
                Me.lblusuariodesautorizo.Text = factInfotep.UsuarioDesautorizo
                Me.lblusuarioautorizo.Text = factInfotep.UsuarioAutorizo
                Me.lblimporte.Text = String.Format("{0:c}", factInfotep.TotalGeneral)
                Me.lblrecargo.Text = String.Format("{0:c}", factInfotep.TotalRecargos)
            End If
            Dim dt As DataTable = Empresas.Facturacion.Factura.getAutAnalisisRecaudo(Me.txtNro.Text)

            Me.gvDetalle.DataSource = dt
            Me.gvDetalle.DataBind()
            Me.pnlResultado.Visible = True


        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Throw New Exception(ex.ToString)
        End Try

    End Sub

    Public Sub limpiarControles()

        dt = New DataTable
        gvDetalle.DataSource = dt
        gvDetalle.DataBind()

        Me.pnlResultado.Visible = False
        Me.txtNro.Text = String.Empty


    End Sub

    Protected Sub btLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btLimpiar.Click
        limpiarControles()

    End Sub
End Class
