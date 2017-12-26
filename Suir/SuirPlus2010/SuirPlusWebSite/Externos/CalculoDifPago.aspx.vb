Imports System.Data
Imports Oracle.DataAccess.Client

Partial Class Externos_CalculoDifPago
    Inherits BasePage

    Dim NoReferencia As String
    Dim Documento As String
    Dim SalarioSS As Decimal
    Dim AporteVoluntario As Decimal
    Dim dtDetalle As DataTable

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Put user code to initialize the page here
    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click

        Dim mFactura As SuirPlus.Empresas.Facturacion.FacturaSS
        Dim Empleado As SuirPlus.Empresas.Trabajador

        NoReferencia = Me.txtReferencia.Text
        Documento = Me.txtCedula.Text

        SalarioSS = Me.txtSalario.Text
        AporteVoluntario = Me.txtAporte.Text

        Try

            mFactura = New SuirPlus.Empresas.Facturacion.FacturaSS(NoReferencia)
            If Documento.Length = 9 Then
                Empleado = New SuirPlus.Empresas.Trabajador(Documento)
            Else
                Empleado = New SuirPlus.Empresas.Trabajador(SuirPlus.Empresas.Trabajador.TrabajadorDocumentoType.Cedula, Documento)
            End If

            Me.lblError.Text = String.Empty
            dtDetalle = SuirPlus.Empresas.Facturacion.FacturaSS.getNotificacionRecalculada(NoReferencia, Documento, SalarioSS, AporteVoluntario)
            llenarDatagrid()

            'Catch exO As OracleException

            '    Me.pnlDatagrid.Visible = False
            '    Me.lblError.Text = "Favor verificar que la notificacion exista y que el trabajador este reflejado. <br> " & exO.ToString
            '    Exit Sub
        Catch ex As Exception
            Me.pnlDatagrid.Visible = False
            Me.lblError.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub
        End Try

        Me.lblTrabajador.Text = Empleado.Nombres + " " + Empleado.PrimerApellido + " " + Empleado.SegundoApellido
        Me.lblRazonSocial.Text = mFactura.RazonSocial
        Me.lblRNC.Text = mFactura.RNC
        Me.lblPeriodo.Text = mFactura.Periodo
        Me.lblNomina.Text = mFactura.Nomina

    End Sub



    Sub llenarDatagrid()

        If dtDetalle.Rows.Count > 0 Then

            Me.pnlDatagrid.Visible = True
            Me.gvDetalleReal.DataSource = dtDetalle
            Me.gvDetalleReal.DataBind()
            Me.gvDetalleReal.Visible = True
            Me.gvDetalleRecalculado.DataSource = dtDetalle
            Me.gvDetalleRecalculado.DataBind()
            Me.gvDetalleRecalculado.Visible = True
            Me.gvDetalleDiferencia.DataSource = dtDetalle
            Me.gvDetalleDiferencia.DataBind()
            Me.gvDetalleDiferencia.Visible = True

        Else

            Me.pnlDatagrid.Visible = False

        End If

    End Sub

    Private Sub On_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ExportaExcel.ExportaExcel

        NoReferencia = Me.txtReferencia.Text
        Documento = Me.txtCedula.Text

        SalarioSS = Me.txtSalario.Text
        AporteVoluntario = Me.txtAporte.Text

        ExportaExcel.FileName = "Factura_" & Me.txtReferencia.Text
        ExportaExcel.DataSource = SuirPlus.Empresas.Facturacion.FacturaSS.getNotificacionRecalculada(NoReferencia, Documento, SalarioSS, AporteVoluntario)

    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Response.Redirect("CalculoDifPago.aspx")
    End Sub
End Class

