Imports System
Imports System.Data
Imports SuirPlus

Partial Class Consultas_consFacturaRNCDetalle
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim rnc As String = Request("rnc")
        Dim tipo As String = Request("tipo")
        Dim nom As String = Request("nom")
        Dim status As String = Request("status")
        Dim pageNum As String = Request("page")

        Dim url As String = "consFacturaRnc.aspx?rnc=" & rnc & "&tipo=" & tipo & "&nom=" & nom & "&pageNum=" & pageNum & "&status=" & status
        Me.hlnkAtras.NavigateUrl = url


        If Not Page.IsPostBack Then
            Me.cargarFacturas()
        End If

    End Sub

    Private Sub cargarFacturas()

        Dim ref As String = Request("nro")
        Dim rnc As String = Request("rnc")
        Dim dtData As DataTable = Nothing

        If Not ref = String.Empty Or Not rnc = String.Empty Then

            Try
                Dim tmpEmp As New Empresas.Empleador(CStr(rnc))
                Me.lblRNC.Text = rnc
                Me.lblNombreComercial.Text = tmpEmp.NombreComercial
                Me.lblRazonSocial.Text = tmpEmp.RazonSocial
                dtData = Empresas.Facturacion.FacturaSS.getResumenNotificacion(ref)
            Catch ex As Exception
                Me.lblMsg.Text = ex.Message
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

            If dtData.Rows.Count > 0 Then
                With dtData.Rows(0)
                    Me.lblReferencia.Text = Utilitarios.Utils.FormateaReferencia(.Item("ID_Referencia").ToString())
                    Me.lblEstatus.Text = .Item("Status").ToString()
                    Me.lblNomina.Text = .Item("Nomina_Des").ToString()
                    Me.lblTipoNomina.Text = .Item("tipo_nomina").ToString()
                    Me.lblPeriodo.Text = .Item("Periodo_Factura").ToString()
                    Me.lblFechaEmision.Text = String.Format("{0:d}", .Item("fecha_emision"))
                    Me.lblFechaPago.Text = String.Format("{0:d}", .Item("fecha_pago"))



                    'Totales
                    Me.lblAporteEmpSVDS.Text = String.Format("{0:c}", .Item("TOTAL_APORTE_EMPLEADOR_SVDS"))
                    Me.lblAporteAfilSVDS.Text = String.Format("{0:c}", .Item("TOTAL_APORTE_AFILIADOS_SVDS"))
                    Me.lblAporteVoluntario.Text = String.Format("{0:c}", .Item("TOTAL_APORTE_VOLUNTARIO"))
                    Me.lblAporteEmpSFS.Text = String.Format("{0:c}", .Item("TOTAL_APORTE_EMPLEADOR_SFS"))
                    Me.lblAporteAfilSFS.Text = String.Format("{0:c}", .Item("TOTAL_APORTE_AFILIADOS_SFS"))
                    Me.lblTotalSRL.Text = String.Format("{0:c}", .Item("TOTAL_APORTE_SRL"))
                    Me.lblRecargos.Text = String.Format("{0:c}", .Item("TOTAL_RECARGOS_FACTURA"))
                    Me.lblInteresesTotal.Text = String.Format("{0:c}", .Item("TOTAL_INTERES_FACTURA"))
                    Me.lblTotalGral.Text = String.Format("{0:c}", .Item("TOTAL_GENERAL_FACTURA"))

                End With
            End If
        Else
            Me.lblMsg.Text = "Debe especificar el RNC y el Nro. de Referencia."
        End If

    End Sub
End Class
