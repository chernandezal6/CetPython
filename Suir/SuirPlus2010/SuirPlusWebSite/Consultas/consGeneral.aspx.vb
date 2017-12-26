Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios.Utils
Partial Class Consultas_consGeneral
    Inherits BasePage



    Protected Sub btnBuscar_Click(sender As Object, e As System.EventArgs) Handles btnBuscar.Click
        LblError.Text = String.Empty

        divGrid.Visible = False
        If txtRNC.Text = String.Empty Then
            LblError.Visible = True
            LblError.Text = "Debe completar el RNC o Cédula"
            Exit Sub

        End If
        Me.BindDetalleEmpleado()
    End Sub


    Protected Sub BindDetalleEmpleado()
        Dim dt As New DataTable
        Try


            Dim empresa As New Empresas.Empleador(txtRNC.Text)
            If empresa.RegistroPatronal = -1 Then
                LblError.Visible = True
                LblError.Text = "Rnc invalido"
                Exit Sub
            End If


            If Not String.IsNullOrEmpty(txtCedula.Text) Then
                If Utilitarios.TSS.existeCiudadano("C", txtCedula.Text) = False Then
                    LblError.Visible = True
                    LblError.Text = "Cédula invalida"
                    Exit Sub
                End If

                Dim representante As DataTable = Empresas.Representante.getRepresentante(txtRNC.Text, txtCedula.Text)

                If representante.Rows.Count = 0 Then
                    LblError.Visible = True
                    LblError.Text = "Representante no existe"
                    Exit Sub
                End If

            End If





            dt = SuirPlus.Empresas.Consultas.get_UltimosArchivos(txtRNC.Text, txtCedula.Text)
            If dt.Rows.Count > 0 Then
                Me.gvArchivos.DataSource = dt
                Me.gvArchivos.DataBind()

                Me.lblEmpleador.Text = "<b>RNC: </b>" & dt.Rows(0)("rnc_o_cedula") & "<br/>"
                Me.lblEmpleador.Text += "<b>Razon Social : </b>" & dt.Rows(0)("razon_social") & "<br/>"

                divGrid.Visible = True
            End If

            dt = Nothing

            dt = SuirPlus.Empresas.Consultas.get_UltimosNovedades(txtRNC.Text, txtCedula.Text)
            If dt.Rows.Count > 0 Then
                Me.gvNovedades.DataSource = dt
                Me.gvNovedades.DataBind()

                divGrid.Visible = True
            End If


            dt = Nothing

            dt = SuirPlus.Empresas.Consultas.get_UltimosSubsidios(txtRNC.Text)
            If dt.Rows.Count > 0 Then
                Me.gvSubsidios.DataSource = dt
                Me.gvSubsidios.DataBind()

                divGrid.Visible = True
            End If

        Catch ex As Exception
            LblError.Visible = True
            Me.LblError.Text = ex.Message

            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub
    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load

    End Sub
    Protected Function formateaRNC_Cedula(ByVal rnc As Object) As Object

        If Not rnc Is DBNull.Value Then

            Return Utilitarios.Utils.FormatearRNCCedula(rnc.ToString)

        End If

        Return rnc

    End Function


    Protected Sub BtnLimpiar_Click(sender As Object, e As System.EventArgs) Handles BtnLimpiar.Click
        Response.Redirect("consGeneral.aspx")
    End Sub
End Class
