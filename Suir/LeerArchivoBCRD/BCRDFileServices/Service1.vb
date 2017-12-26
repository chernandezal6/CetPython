Imports CLBCRDFILE
Imports System.Configuration

Imports System.Net.Mail
Public Class WSBCRD

    Dim TimerWS As New System.Timers.Timer
    Dim GenerarArchivo As New BLArchivoXML
    Private nombrearchivo As String = String.Empty
    Private logdir As String = ConfigurationManager.AppSettings("LogDir")
    Private sec As Int32 = 0
    Private _dir As String

    Protected Overrides Sub OnStart(ByVal args() As String)
        ' Add code here to start your service. This method should set things
        ' in motion so your service can do its work.

        Dim _error As String = "Error.txt"

        _dir = Me.logdir & "\" & _error

        Try

            Me.TimerWS.Enabled = True
            Me.TimerWS.Start()
            Me.TimerWS.Interval = 600000


            AddHandler TimerWS.Elapsed, AddressOf TimerWS_Tick

        Catch ex As Exception

            EnviarConfirmacion("Error en el proceso de WSBCRD", ex.ToString())

        End Try
    End Sub
    Protected Overrides Sub OnStop()
        ' Add code here to perform any tear-down necessary to stop your service.
        TimerWS.Stop()
    End Sub
    Private Sub TimerWS_Tick(ByVal sender As Object, ByVal e As System.Timers.ElapsedEventArgs)

        Try
            GenerarArchivo.ProcesarArchivos()
            EnviarConfirmacion("Proceso Terminado", "El Proceso de recepcion de archivos del BCRD")

        Catch ex As Exception

            'EnviarConfirmacion("Error en el proceso de WSBCRD", ex.ToString())

        End Try

    End Sub

    Private Sub EnviarConfirmacion(ByVal Asunto As String, ByVal body As String)

        Try

            Dim dfrom As New MailAddress("info@mail.tss2.gov.do")
            Dim message As New MailMessage
            Dim smtp As New SmtpClient
            Dim oks As String = String.Empty
            Dim errores As String = String.Empty
            Dim direcciones As String = String.Empty


            GenerarArchivo.getMailAddress(oks, errores)
            direcciones = oks & "," & errores
            message.From = dfrom
            message.To.Add(oks)
            message.Subject = Asunto
            message.IsBodyHtml = True
            message.Body = body
            message.Priority = MailPriority.Normal
            message.BodyEncoding = System.Text.Encoding.Default
            smtp.Host = "172.16.5.8"
            smtp.Send(message)

        Catch ex As SmtpException

            Try
                Dim TextFile As New System.IO.StreamWriter(_dir)
                TextFile.WriteLine(ex.ToString())
                TextFile.Close()

            Catch ex2 As Exception
                ' Dejalo vacio.
            End Try

        End Try

    End Sub
End Class
