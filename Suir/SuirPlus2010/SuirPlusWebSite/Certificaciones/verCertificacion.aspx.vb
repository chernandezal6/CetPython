Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.Certificaciones
Imports SuirPlus.Utilitarios.Utils
Imports System.Data

Partial Class Certificaciones_verCertificacion
    Inherits System.Web.UI.Page
    Protected cert As Certificaciones
    Protected NroCert As String
    ' Protected tipo As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not IsPostBack Then

            'tipo = Request.QueryString("tipo")
            'If Not (tipo = "NoPrint") Then
            '    If Not (ClientScript.IsStartupScriptRegistered("alert")) Then

            '        Page.ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alertMe();", True)

            '    End If
            'End If

            NroCert = Request.QueryString("codCert")

            If NroCert Is Nothing Or NroCert = String.Empty Then
                lblmsg.Visible = True
                lblmsg.Text = "Error generando la certificación"
                Return
            End If

            cargar()

        End If

    End Sub

    Private Sub cargar()

        'Cargamos el slogan de Gobierno
        Dim certconfig As New SuirPlus.Config.Configuracion(Config.ModuloEnum.Certificaciones)
        Me.lblEslogan.Text = certconfig.Field4

        Try
            cert = New Certificaciones(CInt(NroCert))
            showPrimerParrafo()
        Catch ex As Exception
            lblmsg.Visible = True
            lblmsg.Text = Split(ex.Message, "|")(1)

            'Me.ClientScript.RegisterStartupScript(Me.GetType, "script", "<script>window.alert('Error generando la certificacion: " & ex.Message.ToString() & "')</script>")
            ''Me.RegisterStartupScript("script", "<script>window.alert('Error generando la certificacion: " & ex.Message.ToString() & "')</script>")
            SuirPlus.Exepciones.Log.LogToDB("Certificaciones " & ex.ToString())
            Exit Sub
        End Try

        'Llenamos el responsable de firmar la certificacion
        If Not IsNothing(Request("F")) Then
            trFirma.Visible = True

            Me.lblFirma.Text = cert.FirmaResponsable
            Me.lblPuestoFirma.Text = cert.PuestoFirmaResponsable
        Else
            trImagenFirma.Visible = True

            imgFirma.ImageUrl = Application("servidor") & "/sys/JpegImageFirma.aspx?A=" + Convert.ToBase64String(Encoding.ASCII.GetBytes(cert.Numero.ToString().ToCharArray()))
        End If

     

        Me.lblNoCert.Text = cert.Numero

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
                    Me.dlAporteEmpleadoEmpleador.DataSource = cert.Aportes.Tables(0)
                    Me.dlAporteEmpleadoEmpleador.DataBind()

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
                    Me.dlEmpleador.DataSource = cert.Aportes.Tables(0)
                    Me.dlEmpleador.DataBind()

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

                'Cargamos el detalle
                Me.pnlIngresoTardio.Visible = True
                Me.dlIngresoTardio.DataSource = cert.Detalle
                Me.dlIngresoTardio.DataBind()

                showSegundoParrafo()

                'Tipo 10
            Case CertificacionType.Discapidad
                Me.lblPrimerParafo.Text = reemplazaEncabezado(cert.Encabezado)

                'Cargamos el detalle
                Me.pnlDiscapacidad.Visible = True
                Me.dlDetalleDiscapacidad.DataSource = cert.Detalle
                Me.dlDetalleDiscapacidad.DataBind()

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
                Me.DlDeuda.DataSource = cert.Detalle
                Me.DlDeuda.DataBind()
                Me.showSegundoParrafo()

        End Select


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

    Private Sub dlEmpleador_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataListItemEventArgs) Handles dlEmpleador.ItemDataBound

        Dim rnc As String = CType(e.Item.FindControl("lblRnc"), Label).Text
        Dim tmpDList As DataList = e.Item.FindControl("dlAportePersonal")

        'El datatable 1 de aporte personal pertenece a los aporte detallado por cada empleador.
        Dim dvDetalle As DataView = cert.Aportes.Tables(1).DefaultView
        dvDetalle.Sort = "RNC, PERIODO Desc"
        dvDetalle.RowFilter = "RNC='" + rnc.Replace("-", "") + "'"

        tmpDList.DataSource = dvDetalle
        tmpDList.DataBind()

    End Sub

End Class
