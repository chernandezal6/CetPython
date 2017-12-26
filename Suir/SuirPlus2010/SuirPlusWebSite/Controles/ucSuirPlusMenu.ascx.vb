Imports SuirPlus
Imports System.Data
Partial Class Controles_ucSuirPlusMenu
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ' If Not Page.IsPostBack Then
        Me.LimpiarMenu()
        Me.GenerarMenu()
        'End If

    End Sub

    Public Sub LimpiarMenu()
        Me.menuSP.Items.Clear()
    End Sub


    Public Sub GenerarMenu()

        Dim srv As String = Application("servidor")

        'Agrega el Login
        Dim tnL As New MenuItem("Login")

        Dim tncL As New MenuItem("Login Usuario", "1", "", srv & "Login.aspx", "")
        tnL.ChildItems.Add(tncL)

        tncL = New MenuItem("Login Representante", "1", "", srv & "Login.aspx?log=r", "")
        tnL.ChildItems.Add(tncL)

        tncL = New MenuItem("LogOut", "1", "", srv & "LogOut.aspx", "")
        tnL.ChildItems.Add(tncL)

        Me.menuSP.Items.Add(tnL)

        If HttpContext.Current.Session("UsrUserName") <> "" Then

            Dim ds As System.Data.DataSet = SuirPlus.Seguridad.Autorizacion.getMenuItems(HttpContext.Current.Session("UsrUserName"))
            Dim foundRows() As Data.DataRow

            Dim agregar As Boolean = True
            Dim arch As New SuirPlus.Config.Configuracion(Config.ModuloEnum.BancosRecaudadores)
            Dim ArrDGII() As String
            ArrDGII = arch.FTPDir.Split("|")
            Array.Sort(ArrDGII)

            Dim ArrTSS() As String
            ArrTSS = arch.ArchivesDir.Split("|")
            Array.Sort(ArrTSS)

            Dim ArrINF() As String
            ArrINF = arch.Archives_OK_DIR.Split("|")
            Array.Sort(ArrINF)

            'Agregar las secciones
            For Each dtrow As Data.DataRow In ds.Tables(0).Rows

                Dim bPage As New BasePage

                ' Seccion de Bancos de la DGII
                If dtrow.Item("ID").ToString() = "27" Then
                    If (Array.BinarySearch(ArrDGII, bPage.UsrIDEntidadRecaudadora) < 0) Then agregar = False
                End If

                ' Seccion de Bancos de la TSS
                If dtrow.Item("ID").ToString() = "26" Then
                    If (Array.BinarySearch(ArrTSS, bPage.UsrIDEntidadRecaudadora) < 0) Then agregar = False
                End If

                ' Seccion de Bancos de INF
                If dtrow.Item("ID").ToString() = "60" Then
                    If (Array.BinarySearch(ArrINF, bPage.UsrIDEntidadRecaudadora) < 0) Then agregar = False
                End If

                Dim tn As New MenuItem(dtrow.Item("SECCION").ToString())
                tn.ToolTip = dtrow.Item("SECCION").ToString()

                'Agregar las opciones
                foundRows = ds.Tables(1).Select("IDSECCION = '" & dtrow.Item("ID").ToString() & "'")

                For Each dtRows As Data.DataRow In foundRows

                    Dim Url As String = srv & Replace(dtRows.Item("url").ToString(), "../../../../", "")

                    Dim tnc As New MenuItem(dtRows.Item("PERMISO").ToString(), "1", "", Url, "")
                    tn.ChildItems.Add(tnc)

                Next

                If foundRows.Count = 0 Then
                    agregar = False
                End If

                If agregar = True Then
                        Me.menuSP.Items.Add(tn)
                    Else
                        agregar = True
                End If

            Next

        End If

    End Sub

End Class
