Imports System.Data
Imports SuirPlus
Partial Class Oficina_Virtual_ConsDispercionARS
    Inherits SeguridadOFV

    Dim PeriodoAnterior As String = String.Empty
    Dim cantidad As Integer = 0
    Dim consecutivoOn As Boolean = True
    Dim consecutivos As String = String.Empty
    Dim IdNss As String = String.Empty
    Shared periodosConsecutivos As Integer = 0
    Dim dt As DataTable = Nothing
    Dim Nro_Documento As String = String.Empty
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If UserNoDocument <> Nothing Then
            Nro_Documento = UserNoDocument
            Consultas()
        Else
            Response.Redirect("LoginOficinaVirtual.aspx")
        End If
    End Sub
    Private Sub Consultas()
        periodosConsecutivos = 0
        consecutivoOn = True
        Me.BindGrid()
    End Sub
    Private Sub NombreCedulaAfiliado()

        'Dim dt As New DataTable
        'dt = Utilitarios.TSS.getConsultaNss(Nro_Documento, String.Empty, String.Empty, String.Empty, String.Empty, 1, 1)

        'Try
        '    IdNss = dt.Rows("0")("id_nss").ToString()
        '    lblNombreAfiliado.Text = dt.Rows("0")("nombres").ToString() + " " + dt.Rows("0")("apellidos").ToString()

        'Catch ex As Exception
        '    Me.dvError.Visible = True
        '    Me.txtError.InnerText = ex.Message
        'End Try


        Dim infoDT As DataTable
        Try
            infoDT = SuirPlus.Utilitarios.TSS.getCiudadano(Nro_Documento + "", "", "", "", "", "", "", "", "", "", "")
            If infoDT.Rows.Count > 0 Then
                lblNombreAfiliado.Text = infoDT.Rows(0)("NOMBRES").ToString() + " " + infoDT.Rows(0)("PRIMER_APELLIDO").ToString()
                IdNss = infoDT.Rows(0)("ID_NSS").ToString()
            Else
                Me.dvError.Visible = True
                Me.txtError.InnerText = "Error cargando consulta"
            End If
        Catch ex As Exception
            Me.dvError.Visible = True
            Me.txtError.InnerText = ex.Message
        End Try

    End Sub
    Private Sub BindGrid()

        NombreCedulaAfiliado()
        dt = Ars.Consultas.getHistoricoCiudadano(Nro_Documento, IdNss)

        If dt.Rows.Count > 0 Then
            Dim dr As DataRow
            Dim ano As Integer
            Dim anoactual As Integer = 1
            Dim contador As Integer = -1
            Dim ContadorRows As Integer = 0

            tc1.Tabs.Clear()
            For Each dr In dt.Rows
                ContadorRows += 1
                Dim dtano As New DataTable
                dtano = dt.Clone
                ano = Convert.ToInt32(dr("periodo_factura_ars").ToString().Substring(0, 4))

                If anoactual <> ano Then
                    Dim dl As New DataList
                    Dim tp As New AjaxControlToolkit.TabPanel

                    tp.HeaderText = ano.ToString()
                    tc1.Tabs.Add(tp)
                    tc1.TabIndex = contador
                End If

                If Not ViewState.Item(ano) Is Nothing Then
                    dtano = ViewState.Item(ano)
                    dtano.ImportRow(dr)
                    ViewState.Item(ano) = dtano
                Else
                    If Not ViewState.Item(anoactual) Is Nothing Then
                        contador += 1
                        dtano = ViewState.Item(anoactual)
                        BindDinamico(dtano, contador)
                        ViewState.Item(anoactual) = Nothing

                        dtano.Clear()
                        dtano.TableName = ano.ToString
                        dtano.ImportRow(dr)
                        ViewState.Item(ano) = dtano
                    Else
                        dtano.TableName = ano.ToString
                        dtano.ImportRow(dr)
                        ViewState.Item(ano) = dtano
                    End If
                End If
                anoactual = ano

                If ContadorRows = dt.Rows.Count Then
                    contador += 1
                    dtano = ViewState.Item(anoactual)
                    BindDinamico(dtano, contador)

                    ViewState.Item(anoactual) = Nothing
                End If
            Next
        Else
            Me.dvError.Visible = True
            Me.txtError.InnerText = "No se encontraron registros!!"
        End If
    End Sub
    Protected Function MostrarTabla(ByVal Periodo As String, ByVal NombreARS As String, ByVal NSS As String, ByVal Nombre As String, ByVal Apellido As String, ByVal TipoAfiliado As String, ByVal Parentesco As String, ByVal Referencia As String, ByVal FechaPago As String, ByVal Monto As Decimal, ByVal Empresa As String, ByVal RNC As String, ByVal Documento As String) As String
        Dim tablita As New StringBuilder
        cantidad = cantidad + 1

        If PeriodoAnterior <> Periodo Then
            If String.IsNullOrEmpty(PeriodoAnterior) Then
                PeriodoAnterior = Periodo
            End If

            Consecutivas(NSS, PeriodoAnterior, Periodo, IIf(FechaPago = Nothing, False, True))

            PeriodoAnterior = Periodo

            tablita.Append(" <table class='tableDispersion' style='width:1100px;' cellspacing='2' cellpadding='3'>")
            tablita.Append("<tr>")
            tablita.Append("<td class='HeaderTableDispersion' colspan='4'>")
            tablita.Append("Periodo " & Periodo.Substring(0, 4) & "-" & Periodo.Substring(4, 2) & "")
            tablita.Append("</td>")
            tablita.Append("<td class='HeaderTableDispersion' colspan='8'>")
            tablita.Append(NombreARS & "")
            tablita.Append("</td>")
            tablita.Append("</tr>")
            tablita.Append("<tr class='trTablaDispersion'>")
            tablita.Append("<td width='50'><strong>NSS</strong></td>")
            tablita.Append("<td width='70'><strong>Documento</strong></td>")
            tablita.Append("<td colspan='2' width='100'>")
            tablita.Append("<strong>Nombre</strong></td>")
            tablita.Append("<td colspan='1' width='100'>")
            tablita.Append("<strong>Apellido</strong></td>")
            tablita.Append("<td colspan='1' width='100'>")
            tablita.Append("<strong>Tipo Afiliado</strong></td>")
            tablita.Append("<td colspan='1' width='100'>")
            tablita.Append("<strong>Parentesco</strong></td>")
            tablita.Append("<td colspan='1' width='100'>")
            tablita.Append("<strong>No. Referencia</strong></td>")
            tablita.Append("<td colspan='1' style='text-align:center;'>")
            tablita.Append("<strong>Fecha Pago</strong></td>")
            tablita.Append("<td colspan='1' style='text-align:right;'>")
            tablita.Append("<strong>Per Capita</strong></td>")
            tablita.Append("<td colspan='1' width='100' style='text-align:center;'>")
            tablita.Append("<strong>Dispersado</strong></td>")
            tablita.Append("<td colspan='1' width='200'>")
            tablita.Append("<strong>Empresa</strong></td>")
            tablita.Append("</tr>")

            tablita.Append("<tr class='trTablaDispersion'>")
            'tablita.Append("<td><a href='ConsCiudadano.aspx?NSS=" & NSS & "'>" & NSS & "</a></td>")
            tablita.Append("<td>" & NSS & "</td>")
            tablita.Append("<td colspan='1'>" & Documento & "</td>")
            tablita.Append("<td colspan='2'>" & Nombre & "</td>")
            tablita.Append("<td colspan='1'>" & Apellido & "</td>")
            tablita.Append("<td colspan='1'>" & TipoAfiliado & "</td>")
            tablita.Append("<td colspan='1'>" & Parentesco & "</td>")
            'tablita.Append("<td colspan='1'><a href='ConsARSpagados.aspx?Ref=" & Referencia & "'>" & Referencia & "</a></td>")
            tablita.Append("<td colspan='1'>" & Referencia & "</td>")
            tablita.Append("<td colspan='1' style='text-align:center;'>" & IIf(FechaPago = Nothing, String.Empty, FechaPago) & "</td>")
            tablita.Append("<td colspan='1' style='text-align:right'>" & Monto.ToString("c") & "</td>")
            tablita.Append("<td colspan='1' style='text-align:center'>" & IIf(Referencia = Nothing, "<img src='../images/error.gif' alt=''/>", "<img src='../images/ok.gif' alt=''/>") & "</td>")
            'tablita.Append("<td colspan='1'><a href='ConsEmpleador.aspx?RNC=" & RNC & "'>" & Empresa & "</a></td>")
            tablita.Append("<td colspan='1'>" & Empresa & "</a></td>")
            tablita.Append("</tr>")

        Else

            Consecutivas(NSS, PeriodoAnterior, Periodo, IIf(FechaPago = Nothing, False, True))

            'Solo escribo los tr
            tablita.Append("<tr>")
            'tablita.Append("<td><a href='ConsCiudadano.aspx?NSS=" & NSS & "'>" & NSS & "</a></td>")
            tablita.Append("<td>" & NSS & "</td>")
            tablita.Append("<td colspan='1'>" & Documento & "</td>")
            tablita.Append("<td colspan='2'>" & Nombre & "</td>")
            tablita.Append("<td colspan='1'>" & Apellido & "</td>")
            tablita.Append("<td colspan='1'>" & TipoAfiliado & "</td>")
            tablita.Append("<td colspan='1'>" & Parentesco & "</td>")
            'tablita.Append("<td colspan='1'><a href='ConsARSpagados.aspx?Ref=" & Referencia & "'>" & Referencia & "</a></td>")
            tablita.Append("<td colspan='1'>" & Referencia & "</td>")
            tablita.Append("<td colspan='1' style='text-align:center;'>" & IIf(FechaPago = Nothing, String.Empty, FechaPago) & "</td>")
            tablita.Append("<td colspan='1' style='text-align:right'>" & Monto.ToString("c") & "</td>")
            tablita.Append("<td colspan='1' style='text-align:center'>" & IIf(Referencia = Nothing, "<img src='../images/error.gif' alt=''/>", "<img src='../images/ok.gif' alt=''/>") & "</td>")
            'tablita.Append("<td colspan='1'><a href='ConsEmpleador.aspx?RNC=" & RNC & "'>" & Empresa & "</a></td>")
            tablita.Append("<td colspan='1'>" & Empresa & "</td>")
            tablita.Append("</tr>")

        End If

        'Si es el ultimo registro o si el periodo va a cambiar cerramos la tabla
        If dt.Rows.Count = cantidad Then
            tablita.Append("</table>")
        ElseIf dt.Rows(cantidad)("tipo_afiliado").ToString = "Titular" Then
            tablita.Append("</table>")
        End If


        Return tablita.ToString()

    End Function
    Private Sub Consecutivas(ByVal Nss As String, ByVal PeriodoAnterior As String, ByVal Periodo As String, ByVal isPago As Boolean)
        'Manejar contador de periodos consecutivos
        If consecutivoOn = False Then
            periodosConsecutivos = 0
        End If

        If Nss = IdNss Then
            If (Int16.Parse(PeriodoAnterior.Substring(4, 2)) - Int16.Parse(Periodo.Substring(4, 2))) < 2 And isPago = True Then
                periodosConsecutivos += 1
                consecutivoOn = True
            Else
                If (PeriodoAnterior.Substring(4, 2).Equals("01") And Periodo.Substring(4, 2).Equals("12")) _
                    And ((Int16.Parse(PeriodoAnterior.Substring(0, 4)) - Int16.Parse(Periodo.Substring(0, 4))) = 1) And isPago = True Then
                    periodosConsecutivos += 1
                    consecutivoOn = True
                Else
                    consecutivoOn = False
                End If
            End If
        End If
    End Sub
    Protected Sub BindDinamico(ByVal dt As DataTable, ByVal cont As Integer)
        Dim dr As DataRow
        Dim lite As New LiteralControl

        lite.Text = String.Empty


        For Each dr In dt.Rows
            If dr("periodo_factura_ars") Is DBNull.Value Then
                dr("periodo_factura_ars") = ""
            End If

            If dr("ars_des") Is DBNull.Value Then
                dr("ars_des") = ""
            End If

            If dr("nss_dependiente") Is DBNull.Value Then
                dr("nss_dependiente") = ""
            End If

            If dr("nombres") Is DBNull.Value Then
                dr("nombres") = ""
            End If

            If dr("apellidos") Is DBNull.Value Then
                dr("apellidos") = ""
            End If

            If dr("tipo_afiliado") Is DBNull.Value Then
                dr("tipo_afiliado") = ""
            End If

            If dr("parentesco_desc") Is DBNull.Value Then
                dr("parentesco_desc") = ""
            End If

            If dr("id_referencia_dispersion") Is DBNull.Value Then
                dr("id_referencia_dispersion") = ""
            End If

            If dr("monto_dispersar") Is DBNull.Value Then
                dr("monto_dispersar") = 0
            End If

            If dr("razon_social") Is DBNull.Value Then
                dr("razon_social") = ""
            End If

            If dr("RNC") Is DBNull.Value Then
                dr("RNC") = ""
            End If


            lite.Text &= MostrarTabla(dr("periodo_factura_ars"), dr("ars_des"), dr("nss_dependiente"), dr("nombres"), dr("apellidos"), dr("tipo_afiliado"), dr("parentesco_desc"), dr("id_referencia_dispersion"), IIf(IsDBNull(dr("fecha_pago")), String.Empty, dr("fecha_pago")), Convert.ToDecimal(dr("monto_dispersar")), dr("razon_social"), dr("RNC"), dr("no_documento"))

        Next

        lblConsecutivos.Text = periodosConsecutivos.ToString()
        tc1.Tabs(cont).Controls.Add(lite)

    End Sub
    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        Dim tp As New AjaxControlToolkit.TabPanel
        tp.HeaderText = ""
        tp.Visible = False
        tc1.Tabs.Add(tp)


    End Sub
    Protected Overrides Sub OnInit(ByVal e As System.EventArgs)

        Dim tp As New AjaxControlToolkit.TabPanel
        tp.HeaderText = ""
        tp.Visible = False
        tc1.Tabs.Add(tp)

        MyBase.OnInit(e)
    End Sub

    Protected Sub btnRegresar_Click(sender As Object, e As EventArgs) Handles btnRegresar.Click
        Response.Redirect("OficinaVirtual.aspx", True)
    End Sub
End Class
