Imports SuirPlus
Imports System.IO
Imports iTextSharp.text
Imports iTextSharp.tool.xml
Imports iTextSharp.text.pdf
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.Certificaciones
Imports System.Data
Imports System.Drawing
Imports System.Drawing.Drawing2D
Imports System.Drawing.Text

Partial Class ImpCertificacion
    Inherits BasePage
    Protected cert As Certificaciones
    Protected NroCert As String
    Protected urlCertificacion As String
    'Public SaltoPagina As Integer = 0
    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            If Not IsNothing(Request.QueryString("A")) Then
                Dim data As Byte() = Convert.FromBase64String(Request.QueryString("A"))
                NroCert = System.Text.ASCIIEncoding.ASCII.GetString(data)
                cargar()
            End If
        End If

    End Sub

    Private Sub cargar()

        'Cargamos el slogan de Gobierno
        Dim certconfig As New SuirPlus.Config.Configuracion(Config.ModuloEnum.Certificaciones)
        Me.lblEslogan.Text = certconfig.Field4
        urlCertificacion = certconfig.Other1_DIR.ToString()
        Try
            cert = New Certificaciones(CInt(NroCert))
            If IsNothing(cert.PDF) Then
                showPrimerParrafo()
                'Llenamos el responsable de firmar la certificacion
                Me.lblNoCert.Text = cert.Numero
                Dim dev As String = ""
                dev = Request.QueryString("D")

                If dev <> "Y" Then
                    Dim stringWriter As New StringWriter()
                    Dim htmlWriter = New HtmlTextWriter(stringWriter)
                    pnlPDF.RenderControl(htmlWriter)

                    Using ms = New MemoryStream()
                        Using document As New Document()
                            document.SetMargins(20, 20, 20, 87)
                            document.SetPageSize(iTextSharp.text.PageSize.A4)
                            Dim writer As PdfWriter = PdfWriter.GetInstance(document, ms)
                            document.Open()

                            Dim stringReader As New StringReader(stringWriter.ToString())
                            XMLWorkerHelper.GetInstance().ParseXHtml(writer, document, stringReader)
                        End Using

                        Certificaciones.ActualizarPDFCertificacion(cert.Numero, ms.GetBuffer, Me.UsrUserName)
                        Dim attachment As String = "inline;attachment; filename=test.pdf"
                        Response.AddHeader("content-disposition", attachment)
                        Response.ContentType = "application/pdf"
                        Response.BinaryWrite(ms.GetBuffer.ToArray)
                    End Using
                End If
            Else
                Dim attachment As String = "inline;attachment; filename=test.pdf"
                Response.AddHeader("content-disposition", attachment)
                Response.ContentType = "application/pdf"
                Response.BinaryWrite(cert.PDF.ToArray())

            End If

        Catch ex As Exception
            lblmsg.Visible = True
            lblmsg.Text = ex.Message

            'Me.ClientScript.RegisterStartupScript(Me.GetType, "script", "<script>window.alert('Error generando la certificacion: " & ex.Message.ToString() & "')</script>")
            ''Me.RegisterStartupScript("script", "<script>window.alert('Error generando la certificacion: " & ex.Message.ToString() & "')</script>")
            SuirPlus.Exepciones.Log.LogToDB("Certificaciones " & ex.ToString())
            Exit Sub
        End Try

    End Sub

    Private Sub showPrimerParrafo()
        Select Case cert.Tipo

            'Tipo 1, no implementado porque no se usa.
            Case CertificacionType.EstatusPagoDetalle
                Throw New NotImplementedException("Tipo de certificación no implementada")

                'Tipo 2
            Case CertificacionType.AporteEmpleadoPorEmpleador
                If cert.ExistenAporte Then
                    Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.Encabezado)

                    'Bindiamos el datalist con el detalle de los aportes.
                    Me.pnlAportePorEmpleador.Visible = True
                    Me.AportePorEmpleador(cert.Aportes.Tables(0))
                    'SaltoPagina = cert.Aportes.Tables(0).Rows.Count

                Else
                    Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.EncabezadoNegativo)
                End If

                showSegundoParrafo()

                'Tipo 3
            Case CertificacionType.AportePersonal
                If cert.ExistenAporte Then
                    Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.Encabezado)

                    'Bindiamos el datalist de empleadores
                    Me.pnlAportePersonal.Visible = True
                    Me.AportePersonal(cert.Aportes.Tables(0))

                Else
                    Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.EncabezadoNegativo)
                End If

                showSegundoParrafo()

                'Tipo 4
            Case CertificacionType.NoOperaciones
                Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.Encabezado)
                showSegundoParrafo()

                'Tipo 5
            Case CertificacionType.BalanceAlDia
                Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.Encabezado)
                showSegundoParrafo()

                'Tipo 6
            Case CertificacionType.BalanceAlDiaCon3FacturasOMenosPagadas
                Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.Encabezado)
                showSegundoParrafo()

                'Tipo 7
            Case CertificacionType.RegistroPersonaFisicaSinNomina

                Dim periodo As String = Certificaciones.getPeriodoUltimaFactura(cert.RNC)
                If (periodo <> "null") And (periodo <> String.Empty) Then
                    'Reemplazamos el periodo desde por el periodo de la ultima factura.
                    Dim texto As String = cert.EncabezadoNegativo
                    texto = texto.Replace("[PERIODO DESDE]", agregarNegrita(periodo))
                    texto = reemplazaEncabezado(texto)
                    Me.lblPrimerParafo.Text = texto
                Else
                    Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.Encabezado)
                End If

                showSegundoParrafo()

                'Tipo 8
            Case CertificacionType.RegistroEmpleadorSinNomina

                Dim periodo As String = Certificaciones.getPeriodoUltimaFactura(cert.RNC)

                If Not periodo = String.Empty Then
                    'Reemplazamos el periodo desde por el periodo de la ultima factura.
                    Dim texto As String = cert.EncabezadoNegativo
                    texto = texto.Replace("[PERIODO DESDE]", agregarNegrita(IIf(periodo = "null", "desde el inicio del SDSS", periodo)).ToString)
                    texto = reemplazaEncabezado(texto)
                    Me.lblPrimerParafo.Text = texto
                Else
                    Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.Encabezado)
                End If

                showSegundoParrafo()

                'Tipo 9
            Case CertificacionType.IngresoTardio
                Me.lblPrimerParafo.Text = cert.Encabezado

                ''Cargamos el detalle
                Me.pnlIngresoTardio.Visible = True
                Me.IngresoTardio(cert.Detalle)

                showSegundoParrafo()

                'Tipo 10
            Case CertificacionType.Discapidad
                Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.Encabezado)

                ''Cargamos el detalle
                Me.pnlDiscapacidad.Visible = True
                Me.DetalleDiscapacidad(cert.Detalle)

                showSegundoParrafo()

                'Tipo A
            Case CertificacionType.CiudadanoSinAporte

                Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.Encabezado)
                showSegundoParrafo()

                'Tipo B
            Case CertificacionType.UltimoAporteCiudadano

                Dim texto As String = String.Empty
                texto = cert.Encabezado
                texto = texto.Replace("[FECHA PAGO]", agregarNegrita(cert.FechaPago))
                texto = texto.Replace("[NRO. REFERENCIA]", agregarNegrita(Utilitarios.Utils.FormateaReferencia(cert.NroReferencia).ToString))
                texto = texto.Replace("[PERIODO]", agregarNegrita(Utilitarios.Utils.FormateaPeriodo(cert.PeriodoFactura).ToString))
                texto = texto.Replace("[RETENCION]", agregarNegrita(String.Format("{0:c}", cert.UltimaRetencion).ToString))
                texto = texto.Replace("[SALARIO]", agregarNegrita(String.Format("{0:c}", cert.SalarioSS).ToString))

                Me.lblPrimerParafo.Text = reemplazaEncabezado(texto)
                showSegundoParrafo()

                'Tipo C
            Case CertificacionType.ReporteNoPagosEmpleadoAlEmpleador

                Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.Encabezado)
                showSegundoParrafo()
                'Tipo 12
            Case CertificacionType.AcuerdoPagoCuotasRequeridas
                Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.Encabezado)
                Me.showSegundoParrafo()

            Case CertificacionType.Deuda

                Dim monto As Double = cert.getMontoAdeudado(NroCert)
                If Double.TryParse(monto.ToString(), monto) = False Then

                End If
                Dim texto As String = String.Empty
                texto = cert.Encabezado
                texto = texto.Replace("[RAZON SOCIAL]", agregarNegrita(cert.RazonSocial))
                texto = texto.Replace("[RNC EMPLEADOR]", agregarNegrita(formateaRNC(cert.RNC)))
                texto = texto.Replace("[FECHA]", getFechaFormal(cert.FechaCreacion))
                texto = texto.Replace("[MONTO]", agregarNegrita(String.Format("{0:c}", Me.GetWords(monto.ToString).ToUpper + "(" + formateaSalario(monto.ToString) + ")")))
                Me.lblPrimerParafo.Text = texto
                Me.PnlDeuda.Visible = True
                Me.Deuda(cert.Detalle)

                Me.showSegundoParrafo()

                'Tipo 16
            Case CertificacionType.CiudadanoSinAportePorEmpleador

                Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.Encabezado)

                showSegundoParrafo()
            Case CertificacionType.AcuerdoPagoSinAtraso
                Dim result As String = String.Empty
                Dim dt As DataTable = cert.getCuotasPagadasAcuerdo(result)

                If result = "0" Then
                    Dim texto As String = String.Empty
                    texto = reemplazaEncabezado(cert.Encabezado)
                    texto = texto.Replace("[CUOTAS DEL ACUERDO]", agregarNegrita(dt.Rows(0)("cuotas")))
                    texto = texto.Replace("[FECHA DEL ACUERDO DE PAGO]", getFechaFormal(dt.Rows(0)("fecha_registro")))
                    texto = texto.Replace("[PERIODO INICIAL DEL ACUERDO]", agregarNegrita(dt.Rows(0)("periodo_ini")))
                    texto = texto.Replace("[PERIODO FINAL DEL ACUERDO]", agregarNegrita(dt.Rows(0)("periodo_fin")))
                    texto = texto.Replace("[CUOTAS PAGADAS]", agregarNegrita(dt.Rows(0)("cantidad")))

                    Me.lblPrimerParafo.Text = texto

                    Me.showSegundoParrafo()
                End If

            Case CertificacionType.EstatusGeneral
                Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.Encabezado)

                ''Cargamos el detalle
                Me.pnlAportePorEmpleador.Visible = True
                Me.EstatusGeneral(cert.Detalle)

                showSegundoParrafo()

            'tipo 88
            Case CertificacionType.CertificaciónNSSExtranjeros
                Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.Encabezado)
                showSegundoParrafo()

        End Select

        Dim codigo As String = cert.Numero.ToString() + "-" + cert.NoCertificacion + cert.FechaCreacion.Year.ToString()

        '*****para trabajar en abienete de desarrollo se debe cambiar lar urlCertificacion para que apunte http://172.16.5.20:49203*****

        lblCodigoBarra.Text = "Para verificar la autenticidad de esta certificación diríjase a la siguiente dirección: <br /><b>http://www.tss2.gov.do/sys/VerificarCertificacion.aspx</b><br /><br />E introduzca los siguientes datos: <br /><ul><li>Codigo: <b>" + codigo + "</b></li><li>Pin: <b>" + cert.Pin.ToString + "</b></li></ul> <br />"

        imgCodigoBarra.ImageUrl = urlCertificacion & "/sys/jpegBarra.aspx?Id=" + codigo
        imgFirma.ImageUrl = urlCertificacion & "/sys/JpegImageFirma.aspx?A=" + Convert.ToBase64String(Encoding.ASCII.GetBytes(cert.Numero.ToString().ToCharArray()))
        imgLogo.ImageUrl = urlCertificacion & "/images/LogoTSS_small.gif"

        'para pagebreak
        lblCodigoBarraPageBreak.Text = "Para verificar la autenticidad de esta certificación diríjase a la siguiente dirección: <br /><b>http://www.tss2.gov.do/sys/VerificarCertificacion.aspx</b><br /><br />E introduzca los siguientes datos: <br /><ul><li>Codigo: <b>" + codigo + "</b></li><li>Pin: <b>" + cert.Pin.ToString + "</b></li></ul> <br />"
        imgFirmaPageBreak.ImageUrl = urlCertificacion & "/sys/JpegImageFirma.aspx?A=" + Convert.ToBase64String(Encoding.ASCII.GetBytes(cert.Numero.ToString().ToCharArray()))
        imgCodigoBarraPageBreak.ImageUrl = urlCertificacion & "/sys/jpegBarra.aspx?Id=" + codigo

    End Sub

    Private Sub AportePorEmpleador(ByVal data As DataTable)
        Dim sb As String = String.Empty
        sb += "<br />"
        sb += "<table align='center' width='100%' cellspacing='0' cellpadding='2' border='1'>"
        sb += "<tr style='background-color:#003366;'>"
        sb += " <td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma'  align='center' >"
        sb += "Período"
        sb += "<br />"
        sb += "Efectividad"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma'    align='center' >"
        sb += "No.Referencia"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma'    align='center' >"
        sb += "Fecha Pago"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma'    align='center'>"
        sb += "Pago Atrasado"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma'     align='center' >"
        sb += "Salario Reportado RD$"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma'    align='center' >"
        sb += "Aporte RD$ "
        sb += "</td>"
        sb += "</tr>"

        Dim alt As Boolean = False
        For Each Detalle As DataRow In data.Rows
            If alt Then
                sb += "<tr style='background-color:#e2edf5;font-size: 8pt;'>"
                alt = False
            Else
                sb += "<tr style='background-color:#f6f6f6;font-size: 8pt;'>"
                alt = True
            End If

            sb += "<td align='center' style='color:#003399'>"
            sb += getPeriodo(Detalle("C_TIPO_FACTURA").ToString(), Detalle("PERIODO").ToString, Detalle("C_MES_APLICACION").ToString())
            sb += "</td>"
            sb += "<td align='center' style='color:#003399'>"
            sb += formateaReferencia(Detalle("NO_REFERENCIA").ToString())
            sb += "</td>"
            sb += "<td align='center' style='color:#003399'>"
            sb += Detalle("FECHA_PAGO").ToString()
            sb += "</td>"
            sb += "<td align='center' style='color:#003399'>"
            sb += Detalle("Pago_Atrasado").ToString()
            sb += "</td>"
            sb += "<td align='right' style='color:#003399'>"
            sb += FormatNumber(Detalle("SALARIO"))
            sb += "</td>"
            sb += "<td align='right' style='color:#003399'>"
            sb += FormatNumber(Detalle("APORTE"))
            sb += "</td>"
            sb += "</tr>"

        Next

        sb += "</table>"

        Dim lit As Literal = New Literal
        lit.Text = sb
        pnlAportePorEmpleador.Controls.Add(lit)

        'para pageBreak
        validarSaltoPagina(data)

    End Sub

    Private Sub AportePersonal(ByVal data As DataTable)
        Dim sb As String = String.Empty
        sb += "<br />"
        sb += "<table align='center' width='100%' cellspacing='0' cellpadding='2' border='1'>"
        sb += "<tr style='background-color:#003366'>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' >"
        sb += "Período"
        sb += "<br />"
        sb += "Efectividad"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' >"
        sb += "No.Referencia"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' >"
        sb += "Fecha Pago"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' >"
        sb += "Pago Atrasado"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' >"
        sb += "Salario Reportado RD$"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' >"
        sb += "Aporte RD$"
        sb += "</td>"
        sb += "</tr>"
        For Each Detalle As DataRow In data.Rows
            sb += "<tr style='background-color:#aabbcc;font-size: 8pt;'>"
            sb += "<td align='CENTER' style='color:#003399'>"
            sb += "<b>RNC</b>"
            sb += "</td>"
            sb += "<td align='left' style='color:#003399'>"
            sb += formateaRNC(Detalle("RNC").ToString())
            sb += "</td>"
            sb += "<td align='left' colspan='4' style='color:#003399'>"
            sb += Detalle("RAZON_SOCIAL")
            sb += "</td>"
            sb += "</tr>"

            'El datatable 1 de aporte personal pertenece a los aporte detallado por cada empleador.
            Dim dvDetalle As DataView = cert.Aportes.Tables(1).DefaultView
            dvDetalle.Sort = "RNC, PERIODO Desc"
            dvDetalle.RowFilter = "RNC='" + Detalle("RNC").ToString() + "'"

            Dim alt As Boolean = False
            For Each DetalleHijo As DataRowView In dvDetalle

                Dim Deta As DataRow = DetalleHijo.Row

                If alt Then
                    sb += "<tr style='background-color:#e2edf5;font-size: 8pt;'>"
                    alt = False
                Else
                    sb += "<tr style='background-color:#f6f6f6;font-size: 8pt;'>"
                    alt = True
                End If

                sb += "<td align='center' style='color:#003399'>"
                sb += getPeriodo(Deta("C_TIPO_FACTURA").ToString(), Deta("PERIODO").ToString(), Deta("C_MES_APLICACION").ToString())
                sb += "</td>"
                sb += "<td align='center' style='color:#003399'>"
                sb += formateaReferencia(Deta("NO_REFERENCIA").ToString())
                sb += "</td>"
                sb += "<td align='center' style='color:#003399'>"
                sb += Deta("FECHA_PAGO").ToString()
                sb += "</td>"
                sb += "<td align='center' style='color:#003399'>"
                sb += Deta("Pago_Atrasado").ToString()
                sb += "</td>"
                sb += "<td align='right' style='color:#003399'>"
                sb += FormatNumber(Deta("SALARIO"))
                sb += "</td>"
                sb += "<td align='right' style='color:#003399'>"
                sb += FormatNumber(Deta("APORTE"))
                sb += "</td>"
                sb += "</tr>"
            Next

        Next


        sb += "</table>"

        Dim lit As Literal = New Literal
        lit.Text = sb
        pnlAportePersonal.Controls.Add(lit)
        'para pageBreak
        validarSaltoPagina(data)
    End Sub

    Private Sub IngresoTardio(ByVal data As DataSet)
        Dim sb As String = String.Empty
        Dim sbDetalle As String = String.Empty
        Dim status = data.Tables(0).Rows(0)("STATUS").ToString()
        'para pageBreak
        tblimgFirma.Visible = True
        tblimgFirmaPageBreak.Visible = False

        sb += "<br />"
        ' sb += "<div>Información Solicitante:</div>"
        sb += "<table width='100%' align='center' cellspacing='0' cellpadding='2' border='1'>"
        sb += "<tr style='background-color:#003366'>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center'>"
        sb += "NSS"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' >"
        sb += "Cédula"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center'>"
        sb += "Nombres y Apellidos"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center'>"
        sb += "Estatus"
        sb += "</td>"
        sb += "</tr>"

        For Each Encabezado As DataTable In data.Tables()
            sb += "<tr style='background-color:#e2edf5;font-size: 8pt;'>"
            sb += "<td align='center' style='color:#003399'>"
            sb += Encabezado(0)("NSS").ToString()
            sb += "</td>"
            sb += "<td align='center' style='color:#003399'>"
            sb += Encabezado(0)("CEDULA").ToString()
            sb += "</td>"
            sb += "<td align='center' style='color:#003399'>"
            sb += Encabezado(0)("NOMBRE").ToString()
            sb += "</td>"
            sb += "<td align='center' style='color:#003399'>"
            sb += Encabezado(0)("STATUS").ToString()
            sb += "</td>"
            sb += "</tr>"

        Next

        sb += "</table>"

        Dim lit As Literal = New Literal
        lit.Text = sb
        pnlIngresoTardio.Controls.Add(lit)

        If status = "Activo en Nomina" Then

            sbDetalle += "<br />"
            sbDetalle += "<div style='font-size:small;'>Información Empleador:</div>"
            sbDetalle += "<table width='100%' align='center' cellspacing='0' cellpadding='2' border='1'>"
            sbDetalle += "<tr style='background-color:#003366'>"
            sbDetalle += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center'>"
            sbDetalle += "RNC Cedula"
            sbDetalle += "</td>"
            sbDetalle += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center'>"
            sbDetalle += "Razón Social"
            sbDetalle += "</td>"
            sbDetalle += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center'>"
            sbDetalle += "Tipo Nómina"
            sbDetalle += "</td>"
            sbDetalle += "</tr>"

            For Each Detalle As DataRow In data.Tables(0).Rows
                sbDetalle += "<tr style='background-color:#e2edf5;font-size: 8pt;'>"
                sbDetalle += "<td align='center' style='color:#003399'>"
                sbDetalle += Detalle("rnc_o_cedula").ToString()
                sbDetalle += "</td>"
                sbDetalle += "<td align='center' style='color:#003399'>"
                sbDetalle += Detalle("razon_social").ToString()
                sbDetalle += "</td>"
                sbDetalle += "<td align='center' style='color:#003399'>"
                sbDetalle += Detalle("tipo_nomina").ToString()
                sbDetalle += "</td>"
                sbDetalle += "</tr>"

            Next
            sbDetalle += "</table>"
            Dim lit2 As Literal = New Literal
            lit2.Text = sbDetalle
            pnlIngresoTardio.Controls.Add(lit2)

            'para pageBreak
            If data.Tables(0).Rows.Count > 1 Then
                tblimgFirma.Visible = False
                tblimgFirmaPageBreak.Visible = True
            End If
        End If
    End Sub

    Private Sub DetalleDiscapacidad(ByVal data As DataSet)
        Dim sb As String = String.Empty

        sb += "<br />"
        sb += "<table width='100%' align='center' cellspacing='0' cellpadding='2' border='1'>"
        sb += "<tr style='background-color:#003366'>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma'  align='center'  nowrap='nowrap'>"
        sb += "RNC"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center'>"
        sb += "Empleador"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' nowrap='nowrap' width='8%'>"
        sb += "Nomina"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' >"
        sb += "Salario"
        sb += "<br />"
        sb += "Reportado <br />"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center'nowrap='nowrap'>"
        sb += "Del período"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center'  nowrap='nowrap'>"
        sb += "Con fecha límite"
        sb += "<br />"
        sb += "de pago <br />"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' >"
        sb += "Pagado En"
        sb += "</td>"
        sb += "<td align='center' style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' >"
        sb += "Tipo de pago"
        sb += "</td>"
        sb += "</tr>"

        For Each Detalle As DataRow In data.Tables(0).Rows
            sb += "<tr style='background-color:#e2edf5;font-size: 8pt;'>"
            sb += "<td align='center'>"
            sb += formateaRNC(Detalle("RNC").ToString())
            sb += "</td>"
            sb += "<td align='center'>"
            sb += Detalle("razon_social").ToString()
            sb += "</td>"
            sb += "<td align='center'>"
            sb += Detalle("Id_Nomina").ToString()
            sb += "</td>"
            sb += "<td align='center'>"
            sb += FormatNumber(Detalle("Salario_Cotizable"))
            sb += "</td>"
            sb += "<td align='center'>"
            sb += formateaPeriodo(Detalle("periodo_factura").ToString())
            sb += "</td>"
            sb += "<td align='center'>"
            sb += Convert.ToDateTime(Detalle("FechaLimitePago").ToString()).ToShortDateString()
            sb += "</td>"
            sb += "<td align='center'>"
            sb += Convert.ToDateTime(Detalle("fecha_pago").ToString()).ToShortDateString()
            sb += "</td>"
            sb += "<td align='center'>"
            sb += Detalle("TipoPago").ToString()
            sb += "</td>"
            sb += "</tr>"

        Next

        sb += "</table>"

        Dim lit As Literal = New Literal
        lit.Text = sb
        pnlDiscapacidad.Controls.Add(lit)

        'para pageBreak
        Dim dt As DataTable = data.Tables(0)
        validarSaltoPagina(dt)
    End Sub

    Private Sub Deuda(ByVal data As DataSet)
        Dim sb As String = String.Empty

        sb += "<br />"
        sb += "<table align='center' cellspacing='0' cellpadding='2' width='100%' border='1'>"
        sb += "<tr style='background-color:#003366' align='center'>"
        sb += " <td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' width='1%' nowrap='nowrap'>"
        sb += " Periodo Factura"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' width='5%' nowrap='nowrap'>"
        sb += "Nro.Referencia"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' width='4%'>"
        sb += " Estatus"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma'  align='center' nowrap='nowrap' width='8%'>"
        sb += " Nomina"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' width='3%'>"
        sb += "Total"
        sb += "</td>"
        sb += "</tr>"


        For Each Detalle As DataRow In data.Tables(0).Rows
            sb += "<tr style='background-color:#e2edf5;font-size: 8pt;' align='center'>"
            sb += "<td align='center'>"
            sb += formateaPeriodo(Detalle("periodo_factura").ToString())
            sb += "</td>"
            sb += "<td align='center'>"
            sb += formateaReferencia(Detalle("id_referencia").ToString())
            sb += "</td>"
            sb += "<td align='center'>"
            sb += Detalle("status_des").ToString()
            sb += "</td>"
            sb += "<td align='center'>"
            sb += Detalle("nomina_des").ToString()
            sb += "</td>"
            sb += "<td align='center'>"
            sb += formateaSalario(Detalle("total_importe").ToString())
            sb += "</td>"
            sb += "</tr>"

        Next

        sb += "</table>"

        Dim lit As Literal = New Literal
        lit.Text = sb
        PnlDeuda.Controls.Add(lit)
        'para pageBreak
        Dim dt As DataTable = data.Tables(0)
        validarSaltoPagina(dt)
    End Sub

    Private Sub EstatusGeneral(ByVal data As DataSet)
        Dim sb As String = String.Empty

        sb += "<br />"
        sb += "<table align='center' cellspacing='0' cellpadding='2' width='100%' border='1'>"
        sb += "<tr style='background-color:#003366' align='center'>"
        sb += " <td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' width='2%' nowrap='nowrap'>"
        sb += " Periodo Factura"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' width='5%' nowrap='nowrap'>"
        sb += "Nro.Referencia"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' width='3%'>"
        sb += " Estatus"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma'  align='center' nowrap='nowrap' width='7%'>"
        sb += " Nomina"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' width='3%'>"
        sb += "Empleados"
        sb += "</td>"
        sb += "<td style='font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma' align='center' width='3%'>"
        sb += "Total"
        sb += "</td>"
        sb += "</tr>"

        For Each Detalle As DataRow In data.Tables(0).Rows
            sb += "<tr style='background-color:#e2edf5;font-size: 8pt;' align='center'>"
            sb += "<td align='center'>"
            sb += formateaPeriodo(Detalle("periodo_factura").ToString())
            sb += "</td>"
            sb += "<td align='center'>"
            sb += formateaReferencia(Detalle("id_referencia").ToString())
            sb += "</td>"
            sb += "<td align='center'>"
            sb += Detalle("status_des").ToString()
            sb += "</td>"
            sb += "<td align='center'>"
            sb += Detalle("nomina_des").ToString()
            sb += "</td>"
            sb += "<td align='center'>"
            sb += Detalle("total_trabajadores").ToString()
            sb += "</td>"
            sb += "<td align='center'>"
            sb += formateaSalario(Detalle("total_importe").ToString())
            sb += "</td>"
            sb += "</tr>"

        Next

        sb += "</table>"

        Dim lit As Literal = New Literal
        lit.Text = sb
        pnlAportePorEmpleador.Controls.Add(lit)
        'para pageBreak
        Dim dt As DataTable = data.Tables(0)
        validarSaltoPagina(dt)
    End Sub

    Private Sub showSegundoParrafo()
        Me.lblSegundoParrafo.Text = reemplazaPie(cert.Pie)
    End Sub

    Private Function reemplazaEncabezado(ByVal texto As String) As String

        texto = texto.Replace("[RAZON SOCIAL]", agregarNegrita(cert.RazonSocial))
        texto = texto.Replace("[RNC EMPLEADOR]", agregarNegrita(formateaRNC(cert.RNC)))
        texto = texto.Replace("[PERIODO DESDE]", agregarNegrita(cert.PeriodoDesde))
        texto = texto.Replace("[PERIODO HASTA]", agregarNegrita(cert.PeriodoHasta))
        texto = texto.Replace("[FECHA DESDE]", agregarNegrita(cert.FechaDesde))
        texto = texto.Replace("[FECHA HASTA]", agregarNegrita(cert.FechaHasta))
        texto = texto.Replace("[NOMBRE TRABAJADOR]", agregarNegrita(cert.Nombre))
        texto = texto.Replace("[CEDULA CIUDADANO]", agregarNegrita(formateaRNC(cert.Cedula)))
        texto = texto.Replace("[NSS CIUDADANO]", agregarNegrita(Utilitarios.Utils.FormatearNSS(cert.NSS)))
        texto = texto.Replace("[NACIONALIDAD]", agregarNegrita(cert.Nacionalidad))
        If (cert.FechaNacimiento.ToShortDateString() <> DateTime.MinValue) Then
            texto = texto.Replace("[FECHA NACIMIENTO]", agregarNegrita(cert.FechaNacimiento.ToString("dd/MM/yyyy")))
        End If
        Return texto
    End Function

    Private Function agregarNegrita(ByVal texto As String) As String
        texto = "<b>" & texto & "</b>"
        Return texto

    End Function

    Private Function reemplazaPie(ByVal texto As String) As String

        texto = texto.Replace("[FECHA LITERAL]", getFechaFormal(cert.FechaCreacion))
        Return texto

    End Function

    Private Function getFechaFormal(ByVal fecha As Date) As String

        Dim meses() As String = New String() {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"}
        Return "a los " + fecha.Day.ToString + " días del mes de " + meses(fecha.Month - 1) + " del año " + fecha.Year.ToString()

    End Function

    Protected Function formateaRNC(ByVal rnc As String) As String

        If rnc = String.Empty Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormatearRNCCedula(rnc)
        End If

    End Function

    Protected Function formateaNSS(ByVal nss As String) As String
        Return Utilitarios.Utils.FormatearNSS(nss)
    End Function

    Protected Function formateaPeriodo(ByVal periodo As String) As String
        Return Utilitarios.Utils.FormateaPeriodo(periodo)
    End Function

    Protected Function formateaReferencia(ByVal referencia As String) As String
        Return Utilitarios.Utils.FormateaReferencia(referencia)
    End Function

    Public Function formateaSalario(ByVal salario As String) As String
        Dim salFormatear As Double
        Dim res As String

        If Not IsNumeric(salario) Then
            Return salario
        Else
            salFormatear = CDbl(salario)
            res = String.Format("{0:c}", salFormatear)
            Return res
        End If



    End Function

    Protected Function getPeriodo(ByVal tipoFactura As String, ByVal periodoFact As String, ByVal periodoDet As Object) As String

        tipoFactura = Trim(tipoFactura)
        If tipoFactura = "U" Then
            Return "Auditoria"
        ElseIf tipoFactura = "N" Then
            Return "N/A"
        Else
            Return Left(periodoFact.ToString, 4) & "-" & Right(periodoFact.ToString, 2)
        End If

    End Function

    Public Function GetWords(ByVal auxNumero As String) As String
        '********Declara variables de tipo cadena************
        Dim palabras As String = String.Empty
        Dim entero As String = String.Empty
        Dim dec As String = String.Empty
        Dim flag As String = String.Empty
        Dim Letras As String = String.Empty
        '********Declara variables de tipo entero***********
        Dim num, x, y As Integer
        flag = "N"
        Dim numero As String
        numero = auxNumero.Replace("$", "").Replace(",", "").Trim()
        If IsNumeric(numero) Then
            '**********Número Negativo***********
            If Mid(numero, 1, 1) = "-" Then
                numero = Mid(numero, 2, numero.ToString.Length - 1).ToString
                palabras = "menos "
            End If
            '**********Si tiene ceros a la izquierda*************
            For x = 1 To numero.ToString.Length
                If Mid(numero, 1, 1) = "0" Then
                    numero = Trim(Mid(numero, 2, numero.ToString.Length).ToString)
                    If Trim(numero.ToString.Length) = 0 Then palabras = ""
                Else
                    Exit For
                End If
            Next
            '*********Dividir parte entera y decimal************
            For y = 1 To Len(numero)
                If Mid(numero, y, 1) = "." Then
                    flag = "S"
                Else
                    If flag = "N" Then
                        entero = entero + Mid(numero, y, 1)
                    Else
                        dec = dec + Mid(numero, y, 1)
                    End If
                End If
            Next y
            If Len(dec) = 1 Then dec = dec & "0"
            '**********proceso de conversión***********
            flag = "N"
            If Val(numero) <= 999999999 Then
                For y = Len(entero) To 1 Step -1
                    num = Len(entero) - (y - 1)
                    Select Case y
                        Case 3, 6, 9
                            '**********Asigna las palabras para las centenas***********
                            Select Case Mid(entero, num, 1)
                                Case "1"
                                    If Mid(entero, num + 1, 1) = "0" And Mid(entero, num + 2, 1) = "0" Then
                                        palabras = palabras & "cien "
                                    Else
                                        palabras = palabras & "ciento "
                                    End If
                                Case "2"
                                    palabras = palabras & "doscientos "
                                Case "3"
                                    palabras = palabras & "trescientos "
                                Case "4"
                                    palabras = palabras & "cuatrocientos "
                                Case "5"
                                    palabras = palabras & "quinientos "
                                Case "6"
                                    palabras = palabras & "seiscientos "
                                Case "7"
                                    palabras = palabras & "setecientos "
                                Case "8"
                                    palabras = palabras & "ochocientos "
                                Case "9"
                                    palabras = palabras & "novecientos "
                            End Select
                        Case 2, 5, 8
                            '*********Asigna las palabras para las decenas************
                            Select Case Mid(entero, num, 1)
                                Case "1"
                                    If Mid(entero, num + 1, 1) = "0" Then
                                        flag = "S"
                                        palabras = palabras & "diez "
                                    End If
                                    If Mid(entero, num + 1, 1) = "1" Then
                                        flag = "S"
                                        palabras = palabras & "once "
                                    End If
                                    If Mid(entero, num + 1, 1) = "2" Then
                                        flag = "S"
                                        palabras = palabras & "doce "
                                    End If
                                    If Mid(entero, num + 1, 1) = "3" Then
                                        flag = "S"
                                        palabras = palabras & "trece "
                                    End If
                                    If Mid(entero, num + 1, 1) = "4" Then
                                        flag = "S"
                                        palabras = palabras & "catorce "
                                    End If
                                    If Mid(entero, num + 1, 1) = "5" Then
                                        flag = "S"
                                        palabras = palabras & "quince "
                                    End If
                                    If Mid(entero, num + 1, 1) > "5" Then
                                        flag = "N"
                                        palabras = palabras & "dieci"
                                    End If
                                Case "2"
                                    If Mid(entero, num + 1, 1) = "0" Then
                                        palabras = palabras & "veinte "
                                        flag = "S"
                                    Else
                                        palabras = palabras & "veinti"
                                        flag = "N"
                                    End If
                                Case "3"
                                    If Mid(entero, num + 1, 1) = "0" Then
                                        palabras = palabras & "treinta "
                                        flag = "S"
                                    Else
                                        palabras = palabras & "treinta y "
                                        flag = "N"
                                    End If
                                Case "4"
                                    If Mid(entero, num + 1, 1) = "0" Then
                                        palabras = palabras & "cuarenta "
                                        flag = "S"
                                    Else
                                        palabras = palabras & "cuarenta y "
                                        flag = "N"
                                    End If
                                Case "5"
                                    If Mid(entero, num + 1, 1) = "0" Then
                                        palabras = palabras & "cincuenta "
                                        flag = "S"
                                    Else
                                        palabras = palabras & "cincuenta y "
                                        flag = "N"
                                    End If
                                Case "6"
                                    If Mid(entero, num + 1, 1) = "0" Then
                                        palabras = palabras & "sesenta "
                                        flag = "S"
                                    Else
                                        palabras = palabras & "sesenta y "
                                        flag = "N"
                                    End If
                                Case "7"
                                    If Mid(entero, num + 1, 1) = "0" Then
                                        palabras = palabras & "setenta "
                                        flag = "S"
                                    Else
                                        palabras = palabras & "setenta y "
                                        flag = "N"
                                    End If
                                Case "8"
                                    If Mid(entero, num + 1, 1) = "0" Then
                                        palabras = palabras & "ochenta "
                                        flag = "S"
                                    Else
                                        palabras = palabras & "ochenta y "
                                        flag = "N"
                                    End If
                                Case "9"
                                    If Mid(entero, num + 1, 1) = "0" Then
                                        palabras = palabras & "noventa "
                                        flag = "S"
                                    Else
                                        palabras = palabras & "noventa y "
                                        flag = "N"
                                    End If
                            End Select
                        Case 1, 4, 7
                            '*********Asigna las palabras para las unidades*********
                            Select Case Mid(entero, num, 1)
                                Case "1"
                                    If flag = "N" Then
                                        If y = 1 Then
                                            palabras = palabras & "uno "
                                        Else
                                            palabras = palabras & "un "
                                        End If
                                    End If
                                Case "2"
                                    If flag = "N" Then palabras = palabras & "dos "
                                Case "3"
                                    If flag = "N" Then palabras = palabras & "tres "
                                Case "4"
                                    If flag = "N" Then palabras = palabras & "cuatro "
                                Case "5"
                                    If flag = "N" Then palabras = palabras & "cinco "
                                Case "6"
                                    If flag = "N" Then palabras = palabras & "seis "
                                Case "7"
                                    If flag = "N" Then palabras = palabras & "siete "
                                Case "8"
                                    If flag = "N" Then palabras = palabras & "ocho "
                                Case "9"
                                    If flag = "N" Then palabras = palabras & "nueve "
                            End Select
                    End Select
                    '***********Asigna la palabra mil***************
                    If y = 4 Then
                        If Mid(entero, 6, 1) <> "0" Or Mid(entero, 5, 1) <> "0" Or
                        Mid(entero, 4, 1) <> "0" Or (Mid(entero, 6, 1) = "0" And Mid(entero, 5, 1) = "0" And Mid(entero, 4, 1) = "0" And Len(entero) <= 6) Then palabras = palabras & "mil "
                    End If

                    '**********Asigna la palabra millón*************
                    If y = 7 Then
                        If Len(entero) = 7 And Mid(entero, 1, 1) = "1" Then
                            palabras = palabras & "millón "
                        Else
                            palabras = palabras & "millones "
                        End If
                    End If
                Next y
                '**********Une la parte entera y la parte decimal*************
                If dec <> "" Then
                    If palabras = "" Then
                        Letras = "CERO PESOS 00/100 "
                    Else
                        Dim AuxDec As String
                        '*************Valida la longitud de los centavos******************
                        If dec.Length > 2 Then
                            AuxDec = Mid(dec, 1, 2)
                            Letras = palabras & " PESOS CON " & AuxDec & "/100 "
                        Else
                            Letras = palabras & " PESOS CON " & dec & "/100 "
                        End If
                    End If
                Else
                    If palabras = "" Then
                        Letras = "CERO PESOS CON 00/100"
                    Else
                        Letras = palabras & " PESOS CON 00/100 "
                    End If
                End If
            Else
                Letras = ""
            End If
        Else
            Letras = "Dato no numérico"
        End If
        Return Letras
    End Function

    Private Sub validarSaltoPagina(Data As DataTable)

        If (Data.Rows.Count > 4 And Data.Rows.Count <= 29) Then
            tblimgFirma.Visible = False
            tblimgFirmaPageBreak.Visible = True
        ElseIf (Data.Rows.Count > 65 And Data.Rows.Count <= 87) Then
            tblimgFirma.Visible = False
            tblimgFirmaPageBreak.Visible = True
        ElseIf (Data.Rows.Count > 115 And Data.Rows.Count <= 125) Then
            tblimgFirma.Visible = False
            tblimgFirmaPageBreak.Visible = True
        ElseIf (Data.Rows.Count > 163 And Data.Rows.Count <= 173) Then 'a partir de aquí(3era pagina) se toma un rango de 38 registros para el salto de pagina
            tblimgFirma.Visible = False
            tblimgFirmaPageBreak.Visible = True
        ElseIf (Data.Rows.Count > 211 And Data.Rows.Count <= 221) Then
            tblimgFirma.Visible = False
            tblimgFirmaPageBreak.Visible = True
        ElseIf (Data.Rows.Count > 259 And Data.Rows.Count <= 269) Then
            tblimgFirma.Visible = False
            tblimgFirmaPageBreak.Visible = True
        ElseIf (Data.Rows.Count > 307 And Data.Rows.Count <= 317) Then
            tblimgFirma.Visible = False
            tblimgFirmaPageBreak.Visible = True
        ElseIf (Data.Rows.Count > 307 And Data.Rows.Count <= 317) Then
            tblimgFirma.Visible = False
            tblimgFirmaPageBreak.Visible = True
        ElseIf (Data.Rows.Count > 355 And Data.Rows.Count <= 365) Then
            tblimgFirma.Visible = False
            tblimgFirmaPageBreak.Visible = True
        ElseIf (Data.Rows.Count > 403 And Data.Rows.Count <= 413) Then
            tblimgFirma.Visible = False
            tblimgFirmaPageBreak.Visible = True
        ElseIf (Data.Rows.Count > 451 And Data.Rows.Count <= 461) Then
            tblimgFirma.Visible = False
            tblimgFirmaPageBreak.Visible = True

        End If
    End Sub

    'Private Sub dlEmpleador_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataListItemEventArgs) Handles dlEmpleador.ItemDataBound

    '    Dim rnc As String = CType(e.Item.FindControl("lblRnc"), Label).Text
    '    Dim tmpDList As DataList = e.Item.FindControl("dlAportePersonal")

    '    'El datatable 1 de aporte personal pertenece a los aporte detallado por cada empleador.
    '    Dim dvDetalle As DataView = cert.Aportes.Tables(1).DefaultView
    '    dvDetalle.Sort = "RNC, PERIODO Desc"
    '    dvDetalle.RowFilter = "RNC='" + rnc.Replace("-", "") + "'"

    '    tmpDList.DataSource = dvDetalle
    '    tmpDList.DataBind()

    'End Sub

End Class
