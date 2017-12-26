Imports SuirPlus
Imports System.Data
Imports SuirPlus.Utilitarios
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.SubsidiosSFS
Imports SuirPlus.Empresas.SubsidiosSFS.Maternidad

Partial Class Novedades_sfsCambioCuentaMadre
    Inherits BasePage
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Session("nss") = Nothing Then
            Me.txtCedulaNSS.Text = Session("nss")
            Me.btnConsultar_Click(Nothing, Nothing)
            Session("nss") = Nothing
        End If

        Me.txtCedulaNSS.Focus()
    End Sub

#Region "Variables"
    Protected empleado As Trabajador
    Protected madre As Maternidad

    Private Property idCiudadano() As String
        Get
            Return CType(ViewState("idCiudadano"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("idCiudadano") = Value
        End Set
    End Property
#End Region


    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Dim Nss As String = String.Empty
        Dim CedulaM As String = String.Empty
        Me.idCiudadano = txtCedulaNSS.Text
        Try
            Dim mensaje As String = ValidarConsultaNovedades(txtCedulaNSS.Text, UsrRegistroPatronal)

            If mensaje.Equals("OK") Then
                lblMsg.Text = String.Empty
                Me.divConsulta.Visible = True

                If idCiudadano.Length < 11 Then
                    empleado = New Trabajador(Convert.ToInt32(idCiudadano))
                    Nss = idCiudadano
                    CedulaM = empleado.Documento
                    ViewState("Empresa") = empleado.RegistroPatronal
                ElseIf idCiudadano.Length = 11 Then
                    empleado = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, idCiudadano)
                    CedulaM = idCiudadano
                    Nss = empleado.NSS
                    ViewState("Empresa") = empleado.RegistroPatronal
                End If

                If idCiudadano.Length < 11 Then
                    madre = New Maternidad(Convert.ToInt32(idCiudadano))
                ElseIf idCiudadano.Length = 11 Then
                    madre = New Maternidad(idCiudadano)
                End If

                Me.txtCedulaNSS.ReadOnly = True
                ucInfoEmpleado1.Visible = True
                ucInfoEmpleado1.NombreEmpleado = String.Concat(empleado.Nombres, " ", empleado.PrimerApellido, " ", empleado.SegundoApellido)
                ucInfoEmpleado1.NSS = empleado.NSS.ToString
                ucInfoEmpleado1.Cedula = empleado.Documento
                ucInfoEmpleado1.Sexo = empleado.Sexo
                ucInfoEmpleado1.FechaNacimiento = empleado.FechaNacimiento
                ucInfoEmpleado1.SexoEmpleado = "Empleada"
                Me.UpdatePanel1.Visible = True

                Dim dtNovedades As New DataTable
                dtNovedades = Empresas.SubsidiosSFS.Maternidad.getNovedades(CedulaM, Nss, Convert.ToInt32(UsrRegistroPatronal))

                If Not dtNovedades Is Nothing Then
                    If dtNovedades.Rows.Count > 0 Then

                        Me.gvNovedades.DataSource = dtNovedades
                        Me.gvNovedades.DataBind()
                        Me.gvNovedades.Visible = True
                        Me.lblMsg.Visible = False
                    Else
                        Me.gvNovedades.Visible = False
                        Me.lblMsg.Visible = True
                        Me.lblMsg.Text = "No hay Novedades que mostrar"
                    End If
                Else
                    Me.gvNovedades.Visible = False
                    Me.lblMsg.Visible = True
                    Me.lblMsg.Text = "No hay Novedades que mostrar"
                End If



            Else
                lblMsg1.Text = mensaje
                Me.lblMsg1.Visible = True
            End If

        Catch ex As Exception
            Me.lblMsg1.Visible = True
            Me.lblMsg1.Text = ex.Message
            Me.divConsulta.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Limpiar()
    End Sub

    Protected Sub Limpiar()
        Me.divConsulta.Visible = False
        txtCedulaNSS.Text = ""
        Me.gvNovedades.Visible = False
        Me.txtCedulaNSS.Focus()
        Me.lblMsg1.Visible = False
        lblMsg.Text = String.Empty
    End Sub

    Protected Sub gvNovedades_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvNovedades.RowCommand

        Dim nss As String = Split(e.CommandArgument, "|")(0)
        Dim novedad As String = Split(e.CommandArgument, "|")(1)

        If e.CommandName = "Cambiar" Then
            Session("idNss") = nss
            Session("TipoNovedad") = novedad

            Response.Redirect("sfsCambioNovedad.aspx")
        Else

            If e.CommandName = "Eliminar" Then
                Session("idNss") = nss
                Session("TipoNovedad") = novedad

                Response.Redirect("sfsBajaNovedad.aspx")
            End If

        End If

    End Sub

    Protected Sub gvNovedades_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNovedades.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then

            If e.Row.RowIndex = 0 Then

                Dim isModificable As String = CType(e.Row.FindControl("lblModifica"), Label).Text

                If isModificable = "S" Then
                    e.Row.Cells(2).Visible = True
                    lblMsg2.Visible = False
                Else
                    e.Row.Cells(2).Visible = False
                    lblMsg2.Visible = True
                End If

            Else
                e.Row.Cells(2).Visible = False

            End If

        End If


    End Sub


End Class
