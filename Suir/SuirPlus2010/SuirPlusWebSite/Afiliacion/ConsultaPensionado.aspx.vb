Imports SuirPlus
Imports System.Data
Partial Class Afiliacion_ConsultaPensionado
    Inherits BasePage
    Private Property Documento() As Byte()
        Get
            If ViewState("Documento") Is Nothing Then
                Return Nothing
            Else
                Return ViewState("Documento")
            End If
        End Get
        Set(ByVal value As Byte())
            ViewState("Documento") = value
        End Set
    End Property
    Dim dt As New DataTable
    Dim cantidad As Integer = 0
    Dim PeriodoAnterior As String = String.Empty

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("ConsultaPensionado.aspx")
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        If String.IsNullOrEmpty(txtCedula.Text) And String.IsNullOrEmpty(txtNoPensionado.Text) Then
            lblMensaje.Text = "Debe completar uno de los filtros."
        Else
            Limpiar()
            LoadData()
        End If
    End Sub

    Private Sub LoadData()
        Dim dt As New DataTable

        dt = Afiliacion.Afiliaciones.getPensionado(Me.txtCedula.Text, Me.txtNoPensionado.Text)

        If dt.Rows.Count > 0 Then

            'Llenando los datos de la Secretaria de Estado de Hacienda
            If Not IsDBNull(dt.Rows(0)("pensionado")) Then
                lblNoPensionado.Text = dt.Rows(0)("pensionado")
            Else
                lblNoPensionado.Text = "N/A"
            End If


            If Not IsDBNull(dt.Rows(0)("institucion")) Then
                lblInstituto.Text = dt.Rows(0)("institucion")
            Else
                lblInstituto.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("no_documento")) Then
                lblNoDocumentoSeh.Text = dt.Rows(0)("no_documento")
            Else
                lblNoDocumentoSeh.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("nombre")) Then
                lblNombreSeh.Text = dt.Rows(0)("nombre")
            Else
                lblNombreSeh.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("fecha_nacimiento")) Then
                lblFechaNacimiento.Text = dt.Rows(0)("fecha_nacimiento")
            Else
                lblFechaNacimiento.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("direccion")) Then
                lblDireccion.Text = dt.Rows(0)("direccion")
            Else
                lblDireccion.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("telefono")) Then
                lblTelefono.Text = dt.Rows(0)("telefono")
            Else
                lblTelefono.Text = "N/A"
            End If


            'Mostrando Datos de JCE
            If Not IsDBNull(dt.Rows(0)("nombre_ciu")) Then
                lblNombre.Text = dt.Rows(0)("nombre_ciu")
            Else
                lblNombre.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("fecha_nac_ciu")) Then
                lblFechaNacimientoJce.Text = dt.Rows(0)("fecha_nac_ciu")
            Else
                lblFechaNacimientoJce.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("status")) Then
                lblStatus.Text = dt.Rows(0)("status")
            Else
                lblStatus.Text = "N/A"
            End If
           
            'Mostrando los datos de la afiliacion
            If Not IsDBNull(dt.Rows(0)("ars_des")) Then
                lblARS.Text = dt.Rows(0)("ars_des")
            Else
                lblARS.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("desc_status")) Then
                lblEstatus.Text = dt.Rows(0)("desc_status")
            Else
                lblEstatus.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("fecha_afiliacion")) Then
                lblFechaAfiliacion.Text = dt.Rows(0)("fecha_afiliacion")
            Else
                lblFechaAfiliacion.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("fecha_baja_seh")) Then
                lblFechaBaja.Text = dt.Rows(0)("fecha_baja_seh")
            Else
                lblFechaBaja.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("fecha_desafiliacion")) Then
                lblFechaDesafiliacion.Text = dt.Rows(0)("fecha_desafiliacion")
            Else
                lblFechaDesafiliacion.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("fecha_registro")) Then
                lblFechaRegistro.Text = dt.Rows(0)("fecha_registro")
            Else
                lblFechaRegistro.Text = "N/A"
            End If

            If Not IsDBNull(dt.Rows(0)("documentacion")) Then
                Documento = dt.Rows(0)("documentacion")
                lnkImagen.Enabled = True
            Else
                lnkImagen.Enabled = False
            End If

            'Llenando las novedades
            Dim dts As DataTable = Afiliacion.Afiliaciones.getNovedadesPensionado(dt.Rows(0)("pensionado").ToString())
            If dts.Rows.Count > 0 Then
                gvNovedades.DataSource = dts
                gvNovedades.databind()
            End If


            'Llenando el Historico
            BindHistorico(dt.Rows(0)("pensionado").ToString())

            pnlDatos.Visible = True
        Else
            lblMensaje.Text = "No se encontraron registro para esta busqueda."
            pnlDatos.Visible = False
        End If
    End Sub

    Protected Sub lnkImagen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkImagen.Click
        'If Not IsNothing(Documento) Then
        'Response.Clear()
        'Response.AddHeader("content-disposition", "attachment;filename=" & lblNoPensionado.Text & ".tif")
        'Response.Charset = ""
        'Response.Cache.SetCacheability(HttpCacheability.NoCache)
        'Response.ContentType = "image/tiff"
        'Response.BinaryWrite(Documento)
        'Response.End()

        If Documento IsNot Nothing Then
            Dim tipoBlob As String = Utilitarios.Utils.getMimeFromFile(Documento)

            Select Case tipoBlob

                Case "application/pdf" 'pdf-"application/pdf"
                    Response.AddHeader("Content-Disposition", "filename=Documento.pdf")
                    Response.ContentType = "application/pdf"
                    Response.BinaryWrite(Documento)
                Case "application/octet-stream" 'tiff-"application/octet-stream"
                    Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                    Response.ContentType = "image/tiff"
                    Response.BinaryWrite(Documento)
                Case "image/pjpeg" 'jpg-"image/pjpeg"
                    Response.AddHeader("Content-Disposition", "filename=Documento.jpeg")
                    Response.ContentType = "image/pjpeg"
                    Response.BinaryWrite(Documento)
                Case "application/x-zip-compressed" 'doc
                    Response.AddHeader("Content-Disposition", "filename=Documento.doc")
                    Response.ContentType = "application/msword"
                    Response.BinaryWrite(Documento)
                Case Else
                    Response.AddHeader("Content-Disposition", "filename=Documento.tiff")
                    Response.ContentType = "image/tiff"
                    Response.BinaryWrite(Documento)
            End Select

        End If
    End Sub

    Private Sub Limpiar()
        lblNoPensionado.Text = String.Empty
        lblInstituto.Text = String.Empty
        lblNoDocumentoSeh.Text = String.Empty
        lblNombreSeh.Text = String.Empty
        lblFechaNacimiento.Text = String.Empty
        lblDireccion.Text = String.Empty
        lblTelefono.Text = String.Empty
        lblNombre.Text = String.Empty
        lblFechaNacimientoJce.Text = String.Empty
        lblStatus.Text = String.Empty
        lblARS.Text = String.Empty
        lblEstatus.Text = String.Empty
        lblFechaAfiliacion.Text = String.Empty
        lblFechaBaja.Text = String.Empty
        lblFechaDesafiliacion.Text = String.Empty
        lblFechaRegistro.Text = String.Empty
        lnkImagen.Enabled = False
    End Sub

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        Dim tp As New AjaxControlToolkit.TabPanel
        tp.HeaderText = ""
        tp.Visible = False
        tc1.Tabs.Add(tp)
    End Sub

    Private Sub BindHistorico(ByVal Pensionado As Integer)


        dt = Afiliacion.Afiliaciones.getHistoricoPensionado(Pensionado)

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
                ano = Convert.ToInt32(dr("periodo_cartera").ToString().Substring(0, 4))

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
            Me.lblResultados.Text = "No se encontraron registros!!"
        End If
    End Sub

    Protected Function MostrarTabla(ByVal pensionado As String, ByVal periodo_cartera As String, ByVal id_ars As String, ByVal ars_des As String, ByVal nombre As String, ByVal monto_dispersar As String, ByVal fecha_dispersion As DateTime, ByVal registro_dispersado As String) As String
        Dim tablita As New StringBuilder
        cantidad = cantidad + 1

        If PeriodoAnterior <> periodo_cartera Then
            If String.IsNullOrEmpty(PeriodoAnterior) Then
                PeriodoAnterior = periodo_cartera
            End If


            PeriodoAnterior = periodo_cartera

            tablita.Append(" <table class='tblContact' cellspacing='0' cellpadding='3'>")
            tablita.Append("<tr>")
            tablita.Append("<td class='tdContactHeader' colspan='4'>")
            tablita.Append("Periodo " & periodo_cartera.Substring(0, 4) & "-" & periodo_cartera.Substring(4, 2) & "")
            tablita.Append("</td>")
            tablita.Append("<td class='tdContactHeader' colspan='3'>")
            tablita.Append(ars_des & "")
            tablita.Append("</td>")
            tablita.Append("</tr>")

            tablita.Append("<tr>")
            tablita.Append("<td width='50'><strong>Pensionado</strong></td>")
            tablita.Append("<td colspan='2' width='200'>")
            tablita.Append("<strong>Nombre</strong></td>")
            tablita.Append("<td colspan='1' width='75'>")
            tablita.Append("<strong>Fecha Pago</strong></td>")
            tablita.Append("<td colspan='1' style='text-align:right' width='75'>")
            tablita.Append("<strong>Per Capita</strong></td>")
            tablita.Append("<td colspan='1'>")
            tablita.Append("<strong>Dispersado</strong></td>")
            tablita.Append("</tr>")

            tablita.Append("<tr>")
            tablita.Append("<td>" & pensionado & "</td>")
            tablita.Append("<td colspan='2'>" & nombre & "</td>")
            tablita.Append("<td colspan='1'>" & IIf(fecha_dispersion = Nothing, String.Empty, FormatDateTime(fecha_dispersion, DateFormat.ShortDate)) & "</td>")
            tablita.Append("<td colspan='1' style='text-align:right'>" & FormatNumber(monto_dispersar) & "</td>")
            tablita.Append("<td colspan='1' style='text-align:center'>" & IIf(fecha_dispersion = Nothing, "<img src='../images/error.gif' alt=''/>", "<img src='../images/ok.gif' alt=''/>") & "</td>")
            tablita.Append("</tr>")

        Else

            'Solo escribo los tr
            tablita.Append("<tr>")
            tablita.Append("<td>" & pensionado & "</td>")
            tablita.Append("<td colspan='2'>" & nombre & "</td>")
            tablita.Append("<td colspan='1'>" & IIf(fecha_dispersion = Nothing, String.Empty, FormatDateTime(fecha_dispersion, DateFormat.ShortDate)) & "</td>")
            tablita.Append("<td colspan='1' style='text-align:right'>" & FormatNumber(monto_dispersar) & "</td>")
            tablita.Append("<td colspan='1' style='text-align:center'>" & IIf(fecha_dispersion = Nothing, "<img src='../images/error.gif' alt=''/>", "<img src='../images/ok.gif' alt=''/>") & "</td>")
            tablita.Append("</tr>")

        End If

        'Si es el ultimo registro o si el periodo va a cambiar cerramos la tabla
        If dt.Rows.Count = cantidad Then
            tablita.Append("</table>")
        ElseIf dt.Rows(cantidad)("pensionado").ToString = "Titular" Then
            tablita.Append("</table>")
        End If


        Return tablita.ToString()

    End Function

    Protected Sub BindDinamico(ByVal dt As DataTable, ByVal cont As Integer)
        Dim dr As DataRow
        Dim lite As New LiteralControl

        lite.Text = String.Empty

        For Each dr In dt.Rows

            If dr("pensionado") Is DBNull.Value Then
                dr("pensionado") = ""
            End If

            If dr("periodo_cartera") Is DBNull.Value Then
                dr("periodo_cartera") = ""
            End If

            If dr("id_ars") Is DBNull.Value Then
                dr("id_ars") = ""
            End If

            If dr("ars_des") Is DBNull.Value Then
                dr("ars_des") = 0
            End If

            If dr("nombre") Is DBNull.Value Then
                dr("nombre") = 0
            End If

            If dr("monto_dispersar") Is DBNull.Value Then
                dr("monto_dispersar") = 0
            End If

            If dr("fecha_dispersion") Is DBNull.Value Then
                dr("fecha_dispersion") = DateTime.MinValue
            End If

            If dr("registro_dispersado") Is DBNull.Value Then
                dr("registro_dispersado") = 0
            End If

            lite.Text &= MostrarTabla(dr("pensionado"), dr("periodo_cartera"), dr("id_ars"), dr("ars_des"), dr("nombre"), dr("monto_dispersar"), dr("fecha_dispersion"), dr("registro_dispersado"))

        Next

        tc1.Tabs(cont).Controls.Add(lite)

    End Sub

    
End Class
