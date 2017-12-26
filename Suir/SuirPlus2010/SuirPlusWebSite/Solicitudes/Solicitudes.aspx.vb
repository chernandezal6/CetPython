Imports System.Text.RegularExpressions
Imports SuirPlus

Partial Class Solicitudes_Solicitudes
    Inherits BasePage

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents drpSolicitudes As System.Web.UI.WebControls.DropDownList
    'Protected WithEvents lblMsg As System.Web.UI.WebControls.Label
    'Protected WithEvents pnlButton As System.Web.UI.WebControls.Panel
    'Protected WithEvents HyperLink2 As System.Web.UI.WebControls.HyperLink
    'Protected WithEvents HyperLink1 As System.Web.UI.WebControls.HyperLink
    'Protected WithEvents lblMensajeBienvenida As System.Web.UI.WebControls.Label
    'Protected WithEvents btnAceptar As System.Web.UI.WebControls.Button
    'Protected WithEvents RegularExpressionValidator2 As System.Web.UI.WebControls.RegularExpressionValidator
    'Protected WithEvents RequiredFieldValidator1 As System.Web.UI.WebControls.RequiredFieldValidator
    'Protected WithEvents txtCedula As System.Web.UI.WebControls.TextBox
    'Protected WithEvents lblNombreCedula As System.Web.UI.WebControls.Label
    'Protected WithEvents pnlCedula As System.Web.UI.WebControls.Panel
    'Protected WithEvents RegularExpressionValidator1 As System.Web.UI.WebControls.RegularExpressionValidator
    'Protected WithEvents RequiredFieldValidator2 As System.Web.UI.WebControls.RequiredFieldValidator
    'Protected WithEvents txtRnc As System.Web.UI.WebControls.TextBox
    'Protected WithEvents pnlRNC As System.Web.UI.WebControls.Panel
    'Protected WithEvents drpOficinas As System.Web.UI.WebControls.DropDownList
    'Protected WithEvents pnlOficinas As System.Web.UI.WebControls.Panel
    'Protected WithEvents drpTipoCertificacion As System.Web.UI.WebControls.DropDownList
    'Protected WithEvents pnlCertificaciones As System.Web.UI.WebControls.Panel
    'Protected WithEvents lblCedula As System.Web.UI.WebControls.Label
    'Protected WithEvents btAyudaRNC As System.Web.UI.WebControls.Button
    'Protected WithEvents btAyudaCedula As System.Web.UI.WebControls.Button
    'Protected WithEvents txtSalario As System.Web.UI.WebControls.TextBox
    'Protected WithEvents RequiredFieldValidator3 As System.Web.UI.WebControls.RequiredFieldValidator
    'Protected WithEvents pnlSalario As System.Web.UI.WebControls.Panel
    'Protected WithEvents RegularExpressionValidator3 As System.Web.UI.WebControls.RegularExpressionValidator
    'Protected WithEvents pnlProvincia As System.Web.UI.WebControls.Panel
    'Protected WithEvents drpProvincia As System.Web.UI.WebControls.DropDownList

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Page.IsPostBack Then
            bindTiposSolicitud()
        End If

        If Not Request.QueryString("ID") = String.Empty Then
            Try
                Me.drpSolicitudes.SelectedValue = Request.QueryString("ID")
                If Not Page.IsPostBack Then
                    Me.reordernarPanel()
                End If
            Catch ex As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                Response.Redirect("solicitudIntro.aspx")
            End Try
        Else
            Response.Redirect("solicitudIntro.aspx")
        End If



        Dim mens As String

        If Now.Hour <= 11 Then
            mens = "Buenos días, " & MyBase.UsrNombreCompleto() & " le asiste. ¿En que puedo servirle? "
        Else
            mens = "Buenas tardes, " & MyBase.UsrNombreCompleto() & " le asiste. ¿En que puedo servirle? "
        End If

        ' Me.btAyudaCedula.Attributes.Add("OnClick", "window.open('../Solicitudes/Ayuda.aspx?H=2', 'myWin', 'width=405,height=250,toolbar=0,resizable=0');")
        Me.btAyudaRNC.Attributes.Add("OnClick", "window.open('../Solicitudes/Ayuda.aspx?H=1', 'myWin', 'width=405,height=250,toolbar=0,resizable=0');")
        Me.lblMensajeBienvenida.Text = mens
    End Sub

    Protected Sub bindTiposSolicitud()

        Me.drpSolicitudes.DataSource = SolicitudesEnLinea.Solicitudes.getTiposSolicitudes()
        Me.drpSolicitudes.DataTextField = "TipoSolicitud"
        Me.drpSolicitudes.DataValueField = "IdTipo"
        Me.drpSolicitudes.DataBind()
        Me.drpSolicitudes.Items.Add(New WebControls.ListItem(".. Seleccione ..", 0))
        Me.drpSolicitudes.SelectedValue = 0

    End Sub

    Protected Sub bindTipoCertificaciones()

        'Dim tipoSolicitud As String = Me.drpSolicitudes.SelectedValue
        'Me.drpTipoCertificacion.DataSource = SolicitudesEnLinea.Solicitudes.getSubTipoSolicitudes(CInt(tipoSolicitud))
        'Me.drpTipoCertificacion.DataTextField = ""
        'Me.drpTipoCertificacion.DataValueField = ""
        'Me.drpTipoCertificacion.DataBind()

    End Sub

    Protected Sub bindOficinas()

        'Me.drpOficinas.DataSource = ""
        'Me.drpOficinas.DataTextField = ""
        'Me.drpOficinas.DataValueField = ""
        'Me.drpOficinas.DataBind()

    End Sub

    Protected Sub bindProvincias()
        Me.drpProvincia.DataSource = Utilitarios.TSS.getProvincias()
        Me.drpProvincia.DataTextField = "PROVINCIA_DES"
        Me.drpProvincia.DataValueField = "ID_PROVINCIA"
        Me.drpProvincia.DataBind()
        Me.drpProvincia.SelectedValue = "32"

    End Sub

    Private Sub drpSolicitudes_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles drpSolicitudes.SelectedIndexChanged

        Me.txtRnc.Text = ""
        Me.txtCedula.Text = ""
        reordernarPanel()

    End Sub

    Protected Sub reordernarPanel()

        Dim tipo As String = Me.drpSolicitudes.SelectedValue
        Me.pnlCedula.Visible = True
        Me.pnlRNC.Visible = True
        Me.pnlSalario.Visible = False
        Me.btAyudaRNC.Visible = True
        'Me.btAyudaCedula.Visible = True
        MuestraBotonAceptar()

        Select Case tipo

            Case "7"
                pnlRNC.Visible = False
                Me.lblCedula.Text = "Permítame por favor su número de cédula o pasaporte (sin guiones), si lo tiene: "
                'Me.lblCedula.Text = "Permítame por favor su número de cédula (sin guiones): "
                'Me.lblNombreCedula.Text = "Solicitante"
            Case "9"
                pnlRNC.Visible = False
                pnlProvincia.Visible = True

                If Not Page.IsPostBack Then
                    Me.bindProvincias()
                End If

            Case "10"
                pnlRNC.Visible = False
                Me.lblCedula.Text = "Permítame por favor su número de cédula (sin guiones): "
                Me.btAyudaRNC.Visible = False
                '    Me.btAyudaCedula.Visible = False

            Case "11"
                Me.pnlSalario.Visible = True
                pnlRNC.Visible = False
                Me.pnlCedula.Visible = False
                Me.btAyudaRNC.Visible = False
                '   Me.btAyudaCedula.Visible = False

            Case Else
                pnlRNC.Visible = True
                'Me.lblNombreCedula.Text = "Representante"

        End Select

    End Sub

    Private Sub btnAceptar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        Dim mensaje As String = String.Empty

        'Validamos que los datos requerido para un tipo de solicitud se complete
        Dim tipo As String = Me.drpSolicitudes.SelectedValue
        Select Case tipo
            Case "0"
                Me.lblMsg.Text = "Debe seleccionar una solicitud"
                Me.lblMsg.Visible = True
                Exit Sub

            Case "1"
                'Validar aqui

            Case "2" 'Esto es registro de empresa
                If Not isValidoRNC(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                If Not isCedulaValida(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                If isEmpleadorRegistrado(Me.txtRnc.Text) Then
                    Me.lblMsg.Text = Utilitarios.TSS.getErrorDescripcion(26)
                    Me.lblMsg.Text = "Ya este RNC está registrado en la TSS, desea que un representante nuestro le contacte para actualizar sus datos. <br><br>" & _
                                    " Si la respuesta es afirmativa, debe digitar una SOLICITUD GENERAL indicando que el empleador desea actualizar sus datos. "

                    Exit Sub
                End If

                'Colocamos los valores en session para su posterior uso.
                Session("IdTipoSolicitud") = Me.drpSolicitudes.SelectedValue
                Session("TipoSolcitud") = Me.drpSolicitudes.SelectedItem.Text
                Session("RNCEmpleador") = Me.txtRnc.Text
                Session("CedulaRepresentate") = Me.txtCedula.Text

                'Redireccionamos a la pagina de registro.
                Response.Redirect("RegistroEmpresa.aspx")

            Case "3"  'Esto es recuperacion de clave de acceso.

                If Not isValidoRNC(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                If Not isEmpleadorRegistrado(Me.txtRnc.Text) Then
                    Me.lblMsg.Text = "El RNC específicado no está registrado."
                    Exit Sub
                End If

                If Not isCedulaValida(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                If Not isRepresentanteParaEmpleador(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                'Colocamos los valores en session para su posterior uso.
                Session("IdTipoSolicitud") = Me.drpSolicitudes.SelectedValue
                Session("TipoSolcitud") = Me.drpSolicitudes.SelectedItem.Text
                Session("RNCEmpleador") = Me.txtRnc.Text
                Session("CedulaRepresentate") = Me.txtCedula.Text

                'Redireccionamos a la pagina de registro.
                Response.Redirect("RecuperaClave.aspx")

            Case "4" 'Esto es solicitud de estado de cuenta via fax

                If Not isValidoRNC(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                If Not isEmpleadorRegistrado(Me.txtRnc.Text) Then
                    Me.lblMsg.Text = "El RNC específicado no está registrado."
                    Exit Sub
                End If

                If Not isCedulaValida(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                If Not isRepresentanteParaEmpleador(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                'Colocamos los valores en session para su posterior uso.
                Session("IdTipoSolicitud") = Me.drpSolicitudes.SelectedValue
                Session("TipoSolcitud") = Me.drpSolicitudes.SelectedItem.Text
                Session("RNCEmpleador") = Me.txtRnc.Text
                Session("CedulaRepresentate") = Me.txtCedula.Text

                'Redireccionamos a la pagina de registro.
                Response.Redirect("EstadodeCuenta.aspx")

            Case "5" 'Esto es cancelacion de facturar y recargos

                If Not isValidoRNC(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                If Not isEmpleadorRegistrado(Me.txtRnc.Text) Then
                    Me.lblMsg.Text = "El RNC específicado no está registrado."
                    Exit Sub
                End If

                If Not isCedulaValida(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                If Not isRepresentanteParaEmpleador(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                'Colocamos los valores en session para su posterior uso.
                Session("IdTipoSolicitud") = Me.drpSolicitudes.SelectedValue
                Session("TipoSolcitud") = Me.drpSolicitudes.SelectedItem.Text
                Session("RNCEmpleador") = Me.txtRnc.Text
                Session("CedulaRepresentate") = Me.txtCedula.Text

                'Redireccionamos a la pagina de registro.
                Response.Redirect("CancelaFactura.aspx")

            Case "6" 'Esto es solicitud de canelacion de RNC

                If Not isValidoRNC(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                If Not isEmpleadorRegistrado(Me.txtRnc.Text) Then
                    Me.lblMsg.Text = "El RNC específicado no está registrado."
                    Exit Sub
                End If

                If Not isCedulaValida(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                If Not isRepresentanteParaEmpleador(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                'Colocamos los valores en session para su posterior uso.
                Session("IdTipoSolicitud") = Me.drpSolicitudes.SelectedValue
                Session("TipoSolcitud") = Me.drpSolicitudes.SelectedItem.Text
                Session("RNCEmpleador") = Me.txtRnc.Text
                Session("CedulaRepresentate") = Me.txtCedula.Text

                'Redireccionamos a la pagina de registro.
                Response.Redirect("CancelaRNC.aspx")

            Case "7"

                'If Not isCedulaValida(mensaje) Then
                '    Me.lblMsg.Text = mensaje
                '    Exit Sub
                'End If

                Session("IdTipoSolicitud") = Me.drpSolicitudes.SelectedValue
                Session("TipoSolcitud") = Me.drpSolicitudes.SelectedItem.Text
                Session("CedulaRepresentate") = Me.txtCedula.Text

                'Redireccionamos a la pagina de registro.
                Response.Redirect("SolicitudInformacion.aspx")

            Case "8" 'Estado de cuenta via mail

                If Not isValidoRNC(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                If Not isEmpleadorRegistrado(Me.txtRnc.Text) Then
                    Me.lblMsg.Text = "El RNC específicado no está registrado."
                    Exit Sub
                End If

                If Not isCedulaValida(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                If Not isRepresentanteParaEmpleador(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                'Colocamos los valores en session para su posterior uso.
                Session("IdTipoSolicitud") = Me.drpSolicitudes.SelectedValue
                Session("TipoSolcitud") = Me.drpSolicitudes.SelectedItem.Text
                Session("RNCEmpleador") = Me.txtRnc.Text
                Session("CedulaRepresentate") = Me.txtCedula.Text

                'Redireccionamos a la pagina de registro.
                Response.Redirect("FacturasViaMail.aspx")

            Case "9" 'Informacion General

                If Not isCedulaValida(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                'Colocamos los valores en session para su posterior uso.
                Session("IdTipoSolicitud") = Me.drpSolicitudes.SelectedValue
                Session("TipoSolcitud") = Me.drpSolicitudes.SelectedItem.Text
                Session("RNCEmpleador") = "401517078" 'Me.txtRnc.Text
                Session("CedulaRepresentate") = Me.txtCedula.Text
                Session("IDProvincia") = Me.drpProvincia.SelectedValue.ToString
                Session("Provincia") = Me.drpProvincia.SelectedItem.Text

                'Redireccionamos a la pagina de registro.
                Response.Redirect("InformacionGeneral.aspx")

            Case "10" 'Consulta de NSS
                Session("IdTipoSolicitud") = Me.drpSolicitudes.SelectedValue
                Session("TipoSolcitud") = Me.drpSolicitudes.SelectedItem.Text
                Session("CedulaRepresentate") = Me.txtCedula.Text

                Response.Redirect("SolConsultaNSS.aspx")

            Case "11" 'Calculo de aportes

                If Me.txtSalario.Text = String.Empty Then
                    Me.lblMsg.Text = "El salario es requerido"
                    Exit Sub
                End If

                If Not Regex.IsMatch(Me.txtSalario.Text, "^(\d|,)*\.?\d*$") Then
                    Me.lblMsg.Text = "Salario inválido."
                    Exit Sub
                End If

                Session("Salario") = Me.txtSalario.Text
                Response.Redirect("CalculoAportes.aspx")
            Case "12" ' Nomina & Novedades
                If Not isValidoRNC(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                If Not isEmpleadorRegistrado(Me.txtRnc.Text) Then
                    Me.lblMsg.Text = "El RNC específicado no está registrado."
                    Exit Sub
                End If

                If Not isCedulaValida(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If

                If Not isRepresentanteParaEmpleador(mensaje) Then
                    Me.lblMsg.Text = mensaje
                    Exit Sub
                End If


                'Colocamos los valores en session para su posterior uso.
                Session("IdTipoSolicitud") = Me.drpSolicitudes.SelectedValue
                Session("TipoSolcitud") = Me.drpSolicitudes.SelectedItem.Text
                Session("RNCEmpleador") = Me.txtRnc.Text
                Session("CedulaRepresentate") = Me.txtCedula.Text

                'Redireccionamos a la pagina.
                Response.Redirect("SolNovedades.aspx")


        End Select

    End Sub

    Protected Sub MuestraBotonAceptar()
        Me.btnAceptar.Visible = True
    End Sub

    Protected Sub MuestraURL()
        Me.btnAceptar.Visible = False
        Me.pnlCedula.Visible = False
        Me.pnlRNC.Visible = False
    End Sub

#Region "Validaciones"

    'Verifica si la cedula valida es un representante valido para el empleador.
    Protected Function isRepresentanteParaEmpleador(ByRef mensaje As String) As Boolean

        If Not SolicitudesEnLinea.Solicitudes.isRepresentanteEnEmpresa(Me.txtRnc.Text, Me.txtCedula.Text) Then
            mensaje = Utilitarios.TSS.getErrorDescripcion(154)
            mensaje = "El número de RNC o de cédula no corresponden a una empresa o representante válido, por favor repitame de nuevo la información. <br>" & _
                        " Si persiste el error, debe llenar una solicitud general indicando en el comentario que solicita verificar datos de representante."
            Return False
        End If

        Return True

    End Function

    'Verifica si el empleador esta registrado.
    Protected Function isEmpleadorRegistrado(ByVal rnc As String) As Boolean

        Return Empresas.Empleador.isRegistrado(rnc)

    End Function

    'Valida que sea un RNC valido
    Protected Function isValidoRNC(ByRef mensaje As String) As Boolean

        If Me.txtRnc.Text = "" Then
            mensaje = "El RNC es requerido."
            Return False
        End If

        If Not Regex.IsMatch(Me.txtRnc.Text, "^(\d{9}|\d{11})$") Then
            mensaje = "El RNC específicado es inválido."
            Return False
        End If

        Return True

    End Function

    'Valida que sea una cedula valida
    Protected Function isCedulaValida(ByRef mensaje As String) As Boolean

        If Me.txtCedula.Text = "" Then
            mensaje = "La cédula es requerida."
            Return False
        End If

        If Not Regex.IsMatch(Me.txtCedula.Text.Trim(), "^(\d{11})$") Then
            mensaje = "La cédula es inválida."
            Return False
        End If

        If Not Utilitarios.TSS.existeCiudadano("C", Me.txtCedula.Text) Then
            mensaje = "La cédula específica no está registrada en nuestra base de datos."
            Return False
        End If

        Return True

    End Function

#End Region

End Class
