
Partial Class Oficios_cancelaOficios
    Inherits BasePage

    Private Sub btnCancelarOficio_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelarOficio.Click

        '' ToDo: Alguien

        Me.buscaOficio()

    End Sub

    Private Sub buscaOficio()

        Dim tmpOfc As SuirPlus.Empresas.Oficio

        Try
            tmpOfc = New SuirPlus.Empresas.Oficio(Me.txtCodOficio.Text)
        Catch ex As Exception
            Me.lblMsg.Text = "Este oficio no fue encontrado."
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Return
        End Try

        'Validando el estatus
        If tmpOfc.Status = "C" Then
            Me.lblMsg.Text = "Este oficio fue cancelado por " & tmpOfc.NombreUsuarioProcesa & ", en fecha " & tmpOfc.FechaCancela.ToShortDateString()
            Return
        ElseIf tmpOfc.Status = "A" Then
            Me.lblMsg.Text = "Este oficio fue procesado por " & tmpOfc.NombreUsuarioProcesa & ", en fecha " & tmpOfc.FechaProcesa.ToShortDateString()
            Return
        End If

        Me.pnlForm.Visible = False
        Me.pnlResult.Visible = True

        Me.lblAccion.Text = tmpOfc.AccionDes
        Me.lblGeneradoPor.Text = tmpOfc.NombreUsuarioSolicita
        Me.lblOficioNo.Text = tmpOfc.IdOficio
        Me.lblRazonSocial.Text = tmpOfc.RazonSocial
        Me.lblObsSol.Text = tmpOfc.ObsSolicita

    End Sub

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Me.lblMsg.Text = ""
        Me.lblMsg.ForeColor = Drawing.Color.Red

        If Not IsPostBack Then Me.iniForm()

    End Sub

    Private Sub iniForm()

        Me.pnlForm.Visible = True
        Me.pnlResult.Visible = False
        Me.txtCodOficio.Text = ""
        Me.txtObs.Text = ""

    End Sub

    Private Sub btnCancelar2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar2.Click, btnCancelar.Click
        Me.iniForm()
    End Sub

    Private Sub btnCancelarOficio2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelarOficio2.Click

        Dim str As String = SuirPlus.Empresas.Oficio.cancelaOficio(Me.lblOficioNo.Text, Me.UsrUserName, Me.txtObs.Text)

        If Split(str, "|")(0) = "0" Then

            iniForm()
            Me.lblMsg.Text = Split(str, "|")(1)
            Me.lblMsg.ForeColor = Drawing.Color.Blue

        Else

            Me.lblMsg.Text = Split(str, "|")(1)

        End If

    End Sub

End Class
