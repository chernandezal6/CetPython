
Partial Class Externos_HistoricodeDescuento
    Inherits BasePage

    Protected empleado As SuirPlus.Empresas.Trabajador
    Protected idciudadano As String
    Protected empleador As String
    Protected ano As String


    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not Page.IsPostBack Then
            Me.pnlConsulta.Visible = False
        End If

    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click

        idciudadano = txtCedulaNSS.Text

        Try

            If idciudadano.Length = 9 Then
                empleado = New SuirPlus.Empresas.Trabajador(Convert.ToInt32(idciudadano))
            ElseIf idciudadano.Length = 11 Then
                empleado = New SuirPlus.Empresas.Trabajador(SuirPlus.Empresas.Trabajador.TrabajadorDocumentoType.Cedula, idciudadano)
            End If

        Catch ex As Exception

            Me.lblMsg.Text = ex.Message
            Me.pnlConsulta.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

        If empleado Is Nothing Then
            Me.lblMsg.Text = SuirPlus.Utilitarios.TSS.getErrorDescripcion(24)
            Exit Sub
        End If

        Me.pnlConsulta.Visible = True

        Me.lblEmpleado.Text = empleado.Nombres + " " + empleado.PrimerApellido + " " + empleado.SegundoApellido
        Me.lblNSS.Text = SuirPlus.Utilitarios.Utils.FormatearNSS(empleado.NSS.ToString)
        Me.lblCedula.Text = SuirPlus.Utilitarios.Utils.FormatearCedula(empleado.Documento)
        Me.lblFechaNacimiento.Text = String.Format("{0:d}", empleado.FechaNacimiento.Date.ToShortDateString)

        empleador = Me.txtEmpleador.Text
        ano = Me.txtAno.Text

        'Grabamos las variables en viewstate
        ViewState("empleador") = empleador
        ViewState("ano") = ano
        ViewState("trabajador") = idciudadano

        llenarDatagrid(empleador, ano)

    End Sub

    Private Sub llenarDatagrid(ByVal rncEmpleador As String, ByVal ano As String)

        Dim dt As New Data.DataTable
        dt = empleado.getAportes(rncEmpleador, ano)

        If dt.Rows.Count > 0 Then
            Me.gvHistorico.DataSource = dt
            Me.gvHistorico.DataBind()
            Me.lblMsg.Text = ""
        Else
            Me.pnlConsulta.Visible = False
            Me.lblMsg.Text = "No existen registros para este año"
        End If

    End Sub


    Private Sub On_ExportaExcel(ByVal sender As Object, ByVal e As EventArgs) Handles Ucexportarexcel.ExportaExcel

        empleador = CType(ViewState("empleador"), String)
        ano = ViewState("ano").ToString
        idciudadano = CType(ViewState("trabajador"), String)

        If idciudadano.Length = 9 Then
            empleado = New SuirPlus.Empresas.Trabajador(Convert.ToInt32(idciudadano))
        ElseIf idciudadano.Length = 11 Then
            empleado = New SuirPlus.Empresas.Trabajador(SuirPlus.Empresas.Trabajador.TrabajadorDocumentoType.Cedula, idciudadano)
        End If

        Ucexportarexcel.FileName = "Descuento_Empleado_" & empleado.Nombres
        Ucexportarexcel.DataSource = empleado.getAportes(empleador, ano)

    End Sub

    Protected Sub gvHistorico_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvHistorico.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Cells(1).Text = SuirPlus.Utilitarios.Utils.FormateaPeriodo(e.Row.Cells(1).Text)
            e.Row.Cells(2).Text = SuirPlus.Utilitarios.Utils.FormateaPeriodo(e.Row.Cells(2).Text)
        End If
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("HistoricodeDescuento.aspx")
    End Sub
End Class

