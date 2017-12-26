Imports System.Data
Imports SuirPlus

Partial Class Solicitudes_ConsultaARS
    Inherits BasePage

    Protected Sub btBuscarRef_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btBuscarRef.Click

        Dim Res As String = String.Empty
        Dim Nombre As String = String.Empty
        Dim ARS As String = String.Empty
        Dim Status As String = String.Empty
        Dim tipo_afiliacion As String = String.Empty
        Dim Fecha_Afiliacion As String = String.Empty
        Dim nucleo As New DataTable
        Try
            If recaptcha.IsValid Then
                recaptcha.Visible = False

                If Me.txtnodocumento.Text = String.Empty Then
                    Me.lblError.Visible = True
                    Me.lblError.Text = "La cédula es requerida"
                    Exit Sub
                Else
                    Me.lblError.Visible = False
                    Me.lblError.Text = String.Empty
                End If

                Try

                    nucleo = SuirPlus.Ars.Consultas.consultaAfilado(Me.txtnodocumento.Text, Nombre, ARS, Status, tipo_afiliacion, Fecha_Afiliacion, Res)
                    Me.lblARS.Text = ARS
                    Me.lblNombre.Text = Nombre
                    Me.lblStatus.Text = Status
                    Me.lblTipoAfiliacion.Text = tipo_afiliacion
                    If Fecha_Afiliacion <> String.Empty Then
                        Me.lblFechaAfiliacion.Text = String.Format("{0:d}", Fecha_Afiliacion)
                    End If
                    Me.pnlInfo.Visible = True
                    Me.lblError.Visible = False

                    If nucleo.Rows.Count > 0 Then
                        Me.gvNucleoFamiliar.DataSource = nucleo
                        Me.gvNucleoFamiliar.DataBind()
                        Me.pnlNucleo.Visible = True
                        Me.lblError.Visible = False
                    Else
                        Me.pnlNucleo.Visible = False
                    End If
                Catch ex As Exception
                    Me.lblError.Visible = True
                    Me.lblError.Text = Res
                    Me.pnlNucleo.Visible = False
                    Me.pnlInfo.Visible = False
                End Try
            Else
                recaptcha.Visible = True
                Throw New Exception("Caracteres de la imagen incorrectos, por favor intente de nuevo.")
                lblError.Visible = True
            End If
        Catch ex As Exception
            lblError.Text = ex.Message
            lblError.Visible = True
        End Try

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.limpiar()
    End Sub

    Private Sub limpiar()

        Me.lblARS.Text = String.Empty
        Me.lblNombre.Text = String.Empty
        Me.lblStatus.Text = String.Empty
        Me.lblError.Text = String.Empty

        Me.gvNucleoFamiliar.Visible = False
        Me.pnlInfo.Visible = False
        Response.Redirect("ConsultaARS.aspx")
    End Sub

    Protected Function formateaNSS(ByVal NSS As Integer) As String
        Return Utilitarios.Utils.FormatearNSS(NSS.ToString)
    End Function

    Protected Function formateaCedula(ByVal Cedula As String) As String

        If Cedula = String.Empty Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormatearCedula(Cedula)
        End If

    End Function

    Protected Function ValidarNull(ByVal texto As Object) As String

        If IsDBNull(texto) Then
            Return String.Empty
        Else
            Return CStr(texto)
        End If
        Return String.Empty
    End Function


End Class
