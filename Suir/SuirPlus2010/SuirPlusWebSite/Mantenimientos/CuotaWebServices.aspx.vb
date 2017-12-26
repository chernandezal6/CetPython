Imports SuirPlus

Partial Class Mantenimientos_CuotaWebServices
    Inherits BasePage

    Public ReadOnly Property UserNameCuota() As String
        Get
            Return HttpContext.Current.Session("UserNameCuota")
        End Get
    End Property


    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            CargarServicios()
            GridView()
            LimpiarCampos()
        End If
    End Sub

    Public Sub CargarServicios()

        ddlServicioWeb.DataSource = SuirPlus.Seguridad.Permiso.GetServicios_Cuotas()
        ddlServicioWeb.DataTextField = "permiso_des"
        ddlServicioWeb.DataValueField = "id_permiso"
        ddlServicioWeb.DataBind()
        ddlServicioWeb.Items.Add(New ListItem("<--Seleccione-->", "-1"))
        Me.ddlServicioWeb.SelectedValue = "-1"
    End Sub

    Protected Sub ImgBuscar_Click(sender As Object, e As ImageClickEventArgs)
        lblMsg.Visible = False

        If txtSrchUserName.Text <> String.Empty Then
            Dim Usuario = SuirPlus.Seguridad.Usuario.getUsuarios(txtSrchUserName.Text, "", "")
            If Usuario.Rows.Count > 0 Then
                lblNombreUsuario.Text = Usuario.Rows(0).Item("NOMBRE").ToString()
                HttpContext.Current.Session("UserNameCuota") = Usuario.Rows(0).Item("ID_USUARIO").ToString()
                txtSrchUserName.Enabled = False
                ddlServicioWeb.Enabled = True
                txtCuota.Enabled = True
            Else
                lblNombreUsuario.Text = "La búsqueda realizada no ha devuelto ningún resultado"
                lblNombreUsuario.CssClass = "error"
                Return
            End If

        Else
            lblMsg.Text = "Debe indicar un Nombre de Usuario para realizar la búsqueda"
            lblMsg.Visible = True
            Return
        End If
    End Sub
    Protected Sub btnAceptar_Click(sender As Object, e As EventArgs)
        Try
            lblMsg.Visible = True
            lblMsg.CssClass = "error"
            If txtSrchUserName.Text = String.Empty Then
                lblMsg.Text = "Debe indicar un nombre de usuario"
                Return
            End If

            If UserNameCuota = Nothing Then
                lblMsg.Text = "Debe validar con la lupa el nombre de usuario"
                Return
            End If

            If ddlServicioWeb.SelectedValue = "-1" Then
                lblMsg.Text = "Debe seleccionar un servicio valido"
                Return
            End If

            If txtCuota.Text = String.Empty Then
                lblMsg.Text = "El campo cuota es requerido"
                Return
            End If

            Dim Usuario = txtSrchUserName.Text.ToUpper()
            Dim Resultado = SuirPlus.Seguridad.Permiso.InsertCuota(ddlServicioWeb.SelectedValue, Usuario, txtCuota.Text, UsrUserName)

            If Resultado = "OK" Then
                lblMsg.Text = "La Cuota fue agregada al servicio"
                lblMsg.CssClass = "label-Blue"
                LimpiarCampos()
            Else
                lblMsg.Text = Resultado
            End If

        Catch ex As Exception
            lblMsg.Text = ex.Message
            Return
        End Try



    End Sub
    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
        Response.Redirect("CuotaWebServices.aspx")
    End Sub

    Public Sub LimpiarCampos()
        txtCuota.Text = String.Empty
        txtCuota.Enabled = False
        txtSrchUserName.Text = String.Empty
        txtSrchUserName.Enabled = True
        lblNombreUsuario.Text = String.Empty
        ddlServicioWeb.SelectedValue = "-1"
        ddlServicioWeb.Enabled = False
        HttpContext.Current.Session("UserNameCuota") = String.Empty
        GridView()
    End Sub
    Public Sub GridView()
        gvListado.DataSource = SuirPlus.Seguridad.Permiso.DataServiciosCuotas()
        gvListado.DataBind()

    End Sub
    Protected Sub gvListado_RowCommand(sender As Object, e As GridViewCommandEventArgs)

        lblMsg.Visible = True

        If e.CommandName = "Remover" Then
            Dim Servicio As Int32
            Dim Usuario As String

            Dim Permiso = Split(e.CommandArgument, "|")(0)
            Usuario = Split(e.CommandArgument, "|")(1)

            Dim DireccionElectronica = SuirPlus.Seguridad.Permiso.getPermisos(Permiso).Rows(0).Item("DIRECCION_ELECTRONICA")

            Servicio = SuirPlus.Seguridad.Permiso.BuscarIdPermisoPorDireccionURL(DireccionElectronica)
            Try

                Dim Resultado = SuirPlus.Seguridad.Permiso.BorrarCuota(Servicio, Usuario)
                LimpiarCampos()
                lblMsg.Text = "La cuota fue removida"


            Catch ex As Exception
                lblMsg.Text = ex.Message
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

        End If

    End Sub
End Class
