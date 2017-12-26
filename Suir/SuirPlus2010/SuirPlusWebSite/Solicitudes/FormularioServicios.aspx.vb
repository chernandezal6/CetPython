Imports SuirPlus
Imports System.Data
Imports SuirPlus.Utilitarios

Partial Class FormularioServicios
    Inherits BasePage
    Dim script As String
    Public NoSol As String
   
    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            GetTiposSolicitudes()
            cargarClasificacionEmpresa()
            cargarSectoresSalariales()
        End If
    End Sub

    Private Sub cargarClasificacionEmpresa()
        'cargando clasificación de empresas
        ddlClaseEmpresa.DataSource = Empresas.Empleador.getClaseEmpresa()
        ddlClaseEmpresa.DataTextField = "descripcion"
        ddlClaseEmpresa.DataValueField = "id"
        ddlClaseEmpresa.DataBind()

        'asignamos default value en los dropdowns

        ddlClaseEmpresa.Items.Insert(0, New ListItem("<-- Seleccione -->", "0"))
        ddlClaseEmpresa.SelectedValue = 0
    End Sub

    Private Sub cargarSectoresSalariales()
        'cargando sectores salariales
        ddlSectorSalarial.DataSource = Mantenimientos.SectoresSalariales.getSectoresSalariales()
        ddlSectorSalarial.DataTextField = "descripcion"
        ddlSectorSalarial.DataValueField = "id"
        ddlSectorSalarial.DataBind()

        'asignamos default value en los dropdowns
        ddlSectorSalarial.Items.Insert(0, New ListItem("<-- Seleccione -->", "0"))
        ddlSectorSalarial.SelectedValue = 0
    End Sub

    Private Sub GetTiposSolicitudes()
        ddlTipoServicio.DataSource = SolicitudesEnLinea.Solicitudes.getSolicitudesServicio()
        ddlTipoServicio.DataTextField = "TipoSolicitud"
        ddlTipoServicio.DataValueField = "IdTipo"
        ddlTipoServicio.DataBind()
        ddlTipoServicio.Items.Insert(0, New ListItem("<-- Seleccione -->", "0"))
        ddlTipoServicio.SelectedValue = 0
    End Sub
     
    Private Sub Limpiar()
        lblMensaje.Text = String.Empty
        lblMensajeEmpresa.Text = String.Empty
       
    End Sub

    Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGuardar.Click
        GuardarSolicitud()
    End Sub

    Private Sub GuardarSolicitud()
        Limpiar()
        Dim comentario As String = String.Empty
       
        Try

            If ddlTipoServicio.SelectedValue = "0" Then
                Me.lblMensaje.Text = "Por favor seleccione un tipo de solicitud."
                Exit Sub
            End If

            If ddlTipoServicio.SelectedValue = "2" Then

                'validamos si los documentos requeridos fueron revisados

                Dim mylist = cbRequisitos.Items

                For Each item As ListItem In mylist

                    If item.Text.Contains("[Es obligatorio]") Then
                        If Not item.Selected Then
                            Me.lblMensaje.Text = "Debe completar todos los documentos requeridos para el registro de empresa."
                            Exit Sub
                        End If
                    End If
                Next
                If txtRnc.Text = "" Then
                    Me.lblMensaje.Text = "El RNC es obligatorio."
                    Exit Sub
                Else
                    If Me.lblRazonSocialActual.Text = String.Empty Then
                        Me.lblMensaje.Text = "Debe consultar el RNC."
                        Exit Sub
                    End If
                End If

            End If

            'validamos el motivo de la solictud de devolucion de aporte

            If ddlTipoServicio.SelectedValue = "22" Then
                If txtMotivo.Text = String.Empty Then
                    Me.lblMensaje.Text = "El motivo de la solicitud es requerido."
                    Exit Sub
                End If

                'validamos si el solicitante tiene su cedula cancelada
                Dim dtciudadano As New DataTable
                dtciudadano = TSS.CedulaCancelada(UCCiudadano1.getDocumento.ToString())

                If dtciudadano.Rows.Count > 0 Then
                    If dtciudadano.Rows(0)("TIPO_CAUSA") = "C" Then
                        Me.lblMensaje.Text = "La cédula del solicitante esta cancelada."
                        Exit Sub
                    End If

                End If

            End If

            If Not Me.UCCiudadano1.getNombres = String.Empty Then

                'Verificar qeu todos los requisitos de la lista esten seleccionados para poder continuar
                'Este listado de requisitos solo se pide para el tipo Registro de Empresa

                If (ddlTipoServicio.Text.Equals("3")) And (String.IsNullOrEmpty(lblRazonSocialActual.Text)) Then
                    Me.lblMensaje.Text += "<br />El RNC o Cédula es requerido para este tipo de solicitud."
                    Exit Sub
                End If

                If (Not String.IsNullOrEmpty(txtRnc.Text)) And String.IsNullOrEmpty(lblRazonSocialActual.Text) And (Not ddlTipoServicio.Text.Equals("2")) Then
                    Me.lblMensaje.Text = "Por favor verifique el RNC o Cédula."
                    Exit Sub
                Else
                    Me.lblMensaje.Text = String.Empty
                    Dim result As String = String.Empty

                    If ddlTipoServicio.SelectedValue = "2" Then
                        'agregamos los documentos seleccionados a la columna de motivo
                        comentario = comentario & "DOCUMENTOS REQUERIDOS:" & Environment.NewLine()
                        For Each item In cbRequisitos.Items
                            If item.Selected Then

                                Dim docRequerido As String = Replace(item.ToString(), "<span class=error>[Es obligatorio]</span>", "")
                                comentario += "* " & docRequerido & Environment.NewLine()
                            End If
                        Next
                        'agregamos el sector salarial seleccionado a la columna de motivo
                        comentario = comentario & "SECTOR SALARIAL:" & Environment.NewLine()
                        comentario += "* " & ddlSectorSalarial.SelectedItem.Text & Environment.NewLine()

                        'agregamos el motivo con lo demas acumulado
                        comentario = comentario & "MOTIVO:" & Environment.NewLine()
                        If txtMotivo.Text <> String.Empty Then
                            comentario += "* " & txtMotivo.Text & Environment.NewLine()
                        End If

                        txtMotivo.Text = comentario
                    End If

                    result = SolicitudesEnLinea.Solicitudes.crearSolicitud(Me.ddlTipoServicio.SelectedValue, 0, Me.txtRnc.Text, UCCiudadano1.getDocumento(), MyBase.UsrUserName, Me.txtMotivo.Text)

                    If Split(result, "|")(0) = "0" Then
                        NoSol = Split(result, "|")(1)

                        'result = SuirPlus.SolicitudesEnLinea.Solicitudes.CambiarStatus(NoSol, 1, MyBase.UsrUserName, ddlTipoServicio.SelectedItem.Text)

                        pnlFinal.Visible = True
                        Me.pnlInfo.Visible = False
                        Me.pnlRequisitos.Visible = False
                        Me.tblTipo.Visible = False
                        Me.divTipoServicio.Visible = False
                        Me.lblNoSolicitud.Text = NoSol
                        Me.lblTipoServicio.Text = Me.ddlTipoServicio.SelectedItem.Text


                        Dim script As String = "<script Language=JavaScript>" + "window.open('VerFormServicio.aspx?NoSol=" & NoSol & "')</script>"

                        Me.ClientScript.RegisterStartupScript(Me.GetType, "popup", script)
                    Else
                        Me.divTipoServicio.Visible = True
                        lblMensaje.Text = Split(result, "|")(2)
                    End If
                End If
            Else
                Me.lblMensaje.Text = "El solicitante es requerido por el sistema."
            End If

        Catch ex As Exception
            lblMensaje.Text = ex.Message
        End Try

    End Sub

    Protected Sub ddlTipoServicio_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlTipoServicio.SelectedIndexChanged
        Limpiar()
        If Me.ddlTipoServicio.SelectedValue <> "0" Then
            pnlInfo.Visible = True

            Select Case Me.ddlTipoServicio.SelectedValue
                Case "2"
                    pnlRequisitos.Visible = True

                Case Else
                    pnlRequisitos.Visible = False

            End Select

        End If
    End Sub

    Protected Sub btnNuevaCert_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNuevaCert.Click
        Response.Redirect("FormularioServicios.aspx")
    End Sub

    Protected Sub cargarRequisitos(ByVal idClaseEmpresa As Integer)
        Dim dt As DataTable
        Dim dr As DataRow
        Dim requerido As New Label
        requerido.Text = "[Es obligatorio]"
        dt = SuirPlus.Empresas.Empleador.getDocClaseEmpresa(idClaseEmpresa)
        If dt.Rows.Count > 0 Then
            cbRequisitos.Items.Clear()
            'llenar check box list
            For Each dr In dt.Rows
                If dr("obligatorio") = "S" Then
                    cbRequisitos.Items.Add(dr("Descripcion") & " " & "<span class=" & "error" & ">" & requerido.Text & "</span>")
                Else
                    cbRequisitos.Items.Add(dr("Descripcion"))
                End If

            Next
        End If
    End Sub

    Protected Sub ddlClaseEmpresa_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlClaseEmpresa.SelectedIndexChanged

        If Me.ddlClaseEmpresa.SelectedValue <> "0" Then
            cargarRequisitos(CInt(ddlClaseEmpresa.SelectedValue))
            Me.trRequisitos.Visible = True
        Else
            Me.trRequisitos.Visible = False
        End If

    End Sub

    Protected Sub btnConsRNC_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsRNC.Click
        Dim emp As Empresas.Empleador
        Dim dt As DataTable
        Me.lblMensaje.Text = String.Empty
        Try
            If Not Me.txtRnc.Text = String.Empty Then

                If ddlTipoServicio.SelectedValue = "2" Then

                    dt = Empresas.Empleador.getDGIIEmpleador(Me.txtRnc.Text)
                    If dt.Rows.Count > 0 Then
                        trRazonSocial.Visible = True
                        Me.lblRazonSocialActual.Text = dt.Rows(0)("razon_social")
                        Me.lblMensajeEmpresa.Text = String.Empty
                    Else
                        trRazonSocial.Visible = False
                        Me.lblMensajeEmpresa.Text = "RNC/Cédula inválida"
                        Exit Sub
                    End If

                ElseIf ddlTipoServicio.SelectedValue = "22" Then ' para devolución de aportes
                    Me.lblMensajeEmpresa.Text = String.Empty
                    emp = New Empresas.Empleador(Me.txtRnc.Text)

                    If emp.RegistroPatronal = -1 Then
                        trRazonSocial.Visible = False
                        Me.lblMensajeEmpresa.Text = "RNC/Cédula inválida."
                        Exit Sub
                    End If
                    If emp.Estatus = "B" Then
                        trRazonSocial.Visible = False
                        Me.lblMensajeEmpresa.Text = "Este empleador está de baja."
                        Exit Sub
                    End If

                    If Not emp.RazonSocial = Nothing Then
                        trRazonSocial.Visible = True
                        Me.lblRazonSocialActual.Text = emp.RazonSocial
                    Else
                        trRazonSocial.Visible = False
                        Me.lblMensajeEmpresa.Text = String.Empty
                    End If
                    'validamos que el empleador tenga NP pagadas.

                    If Not (Finanzas.DevolucionAportes.TieneFactPagadas(emp.RegistroPatronal)) Then
                        trRazonSocial.Visible = True
                        Me.lblMensajeEmpresa.Text = "Este empleador no tiene referencias pagadas."
                        Exit Sub
                    End If

                Else
                    emp = New Empresas.Empleador(Me.txtRnc.Text)
                    If emp.RegistroPatronal <> -1 Then
                        Me.lblMensajeEmpresa.Text = String.Empty
                        If Not emp.RazonSocial = Nothing Then
                            trRazonSocial.Visible = True
                            Me.lblRazonSocialActual.Text = emp.RazonSocial
                        Else
                            trRazonSocial.Visible = False
                            Me.lblMensajeEmpresa.Text = String.Empty
                        End If
                    Else
                        trRazonSocial.Visible = False
                        Me.lblMensajeEmpresa.Text = "RNC/Cédula inválida"
                    End If
                End If

            Else
                Me.lblMensajeEmpresa.Text = "RNC/Cédula requerida"
            End If
        Catch ex As Exception
            Me.lblMensajeEmpresa.Visible = True
            Me.lblMensajeEmpresa.Text = ex.Message
        End Try

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("FormularioServicios.aspx")
    End Sub

End Class
