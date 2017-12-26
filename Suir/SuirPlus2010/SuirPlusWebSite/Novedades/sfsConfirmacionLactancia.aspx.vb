Imports System.Data
Imports System.Collections.Generic
Imports SuirPlus.FrameWork
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.SubsidiosSFS
Imports SuirPlus.Empresas.SubsidiosSFS.Maternidad
Imports System.Linq
Partial Class Novedades_sfsConfirmacionLactancia
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            'llenar controles con variables de sesion
            Try
                Dim dtLactantes As New DataTable
                If Not Session("dtLactantes") Is Nothing And Not (String.IsNullOrEmpty(Request.QueryString("NSS"))) Then

                    dtLactantes = CType(Session("dtLactantes"), DataTable)
                    gvLactantes.DataSource = dtLactantes
                    gvLactantes.DataBind()

                    lblCantidadLactantes.Text = Request.QueryString("Cantidad").ToString()
                    lblFechaNacimiento.Text = Request.QueryString("FechaNacimientoLactante").ToString()

                    ucInfoEmpleado1.NombreEmpleado = Request.QueryString("NombreEmpleado").ToString()
                    ucInfoEmpleado1.NSS = Request.QueryString("NSS").ToString()
                    ucInfoEmpleado1.Cedula = Request.QueryString("Cedula").ToString().Replace("-", "")
                    ucInfoEmpleado1.Sexo = Request.QueryString("Sexo").ToString()
                    ucInfoEmpleado1.FechaNacimiento = Request.QueryString("FechaNacimiento").ToString()
                    ucInfoEmpleado1.SexoEmpleado = "Empleada"
                End If
            Catch ex As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If
    End Sub
    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRegistrar.Click
        lblMsg.Text = String.Empty
        Dim resultado As String = String.Empty
        Dim nss As Nullable(Of Integer)

        Try

            If gvLactantes.Rows.Count > 0 Then

                Dim solicitud As String = String.Empty
                For Each row As GridViewRow In gvLactantes.Rows
                    If row.Cells(0).Text.Equals("&nbsp;") Then
                        nss = 0
                    Else
                        nss = Convert.ToInt32(row.Cells(0).Text)
                    End If

                    resultado = ReporteLactanciaExtraordinaria(ucInfoEmpleado1.Cedula.Replace("-", ""), Session("RegistroPatronal").ToString(), lblFechaNacimiento.Text, nss, _
                                                       row.Cells(1).Text, row.Cells(2).Text, row.Cells(3).Text, row.Cells(5).Text, _
                                                       row.Cells(4).Text, UsrUserName, lblCantidadLactantes.Text, solicitud)
                    If resultado.Equals("OK") Then
                        Response.Redirect("NovedadesAplicadas.aspx?msg=Su solicitud fue procesada, el numero es: " & solicitud)
                    Else
                        lblMsg.Text = resultado
                        Exit Sub
                    End If
                Next

            End If

        Catch ex As Exception

            Try
                Dim err As String()
                err = ex.Message.Split("|")
                lblMsg.Text = err(0)
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())

            Catch ex2 As Exception
                lblMsg.Text = "Ha ocurrido un error: " & ex2.Message
            End Try

        End Try
    End Sub

    Protected Sub btnCancelarGeneral_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelarGeneral.Click
        Response.Redirect("~/Novedades/sfsLactanciaExtraordinario.aspx?NombreEmpleado=" & ucInfoEmpleado1.NombreEmpleado & "&NSS=" & ucInfoEmpleado1.NSS & "&Cedula=" & ucInfoEmpleado1.Cedula & "&Sexo=" & ucInfoEmpleado1.Sexo & "&FechaNacimiento=" & ucInfoEmpleado1.FechaNacimiento & "&Cantidad=" & Request.QueryString("Cantidad").ToString() & "&FechaNacimientoLactante=" & Request.QueryString("FechaNacimientoLactante").ToString())
    End Sub
End Class
