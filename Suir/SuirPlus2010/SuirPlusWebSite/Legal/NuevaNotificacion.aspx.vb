Imports SuirPlus
Imports SuirPlus.Legal
Imports System.IO
Partial Class Legal_NuevaNotificacion
    Inherits BasePage
    Protected Property IdPatronal() As Integer
        Get
            If ViewState("regPatronal") Is Nothing Then
                Return 0
            Else
                Return ViewState("regPatronal")
            End If
        End Get
        Set(ByVal value As Integer)
            ViewState("regPatronal") = value
        End Set
    End Property
    Protected Sub btnCrear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCrear.Click

        Page.Validate()
        If Page.IsValid Then
            Try
                Dim emp As New Empresas.Empleador(Me.txtRnc.Text)
                Me.lblRNC.Text = Me.txtRnc.Text
                Me.lblRazonSocial.Text = emp.RazonSocial
                Me.lblTipoNot.Text = Me.drpTipoNot.SelectedItem.Text
                Me.IdPatronal = emp.RegistroPatronal
                Me.lblComentario.Text = Left(Me.txtComentario.Text, 200)
            Catch ex As Exception
                Me.lblMsg.Text = ex.Message
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                Exit Sub
            End Try
        End If

        Me.pnlGeneral.Visible = Not pnlGeneral.Visible
        Me.pnlConfirmacion.Visible = Not pnlConfirmacion.Visible

    End Sub
    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click

        Me.txtRnc.Text = String.Empty
        Me.drpTipoNot.SelectedValue = "-1"
        Me.txtComentario.Text = String.Empty

    End Sub
    Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGuardar.Click

        If fuDocument.PostedFile IsNot Nothing Then
            Dim contentType As String = fuDocument.PostedFile.ContentType
            If Not contentType = "image/jpeg" And _
             Not contentType = "image/pjpeg" And _
             Not contentType = "image/gif" And _
             Not contentType = "image/tiff" And _
             Not contentType = "image/bmp" Then
                Me.lblMsg.Text = "El formato del documento no es permitido."
                Exit Sub
            End If

        End If

        Try
            Dim imgContent() As System.Byte = Nothing
            If fuDocument.PostedFile IsNot Nothing Then
                imgContent = fuDocument.FileBytes()
            End If
            Notificacion.CrearNuevaNotificacion(Me.IdPatronal, CInt(Me.drpTipoNot.SelectedValue), imgContent, Me.txtComentario.Text)
        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub
        End Try

        Me.lblMsg.Text = "La notificación fue guardada satisfactoriamente."
        Me.initForm()
        Me.btnLimpiar_Click(Me, Nothing)

    End Sub
    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        initForm()
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            bindTipoNot()
        End If

    End Sub
    Protected Sub bindTipoNot()

        Me.drpTipoNot.DataSource = Notificacion.getTiposNotificaciones()
        Me.drpTipoNot.DataTextField = "Descripcion"
        Me.drpTipoNot.DataValueField = "id_tipo_notificacion"
        Me.drpTipoNot.DataBind()
        Me.drpTipoNot.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))

    End Sub
    Protected Sub initForm()
        Me.lblRNC.Text = String.Empty
        Me.lblRazonSocial.Text = String.Empty
        Me.lblTipoNot.Text = String.Empty
        Me.lblComentario.Text = String.Empty
        Me.pnlGeneral.Visible = True
        Me.pnlConfirmacion.Visible = False
    End Sub

End Class
