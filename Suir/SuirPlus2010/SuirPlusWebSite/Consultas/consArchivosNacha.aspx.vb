Imports SuirPlus
Imports System.IO
Imports System.Data
Imports System.IO.Directory

Partial Class Consultas_consArchivosNacha
    Inherits BasePage



    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            'Cargando los txt
            Me.txtDesde.Text = Now.ToShortDateString
            Me.txtHasta.Text = Now.ToShortDateString

            Me.Cargar_Nacha()

            'cargamos los archivos nacha pendientes...
            BuscarArchivosPendientes()
            '
        End If
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        Me.Cargar_Nacha()
    End Sub

    Private Sub Cargar_Nacha()
        'Cargamos los archivos nachas recibidos...
        Dim dt As New Data.DataTable

        dt = Nachas.Nacha.getArchivosCargadosDelDia(txtDesde.Text, txtHasta.Text)

        If dt.Rows.Count > 0 Then
            Me.lblMsg.Visible = False
            Me.gvNachas.DataSource = dt
            Me.gvNachas.DataBind()
        Else
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = "No existen registros"
        End If

    End Sub



    Private Sub BuscarArchivosPendientes()
        Dim oFileInfo As FileInfo
        Dim oDirectoryInfo As DirectoryInfo
        Dim arch As New SuirPlus.Config.Configuracion(Config.ModuloEnum.EnvioNacha)

        'oDirectoryInfo = New DirectoryInfo("C:\UploadedFiles\")
        oDirectoryInfo = New DirectoryInfo(arch.Archives_ERR_DIR)
        
        'oDirectoryInfo = New DirectoryInfo("\\corelli\e$\suirfiles\Archivos_Nacha_Unipago\E\")
        '--creamos el datatable con la lista de archivos existente en la ruta especificada
        Dim myTable As New DataTable

        Dim dc As New DataColumn
        dc.ColumnName = "NombreArchivo"
        myTable.Columns.Add(dc)

        'Dim dc1 As New DataColumn
        'dc1.ColumnName = "Tamaño"
        'myTable.Columns.Add(dc1)

        For Each oFileInfo In oDirectoryInfo.GetFiles("*.txt")

            Dim myrow0 As DataRow
            myrow0 = myTable.NewRow()
            myrow0("NombreArchivo") = oFileInfo.Name
            myTable.Rows.Add(myrow0)

        Next

        If myTable.Rows.Count > 0 Then
            Me.divInfoMenor.Visible = True
            Me.gvArchivosPendientes.DataSource = myTable
            Me.gvArchivosPendientes.DataBind()
        Else
            Me.divInfoMenor.Visible = False

        End If

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("consArchivosNacha.aspx")
    End Sub

    Protected Sub btnRecogerArchivos_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRecogerArchivos.Click
        Dim NachasFaltantes As String
        Try
            NachasFaltantes = Nachas.Nacha.CargarNachasFaltantes()
            If NachasFaltantes <> "000" Then
                Me.lblmsG.visible = True
                Me.lblmsG.text = NachasFaltantes & " | Error cargando los archivos nacha faltantes"
                Exit Sub
            End If

        Catch ex As Exception
            Me.lblmsG.visible = True
            Me.lblmsG.text = ex.Message & " | Error cargando los archivos nacha faltantes"
        End Try



    End Sub
End Class
