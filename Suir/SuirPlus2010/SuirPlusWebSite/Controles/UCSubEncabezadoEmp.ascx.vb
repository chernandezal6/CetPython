
Partial Class Controles_UCSubEncabezadoEmp
    Inherits System.Web.UI.UserControl


#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub


    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not IsPostBack() Then

            If CType(Me.Page, BasePage).UsrImpersonandoUnRepresentante = True Then
                Dim tmpRep As SuirPlus.Empresas.Representante

                tmpRep = New SuirPlus.Empresas.Representante(CType(Me.Page, BasePage).UsrRNC, CType(Me.Page, BasePage).UsrCedula)

                Me.lblRazonSocial.Text = tmpRep.Empleador.RazonSocial
                Me.lblRncCedula.Text = tmpRep.RNC 'SuirPlus.Utilitarios.Utils.FormatearRNCCedula(tmpRep.RNC)

                Dim c As New SuirPlus.Empresas.Trabajador(CType(Me.Page, BasePage).UsrImpNSS)

                Me.lblNombreRep.Text = c.Nombres & " " & c.PrimerApellido & " " & c.SegundoApellido
                Me.lblCedula.Text = c.Documento

                Me.pnlInfoRep.Visible = CType(Me.Page, BasePage).UsrImpersonandoUnRepresentante

                'Cargando propiedad de registro patronal
                ViewState("RegistroPatronal") = tmpRep.RegistroPatronal
                ViewState("RNC") = tmpRep.RNC
            Else

            End If


        End If

    End Sub


    Private Sub linkbtnTerminarSession_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub

    Public ReadOnly Property RegistroPatronal() As Integer

        Get
            Return ViewState("RegistroPatronal")
        End Get

    End Property


    Public ReadOnly Property RNC() As String

        Get
            Return CType(Me.Page, BasePage).UsrRNC 'ViewState("RNC")
        End Get

    End Property

    Public ReadOnly Property NSS() As Integer
        Get
            Return ViewState("NSS")
        End Get
    End Property

    Public ReadOnly Property Documento() As String
        Get
            Return CType(Me.Page, BasePage).UsrCedula 'ViewState("Documento")
        End Get
    End Property

    Public ReadOnly Property UsuarioRepresentante() As String
        Get
            Return Me.RNC + Me.Documento
        End Get
    End Property

    Private Sub btnTerminarSession_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnTerminarSession.Click

        'Sacando el representante emulado
        Session("REPRESENTANTE_TMP") = Nothing

        'Colocamos la variable false para que el control no vuelva a mostrarse
        CType(Me.Page, BasePage).UsrImpersonandoUnRepresentante = False

        'Response.Redirect(System.Configuration.ConfigurationSettings.AppSettings("COMPROBACION_REP"))
        Response.Redirect("~/Default.aspx")

    End Sub
End Class

