Imports SuirPlus
Imports System.Data
Partial Class VerFormServicio
    Inherits System.Web.UI.Page
    Protected NroSol As String
    Protected motivo As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            NroSol = Request.QueryString("NoSol")
            motivo = Request.QueryString("Motivo")

            If NroSol Is Nothing Or NroSol = String.Empty Then
                Return
            End If

            cargar()

        End If
    End Sub

    Private Sub cargar()

        Dim dt As New DataTable
        Dim dtDGII As New DataTable

        dt = SolicitudesEnLinea.Solicitudes.CargarDatos(NroSol)

        If dt.Rows.Count > 0 Then
            Me.lblNoSolicitud.Text = IsNull(dt.Rows(0)("id_solicitud"))
            Me.lblTipoServicio.Text = IsNull(dt.Rows(0)("descripcion"))
            Me.lblFecha.Text = IsNull(dt.Rows(0)("fecha_registro"))


            Me.lblRazonSocial.Text = IsNull(dt.Rows(0)("razon_social"))
            Me.lblRNC.Text = IsNull(dt.Rows(0)("rnc_o_cedula"))

            Me.lblNombre.Text = IsNull(dt.Rows(0)("NombreRepresentante"))
            Me.lblNoDocumento.Text = IsNull(dt.Rows(0)("representante"))

            Me.lblMotivo.Text = IsNull(dt.Rows(0)("comentarios")) 'IsNull(motivo)


            If dt.Rows(0)("id_tipo_solicitud").ToString() = "2" Then
                dtDGII = Empresas.Empleador.getDGIIEmpleador(Me.lblRNC.Text)
                If dtDGII.Rows.Count > 0 Then
                    Me.lblRazonSocial.Text = dtDGII.Rows(0)("razon_social")
                End If

                Me.lblMotivo.Text = Replace(Me.lblMotivo.Text, "*", "<br/>*")
                Me.lblMotivo.Text = Replace(Me.lblMotivo.Text, "DOCUMENTOS REQUERIDOS:", "<br/><br/>DOCUMENTOS ADJUNTOS:")
                Me.lblMotivo.Text = Replace(Me.lblMotivo.Text, "SECTOR SALARIAL:", "<br/><br/>SECTOR SALARIAL:")
                Me.lblMotivo.Text = Replace(Me.lblMotivo.Text, "MOTIVO:", "<br/><br/>MOTIVO:")
            End If



            Me.lblUsuario.Text = IsNull(dt.Rows(0)("ult_usr_modifico"))

            'Cargamos el slogan de Gobierno
            Dim certconfig As New SuirPlus.Config.Configuracion(Config.ModuloEnum.Certificaciones)
            Me.lblEslogan.Text = certconfig.Field4

            'If Me.lblTipoServicio.Text = "Registro de Empresa" Then
            '    divDocumentosSC.Visible = True
            'Else
            '    divDocumentosSC.Visible = False
            'End If

        End If

    End Sub

    Private Function IsNull(ByVal Valor As Object) As String
        If Not IsDBNull(Valor) Then
            Return Valor
        Else
            Return String.Empty
        End If

        Return String.Empty
    End Function

End Class
