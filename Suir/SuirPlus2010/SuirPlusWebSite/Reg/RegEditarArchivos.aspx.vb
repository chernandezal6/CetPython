Imports System.IO
Imports System.IO.File

Partial Class Reg_RegEditarArchivos
    Inherits System.Web.UI.Page

    Public ReadOnly Property Solicitud() As String
        Get
            Return Context.Request.QueryString("Codsolicitud")
        End Get
    End Property
    Public ReadOnly Property Requisito() As String
        Get
            Return Context.Request.QueryString("idrequisito")
        End Get
    End Property
    Public ReadOnly Property Id_Solicitud() As String
        Get
            Return Context.Request.QueryString("idSolicitud")
        End Get
    End Property
    Public ReadOnly Property NombreArchivo() As String
        Get
            Return Context.Request.QueryString("NombreArchivo")
        End Get
    End Property
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If IsPostBack Then
            UploadPhoto()
        End If
    End Sub
    Sub UploadPhoto()
        Dim script = String.Empty
        If Not fileCharge.PostedFile Is Nothing And fileCharge.PostedFile.ContentLength > 0 Then
            UploadDocumentacion(fileCharge, Requisito)
        End If
        ClientScript.RegisterStartupScript(Me.GetType(), "Notificación de la Carga", script)
    End Sub
    Public Sub UploadDocumentacion(Archivo As HtmlInputFile, Req As String)

        '    var path = Server.MapPath(@"test.pdf");
        '    byte[] bytes = System.IO.File.ReadAllBytes(path);

        '    Response.Clear();
        '    MemoryStream ms = new MemoryStream(bytes);
        '    Response.ContentType = "application/pdf";
        '    Response.AddHeader("content-disposition", "filename=prueba.pdf");
        '    Response.Buffer = true;
        '    ms.WriteTo(Response.OutputStream);
        '    Response.End();

        Try
            Dim script = String.Empty
            'Lectura del Archivo
            Dim Ruta As String = Archivo.PostedFile.FileName
            Dim NombreArchivo As String = Path.GetFileName(Ruta)
            Dim Extension As String = Path.GetExtension(NombreArchivo)
            Dim ContentType As String = String.Empty

            'Listado de Archivos
            Select Case Extension.ToLower()
                Case ".doc"
                    ContentType = "application/vnd.ms-word"
                    Exit Select
                Case ".docx"
                    ContentType = "application/vnd.ms-word"
                    Exit Select
                Case ".xls"
                    ContentType = "application/vnd.ms-excel"
                    Exit Select
                Case ".xlsx"
                    ContentType = "application/vnd.ms-excel"
                    Exit Select
                Case ".jpg"
                    ContentType = "image/jpg"
                    Exit Select
                Case ".png"
                    ContentType = "image/png"
                    Exit Select
                Case ".gif"
                    ContentType = "image/gif"
                    Exit Select
                Case ".tiff"
                    ContentType = "image/tiff"
                    Exit Select
                Case ".tif"
                    ContentType = "image/tif"
                    Exit Select
                Case ".pdf"
                    ContentType = "application/pdf"
                    Exit Select
            End Select

            Dim resultado = String.Empty
            Dim fs As Stream = Archivo.PostedFile.InputStream
            Dim br As New BinaryReader(fs)
            Dim bytes As Byte() = br.ReadBytes(fs.Length)

            If hdPropiedad.Value = "INSERTAR" Then
                resultado = SuirPlus.SolicitudesEnLinea.Solicitudes.InsertarArchivoSolicitud(Solicitud, Req, bytes, NombreArchivo, ContentType)
            End If
            If hdPropiedad.Value = "ACTUALIZAR" Then
                resultado = SuirPlus.SolicitudesEnLinea.Solicitudes.ActualizarArchivoSolicitud(Id_Solicitud, Req, NombreArchivo, bytes, ContentType)
            End If

            ''Carga de archivo
            If resultado <> "0" Then

                script = String.Format("resultado.", "true")

            End If
            'script = String.Format(SCRIPT_TEMPLATE, "Archivo cargado de manera satisfactoria.")

            ClientScript.RegisterStartupScript(Me.GetType(), "uploadNotify", script)

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub btnVer_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        ' Handle your Button clicks here
        'Aqui debe ir la descomposión del DataSet para obtener el arreglo de Bytes de la BD
        Dim File = SuirPlus.SolicitudesEnLinea.Solicitudes.GetEditArchivo(Id_Solicitud, Requisito)
        Dim bytes As Byte() = System.IO.File.ReadAllBytes(File)

        Response.Clear()
        Dim ms As MemoryStream = New MemoryStream(bytes)
        Response.ContentType = "application/pdf"
        Response.AddHeader("content-disposition", "filename=prueba.pdf")
        Response.Buffer = True
        ms.WriteTo(Response.OutputStream)
        Response.End()
    End Sub
End Class
