Imports System.Data
Imports SuirPlus
Partial Class Consultas_consNacionalidades
    Inherits BasePage

    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            cargarNacionalidades()
        End If
    End Sub

    Protected Sub cargarNacionalidades()
        Try
            Dim dtNacionalidades = SuirPlus.Utilitarios.TSS.get_Nacionalidades()

            If dtNacionalidades.Rows.Count > 0 Then
                divNacionalidades.Visible = True
                lblMsg.Visible = False
                gvNacionalidades.DataSource = dtNacionalidades
                gvNacionalidades.DataBind()
            Else
                divNacionalidades.Visible = False
                Throw New Exception("No hay registros.")
            End If
        Catch ex As Exception
            lblMsg.Visible = True
            divNacionalidades.Visible = False
            lblMsg.Text = ex.Message
        End Try

    End Sub

    Protected Sub ucExportarExcel1_ExportaExcel(sender As Object, e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel
        Dim dtNac = SuirPlus.Utilitarios.TSS.get_Nacionalidades()
        ucExportarExcel1.FileName = "Listado_de_Nacionalidades.xls"
        ucExportarExcel1.DataSource = dtNac
    End Sub
End Class
