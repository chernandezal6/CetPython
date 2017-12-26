Imports SuirPlus
Imports SuirPlus.SolicitudesEnLinea
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios

Partial Class Solicitudes_CancelaFactura
    Inherits BasePage
#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents lblRNC As System.Web.UI.WebControls.Label
    'Protected WithEvents lblRazonSocial As System.Web.UI.WebControls.Label
    'Protected WithEvents lblContacto As System.Web.UI.WebControls.Label
    'Protected WithEvents btnAceptar As System.Web.UI.WebControls.Button
    'Protected WithEvents txtEmail As System.Web.UI.WebControls.TextBox
    'Protected WithEvents txtCargo As System.Web.UI.WebControls.TextBox
    'Protected WithEvents RequiredFieldValidator1 As System.Web.UI.WebControls.RequiredFieldValidator
    'Protected WithEvents RequiredFieldValidator2 As System.Web.UI.WebControls.RequiredFieldValidator
    'Protected WithEvents txtNotificacion1 As System.Web.UI.WebControls.TextBox
    'Protected WithEvents txtNotificacion2 As System.Web.UI.WebControls.TextBox
    'Protected WithEvents txtNotificacion3 As System.Web.UI.WebControls.TextBox
    'Protected WithEvents txtNotificacion4 As System.Web.UI.WebControls.TextBox
    'Protected WithEvents RequiredFieldValidator3 As System.Web.UI.WebControls.RequiredFieldValidator
    'Protected WithEvents ValidationSummary1 As System.Web.UI.WebControls.ValidationSummary
    'Protected WithEvents lblMensaje As System.Web.UI.WebControls.Label
    'Protected WithEvents lblSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents RegularExpressionValidator1 As System.Web.UI.WebControls.RegularExpressionValidator
    'Protected WithEvents txtNotificacion5 As System.Web.UI.WebControls.TextBox
    'Protected WithEvents txtNotificacion6 As System.Web.UI.WebControls.TextBox
    'Protected WithEvents txtNotificacion7 As System.Web.UI.WebControls.TextBox
    'Protected WithEvents txtNotificacion8 As System.Web.UI.WebControls.TextBox
    'Protected WithEvents txtMotivo As System.Web.UI.WebControls.TextBox
    'Protected WithEvents rbtnRecargos1 As System.Web.UI.WebControls.RadioButton
    'Protected WithEvents rbtnFactura1 As System.Web.UI.WebControls.RadioButton
    'Protected WithEvents rbtnRecargos2 As System.Web.UI.WebControls.RadioButton
    'Protected WithEvents rbtnRecargos3 As System.Web.UI.WebControls.RadioButton
    'Protected WithEvents rbtnRecargos4 As System.Web.UI.WebControls.RadioButton
    'Protected WithEvents rbtnRecargos5 As System.Web.UI.WebControls.RadioButton
    'Protected WithEvents rbtnRecargos7 As System.Web.UI.WebControls.RadioButton
    'Protected WithEvents rbtnRecargos8 As System.Web.UI.WebControls.RadioButton
    'Protected WithEvents rbtnRecargos6 As System.Web.UI.WebControls.RadioButton
    'Protected WithEvents rbtnFactura2 As System.Web.UI.WebControls.RadioButton
    'Protected WithEvents rbtnFactura3 As System.Web.UI.WebControls.RadioButton
    'Protected WithEvents rbtnFactura4 As System.Web.UI.WebControls.RadioButton
    'Protected WithEvents rbtnFactura5 As System.Web.UI.WebControls.RadioButton
    'Protected WithEvents rbtnFactura6 As System.Web.UI.WebControls.RadioButton
    'Protected WithEvents rbtnFactura7 As System.Web.UI.WebControls.RadioButton
    'Protected WithEvents rbtnFactura8 As System.Web.UI.WebControls.RadioButton

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

    'Protected WithEvents ctrlTelefono As UCTelefono
    'Protected WithEvents ctrlFax As UCTelefono

    Private Sub InicializaFromSession()

        If Convert.ToString(Session("RNCEmpleador")) = String.Empty Or _
        Convert.ToString(Session("IdTipoSolicitud")) = String.Empty Or _
        Convert.ToString(Session("CedulaRepresentate")) = String.Empty Then
            Response.Redirect("Solicitudes.aspx")
        End If

    End Sub

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Page.IsPostBack Then
            cargarInfo()
        End If
    End Sub

    Private Sub cargarInfo()

        Me.lblSolicitud.Text = Session("TipoSolcitud")
        Me.lblRNC.Text = Session("RNCEmpleador")

        Try
            Dim emp As New Empleador(Me.lblRNC.Text)
            Me.lblRazonSocial.Text = emp.RazonSocial
            Me.ctrlTelefono.PhoneNumber = emp.Telefono1
            Me.ctrlFax.PhoneNumber = emp.Fax
            'Me.txtEmail.Text = Convert.ToString(Session("CedulaRepresentate"))
            Dim rep As New Representante(Me.lblRNC.Text, Convert.ToString(Session("CedulaRepresentate")))
            Me.txtEmail.Text = rep.Email
            Me.lblContacto.Text = rep.NombreCompleto
        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub btnAceptar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        'Validamos que los datos requeridos para esta certificacion sean correctos.
        If Me.txtEmail.Text = String.Empty Then
            Me.lblMensaje.Text = "Edl email es requerido para esta solicitud"
            Exit Sub
        ElseIf Me.ctrlTelefono.PhoneNumber = String.Empty Then
            Me.lblMensaje.Text = "El teléfono es requerido para esta solicitud."
            Exit Sub
        ElseIf Me.txtNotificacion1.Text = String.Empty Then
            Me.lblMensaje.Text = "Al menos una notificación se debe específicar."
            Exit Sub
        ElseIf Not Me.rbtnFactura1.Checked And Not rbtnRecargos1.Checked Then
            Me.lblMensaje.Text = "favor específicar el tipo de cancelación (Recargo/Factura)"
            Exit Sub
        End If

        'Validamos que los nro. de notificacion puesto en los textbox sean validos.
        For i As Int16 = 1 To 8

            Dim txtNotificacion As TextBox = CType(Me.FindControl("txtNotificacion" & i.ToString()), TextBox)
            If Not txtNotificacion.Text = String.Empty Then

                'Si se cololo un nro. de referencia verificamos si se coloco lo que se desea cancelar.
                Dim rbtnRecargos As RadioButton = CType(Me.FindControl("rbtnRecargos" & i.ToString()), RadioButton)
                Dim rbtnFacturas As RadioButton = CType(Me.FindControl("rbtnFactura" & i.ToString()), RadioButton)

                If Not rbtnRecargos.Checked And Not rbtnFacturas.Checked Then
                    Me.lblMensaje.Text = "favor específicar el tipo de cancelación (Recargo/Factura) en la línea " & i.ToString()
                    Exit Sub
                End If

                'Verificamos que el Nro. de referencia sea valido
                If Not Facturacion.FacturaSS.isReferenciaValida(txtNotificacion.Text, Me.lblRNC.Text) Then
                    Me.lblMensaje.Text = "El Nro. de referencia de la línea " & i.ToString() & " es inválido."
                    Exit Sub
                End If

            End If

        Next

        'Insertamos la solicitud
        Try

            Dim idSolicitud As String = String.Empty
            idSolicitud = SolicitudesEnLinea.Solicitudes.crearCancelacion(5, Me.lblRNC.Text, _
             Me.lblContacto.Text, Me.txtCargo.Text, Me.ctrlTelefono.PhoneNumber.Replace("-", ""), "F", _
             Me.txtMotivo.Text, Nothing, Nothing, MyBase.UsrUserName, Me.ctrlFax.PhoneNumber.Replace("-", ""), Me.txtEmail.Text)


            'El idSolicitud viene acompañado de un error o un cero si todo marcho bien.
            If idSolicitud.Split("|")(0) = "0" Then

                idSolicitud = idSolicitud.Split("|")(1)
                Dim tipoCancelacion As String = String.Empty

                'Si la solicitud se creo correctamente insertamos el detalle.
                For i As Int16 = 1 To 8
                    Dim txtNotificacion As TextBox = CType(Me.FindControl("txtNotificacion" & i.ToString()), TextBox)
                    Dim rbtnRecargos As RadioButton = CType(Me.FindControl("rbtnRecargos" & i.ToString()), RadioButton)

                    If rbtnRecargos.Checked Then
                        tipoCancelacion = "R"
                    Else
                        tipoCancelacion = "F"
                    End If

                    SolicitudesEnLinea.Solicitudes.crearDetCancelacion(idSolicitud, txtNotificacion.Text, tipoCancelacion)

                Next

                Response.Redirect("confirmacion.aspx?id=" & idSolicitud)
            Else
                Me.lblMensaje.Text = idSolicitud.Split("|")(1)
            End If

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Response.Redirect("error.aspx?errMsg=" & ex.Message)
        End Try

    End Sub

End Class
