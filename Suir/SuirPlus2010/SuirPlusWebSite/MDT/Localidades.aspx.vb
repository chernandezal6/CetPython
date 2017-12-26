
Partial Class MDT_Localidades
    Inherits BasePage

    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load
        Dim pagaMDT As Boolean

        If UsrRegistroPatronal <> String.Empty Then
            Dim emp As New SuirPlus.Empresas.Empleador(CInt(UsrRegistroPatronal))
            pagaMDT = emp.PagaMDT
            If Not pagaMDT Then
                Response.Redirect("../Empleador/consNotificaciones.aspx")
            End If

        Else
            Response.Redirect("../Empleador/consNotificaciones.aspx")

        End If

    End Sub

    Protected Sub ucExportarExcel1_ExportaExcel(sender As Object, e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel
        Dim dtLocalidades = SuirPlus.MDT.Localidades.getLocalidades(UsrRegistroPatronal, 1, 9999)
        dtLocalidades.Columns.RemoveAt(0)
        dtLocalidades.Columns.RemoveAt(0)

        ucExportarExcel1.FileName = "Establecimientos.xls"
        ucExportarExcel1.DataSource = dtLocalidades

    End Sub


End Class
