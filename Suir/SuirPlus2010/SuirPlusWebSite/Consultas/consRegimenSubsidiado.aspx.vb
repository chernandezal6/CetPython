Imports System.Data
Imports SuirPlus
Partial Class sfsRegimenSubsidiado
    Inherits BasePage

    Dim PeriodoAnterior As String = String.Empty
    Dim cantidad As Integer = 0
    Dim consecutivoOn As Boolean = True
    Dim consecutivos As String = String.Empty
    Dim documento As String = String.Empty
    Shared periodosConsecutivos As Integer = 0
    Dim dt As DataTable = Nothing

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        If String.IsNullOrEmpty(txtDocumento.Text) And String.IsNullOrEmpty(txtNSS.Text) Then
            Me.lblMsg.Text = "Debe específicar un critero."
        Else
            Me.BindGrid()
        End If
    End Sub
    Private Sub NombreCedulaAfiliado()

        Dim dt As New DataTable
        dt = Utilitarios.TSS.getConsultaNss(Me.txtDocumento.Text, Me.txtNSS.Text, String.Empty, String.Empty, String.Empty, 1, 1)

        Try
            documento = dt.Rows("0")("no_documento").ToString()
            lblNombreAfiliado.Text = dt.Rows("0")("nombres").ToString() + " " + dt.Rows("0")("apellidos").ToString()

        Catch ex As Exception

        End Try

    End Sub
    Private Sub BindGrid()
        ltSpan.Text = String.Empty
        ltDiv.Text = String.Empty

        NombreCedulaAfiliado()
        dt = Afiliacion.RegimenSubsidiado.ConsultaSubsidiado(Me.txtDocumento.Text, Me.txtNSS.Text)

        If dt.Rows.Count > 0 Then
            Dim dr As DataRow
            Dim ano As Integer
            Dim anoactual As Integer = 1
            Dim contador As Integer = -1
            Dim ContadorRows As Integer = 0


            For Each dr In dt.Rows
                ContadorRows += 1
                Dim dtano As New DataTable
                dtano = dt.Clone
                ano = Convert.ToInt32(dr("periodo_factura").ToString().Substring(0, 4))


                If anoactual <> ano Then
                    ltSpan.Text += "<li><a href='#" & ano & "'><span> " & ano.ToString() & "</span></a></li>"
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
            Me.lblMsg.Text = "No se encontraron registros!!"
        End If
    End Sub

    Protected Function MostrarTabla(ByVal Periodo As String, ByVal NSS As String, ByVal Nombre As String, ByVal Apellido As String, ByVal Parentesco As String, ByVal Documento As String) As String
        Dim tablita As New StringBuilder
        cantidad = cantidad + 1

        If PeriodoAnterior <> Periodo Then

            If String.IsNullOrEmpty(PeriodoAnterior) Then
                PeriodoAnterior = Periodo
            End If


            PeriodoAnterior = Periodo


            tablita.Append(" <table class='tblContact' cellspacing='0' cellpadding='7'>")
            tablita.Append("<tr>")
            tablita.Append("<td class='tdContactHeader' colspan='8'>")
            tablita.Append("Periodo " & Periodo.Substring(0, 4) & "-" & Periodo.Substring(4, 2) & "")
            tablita.Append("</td>")
            tablita.Append("</tr>")
            tablita.Append("<tr>")
            tablita.Append("<td width='50'><strong>NSS</strong></td>")
            tablita.Append("<td width='70'><strong>Documento</strong></td>")
            tablita.Append("<td colspan='2' width='100'>")
            tablita.Append("<strong>Nombre</strong></td>")
            tablita.Append("<td colspan='1' width='100'>")
            tablita.Append("<strong>Apellido</strong></td>")
            tablita.Append("<td colspan='1' width='100'>")
            tablita.Append("<strong>Parentesco</strong></td>")
            tablita.Append("<td colspan='1' width='100'>")
            tablita.Append("<strong>Per Capita</strong></td>")
            tablita.Append("<td colspan='1'>")
            tablita.Append("</tr>")

            tablita.Append("<tr>")
            tablita.Append("<td><a href='ConsCiudadano.aspx?NSS=" & NSS & "'>" & NSS & "</a></td>")
            tablita.Append("<td colspan='1'>" & Documento & "</td>")
            tablita.Append("<td colspan='2'>" & Nombre & "</td>")
            tablita.Append("<td colspan='1'>" & Apellido & "</td>")
            tablita.Append("<td colspan='1'>" & Parentesco & "</td>")
            tablita.Append("</tr>")

        Else

            'Solo escribo los tr
            tablita.Append("<tr>")
            tablita.Append("<td><a href='ConsCiudadano.aspx?NSS=" & NSS & "'>" & NSS & "</a></td>")
            tablita.Append("<td colspan='1'>" & Documento & "</td>")
            tablita.Append("<td colspan='2'>" & Nombre & "</td>")
            tablita.Append("<td colspan='1'>" & Apellido & "</td>")
            tablita.Append("<td colspan='1'>" & Parentesco & "</td>")

            tablita.Append("</tr>")

        End If

        'Si es el ultimo registro o si el periodo va a cambiar cerramos la tabla
        If dt.Rows.Count = cantidad Then
            tablita.Append("</table>")
        ElseIf dt.Rows(cantidad)("periodo_factura").ToString <> Periodo Then
            tablita.Append("</table>")
        End If


        Return tablita.ToString()

    End Function

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("consRegimenSubsidiado.aspx")

    End Sub

    Protected Sub BindDinamico(ByVal dt As DataTable, ByVal cont As Integer)
        Dim dr As DataRow
        Dim lite As New LiteralControl

        lite.Text = String.Empty

        lite.Text = "<div id='" & dt.Rows(0)("periodo_factura").ToString().Substring(0, 4) & "'>"

        For Each dr In dt.Rows
            If dr("periodo_factura") Is DBNull.Value Then
                dr("periodo_factura") = ""
            End If

            If dr("nss_t") Is DBNull.Value Then
                dr("nss_t") = ""
            End If

            If dr("nombres") Is DBNull.Value Then
                dr("nombres") = ""
            End If

            If dr("apellidos") Is DBNull.Value Then
                dr("apellidos") = ""
            End If


            If dr("parentesco_desc") Is DBNull.Value Then
                dr("parentesco_desc") = ""
            End If


            lite.Text += MostrarTabla(dr("periodo_factura"), dr("nss_t"), dr("nombres"), dr("apellidos"), dr("parentesco_desc"), dr("no_documento"))

        Next

        lite.Text += "</div>"

        divConsecutivas.Visible = True

        ltDiv.Text += lite.Text

    End Sub

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            ltSpan.Text = "<li><a href='#No'><span>Resultados</span></a></li>"
            ltDiv.Text = "<div id='No'></div>"
        End If
    End Sub
End Class
