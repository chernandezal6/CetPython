Partial Class Novedades_CambioCiudadanosAplicar
    Inherits BasePage


    Protected Sub Novedades_CambioCiudadanosAplicar_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Page.IsPostBack = False Then
            Me.cargarCiudadanosPE()
        End If
    End Sub

    Protected Sub cargarCiudadanosPE()

        Dim dt As New Data.DataTable
        Try
            dt = SuirPlus.Utilitarios.TSS.getCiudadano()

            If dt.Rows.Count > 0 Then

                Me.gvCiudadanosPE.DataSource = dt
                Me.gvCiudadanosPE.DataBind()

            Else
                ''Me.lblMsg.Text = "No existen registros Pendientes"
            End If
        Catch ex As Exception
            Me.lblMsg.Text = ex.ToString
        End Try


    End Sub

    Protected Sub btnAplicarCambio_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAplicarCambio.Click
        If SuirPlus_Status = "REDUCIDO" Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = SuirPlusREDUCIDO
            Exit Sub
        End If

        '' Aplicar todos los elementos del Grid
        For Each row As GridViewRow In gvCiudadanosPE.Rows

            SuirPlus.Utilitarios.TSS.AplicarCambioCiudadano(row.Cells(0).Text)

        Next

        Response.Redirect("NovedadesAplicadas.aspx?msg=Novedades Aplicadas")


    End Sub

End Class
