Partial Class Solicitudes_Info
    Inherits BasePage
    Public qsID As String

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents pnlMsn1 As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlMsn2 As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlMsn3 As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlMsn4 As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlMsn5 As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlMsn6 As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlMsn7 As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlMsn8 As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlMsn9 As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlMsn10 As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlMsn11 As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlMsn12 As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlMsn13 As System.Web.UI.WebControls.Panel
    'Protected WithEvents btnAceptar1 As System.Web.UI.WebControls.Button
    'Protected WithEvents btnAceptar2 As System.Web.UI.WebControls.Button
    'Protected WithEvents btnAceptar3 As System.Web.UI.WebControls.Button
    'Protected WithEvents btnAceptar4 As System.Web.UI.WebControls.Button
    'Protected WithEvents btnAceptar5 As System.Web.UI.WebControls.Button
    'Protected WithEvents btnAceptar6 As System.Web.UI.WebControls.Button
    'Protected WithEvents btnAceptar7 As System.Web.UI.WebControls.Button
    'Protected WithEvents btnAceptar8 As System.Web.UI.WebControls.Button
    'Protected WithEvents btnAceptar9 As System.Web.UI.WebControls.Button
    'Protected WithEvents btnAceptar10 As System.Web.UI.WebControls.Button
    'Protected WithEvents btnAceptar11 As System.Web.UI.WebControls.Button
    'Protected WithEvents btnAceptar12 As System.Web.UI.WebControls.Button
    'Protected WithEvents btnAceptar13 As System.Web.UI.WebControls.Button

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        If Not Request.QueryString("Id") = String.Empty Then

            Try
                qsID = Request.QueryString("Id")

                If qsID = 1 Then
                    Me.pnlMsn1.Visible = True
                ElseIf qsID = 2 Then
                    Me.pnlMsn2.Visible = True
                ElseIf qsID = 3 Then
                    Me.pnlMsn3.Visible = True
                ElseIf qsID = 4 Then
                    Me.pnlMsn4.Visible = True
                ElseIf qsID = 5 Then
                    Me.pnlMsn5.Visible = True
                ElseIf qsID = 6 Then
                    Me.pnlMsn6.Visible = True
                ElseIf qsID = 7 Then
                    Me.pnlMsn7.Visible = True
                ElseIf qsID = 8 Then
                    Me.pnlMsn8.Visible = True
                ElseIf qsID = 9 Then
                    Me.pnlMsn9.Visible = True
                ElseIf qsID = 10 Then
                    Me.pnlMsn10.Visible = True
                ElseIf qsID = 11 Then
                    Me.pnlMsn11.Visible = True
                ElseIf qsID = 12 Then
                    Me.pnlMsn12.Visible = True
                ElseIf qsID = 13 Then
                    Response.Redirect("PreguntasFrecuentes.aspx")
                ElseIf qsID = 14 Then
                    Response.Redirect("GlosarioTerminos.aspx")
                ElseIf qsID = 15 Then
                    Response.Redirect("Directorio.aspx")
                ElseIf qsID = 16 Then
                    Response.Redirect("OficinasTSS.aspx")
                ElseIf qsID = 17 Then
                    Response.Redirect("ConsultaByRNC.aspx")
                ElseIf qsID = 18 Then
                    Response.Redirect("ConsultaSolicitud.aspx")
                ElseIf qsID = 19 Then
                    Response.Redirect("../Solicitudes/ConsultaARS.aspx")
                ElseIf qsID = 20 Then
                    Response.Redirect("../sys/ConsultaAfiliacion.aspx")
                ElseIf qsID = 21 Then
                    Response.Redirect("../Solicitudes/ConsultaAFP.aspx")
                End If




            Catch ex As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                Response.Write(ex.ToString())
                'Response.Redirect("SolicitudIntro.aspx")

            End Try

        End If
    End Sub

    Private Sub btnAceptar1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar1.Click
        Response.Redirect("Solicitudes.aspx?Id=" & qsID)
    End Sub

    Private Sub btnAceptar2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar2.Click
        Response.Redirect("Solicitudes.aspx?Id=" & qsID)
    End Sub

    Private Sub btnAceptar3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar3.Click
        Response.Redirect("Solicitudes.aspx?Id=" & qsID)
    End Sub

    Private Sub btnAceptar4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar4.Click
        Response.Redirect("Solicitudes.aspx?Id=" & qsID)
    End Sub

    Private Sub btnAceptar5_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar5.Click
        Response.Redirect("Solicitudes.aspx?Id=" & qsID)
    End Sub

    Private Sub btnAceptar6_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar6.Click
        Response.Redirect("Solicitudes.aspx?Id=" & qsID)
    End Sub


    Private Sub btnAceptar7_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar7.Click
        Response.Redirect("Solicitudes.aspx?Id=" & qsID)
    End Sub

    Private Sub btnAceptar8_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar8.Click
        Response.Redirect("Solicitudes.aspx?Id=" & qsID)
    End Sub

    Private Sub btnAceptar9_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar9.Click
        Response.Redirect("Solicitudes.aspx?Id=" & qsID)
    End Sub

    Private Sub btnAceptar10_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar10.Click
        Response.Redirect("Solicitudes.aspx?Id=" & qsID)
    End Sub

    Private Sub btnAceptar11_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar11.Click
        Response.Redirect("Solicitudes.aspx?Id=" & qsID)
    End Sub

    Private Sub btnAceptar12_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar12.Click
        Response.Redirect("Solicitudes.aspx?Id=" & qsID)
    End Sub

    Private Sub btnAceptar13_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar13.Click
        Response.Redirect("Solicitudes.aspx?Id=" & qsID)
    End Sub
End Class
