Imports System.Net
Imports System.Net.Mail
Imports System.Net.Mime

Public Class EnvioEmail

    Public Shared Sub EnviarEmail(ByVal tipo As TipoArchivo, ByVal Asunto As String, ByVal Cuerpo As String, ByRef Resultado As Boolean, ByRef MensajeError As String, ByRef NombreArchivoError As String, Optional ByVal Attachment As String = Nothing)

        'archivo procesado correctamente
        Resultado = False

        Dim dfrom As New MailAddress(Cons.MailFrom)
        Dim message As New MailMessage
        Dim smtp As New SmtpClient
        Dim oks As String = String.Empty
        Dim errores As String = String.Empty
        Dim direcciones As String = String.Empty

        Try

            BLArchivoXML.getMailAddress(oks, errores)
            direcciones = oks & "," & errores
            message.From = dfrom
            message.To.Add(oks)

            message.Subject = Asunto
            message.IsBodyHtml = True
            message.Body = Cuerpo
            message.Priority = MailPriority.Normal
            message.BodyEncoding = System.Text.Encoding.Default

            If Attachment.Length > 0 Then
                message.Attachments.Add(New Attachment(Attachment))
            End If

            smtp.Host = Cons.SMTPhost

            Console.WriteLine("")
            Console.WriteLine("Enviando Reporte....")
            smtp.Send(message)

            If message.Attachments.Count > 0 Then
                Console.WriteLine("Reporte enviado: " & message.Attachments.Item(0).Name)
            Else
                Console.WriteLine("Reporte enviado sin attach... ")
            End If


            Resultado = True

        Catch ex As Exception

            Resultado = False
            MensajeError = ex.Message
            Dim NombreAr As String = ""


            If message.Attachments.Count > 0 Then

                NombreArchivoError = message.Attachments.Item(0).Name
                NombreAr = message.Attachments.Item(0).Name.Replace(".TXT", ".html")

            End If


            Console.WriteLine("Error enviando por email el archivo: " & NombreAr)
            Console.WriteLine(ex.ToString())
            Console.WriteLine("Se procedio a generar el archivo en el FileSystem")


            If message.Attachments.Count > 0 Then
                Try
                    System.IO.File.WriteAllText(NombreAr, Cuerpo)
                Catch ex2 As Exception
                    Console.WriteLine("")
                    Console.WriteLine("Error grabando el reporte en el FileSystem: ")
                    Console.WriteLine(ex2.ToString())
                End Try
            End If

        End Try

    End Sub

End Class
