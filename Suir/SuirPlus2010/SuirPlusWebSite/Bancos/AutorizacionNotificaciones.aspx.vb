Imports System.Data
Imports SuirPlus
Partial Class Bancos_AutorizacionNotificaciones
    Inherits BasePage

    Private myFact As Empresas.Facturacion.Factura
    Private eConcepto As SuirPlus.Empresas.Facturacion.Factura.eConcepto

    Public Function EvaluarBoton(ByVal Entrada As String) As Boolean

        If Entrada.ToUpper.Trim = "S" Then
            Return True
        Else
            Return False
        End If

    End Function

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim tt As String = Request("tt")

        Select Case tt
            Case "SDSS"
                Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.SDSS
                Me.imgLogo.Src = Me.urlLogoTSS
            Case "ISR"
                Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.ISR
                Me.imgLogo.Src = Me.urlLogoDGII
            Case "IR17"
                Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.IR17
                Me.imgLogo.Src = Me.urlLogoDGII
            Case "INF"
                Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.INF
                Me.imgLogo.Src = Me.urlLogoINF
            Case Else
                Response.Redirect(FormsAuthentication.LoginUrl)
        End Select

    End Sub

    Protected Sub btBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btBuscar.Click

        Select Case Me.eConcepto
            Case Empresas.Facturacion.Factura.eConcepto.SDSS
                Me.BuscarNotificacionesTSS()
            Case Empresas.Facturacion.Factura.eConcepto.ISR
                BuscarNotificacionesISR()
            Case Empresas.Facturacion.Factura.eConcepto.IR17
                BuscarNotificacionesIR17()
            Case Empresas.Facturacion.Factura.eConcepto.INF
                BuscarNotificacionesINF()
        End Select

    End Sub

    Public Sub BuscarNotificacionesTSS()
        Dim dt As DataTable
        Dim RazonSocial As String = ""
        Dim NombreComercial As String = ""

        If (Me.txtReferencia.Text = String.Empty) And (Me.txtRNC.Text = String.Empty) Then
            Me.MostrarError("Debe digitar un RNC o una Referencia válida")
            Exit Sub
        ElseIf (Me.txtReferencia.Text.Length = 16) Then

            Try
                Dim fac As New Empresas.Facturacion.FacturaSS(Me.txtReferencia.Text)
                Me.txtRNC.Text = Replace(fac.RNC, "-", "")
            Catch ex As Exception
                Me.MostrarError("No existen registros para esta referencia")
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If


            dt = Empresas.Facturacion.Factura.getRefsDisponiblesParaPago(Me.txtRNC.Text, Empresas.Facturacion.Factura.eConcepto.SDSS, RazonSocial, NombreComercial)

            If dt.Rows.Count > 0 Then
                Me.lblTSS.Visible = True
                Me.dgFacturas.DataSource = dt
                Me.dgFacturas.DataBind()
                Me.lblNombreComercial.Text = NombreComercial
                Me.lblRazonSocial.Text = RazonSocial
                Me.pnlSDSS.Visible = True
                Me.pnlInfoEmp.Visible = True
            Else
                Me.lblTSS.Visible = False
                Me.pnlSDSS.Visible = False
                Me.pnlInfoEmp.Visible = False
                RazonSocial = ""
                NombreComercial = ""
                Me.MostrarError("No existen notificaciones pendientes de autorizar")
                Exit Sub
            End If



    End Sub
    Public Sub BuscarNotificacionesISR()
        If Me.txtReferencia.Text.Length = 16 Then

            Try
                Dim fac As New Empresas.Facturacion.LiquidacionISR(Me.txtReferencia.Text)
                Me.txtRNC.Text = Replace(fac.RNC, "-", "")
            Catch ex As Exception
                Me.MostrarError(ex.ToString())
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

        End If

        Dim dt As DataTable
        Dim RazonSocial As String = ""
        Dim NombreComercial As String = ""

        dt = Empresas.Facturacion.Factura.getRefsDisponiblesParaPago(Me.txtRNC.Text, Empresas.Facturacion.Factura.eConcepto.ISR, RazonSocial, NombreComercial)
        If RazonSocial = "null" Then RazonSocial = String.Empty
        If NombreComercial = "null" Then NombreComercial = String.Empty

        If SuirPlus.Utilitarios.Utils.HayErrorEnDataTable(dt) = False Then

            If dt.Rows.Count = 0 Then
                Me.lblISR.Visible = False
                Me.MostrarError("No existen liquidaciones pendientes de autorizar")
            Else
                Me.lblISR.Visible = True
            End If


            Me.gvISR.DataSource = dt
            Me.gvISR.DataBind()
            Me.lblNombreComercial.Text = NombreComercial
            Me.lblRazonSocial.Text = RazonSocial
            Me.pnlISR.Visible = True
            Me.pnlInfoEmp.Visible = True
            Me.gvISR.Visible = True

        Else

            Me.lblMensajeError.Visible = True
            Me.lblMensajeError.Text = "<br>" & SuirPlus.Utilitarios.Utils.sacarMensajeDeErrorDesdeTabla(dt)
            Me.pnlISR.Visible = False
            Me.pnlInfoEmp.Visible = False

        End If
    End Sub
    Public Sub BuscarNotificacionesIR17()

        If Me.txtReferencia.Text.Length = 16 Then

            Try
                Dim fac As New Empresas.Facturacion.LiquidacionIR17(Me.txtReferencia.Text)
                Me.txtRNC.Text = Replace(fac.RNC, "-", "")
            Catch ex As Exception
                Me.MostrarError(ex.ToString())
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

        End If

        Dim dt As DataTable
        Dim RazonSocial As String = ""
        Dim NombreComercial As String = ""

        dt = Empresas.Facturacion.Factura.getRefsDisponiblesParaPago(Me.txtRNC.Text, Empresas.Facturacion.Factura.eConcepto.IR17, RazonSocial, NombreComercial)
        If RazonSocial = "null" Then RazonSocial = String.Empty
        If NombreComercial = "null" Then NombreComercial = String.Empty
        If SuirPlus.Utilitarios.Utils.HayErrorEnDataTable(dt) = False Then

            If dt.Rows.Count = 0 Then
                Me.lblIR17.Visible = False
                Me.MostrarError("No existen liquidaciones pendientes de autorizar")
            Else
                Me.lblIR17.Visible = True
            End If

            Me.gvIR17.DataSource = dt
            Me.gvIR17.DataBind()
            Me.lblNombreComercial.Text = NombreComercial
            Me.lblRazonSocial.Text = RazonSocial
            Me.pnlIR17.Visible = True
            Me.pnlInfoEmp.Visible = True
            Me.gvIR17.Visible = True

        Else

            Me.lblMensajeError.Visible = True
            Me.lblMensajeError.Text = "<br>" & SuirPlus.Utilitarios.Utils.sacarMensajeDeErrorDesdeTabla(dt)
            Me.pnlIR17.Visible = False
            Me.pnlInfoEmp.Visible = False

        End If
    End Sub
    Public Sub BuscarNotificacionesINF()

        If Me.txtReferencia.Text.Length = 16 Then

            Try
                Dim fac As New Empresas.Facturacion.LiquidacionInfotep(Me.txtReferencia.Text)
                Me.txtRNC.Text = Replace(fac.RNC, "-", "")
            Catch ex As Exception
                Me.MostrarError(ex.Message)
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                Me.pnlInfotep.Visible = False
                Me.pnlInfoEmp.Visible = False
                Exit Sub
            End Try

        End If

        Dim dt As DataTable
        Dim RazonSocial As String = ""
        Dim NombreComercial As String = ""

        dt = Empresas.Facturacion.Factura.getRefsDisponiblesParaPago(Me.txtRNC.Text, Empresas.Facturacion.Factura.eConcepto.INF, RazonSocial, NombreComercial)
        If RazonSocial = "null" Then RazonSocial = String.Empty
        If NombreComercial = "null" Then NombreComercial = String.Empty

        If SuirPlus.Utilitarios.Utils.HayErrorEnDataTable(dt) = False Then

            If dt.Rows.Count = 0 Then
                Me.lblINF.Visible = False
                Me.MostrarError("No existen liquidaciones pendientes de autorizar")
            Else
                Me.lblINF.Visible = True
            End If

            Me.gvINFOTEP.DataSource = dt
            Me.gvINFOTEP.DataBind()
            Me.lblNombreComercial.Text = NombreComercial
            Me.lblRazonSocial.Text = RazonSocial
            Me.pnlInfoEmp.Visible = True
            Me.pnlInfotep.Visible = True
            Me.gvINFOTEP.Visible = True

        Else

            Me.lblMensajeError.Visible = True
            Me.lblMensajeError.Text = "<br>" & SuirPlus.Utilitarios.Utils.sacarMensajeDeErrorDesdeTabla(dt)
            Me.pnlInfotep.Visible = False
            Me.pnlInfoEmp.Visible = False

        End If
    End Sub

    Private Sub AutorizarFactura(ByVal NroReferencia As String)

        If NroReferencia = "" Then

            SuirPlus.Exepciones.Log.LogToDB("Error en el Banco.1")
            Response.Write("Error al autorizar la referencia, favor llamar a Mesa de Ayuda al 809.567.5049 ext 3043")
            Response.Write("<br>")
            Response.Write("1")
            Response.End()

        End If

        Select Case eConcepto
            Case Empresas.Facturacion.Factura.eConcepto.ISR
                Me.myFact = New Empresas.Facturacion.LiquidacionISR(NroReferencia)
            Case Empresas.Facturacion.Factura.eConcepto.SDSS
                Me.myFact = New Empresas.Facturacion.FacturaSS(NroReferencia)
            Case Empresas.Facturacion.Factura.eConcepto.IR17
                Me.myFact = New Empresas.Facturacion.LiquidacionIR17(NroReferencia)
            Case Empresas.Facturacion.Factura.eConcepto.INF
                Me.myFact = New Empresas.Facturacion.LiquidacionInfotep(NroReferencia)
        End Select

        Dim resultado As String = Me.myFact.AutorizarFactura(Me.UsrUserName)

        If NroReferencia = "" Then

            SuirPlus.Exepciones.Log.LogToDB("Error en el Banco.2")
            Response.Write("Error al autorizar la referencia, favor llamar a Mesa de Ayuda al 809.567.5049 ext 3043")
            Response.Write("<br>")
            Response.Write("2")
            Response.End()

        End If

        If resultado = "0" Then
            ' La factura fue autorizada
            If NroReferencia = "" Then

                SuirPlus.Exepciones.Log.LogToDB("Error en el Banco.3")
                Response.Write("Error al autorizar la referencia, favor llamar a Mesa de Ayuda al 809.567.5049 ext 3043")
                Response.Write("<br>")
                Response.Write("3")
                Response.End()

            End If

            Me.MostrarRecibo(NroReferencia)

            If NroReferencia = "" Then

                SuirPlus.Exepciones.Log.LogToDB("Error en el Banco.4")
                Response.Write("Error al autorizar la referencia, favor llamar a Mesa de Ayuda al 809.567.5049 ext 3043")
                Response.Write("<br>")
                Response.Write("4")
                Response.End()

            End If

            Me.btBuscar_Click(New Object, Nothing)


        Else
            ' La factura no pudo ser autorizada
            If resultado = "999" Then
                resultado = "Existen otras referenciones anteriores (mas viejas) que debe pagar primero."
            End If
            Me.MostrarError(resultado)
        End If

    End Sub
    Private Sub MostrarRecibo(ByVal NroReferencia As String)

        Dim popupScript As String = "<script language='javascript'>" & _
          "window.open('popReciboAut.aspx?nroref=" + NroReferencia + "&tt=" + Request("tt") + "', 'CustomPopUp', " & _
          "'width=680, height=600, menubar=no, resizable=no')" & _
          "</script>"

        ClientScript.RegisterStartupScript(Me.GetType(), "PopupScript", popupScript)
    End Sub
    Protected Sub dgFacturas_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgFacturas.RowCommand, gvISR.RowCommand, gvIR17.RowCommand, gvINFOTEP.RowCommand

        Dim NroReferencia As String = e.CommandArgument.ToString()
        Me.AutorizarFactura(NroReferencia)

    End Sub

    Private Sub MostrarError(ByVal mensaje As String)

        Me.lblMensajeError.Text = mensaje
        Me.lblMensajeError.Visible = True

    End Sub
End Class
