Imports SuirPlus
Imports SuirPlus.SolicitudesEnLinea
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios
Imports System.Data

Partial Class Solicitudes_EstadodeCuenta
    Inherits BasePage

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents lblRazonSocial As System.Web.UI.WebControls.Label
    'Protected WithEvents lblNombreComercial As System.Web.UI.WebControls.Label
    'Protected WithEvents lblCedRepresentante As System.Web.UI.WebControls.Label
    'Protected WithEvents lblRepresentante As System.Web.UI.WebControls.Label
    'Protected WithEvents gvTSS As System.Web.UI.WebControls.DataGrid
    'Protected WithEvents gvDGII As System.Web.UI.WebControls.DataGrid
    'Protected WithEvents gvIR17 As System.Web.UI.WebControls.DataGrid
    'Protected WithEvents btnCancelar As System.Web.UI.WebControls.Button
    'Protected WithEvents btFax As System.Web.UI.WebControls.Button
    'Protected WithEvents btEmail As System.Web.UI.WebControls.Button
    'Protected WithEvents btActFax As System.Web.UI.WebControls.Button
    'Protected WithEvents pnlFax As System.Web.UI.WebControls.Panel
    'Protected WithEvents btActEmail As System.Web.UI.WebControls.Button
    'Protected WithEvents txtConfirmacion As System.Web.UI.WebControls.TextBox
    'Protected WithEvents CompareValidator1 As System.Web.UI.WebControls.CompareValidator
    'Protected WithEvents RegularExpressionValidator3 As System.Web.UI.WebControls.RegularExpressionValidator
    'Protected WithEvents txtNuevoCorreo As System.Web.UI.WebControls.TextBox
    'Protected WithEvents pnlEmail As System.Web.UI.WebControls.Panel
    'Protected WithEvents lblSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents lblMensaje As System.Web.UI.WebControls.Label
    'Protected WithEvents lblRNC As System.Web.UI.WebControls.Label
    'Protected WithEvents txtFax As System.Web.UI.WebControls.TextBox
    'Protected WithEvents txtFaxComentario As System.Web.UI.WebControls.TextBox
    'Protected WithEvents txtEmailComentario As System.Web.UI.WebControls.TextBox
    'Protected WithEvents lblTextoEmail As System.Web.UI.WebControls.Label
    'Protected WithEvents lblAdios As System.Web.UI.WebControls.Label
    'Protected WithEvents lblCorreoActual As System.Web.UI.WebControls.Label
    'Protected WithEvents lblDeseo As System.Web.UI.WebControls.Label

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
        InicializaFromSession()
    End Sub

#End Region

    '  Protected WithEvents ctrlFax As UCTelefono
    Private totalNot As Double = 0
    Private totalLiq As Double = 0
    Private totalIR As Double = 0

    Private Sub InicializaFromSession()

        If Convert.ToString(Session("RNCEmpleador")) = String.Empty Or _
        Convert.ToString(Session("IdTipoSolicitud")) = String.Empty Or _
        Convert.ToString(Session("CedulaRepresentate")) = String.Empty Then
            Response.Redirect("Solicitudes.aspx")
        End If

    End Sub

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.lblAdios.Text = MyBase.UsrNombreCompleto & " le asistió tenga un feliz resto del día!"

        If Not Page.IsPostBack Then
            cargarInfo()
        End If

    End Sub

    Private Sub cargarInfo()

        Me.lblSolicitud.Text = Session("TipoSolcitud")
        Me.lblRNC.Text = Session("RNCEmpleador").ToString
        Me.lblCedRepresentante.Text = Utils.FormatearCedula(Session("CedulaRepresentate"))
        Me.lblRepresentante.Text = Utilitarios.TSS.getNombreCiudadano("C", Session("CedulaRepresentate"))
        Dim emp As New Empleador(Convert.ToString(Session("RNCEmpleador")))
        Me.lblRazonSocial.Text = emp.RazonSocial
        Me.lblNombreComercial.Text = emp.NombreComercial
        mostrarGrid()

    End Sub

    Private Sub mostrarGrid()
        Dim dtTSS As DataTable = SuirPlus.Empresas.Facturacion.Factura.getNotificacionesPendientePago(SuirPlus.Empresas.Facturacion.Factura.eConcepto.SDSS, Me.lblRNC.Text)
        Dim dtISR As DataTable = SuirPlus.Empresas.Facturacion.Factura.getNotificacionesPendientePago(SuirPlus.Empresas.Facturacion.Factura.eConcepto.ISR, Me.lblRNC.Text)
        Dim dtIR17 As DataTable = SuirPlus.Empresas.Facturacion.Factura.getNotificacionesPendientePago(SuirPlus.Empresas.Facturacion.Factura.eConcepto.IR17, Me.lblRNC.Text)

        If SuirPlus.Utilitarios.Utils.HayErrorEnDataTable(dtTSS) = False Then

            Me.gvTSS.Visible = True
            Me.gvTSS.DataSource = dtTSS
            Me.gvTSS.DataBind()
        Else
            Response.Write(SuirPlus.Utilitarios.Utils.sacarMensajeDeErrorDesdeTabla(dtTSS))
        End If


        If SuirPlus.Utilitarios.Utils.HayErrorEnDataTable(dtISR) = False Then
            Me.gvDGII.Visible = True
            Me.gvDGII.DataSource = dtISR
            Me.gvDGII.DataBind()
        Else
            Response.Write(SuirPlus.Utilitarios.Utils.sacarMensajeDeErrorDesdeTabla(dtISR))
        End If


        If SuirPlus.Utilitarios.Utils.HayErrorEnDataTable(dtIR17) = False Then
            Me.gvIR17.Visible = True
            Me.gvIR17.DataSource = dtIR17
            Me.gvIR17.DataBind()
        Else
            Response.Write(SuirPlus.Utilitarios.Utils.sacarMensajeDeErrorDesdeTabla(dtIR17))
        End If
    End Sub

    Private Sub btEmail_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btEmail.Click

        Me.pnlEmail.Visible = True
        Me.pnlFax.Visible = False
        Me.lblDeseo.Visible = False

        Try
            Dim rep As New Representante(Me.lblRNC.Text, Convert.ToString(Session("CedulaRepresentate")))
            Me.lblCorreoActual.Text = rep.Email

            If Me.lblCorreoActual.Text.Length <= 1 Then
                Me.lblCorreoActual.Text = "No tiene, favor cambiarlo. "
            End If

        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub btFax_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btFax.Click

        Me.pnlEmail.Visible = False
        Me.pnlFax.Visible = True
        Me.lblDeseo.Visible = False

        Dim emp As New SuirPlus.Empresas.Empleador(Me.lblRNC.Text)
        Me.ctrlFax.PhoneNumber = emp.Fax
        Me.txtFax.Text = emp.Fax
        Me.txtFax.Visible = False

    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        If (Me.pnlEmail.Visible = True) Or (Me.pnlFax.Visible = True) Then
            cargarInfo()
            Me.pnlEmail.Visible = False
            Me.pnlFax.Visible = False
        Else

            Response.Redirect("Solicitudes.aspx")
        End If


    End Sub

    Private Sub btActFax_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btActFax.Click
        EnviarSolPorFax()
    End Sub

    Private Sub btActEmail_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btActEmail.Click
        EnviarSolPorEmail()
    End Sub

    'Procedimiento que genera una solicitud, actualizando el correo electronico.
    Protected Sub EnviarSolPorEmail()

        If Me.lblCorreoActual.Text = String.Empty And Me.txtNuevoCorreo.Text = String.Empty Then
            Me.lblMensaje.Text = "El correo electrónico es requerido en esta solicitud."
            Exit Sub
        End If

        If Me.txtNuevoCorreo.Text <> Me.txtConfirmacion.Text Then
            Me.lblMensaje.Text = "La confirmación del correo debe ser igual al nuevo correo."
            Exit Sub
        End If

        Dim idTipoSolicitud As String = Session("IdTipoSolicitud")
        Dim cedulaRep As String = Session("CedulaRepresentate")
        Dim idSolicitud As String = String.Empty

        Try
            idSolicitud = SolicitudesEnLinea.Solicitudes.crearSolicitud(idTipoSolicitud, 0, Me.lblRNC.Text, cedulaRep, MyBase.UsrUserName, "E: " & Me.lblCorreoActual.Text & " - " & txtEmailComentario.Text)
            If idSolicitud.Split("|")(0) = "0" Then

                Dim rep As New Representante(Me.lblRNC.Text, Session("CedulaRepresentate"))
                rep.FacturaXEmail = "S"
                If Not Me.txtNuevoCorreo.Text = String.Empty Then
                    'Actualizamos el correo del reprentante.
                    rep.Email = Me.txtNuevoCorreo.Text
                End If

                rep.GuardarCambios(MyBase.UsrUserName)

                'Confirmamos.
                Response.Redirect("confirmacion.aspx?id=" & idSolicitud.Split("|")(1))
            Else
                Me.lblMensaje.Text = idSolicitud.Split("|")(1)
            End If

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Response.Redirect("error.aspx?errMsg=" & ex.ToString())
        End Try

    End Sub

    Protected Sub EnviarSolPorFax()

        If Me.ctrlFax.PhoneNumber = String.Empty Then
            Me.lblMensaje.Text = "El Nro. de fax es requerido en esta solicitud."
            Exit Sub
        End If

        Dim idTipoSolicitud As String = Session("IdTipoSolicitud")
        Dim cedulaRep As String = Session("CedulaRepresentate")
        Dim fax As String = ctrlFax.PhoneNumber
        Dim idSolicitud As String = String.Empty

        Try
            idSolicitud = SolicitudesEnLinea.Solicitudes.crearSolicitud(idTipoSolicitud, 0, Me.lblRNC.Text, cedulaRep, MyBase.UsrUserName, "F: " & fax & " -" & txtFaxComentario.Text)
            If idSolicitud.Split("|")(0) = "0" Then

                If Me.txtFax.Text <> ctrlFax.PhoneNumber Then
                    'Actualizamos el fax del empleador.
                    Dim emp As New Empleador(Me.lblRNC.Text)
                    emp.Fax = ctrlFax.PhoneNumber.Replace("-", "")
                    emp.GuardarCambios(MyBase.UsrUserName)
                End If
                'Confirmamos
                Response.Redirect("confirmacion.aspx?id=" & idSolicitud.Split("|")(1))
            Else
                Me.lblMensaje.Text = idSolicitud.Split("|")(1)
            End If

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Response.Redirect("error.aspx?errMsg=" & ex.ToString())
        End Try

    End Sub

    'Private Sub gvTSS_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles gvTSS.ItemDataBound
    '    If (e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem) Then
    '        totalNot = totalNot + e.Item.Cells(3).Text
    '    ElseIf e.Item.ItemType = ListItemType.Footer Then
    '        e.Item.Cells(2).Text = "Total: "
    '        e.Item.Cells(2).HorizontalAlign = HorizontalAlign.Right
    '        e.Item.Cells(2).Font.Bold = True
    '        e.Item.Cells(3).Text = String.Format("{0:c}", totalNot)
    '        e.Item.Cells(3).HorizontalAlign = HorizontalAlign.Right
    '        e.Item.Cells(3).Font.Bold = True
    '    End If
    'End Sub

    'Private Sub gvDGII_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles gvDGII.ItemDataBound

    '    If (e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem) Then
    '        totalLiq = totalLiq + e.Item.Cells(3).Text
    '    ElseIf e.Item.ItemType = ListItemType.Footer Then
    '        e.Item.Cells(2).Text = "Total: "
    '        e.Item.Cells(2).HorizontalAlign = HorizontalAlign.Right
    '        e.Item.Cells(2).Font.Bold = True
    '        e.Item.Cells(3).Text = String.Format("{0:c}", totalLiq)
    '        e.Item.Cells(3).HorizontalAlign = HorizontalAlign.Right
    '        e.Item.Cells(3).Font.Bold = True
    '    End If

    'End Sub

    'Private Sub gvIR17_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles gvIR17.ItemDataBound

    '    If (e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem) Then
    '        totalIR = totalIR + e.Item.Cells(3).Text
    '    ElseIf e.Item.ItemType = ListItemType.Footer Then
    '        e.Item.Cells(2).Text = "Total: "
    '        e.Item.Cells(2).HorizontalAlign = HorizontalAlign.Right
    '        e.Item.Cells(2).Font.Bold = True
    '        e.Item.Cells(3).Text = String.Format("{0:c}", totalIR)
    '        e.Item.Cells(3).HorizontalAlign = HorizontalAlign.Right
    '        e.Item.Cells(3).Font.Bold = True
    '    End If

    'End Sub

    Protected Sub gvTSS_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvTSS.RowDataBound

        If (e.Row.RowType = DataControlRowType.DataRow) Then
            totalNot = totalNot + e.Row.Cells(3).Text
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(2).Text = "Total: "
            e.Row.Cells(2).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(2).Font.Bold = True
            e.Row.Cells(3).Text = String.Format("{0:c}", totalNot)
            e.Row.Cells(3).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(3).Font.Bold = True
        End If

    End Sub

    Protected Sub gvDGII_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDGII.RowDataBound

        If (e.Row.RowType = DataControlRowType.DataRow) Then
            totalLiq = totalLiq + e.Row.Cells(3).Text
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(2).Text = "Total: "
            e.Row.Cells(2).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(2).Font.Bold = True
            e.Row.Cells(3).Text = String.Format("{0:c}", totalLiq)
            e.Row.Cells(3).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(3).Font.Bold = True
        End If
    End Sub

    Protected Sub gvIR17_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvIR17.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            totalIR = totalIR + e.Row.Cells(3).Text
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(2).Text = "Total: "
            e.Row.Cells(2).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(2).Font.Bold = True
            e.Row.Cells(3).Text = String.Format("{0:c}", totalIR)
            e.Row.Cells(3).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(3).Font.Bold = True
        End If
    End Sub
End Class
