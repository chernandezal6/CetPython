Imports SuirPlus

Partial Class MDT_catalogoPuestos
    Inherits BasePage

    Protected Sub UcExp_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles UcExp.ExportaExcel

        Dim dtCatalogo = SuirPlus.MDT.General.getPuestos("", 1, 9999)
        dtCatalogo.Columns.RemoveAt(0)
        dtCatalogo.Columns.RemoveAt(0)
        dtCatalogo.Columns.RemoveAt(2)

        UcExp.FileName = "Catalogo_de_Puestos.xls"
        UcExp.DataSource = dtCatalogo

    End Sub

End Class
