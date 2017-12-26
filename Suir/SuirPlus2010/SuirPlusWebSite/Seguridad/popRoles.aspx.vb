Imports SuirPlus
Partial Class Seguridad_popRoles
    Inherits System.Web.UI.Page

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not Page.IsPostBack Then
            Me.lblIDPermiso.Text = Request("IDPermiso")
            Me.lblUserName.Text = Request("UserName")
            Me.lblUsrResponsable.Text = Request("UsuarioResponsable")
            Me.CargaInicial()
        End If

    End Sub

    Private Sub CargaInicial()

        If (Me.lblUserName.Text = "") And (Me.lblIDPermiso.Text = "") Then
            Exit Sub
        End If

        If (Me.lblIDPermiso.Text = "") Then
            ' Es un Usuario

            Dim dt As System.Data.DataTable = SuirPlus.Seguridad.Role.getRolesNoTieneUsuario(Me.lblUserName.Text)
            Dim usr As New Seguridad.Usuario(Me.lblUsrResponsable.Text)

            Dim aut As New Seguridad.Autorizacion(Me.lblUsrResponsable.Text)
            usr.Roles = aut.getRoles.Split("|")

            ' Roles de los Bancos
            If usr.IsInRole(56) Then

                Dim dtRS As System.Data.DataRow() = dt.Select("tipo_role = 'B'")

                Dim dt2 As System.Data.DataTable = dt.Clone
                Dim dtR As System.Data.DataRow

                For Each dtR In dtRS
                    dt2.ImportRow(dtR)
                Next

                dt = dt2
            Else
                dt = dt
            End If

            ' Roles de la DGII
            If usr.IsInRole(46) Then
                Dim dtRS As System.Data.DataRow() = dt.Select("tipo_role = 'D'")

                Dim dt2 As System.Data.DataTable = dt.Clone
                Dim dtR As System.Data.DataRow

                For Each dtR In dtRS
                    dt2.ImportRow(dtR)
                Next

                dt = dt2
            Else
                dt = dt
            End If

            ' Roles del CCG
            If usr.IsInRole(235) Then
                Dim dtRS As System.Data.DataRow() = dt.Select("tipo_role = 'C'")

                Dim dt2 As System.Data.DataTable = dt.Clone
                Dim dtR As System.Data.DataRow

                For Each dtR In dtRS
                    dt2.ImportRow(dtR)
                Next

                dt = dt2
            Else
                dt = dt
            End If


            ' Roles del AFP
            If usr.IsInRole(699) Then
                Dim dtRS As System.Data.DataRow() = dt.Select("tipo_role = 'A'")

                Dim dt2 As System.Data.DataTable = dt.Clone
                Dim dtR As System.Data.DataRow

                For Each dtR In dtRS
                    dt2.ImportRow(dtR)
                Next

                dt = dt2
            Else
                dt = dt
            End If


            ' Roles de la DIDA
            If usr.IsInRole(135) Then
                Dim dtRS As System.Data.DataRow() = dt.Select("tipo_role = 'I'")

                Dim dt2 As System.Data.DataTable = dt.Clone
                Dim dtR As System.Data.DataRow

                For Each dtR In dtRS
                    dt2.ImportRow(dtR)
                Next

                dt = dt2
            Else
                dt = dt
            End If



            Me.dgRoles.DataSource = dt
            Me.dgRoles.DataBind()

        ElseIf (Me.lblUserName.Text = "") Then

            ' Es un Permiso
            Me.dgRoles.DataSource = SuirPlus.Seguridad.Role.getRolesNoTienePermiso(Me.lblIDPermiso.Text)
            Me.dgRoles.DataBind()

        End If

    End Sub

    Private Function AgregarRole(ByVal IDRole As Int32) As String

        If (Me.lblUserName.Text = "") And (Me.lblIDPermiso.Text = "") Then
            Return String.Empty
        End If

        Dim Resultado As String = String.Empty

        If (Me.lblIDPermiso.Text = "") Then

            ' Es un Usuario
            Dim Usr As New Seguridad.Usuario(Me.lblUserName.Text)
            Resultado = Usr.AgregarRole(IDRole, Me.lblUsrResponsable.Text)

            If Resultado <> "0" Then
                Return Me.lblUserName.Text & " | " & Resultado
            End If

        ElseIf (Me.lblUserName.Text = "") Then

            ' Es un Permiso
            Dim Per As New Seguridad.Permiso(Me.lblIDPermiso.Text)
            Resultado = Per.AgregarRole(IDRole, Me.lblUsrResponsable.Text)

            If Resultado <> "0" Then
                Return Resultado
            End If

        End If

        Return Resultado

    End Function

    Private Sub btAgregar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btAgregar.Click

        Dim dgItem As GridViewRow

        For Each dgItem In Me.dgRoles.Rows

            Dim chkBox As CheckBox = CType(dgItem.Cells(0).Controls(1), System.Web.UI.WebControls.CheckBox)

            If chkBox.Checked Then
                Dim lbl As Label = CType(dgItem.FindControl("lblID"), Label)
                Dim Resultado As String = Me.AgregarRole(lbl.Text)

                If Resultado <> "0" Then
                    Me.lblMensajeError.Text = Resultado
                    Me.lblMensajeError.Visible = True
                    Exit Sub
                End If

            End If

        Next

        Me.CargaInicial()

    End Sub

    Private Sub btCerrar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btCerrar.Click
        Me.ClientScript.RegisterStartupScript(Me.GetType, "_cerrar", "<script language='javascript'> window.close();</script>")
    End Sub

End Class
