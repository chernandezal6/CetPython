Imports System.Data

Partial Class Bancos_consResultadoEnvio
    Inherits BasePage

    Protected dtP As DataTable
    Protected dtA As DataTable
    Dim Pagos As Boolean = False
    Dim Aclaraciones As Boolean = False
    Dim Titulo As String
    Dim dt As Object

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Put user code to initialize the page here
    End Sub
    Private Sub setFormError(ByVal msg As String)
        Me.lblFormError.Text = "<br>" + msg + "<br>"
    End Sub

    Private Sub getArchivo()
        Dim dt As New DataTable

        Try

            dt = SuirPlus.Empresas.Archivo.getArchivo(CInt(Me.txtEnvio.Text))

            If dt.Rows.Count > 0 Then
                Me.pnlInfo.Visible = True
                Me.lblEntidadRecaudadora.Text = dt.Rows(0).Item(2).ToString
                Me.lbltipo.Text = dt.Rows(0).Item(3).ToString
                Me.lblArchivo.Text = dt.Rows(0).Item(4).ToString
                Me.lblFechaCarga.Text = dt.Rows(0).Item(5).ToString
                Me.lblUsrCarga.Text = dt.Rows(0).Item(6).ToString



            Else
                Me.pnlInfo.Visible = False
            End If

        Catch ex As Exception
            Me.lblFormError.Text = ex.ToString
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub
    Private Sub ArchivosPagos()

        Try

            dtP = SuirPlus.Bancos.Dgii.getRespuestaPagos(CInt(Me.txtEnvio.Text))

            If dtP.Rows.Count > 0 Then
                Me.gvPagos.DataSource = dtP
                Me.gvPagos.DataBind()
                Me.pnlPagos.Visible = True
                Session("Tipo") = "P"
                Me.UcExportarExcel1.Visible = True

            Else
                Me.pnlPagos.Visible = False
            End If

        Catch ex As Exception
            Me.lblFormError.Text = ex.ToString
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())

        End Try
    End Sub

    Private Sub ArchivosAclaraciones()

        Try
            dtA = SuirPlus.Bancos.Dgii.getRespuestaAclaraciones(CInt(Me.txtEnvio.Text))

            If dtA.Rows.Count > 0 Then
                Me.gvAclaraciones.DataSource = dtA
                Me.gvAclaraciones.DataBind()
                Me.pnlAclaraciones.Visible = True
                Session("Tipo") = "A"
                Me.UcExportarExcel1.Visible = True
            Else
                Me.pnlAclaraciones.Visible = False
            End If

        Catch ex As Exception
            Me.lblFormError.Text = ex.ToString
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())

        End Try
    End Sub

    Private Sub On_ExportaExcel(ByVal sender As Object, ByVal e As EventArgs) Handles UcExportarExcel1.ExportaExcel
        If Session("Tipo") = "P" Then
            dt = SuirPlus.Bancos.Dgii.getRespuestaPagos(CInt(Me.txtEnvio.Text))
            Titulo = "Resultado Pagos"
            UcExportarExcel1.FileName = Titulo
            UcExportarExcel1.DataSource = dt
        Else
            dt = SuirPlus.Bancos.Dgii.getRespuestaAclaraciones(CInt(Me.txtEnvio.Text))
            Titulo = "Resultado de Aclaraciones"
            UcExportarExcel1.FileName = Titulo
            UcExportarExcel1.DataSource = dt
        End If
    End Sub

    Private Sub btBuscarRef_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btBuscarRef.Click
        Me.getArchivo()
        Me.ArchivosPagos()
        Me.ArchivosAclaraciones()
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        'Response.Redirect("consResultadoEnvio.aspx")
        Me.pnlInfo.Visible = False
        Me.pnlPagos.Visible = False
        Me.pnlAclaraciones.Visible = False
        Me.txtEnvio.Text = String.Empty
        Me.UcExportarExcel1.Visible = False

    End Sub
End Class

