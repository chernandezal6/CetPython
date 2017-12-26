Imports System.Globalization
Imports System.Threading
Imports SuirPlusEF
Imports SuirPlusEF.Models
Imports System.Data
Imports System.Drawing
Imports SuirPlus
Imports SuirPlusEF.Service

Partial Class Asignacion_NSS_ConsAsignacionRnc
    Inherits BasePage

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
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarEstatus()
        End If

        pageNum = 1
        PageSize = BasePage.PageSize
    End Sub
    Private Sub CargarEstatus()
        Try
            Dim Estatus As New SuirPlusEF.Repositories.EstatusNSSRepository()
            ddlEstatus.DataSource = Estatus.GetAllEstatus()
            ddlEstatus.DataTextField = "DESCRIPCION"
            ddlEstatus.DataValueField = "IdEstatus"
            ddlEstatus.DataBind()
            ddlEstatus.Items.Add(New ListItem("Seleccione", ""))
            ddlEstatus.SelectedValue = ""
        Catch ex As Exception
            Throw ex.InnerException
        End Try

    End Sub
    Private Sub llenarDataGridSolicitud()

        If ddlEstatus.SelectedValue <> "" And txtRnc.Text = String.Empty Then
            lblMensajeError.Text = "El RNC es obligatorio."
            lblMensajeError.Visible = True
            Return
        End If
        If ddlEstatus.SelectedValue = "" And txtRnc.Text = String.Empty Then
            lblMensajeError.Text = "Debe especificar al menos uno de los criterios de busqueda."
            lblMensajeError.Visible = True
            Return
        End If

        Dim repSolicitud As New Repositories.SolicitudNSSRepository()
        Dim sol = repSolicitud.GetSolicitudRnc(txtRnc.Text, ddlEstatus.SelectedValue, txtFechaDesde.Text, txtFechaHasta.Text, pageNum, PageSize)

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
    Private Sub btBuscar_Click(sender As Object, e As EventArgs) Handles btBuscar.Click
        llenarDataGridSolicitud()
    End Sub
    Private Sub btLimpiar_Click(sender As Object, e As EventArgs) Handles btLimpiar.Click
        Response.Redirect("ConsAsignacionRnc.aspx")
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

        btBuscar_Click(Nothing, Nothing)
    End Sub
    Private Sub gvSolicitudGeneral_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSolicitudGeneral.RowDataBound
        Dim BtnCertificacion As Button = CType(e.Row.FindControl("btnCertificacion"), Button)
        Dim ImgCertificacion As ImageButton = CType(e.Row.FindControl("ibCertificacion"), ImageButton)
        Dim ImgSolicitud As ImageButton = CType(e.Row.FindControl("ibImagen"), ImageButton)
        Dim Solicitud As New DetalleSolicitudes()
        Dim repDetSolicitud As New Repositories.DetalleSolicitudesRepository()

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
    End Sub
    Private Sub gvSolicitudGeneral_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSolicitudGeneral.RowCommand
        Dim solicitud As String = String.Empty
        Dim nss As Int32

        If e.CommandName = "VerSol" Then
            solicitud = e.CommandArgument.ToString
            Dim script As String = "<script Language=JavaScript>" + "window.open('ImagenSolicitud.aspx?solicitud=" & solicitud & "')</script>"
            Me.ClientScript.RegisterStartupScript(Me.GetType, "popup", script)
            Return
        End If

        Dim tipoCert = Empresas.Certificaciones.setTipoCertificacion(88)
        Dim myCert = New Empresas.Certificaciones(tipoCert)

        If e.CommandName = "Crear" Then
            Dim Cert() As String = e.CommandArgument.ToString.Split(",")
            solicitud = Cert(0)
            nss = Cert(1)
            myCert.NSS = nss
            myCert.Crear(UsrUserName)

            If myCert.NoCertificacion IsNot Nothing Then

                Dim repDetalleSol As New Repositories.DetalleSolicitudesRepository()
                Dim DetalleSol As New DetalleSolicitudes()

                DetalleSol = repDetalleSol.GetBySolicitud(solicitud)
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

            solicitud = e.CommandArgument.ToString
            DetalleSol = repDetalleSol.GetBySolicitud(solicitud)
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

    Protected Sub ucExportarExcel1_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel
        Dim dtExport As New DataTable
        Dim repSolicitud As New Repositories.SolicitudNSSRepository()
        dtExport = repSolicitud.GetSolicitudRnc(UsrRNC, ddlEstatus.SelectedValue, txtFechaDesde.Text, txtFechaHasta.Text, pageNum, PageSize)
        dtExport.Columns.Remove("RECORDCOUNT")
        Me.ucExportarExcel1.DataSource = dtExport
        Me.ucExportarExcel1.FileName = "SolicitudesNSS.xls"

    End Sub
End Class

