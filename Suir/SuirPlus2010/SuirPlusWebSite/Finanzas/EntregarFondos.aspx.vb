Imports SuirPlus
Imports System.Data
Imports SuirPlus.Finanzas

Partial Class Finanzas_EntregarFondos
    Inherits BasePage

    Dim NroReclamacion As String = String.Empty
    Dim ciudadanoVaido As String = String.Empty
    Dim tipoDoc As String = String.Empty

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then

            If Request.QueryString.Item("rec") <> String.Empty Then
                NroReclamacion = Request.QueryString.Item("rec")
                Session("NroReclamacion") = NroReclamacion
                Me.pnlEntregarFondos.Visible = True
                Me.pnlConfirmacion.Visible = False
            Else
                Me.pnlEntregarFondos.Visible = True
                Me.pnlConfirmacion.Visible = False
                Me.lblMensaje.Text = ("Error en el Nro. de reclamación.")
                Exit Sub
                Me.pnlEntregarFondos.Visible = False
                Me.pnlConfirmacion.Visible = True
            End If

        End If


    End Sub

    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click
        If Me.txtCheque.Text = String.Empty And Me.txtDocumeto.Text = String.Empty Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ("Los parametros son requeridos.")
            Exit Sub
        End If

        'If (Me.txtDocumeto.Text.Trim.Length <> 11) And (Me.txtDocumeto.Text.Trim.Length <> 25) Then
        '    Me.lblMensaje.Visible = True
        '    Me.lblMensaje.Text = ("Nro. de Documento inválido.")
        '    Exit Sub
        'End If

        Try
            If Me.txtDocumeto.Text.Trim.Length = 11 Then
                tipoDoc = "C"
            Else
                tipoDoc = "P"
            End If

            ciudadanoVaido = DevolucionAportes.ValidaCiudadano(Me.txtDocumeto.Text, tipoDoc)

            If ciudadanoVaido = "0" Then
                'Actualizamos la tabla dva_registros con la informacion para la entrega de fondos pasando la cedula de la persona que recibe el cheque.
                'marcamos como completado el estatus del regristro en cuestion en la tabla dva_registros

                EntregarFondos(Session("NroReclamacion"), tipoDoc, Me.txtDocumeto.Text, Me.txtCheque.Text, "CP")
                Me.pnlEntregarFondos.Visible = False
                Me.pnlConfirmacion.Visible = True
            Else
                Me.pnlEntregarFondos.Visible = True
                Me.pnlConfirmacion.Visible = False
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = ciudadanoVaido.Split("|")(1)
                Exit Sub
            End If
        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
        End Try

    End Sub

    Protected Sub EntregarFondos(ByVal reclamacion As String, ByVal tipoDoc As String, ByVal NroDocumento As String, ByVal NroCheque As String, ByVal status As String)
        Try
            Dim usuario_nombreCompleto = String.Empty
            If UsrUserName <> String.Empty Then
                usuario_nombreCompleto = UsrUserName + "|" + UsrNombreCompleto
            End If

            DevolucionAportes.EntregarFondos(reclamacion, tipoDoc, NroDocumento, NroCheque, status, usuario_nombreCompleto)
        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
        End Try
    End Sub

    Protected Sub btnConfirmar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConfirmar.Click
        'CloseWindow()
        'CerrarPopup(Session("NroReclamacion"))
        Response.Redirect("~/finanzas/DetDevolucionAportes.aspx?rec=" & Session("NroReclamacion"))

    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        'CloseWindow()
        'CerrarPopup(Session("NroReclamacion"))
        Response.Redirect("~/finanzas/DetDevolucionAportes.aspx?rec=" & Session("NroReclamacion"))
    End Sub


    'Private Sub CerrarPopup(ByVal Nroreclamacion As String)

    '    Dim popupScript As String = "<script language='javascript'>" & _
    '      "window.close('~/finanzas/DevolucionAportes.aspx?rec=" + Nroreclamacion + "', 'CustomPopUp', " & _
    '      "'width=400, height=450, menubar=no, resizable=no')" & _
    '      "</script>"

    '    ClientScript.RegisterStartupScript(Me.GetType(), "popup", popupScript)


    'End Sub

    'Private Sub CloseWindow()
    '    Dim sb As New StringBuilder()
    '    sb.Append("window.opener.document.forms[0].submit();")
    '    sb.Append("window.close();")

    '    ClientScript.RegisterClientScriptBlock(Me.[GetType](), "CloseWindowScript", sb.ToString(), True)
    'End Sub


End Class
