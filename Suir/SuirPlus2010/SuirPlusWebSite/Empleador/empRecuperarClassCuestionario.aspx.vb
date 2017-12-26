Imports SuirPlus
Imports System.Data

Partial Class Empleador_empRecuperarClassCuestionario
    Inherits BasePage

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        'If Not Page.IsPostBack Then
        '    dlCuestionario.DataSource = SuirPlus.Utilitarios.TSS.getCuestionario()
        '    dlCuestionario.DataBind()
        'End If
    End Sub

    Protected Sub btnAceptarRep_Click(sender As Object, e As System.EventArgs) Handles btnAceptarRep.Click
        Try
            ' buscamos los datos del representante
            Session.Remove("IdRegPat")
            Session.Remove("emailRepresentante")
            Session.Remove("usuarioRepresentante")
            Session.Remove("NSSRepresentante")
            lblMensaje.Text = ""
            tblInfoRepresentante.Visible = False
            Dim dt As New DataTable
            Dim rep As New SuirPlus.Empresas.Representante(txtRncCedula.Text, txtCedulaRep.Text)
            If rep.NombreCompleto <> String.Empty Then
                Session("usuarioRepresentante") = rep.UserName
                Session("emailRepresentante") = rep.Email
                Session("NSSRepresentante") = rep.IdNSS

                Dim emp As New Empresas.Empleador(rep.RegistroPatronal)
                Session("IdRegPat") = emp.RegistroPatronal
                tblInfoRepresentante.Visible = True
                lblRepresentante.Text = rep.NombreCompleto
                lblRazonSocial.Text = emp.RazonSocial
                lblNombreComercial.Text = emp.NombreComercial


                ' recargamos el cuestionario
                dt = SuirPlus.Utilitarios.TSS.getCuestionario(CInt(Session("IdRegPat")), CInt(Session("NSSRepresentante")))
                If dt.Rows.Count > 0 Then
                    pnlCuestionario.Visible = True
                    dlCuestionario.DataSource = dt
                    dlCuestionario.DataBind()
                Else
                    pnlCuestionario.Visible = False
                    dlCuestionario.DataSource = Nothing
                    dlCuestionario.DataBind()
                End If

                btnAceptarRep.Enabled = False
            Else
                btnAceptarRep.Enabled = True
                lblMensaje.Text = "Representante inválido."
                tblInfoRepresentante.Visible = False
            End If


        Catch ex As Exception
            lblMensaje.Text = ex.Message

        End Try

    End Sub

    Protected Sub btnCancelarRep_Click(sender As Object, e As System.EventArgs) Handles btnCancelarRep.Click
        Response.Redirect("empRecuperarClassCuestionario.aspx")
    End Sub

    Protected Sub dlCuestionario_ItemCommand(source As Object, e As System.Web.UI.WebControls.DataListCommandEventArgs) Handles dlCuestionario.ItemCommand
        Dim valorErr As Integer = 0
        Dim respuesta As String = String.Empty

        If e.CommandName = "A" Then
            For Each itm As DataListItem In dlCuestionario.Items()
                If itm.ItemType = ListItemType.Item OrElse itm.ItemType = ListItemType.AlternatingItem Then
                    Dim lblIdPregunta As String = CType(itm.FindControl("lblId"), Label).Text
                    Dim txtresp As String = CType(itm.FindControl("txtRespuesta"), TextBox).Text
                    Dim lnkBtnSi As LinkButton = CType(itm.FindControl("lnkBtnSi"), LinkButton)
                    Dim lnkBtnNo As LinkButton = CType(itm.FindControl("lnkBtnNo"), LinkButton)

                    'para remover acentos, espacios y caracteres especiales
                    'Dim textoOriginal = txtresp
                    'Dim textoNormalizado = textoOriginal.Normalize(NormalizationForm.FormD)
                    ''coincide todo lo que no sean letras y números ascii o espacio
                    ''y lo reemplazamos por una cadena vacía.
                    'Dim reg As Regex = New Regex("[^a-zA-Z0-9 ]")
                    'Dim textoSinAcentos = reg.Replace(textoNormalizado, "")

                    'llamamos verificamos la respuesta proporcionada por el representante para la pregunta en curso
                    respuesta = Utilitarios.TSS.getRespuestaCuestionario(CInt(Session("IdRegPat")), CInt(Session("NSSRepresentante")), CInt(lblIdPregunta), txtresp)

                    If respuesta = "TRUE" Then
                        lnkBtnSi.Visible = True
                        lnkBtnNo.Visible = False
                    Else
                        valorErr += 1
                        lnkBtnSi.Visible = False
                        lnkBtnNo.Visible = True
                    End If
                End If
            Next
            Dim BtnAceptar As Button = CType(e.Item.FindControl("btnAceptar"), Button)
            If valorErr > 0 Then
                BtnAceptar.Enabled = True
                pnlEmailRegistrado.Visible = False
            Else
                BtnAceptar.Enabled = False
                pnlEmailRegistrado.Visible = True
                txtEmailRep.Text = Session("emailRepresentante")
            End If

        End If
        If e.CommandName = "C" Then
            Response.Redirect("empRecuperarClassCuestionario.aspx")

        End If
    End Sub

    Protected Sub btnAceptarEmail_Click(sender As Object, e As System.EventArgs) Handles btnAceptarEmail.Click
        Try

            Dim resultado As String
            Dim valor As String
            lblMsg.Text = ""
            'resultado = SuirPlus.Empresas.Representante.RecuperarClassRep(Session("usuarioRepresentante"), txtEmailRep.Text, "R")
            resultado = SuirPlus.Seguridad.Usuario.RecuperarClass(Session("usuarioRepresentante"), txtEmailRep.Text, Nothing, "R")
            valor = Split(resultado, "|")(0)
            If valor = "0" Then
                lblMsg.Font.Size = FontUnit.Medium
                ' lblMsg.ForeColor = Drawing.Color.Blue
                lblMsg.CssClass = "labelData"
                lblMsg.Text = "Se le ha enviado un correo electrónico para completar el proceso de recuperación de su class, favor revisar en su correo."
            Else
                lblMsg.Text = Split(resultado, "|")(1)
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub btnCancelarEmail_Click(sender As Object, e As System.EventArgs) Handles btnCancelarEmail.Click
        Response.Redirect("empRecuperarClassCuestionario.aspx")
    End Sub

End Class

