Imports SuirPlus
Imports System.Data

Partial Class AsignacionCartera
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadCarteras()
            LoadUsuarios()
            LoadCarterasAsignadas()
        End If
    End Sub

    Private Sub LoadCarteras()
        Dim dt As New DataTable

        Dim tipo As String = String.Empty
        If Seguridad.Autorizacion.isInRol(UsrUserName, "318") Then tipo = "C"
        If Seguridad.Autorizacion.isInRol(UsrUserName, "298") Then tipo = "L"


        dt = Legal.Cobro.getCarteras(tipo, "P")

        If dt.Rows.Count > 0 Then
            ddlCartera.DataSource = dt
            ddlCartera.DataTextField = "ID_CARTERA"
            ddlCartera.DataValueField = "ID_CARTERA"
            ddlCartera.DataBind()
            ddlCartera.Items.Insert(0, New ListItem("Seleccione", "0"))
        End If
    End Sub

    Private Sub LoadUsuarios()
        Dim dt As New DataTable

        Dim tipo As Integer = 0
        If Seguridad.Autorizacion.isInRol(UsrUserName, "318") Then tipo = 232
        If Seguridad.Autorizacion.isInRol(UsrUserName, "298") Then tipo = 213

        Dim rol As New Seguridad.Role(tipo)

        dt = rol.getUsuariosTienenRole()

        If dt.Rows.Count > 0 Then
            ddlUsuario.DataSource = dt
            ddlUsuario.DataTextField = "nombre"
            ddlUsuario.DataValueField = "id_usuario"
            ddlUsuario.DataBind()
            ddlUsuario.Items.Insert(0, New ListItem("Seleccione", "0"))
        End If

    End Sub


    Private Sub LoadCarterasAsignadas()
        Dim dt As New DataTable

        dt = Legal.Cobro.getCarterasAsignadas("P")

        If dt.Rows.Count > 0 Then
            gvCarteras.DataSource = dt
            gvCarteras.DataBind()
        End If
    End Sub

    Protected Sub Button2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button2.Click
        Try
            Dim resultado As String = Legal.Cobro.Asigna_Cartera(ddlCartera.SelectedValue, ddlUsuario.SelectedValue)

            If resultado = "0" Then
                lblMensaje.Text = "Registro Asignado correctamente!!"
                LoadCarterasAsignadas()
            Else
                lblMensaje.Text = resultado
            End If
        Catch ex As Exception
            lblMensaje.Text = ex.Message
        End Try
        
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        Response.Redirect("AsignacionCartera.aspx")
    End Sub

    Protected Sub gvCarteras_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvCarteras.RowCommand
        If e.CommandName = "Deasignar" Then
            Dim vec() As String = e.CommandArgument.ToString.Split("|")

            Dim IDUsuario As String = vec(0)
            Dim IDCarteras As Integer = vec(1)

            Try
                Dim resultado As String = Legal.Cobro.DeAsignaCartera(IDCarteras, IDUsuario)

                If resultado = "0" Then
                    lblMensaje.Text = "Registro DeAsignado correctamente"
                    LoadCarterasAsignadas()
                Else
                    lblMensaje.Text = resultado
                End If
            Catch ex As Exception
                lblMensaje.Text = ex.Message
            End Try

        End If
    End Sub
End Class
