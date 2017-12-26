Imports System.Data

Partial Class DGII_consDetalleRecaudacionBanco
    Inherits BasePage

    ' Declaramos las variables globales.
    Protected dt As DataTable
    Protected dt2 As DataTable
    Protected dtP As DataTable
    Protected dtA As DataTable
    Protected fechaInicial As String
    Protected fechaFinal As String
    Protected paginaTam As Integer
    Dim ContPa, ContAc As Integer
    Dim acCount As Integer
    Dim paCount As Integer
    Dim entidad As String


    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        ' Establecemos los roles que manejaran esta página.
        'If Not IsPostBack Then
        '    ViewState("paginaActual") = 1
        'End If

        Me.RolesRequeridos = New String() {10, 46}
        entidad = Request("id_entidad_recaudadora")
        fechaInicial = Request("desde")
        fechaFinal = Request("hasta")
        ' Desplegamos en los labels las variables que recibimos de la página de Resumen.
        Me.lbltxtBanco.Text = Request("desc")
        Me.lbltxtDesde.Text = fechaInicial 'Request("desde")
        Me.lbltxtHasta.Text = fechaFinal 'Request("hasta")
        Me.DetallesPagos()
        Me.CuentaPagos(entidad)
        Me.CuentaAclaraciones(entidad)

    End Sub

    Private Sub DetallesPagos()

        Try
            ' Me.paginaTam = Application("gvPageSize")
            ' Me.gvDetalle.PageSize = Me.paginaTam
            Me.lbltxtBanco.Text = Request("desc")
            dt = SuirPlus.Bancos.Dgii.getDetalleRecaudoPagos(CInt(entidad), CDate(fechaInicial), CDate(fechaFinal))
            Me.gvDetalle.DataSource = dt
            Me.gvDetalle.DataBind()
            ' Me.Bind()

            'Dim ucEx As Controles_ucExportarExcel = Me.FindControl("ucExpExcel")
            'ucEx.DataSource = dt
        Catch ex As Exception
            Response.Write(ex.ToString())
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Private Sub CuentaPagos(ByVal entidad As Integer)
        dtP = SuirPlus.Bancos.Dgii.getCuentaPagos(CInt(entidad), CDate(fechaInicial), CDate(fechaFinal))
        Me.lbltxtPagos.Text = dtP.Rows(0)("cuenta")
    End Sub
    Private Sub CuentaAclaraciones(ByVal entidad As Integer)
        dtA = SuirPlus.Bancos.Dgii.getCuentaAclaraciones(CInt(entidad), CDate(fechaInicial), CDate(fechaFinal))
        Me.lbltxtAclaracion.Text = dtA.Rows(0)("cuenta")
    End Sub

    Private Sub On_ExportaExcel(ByVal sender As Object, ByVal e As EventArgs) Handles ucExpExcel.ExportaExcel
        ucExpExcel.FileName = "Recaudación de Bancos"
        ucExpExcel.DataSource = SuirPlus.Bancos.Dgii.getDetalleRecaudoPagos(CInt(entidad), CDate(fechaInicial), CDate(fechaFinal))
    End Sub

End Class

