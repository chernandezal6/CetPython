Imports SuirPlus.Empresas
Partial Class Empleador_empNominas
    Inherits BasePage


    Private Estatus As Modo

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Page.IsPostBack Then
            Me.Estatus = ViewState().Item("Modo")

        End If

        Me.lblMensajeDeError.Text = ""
        Me.lblMensajeDeError.Visible = True

        If Not IsPostBack Then
            CargarTipoNominas()
            Me.CargaInicial()
        End If

        If SuirPlus.Empresas.Archivo.isEmpleadorEnLegal(UsrRNC) = True Then
            lblMensajeDeError.Text = SuirPlus.Utilitarios.TSS.getErrorDescripcion("241")
            btnNuevoRep.Enabled = False

        End If
        'For Each i As System.Web.UI.WebControls.DataGridItem In Me.dgNominas.Items
        '    CType(i.FindControl("iBtnBorrar"), ImageButton).Attributes.Add("onClick", "return confirm('Esta seguro que desea eliminar esta nómina?');")
        'Next
    End Sub

    Protected Sub CargarTipoNominas()

        Try
            Dim dt As Data.DataTable = Nomina.getTipoNomina()
            Me.ddlTipoNomina.DataSource = dt
            Me.ddlTipoNomina.DataTextField = "Descripcion"
            Me.ddlTipoNomina.DataValueField = "id_tipo_nomina"
            Me.ddlTipoNomina.DataBind()
            Me.ddlTipoNomina.Items.Add(New WebControls.ListItem("<--Seleccione-->", "-1"))
            Me.ddlTipoNomina.SelectedValue = "-1"
        Catch ex As Exception
            Response.Write(ex.ToString)
        End Try



    End Sub
    Private Sub CargaInicial()
        Me.llenarDataGridNominas()
    End Sub

    Private Sub llenarDataGridNominas()

        Me.dgNominas.DataSource = Nomina.getNomina(Me.UsrRegistroPatronal, -1)
        Me.dgNominas.DataBind()

    End Sub

    Private Sub btnNuevoRep_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNuevoRep.Click

        Me.Estatus = Modo.Nuevo
        ViewState().Add("Modo", Me.Estatus)
        Me.MostrarAbajo()

    End Sub

    Private Sub MostrarArriba()

        Me.pnlDetalle.Visible = False
        Me.pnlListado.Visible = True

        Me.llenarDataGridNominas()

    End Sub

    Private Sub MostrarAbajo()

        Me.pnlDetalle.Visible = True
        Me.pnlListado.Visible = False

        Me.txtDescripcion.Text = ""
        Me.ddlTipoNomina.SelectedValue = "-1"

    End Sub

    Private Function EditarNomina(ByVal IDNomina As Int32) As String

        Dim nomina As New Nomina(Me.UsrRegistroPatronal, IDNomina)

        nomina.NominaDes = Me.txtDescripcion.Text
        nomina.TipoNomina = Me.ddlTipoNomina.SelectedValue

        Return nomina.GuardarCambios(Me.UsrUserName)

    End Function

    Private Sub prepararEditarNomina()
        Me.Estatus = Modo.Edicion

        ViewState().Add("Modo", Me.Estatus)

        Me.MostrarAbajo()

        Dim nomina As New Nomina(Me.UsrRegistroPatronal, ViewState().Item("IDNomina"))
        Me.txtDescripcion.Text = nomina.NominaDes
        Me.ddlTipoNomina.SelectedValue = nomina.TipoNomina

    End Sub

    Private Sub BorrarNomina(ByVal IDNomina As Int32)

        Dim tmpRet As String = Nomina.borraNomina(Me.UsrRegistroPatronal, IDNomina, Me.UsrUserName)

        If Split(tmpRet, "|")(0) <> "0" Then
            Me.lblMensajeDeError.Text = Split(tmpRet, "|")(1)
            Me.lblMensajeDeError.ForeColor = Drawing.Color.Red
        End If

        Me.MostrarArriba()

    End Sub

    Private Sub Button3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Me.MostrarArriba()
    End Sub

    Private Sub btnAceptar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar.Click
        If ddlTipoNomina.SelectedValue <> "-1" Then
            Dim Resultado As String = ""
            If Me.Estatus = Modo.Nuevo Then

                Resultado = Nomina.insertaNomina(Me.UsrRegistroPatronal, Me.txtDescripcion.Text, "A", Me.ddlTipoNomina.SelectedValue, Me.UsrUserName)
                If Resultado = "0" Then
                    Me.MostrarArriba()
                Else
                    Me.lblMensajeDeError.Text = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(Resultado)
                    Me.lblMensajeDeError.Visible = True
                End If

            ElseIf Me.Estatus = Modo.Edicion Then

                Resultado = Me.EditarNomina(ViewState().Item("IDNomina"))

            End If

            If Resultado = "0" Then
                Me.MostrarArriba()
            Else
                Me.lblMensajeDeError.Text = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(Resultado)
                Me.lblMensajeDeError.Visible = True
            End If
        Else
            Me.lblMensajeDeError.Text = "Debe seleccionar un tipo de nomina."
            Me.lblMensajeDeError.Visible = True
        End If


    End Sub

    'Public Function getTipoNom(ByVal codigoTipo As String) As String
    '    Return IIf(codigoTipo = "N", "Normal", IIf(codigoTipo = "P", "Pensionados", IIf(codigoTipo = "D", "Discapacitados", "Contratados")))
    'End Function

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        MostrarArriba()
    End Sub

    Protected Sub dgNominas_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgNominas.RowCommand

        Dim IDNomina As Int32 = e.CommandArgument.ToString()

        ViewState().Add("IDNomina", IDNomina)

        Select Case e.CommandName
            Case "Editar"
                Me.prepararEditarNomina()
            Case "Borrar"
                Me.BorrarNomina(IDNomina)
        End Select

    End Sub

    Protected Sub dgNominas_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgNominas.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then

            If CType(e.Row.FindControl("lblID"), Label).Text = "1" Then

                CType(e.Row.FindControl("iBtnBorrar"), ImageButton).Visible = False

            End If

        End If

    End Sub
End Class

