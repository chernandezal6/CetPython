Imports SuirPlus
Imports System.Data
Imports System.Net.Mail
Imports System.IO

Partial Class ManejoEmpleador
    Inherits BasePage

    Private totalNot As Decimal
    Private recargoNOT As Decimal
    Private ImporteNOT As Decimal
    Private InteresesNOT As Decimal


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

    Public Property PageSize() As Int16
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

    Public Property ID_Cartera() As Integer
        Get
            Return ViewState("IDCartera")
        End Get
        Set(ByVal value As Integer)
            ViewState("IDCartera") = value
        End Set
    End Property

    Public Property RNC() As String
        Get
            Return ViewState("RNC")
        End Get
        Set(ByVal value As String)
            ViewState("RNC") = value
        End Set
    End Property

    Public Property NO() As Integer
        Get
            Return ViewState("NO")
        End Get
        Set(ByVal value As Integer)
            ViewState("NO") = value
        End Set
    End Property

    Public Property Total() As Integer
        Get
            Return ViewState("Total")
        End Get
        Set(ByVal value As Integer)
            ViewState("Total") = value
        End Set
    End Property

    Public Property RegPatronal() As String
        Get
            Return ViewState("RegPatronal")
        End Get
        Set(ByVal value As String)
            ViewState("RegPatronal") = value
        End Set
    End Property

#Region "Paginación"

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

        LoadData()

    End Sub

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Not IsNothing(Request.QueryString("ID")) And Not IsNothing(Request.QueryString("IR")) Then
                Me.ID_Cartera = Request.QueryString("ID")
                Me.RNC = Request.QueryString("IR")
                Me.NO = Request.QueryString("NO")
                Me.Total = Request.QueryString("TO")
                LoadData()
                LoadNotificaciones("VE")
                LoadNotificaciones("PA")
                cargarRepresentante()
            End If
        End If
    End Sub


    Protected Sub LoadNotificaciones(ByVal status As String)

        Try

            Dim dtTSS As DataTable

            dtTSS = Empresas.Facturacion.Factura.getNotificaciones(SuirPlus.Empresas.Facturacion.Factura.eConcepto.SDSS, Me.RNC, "6321", status)

            If status = "VE" Then
                Me.lblCantidadVencidas.Text = "Cantidad de Notificaciones : " & dtTSS.Rows.Count

                Me.dgNotificaciones.DataSource = dtTSS
                Me.dgNotificaciones.DataBind()
            Else
                Me.lblCantidadPagadas.Text = "Cantidad de Notificaciones : " & dtTSS.Rows.Count

                Me.gvPagadas.DataSource = dtTSS
                Me.gvPagadas.DataBind()
            End If

            
        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message

        End Try
    End Sub

    Private Sub LoadData()

        Dim emp As New Empresas.Empleador(Me.RNC)
        Me.lblRNC.Text = formateaRNC(emp.RNCCedula)
        Me.lblRegistro.Text = emp.RegistroPatronal
        Me.RegPatronal = emp.RegistroPatronal
        Me.lblRazonSocial.Text = emp.RazonSocial
        Me.lblNombreComercial.Text = emp.NombreComercial

        If emp.Provincia = "Distrito Nacional" Or emp.Provincia = "Santo Domingo" Then
            Me.lblTelefono1.Text = "<a href='sip:9" & emp.Telefono1 & "'>" & Utilitarios.Utils.FormatearTelefono(emp.Telefono1) & "</a>"
        Else
            chkTel1.Checked = True
            Me.lblTelefono1.Text = "<a href='sip:91" & emp.Telefono1 & "'>" & "1 " & Utilitarios.Utils.FormatearTelefono(emp.Telefono1) & "</a>"
        End If

        Me.ucTelefono1.phoneNumber = emp.Telefono1
        Me.ucTelefono2.phoneNumber = emp.Telefono2


        If Not emp.Telefono2 = " " Then
            If emp.Provincia = "Distrito Nacional" Or emp.Provincia = "Santo Domingo" Then
                Me.lblTelefono2.Text = "<a href='sip:9" & emp.Telefono2 & "'>" & Utilitarios.Utils.FormatearTelefono(emp.Telefono2) & "</a>"
            Else
                chkTel2.Checked = True
                Me.lblTelefono2.Text = "<a href='sip:91" & emp.Telefono2 & "'>" & "1 " & Utilitarios.Utils.FormatearTelefono(emp.Telefono2) & "</a>"
            End If
        Else
            chkTel2.Visible = False
        End If

        Me.ucFax.phoneNumber = Utilitarios.Utils.FormatearTelefono(emp.Fax)
        Me.txtEmail.Text = emp.Email

        Me.lblDireccion.Text = emp.Calle & " " & emp.Numero & ", " & emp.Sector & ", " & emp.Provincia

        'Cargando los tipos Registros
        cargarCMRRegistros()

        'Cargando los Estatus
        LoadStatusCobro()


        'Cargando los CRM anteriores
        bindCRMDataList()


        'Cargando los Otros CRM anteriores
        bindOtrosCRMDataList()
    End Sub

    Protected Function FormatearPeriodo(ByVal periodo As String) As String

        Return Utilitarios.Utils.FormateaPeriodo(periodo)

    End Function

    Protected Function formateaRNC(ByVal rnc As String) As String

        If rnc = String.Empty Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormatearRNCCedula(rnc)
        End If

    End Function

    Protected Sub cargarCMRRegistros()

        'Cargando tipos de acciones
        Me.ddlTipoCaso.DataSource = Empresas.CRM.getTiposCRM(-1)
        Me.ddlTipoCaso.DataTextField = "TIPO_REGISTRO_DES"
        Me.ddlTipoCaso.DataValueField = "ID_TIPO_REGISTRO"
        Me.ddlTipoCaso.DataBind()
        Me.ddlTipoCaso.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))


        Dim tipo As String = "2"
        If Seguridad.Autorizacion.isInRol(UsrUserName, "318") Then tipo = "2"
        If Seguridad.Autorizacion.isInRol(UsrUserName, "298") Then tipo = "1"

        Me.ddlTipoCaso.SelectedValue = tipo

        Me.txtFechaNotificacion.Text = Date.Now.ToString
    End Sub

    Protected Sub bindCRMDataList()
        'Cargamos los ultimos registros
        Me.dlUltimosRegistros.DataSource = Empresas.CRM.getUtimosCRM(Me.RegPatronal, Me.ID_Cartera)
        Me.dlUltimosRegistros.DataBind()
    End Sub

    Protected Sub bindOtrosCRMDataList()
        'Cargamos los ultimos registros
        Me.dtOtrosCRM.DataSource = Empresas.CRM.getUtimosCRM(Me.RegPatronal)
        Me.dtOtrosCRM.DataBind()
    End Sub


    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        'Validaciones
        If Me.ddlTipoCaso.SelectedValue = "-1" Then
            Me.lblMensajeCRM.Text = "Debe seleccionar un tipo de caso."
            Exit Sub
        End If

        If Me.ddlStatusCobro.SelectedValue = "-1" Then
            Me.lblMensajeCRM.Text = "Debe seleccionar un estatus cobro"
            Exit Sub
        End If


        If String.IsNullOrEmpty(Me.txtContacto.Text) Then
            Me.lblMensajeCRM.Text = "Debe específicar el contacto."
            Exit Sub
        End If

        If String.IsNullOrEmpty(Me.txtDescripcion.Text) Then
            Me.lblMensajeCRM.Text = "Debe específicar la descripción"
            Exit Sub
        End If

        If Me.chkNotificame.Checked = True Then
            If String.IsNullOrEmpty(Me.txtFechaNotificacion.Text) Then
                Me.lblMensajeCRM.Text = "Debe específicar la fecha de notificación."
                Exit Sub
            End If
        End If

        Dim FechaNotificacion As Nullable(Of Date)
        If Me.chkNotificame.Checked Then
            FechaNotificacion = CDate(Me.txtFechaNotificacion.Text)
        Else
            FechaNotificacion = Nothing
        End If

        Try
            Dim str As String = Empresas.CRM.insertaRegistroCRMCobro(Me.RegPatronal, _
                                       Me.ddlStatusCobro.SelectedItem.Text, Integer.Parse(Me.ddlTipoCaso.SelectedValue), _
                                       Me.txtContacto.Text, Me.txtDescripcion.Text, Me.UsrUserName, _
                                       FechaNotificacion, _
                                       Me.txtMailAdic1.Text, Me.txtMailAdic2.Text, ddlStatusCobro.SelectedValue, Me.ID_Cartera)

            If Split(str, "|")(0) = "0" Then
                Me.lblMensajeCRM.CssClass = "subHeader"
                Me.lblMensajeCRM.Text = "El " + Split(str, "|")(1).ToString() + " registro fue insertado satisfactoriamente."
                LimpiarCRMRegistros()
                bindCRMDataList()
            Else
                Me.lblMensajeCRM.CssClass = "error"
                Me.lblMensajeCRM.Text = "Error: " + Split(str, "|")(1).ToString()
            End If
        Catch ex As Exception
            Me.lblMensajeCRM.CssClass = "error"
            Me.lblMensajeCRM.Text = ex.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub LimpiarCRMRegistros()
        Me.txtContacto.Text = String.Empty
        Me.txtDescripcion.Text = String.Empty
        Me.txtFechaNotificacion.Text = String.Empty
        Me.chkNotificame.Checked = False
        Me.txtMailAdic1.Text = String.Empty
        Me.txtMailAdic2.Text = String.Empty

    End Sub


    Private Sub LoadStatusCobro()

        Dim dt As New DataTable

        dt = Legal.Cobro.getStatusCobro()

        If dt.Rows.Count > 0 Then
            ddlStatusCobro.DataSource = dt
            ddlStatusCobro.DataTextField = "DESCRIPCION"
            ddlStatusCobro.DataValueField = "ID_STATUS_COBRO"
            ddlStatusCobro.DataBind()
            Me.ddlStatusCobro.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
        End If
    End Sub

  

    Protected Sub cargarRepresentante()

        Me.dtRepresentante.DataSource = Empresas.Representante.getRepresentante(-1, CInt(Me.RegPatronal))
        Me.dtRepresentante.DataBind()

    End Sub

    Protected Function formatCedula(ByVal cedula As Object) As String

        If cedula Is DBNull.Value Then
            Return String.Empty
        End If

        If cedula.ToString.Length = 11 Then
            Return SuirPlus.Utilitarios.Utils.FormatearCedula(cedula)
        Else
            Return cedula
        End If

    End Function

    Protected Function formatTelefono(ByVal telefono As Object) As String
        If telefono Is DBNull.Value Then
            Return String.Empty
        End If

        Return SuirPlus.Utilitarios.Utils.FormatearTelefono(telefono)


    End Function

    Protected Sub btnActualizar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnActualizar.Click
        EditDatos()
    End Sub


    Private Sub EditDatos()
        lblMensaje.Text = String.Empty

        Dim emp As New SuirPlus.Empresas.Empleador(Me.RNC)

        emp.Email = Me.txtEmail.Text
        emp.Telefono1 = Me.ucTelefono1.phoneNumber.Replace("-", "")
        emp.Telefono2 = Me.ucTelefono2.phoneNumber.Replace("-", "")
        emp.Fax = Me.ucFax.phoneNumber.Replace("-", "")

        emp.GuardarCambios(Me.UsrUserName)

        LoadData()

    End Sub

    Protected Sub imgAtras_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgAtras.Click
        GetLast()
    End Sub
    Protected Sub imgSiguiente_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgSiguiente.Click
        GetNext()
    End Sub

    Protected Sub GetNext()
        Dim dt As New DataTable

        Try
            If Me.NO <= 1 Then
                Me.NO = Me.Total
            Else
                Me.NO = Me.NO - 1

            End If

            dt = Legal.Cobro.getEmpresasAsignadas(Me.ID_Cartera, String.Empty, String.Empty, -1, Me.NO, 1)
            If dt.Rows.Count > 0 Then
                Response.Redirect("ManejoEmpleador.aspx?ID=" & ID_Cartera & "&IR=" & dt.Rows(0)("RNC_O_CEDULA") & "&NO=" & Me.NO & "&TO=" & dt.Rows(0)("RecordCount"))
            End If
        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
        End Try
    End Sub

    Protected Sub GetLast()
        Dim dt As New DataTable

        Try
            If Me.NO >= Me.Total Then
                Me.NO = 1
            Else
                Me.NO = Me.NO + 1

            End If

            dt = Legal.Cobro.getEmpresasAsignadas(Me.ID_Cartera, String.Empty, String.Empty, -1, Me.NO, 1)
            If dt.Rows.Count > 0 Then
                Response.Redirect("ManejoEmpleador.aspx?ID=" & ID_Cartera & "&IR=" & dt.Rows(0)("RNC_O_CEDULA") & "&NO=" & Me.NO & "&TO=" & dt.Rows(0)("RecordCount"))
            End If
        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
        End Try
    End Sub

    Public Overrides Sub VerifyRenderingInServerForm(control As Control)

    End Sub



    Private Sub SendMail()
        lblMensaje.Text = String.Empty

        Dim correo As String = txtEmail.Text

        If Not String.IsNullOrEmpty(correo) Then

            'tabla
            Dim mensaje As String = "Buenos Días Sres.: <b>" & IIf(String.IsNullOrEmpty(Me.lblNombreComercial.Text), Me.lblRazonSocial.Text, Me.lblNombreComercial.Text) & "</b><br/> <br/>"
            mensaje += "Por medio a la presente le informamos que la razón social " & Me.lblRazonSocial.Text & "  tiene las siguientes notificaciones de pago vencidas:<br/> <br/>"

            'Armando la tabla
            Dim sb As New StringBuilder()
            Dim sw As New StringWriter(sb)
            Dim hw As New HtmlTextWriter(sw)



            dgNotificaciones.RenderControl(hw)

            mensaje += sb.ToString()

            mensaje += "<br/> <br/>Sugerimos realicen pago en los próximos 3 días laborables. Para más información nos puede contactar al 809-472-6363. <br/> <br/>"
            mensaje += "Gracias por su colaboración."


            Dim message As New MailMessage()
            Dim smtp As New SmtpClient("prius")

            Try
                'from del mensaje
                message.From = New MailAddress("info@tss.gov.do")



                message.[To].Add(New MailAddress(correo))

                message.Subject = "Recordatorio de Pago SuirPlus"

                message.Body = mensaje

                message.IsBodyHtml = True


                smtp.Send(message)


                'Insertamos el CRM
                Dim FechaNotificacion As Nullable(Of Date)
                FechaNotificacion = Nothing

                Dim str As String = Empresas.CRM.insertaRegistroCRMCobro(Me.RegPatronal, _
                                           "Recordatorio de Pago SuirPlus", 2, _
                                           Me.txtContacto.Text, "Recordatorio  por Mail", Me.UsrUserName, _
                                           FechaNotificacion, _
                                           correo, String.Empty, "CO", Me.ID_Cartera)



                Response.Redirect("ManejoEmpleador.aspx?ID=" & Me.ID_Cartera & "&IR=" & Me.RNC & "&NO=" & Me.NO & "&TO=" & Me.Total)
            Catch ex As Exception
                lblMensaje.Text = ex.Message
            End Try
        Else
            lblMensaje.Text = "La empresa a la cual se le enviara el recordatorio debe tener un Email valido!!"
        End If
    End Sub

    'Protected Sub imgEnviar_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgEnviar.Click
    '    SendMail()
    'End Sub

    Protected Sub dgNotificaciones_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgNotificaciones.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            ImporteNOT = ImporteNOT + e.Row.Cells(6).Text
            recargoNOT = recargoNOT + e.Row.Cells(7).Text
            InteresesNOT = InteresesNOT + e.Row.Cells(8).Text
            totalNot = totalNot + e.Row.Cells(9).Text
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(5).Text = "Totales:&nbsp;"
            e.Row.Cells(5).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(6).Text = FormatNumber(ImporteNOT)
            e.Row.Cells(6).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(7).Text = FormatNumber(recargoNOT)
            e.Row.Cells(7).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(8).Text = FormatNumber(InteresesNOT)
            e.Row.Cells(8).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(9).Text = FormatNumber(totalNot)
            e.Row.Cells(9).HorizontalAlign = HorizontalAlign.Right
        End If
    End Sub

    Protected Sub chkTel1_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkTel1.CheckedChanged
        If chkTel1.Checked = False Then
            Me.lblTelefono1.Text = "<a href='sip:9" & ucTelefono1.phoneNumber & "'>" & Utilitarios.Utils.FormatearTelefono(ucTelefono1.phoneNumber) & "</a>"
        Else
            Me.lblTelefono1.Text = "<a href='sip:91" & ucTelefono1.phoneNumber & "'>" & "1 " & Utilitarios.Utils.FormatearTelefono(ucTelefono1.phoneNumber) & "</a>"
        End If
    End Sub

    Protected Sub chkTel2_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkTel2.CheckedChanged
        If chkTel2.Checked = False Then
            Me.lblTelefono2.Text = "<a href='sip:9" & ucTelefono2.phoneNumber & "'>" & Utilitarios.Utils.FormatearTelefono(ucTelefono2.phoneNumber) & "</a>"
        Else
            Me.lblTelefono2.Text = "<a href='sip:91" & ucTelefono2.phoneNumber & "'>" & "1 " & Utilitarios.Utils.FormatearTelefono(ucTelefono2.phoneNumber) & "</a>"
        End If
    End Sub
End Class
