Imports SuirPlus
Imports System.Data
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.Facturacion
Partial Class Externos_recRiesgoLaboral
    Inherits BasePage


    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not Page.IsPostBack Then
            BindCategoria()
        End If

    End Sub

    Sub BindCategoria()

        Me.drpCategoria.DataSource = SuirPlus.Mantenimientos.Parametro.getCategoriaRiesgo
        Me.drpCategoria.DataTextField = "riesgo_des"
        Me.drpCategoria.DataValueField = "id_riesgo"
        Me.drpCategoria.DataBind()

    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click

        Dim noReferencia As String = Me.txtReferencia.Text
        Dim empFactura As FacturaSS = Nothing

        Try
            empFactura = New FacturaSS(noReferencia)
        Catch ex As Exception
            Me.lblMsg.Text = "No. de referencia inválido"
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

        If Not empFactura Is Nothing Then
            UcInfoEmpleador.RazonSocial = empFactura.RazonSocial
            UcInfoEmpleador.NombreComercial = empFactura.NombreComercial
            UcInfoEmpleador.RNC = empFactura.RNC
            UcInfoEmpleador.RegistroPatronal = empFactura.RegistroPatronal

            bindLlenaGrid()

            Me.pnlConsulta.Visible = True

        Else
            Me.pnlConsulta.Visible = False
            Me.lblMsg.Text = "No se encontró notificación."
        End If

    End Sub

    Sub bindLlenaGrid()

        Dim dtRecalculo As DataTable = SuirPlus.Empresas.Facturacion.FacturaSS.getSrlRecalculado(Me.txtReferencia.Text, Me.drpCategoria.SelectedValue)
        Me.gvRecalculo.DataSource = dtRecalculo
        Me.gvRecalculo.DataBind()

    End Sub

    Protected Sub gvRecalculo_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvRecalculo.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Cells(1).Text = SuirPlus.Utilitarios.Utils.FormateaPeriodo(e.Row.Cells(1).Text)

            'Formateamos nosotros mismo la celda #6  ya que con el {0:c} los numeros negativos lo pone entre parentesis no en negativo
            If CDbl(e.Row.Cells(6).Text) < 0.0 Then e.Row.Cells(6).ForeColor = Drawing.Color.Red
            e.Row.Cells(6).Text = "RD$" + e.Row.Cells(6).Text
        End If

    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Response.Redirect("recRiesgoLaboral.aspx")
    End Sub
End Class


