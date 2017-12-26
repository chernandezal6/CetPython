Imports SuirPlus

Partial Class Bancos_consFacturas
    Inherits BasePage

    Private myEmp As Empresas.Empleador
    Private myFact As Empresas.Facturacion.Factura
    Private eConcepto As Empresas.Facturacion.Factura.eConcepto
    Private totalFacturas As Decimal
    Private IDNominaNew As Int64
    Private IDNominaOld As Int64

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Page.IsPostBack Then
            'Me.myFact = Session("myFact")
            Me.myEmp = Session("myEmp")
        End If

        Me.txtReferencia.Attributes.Add("onkeyup", "BorrarRNC();")
        Me.txtReferencia.Attributes.Add("onchange", "BorrarRNC();")
        Me.txtRNC.Attributes.Add("onkeyup", "BorrarRef();")
        Me.txtRNC.Attributes.Add("onchange", "BorrarRef();")
        Me.ddlNominas.Attributes.Add("onchange", "HabilitarBuscar();")

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

                Me.ddlNominas.Enabled = False
            Case "INF"

                Me.eConcepto = Empresas.Facturacion.Factura.eConcepto.INF
                Me.imgLogo.Src = Me.urlLogoINF

                Me.ddlNominas.Enabled = False

            Case Else
                Response.Redirect(FormsAuthentication.LoginUrl)
                ''Throw New Exception("Error de Seguridad.")
        End Select

        Me.dgFacturas.Visible = True

    End Sub

    Private Sub btBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btBuscar.Click

        If Me.txtReferencia.Text <> "" Then

            'Try
            '    Me.busquedaPorReferencia()
            'Catch ex As Exception
            '    Me.MostrarError(ex.Message)
            '    SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            '    Exit Sub
            'End Try

            'MostrarInfo()

            'Me.ddlNominas.Visible = False
            'Me.Label1.Visible = False
            Try
                Select Case eConcepto
                    Case Empresas.Facturacion.Factura.eConcepto.ISR
                        Me.myFact = New Empresas.Facturacion.LiquidacionISR(Me.txtReferencia.Text)
                    Case Empresas.Facturacion.Factura.eConcepto.SDSS
                        Me.myFact = New Empresas.Facturacion.FacturaSS(Me.txtReferencia.Text)
                    Case Empresas.Facturacion.Factura.eConcepto.IR17
                        Me.myFact = New Empresas.Facturacion.LiquidacionIR17(Me.txtReferencia.Text)
                    Case Empresas.Facturacion.Factura.eConcepto.INF
                        Me.myFact = New Empresas.Facturacion.LiquidacionInfotep(Me.txtReferencia.Text)
                End Select

            Catch ex As Exception

                Me.lblMensajeError.Text = ex.Message.ToString()
                Me.lblMensajeError.Visible = True

                Me.dgFacturas.Visible = False
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())

                Exit Sub
            End Try
            Try

                Me.myEmp = New Empresas.Empleador(Me.myFact.RegistroPatronal)

            Catch ex As Exception
                Me.MostrarError("Este Nro. de Referencia no existe")
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
            Me.txtRNC.Text = Me.myEmp.RNCCedula

            Try
                buscarNominas()
            Catch ex As Exception
                Me.MostrarError("RNC o Cedula Invalido")
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                Exit Sub
            End Try

            MostrarInfo()

            busquedaPorRNC()
            Me.txtReferencia.Text = ""

        ElseIf Me.txtRNC.Text <> "" Then

            busquedaPorRNC()
            MostrarInfo()

        End If

    End Sub

    Private Sub MostrarInfo()

        Me.lblRNC.Visible = True
        Me.lbltxtRNC.Visible = True
        Me.lbltxtRNC2.Visible = True
        Me.lblTXTNombreComercial.Visible = True
        Me.lblNombreComercial.Visible = True
        Me.lblRazonSocial.Visible = True
        Me.label8.Visible = True
        Me.Label1.Visible = True
        Me.ddlNominas.Visible = True

    End Sub

    Private Sub busquedaPorReferencia()

        Me.ddlNominas.Items.Clear()

        Select Case eConcepto
            Case Empresas.Facturacion.Factura.eConcepto.ISR
                Me.myFact = New Empresas.Facturacion.LiquidacionISR(Me.txtReferencia.Text)
            Case Empresas.Facturacion.Factura.eConcepto.SDSS
                Me.myFact = New Empresas.Facturacion.FacturaSS(Me.txtReferencia.Text)
            Case Empresas.Facturacion.Factura.eConcepto.IR17
                Me.myFact = New Empresas.Facturacion.LiquidacionIR17(Me.txtReferencia.Text)
            Case Empresas.Facturacion.Factura.eConcepto.INF
                Me.myFact = New Empresas.Facturacion.LiquidacionInfotep(Me.txtReferencia.Text)
        End Select

        Me.myEmp = New Empresas.Empleador(Me.myFact.RegistroPatronal)

        Me.lblRNC.Text = Me.myEmp.RNCCedula

        If lblRNC.Text <> String.Empty Then
            Me.btnCancelar.Visible = True
        End If

        Me.lblNombreComercial.Text = Me.myEmp.NombreComercial
        Me.lblRazonSocial.Text = Me.myEmp.RazonSocial

        Dim dt As Data.DataTable = Empresas.Facturacion.Factura.getNotificacionesPendientePago(eConcepto, Me.txtReferencia.Text)

        Try

            If dt.Rows.Count = 0 Then

                Dim fc As Empresas.Facturacion.Factura = Nothing

                Select Case eConcepto
                    Case Empresas.Facturacion.Factura.eConcepto.ISR
                        fc = New Empresas.Facturacion.LiquidacionISR(Me.txtReferencia.Text)
                    Case Empresas.Facturacion.Factura.eConcepto.SDSS
                        fc = New Empresas.Facturacion.FacturaSS(Me.txtReferencia.Text)
                    Case Empresas.Facturacion.Factura.eConcepto.IR17
                        fc = New Empresas.Facturacion.LiquidacionIR17(Me.txtReferencia.Text)
                    Case Empresas.Facturacion.Factura.eConcepto.INF
                        fc = New Empresas.Facturacion.LiquidacionInfotep(Me.txtReferencia.Text)
                End Select

                If fc.Estatus = "CA" Then
                    Me.lblMensajeError.Text = "Esta Referencia no puede ser autorizada, se encuentra Revocada."
                    Me.lblMensajeError.Visible = True
                    Exit Try
                ElseIf fc.Estatus = "RE" Then
                    Me.lblMensajeError.Text = "Esta Referencia no puede ser autorizada, se encuentra Recalculada."
                    Me.lblMensajeError.Visible = True
                    Exit Try
                End If

                Me.lblMensajeError.Text = "No puede autorizar esta Referencia, ya se encuentra autorizada"
                Me.lblMensajeError.Visible = True


            End If

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

        Me.dgFacturas.DataSource = dt
        Me.dgFacturas.DataBind()

        Session("myEmp") = Me.myEmp
    End Sub
    Private Sub busquedaPorRNC()

        Dim dt As Data.DataTable
        dt = SuirPlus.Empresas.Facturacion.Factura.getNotificacionesPendientePago(eConcepto, Me.txtRNC.Text, Me.ddlNominas.SelectedValue)

        Me.dgFacturas.DataSource = dt
        Me.dgFacturas.DataBind()

        If dt.Rows.Count = 0 Then
            Me.lblMensajeError.Text = "Este Cliente NO tiene notificaciones pendientes de autorizar."
            Me.lblMensajeError.Visible = True
            Me.dgFacturas.Visible = False
        End If

    End Sub
    Private Sub buscarNominas()

        Me.myEmp = New Empresas.Empleador(Me.txtRNC.Text)

        Me.lblRNC.Text = Me.myEmp.RNCCedula
        Me.lblNombreComercial.Text = Me.myEmp.NombreComercial
        Me.lblRazonSocial.Text = Me.myEmp.RazonSocial

        Me.ddlNominas.DataSource = Empresas.Facturacion.Factura.getNominas(Me.txtRNC.Text)
        Me.ddlNominas.DataTextField = "NOMINA_DES"
        Me.ddlNominas.DataValueField = "ID_NOMINA"
        Me.ddlNominas.DataBind()

        Me.ddlNominas.Visible = True
        Me.Label1.Visible = True

        Me.dgFacturas.DataSource = Nothing
        Me.dgFacturas.DataBind()

        Session("myEmp") = Me.myEmp

    End Sub

    Private Sub btTraerNominas_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btTraerNominas.Click
        Try
            buscarNominas()
        Catch ex As Exception
            Me.MostrarError("RNC o Cedula Invalido")
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub
        End Try

        MostrarInfo()
        Me.btBuscar.Enabled = True
    End Sub

    Private Sub AutorizarFactura(ByVal NroReferencia As String)

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

        If resultado = "0" Then
            ' La factura fue autorizada
            Me.MostrarRecibo(NroReferencia)
            Me.ActualizarDataGrid()
        Else
            ' La factura no pudo ser autorizada
            Me.MostrarError(resultado)
        End If

    End Sub

    Private Sub ActualizarDataGrid()

        If Me.txtReferencia.Text <> "" Then
            Me.busquedaPorReferencia()

            MostrarInfo()

            Me.ddlNominas.Visible = False
            Me.Label1.Visible = False
        ElseIf Me.txtRNC.Text <> "" Then
            busquedaPorRNC()
            MostrarInfo()
        End If
    End Sub

    Private Sub MostrarError(ByVal mensaje As String)

        Me.lblMensajeError.Text = mensaje
        Me.lblMensajeError.Visible = True

    End Sub

    Private Sub MostrarRecibo(ByVal NroReferencia As String)

        Dim popupScript As String = "<script language='javascript'>" & _
          "window.open('popReciboAut.aspx?nroref=" + NroReferencia + "&tt=" + Request("tt") + "', 'CustomPopUp', " & _
          "'width=680, height=600, menubar=no, resizable=no')" & _
          "</script>"

        ClientScript.RegisterStartupScript(Me.GetType(), "PopupScript", popupScript)
    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Select Case eConcepto
            Case Empresas.Facturacion.Factura.eConcepto.ISR
                Response.Redirect("consFacturas.aspx?tt=ISR")
            Case Empresas.Facturacion.Factura.eConcepto.SDSS
                Response.Redirect("consFacturas.aspx?tt=SDSS")
            Case Empresas.Facturacion.Factura.eConcepto.IR17
                Response.Redirect("consFacturas.aspx?tt=IR17")
            Case Empresas.Facturacion.Factura.eConcepto.INF
                Response.Redirect("consFacturas.aspx?tt=INF")
        End Select
    End Sub

    Protected Sub dgFacturas_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgFacturas.RowCommand

        Dim NroReferencia As String = e.CommandArgument.ToString()

        Me.AutorizarFactura(NroReferencia)

    End Sub

    Protected Sub dgFacturas_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgFacturas.RowDataBound

        If (e.Row.RowType = DataControlRowType.DataRow) Then

            totalFacturas = totalFacturas + e.Row.Cells(3).Text

            Dim Valor As String = DataBinder.Eval(e.Row.DataItem, "tipo_factura")
            If Valor = "B" Or Valor = "E" Then

                Dim bt As System.Web.UI.WebControls.Button = CType(e.Row.FindControl("btAutorizar"), System.Web.UI.WebControls.Button)
                bt.Visible = True
                bt.Enabled = True
                Exit Sub
            End If

            IDNominaNew = CType(e.Row.FindControl("lblNomina"), Label).Text

            If IDNominaNew <> IDNominaOld Then
                Dim bt As System.Web.UI.WebControls.Button = CType(e.Row.FindControl("btAutorizar"), System.Web.UI.WebControls.Button)
                bt.Visible = True
                bt.Enabled = True

                IDNominaOld = IDNominaNew
            Else
                Dim bt As System.Web.UI.WebControls.Button = CType(e.Row.FindControl("btAutorizar"), System.Web.UI.WebControls.Button)
                bt.Visible = False
                bt.Enabled = False

            End If



        ElseIf (e.Row.RowType = DataControlRowType.Footer) Then

            ' Desplegar el Total de la Factura
            e.Row.Cells(2).Text = "Monto Total: "
            e.Row.Cells(3).Text = System.String.Format("{0:c}", totalFacturas)

        End If
    End Sub


End Class
