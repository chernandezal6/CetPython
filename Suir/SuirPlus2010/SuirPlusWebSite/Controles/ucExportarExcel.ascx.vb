Imports System
Imports System.Data

Partial Class Controles_ucExportarExcel
    Inherits System.Web.UI.UserControl

    Private dtExportar As DataTable
    Public Event ExportaExcel(ByVal sender As Object, ByVal e As EventArgs)

    Public WriteOnly Property DataSource() As DataTable
        Set(ByVal Value As DataTable)
            dtExportar = Value
        End Set
    End Property
    Public Property FileName() As String
        Get
            If Me.ViewState("myNombreArchivo") = "" Then
                Return Session.SessionID.ToString
            Else
                Return ViewState("myNombreArchivo")
            End If
        End Get
        Set(ByVal Value As String)
            Me.ViewState("myNombreArchivo") = Value
        End Set
    End Property

    Public Sub LinkButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LinkButton1.Click

        RaiseEvent ExportaExcel(Me, Nothing)
        exportarDT()

    End Sub

    Public Sub exportarDT()

        Page.Controls.Clear()
        Dim dt As DataTable = Me.dtExportar

        Dim dg As New DataGrid
        dg.DataSource = dt
        dg.DataBind()

        Page.Controls.Add(dg)

        Response.Clear()
        Response.Buffer = True
        Response.Charset = ""
        'Response.ContentType = "application/vnd.ms-excel"
        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        'Response.AddHeader("Content-Disposition", "attachment; filename=""" & Me.FileName & """")
        Response.AddHeader("Content-Disposition", "attachment; filename= " & Me.FileName)
        'Response.ContentEncoding = System.Text.Encoding.UTF8

        EnableViewState = False


    End Sub

End Class
