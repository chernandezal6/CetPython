
Partial Class sys_deudaempleador
    Inherits BasePage

    Dim totalFactura As Decimal

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Me.pnlConsulta.Visible = False

    End Sub

    Private Sub btBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btBuscar.Click

        Dim IdEmpleador As String = Me.txtRNC.Text

        If IdEmpleador = String.Empty Or IdEmpleador Is Nothing Then
            Me.lblMensaje.Text = SuirPlus.Utilitarios.TSS.getErrorDescripcion(150)
        End If

        cargarDatosEmpleador(IdEmpleador)

    End Sub

    'Metodo utilizado para cargar los datos generales del empleador
    Private Sub cargarDatosEmpleador(ByVal rnc As String)

        Dim empleador As SuirPlus.Empresas.Empleador = Nothing

        Try
            empleador = New SuirPlus.Empresas.Empleador(rnc)
        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
        End Try

        If Not empleador Is Nothing Then

            Me.lblNombreComercial.Text = empleador.NombreComercial
            Me.lblRazonSocial.Text = empleador.RazonSocial
            mostrarFacturas(rnc)
            Me.pnlConsulta.Visible = True

            If empleador.isMovimientoPendiente = True Then
                Me.lblMovimiento.Text = SuirPlus.Utilitarios.TSS.getErrorDescripcion(172)
            End If

        End If

    End Sub

    'Metodo utilizado para cargar el datagrid con las facturas pendientes de un empleador.
    Private Sub mostrarFacturas(ByVal rnc As String)

        Dim dtFacturas As System.Data.DataTable = Nothing

        Try

            dtFacturas = SuirPlus.Empresas.Facturacion.FacturaSS.getConsultaDeudaARL(rnc)

        Catch ex As Exception

            Me.lblMensaje.Text = ex.Message

        End Try

        Me.dgFacturas.DataSource = dtFacturas
        Me.dgFacturas.DataBind()
        Me.dgFacturas.Visible = True

    End Sub

    Protected Sub dgFacturas_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgFacturas.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Try
                totalFactura += Convert.ToDecimal(Replace(Replace(e.Row.Cells(4).Text, ",", ""), "RD$", ""))
            Catch ex As Exception
            End Try
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(3).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(3).Text = "Total Gral.:"
            e.Row.Cells(4).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(4).Text = String.Format("{0:c}", totalFactura)
        End If
    End Sub
End Class
