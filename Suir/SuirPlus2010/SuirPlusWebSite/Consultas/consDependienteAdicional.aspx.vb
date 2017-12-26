Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios
Partial Class Consultas_consDependienteAdicional
    Inherits BasePage

    Protected dtDependiente As DataTable = Nothing
    Protected dtTitular As DataTable = Nothing


    Private Sub btnBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        If (Trim(Me.txtDocumento.Text) = String.Empty) Then
            lblError.Text = "Debe introducir una Cédula o un Número de seguridad social"
            Exit Sub
        End If

        BindDatagrid()

    End Sub

    Private Sub BindDatagrid()

        Try

            If Me.drpTipoConsulta.SelectedValue = "C" Then
                'llenamos el grid del titular via cedula
                Me.txtDocumento.MaxLength = 11

                dtTitular = Empresas.DependienteAdicional.getTitular(Me.txtDocumento.Text, Nothing)

                'llenamos el grid del dependiente via cedula
                dtDependiente = Empresas.DependienteAdicional.getDependienteAdicional(Me.txtDocumento.Text, Nothing)
            Else
                'llenamos el grid del titular via NSS
                If Trim(Me.txtDocumento.Text.Length) <> 9 Then

                    Me.txtDocumento.Text.Trim.PadLeft(9, "0")
                End If
                dtTitular = Empresas.DependienteAdicional.getTitular(Nothing, Me.txtDocumento.Text)
                'Llenamos el grid del titular via Cedula
                dtDependiente = Empresas.DependienteAdicional.getDependienteAdicional(Nothing, Me.txtDocumento.Text)
            End If

            If (Me.dtTitular.Rows.Count <= 0) Or (Me.dtDependiente.Rows.Count <= 0) Then

                Me.gvDetalleTitutar.Visible = False
                Me.lblTitular.Visible = False
                Me.gvDependiente.Visible = False
                Me.lblTituloDependiente.Visible = False
                lblError.Text = "No se encontró registro para esta consulta."

            Else

                Me.gvDetalleTitutar.DataSource = dtTitular
                Me.gvDetalleTitutar.DataBind()

                Me.gvDependiente.DataSource = dtDependiente
                Me.gvDependiente.DataBind()

                Me.gvDetalleTitutar.Visible = True
                Me.lblTitular.Visible = True
                Me.gvDependiente.Visible = True
                Me.lblTituloDependiente.Visible = True

            End If

            dtTitular = Nothing
            dtDependiente = Nothing

        Catch ex As Exception
            Exepciones.Log.LogToDB(ex.ToString())
            Throw New Exception(ex.ToString)
        End Try

    End Sub

    Private Sub btnLimpiar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click

        Response.Redirect("consDependienteAdicional.aspx")

    End Sub

End Class
