Imports CLBCRDFILE
Imports System.IO
Imports System.Security
Imports System.Security.Cryptography
Imports System.Text
Imports Microsoft.VisualBasic.FileIO
Imports ICSharpCode.SharpZipLib.Zip
Imports System.IO.Compression
Module Module1
    Sub Main()
        Dim m As New BLArchivoXML()
        'm.ProcesarArchivos()

        m.EnviarCorreo()

    End Sub
    Sub DecryptFile(ByVal FileIn As String, ByVal Fileout As String, ByVal fileKey As String)
        Try
            '' The encrypted file
            Dim fsFileIn As FileStream = File.OpenRead(FileIn)

            '' The decrypted file
            Dim fsFileOu As FileStream = File.Create(Fileout)

            ''The key
            Dim fsfileKey As FileStream = File.OpenRead(fileKey)

            Dim cryptAlgorithm As New TripleDESCryptoServiceProvider
            Dim brfile As New BinaryReader(fsfileKey)

            cryptAlgorithm.Key = brfile.ReadBytes(24)
            cryptAlgorithm.IV = brfile.ReadBytes(8)
            cryptAlgorithm.Mode = CipherMode.ECB
            cryptAlgorithm.Padding = PaddingMode.PKCS7

            Dim csEncrypt As New CryptoStream(fsFileIn, cryptAlgorithm.CreateDecryptor(), CryptoStreamMode.Read)

            Dim srCleanStream As New StreamReader(csEncrypt)

            Dim swCleanStream As New StreamWriter(fsFileOu)

            swCleanStream.Write(srCleanStream.ReadToEnd())

            swCleanStream.Close()

            fsFileOu.Close()

            srCleanStream.Close()

        Catch cx As CryptographicException
            Throw cx
        Catch uaex As UnauthorizedAccessException
            Throw uaex
        End Try
    End Sub

    Sub EncryptTextToFile(ByVal Data As String, ByVal FileName As String, ByVal Key() As Byte, ByVal IV() As Byte)
        Try
            ' Create or open the specified file.
            Dim fStream As FileStream = File.Open(FileName, FileMode.OpenOrCreate)



            ' Create a CryptoStream using the FileStream 
            ' and the passed key and initialization vector (IV).
            Dim cStream As New CryptoStream(fStream, _
                                            New TripleDESCryptoServiceProvider().CreateEncryptor(Key, IV), _
                                            CryptoStreamMode.Write)

            ' Create a StreamWriter using the CryptoStream.
            Dim sWriter As New StreamWriter(cStream)

            ' Write the data to the stream 
            ' to encrypt it.
            sWriter.WriteLine(Data)

            ' Close the streams and
            ' close the file.
            sWriter.Close()
            cStream.Close()
            fStream.Close()
        Catch e As CryptographicException
            Console.WriteLine("A Cryptographic error occurred: {0}", e.Message)
        Catch e As UnauthorizedAccessException
            Console.WriteLine("A file error occurred: {0}", e.Message)
        End Try
    End Sub
    Sub DecryptFile(ByVal FileIn As String, ByVal Fileout As String, ByVal key() As Byte, ByVal IV() As Byte)
        Try
            '' The encrypted file
            Dim fsFileIn As FileStream = File.OpenRead(FileIn)

            '' The decrypted file
            Dim fsFileOu As FileStream = File.Create(Fileout)

            Dim cryptAlgorithm As New TripleDESCryptoServiceProvider


            cryptAlgorithm.Key = key
            cryptAlgorithm.IV = IV


            Dim csEncrypt As New CryptoStream(fsFileIn, cryptAlgorithm.CreateDecryptor(), CryptoStreamMode.Read)

            Dim srCleanStream As New StreamReader(csEncrypt)

            Dim swCleanStream As New StreamWriter(fsFileOu)

            swCleanStream.Write(srCleanStream.ReadToEnd())

            swCleanStream.Close()

            fsFileOu.Close()

            srCleanStream.Close()

        Catch cx As CryptographicException
            Throw cx
        Catch uaex As UnauthorizedAccessException
            Throw uaex
        End Try
    End Sub
    Sub ReadFiles()
        Dim ruta As String = "C:\ConFiles\RENC043403062009074078_TSS.txt"
        Using Reader As New TextFieldParser(ruta)
            Reader.TextFieldType = FieldType.FixedWidth
            Reader.SetFieldWidths(1, 2, 2, 3, 2, 4, 6)
            Dim Currentrow As String()
            While Not Reader.EndOfData
                Try
                    Currentrow = Reader.ReadFields
                    For Each currentfile As String In Currentrow
                        Console.WriteLine(currentfile)
                    Next

                Catch ex As MalformedLineException
                    Console.WriteLine(ex)
                    Console.ReadLine()
                End Try
            End While
            Console.ReadLine()
        End Using

        Dim readText() As String = File.ReadAllLines(ruta)
    End Sub
    Sub ReadFilesde()

        Dim EnumFiles As IEnumerable(Of String) = Directory.GetFiles("C:\ConFiles").Where(Function(p As String) _
                                                                                        p.EndsWith(".TXT"))


        For Each _file As String In EnumFiles

            Dim fileinfo As FileInfo = New FileInfo(_file)

            Dim EnumEnc As IEnumerable(Of String) = File.ReadAllLines(fileinfo.FullName).Where(Function(p As String) _
                                                                                        p.StartsWith("D"))

            For Each det As String In EnumEnc
                LeerLinea(det)
            Next



        Next
        'Dim ruta As String = "C:\ConFiles\RENC043603062009074079_TSS.txt"
        'Dim s() As String = File.ReadAllLines(ruta)
        'For i As Int32 = 0 To s.Length - 1
        '    Dim e As String = s(i)
        '    LeerLinea(e)
        'Next
    End Sub
    Sub LeerLinea(ByVal linea As String)

        Dim DetalleCon As Detalle = New Detalle
        Dim resultado As String = String.Empty

        '' Llamar metodo para agregar el Detalle
        getDetalleValues(linea, DetalleCon.FechaSolicutud, DetalleCon.Tipo_Instruccion, DetalleCon.Importe_Instruccion, DetalleCon.Cuenta_Origen, _
                         DetalleCon.Cuenta_Destino, DetalleCon.Tipo_Entidad_Destino, DetalleCon.Entidad_Destino, _
                         DetalleCon.Tipo_Entidad_Origen, DetalleCon.Entidad_Origen, resultado)


    End Sub
    Sub getDetalleValues(ByVal det As String, ByRef fechasolicitud As String, ByRef tipo_instruccion As String, ByRef importe_instruccion As Decimal, _
                               ByRef cuenta_origen As String, ByRef cuenta_destino As String, ByRef tipo_entidad_depositen_fondo As Int32, _
                               ByRef entidad_depositen_fondo As Int32, ByRef tipo_entidad_depositar_fondo As Int32, ByRef entidad_depositar_fondo As Int32)


        fechasolicitud = det.Substring(2, 8)



    End Sub

    Public Sub getDetalleValues(ByVal det As String, ByRef fechasolicitud As String, ByRef tipo_instruccion As String, ByRef importe_instruccion As Decimal, _
                                   ByRef cuenta_origen As String, ByRef cuenta_destino As String, ByRef tipo_entidad_destino As Int32, _
                                   ByRef entidad_destino As Int32, ByRef tipo_entidad_origen As Int32, ByRef entidad_origen As Int32, ByRef result As String)

        Dim fecha As String = String.Empty
        Dim dec As String = String.Empty

        Try

            fecha = det.Substring(1, 8)
            fechasolicitud = fecha.Substring(0, 2) + "/" + fecha.Substring(2, 2) + "/" + fecha.Substring(4, 4)
            tipo_instruccion = det.Substring(9, 2)
            importe_instruccion = Convert.ToDecimal(det.Substring(13, 24))
            cuenta_origen = Trim(det.Substring(37, 25))
            cuenta_destino = Trim(det.Substring(62, 25))
            tipo_entidad_destino = Convert.ToInt32(det.Substring(87, 2))
            entidad_destino = Convert.ToInt32(det.Substring(89, 2))
            tipo_entidad_origen = Convert.ToInt32(det.Substring(91, 2))
            entidad_origen = Convert.ToInt32(det.Substring(93, 2))
            result = "0"
        Catch ex As Exception
            ' MoverArchivoError("Ha ocurrido el siguiente error Obteniendo los Valores del detalle del archvio" + " " + ex.Message, fileinfo.FullName, "Archivo Concentracion")
            result = ex.Message
        End Try

    End Sub
    Friend Structure Detalle
        Public FechaSolicutud As String
        Public Tipo_Instruccion As String
        Public Importe_Instruccion As Decimal
        Public Cuenta_Origen As String
        Public Cuenta_Destino As String
        Public Tipo_Entidad_Destino As Int32
        Public Entidad_Destino As Int32
        Public Tipo_Entidad_Origen As Int32
        Public Entidad_Origen As Int32
    End Structure
    Private Sub ComprimirArchivo(ByVal FileIn As String, ByVal fileou As String)

        Dim sourcefile As FileStream = File.OpenRead(FileIn)
        Dim desfile As FileStream = File.Create(fileou)

        Dim mycompress As DeflateStream = New DeflateStream(desfile, CompressionMode.Compress, True)
        Dim buffer(sourcefile.Length) As Byte
        sourcefile.Read(buffer, 0, buffer.Length)
        mycompress.Write(buffer, 0, buffer.Length)

        mycompress.Close()

        Console.WriteLine("Original size: {0}, Compressed size: {1}", buffer.Length, desfile.Length)

        Console.ReadLine()

    End Sub

    Private Sub ComprimirArchivo(ByVal FileIn As String)

        ''Dim sourcefile As New FileStream(FileIn, FileMode.Open, FileAccess.Read, FileShare.Read)
        ''Dim m As New SuirPlus.Empresas.Archivo
        ''Dim des As FileStream = m.getArchivoSinComprimir(sourcefile)
        'getArchivoSinComprimir(sourcefile)
        'Dim buffer(sourcefile.Length) As Byte

        'Dim count As Integer
        'count = sourcefile.Read(buffer, 0, buffer.Length)
        'sourcefile.Close()

        'Dim ms As MemoryStream = New MemoryStream()

        'Dim mycompress As DeflateStream = New DeflateStream(ms, CompressionMode.Compress, True)

        'mycompress.Write(buffer, 0, buffer.Length)

        'mycompress.Close()

        'Console.WriteLine("Original size: {0}, Compressed size: {1}", buffer.Length, ms.Length)

    End Sub
    Private Sub ComprimirArchivoGZip(ByVal FileIn As String, ByVal Fileout As String)
        Try
            Using sourcefile As FileStream = File.OpenRead(FileIn)
                Using desfile As FileStream = File.Create(Fileout)
                    Using compSteam As GZipStream = New GZipStream(desfile, CompressionMode.Compress)
                        Dim data(sourcefile.Length) As Byte
                        sourcefile.Read(data, 0, data.Length)
                        compSteam.Write(data, 0, data.Length)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Public Sub GZipCompressDecompress(ByVal filename As String, ByVal fileout As String)


        Dim infile As FileStream
        Try
            ' Open the file as a FileStream object.
            infile = New FileStream(filename, FileMode.Open, FileAccess.Read, FileShare.Read)
            Dim f As FileStream = File.Create(fileout)
            Dim buffer(infile.Length - 1) As Byte
            ' Read the file to ensure it is readable.
            Dim count As Integer = infile.Read(buffer, 0, buffer.Length)
            If count <> buffer.Length Then
                infile.Close()

                Return
            End If
            infile.Close()
            Dim ms As New MemoryStream()
            ' Use the newly created memory stream for the compressed data.
            Dim compressedzipStream As New GZipStream(f, CompressionMode.Compress, True)
            compressedzipStream.Write(buffer, 0, buffer.Length)
            ' Close the stream.
            compressedzipStream.Close()

            Console.WriteLine("Original size: " & buffer.Length & ", Compressed size: " & f.Length)


        Catch e As Exception
            Throw e
        End Try

    End Sub 'GZipCompressDecompress

    Private Sub CompressFile(ByVal path As String)
        Dim sourceFile As FileStream = File.OpenRead(path)
        Dim destinationFile As FileStream = File.Create(path + ".Zip")

        Dim buffer(sourceFile.Length) As Byte
        sourceFile.Read(buffer, 0, buffer.Length)

        Using output As New GZipStream(destinationFile, _
            CompressionMode.Compress)

            Console.WriteLine("Compressing {0} to {1}.", sourceFile.Name, _
                destinationFile.Name, False)

            output.Write(buffer, 0, buffer.Length)
        End Using

        ' Close the files.
        sourceFile.Close()
        destinationFile.Close()
    End Sub

    Private Sub DeflateCompressDecompress(ByVal filename As String)

        Dim infile As FileStream
        Try
            infile = New FileStream(filename, FileMode.Open, FileAccess.Read, FileShare.Read)
            Dim buffer(infile.Length - 1) As Byte
            Dim count As Integer = infile.Read(buffer, 0, buffer.Length)
            If count <> buffer.Length Then
                infile.Close()
                Console.WriteLine("Test Failed: Unable to read data from file")
                Return
            End If
            infile.Close()

            Dim destinationFile As FileStream = File.Create(filename + ".Zip")
            Dim compressedzipStream As New DeflateStream(destinationFile, CompressionMode.Compress, True)
            compressedzipStream.Write(buffer, 0, buffer.Length)
            compressedzipStream.Close()


            Console.WriteLine("Compressing {0} to {1}.", infile.Name, _
              destinationFile.Name, False)

        Catch e As Exception
            Console.WriteLine("Error: The file being read contains invalid data.")
        End Try
    End Sub 'DeflateCompress
    Private Function CompareData(ByVal buf1() As Byte, ByVal len1 As Integer, ByVal buf2() As Byte, ByVal len2 As Integer) As Boolean
        ' Use this method to compare data from two different buffers.
        Dim msg = String.Empty
        If len1 <> len2 Then
            msg = "Number of bytes in two buffer are different" & len1 & ":" & len2
            MsgBox(msg)
            Return False
        End If

        Dim i As Integer
        For i = 0 To len1 - 1
            If buf1(i) <> buf2(i) Then
                msg = "byte " & i & " is different " & buf1(i) & "|" & buf2(i)
                MsgBox(msg)
                Return False
            End If
        Next i
        msg = "All bytes compare."
        MsgBox(msg)
        Return True
    End Function 'CompareData
    Private Function ReadAllBytesFromStream(ByVal stream As Stream, ByVal buffer() As Byte) As Integer
        ' Use this method is used to read all bytes from a stream.
        Dim offset As Integer = 0
        Dim totalCount As Integer = 0
        While True
            Dim bytesRead As Integer = stream.Read(buffer, offset, 100)
            If bytesRead = 0 Then
                Exit While
            End If
            offset += bytesRead
            totalCount += bytesRead
        End While
        Return totalCount
    End Function 'ReadAllBytesFromStream
    
    Private Function getArchivoSinComprimir(ByVal zipFile As Stream) As Stream
        Dim entry As ZipEntry
        Dim zip As New ZipInputStream(zipFile)
        Dim fileName As String = String.Empty
        Dim stream2 As New MemoryStream
        Dim num As Integer = 0
        Dim myNombreAchivo As String

        entry = zip.GetNextEntry
        fileName = Path.GetFileName(entry.Name)

        If (fileName <> String.Empty) Then

            myNombreAchivo = fileName

            Dim count As Integer = 0
            Dim buffer As Byte() = New Byte(256) {}
            Do While True
                count = zip.Read(buffer, 0, buffer.Length)
                If (count <= 0) Then
                    Exit Do
                End If
                stream2.Write(buffer, 0, count)
            Loop
            num += 1
        End If

        zip.Close()
        Return stream2
    End Function



End Module
