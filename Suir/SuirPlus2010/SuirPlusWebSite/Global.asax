<%@ Application Language="VB" %>

<script runat="server">

    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs on application startup
        Application("ActiveUsers") = 0
    End Sub

    Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs on application shutdown
    End Sub

    Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs when an unhandled error occurs

        Try
            SuirPlus.Exepciones.Log.LogToDB(Server.GetLastError.ToString())
        Catch ex As Exception

        End Try

    End Sub

    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)

        Application.Lock()
        Application("ActiveUsers") = CInt(Application("ActiveUsers")) + 1
        Application.UnLock()

        '===========================================
        ' Configuracion de las Rutas
        '===========================================
        Dim servidor As String = "http://" & Request.ServerVariables("HTTP_HOST") & "/"

        ''se define la ruta alctual como "NOPRODUCCION" en el webconfig para determinar que ruta debe tomar en determinado servidor.
        Dim ruta = System.Configuration.ConfigurationManager.AppSettings("rutaActual")
        If ruta = "NOPRODUCCION" Then
            Application("servidor") = servidor
        Else
            Application("servidor") = "http://www.tss2.gov.do/"
        End If

        Application("Main_Menu") = servidor & "tss_menu.js"

        ' Cargar las Imagenes
        Application("urlLogoSuirPlus") = servidor & System.Configuration.ConfigurationManager.AppSettings("LOGO_SUIR_PLUS")
        Application("urlLogoTSS") = servidor & System.Configuration.ConfigurationManager.AppSettings("LOGO_TSS")
        Application("urlLogoTSSDocumento") = servidor & System.Configuration.ConfigurationManager.AppSettings("LOGO_TSS_DOC")
        Application("urlLogoDGII") = servidor & System.Configuration.ConfigurationManager.AppSettings("LOGO_DGII")
        Application("urlLogoINF") = servidor & System.Configuration.ConfigurationManager.AppSettings("LOGO_INFOTEP")
        Application("urlLogoINFDocumento") = servidor & System.Configuration.ConfigurationManager.AppSettings("LOGO_INF_DOC")

        Application("urlLogoMDT") = servidor & System.Configuration.ConfigurationManager.AppSettings("LOGO_MDT")
        Application("urlLogoMDTDocumento") = servidor & System.Configuration.ConfigurationManager.AppSettings("LOGO_MDT_DOC")

        Application("urlLogoDGIIDocumento") = servidor & System.Configuration.ConfigurationManager.AppSettings("LOGO_DGII_DOC")
        Application("urlGradienteHeader") = servidor & System.Configuration.ConfigurationManager.AppSettings("GRADIENTE_HEADER")
        Application("urlBarraMenuHeader") = servidor & System.Configuration.ConfigurationManager.AppSettings("BARRA_MENU_HEADER")
        Application("urlLogOff") = servidor & System.Configuration.ConfigurationManager.AppSettings("LOG_OFF")
        Application("urlBarraFooter") = servidor & System.Configuration.ConfigurationManager.AppSettings("BARRA_FOOTER")
        Application("urlImgOK") = servidor & System.Configuration.ConfigurationManager.AppSettings("IMG_OK")
        Application("urlImgCancelar") = servidor & System.Configuration.ConfigurationManager.AppSettings("IMG_CANCELAR")
        Application("urlImgBusqueda") = servidor & System.Configuration.ConfigurationManager.AppSettings("IMG_BUSQUEDA")
        Application("urlIconoRep") = servidor & System.Configuration.ConfigurationManager.AppSettings("ICONO_REPRESENTANTE")
        Application("urlIconoUsr") = servidor & System.Configuration.ConfigurationManager.AppSettings("ICONO_USUARIO")
        Application("urlComprobacionRep") = servidor & System.Configuration.ConfigurationManager.AppSettings("COMPROBACION_REP")
        Application("urlLogin") = servidor & System.Configuration.ConfigurationManager.AppSettings("Login")
        Application("urlImprimir") = servidor & System.Configuration.ConfigurationManager.AppSettings("Imprimir")
        Application("CambioClassUsuario") = servidor & System.Configuration.ConfigurationManager.AppSettings("CambioClassUsuario")
        Application("CambioClassRepresentante") = servidor & System.Configuration.ConfigurationManager.AppSettings("CambioClassRepresentante")
        Application("LoginImp") = servidor & System.Configuration.ConfigurationManager.AppSettings("LoginImp")


    End Sub

    Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs when a session ends. 
        ' Note: The Session_End event is raised only when the sessionstate mode
        ' is set to InProc in the Web.config file. If session mode is set to StateServer 
        ' or SQLServer, the event is not raised.

        Application.Lock()
        Application("ActiveUsers") = CInt(Application("ActiveUsers")) - 1
        Application.UnLock()

    End Sub

</script>