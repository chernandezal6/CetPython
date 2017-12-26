Imports SuirPlus
Imports SuirPlus.SolicitudesEnLinea
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios

Partial Class Solicitudes_CalculoAportes
    Inherits BasePage

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents lblDescuento As System.Web.UI.WebControls.Label
    'Protected WithEvents lblAporteEmpleador As System.Web.UI.WebControls.Label
    'Protected WithEvents lblAporteMensual As System.Web.UI.WebControls.Label
    'Protected WithEvents lblAgente As System.Web.UI.WebControls.Label
    'Protected WithEvents lblMensaje As System.Web.UI.WebControls.Label

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
        If Session("Salario") = String.Empty Then
            Response.Redirect("Solicitudes.aspx")
        End If
    End Sub

#End Region

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not Page.IsPostBack Then
            cargar()
        End If

    End Sub

    Protected Sub cargar()

        Dim salario As Double = CDbl(Session("Salario"))
        Dim aporteAfiliado As Double
        Dim aporteEmpleador As Double
        Dim cuentaPersonal As Double

        'Obtenemos por referencia los valores de los aportes.
        SolicitudesEnLinea.Solicitudes.getAportes(Nothing, salario, aporteAfiliado, aporteEmpleador, cuentaPersonal)

        Me.lblDescuento.Text = FormatCurrency(aporteAfiliado)
        Me.lblAporteEmpleador.Text = FormatCurrency(aporteEmpleador)
        Me.lblAporteMensual.Text = FormatCurrency(cuentaPersonal)
        Me.lblAgente.Text = MyBase.UsrNombreCompleto

    End Sub

End Class
