Imports SuirPlus
Imports SuirPlus.Empresas
Imports System.Data

Partial Class Empleador_empRepresentantes
    Inherits BasePage

    Private Estatus As Modo

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        If Not Page.IsPostBack Then
            Me.CargaInicial()
            Me.ucRepTelefono1.Separador = ""
            Me.ucRepTelefono2.Separador = ""
        End If

        If Page.IsPostBack Then
            Me.Estatus = Session("Modo")
        End If

        Me.lblMensajeDeError.Visible = True
        Me.lblMensajeDeError.Text = ""
        Me.lblMensajeDeError.ForeColor = Drawing.Color.Red

        Me.lblRepMsg.Text = ""

        'Apagando panel de info temporal de representantes ingresados
        Me.pnlTmpRep.Visible = False

        Me.ucRepresentante.ShowPasaporte = False

    End Sub

    Private Sub CargaInicial()
        Me.llenarDataGridRepresentantes()
    End Sub

    Private Sub llenarDataGridRepresentantes()

        Dim dtrep As New DataTable
        dtrep = Representante.getRepresentante(-1, CType(Me.UsrRegistroPatronal, Int32))
        If dtrep.Rows.Count > 0 Then
            Me.dgRepresentantes.DataSource = dtrep
            Me.dgRepresentantes.DataBind()
        Else
            Me.lblRepMsg.Text = "error al cargar los representantes"
            Return
        End If


    End Sub

    Private Sub btnNuevoRep_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNuevoRep.Click

        Me.Estatus = Modo.Nuevo
        Session("Modo") = Me.Estatus
        Me.MostrarAbajo()

    End Sub

    Private Sub MostrarAbajo()

        Me.pnlDetalle.Visible = True
        Me.pnlListado.Visible = False

        If Me.Estatus = BasePage.Modo.Nuevo Then
            Me.pnlNuevaInfoGeneral.Visible = True
            Me.pnlInfoGeneral.Visible = False
            Me.ucRepresentante.iniForm()
        Else
            Me.pnlNuevaInfoGeneral.Visible = True
            Me.pnlInfoGeneral.Visible = False
        End If

        Me.ucRepTelefono1.PhoneNumber = ""
        Me.ucRepTelefono2.PhoneNumber = ""
        Me.txtRepExt1.Text = ""
        Me.txtRepExt2.Text = ""
        Me.txtRepEmail.Text = ""
        Me.chkboxNotificacionMail.Checked = False
        Me.mostrarNominas()

    End Sub

    Private Sub mostrarNominas()
        Dim dtnom As New DataTable
        dtnom = Nomina.getNomina(Me.UsrRegistroPatronal, -1)
        If dtnom.Rows.Count > 0 Then
            Me.dgNominas.DataSource = dtnom
            Me.dgNominas.DataBind()
        Else
            Me.lblRepMsg.Text = "error al cargar las nóminas"
            Return
        End If

    End Sub

    Public Sub mostrarArriba()
        Me.pnlDetalle.Visible = False
        Me.pnlListado.Visible = True

        Me.llenarDataGridRepresentantes()
    End Sub

    Public Function getTipoNom(ByVal codigoTipo As String) As String
        Return IIf(codigoTipo = "N", "Normal", IIf(codigoTipo = "P", "Pensionados", "Contratados"))
    End Function

    Private Sub Button3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Me.pnlDetalle.Visible = False
        Me.pnlListado.Visible = True
    End Sub

    Private Sub btnAceptar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        'Validando el telefono 1 como obligatoria
        If Me.ucRepTelefono1.PhoneNumber.Trim = "" Then
            Me.lblMensajeDeError.Text = "Debe introducir el telefono 1 válido."
            Me.lblMensajeDeError.ForeColor = Drawing.Color.Red
            Return
        End If

        'Validando el email como obligatoria
        If txtRepEmail.Text.Trim = "" Then
            Me.lblMensajeDeError.Text = "El email del representante es requerido."
            Me.lblMensajeDeError.ForeColor = Drawing.Color.Red
            Return
        End If

        If Me.Estatus = Modo.Nuevo Then
            Try
                If Not Me.ucRepresentante.getNSS = "" Then
                    If marcoAcceso() Then
                        'Validando que si quieren notificaciones por email introduzcan su email.
                        If Me.chkboxNotificacionMail.Checked And Trim(Me.txtRepEmail.Text) = "" Then
                            Me.lblMensajeDeError.Text = "Si desea recibir notificaciones via e-mail, debe introducir su e-mail."
                            Me.lblMensajeDeError.ForeColor = Drawing.Color.Red
                            Return
                        End If

                        'Agregando representante
                        Dim ret As String = Representante.insertaRepresentante(Trim(Me.ucRepresentante.getDocumento), Integer.Parse(Me.UsrRegistroPatronal), Me.ddTipo.SelectedValue, IIf(Me.chkboxNotificacionMail.Checked, "S", "N"), Me.ucRepTelefono1.PhoneNumber, Me.txtRepExt1.Text, Me.ucRepTelefono2.PhoneNumber, Me.txtRepExt2.Text, Me.txtRepEmail.Text, Trim(Me.UsrUserName))

                        If Split(ret, "|")(0) = "0" Then

                            Me.asignarNominas(New Representante(Me.UsrRNC, Trim(Me.ucRepresentante.getDocumento)))

                            Me.lblTmpRepNombre.Text = Me.ucRepresentante.getNombres + " " + Me.ucRepresentante.getApellidos
                            Me.lblTmpRepClass.Text = Split(ret, "|")(1)
                            Me.pnlTmpRep.Visible = True

                            Me.pnlDetalle.Visible = False


                            'Me.MostrarAbajo()

                        Else
                            Me.pnlDetalle.Visible = True
                            Me.lblRepMsg.Text = (Split(ret, "|")(1))
                        End If
                    Else
                        Me.lblRepMsg.Text = "Debe indicar las nóminas a las que tiene acceso este representante."
                    End If

                Else
                    Me.lblRepMsg.Text = "Debe seleccionar un individuo."
                End If

            Catch ex As Exception
                Me.lblRepMsg.Text = ex.Message
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        ElseIf Me.Estatus = Modo.Edicion Then
            Try

                Dim tmpRep As New Representante(Me.UsrRNC, Me.lblCedula.Text)

                tmpRep.TipoRep = Me.ddTipo.SelectedValue
                tmpRep.Telefono1 = Me.ucRepTelefono1.PhoneNumber
                tmpRep.Ext1 = Me.txtRepExt1.Text
                tmpRep.Telefono2 = Me.ucRepTelefono2.PhoneNumber
                tmpRep.Ext2 = Me.txtRepExt2.Text

                Try
                    If tmpRep.Email <> Me.txtRepEmail.Text Then
                        Operaciones.RegistroLogAuditoria.CrearRegistro(Me.UsrRegistroPatronal, Me.UsrUserName, Me.UsrUserName, 5, Request.UserHostAddress, Request.UserHostName, "Anterior: " + tmpRep.Email + " | Actual: " + Me.txtRepEmail.Text, Request.ServerVariables("LOCAL_ADDR"))
                    End If
                Catch ex As Exception
                    Try
                        SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                    Catch ex2 As Exception

                    End Try

                End Try

                tmpRep.Email = Me.txtRepEmail.Text
                tmpRep.FacturaXEmail = IIf(Me.chkboxNotificacionMail.Checked, "S", "N")
                tmpRep.GuardarCambios(Me.UsrUserName)

                Dim result As String = tmpRep.GuardarCambios(Me.UsrUserName)

                If result <> "0" Then
                    Throw New Exception(result)
                End If


                tmpRep.quitarTodoAccesoNomina(UsrUserName)
                Me.asignarNominas(tmpRep)
                Me.mostrarArriba()

                Me.lblMensajeDeError.ForeColor = Drawing.Color.Blue
                Me.lblMensajeDeError.Text = "Registro actualizado satisfactoriamente"
            Catch ex As Exception
                Me.lblRepMsg.Text = ex.Message
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If

    End Sub

    Private Function marcoAcceso() As Boolean

        For Each i As GridViewRow In Me.dgNominas.Rows
            If CType(i.FindControl("chbSelecciona"), CheckBox).Checked = True Then Return True
        Next

        Return False

    End Function

    Private Sub asignarNominas(ByVal rep As Representante)

        For Each i As GridViewRow In Me.dgNominas.Rows

            If CType(i.FindControl("chbSelecciona"), CheckBox).Checked Then
                rep.darAccesoNomina(Integer.Parse(CType(i.FindControl("lblID"), Label).Text), Me.UsrUserName)
            End If

        Next

    End Sub

    Private Sub prepararEditarRepresentante(ByVal Cedula As String)
        Me.Estatus = Modo.Edicion

        Session("Modo") = Me.Estatus

        Me.MostrarAbajo()
        Dim rep As New Representante(Me.UsrRNC, Cedula)

        Me.pnlNuevaInfoGeneral.Visible = False
        Me.pnlInfoGeneral.Visible = True

        Me.lblNombre.Text = rep.NombreCompleto
        Me.lblCedula.Text = rep.Cedula
        Me.lblNss.Text = rep.IdNSS
        Me.ddTipo.SelectedValue = rep.TipoRep
        Me.ucRepTelefono1.PhoneNumber = rep.Telefono1
        Me.txtRepExt1.Text = rep.Ext1
        Me.ucRepTelefono2.PhoneNumber = rep.Telefono2
        Me.txtRepExt2.Text = rep.Ext2
        Me.txtRepEmail.Text = rep.Email
        Me.chkboxNotificacionMail.Checked = IIf(rep.FacturaXEmail = "S", True, False)

        Dim tmpTablaAccesos As DataTable = rep.getAccesos()

        For Each i As GridViewRow In Me.dgNominas.Rows

            If rep.tieneAcceso(tmpTablaAccesos, Integer.Parse(CType(i.FindControl("lblId"), Label).Text)) Then
                CType(i.FindControl("chbSelecciona"), CheckBox).Checked = True
            End If

        Next


    End Sub

    Private Sub BorrarRepresentante(ByVal idNSS As Int32)

        Dim ret As String = SuirPlus.Empresas.Representante.borraRepresentante(Me.UsrRegistroPatronal, idNSS, Me.UsrUserName)

        If Split(ret, "|")(0) = "0" Then
            Me.lblMensajeDeError.Text = "El representante fue borrado satisfactoriamente."
            Me.lblMensajeDeError.ForeColor = Drawing.Color.Blue
            Me.mostrarArriba()
        Else
            Me.lblMensajeDeError.Text = Split(ret, "|")(1)
            Me.lblMensajeDeError.ForeColor = Drawing.Color.Red
            Me.mostrarArriba()
        End If

    End Sub

    Private Sub resetearClass(ByVal usuario As String)
        usuario = usuario.ToUpper

        Try

            Dim tmpClass As String = SuirPlus.Seguridad.Usuario.ResetearClass(usuario)

            If Split(tmpClass, "|")(0) = "0" Then

                'Reseteado correctamente
                Me.lblMensajeDeError.ForeColor = Drawing.Color.Blue
                Me.lblMensajeDeError.Text = "El CLASS fue reseteado satisfactoriamente. Nuevo CLASS <B>" & Split(tmpClass, "|")(1) & "</B>"

            Else

                'Error
                Me.lblMensajeDeError.ForeColor = Drawing.Color.Red
                Me.lblMensajeDeError.Text = Split(tmpClass, "|")(1)

            End If

        Catch ex As Exception

            Me.lblMensajeDeError.ForeColor = Drawing.Color.Red
            Me.lblMensajeDeError.Text = "Ocurrio un error, el CLASS no pudo ser recuperado."
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.mostrarArriba()
    End Sub

    Private Function getNSS() As String
        Return Me.UsrNSS
    End Function

    Protected Sub dgRepresentantes_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgRepresentantes.RowCommand

        Dim cedula As String = e.CommandArgument.ToString
        Select Case e.CommandName
            Case "Editar"

                If e.CommandArgument = "N" Then
                    Me.ddTipo.Enabled = False
                Else
                    Me.ddTipo.Enabled = True
                End If
                Me.prepararEditarRepresentante(cedula)

            Case "Borrar"
                Me.BorrarRepresentante(e.CommandArgument.ToString)
            Case "Recuperar"
                Me.resetearClass(Me.UsrRNC & e.CommandArgument.ToString)

        End Select
    End Sub

    Protected Sub dgRepresentantes_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgRepresentantes.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then

            If CType(e.Row.FindControl("lblID"), Label).Text = getNSS() Then
                CType(e.Row.FindControl("iBtnBorrar"), ImageButton).Visible = False
                'CType(e.Row.FindControl("iBtnEditar"), ImageButton).CommandArgument = "N"
            Else
                'CType(e.Row.FindControl("iBtnEditar"), ImageButton).CommandArgument = "S"
            End If
        End If

    End Sub

    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVolver.Click
        Me.btnNuevoRep_Click(Nothing, Nothing)
    End Sub
End Class
