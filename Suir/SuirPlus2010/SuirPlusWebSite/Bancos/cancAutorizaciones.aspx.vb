Imports SuirPlus

Partial Class Bancos_cancAutorizaciones
    Inherits BasePage
    Private eConcepto As Empresas.Facturacion.Factura.eConcepto

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

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
        End Select

        If Not Page.IsPostBack Then
            Me.CargaInicial()
        End If

    End Sub

    Private Sub CargaInicial()

        Me.llenarDataGrid("")

    End Sub

    Private Sub llenarDataGrid(ByVal NroReferencia As String)

        Me.dgAutorizaciones.DataSource = Empresas.Facturacion.Factura.getAutorizaciones(Me.UsrUserName, NroReferencia, eConcepto)
        Me.dgAutorizaciones.DataBind()

    End Sub


    Private Sub btBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btBuscar.Click

        Me.txtReferencia.Text = Me.txtReferencia.Text.Trim
        Dim Ref As String

        If Me.txtReferencia.Text <> "" Then
            Ref = Me.txtReferencia.Text
        Else
            Ref = ""
        End If

        Try
            Me.llenarDataGrid(Ref)
        Catch ex As Exception
            Me.MostrarError("Este Nro de Referencia no se encuentra en la Base de Datos")
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub MostrarRecibo(ByVal NroReferencia As String)

        Dim popupScript As String = "<script language='javascript'>" & _
          "window.open('popReciboAut.aspx?nroref=" + NroReferencia + "&tt=" + Request("tt") + "', 'CustomPopUp', " & _
          "'width=680, height=600, menubar=no, resizable=no')" & _
          "</script>"

        ClientScript.RegisterStartupScript(Me.GetType(), "PopupScript", popupScript)

    End Sub
    Private Sub CancelarAutorizacion(ByVal NroReferencia As String)

        If NroReferencia = "" Then

            SuirPlus.Exepciones.Log.LogToDB("Error en el Banco.C1")
            Response.Write("Error al cancelar la autorizacion, favor llamar a Mesa de Ayuda al 809.567.5049 ext 3043")
            Response.Write("<br>")
            Response.Write("C1")
            Response.End()

        End If

        Dim fc As Empresas.Facturacion.Factura = Nothing

        Select Case eConcepto

            Case Empresas.Facturacion.Factura.eConcepto.ISR
                fc = New Empresas.Facturacion.LiquidacionISR(NroReferencia)
            Case Empresas.Facturacion.Factura.eConcepto.SDSS
                fc = New Empresas.Facturacion.FacturaSS(NroReferencia)
            Case Empresas.Facturacion.Factura.eConcepto.IR17
                fc = New Empresas.Facturacion.LiquidacionIR17(NroReferencia)
            Case Empresas.Facturacion.Factura.eConcepto.INF
                fc = New Empresas.Facturacion.LiquidacionInfotep(NroReferencia)
        End Select

        Dim resultado As String = fc.DesAutorizarFactura(Me.UsrUserName, Now())

        If resultado = "0" Then
            Me.ActualizarDataGrid()
        Else
            Me.MostrarError(resultado)
        End If


    End Sub
    Private Sub MostrarError(ByVal mensaje As String)

        Me.lblMensajeError.Text = mensaje
        Me.lblMensajeError.Visible = True

    End Sub

    Private Sub ActualizarDataGrid()

        If Me.txtReferencia.Text = "" Then
            Me.llenarDataGrid("")
        Else
            Me.llenarDataGrid(Me.txtReferencia.Text)
        End If

    End Sub

    Private Sub lnkExportar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lnkExportar.Click

        Page.Controls.Clear()
        Dim dt As Data.DataTable = Empresas.Facturacion.Factura.getAutorizaciones(Me.UsrUserName, "", eConcepto)

        Dim i As Integer
        Dim ii As Integer
        Dim strBuilder As New System.Text.StringBuilder
        Dim linea As String

        Response.Clear()
        Response.Buffer = True
        Response.ContentType = "text"
        Response.AddHeader("Content-Disposition", "attachment; filename=ReferenciasAutorizadas.csv")
        Response.ContentEncoding = System.Text.Encoding.UTF8
        Response.Charset = ""
        EnableViewState = False

        For i = 0 To (dt.Rows.Count - 1)

            strBuilder.Append("")

            For ii = 0 To (dt.Columns.Count - 1)
                strBuilder.Append(dt.Rows(i)(ii) & ",")
            Next

            linea = strBuilder.ToString()
            linea = Left(linea, linea.Length - 1)
            linea = linea & vbCrLf

            Response.Write(linea)

            strBuilder.Remove(0, strBuilder.Length)

        Next

    End Sub


    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Select Case eConcepto
            Case Empresas.Facturacion.Factura.eConcepto.ISR
                Response.Redirect("cancAutorizaciones.aspx?tt=ISR")
            Case Empresas.Facturacion.Factura.eConcepto.SDSS
                Response.Redirect("cancAutorizaciones.aspx?tt=SDSS")
            Case Empresas.Facturacion.Factura.eConcepto.IR17
                Response.Redirect("cancAutorizaciones.aspx?tt=IR17")
            Case Empresas.Facturacion.Factura.eConcepto.INF
                Response.Redirect("cancAutorizaciones.aspx?tt=INF")
        End Select
    End Sub

    Protected Sub dgAutorizaciones_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgAutorizaciones.RowCommand

        Dim NroReferencia As String = e.CommandArgument.ToString()

        Select Case e.CommandName
            Case "Imprimir"
                Me.MostrarRecibo(NroReferencia)
            Case "Cancelar"
                Me.CancelarAutorizacion(NroReferencia)
        End Select

    End Sub

    Protected Sub dgAutorizaciones_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgAutorizaciones.RowDataBound
        If Me.txtReferencia.Text = "" Then
            Me.dgAutorizaciones.Columns(7).Visible = False
        Else
            Me.dgAutorizaciones.Columns(7).Visible = True
        End If
    End Sub
End Class
