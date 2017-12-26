Imports System.Data
Imports SuirPlus


Partial Class MDT_pagosPlanillasMDT
    Inherits BasePage
    Dim usuario As String = String.Empty

    Public PINSeleccionados() As String
    Public FacturasSeleccionados() As String

    Private myFact As Empresas.Facturacion.Factura



    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load
        Try
            If Me.UsrImpersonandoUnRepresentante Then
                usuario = Me.UsrImpUserName

                'Completando los datos de la empresa
                Dim empresa As New Empresas.Empleador(Me.UsrImpRNC)
                'Me.lblRNC.Text = "<b>RNC:</b> " & empresa.RNCCedula
                'Me.lblRazonSocial.Text = "<b>Razon Social:</b> " & empresa.RazonSocial

            Else
                usuario = Me.UsrUserName

                'Completando los datos de la empresa
                'Dim empresa As New Empresas.Empleador(Me.UsrRNC)
                'Me.lblRNC.Text = "<b>RNC:</b> " & empresa.RNCCedula
                'lblRazonSocial.Text = "<b>Razon Social:</b> " & empresa.RazonSocial
            End If


            If Not Page.IsPostBack Then
                If SuirPlus.MDT.General.ValidarNovedadesPendientes(UsrRegistroPatronal) = "OK" Then
                    CargarDatosMDT()
                    ListarPIN(CInt(UsrRegistroPatronal))
                    ListarRepresentacionLocal()
                    btnProcesarFactura.Enabled = False
                    btnProcesarFactura.ForeColor = Drawing.Color.WhiteSmoke

                    lbTotalPIN.Text = FormatCurrency(0)


                    lbTotalFacturas.ForeColor = Drawing.Color.Red
                    lbTotalPIN.ForeColor = Drawing.Color.Green
                    gvPIN.Columns(1).Visible = False
                Else
                    lblMensajeError.Text = SuirPlus.MDT.General.ValidarNovedadesPendientes(UsrRegistroPatronal).ToString()
                    btnAutorizarPIN.Enabled = False
                    btnProcesar.Enabled = False
                    btnProcesarFactura.Enabled = False
                    txtAutorizarPIN.Enabled = False
                    txtObservacion.Enabled = False
                    txtPIN.Enabled = False
                    ddlRepresentacionLocal.Enabled = False

                End If




            End If
            lbSuccess.Visible = False
            btnProcesar.Visible = False

        Catch ex As Exception
            Me.lblMensajeError.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try





    End Sub

    Private Sub CargarDatosMDT()

        Try
            If Request.QueryString("nro").ToString() <> "" Then
                'Dim strFiltro As String = "CodStatus in ('VI','VE') and NO_AUTORIZACION  is null and id_referencia=" + Request.QueryString("nro").ToString() + " "
                Dim strFiltro As String = "VIVE"
                Planilla.Value = Request.QueryString("nro").ToString()


                Dim dtMDT As DataTable
                dtMDT = Empresas.Facturacion.Factura.getNotificaciones(SuirPlus.Empresas.Facturacion.Factura.eConcepto.MDT, Convert.ToInt32(Me.UsrRegistroPatronal), usuario, strFiltro)
                dtMDT.DefaultView.Sort = "periodo_factura Desc, Fecha_Emision Desc"
                Dim view As DataView = New DataView(dtMDT)

                If dtMDT.Rows.Count > 0 Then
                    Dim Filtro = "ID_REFERENCIA='" + Request.QueryString("nro").ToString() + "'"
                    view.RowFilter = Filtro

                    Me.gvPlanillasMDT.DataSource = view
                    Me.gvPlanillasMDT.DataBind()
                    lbTotalFacturas.Text = FormatCurrency(gvPlanillasMDT.Rows(0).Cells(4).Text())
                Else
                    lblMensajeError.Text = "No hay data"
                End If

            Else
                lbTotalFacturas.Text = FormatCurrency(0.0)
            End If


        Catch ex As Exception
          
            Throw New Exception("No hay data")

        End Try


    End Sub
    Private Sub ListarPIN(ByVal regPat As String)
        Dim dtMDT As DataTable
        Try
            If regPat <> 0 Then
                dtMDT = Empresas.Facturacion.PlanillaMDT.ListarPIN(regPat)
                If dtMDT.Rows.Count > 0 Then
                    Me.gvPIN.DataSource = dtMDT
                    Me.gvPIN.DataBind()
                End If
            End If

        Catch ex As Exception
            Me.lblMensajeError.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub
    Private Sub ListarRepresentacionLocal()
        Dim dtMDT As DataTable

        Try
            dtMDT = SuirPlus.MDT.General.listarRepresentacionLocal()

            If dtMDT.Rows.Count > 0 Then

                Me.ddlRepresentacionLocal.DataSource = dtMDT
                Me.ddlRepresentacionLocal.DataValueField = "ID_REPRESENTANTE"
                Me.ddlRepresentacionLocal.DataTextField = "DESCRIPCION_REPRESENTACION"
                Me.ddlRepresentacionLocal.DataBind()
                Me.ddlRepresentacionLocal.Items.Insert(0, New ListItem("--Seleccione--", "0"))

            Else
                Me.ddlRepresentacionLocal.Items.Add("error al cargar la data")
            End If

        Catch ex As Exception
            Me.lblMensajeError.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub



    Protected Function FormatearPeriodo(ByVal periodo As String) As String

        Return Utilitarios.Utils.FormateaPeriodo(periodo)

    End Function

    Protected Sub btnAutorizarPIN_Click(sender As Object, e As System.EventArgs) Handles btnAutorizarPIN.Click


        Try
            lblMensajeError.Text = ""


            If SoloNumeros() = 0 Then
                If ddlRepresentacionLocal.SelectedIndex <> 0 Then
                    If SuirPlus.MDT.General.ValidarPIN(CInt(UsrRegistroPatronal), txtPIN.Text, txtAutorizarPIN.Text, ddlRepresentacionLocal.Text).ToString() = "OK" Then

                        ListarPIN(CInt(UsrRegistroPatronal))
                        txtAutorizarPIN.Text = ""
                        txtPIN.Text = ""
                        lblMensajeError.Text = ""

                        Response.Redirect("pagosPlanillasMDT.aspx?nro=" + Planilla.Value)



                    Else

                        lblMensajeError.Text = SuirPlus.MDT.General.ValidarPIN(CInt(UsrRegistroPatronal), txtPIN.Text, txtAutorizarPIN.Text, ddlRepresentacionLocal.Text).ToString()
                    End If
                Else
                    lblMensajeError.Text = "Debe seleccionar una representacion local."
                End If
            End If

        Catch ex As Exception
            lblMensajeError.Text = ex.Message.ToString()

        End Try



    End Sub

    Function CalcularMontos() As Boolean
        Dim Count As Integer
        Dim total As Decimal
        Dim Pines(CInt(gvPIN.Rows.Count - 1)) As String

        For i As Integer = 0 To gvPIN.Rows.Count - 1
            If CType(gvPIN.Rows(i).FindControl("chkPIN"), CheckBox).Checked = True Then
                total = CDec(gvPIN.Rows(i).Cells(5).Text) + total
                Pines(i) = CType(gvPIN.Rows(i).FindControl("chkPIN"), CheckBox).Text
                Count = Count + i
            End If
        Next

        lbTotalPIN.Text = FormatCurrency(total)

        If lbTotalPIN.Text <> "" And lbTotalFacturas.Text <> "" Then
            HabilitarProcesar(CDec(lbTotalPIN.Text), CDec(lbTotalFacturas.Text))
            Return True
        Else
            Return False
        End If

    End Function



    Protected Sub chkPIN_CheckedChanged(sender As Object, e As EventArgs)
        CalcularMontos()
    End Sub

    'Protected Sub chkFacturas_CheckedChanged(sender As Object, e As EventArgs)
    '    Dim Count As Integer
    '    Dim total As Decimal
    '    Dim Facturas(CInt(gvPlanillasMDT.Rows.Count - 1)) As String

    '    For i As Integer = 0 To gvPlanillasMDT.Rows.Count - 1
    '        If CType(gvPlanillasMDT.Rows(i).FindControl("chkFacturas"), CheckBox).Checked = True Then
    '            total = CDec(gvPlanillasMDT.Rows(i).Cells(4).Text) + total
    '            Facturas(i) = CType(gvPlanillasMDT.Rows(i).FindControl("chkFacturas"), CheckBox).Text
    '            Count = Count + 1
    '        End If
    '    Next

    '    lbTotalFacturas.Text = FormatCurrency(total)

    '    If lbTotalPIN.Text <> "" And lbTotalFacturas.Text <> "" Then
    '        HabilitarProcesar(CDec(lbTotalPIN.Text), CDec(lbTotalFacturas.Text))
    '    End If

    'End Sub

    Sub HabilitarProcesar(TotalPIN As Decimal, TotalFacturas As Decimal)
        If TotalPIN >= TotalFacturas And TotalFacturas <> 0 Then
            btnProcesarFactura.Enabled = True
            btnProcesarFactura.ForeColor = Drawing.Color.Black

        Else
            btnProcesarFactura.Enabled = False
            btnProcesarFactura.ForeColor = Drawing.Color.WhiteSmoke

        End If

    End Sub

    'Private Sub AutorizarFactura(ByVal NroReferencia As String)

    '    If NroReferencia = "" Then

    '        SuirPlus.Exepciones.Log.LogToDB("Error en el Banco.1")
    '        Response.Write("Error al autorizar la referencia, favor llamar a Mesa de Ayuda al 809.567.5049 ext 3043")
    '        Response.Write("<br>")
    '        Response.Write("1")
    '        Response.End()

    '    End If
    '    Me.myFact = New Empresas.Facturacion.PlanillaMDT(NroReferencia)

    '    Dim resultado As String = Me.myFact.AutorizarFactura(Me.UsrUserName)

    '    If NroReferencia = "" Then

    '        SuirPlus.Exepciones.Log.LogToDB("Error en el Banco.2")
    '        Response.Write("Error al autorizar la referencia, favor llamar a Mesa de Ayuda al 809.567.5049 ext 3043")
    '        Response.Write("<br>")
    '        Response.Write("2")
    '        Response.End()

    '    End If

    '    If resultado = "0" Then
    '        ' La factura fue autorizada
    '        If NroReferencia = "" Then

    '            SuirPlus.Exepciones.Log.LogToDB("Error en el Banco.3")
    '            Response.Write("Error al autorizar la referencia, favor llamar a Mesa de Ayuda al 809.567.5049 ext 3043")
    '            Response.Write("<br>")
    '            Response.Write("3")
    '            Response.End()

    '        End If


    '    Else
    '        ' La factura no pudo ser autorizada
    '        If resultado = "999" Then
    '            resultado = "Existen otras referenciones anteriores (mas viejas) que debe pagar primero."
    '        End If

    '    End If

    'End Sub


    Protected Sub btnProcesarFactura_Click(sender As Object, e As System.EventArgs) Handles btnProcesarFactura.Click
        Try
            gvPIN.Columns(1).Visible = True
            contenido.Visible = False
            btnProcesarFactura.Enabled = False


            lbSuccess.Text = "<p style='text-align:center; margin-left:30%;'>Estamos procesando su pago...</p>"
            lbSuccess.Visible = True


            Dim Recibos As String = String.Empty
            Dim Pines(CInt(gvPIN.Rows.Count)) As String

            For i As Integer = 0 To gvPIN.Rows.Count - 1
                If CType(gvPIN.Rows(i).FindControl("chkPIN"), CheckBox).Checked = True Then
                    Pines(i) = gvPIN.Rows(i).Cells(1).Text


                End If
            Next

            For Each Filas As String In Pines
                If Filas <> Nothing Then
                    Recibos = arrayToString(Pines)
                End If
            Next


            If CalcularMontos() = True Then
                If Recibos <> "|" Then

                    Dim Cadena = SuirPlus.MDT.General.procesar_PlanillasMDT(gvPlanillasMDT.Rows(0).Cells(0).Text, Recibos, txtObservacion.Text, usuario).ToString()

                    If Cadena = "OK" Then
                        lbSuccess.Text = "<p style='text-align:center; margin-left:30%;'>Pago procesado correctamente.</p>"
                        btnProcesar.Visible = True

                    Else
                        lblMensajeError.Text = Cadena
                        lbSuccess.Visible = False
                        btnProcesar.Visible = False
                        contenido.Visible = True
                        btnProcesarFactura.Enabled = True
                    End If

                End If
            End If


        Catch ex As Exception
            lblMensajeError.Text = ex.Message.ToString()
            contenido.Visible = True
            lbSuccess.Visible = False
            btnProcesar.Visible = False

        End Try
        gvPIN.Columns(1).Visible = False
        btnProcesarFactura.Enabled = True

    End Sub


    Public Function arrayToString(StringArray() As String)
        Dim str As String = "|"
        Dim Resultado As String = String.Empty
        For i As Integer = 0 To StringArray.Length - 1
            If StringArray(i) <> Nothing Then
                Resultado = Resultado + str + StringArray(i)
            End If
        Next
        Resultado = Resultado.TrimStart("|")
        Resultado = Resultado.TrimEnd("|")

        Return Resultado
    End Function


    Protected Sub btnProcesar_Click(sender As Object, e As System.EventArgs) Handles btnProcesar.Click
        Response.Redirect(Application("servidor") + "Empleador/consNotificaciones.aspx")
    End Sub

    Function SoloNumeros() As Integer

        If txtPIN.Text = "" Then
            lblMensajeError.Text = "Debe digitar un número de recibo"
            Return 1
        End If

        If Not IsNumeric(txtPIN.Text) Then
            lblMensajeError.Text = "Debe ingresar solo valores numericos en el número de recibo"
            Return 1
        End If

        If txtAutorizarPIN.Text = "" Then
            lblMensajeError.Text = "Debe digitar un codigo de Aprobación"
            Return 1
        End If

        If Not IsNumeric(txtAutorizarPIN.Text) Then
            lblMensajeError.Text = "Debe ingresar solo valores numericos en el codigo de Aprobación"
            Return 1
        End If

        Return 0
    End Function


    Private Function WaitSeconds(ByVal nSecs As Double) As Boolean

        ' Esperar los segundos indicados

        ' Crear la cadena para convertir en TimeSpan
        Dim s As String = "0.00:00:" & nSecs.ToString.Replace(",", ".")
        Dim ts As TimeSpan = TimeSpan.Parse(s)

        ' Añadirle la diferencia a la hora actual
        Dim t1 As DateTime = DateTime.Now.Add(ts)

        ' Esta asignación solo es necesaria 
        ' si la comprobación se hace al principio del bucle
        Dim t2 As DateTime = DateTime.Now

        ' Mientras no haya pasado el tiempo indicado
        Do While t2 < t1
            ' Un respiro para el sitema
            System.Windows.Forms.Application.DoEvents()
            ' Asignar la hora actual
            t2 = DateTime.Now
        Loop

        Return True

    End Function



End Class
