Imports System.Data

Partial Class Externos_consMontosSRLEmpleador
    Inherits BasePage

    Private Sub btBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btBuscar.Click

        'Validando el empleador
        Try
            Dim emp As New SuirPlus.Empresas.Empleador(Me.txtRNC.Text)

            Dim tmpDt As DataTable = SuirPlus.Empresas.Empleador.getConsSRLEmp(Me.txtRNC.Text, Me.txtPeriodo.Text)

            If tmpDt.Rows.Count > 0 Then

                Me.lblRS.Visible = True
                Me.lblNC.Visible = True
                Me.gvNotificaciones.DataSource = tmpDt
                Me.gvNotificaciones.DataBind()
                Me.lblRazonSocial.Text = emp.RazonSocial
                Me.lblNombreComercial.Text = emp.NombreComercial

            Else

                Me.lblMsg.Text = "No fueron encontradas notificaciones para este periodo."
                Me.resetForm()

            End If
        Catch ex As Exception

            Me.lblMsg.Text = "El empleador no fue encontrado."
            Me.resetForm()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Return

        End Try


    End Sub

    Private Sub btnLimpiar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        resetForm()
    End Sub

    Private Sub resetForm()
        Me.lblRS.Visible = False
        Me.lblNC.Visible = False
        Me.lblRazonSocial.Text = ""
        Me.lblNombreComercial.Text = ""
        Me.txtPeriodo.Text = ""
        Me.txtRNC.Text = ""
        Me.gvNotificaciones.DataSource = Nothing
        Me.gvNotificaciones.DataBind()
    End Sub

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Me.IsPostBack Then Me.resetForm()
        Me.lblMsg.Text = ""
    End Sub
End Class

