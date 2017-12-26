Imports System.Data
Imports System.Drawing
Imports System.Globalization
Imports System.Threading
Imports SuirPlus
Imports SuirPlus.Utilitarios
Imports SuirPlusEF
Imports SuirPlusEF.Models
Imports SuirPlusEF.Repositories
Partial Class Evaluacion_Visual_EvaVisualDetalle
    Inherits BasePage

    'Shared nwIdNSS As String
    Public Property NSSRetornado() As Integer
        Get
            Return CInt(HttpContext.Current.Session("nwIdNSS"))
        End Get
        Set(ByVal value As Integer)
            HttpContext.Current.Session("nwIdNSS") = value
        End Set
    End Property

    Public ReadOnly Property IdSol() As Int32
        Get
            Return CInt(HttpContext.Current.Session("IdSol"))
        End Get
    End Property

    Public ReadOnly Property IdReg() As Int32
        Get
            Return CInt(HttpContext.Current.Session("IdReg"))
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        Dim registro As String = Request.QueryString("Registro")
        Dim sol As New SuirPlusEF.Repositories.SolicitudNSSRepository()
        Dim ars As New SuirPlusEF.Repositories.ArsCatalogoRepository()
        Dim detSol As New DetalleSolicitudesRepository()
        Dim solicitud = detSol.GetByRegistro(registro)
        Dim valor = sol.GetById(CInt(solicitud.IdSolicitud))
        'Dim motivo = detSol.GetBySolicitud(valor.IdSolicitud)
        Dim motivo = detSol.GetByRegistro(registro)
        Dim catalogoArs = ars.GetByIdArs(motivo.IdARS)
        HttpContext.Current.Session("IdReg") = registro

        If Not Page.IsPostBack Then

            HttpContext.Current.Session("IdSol") = solicitud.IdSolicitud

            If (valor.IdTipo = 4) Or (valor.IdTipo = 5) Then
                CargarEvaluacionExt(valor.IdSolicitud)
                CargarDetEvaluacionExt(registro)
                CargarMotivoRechazo("N")
                pnlNacionales.Visible = False
                btnActualizar.Visible = False

            ElseIf ((valor.IdTipo = 1) Or (valor.IdTipo = 2) Or (valor.IdTipo = 3)) Then
                CargarEvaluacionNac(registro)
                CargarDetEvaluacionNac(registro)
                CargarMotivoRechazo("N")
                pnlExtranjeros.Visible = False
            End If

            lblSolicitud.Text = valor.IdSolicitud
            lblTipoSolicitud.Text = valor.tipoSolicitudNSS.Descripcion
            lblFechaSolicitud.Text = valor.FechaSolicitud.ToString("dd/MM/yyyy")

            If motivo.error IsNot Nothing Then
                lblMotivo.Text = motivo.error.Descripcion
                lblMotivo.Visible = True
            End If

            If catalogoArs IsNot Nothing Then
                lblArs.Text = catalogoArs.Descripcion
                tdArs.Visible = True
            Else
                tdArs.Visible = False
            End If

            HttpContext.Current.Session("nwIdNSS") = Nothing
        End If

    End Sub
    Public Sub CargarEvaluacionExt(ByVal solicitud As Integer)
        Try
            Dim repEvaluacion As New SuirPlusEF.Repositories.DetEvaluacionVisualRepository()
            Dim evaluacion = repEvaluacion.GetEvaluacionMaestroExt(solicitud)

            If evaluacion.Count > 0 Then
                gvMaestroExtranjeros.DataSource = evaluacion
                gvMaestroExtranjeros.DataBind()
                pnlExtranjeros.Visible = True
            End If

        Catch ex As Exception
            Throw ex.InnerException
        End Try
    End Sub

    Public Sub CargarDetEvaluacionExt(ByVal registro As Integer)
        Try
            Dim detevaluacion As DataTable
            detevaluacion = SuirPlus.SolicitudesEnLinea.Solicitudes.getEvaluacionDet(registro)

            If detevaluacion.Rows.Count > 0 Then
                gvDetalleExtranjero.DataSource = detevaluacion
                gvDetalleExtranjero.DataBind()
                pnlExtranjeros.Visible = True
            End If
        Catch ex As Exception
            Throw ex.InnerException
        End Try
    End Sub

    Public Sub CargarEvaluacionNac(ByVal registro As Integer)
        Try
            Dim repEvaluacion As New SuirPlusEF.Repositories.DetEvaluacionVisualRepository()
            Dim evaluacion = repEvaluacion.GetEvaluacionMaestroNac(registro)

            If evaluacion.Count > 0 Then
                gvMaestroNacionales.DataSource = evaluacion
                gvMaestroNacionales.DataBind()
                pnlNacionales.Visible = True
            End If

        Catch ex As Exception
            Throw ex.InnerException
        End Try
    End Sub

    Public Sub CargarDetEvaluacionNac(ByVal solicitud As Integer)
        Try
            Dim detevaluacion As DataTable
            detevaluacion = SuirPlus.SolicitudesEnLinea.Solicitudes.getEvaluacionDet(solicitud)

            If detevaluacion.Rows.Count > 0 Then
                gvDetalleNacionales.DataSource = detevaluacion
                gvDetalleNacionales.DataBind()
                pnlNacionales.Visible = True
            End If

        Catch ex As Exception
            Throw ex.InnerException
        End Try
    End Sub

    Private Sub CargarMotivoRechazo(ByVal tipoMotivos As String)

        Dim dt As New DataTable
        dt = Ars.Consultas.GetMotivoRechazoNSS()
        If dt.Rows.Count > 0 Then
            ddlMotivo.DataSource = dt
            ddlMotivo.DataTextField = "error_des"
            ddlMotivo.DataValueField = "id_error"
            ddlMotivo.DataBind()
        End If
        ddlMotivo.Items.Insert(0, New ListItem("<-- Seleccione -->", "0"))
        ddlMotivo.SelectedValue = "0"

    End Sub

    Private Sub btnAsignacion_Click(sender As Object, e As EventArgs) Handles btnAsignacion.Click
        Try
            Dim repDetalleEvaluacion As New DetEvaluacionVisualRepository()
            Dim repDetalleSolicitud As New DetalleSolicitudesRepository()
            Dim sol = repDetalleSolicitud.GetByRegistro(IdReg)
            Dim repSolicitud As New SolicitudNSSRepository()
            Dim SolTipo = repSolicitud.GetById(IdSol)

            If ddlMotivo.SelectedValue <> "0" Then
                lbl_error.Text = "No debe elegir ningún motivo de rechazo"
                lbl_error.Visible = True
                Return
            End If
            repDetalleEvaluacion.NSSInsertarCiudadano(IdReg, UsrUserName)
            Response.Redirect("~/Asignacion_NSS/EvaVisualMaster.aspx?IdTipo=" & SolTipo.IdTipo)

        Catch ex As Exception
            lbl_error.Text = "Error asignando el NSS..."
            lbl_error.Visible = True
            Exepciones.Log.LogToDB("Error asignando el NSS... " + ex.ToString())
        End Try

    End Sub

    Private Sub btnActualizar_Click(sender As Object, e As EventArgs) Handles btnActualizar.Click
        Try
            Dim repDetalleEvaluacion As New DetEvaluacionVisualRepository()
            Dim repDetalleSolicitud As New DetalleSolicitudesRepository()
            Dim sol = repDetalleSolicitud.GetByRegistro(IdReg)
            Dim repSolicitud As New SolicitudNSSRepository()
            Dim SolTipo = repSolicitud.GetById(IdSol)
            NSSRetornado = RecorrerGridView()


            If ddlMotivo.SelectedValue <> "0" Then
                lbl_error.Text = "No debe elegir ningún motivo de rechazo"
                lbl_error.Visible = True
                Return
            End If
            'para los casos diferentes de extranjeros
            If sol.solicitudNSS.IdTipo <> 4 Then
                If NSSRetornado = Nothing Then
                    lbl_error.Text = "Debe seleccionar el registro a actualizar."
                    lbl_error.Visible = True
                    Return
                End If
            Else
                lbl_error.Text = "Las solicitudes de trabajadores extranjeros no se actualizan."
                lbl_error.Visible = True
                NSSRetornado = Nothing
                Return
            End If

            repDetalleEvaluacion.NSSActualizarCiudadano(IdReg, UsrUserName, NSSRetornado)
            Response.Redirect("~/Asignacion_NSS/EvaVisualMaster.aspx?IdTipo=" & SolTipo.IdTipo)

        Catch ex As Exception
            lbl_error.Text = "Error al actualizar..."
            lbl_error.Visible = True
            Exepciones.Log.LogToDB("Error al actualizar..." + ex.ToString())
        End Try
    End Sub

    Private Sub btnRechazar_Click(sender As Object, e As EventArgs) Handles btnRechazar.Click
        Try
            Dim repDetalleEvaluacion As New DetEvaluacionVisualRepository()
            Dim repDetalleSolicitud As New DetalleSolicitudesRepository()
            Dim repSolictud As New SolicitudNSSRepository()
            Dim sol = repDetalleSolicitud.GetByRegistro(IdReg)
            Dim tipoSol = repSolictud.GetById(sol.IdSolicitud)

            If (tipoSol.IdTipo = 1 Or tipoSol.IdTipo = 2 Or tipoSol.IdTipo = 3) Then
                NSSRetornado = RecorrerGridView()
            Else
                NSSRetornado = RecorrerGridViewExt()
            End If

            If ddlMotivo.SelectedValue = "0" Then
                lbl_error.Text = "Debe Seleccionar un motivo de rechazo"
                lbl_error.Visible = True
                Return
            End If

            If ddlMotivo.SelectedValue = "NSS904" Then
                If NSSRetornado = Nothing Then
                    lbl_error.Text = "Debe seleccionar el registro de duplicidad."
                    lbl_error.Visible = True
                    Return
                End If
            Else
                NSSRetornado = Nothing
            End If

            Dim repSolicitud As New SolicitudNSSRepository()
            Dim SolTipo = repSolicitud.GetById(IdSol)
            repDetalleEvaluacion.NSSRechazarSolicitud(IdReg, 6, ddlMotivo.SelectedValue, NSSRetornado, UsrUserName)
            Response.Redirect("~/Asignacion_NSS/EvaVisualMaster.aspx?IdTipo=" & SolTipo.IdTipo)

        Catch ex As Exception
            lbl_error.Text = "Error al rechazar la solicitud..."
            lbl_error.Visible = True
            Exepciones.Log.LogToDB("Error al rechazar la solicitud... " + ex.ToString())
            Return
        End Try
    End Sub

    Private Sub gvMaestroExtranjeros_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvMaestroExtranjeros.RowCommand
        If e.CommandName = "Ver" Then
            Dim registro As String = Request.QueryString("registro")
            Dim repDetalleSolicitud As New DetalleSolicitudesRepository()
            Dim solicitud = repDetalleSolicitud.GetByRegistro(registro)
            Dim script As String = "<script Language=JavaScript>" + "modelesswin('ImagenSolicitud.aspx?registro=" & registro & "')</script>"
            Me.ClientScript.RegisterStartupScript(Me.GetType, "popup", script)
            Return
        End If
    End Sub

    Private Sub gvDetalleNacionales_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDetalleNacionales.RowCommand

        If e.CommandName = "Ver" Then
            Dim nss As String = e.CommandArgument.ToString()
            Dim script As String = "<script Language=JavaScript>" + "modelesswin('ImagenCiudadano.aspx?nss=" & nss & "')</script>"
            Me.ClientScript.RegisterStartupScript(Me.GetType, "popup", script)
            Return
        End If
    End Sub

    Private Sub gvMaestroNacionales_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvMaestroNacionales.RowCommand
        If e.CommandName = "VerMaestro" Then
            Dim registro As String = Request.QueryString("registro")
            Dim script As String = "<script Language=JavaScript>" + "modelesswin('ImagenSolicitud.aspx?registro=" & registro & "')</script>"
            Me.ClientScript.RegisterStartupScript(Me.GetType, "popup", script)
            Return
        End If
    End Sub

    Private Sub gvMaestroExtranjeros_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvMaestroExtranjeros.RowDataBound
        Dim ibImagenEnc As ImageButton = CType(e.Row.FindControl("ibImagenEnc"), ImageButton)
        Dim DetSol As New DetalleSolicitudes()
        Dim repDetSol As New Repositories.DetalleSolicitudesRepository()

        If e.Row.RowType = DataControlRowType.DataRow Then
            If (e.Row.Cells(6).Text <> String.Empty) Then
                e.Row.Cells(6).Text = e.Row.Cells(6).Text & " - Edad: " & Utilitarios.Utils.ObtenerEdad(e.Row.Cells(6).Text, DateTime.Now)
            End If
            DetSol = repDetSol.GetBySolicitud(IdSol)
            If DetSol.IMAGEN_SOLICITUD IsNot Nothing Then
                ibImagenEnc.Visible = True
            Else
                ibImagenEnc.Visible = False
            End If
        End If
    End Sub

    Private Sub gvDetalleExtranjero_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDetalleExtranjero.RowCommand
        If e.CommandName = "VerDetalle" Then
            Dim nss As String = e.CommandArgument.ToString()
            Dim script As String = "<script Language=JavaScript>" + "modelesswin('ImagenCiudadano.aspx?nss=" & nss & "');</script>"
            Me.ClientScript.RegisterStartupScript(Me.GetType, "popup", script)
            Return
        End If
    End Sub

    Private Sub gvMaestroNacionales_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvMaestroNacionales.RowDataBound
        Dim ibImgnMaestro As ImageButton = CType(e.Row.FindControl("ibImgnMaestro"), ImageButton)
        Dim DetSol As New DetalleSolicitudes()
        Dim repDetSol As New Repositories.DetalleSolicitudesRepository()

        If e.Row.RowType = DataControlRowType.DataRow Then
            If (e.Row.Cells(4).Text <> String.Empty) Then
                e.Row.Cells(4).Text = e.Row.Cells(4).Text & " - Edad: " & Utilitarios.Utils.ObtenerEdad(e.Row.Cells(4).Text, DateTime.Now)
            End If
            DetSol = repDetSol.GetBySolicitud(IdSol)
            If DetSol.IMAGEN_SOLICITUD IsNot Nothing Then
                ibImgnMaestro.Visible = True
            Else
                ibImgnMaestro.Visible = False
            End If
        End If
    End Sub

    Private Sub gvDetalleNacionales_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gvDetalleNacionales.SelectedIndexChanged
        For Each row As GridViewRow In gvDetalleNacionales.Rows
            If row.RowIndex = gvDetalleNacionales.SelectedIndex Then
                row.BackColor = ColorTranslator.FromHtml("#A1DCF2")
                Session("Id_NSS") = row.Cells(1).Text
            Else
                row.BackColor = ColorTranslator.FromHtml("#FFFFFF")
            End If
        Next
    End Sub
    Private Sub btnListar_Click(sender As Object, e As EventArgs) Handles btnListar.Click
        Dim repSolicitud As New SolicitudNSSRepository()
        Dim Sol = repSolicitud.GetById(lblSolicitud.Text)
        Response.Redirect("~/Asignacion_NSS/EvaVisualMaster.aspx?IdTipo=" & Sol.IdTipo)
    End Sub

    Private Sub gvDetalleExtranjero_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvDetalleExtranjero.RowDataBound
        Dim ibImagenDet As ImageButton = CType(e.Row.FindControl("ibImagenDet"), ImageButton)
        Dim ciudadano As New Ciudadano()
        Dim repCiudadano As New Repositories.CiudadanoRepository()

        If e.Row.RowType = DataControlRowType.DataRow Then

            ciudadano = repCiudadano.GetByNSS(e.Row.Cells(1).Text)
            If ciudadano.ImagenActa IsNot Nothing Then
                ibImagenDet.Visible = True
            Else
                ibImagenDet.Visible = False
            End If
        End If
    End Sub

    Private Sub gvDetalleNacionales_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvDetalleNacionales.RowDataBound
        Dim ibImagenDet As ImageButton = CType(e.Row.FindControl("ibImagen"), ImageButton)
        Dim ciudadano As New Ciudadano()
        Dim repCiudadano As New Repositories.CiudadanoRepository()

        If e.Row.RowType = DataControlRowType.DataRow Then
            If (e.Row.Cells(6).Text <> String.Empty) Then
                e.Row.Cells(6).Text = e.Row.Cells(6).Text & " - Edad: " & Utilitarios.Utils.ObtenerEdad(e.Row.Cells(6).Text, DateTime.Now)
            End If
            ciudadano = repCiudadano.GetByNSS(e.Row.Cells(1).Text)
            If ciudadano.ImagenActa IsNot Nothing Then
                ibImagenDet.Visible = True
            Else
                ibImagenDet.Visible = False
            End If
        End If
    End Sub

    Function RecorrerGridView() As Integer
        Dim resultado As Integer = 0

        For Each item As GridViewRow In gvDetalleNacionales.Rows
            Dim check = CType(gvDetalleNacionales.Rows.Item(item.RowIndex).Cells(0).FindControl("radButton"), HtmlInputRadioButton)
            If check.Checked = True Then
                resultado = check.Value
            End If
        Next
        Return resultado
    End Function

    Function RecorrerGridViewExt() As Integer
        Dim resultado As Integer = 0

        For Each item As GridViewRow In gvDetalleExtranjero.Rows
            Dim check = CType(gvDetalleExtranjero.Rows.Item(item.RowIndex).Cells(0).FindControl("radButton"), HtmlInputRadioButton)
            If check.Checked = True Then
                resultado = check.Value
            End If
        Next
        Return resultado
    End Function


End Class
