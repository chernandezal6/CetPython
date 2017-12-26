Imports SuirPlus
Imports SuirPlus.SolicitudesEnLinea
Imports SuirPlus.Utilitarios

Partial Class sys_Confirmacion
    Inherits BasePage
    Public rnc As String
    'Protected WithEvents btnAceptar As System.Web.UI.WebControls.Button
    'Protected WithEvents pnlEstadoCuentaFax As System.Web.UI.WebControls.Panel
    Public cedula As String
    Public fax As String


#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents lblRazonSocial As System.Web.UI.WebControls.Label
    'Protected WithEvents lblNombreComercial As System.Web.UI.WebControls.Label
    'Protected WithEvents lblRepresentante As System.Web.UI.WebControls.Label
    'Protected WithEvents lblFax As System.Web.UI.WebControls.Label
    'Protected WithEvents lblRnc As System.Web.UI.WebControls.Label
    'Protected WithEvents lblMensaje As System.Web.UI.WebControls.Label

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
        rnc = Session("Rnc")
        cedula = Session("Cedula")
        fax = Session("fax")
        'fax.Replace("-", "")
        Dim emp As New SuirPlus.Empresas.Empleador(rnc)
        Me.pnlEstadoCuentaFax.Visible = True
        Me.lblRnc.Text = Utils.FormatearRNCCedula(emp.RNCCedula)
        Me.lblRazonSocial.Text = emp.RazonSocial
        Me.lblNombreComercial.Text = emp.NombreComercial
        Me.lblFax.Text = fax
        Dim rep As New SuirPlus.Empresas.Representante(rnc, cedula)
        Me.lblRepresentante.Text = rep.NombreCompleto

    End Sub

    Private Sub btnAceptar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        Me.EstadoCuenta()

    End Sub

    Private Sub ActualizarFax()

        Dim emp As New SuirPlus.Empresas.Empleador(rnc)

        emp.Fax = Me.lblFax.Text.Replace("-", "")

        emp.GuardarCambios(cedula & rnc)


    End Sub

    Private Sub EstadoCuenta()

        Dim NumeroSolicitud As String
        Dim valor1 As String
        Dim valor2 As String
        'Dim validaRep As String
        Dim Res As String()

        Dim Comentario As String = String.Empty

        Dim emp As New SuirPlus.Empresas.Empleador(rnc)

        If Replace(emp.Fax, "-", "") = Replace(Me.lblFax.Text, "-", "") Then
            Comentario = "Solicitado por www.tss.gov.do"
        Else
            Me.ActualizarFax()
        End If

        Try
            NumeroSolicitud = SuirPlus.SolicitudesEnLinea.Solicitudes.crearSolicitud(4, 0, rnc, cedula, "", Comentario)

            Res = NumeroSolicitud.Split("|")
            valor1 = Res(0)
            valor2 = Res(1)

            If valor1 = "0" Then

                Dim mensaje As String

                mensaje = "Usted recibirá su estado de cuentas via fax en los próximos 15 minutos al número" & Me.lblFax.Text

                Response.Redirect("SolicitudCreada.aspx?Id=" & valor2)
            Else

                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = valor2

            End If
        Catch ex As Exception
            Response.Redirect("error.aspx?errMsg=" & ex.ToString())
        End Try
    End Sub
End Class
