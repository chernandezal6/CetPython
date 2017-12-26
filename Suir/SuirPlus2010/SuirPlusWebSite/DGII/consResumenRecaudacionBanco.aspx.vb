Imports System.Data

Partial Class DGII_consResumenRecaudacionBanco
    Inherits BasePage
    Protected validador As Integer
    Protected dt As DataTable
    Protected dt2 As DataTable
    Protected dt3 As DataTable
    Protected paginaTam As Integer

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Me.txtDesde.Text = DateTime.Now.ToString("d")
            Me.txtHasta.Text = DateTime.Now.ToString("d")
        End If
    End Sub

    Private Sub btBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btBuscar.Click
        validar()

        If Not validador = 1 Then

            'Ejecutamos los tres procesos que llenan los gridviews consecuentes.
            RecaudacionAclaraciones()
            RecaudacionPagos()
            RecaudacionTotal()

            If Not (dt.Rows.Count > 0) And Not (dt2.Rows.Count > 0) And Not (dt3.Rows.Count > 0) Then
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existen registros para este rango de fechas"
            Else
                Me.lblMsg.Visible = False
            End If
        Else
            Exit Sub

        End If
    End Sub

    Protected Sub validar()
        If CDate(Me.txtDesde.Text) > CDate(Me.txtHasta.Text) Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = "La fecha desde debe ser menor que la fecha hasta"
            validador = 1
            Exit Sub

        Else
            Me.lblMsg.Visible = False

        End If

    End Sub

    ' Se llena el dbgrid de Aclaraciones.
    Private Sub RecaudacionAclaraciones()

        Try

            dt2 = SuirPlus.Bancos.Dgii.getResumenRecaudacion(Me.txtDesde.Text, Me.txtHasta.Text, "A")
            If dt2.Rows.Count > 0 Then
                Me.gvDetalle2.DataSource = dt2
                Me.gvDetalle2.DataBind()
                Me.pnlAclaraciones.Visible = True
            Else
                Me.pnlAclaraciones.Visible = False
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub
    ' Se llena el dbgrid de Pagos.
    Private Sub RecaudacionPagos()

        Try

            dt = SuirPlus.Bancos.Dgii.getResumenRecaudacion(Me.txtDesde.Text, Me.txtHasta.Text, "P")
            If dt.Rows.Count > 0 Then
                Me.gvDetalle.DataSource = dt
                Me.gvDetalle.DataBind()
                Me.pnlPagos.Visible = True
            Else
                Me.pnlPagos.Visible = False
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub
    ' Se llena el dbgrid de Pagos y Aclaraciones (los totales de ambos).
    Private Sub RecaudacionTotal()

        Try
            dt3 = SuirPlus.Bancos.Dgii.getResumenRecaudacion(Me.txtDesde.Text, Me.txtHasta.Text, "T")
            If dt3.Rows.Count > 0 Then
                Me.gvDetalle4.DataSource = dt3
                Me.gvDetalle4.DataBind()
                Me.pnlTotales.Visible = True
            Else
                Me.pnlTotales.Visible = False
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub
    ' Enviamos a la pagina de Detalles mediante el numero de la Entidad Recaudadora.
    Protected Sub gvDetalle4_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDetalle4.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Cells(1).Text = "<a href=""consDetalleRecaudacionBanco.aspx?id_entidad_recaudadora=" & e.Row.Cells(0).Text & "&desc=" & e.Row.Cells(1).Text & "&desde=" & Me.txtDesde.Text & "&hasta=" & Me.txtHasta.Text & """>" & e.Row.Cells(1).Text & "</a>"
        End If
    End Sub


    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.pnlAclaraciones.Visible = False
        Me.pnlPagos.Visible = False
        Me.pnlTotales.Visible = False
        Me.lblMsg.Visible = False
        Me.txtDesde.Text = DateTime.Now.ToString("d")
        Me.txtHasta.Text = DateTime.Now.ToString("d")
    End Sub
End Class
