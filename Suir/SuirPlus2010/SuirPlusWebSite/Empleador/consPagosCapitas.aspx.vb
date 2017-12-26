Imports SuirPlus
Imports SuirPlus.Empresas.SubsidiosSFS.Consultas

Partial Class Empleador_consPagosCapitas
    Inherits BasePage
    Public Referencia As String

    Protected Sub Empleador_consPagosCapitas_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            lblMensaje.Text = String.Empty
            Referencia = Request.QueryString("Nro")

            Try

                gvPagosExceso.DataSource = getPagosExcesoRepresentante(UsrRegistroPatronal, Referencia)
                gvPagosExceso.DataBind()
                LlenarFiltro()
                If Not gvPagosExceso.Rows.Count > 0 Then
                    lblMensaje.Text = "No existen registros de devoluciones"
                    pnlInfoEncabezado.Visible = False
                Else
                    pnlInfoEncabezado.Visible = True
                End If

            Catch ex As Exception
                lblMensaje.Text = ex.Message

            End Try
        End If

    End Sub

    Protected Sub gvReferenciaCredito_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPagosExceso.RowDataBound

        If (e.Row.RowType = DataControlRowType.DataRow) Then
            e.Row.Cells(0).Text = "<a href=""consFacturas.aspx?tipo=sdss&sec=encabezado&nro=" & e.Row.Cells(0).Text & """>" & e.Row.Cells(0).Text & "</a>"

        End If

    End Sub
    Protected Sub gvReferenciaExceso_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPagosExceso.RowDataBound

        If (e.Row.RowType = DataControlRowType.DataRow) Then
            e.Row.Cells(1).Text = "<a href=""consFacturas.aspx?tipo=sdss&sec=encabezado&nro=" & e.Row.Cells(1).Text & """>" & e.Row.Cells(1).Text & "</a>"

        End If

    End Sub

    Protected Function formateaPeriodo(ByVal Periodo As Object) As String
        If Not IsDBNull(Periodo) Then
            Return Utilitarios.Utils.FormateaPeriodo(Periodo)
        Else
            Return String.Empty
        End If
    End Function
    Protected Function formateaCedula(ByVal rnc As Object) As String

        If Not IsDBNull(rnc) Then
            If rnc = String.Empty Then
                Return String.Empty
            Else
                Return Utilitarios.Utils.FormatearRNCCedula(rnc)
            End If
        Else
            Return String.Empty
        End If

    End Function

    Protected Sub ucExportarExcel1_ExportaExcel(sender As Object, e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel

        If txtFiltro.Text <> String.Empty And ddlFiltro.SelectedValue <> "-1" Then
            If ddlFiltro.SelectedValue = "1" Then
                ucExportarExcel1.FileName = "Listado_Pagos_Devolucion.xls"
                ucExportarExcel1.DataSource = SuirPlus.Empresas.SubsidiosSFS.Consultas.FiltrarPagosExceso(UsrRegistroPatronal, txtFiltro.Text, "", "", "")

            ElseIf ddlFiltro.SelectedValue = "2" Then
                ucExportarExcel1.FileName = "Listado_Pagos_Devolucion.xls"
                ucExportarExcel1.DataSource = SuirPlus.Empresas.SubsidiosSFS.Consultas.FiltrarPagosExceso(UsrRegistroPatronal, "", txtFiltro.Text, "", "")
            ElseIf ddlFiltro.SelectedValue = "3" Then
                ucExportarExcel1.FileName = "Listado_Pagos_Devolucion.xls"
                ucExportarExcel1.DataSource = SuirPlus.Empresas.SubsidiosSFS.Consultas.FiltrarPagosExceso(UsrRegistroPatronal, "", "", txtFiltro.Text, "")
            ElseIf ddlFiltro.SelectedValue = "4" Then
                ucExportarExcel1.FileName = "Listado_Pagos_Devolucion.xls"
                ucExportarExcel1.DataSource = SuirPlus.Empresas.SubsidiosSFS.Consultas.FiltrarPagosExceso(UsrRegistroPatronal, "", "", "", txtFiltro.Text)

            End If

        Else

            ucExportarExcel1.FileName = "Listado_Pagos_Devolucion.xls"
            ucExportarExcel1.DataSource = getPagosExcesoRepresentante(UsrRegistroPatronal, Referencia)

        End If


    End Sub


    Sub LlenarFiltro()
        ddlFiltro.Items.Add(New ListItem("Seleccione", "-1"))
        ddlFiltro.Items.Add(New ListItem("Referencia Credito", "1"))
        ddlFiltro.Items.Add(New ListItem("Referencia pagada con Per Cápita", "2"))
        ddlFiltro.Items.Add(New ListItem("Cedula Titular", "3"))
        ddlFiltro.Items.Add(New ListItem("Cedula Dependiente", "4"))

        ddlFiltro.SelectedValue = "-1"


    End Sub

    Protected Sub btnFiltrar_Click(sender As Object, e As System.EventArgs) Handles btnFiltrar.Click
        If ddlFiltro.SelectedValue = "-1" Then
            lblMensaje.Text = "Debe seleccionar una Opcion del Filtro para realizar la busqueda."
            Return
        ElseIf ddlFiltro.SelectedValue = "1" Then
            gvPagosExceso.DataSource = SuirPlus.Empresas.SubsidiosSFS.Consultas.FiltrarPagosExceso(UsrRegistroPatronal, txtFiltro.Text, "", "", "")

        ElseIf ddlFiltro.SelectedValue = "2" Then
            gvPagosExceso.DataSource = SuirPlus.Empresas.SubsidiosSFS.Consultas.FiltrarPagosExceso(UsrRegistroPatronal, "", txtFiltro.Text, "", "")
        ElseIf ddlFiltro.SelectedValue = "3" Then
            If txtFiltro.Text.Contains("-") Then
                lblMensaje.Text = "La cedula no debe contener guiones."
                Return
            End If
            gvPagosExceso.DataSource = SuirPlus.Empresas.SubsidiosSFS.Consultas.FiltrarPagosExceso(UsrRegistroPatronal, "", "", txtFiltro.Text, "")
        ElseIf ddlFiltro.SelectedValue = "4" Then
            If txtFiltro.Text.Contains("-") Then
                lblMensaje.Text = "La cedula no debe contener guiones."
                Return
            End If
            gvPagosExceso.DataSource = SuirPlus.Empresas.SubsidiosSFS.Consultas.FiltrarPagosExceso(UsrRegistroPatronal, "", "", "", txtFiltro.Text)

        End If
        gvPagosExceso.DataBind()

    End Sub
End Class
