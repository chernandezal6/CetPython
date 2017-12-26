Imports System.Data
Imports SuirPlus.Utilitarios
Partial Class DesmarcarIR13
    Inherits BasePage
    Public i As Double

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        Dim dt As New DataTable

        Try
            Dim emp As New SuirPlus.Empresas.Empleador(Me.txtRNC.Text)
            'Llenando los controles'
            Me.lblTelefono.Text = SuirPlus.Utilitarios.Utils.FormatearTelefono(emp.Telefono1)
            Me.lblRazonSocial.Text = emp.RazonSocial
            Me.lblNombreComercial.Text = emp.NombreComercial

            Me.lblTelefono.Visible = True
            Me.lblRazonSocial.Visible = True
            Me.lblNombreComercial.Visible = True
            Me.tblInfoAcuerdo.Visible = True
            Me.txtRNC.ReadOnly = True
            Me.btnBuscar.Enabled = False

            Dim ir As New SuirPlus.Empresas.Facturacion.ResumenDeclaracionIR13(Utils.getPeriodoIR13, Me.txtRNC.Text)
            If ir.Status = "Procesado" Then
                btDeclarar.enabled = True
                btDeclarar.visible = True
                Me.lblMensaje.Text = "IR-13 Declarado"
            Else
                Me.lblMensaje.Text = "IR-13 No Declarado"
            End If

            Me.lblMensaje.Visible = True

        Catch ex As Exception

            Me.lblMensaje.Text = "Este empleador no se encuentra registrado en nuestras base de datos." & "<br>" & ex.ToString()
            Me.lblMensaje.Visible = True
            Me.LimpiarCampos()
            Me.txtRNC.ReadOnly = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
       End Try

    End Sub
    Private Sub LimpiarCampos()

        Me.lblNombreComercial.Text = ""
        Me.lblRazonSocial.Text = ""
        Me.lblTelefono.Text = ""

        Me.lblTelefono.Visible = False
        Me.lblRazonSocial.Visible = False
        Me.lblNombreComercial.Visible = False
        Me.tblInfoAcuerdo.Visible = False
        Me.txtRNC.ReadOnly = False
        Me.btnBuscar.Enabled = True
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click

        Me.txtRNC.ReadOnly = False
        Me.btnBuscar.Enabled = True
        Me.LimpiarCampos()
        Me.txtRNC.Text = ""
    End Sub
    Protected Sub btDeclarar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btDeclarar.Click
        Dim ir As New SuirPlus.Empresas.Facturacion.ResumenDeclaracionIR13(Utils.getPeriodoIR13, Me.txtRNC.Text)
        If ir.Status = "Procesado" Then
            ir.DesmarcarProcesado(Me.UsrUserName())
            Me.lblMensaje.Text = "La Declaración existente del IR-13 fue anulada."
            Me.lblMensaje.Visible = True
        End If
        btDeclarar.Visible = False
        btDeclarar.Enabled = False
    End Sub
End Class
