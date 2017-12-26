Imports SuirPlus
Imports System.Data

Partial Class Reportes_NP_por_trabajadores
    Inherits BasePage
    Protected empleado As SuirPlus.Empresas.Trabajador


    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click
        Try
            Me.lblMsg.Text = String.Empty

            If (Me.txtDocumento.Text <> String.Empty) Then
                If (Me.txtDocumento.Text.Length = 11) Then
                    empleado = New SuirPlus.Empresas.Trabajador(SuirPlus.Empresas.Trabajador.TrabajadorDocumentoType.Cedula, Me.txtDocumento.Text)
                Else
                    empleado = New SuirPlus.Empresas.Trabajador(SuirPlus.Empresas.Trabajador.TrabajadorDocumentoType.Pasaporte, Me.txtDocumento.Text)
                End If

                If empleado Is Nothing Then
                    Me.lblMsg.Text = SuirPlus.Utilitarios.TSS.getErrorDescripcion(24)
                    Exit Sub
                End If

                Me.divInfoTrabajador.Visible = True

                ucInfoEmpleado1.NombreEmpleado = empleado.Nombres + " " + empleado.PrimerApellido + " " + empleado.SegundoApellido
                ucInfoEmpleado1.NSS = empleado.NSS.ToString
                ucInfoEmpleado1.Cedula = empleado.Documento
                ucInfoEmpleado1.Sexo = empleado.Sexo
                ucInfoEmpleado1.FechaNacimiento = empleado.FechaNacimiento

                getData(Me.txtDocumento.Text)

            Else
                lblMsg.Visible = True
                Me.divInfoTrabajador.Visible = False
                Me.pnlNP_Por_Trabajadores.Visible = False
                Me.lblMsg.Text = "Nro. de documento inválido."

            End If


        Catch ex As Exception
            lblMsg.Visible = True
            Me.divInfoTrabajador.Visible = False
            Me.pnlNP_Por_Trabajadores.Visible = False
            Me.lblMsg.Text = ex.Message
        End Try



    End Sub

    Protected Sub getData(ByVal Documento As String)
        Dim dt As New DataTable
        Try

            dt = Empresas.Consultas.get_NP_por_trabajadores(Documento)

            If dt.Rows.Count > 0 Then
                Me.pnlNP_Por_Trabajadores.Visible = True
                Me.lblMsg.Visible = False
                rvNP_Por_Trabajadores.LocalReport.DataSources.Clear()
                rvNP_Por_Trabajadores.LocalReport.DataSources.Add(New Microsoft.Reporting.WebForms.ReportDataSource("NP_Trabajadores_ds", dt))
                rvNP_Por_Trabajadores.LocalReport.Refresh()
            Else
                Me.divInfoTrabajador.Visible = False
                Me.pnlNP_Por_Trabajadores.Visible = False
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existen registros para este trabajador"
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
            Me.divInfoTrabajador.Visible = False
            Me.pnlNP_Por_Trabajadores.Visible = False
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.Response.Redirect("NP_Por_Trabajadores.aspx")
    End Sub


End Class
