Imports System.Data
Imports SuirPlus

Partial Class ImpEnfermedadComun
    Inherits BasePage

    Protected Sub btBuscarRef_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btBuscarRef.Click

        Try
            'If recaptcha.IsValid Then
            '    recaptcha.Visible = False

            Dim dt As New DataTable

            If Not String.IsNullOrEmpty(txtnodocumento.Text) And Not String.IsNullOrEmpty(txtPin.Text) Then

                dt = Empresas.SubsidiosSFS.EnfermedadComun.GetReImpresionEnfComun(txtnodocumento.Text, txtPin.Text)

                If dt.Rows.Count > 0 Then

                    ''definimos los valores para la reimpresion del formulario de enfermedad comun

                    hfNumeroFormulario.Value = dt.Rows(0)("NROFORMULARIO").ToString()
                    hfnombre.Value = dt.Rows(0)("NOMBRE_AFILIADO").ToString()
                    hfcedula.Value = dt.Rows(0)("CEDULA").ToString()
                    hfnss.Value = dt.Rows(0)("ID_NSS").ToString()
                    hfsexo.Value = dt.Rows(0)("SEXO").ToString()
                    Dim secuencia As String = dt.Rows(0)("SECUENCIA").ToString()

                    If secuencia = "1" Then
                        hftipoSolicitud.Value = "Nueva"
                    Else
                        hftipoSolicitud.Value = "Renovacion"
                    End If
                    hfhash.Value = Empresas.SubsidiosSFS.EnfermedadComun.hashValores(hfNumeroFormulario.Value, hfcedula.Value)
                    hfNumeroFormulario.Value = Empresas.SubsidiosSFS.EnfermedadComun.hashValores(hfNumeroFormulario.Value, String.Empty)
                Else
                    '    recaptcha.Visible = True
                    lblError.Text = "No existen registros para esta busqueda!!."
                    lblError.Visible = True
                End If
            Else
                'recaptcha.Visible = True
                Throw New Exception("Los parametros son requeridos.")
            End If

            Me.txtnodocumento.Enabled = False
            Me.txtPin.Enabled = False
            Me.btBuscarRef.Enabled = False
            'Else
            '    recaptcha.Visible = True
            '    Throw New Exception("Caracteres de la imagen incorrectos, por favor intente de nuevo.")
            lblError.Visible = True

        Catch ex As Exception
            lblError.Text = ex.Message
            lblError.Visible = True
        End Try

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.limpiar()
    End Sub

    Private Sub limpiar()
        Response.Redirect("ImpEnfermedadComun.aspx")
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
