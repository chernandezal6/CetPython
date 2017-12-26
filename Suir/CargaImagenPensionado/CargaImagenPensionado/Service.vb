Imports ReducirImagen
Imports Oracle.DataAccess.Client
Imports System
Imports System.IO
Imports System.Text
Public Class Service

#Region "Variables Publicas"
    Dim content As Byte()

    Dim ruta As String = String.Empty
    Dim Ignorar As Boolean = False
    Dim correoTO As String = "hector_minaya@mail.tss2.gov.do"
    Dim correoCC As String = "mayreni_vargas@mail.tss2.gov.do"
#End Region

    Protected Overrides Sub OnStart(ByVal args() As String)
        'Cuando comienze el servicio iniciamos el timer
        TimeEjecuta.Start()
        TimeEjecuta.Interval = CDbl(System.Configuration.ConfigurationManager.AppSettings("INTERVAL").ToString)

    End Sub

    Protected Overrides Sub OnStop()
        'Cuando termine el servicio detenemos el timer
        TimeEjecuta.Stop()
    End Sub


    Private Sub ProcesarArchivos()
        Try

            'Folder de los archivos procesados
            Dim FolderRecibidos As New IO.DirectoryInfo(System.Configuration.ConfigurationManager.AppSettings("ArchivosRecibidos"))

            'Listandos las carpetas
            Dim Folders As IO.DirectoryInfo() = FolderRecibidos.GetDirectories()

            For Each Folder As IO.DirectoryInfo In Folders
                'Listando los archivos de la carpeta en cuestion
                Dim Archivos As IO.FileInfo() = Folder.GetFiles("*.tif")

                For Each Archivo In Archivos


                    If ValidarArchivo(Archivo, Folder) Then

                        If Ignorar = False Then

                            Try
                                'Si existe el archivo que lo borre y cargue el nuevo
                                If IO.File.Exists(System.Configuration.ConfigurationManager.AppSettings("ArchivosProcesados") & "\" & Archivo.Name) Then
                                    IO.File.Delete(System.Configuration.ConfigurationManager.AppSettings("ArchivosProcesados") & "\" & Archivo.Name)
                                End If

                                'Escribir en la carpeta valida
                                System.IO.File.Move(System.Configuration.ConfigurationManager.AppSettings("ArchivosRecibidos") & "\" & Folder.Name & "\" & Archivo.Name, System.Configuration.ConfigurationManager.AppSettings("ArchivosProcesados") & "\" & Archivo.Name)
                            Catch ex As System.IO.IOException
                                GenerarArchivoError("Se movio el/los archivos de recibidos a procesados", "  Descripcion: " & ex.ToString(), "Nombre del archivo:" & Archivo.Name, " " & "Fecha: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))
                                'No hagas na
                            Catch ex As Exception
                                GenerarArchivoError("Se movio el/los archivos de recibidos a procesados", "  Descripcion: " & ex.ToString(), "Nombre del archivo:" & Archivo.Name, " " & "Fecha: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))
                                'Enviar_Correo("Mensaje de error en la carga de imagen de Afiliacion", "  Descripcion: " & ex.ToString())
                            End Try

                        Else
                            Ignorar = False

                            Try
                                'Si existe el archivo que lo borre y cargue el nuevo
                                If IO.File.Exists(System.Configuration.ConfigurationManager.AppSettings("Temporal") & "\" & Archivo.Name) Then
                                    IO.File.Delete(System.Configuration.ConfigurationManager.AppSettings("Temporal") & "\" & Archivo.Name)
                                End If

                                'Escribir en la carpeta de Temporal
                                System.IO.File.Move(System.Configuration.ConfigurationManager.AppSettings("ArchivosRecibidos") & "\" & Folder.Name & "\" & Archivo.Name, System.Configuration.ConfigurationManager.AppSettings("temporal") & "\" & Archivo.Name)
                            Catch ex As System.IO.IOException
                                'No hagas na
                            Catch ex As Exception
                                GenerarArchivoError("Se movio el/los archivos de recibidos a procesados", "  Descripcion: " & ex.ToString(), "Nombre del archivo:" & Archivo.Name, " " & "Fecha: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))
                                '  Enviar_Correo("Mensaje de error en la carga de imagen de Afiliacion", "  Descripcion: " & ex.ToString())
                            End Try
                        End If

                    Else
                        Try
                            'Si existe el archivo que lo borre y cargue el nuevo
                            If IO.File.Exists(System.Configuration.ConfigurationManager.AppSettings("ArchivosConError") & "\" & Archivo.Name) Then
                                IO.File.Delete(System.Configuration.ConfigurationManager.AppSettings("ArchivosConError") & "\" & Archivo.Name)
                            End If


                            'Escribir en la carpeta de Error
                            System.IO.File.Move(System.Configuration.ConfigurationManager.AppSettings("ArchivosRecibidos") & "\" & Folder.Name & "\" & Archivo.Name, System.Configuration.ConfigurationManager.AppSettings("ArchivosConError") & "\" & Archivo.Name)
                        Catch ex As System.IO.IOException
                            'No hagas na
                        Catch ex As Exception
                            GenerarArchivoError("Se movio el/los archivos de recibidos a procesados", "  Descripcion: " & ex.ToString(), "Nombre del archivo:" & Archivo.Name, " " & "Fecha: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))
                            '  Enviar_Correo("Mensaje de error en la carga de imagen de Afiliacion", "  Descripcion: " & ex.ToString())
                        End Try
                    End If

                Next
                Archivos = Nothing
            Next

        Catch ex As Exception
            'Enviamos mensaje de error
            GenerarArchivoError("Se movio el/los archivos de recibidos a procesados", "  Descripcion: " & ex.ToString(), "", " " & "Fecha: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))
            'Enviar_Correo("Mensaje de error en la carga de imagen de Afiliacion", "  Descripcion: " & ex.ToString())
        End Try


    End Sub


    Private Function ValidarArchivo(ByVal Archivo As IO.FileInfo, ByVal Carpeta As IO.DirectoryInfo) As Boolean
        Try
            Dim IDARS As String = String.Empty
            Dim ARSArchivo As String = String.Empty
            Dim CodPensionado As String = String.Empty

            'Capturando el ID de la ARS
            If Carpeta.Name = "SaludSegura" Then
                IDARS = "02"
            ElseIf Carpeta.Name = "SEMMA" Then
                IDARS = "42"
            ElseIf Carpeta.Name = "SENASA" Then
                IDARS = "52"
            End If

            'Validando la nomeclatura
            If Not Archivo.Name.Contains("_") Then
                'Fallo la nomeclatura
                GuardarArchivoInvalido("200", Archivo.Name, IDARS)
                Return False

            Else
                ARSArchivo = Split(Archivo.Name, "_")(0)
                CodPensionado = Split(Split(Archivo.Name, "_")(1), ".")(0)

                'Validando que archivo pertenzca a esa ARS
                If IDARS <> ARSArchivo Then
                    'No es de la ARS*
                    GuardarArchivoInvalido("P07", Archivo.Name, IDARS)
                    Return False
                End If

                'Validando el NoPensionado
                If Not IsNumeric(CodPensionado) Then
                    'Fallo la nomeclatura
                    GuardarArchivoInvalido("200", Archivo.Name, IDARS)
                    Return False
                End If


                Dim arrParam As OracleParameter() = New OracleParameter(2) {}

                arrParam(0) = New OracleParameter("p_idars", OracleDbType.Double)
                arrParam(0).Value = IDARS
                arrParam(1) = New OracleParameter("p_nropensionado", OracleDbType.Double)
                arrParam(1).Value = CodPensionado
                arrParam(2) = New OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000)
                arrParam(2).Direction = ParameterDirection.Output

                Dim cmdStr As [String] = "SEH_PENSIONADOS_PKG.validarPensionado"


                ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam)

                Dim resultado As String = arrParam(2).Value.ToString()
                'Si ocurre un error en la db manejamos la excepcion de lo contrario seguimos con el proceso
                If Split(resultado, "|")(0) = "P02" Then
                    'No es esta en la Db en el pensionado*
                    GenerarArchivoError("Guardando archivo invalido", "  Descripcion: Error P02", "Nombre del Archivo: " & Archivo.Name, " " & "Fecha: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))
                    GuardarArchivoInvalido("P02", Archivo.Name, IDARS)
                    Return False
                ElseIf Split(resultado, "|")(0) = "P07" Then
                    'No es de la ARS*
                    GenerarArchivoError("Guardando archivo invalido", "  Descripcion: Error P07", "Nombre del Archivo: " & Archivo.Name, " " & "Fecha: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))
                    GuardarArchivoInvalido("P07", Archivo.Name, IDARS)
                    Return False
                ElseIf Split(resultado, "|")(0) = "00" Then
                    'Error de status del pensionado
                    GenerarArchivoError("Error con el status del pensionado. Debe estar PE o OK, favor verificar", "  Descripcion: Error 00", "Nombre del Archivo: " & Archivo.Name, " " & "Fecha: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))
                    Ignorar = True
                    Return True
                End If
            End If


            Try
                'Reduciendo la imagen a copiar
                Reducir(Archivo, System.Configuration.ConfigurationManager.AppSettings("ReducirTemporal"), Carpeta.FullName)
                Archivo.Refresh()
                'Cargando la imagen a guardar en la db
                content = New Byte(Archivo.Length - 1) {}
                Dim imagestream As System.IO.FileStream = Archivo.OpenRead()
                imagestream.Read(content, 0, content.Length)
                imagestream.Close()
                imagestream.Dispose()

                'Si todo funciono correctamente insertamos en la db
                CambiarStatusArchivo(CodPensionado)
                GuardarArchivoValido(Archivo.Name, IDARS)
            Catch ex As System.IO.IOException
                'No hagas na
                GenerarArchivoError("Mensaje de error en la carga de imagen de Afiliacion", "  Descripcion: " & ex.ToString(), "Nombre del Archivo: " & Archivo.Name, " " & "Fecha: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))
                Ignorar = True
            Catch ex As System.OutOfMemoryException
                'No hagas nada        
                GenerarArchivoError("Mensaje de error en la carga de imagen de Afiliacion", "  Descripcion: " & ex.ToString(), "Nombre del Archivo: " & Archivo.Name, " " & "Fecha: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))
                Ignorar = True
            Catch ex As System.ArgumentException
                GenerarArchivoError("Mensaje de error en la carga de imagen de Afiliacion", "  Descripcion: " & ex.ToString(), "Nombre del Archivo: " & Archivo.Name, " " & "Fecha: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))
                Return False
            Catch ex As System.NullReferenceException
                GenerarArchivoError("Mensaje de error en la carga de imagen de Afiliacion", "  Descripcion: " & ex.ToString(), "Nombre del Archivo: " & Archivo.Name, " " & "Fecha: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))
                Return False
            Catch ex As Exception
                Ignorar = True
                GenerarArchivoError("Mensaje de error en la carga de imagen de Afiliacion", "  Descripcion: " & ex.ToString(), "Nombre del Archivo: " & Archivo.Name, " " & "Fecha: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))
                'Enviar_Correo("Mensaje de error en la carga de imagen de Afiliacion", "  Descripcion: " & ex.ToString())
            End Try

            Return True

        Catch ex As System.IO.IOException
            'No hagas na
            GenerarArchivoError("Mensaje de error en la carga de imagen de Afiliacion", "  Descripcion: " & ex.ToString(), "Nombre del Archivo: " & Archivo.Name, " " & "Fecha: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))
            Ignorar = True
            Return True
        Catch ex As Exception
            GenerarArchivoError("Mensaje de error en la carga de imagen de Afiliacion", "  Descripcion: " & ex.ToString(), "Nombre del Archivo: " & Archivo.Name, " " & "Fecha: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))
            '  Enviar_Correo("Mensaje de error en la carga de imagen de Afiliacion", "  Descripcion: " & ex.ToString())
            Ignorar = True
            Return True
        End Try
    End Function

    Private Sub GuardarArchivoInvalido(ByVal IDError As String, ByVal NombreArchivo As String, ByVal IdARS As String)

        Dim arrParam As OracleParameter() = New OracleParameter(3) {}

        arrParam(0) = New OracleParameter("p_ID_ARS", OracleDbType.Double)
        arrParam(0).Value = IdARS
        arrParam(1) = New OracleParameter("p_NOMBRE", OracleDbType.NVarchar2)
        arrParam(1).Value = NombreArchivo
        arrParam(2) = New OracleParameter("p_CODIGO_ERROR", OracleDbType.NVarchar2)
        arrParam(2).Value = IDError
        arrParam(3) = New OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000)
        arrParam(3).Direction = ParameterDirection.Output

        Dim cmdStr As [String] = "SEH_PENSIONADOS_PKG.AgregarDocInvalidados"


        ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam)

    End Sub

    Private Sub GuardarArchivoValido(ByVal NombreArchivo As String, ByVal IdARS As String)

        Dim arrParam As OracleParameter() = New OracleParameter(2) {}

        arrParam(0) = New OracleParameter("p_ID_ARS", OracleDbType.Double)
        arrParam(0).Value = IdARS
        arrParam(1) = New OracleParameter("p_NOMBRE_IMAGEN", OracleDbType.NVarchar2)
        arrParam(1).Value = NombreArchivo
        arrParam(2) = New OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000)
        arrParam(2).Direction = ParameterDirection.Output

        Dim cmdStr As [String] = "SEH_PENSIONADOS_PKG.AgregarDocValidados"


        ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam)

    End Sub

    Private Sub CambiarStatusArchivo(ByVal NoPensionado As String)

        Dim arrParam As OracleParameter() = New OracleParameter(2) {}

        arrParam(0) = New OracleParameter("p_nropensionado", OracleDbType.Double)
        arrParam(0).Value = NoPensionado
        arrParam(1) = New OracleParameter("p_imagen", OracleDbType.Blob)
        arrParam(1).Value = content
        arrParam(2) = New OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000)
        arrParam(2).Direction = ParameterDirection.Output

        Dim cmdStr As [String] = "SEH_PENSIONADOS_PKG.MarcarStatusPens"


        ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam)


    End Sub

    Public Sub GenerarArchivoError(texto As String, mensaje As String, archivo_name As String, fecha As String)
        Dim fs As FileStream = Nothing
        Dim strPath As String = System.IO.Path.GetDirectoryName( _
         System.Reflection.Assembly.GetExecutingAssembly().CodeBase)
        Dim localpath = New Uri(strPath).LocalPath
        Dim fileLoc As String = localpath & "\LogfileError.txt"
        'Dim fileLoc As String = IO.Directory.GetParent(Application.ExecutablePath).FullName()
        Try
            If (Not File.Exists(fileLoc)) Then
                fs = File.Create(fileLoc)
                fs.Close()
            End If
            Using sw As StreamWriter = New StreamWriter(fileLoc)
                sw.WriteLine(texto)
                sw.WriteLine(mensaje)
                sw.WriteLine(archivo_name)
                sw.WriteLine(fecha)
                sw.Close()
            End Using
        Catch ex As Exception
            '  Enviar_Correo("Hubo un error en la creacion del archivo de error", "Descripcion: " & ex.ToString())
        End Try

    End Sub

    Public Function Enviar_Correo(ByVal Subject As String, ByVal Cuerpo As String) As Boolean


        Dim smtp As String = System.Configuration.ConfigurationManager.AppSettings("SMTP")
        Dim from As String = System.Configuration.ConfigurationManager.AppSettings("FROM")

        Dim Mensaje As New System.Net.Mail.MailMessage
        Mensaje.From = New System.Net.Mail.MailAddress(from)

        Mensaje.To.Add(correoTO)
        Mensaje.CC.Add(correoCC)

        Mensaje.Subject = Subject
        Mensaje.Body = Cuerpo
        Mensaje.IsBodyHtml = True
        Mensaje.Priority = System.Net.Mail.MailPriority.Normal


        Dim osmtp As New System.Net.Mail.SmtpClient
        osmtp.Host = smtp

        Try
            osmtp.Send(Mensaje)
            Mensaje.Dispose()
        Catch ex As Exception
            'Enviamos mensaje de error
            GenerarArchivoError("Mensaje de error en la carga de imagen de Afiliacion", "  Descripcion: " & ex.ToString(), "", " " & "Fecha: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))
            '  Enviar_Correo("Mensaje de error en la carga de imagen de Afiliacion", "Descripcion: " & ex.ToString())
            Return False
        End Try
    End Function

    Private Function getConnString() As String
        Dim connectionString As String = System.Configuration.ConfigurationManager.AppSettings("oConnSuirPlus")

        Dim data As Byte() = Convert.FromBase64String(connectionString)

        Return System.Text.ASCIIEncoding.ASCII.GetString(data)

    End Function

    Private Sub TimeEjecuta_Elapsed(ByVal sender As System.Object, ByVal e As System.Timers.ElapsedEventArgs) Handles TimeEjecuta.Elapsed
        ProcesarArchivos()
    End Sub

    Public Function ExecuteNonQuery(ByVal commandType As CommandType, ByVal commandText As String, ByVal ParamArray commandParameters As OracleParameter()) As Integer

        Using oConn As New Oracle.DataAccess.Client.OracleConnection(getConnString())
            Using oCommand As New Oracle.DataAccess.Client.OracleCommand()
                oConn.Open()
                oCommand.Connection = oConn
                oCommand.CommandType = commandType
                oCommand.CommandText = commandText
                oCommand.Parameters.AddRange(commandParameters)

                Dim Resultado As Integer = oCommand.ExecuteNonQuery()

                oCommand.Connection.Close()

                Return Resultado
            End Using

        End Using
    End Function
End Class
