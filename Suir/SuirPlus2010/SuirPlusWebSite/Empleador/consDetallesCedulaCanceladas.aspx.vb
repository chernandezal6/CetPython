Imports System.Data

Partial Class Empleador_consDetallesCedulaCanceladas
    Inherits BasePage

    Protected dt As DataTable
    Protected custView As New DataView
    Protected strFiltro As String
    Protected paginaActual As Integer = 1
    Protected paginaTam As Integer

    Protected registroPatronal As String
    Protected idNomina As String

    Private Sub cargaInicial()

        Me.dt = SuirPlus.Empresas.Nomina.getNomTrabCedCancel(registroPatronal, idNomina)
        If dt.Rows.Count > 0 Then
            Me.pnlDetTrabCedCanceladas.Visible = True
            Me.gvDetalle.DataSource = dt
            Me.gvDetalle.DataBind()
            Me.lblMensaje.Text = String.Empty

        Else
            Me.pnlDetTrabCedCanceladas.Visible = False
            Me.gvDetalle.DataSource = Nothing
            Me.lblMensaje.Text = "No existen registros disponibles."


        End If
    End Sub

    Public Function formateaNSS(ByVal NSS As Object) As Object

        If Not NSS Is DBNull.Value Then

            Return SuirPlus.Utilitarios.Utils.FormatearNSS(NSS.ToString)

        End If

        Return NSS

    End Function

    Public Function formateaDocumento(ByVal documento As String) As String

        'Si el documento que se envia no tiene 11 digitos asumimos que es un pasaporte.
        If documento.Length <> 11 Then
            Return documento
        End If

        Return SuirPlus.Utilitarios.Utils.FormatearCedula(documento)

    End Function

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        registroPatronal = Request("regPatronal")
        idNomina = Request("nomina")
        Me.gvDetalle.Visible = True
        Me.cargaInicial()
    End Sub

    Protected Sub UcExp_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles UcExp.ExportaExcel
        Me.UcExp.FileName = "Nomina_" & idNomina.ToString & ".xls"
        Me.UcExp.DataSource = SuirPlus.Empresas.Nomina.getNomTrabCedCancel(registroPatronal, idNomina)
    End Sub
End Class
