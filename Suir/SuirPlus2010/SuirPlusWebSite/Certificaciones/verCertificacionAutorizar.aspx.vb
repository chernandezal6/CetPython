Imports SuirPlus

Partial Class Certificaciones_verCertificacionAutorizar
    Inherits BasePage


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            'EN PRODUCCION ES 254
            'este es el codigo para desarrollo y prueba 244
            If Not Me.IsInPermiso("254") Then
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "Usted no tiene los permisos necesarios para ver esta pagina."
                Exit Sub
            End If
            bindGridView()
        End If

    End Sub

    Protected Sub bindGridView()
        Dim dt As New Data.DataTable
        Try
            dt = Empresas.Certificaciones.getCertificaciones(Nothing, Nothing, Nothing, Nothing, 1, "CI", 1, 9999, String.Empty, String.Empty)


            If dt.Rows.Count > 0 Then
                Me.gvCertificacionesAutorizar.DataSource = dt
                Me.gvCertificacionesAutorizar.DataBind()
            Else
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existen certificaciones pendientes de autorizar"
            End If
        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try


    End Sub

    Protected Sub gvCertificacionesAutorizar_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvCertificacionesAutorizar.RowCommand
        If e.CommandName = "Ver" Then
            Dim idCert() As String = e.CommandArgument.ToString.Split("|")
            Response.Redirect("AutorizarCertificacion.aspx?Id= " & idCert(0) & "&Tipo=" & idCert(1))
        End If
    End Sub


    Protected Function formateaRNC_Cedula(ByVal rnc As Object) As Object

        If Not rnc Is DBNull.Value Then

            Return Utilitarios.Utils.FormatearRNCCedula(rnc.ToString)

        End If

        Return rnc

    End Function



End Class
