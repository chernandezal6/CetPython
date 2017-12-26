Imports System.Data
Imports SuirPlusEF.Repositories
Imports System.Globalization
Imports System.Threading
Imports SuirPlus
Imports SuirPlus.Empresas
Imports System.Runtime.ConstrainedExecution
Imports System.IO
Imports SuirPlusEF
Imports SuirPlusEF.Models
Imports SuirPlusEF.Service
Imports SuirPlusEF.ViewModels
Imports SuirPlusMasterPage


Partial Class Asignacion_NSS_ConAsignacionNss
    Inherits BasePage

    Public RepSolicitudNss As New SolicitudNSSRepository()
    Public Property pageNum() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNum.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNum.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNum.Text = value
        End Set
    End Property

    Public Overloads Property PageSize() As Int16
        Get
            If String.IsNullOrEmpty(Me.lblPageSize.Text) Then
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSize.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSize.Text = value
        End Set
    End Property

    Private Sub Asignacion_NSS_ConAsignacionNss_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarTiposdocumentos()
            btLimpiar_Click(Nothing, Nothing)
        End If
        pageNum = 1
        PageSize = BasePage.PageSize
    End Sub

    Private Sub btnBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btBuscar.Click

        gvSolicitudGeneral.DataSource = Nothing
        gvSolicitudGeneral.DataBind()
        pnlNavegacion.Visible = False

        llenarDataGridSolicitud()
    End Sub

    Private Sub btLimpiar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btLimpiar.Click

        txtNumeroDocumento.Text = String.Empty
        txtNroDocSinMask.Text = String.Empty
        txtNumeroSol.Text = String.Empty
        ddlTipoDocumento.SelectedValue = ""
        gvSolicitudGeneral.Visible = False
        txtNroDocSinMask.Visible = True
        txtNumeroDocumento.Visible = False
        lblmensaje.Text = String.Empty
        lblmensaje.Visible = False
        pnlNavegacion.Visible = False
    End Sub
    Private Sub CargarTiposdocumentos()
        Try
            Dim TiposDocumentos As New SuirPlusEF.Repositories.TipoDocumentoRepository()
            Me.ddlTipoDocumento.DataSource = TiposDocumentos.GetTipoDocumentoAsig()
            ddlTipoDocumento.DataTextField = "Descripcion"
            ddlTipoDocumento.DataValueField = "IdTipoDocumento"
            ddlTipoDocumento.DataBind()
            ddlTipoDocumento.Items.Add(New ListItem("Seleccione", ""))
            ddlTipoDocumento.SelectedValue = ""
        Catch ex As Exception
            Throw ex.InnerException
        End Try
        txtNumeroDocumento.Visible = True
    End Sub
    Private Sub llenarDataGridSolicitud()

        Dim NroDoc = String.Empty
        Dim sol As String = String.Empty

        If ((txtNumeroDocumento.Text.Trim() = String.Empty And txtNroDocSinMask.Text.Trim() = String.Empty) And ddlTipoDocumento.SelectedValue = "") And (txtNumeroSol.Text.Trim() = String.Empty) Then
            Me.lblMensajeError.Text = "Debe especificar al menos uno de los criterios de busqueda."
            Me.lblMensajeError.Visible = True
            gvSolicitudGeneral.Visible = False
            Return
        ElseIf ((txtNumeroSol.Text.Trim() = String.Empty) And (txtNumeroDocumento.Text = String.Empty And txtNroDocSinMask.Text = String.Empty) And ddlTipoDocumento.SelectedValue <> "") Then
            Me.lblMensajeError.Text = "Debe especificar al menos uno de los criterios de busqueda."
            Me.lblMensajeError.Visible = True
            gvSolicitudGeneral.Visible = False
            Return

        ElseIf ((txtNumeroSol.Text.Trim() = String.Empty) And (txtNumeroDocumento.Text <> String.Empty Or txtNroDocSinMask.Text <> String.Empty) And ddlTipoDocumento.SelectedValue = "") Then
            Me.lblMensajeError.Text = "Debe especificar al menos uno de los criterios de busqueda."
            Me.lblMensajeError.Visible = True
            gvSolicitudGeneral.Visible = False
            Return

        ElseIf ((txtNumeroSol.Text.Trim() = String.Empty) And (txtNumeroDocumento.Text = "DO-__-______" And txtNroDocSinMask.Text = String.Empty) And ddlTipoDocumento.SelectedValue <> "") Then
            Me.lblMensajeError.Text = "Debe especificar al menos uno de los criterios de busqueda."
            Me.lblMensajeError.Visible = True
            gvSolicitudGeneral.Visible = False
            Return
        ElseIf ((txtNumeroSol.Text.Trim() <> String.Empty) And (txtNumeroDocumento.Text.Trim() <> String.Empty Or txtNroDocSinMask.Text.Trim() <> String.Empty) And ddlTipoDocumento.SelectedValue = "") Then
            Me.lblMensajeError.Text = "Debe especificar al menos uno de los criterios de busqueda."
            Me.lblMensajeError.Visible = True
            gvSolicitudGeneral.Visible = False
            Return
        ElseIf ((txtNumeroSol.Text.Trim() <> String.Empty) And (txtNumeroDocumento.Text.Trim() = String.Empty And txtNroDocSinMask.Text.Trim() = String.Empty) And ddlTipoDocumento.SelectedValue <> "") Then
            Me.lblMensajeError.Text = "Debe especificar al menos uno de los criterios de busqueda."
            Me.lblMensajeError.Visible = True
            gvSolicitudGeneral.Visible = False
            Return
        Else
            If (ddlTipoDocumento.SelectedValue = "C") Or (ddlTipoDocumento.SelectedValue = "U") Then
                If (txtNroDocSinMask.Text.Trim() <> String.Empty) And Len(txtNroDocSinMask.Text.Trim()) <> 11 Then
                    Me.lblMensajeError.Text = "El número de documento debe tener 11 digitos."
                    Me.lblMensajeError.Visible = True
                    Return
                End If
            End If

            If ((txtNumeroSol.Text.Trim()) <> String.Empty) Then
                sol = (txtNumeroSol.Text)
            End If

            If txtNroDocSinMask.Text.Trim() <> String.Empty Then
                NroDoc = txtNroDocSinMask.Text
            End If

            If txtNumeroDocumento.Text.Trim() <> String.Empty Then
                NroDoc = txtNumeroDocumento.Text
            ElseIf (txtNroDocSinMask.Text.Trim() <> String.Empty) Then
                NroDoc = txtNroDocSinMask.Text
            End If

            If (txtNumeroDocumento.Text.Trim() = "DO-__-______") Then
                NroDoc = String.Empty
            End If

            CargarSolicitudes(sol, ddlTipoDocumento.SelectedValue, NroDoc)

        End If

    End Sub

    Private Sub CargarSolicitudes(ByVal solicitud As String, ByVal tipoDocumento As String, ByVal documento As String)
        Dim repSolicitud As New SuirPlusEF.Repositories.SolicitudNSSRepository()
        Dim lote As String = String.Empty
        Dim registro As String = String.Empty
        Dim sol = repSolicitud.GetSolicitud(solicitud, tipoDocumento, documento, lote, registro, pageNum, PageSize)
        If sol IsNot Nothing Then
            If sol.Rows.Count > 0 Then
                gvSolicitudGeneral.DataSource = sol
                gvSolicitudGeneral.DataBind()
                gvSolicitudGeneral.Visible = True
                lblMensajeError.Text = String.Empty
                pnlNavegacion.Visible = True
                lblTotalRegistros.Text = sol.Rows(0)("RECORDCOUNT")
                lblTotalRegistros.Visible = True
            Else
                lblMensajeError.Text = "No existe registro"
                lblMensajeError.Visible = True
                gvSolicitudGeneral.Visible = False
                pnlNavegacion.Visible = False
                lblTotalRegistros.Visible = False
            End If
        Else
            lblMensajeError.Text = "No existe registro"
            lblMensajeError.Visible = True
            gvSolicitudGeneral.Visible = False
            pnlNavegacion.Visible = False
            lblTotalRegistros.Visible = False
        End If
        sol = Nothing
        setNavigation()

    End Sub
    Protected Sub gvSolicitudGeneral_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSolicitudGeneral.RowDataBound
        Dim BtnCertificacion As Button = CType(e.Row.FindControl("btnCertificacion"), Button)
        Dim ImgCertificacion As ImageButton = CType(e.Row.FindControl("ibCertificacion"), ImageButton)
        Dim ImgSolicitud As ImageButton = CType(e.Row.FindControl("ibImagen"), ImageButton)
        Dim curCulture As CultureInfo = Thread.CurrentThread.CurrentCulture
        Dim tInfo As TextInfo = curCulture.TextInfo()
        Dim Solicitud As New DetalleSolicitudes()
        Dim repDetSolicitud As New Repositories.DetalleSolicitudesRepository()

        Try
            'Verificamos si la columna 
            If e.Row.RowType = DataControlRowType.DataRow Then
                'validamos si tiene una imagen en la solicitud para mostrar el boton
                Solicitud = repDetSolicitud.GetBySolicitud(e.Row.Cells(0).Text)
                If Solicitud.IMAGEN_SOLICITUD IsNot Nothing Then
                    ImgSolicitud.Visible = True
                Else
                    ImgSolicitud.Visible = False
                End If

                If ((e.Row.Cells(1).Text.ToUpper() = "TRABAJADOR EXTRANJERO") Or (e.Row.Cells(1).Text.ToUpper() = "DEPENDIENTE TRABAJADOR EXTRANJERO")) Then
                    If (Solicitud.IdNSSAsignado IsNot Nothing) And (Solicitud.IdEstatus = AsignacionNSS.EstatusSolicitudNSSEnum.NSS_Asignado Or Solicitud.IdEstatus = AsignacionNSS.EstatusSolicitudNSSEnum.NSS_Existe Or Solicitud.IdEstatus = AsignacionNSS.EstatusSolicitudNSSEnum.Registro_Actualizado) Then
                        If Solicitud.IdCertificacion IsNot Nothing Then
                            Dim repCertificacion As New Repositories.CertificacionesRepository()
                            Dim certificacion As New Models.Certificaciones()
                            certificacion = repCertificacion.GetByIdCertificacion(Solicitud.IdCertificacion)

                            If certificacion.PdfCertificacion IsNot Nothing Then
                                BtnCertificacion.Visible = False
                                ImgCertificacion.Visible = True
                            Else
                                BtnCertificacion.Visible = True
                                ImgCertificacion.Visible = False
                            End If
                        Else
                            BtnCertificacion.Visible = True
                            ImgCertificacion.Visible = False
                        End If

                    Else
                        BtnCertificacion.Visible = False
                        ImgCertificacion.Visible = False
                    End If

                Else
                    BtnCertificacion.Visible = False
                    ImgCertificacion.Visible = False
                End If

            End If
        Catch ex As Exception
            Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Private Sub gvSolicitudGeneral_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSolicitudGeneral.RowCommand


        Dim registro As String = String.Empty
        Dim nss As Int32

        If e.CommandName = "VerSol" Then
            registro = e.CommandArgument.ToString
            Dim script As String = "<script Language=JavaScript>" + "window.open('ImagenSolicitud.aspx?registro=" & registro & "')</script>"
            Me.ClientScript.RegisterStartupScript(Me.GetType, "popup", script)
            Return
        End If

        Dim tipoCert = Empresas.Certificaciones.setTipoCertificacion(88)
        Dim myCert = New Empresas.Certificaciones(tipoCert)

        If e.CommandName = "Crear" Then
            Dim Cert() As String = e.CommandArgument.ToString.Split(",")
            registro = Cert(0)
            nss = Cert(1)
            myCert.NSS = nss
            myCert.Crear(UsrUserName)

            If myCert.NoCertificacion IsNot Nothing Then

                Dim repDetalleSol As New Repositories.DetalleSolicitudesRepository()
                Dim DetalleSol As New DetalleSolicitudes()

                DetalleSol = repDetalleSol.GetByRegistro(registro)
                DetalleSol.IdCertificacion = myCert.Numero
                DetalleSol.UltimaFechaActualizacion = DateTime.Now
                DetalleSol.UltimoUsuarioActualiza = UsrUserName
                repDetalleSol.Update(DetalleSol)

                lblmensaje.Text = "Su certificación fue generada de manera satistactoria, puede visualizarla dando click en la imagen de certificación."
                lblmensaje.Visible = True

            End If

            Dim row As GridViewRow = CType(CType(e.CommandSource, Control).NamingContainer, GridViewRow)
            Dim imgCer = row.FindControl("ibCertificacion")
            Dim btnCer = row.FindControl("btnCertificacion")
            imgCer.Visible = True
            btnCer.Visible = False

        ElseIf e.CommandName = "VerCer" Then

            Dim id_certificacion As String = String.Empty
            Dim repDetalleSol As New Repositories.DetalleSolicitudesRepository()
            Dim DetalleSol As New DetalleSolicitudes()

            registro = e.CommandArgument.ToString
            DetalleSol = repDetalleSol.GetByRegistro(registro)
            id_certificacion = DetalleSol.IdCertificacion

            Dim b, c, d As String
            b = String.Empty
            c = String.Empty
            d = String.Empty

            Dim random = New Random(DateTime.Now.Millisecond)
            Dim rand As Random = New Random()
            Dim letras = Enumerable.Range(0, 20).Select(Function(i) (Chr(Asc("A") + rand.Next(0, 26)))).OrderBy(Function(x) random.Next()).ToList()
            Dim letras2 = Enumerable.Range(20, 40).Select(Function(i) (Chr(Asc("A") + rand.Next(0, 26)))).OrderBy(Function(x) random.Next()).ToList()
            Dim letras3 = Enumerable.Range(40, 60).Select(Function(i) (Chr(Asc("A") + rand.Next(0, 26)))).OrderBy(Function(x) random.Next()).ToList()

            For Each l As String In letras
                b = b & l
            Next

            For Each l As String In letras2
                c = c & l
            Next

            For Each l As String In letras3
                d = d & l
            Next

            Dim Resultado = Convert.ToBase64String(Encoding.ASCII.GetBytes(id_certificacion.ToString().ToCharArray()))
            Dim script As String = "<script Language=JavaScript>" + "window.open('../sys/ImpCertificacion.aspx?A=" + Resultado + "&b=" + b + "&C=" + c + "&D=" + d + "')</script>"
            Me.ClientScript.RegisterStartupScript(Me.GetType, "popup", script)

        End If

    End Sub
    Private Sub ddlTipoDocumento_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlTipoDocumento.SelectedIndexChanged

        If ddlTipoDocumento.SelectedValue = "I" Then
            Dim tipoDocumento As TipoDocumento = New TipoDocumento()
            Dim repTipoDocumento As SuirPlusEF.Repositories.TipoDocumentoRepository = New Repositories.TipoDocumentoRepository()

            tipoDocumento = repTipoDocumento.GetByIdTipoDocumento(ddlTipoDocumento.SelectedValue.ToString())
            txtNumeroDocumento.Visible = True
            txtNroDocSinMask.Visible = False
            txtNumeroDocumento.Text = String.Empty
            maskNroDocumento.Mask = tipoDocumento.Mascara
            txtNumeroDocumento.Focus()
            maskNroDocumento.ClearMaskOnLostFocus = False

        Else
            maskNroDocumento.Mask = "99999999999"
            txtNumeroDocumento.Visible = False
            txtNroDocSinMask.Visible = True
            txtNumeroDocumento.Text = String.Empty
            txtNroDocSinMask.Text = String.Empty
            txtNroDocSinMask.Focus()
            maskNroDocumento.ClearMaskOnLostFocus = False
        End If

    End Sub

    Private Sub setNavigation()

        Dim totalRecords As Integer = 0

        If IsNumeric(Me.lblTotalRegistros.Text) Then
            totalRecords = CInt(Me.lblTotalRegistros.Text)
        End If

        Dim totalPages As Double = Math.Ceiling(Convert.ToDouble(totalRecords) / PageSize)

        If totalRecords = 1 Or totalPages = 0 Then
            totalPages = 1
        End If

        If PageSize > totalRecords Then
            PageSize = Int16.Parse(totalPages)
        End If

        Me.lblCurrentPage.Text = pageNum
        Me.lblTotalPages.Text = totalPages

        If pageNum = 1 Then
            Me.btnLnkFirstPage.Enabled = False
            Me.btnLnkPreviousPage.Enabled = False
        Else
            Me.btnLnkFirstPage.Enabled = True
            Me.btnLnkPreviousPage.Enabled = True
        End If

        If pageNum = totalPages Then
            Me.btnLnkNextPage.Enabled = False
            Me.btnLnkLastPage.Enabled = False
        Else
            Me.btnLnkNextPage.Enabled = True
            Me.btnLnkLastPage.Enabled = True
        End If

    End Sub

    Protected Sub NavigationLink_Click(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First"
                pageNum = 1
            Case "Last"
                pageNum = Convert.ToInt32(lblTotalPages.Text)
            Case "Next"
                pageNum = Convert.ToInt32(lblCurrentPage.Text) + 1
            Case "Prev"
                pageNum = Convert.ToInt32(lblCurrentPage.Text) - 1
        End Select

        btnBuscar_Click(Nothing, Nothing)
    End Sub

End Class
