Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios

Partial Class Consultas_consDepAdicionalesTrab
    Inherits BasePage

    Private Sub btnBuscarRef_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBuscarRef.Click

        Dim dt As DataTable

        If Me.txtDocumento.Text = String.Empty Then
            Me.LblError.Text = "Favor especificar Cédula o NSS"
            Exit Sub
        End If

        'Si el tipo de consulta se va a realizar via cédula
        If Me.drpTipoConsulta.SelectedValue = "C" Then
            dt = Utilitarios.TSS.getConsultaNss(Me.txtDocumento.Text, Nothing, Nothing, Nothing, Nothing, 1, 15)
            Me.bindGridTitular(dt)

        Else
            'Aqui se le agregan ceros a la izquierda siempre y cuando sea los digitos menor que 9 para el NSS
            If Trim(Me.txtDocumento.Text.Length) <> 9 Then
                'Me.txtNSS = String.Format("{0:000000000}", Convert.ToInt32(Me.txtNSS.Text))
                Me.txtDocumento.Text.Trim.PadLeft(9, "0")
            End If
            'Si el tipo de consulta se va a rezalizar via NSS
            dt = Utilitarios.TSS.getConsultaNss(Nothing, Me.txtDocumento.Text, Nothing, Nothing, Nothing, 1, 15)
            Me.bindGridTitular(dt)
        End If

    End Sub

    Private Sub bindGridTitular(ByVal dt As DataTable)

        If dt.Rows.Count > 0 Then
            Me.gvTrabajador.DataSource = dt
            Me.gvTrabajador.DataBind()
            Me.lblTitulo.Visible = True
            Dim nss As Integer = CInt(dt.Rows(0)(2))
            showDependientes(nss)
        Else
            Me.LblError.Text = "No se encontró registro."
            Me.gvTrabajador.DataSource = Nothing
            Me.lblTitulo.Visible = False
            Me.gvTrabajador.DataBind()
        End If
    End Sub

    Private Sub showDependientes(ByVal nss As Integer)
        Me.ucDep.setNSS = nss
        Me.ucDep.bindControl()
        Me.ucDep.Visible = True
    End Sub

    Private Sub btnLimpiar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("consDepAdicionalesTrab.aspx")
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Me.drpTipoConsulta.SelectedValue = "C" Then
            Me.txtDocumento.MaxLength = 11
        Else
            Me.txtDocumento.MaxLength = 9
        End If
    End Sub
End Class
