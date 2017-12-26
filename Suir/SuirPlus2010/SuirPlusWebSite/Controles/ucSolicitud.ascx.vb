Imports SuirPlus
Imports SuirPlus.Utilitarios
Partial Class Controles_ucSolicitud
    Inherits System.Web.UI.UserControl

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    'Protected WithEvents txtIdSolicitud As System.Web.UI.WebControls.TextBox
    'Protected WithEvents lblIdSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents lblTipoSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents lblRnc As System.Web.UI.WebControls.Label
    'Protected WithEvents lblEstatus As System.Web.UI.WebControls.Label
    'Protected WithEvents lblRepresentante As System.Web.UI.WebControls.Label
    'Protected WithEvents lblOperador As System.Web.UI.WebControls.Label
    'Protected WithEvents lblComentarios As System.Web.UI.WebControls.Label
    'Protected WithEvents lblFechaRegistro As System.Web.UI.WebControls.Label
    'Protected WithEvents lblFechaCierre As System.Web.UI.WebControls.Label
    'Protected WithEvents lblEntreadoA As System.Web.UI.WebControls.Label
    'Protected WithEvents lblFechaEntrega As System.Web.UI.WebControls.Label
    'Protected WithEvents lblRazonSocial As System.Web.UI.WebControls.Label
    'Protected WithEvents lblNombreComercial As System.Web.UI.WebControls.Label
    'Protected WithEvents lblFax As System.Web.UI.WebControls.Label
    'Protected WithEvents lblMensaje As System.Web.UI.WebControls.Label
    'Protected WithEvents lblEmailRepresentante As System.Web.UI.WebControls.Label
    'Protected WithEvents lblTelefono1 As System.Web.UI.WebControls.Label
    'Protected WithEvents lblTelefono2 As System.Web.UI.WebControls.Label
    'Protected WithEvents pnlGeneral As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlInfoCierre As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlSolInformacion As System.Web.UI.WebControls.Panel
    'Protected WithEvents lblSolicitante As System.Web.UI.WebControls.Label
    'Protected WithEvents lblInfoSolicitada As System.Web.UI.WebControls.Label
    'Protected WithEvents lblMotivoSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents lblSolicitanteComentario As System.Web.UI.WebControls.Label
    'Protected WithEvents lblSolicitanteIDSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents lbSolicitantelCedula As System.Web.UI.WebControls.Label
    'Protected WithEvents lblSolicitanteInstitucion As System.Web.UI.WebControls.Label
    'Protected WithEvents lblSolicitanteCargo As System.Web.UI.WebControls.Label
    'Protected WithEvents lblSolicitanteDireccion As System.Web.UI.WebControls.Label
    'Protected WithEvents lblSolicitanteTelefono As System.Web.UI.WebControls.Label
    'Protected WithEvents lblSolicitanteCelular As System.Web.UI.WebControls.Label
    'Protected WithEvents lblSolicitanteTipoSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents pnlTelefonos As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlEmail As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlFax As System.Web.UI.WebControls.Panel
    'Protected WithEvents lblCedulaRepresentante As System.Web.UI.WebControls.Label
    'Protected WithEvents pnlCancelacion As System.Web.UI.WebControls.Panel
    'Protected WithEvents lblCancelacionRazonSocial As System.Web.UI.WebControls.Label
    'Protected WithEvents lblCancelacionIDSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents lblCancelacionRNC As System.Web.UI.WebControls.Label
    'Protected WithEvents lblCancelacionEmail As System.Web.UI.WebControls.Label
    'Protected WithEvents lblCancelacionTelefono As System.Web.UI.WebControls.Label
    'Protected WithEvents lblCancelacionFax As System.Web.UI.WebControls.Label
    'Protected WithEvents lblCancelacionCargo As System.Web.UI.WebControls.Label
    'Protected WithEvents lblCancelacionSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents lblCancelacionRNCCancelar As System.Web.UI.WebControls.Label
    'Protected WithEvents lblCancelacionMotivo As System.Web.UI.WebControls.Label
    'Protected WithEvents pnlFacturas As System.Web.UI.WebControls.Panel
    'Protected WithEvents dgFacturas As System.Web.UI.WebControls.DataGrid
    'Protected WithEvents lblCancelacionContacto As System.Web.UI.WebControls.Label
    'Protected WithEvents pnlRNCCancelar As System.Web.UI.WebControls.Panel
    'Protected WithEvents lblSolicitanteFechaRegistro As System.Web.UI.WebControls.Label
    'Protected WithEvents lblCanFechaRegistro As System.Web.UI.WebControls.Label
    'Protected WithEvents pnlSolicitudInformacionGeneral As System.Web.UI.WebControls.Panel
    'Protected WithEvents lblInfoNroSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents lblInfoTipoSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents lblInfoCedRepresentante As System.Web.UI.WebControls.Label
    'Protected WithEvents lblInfoRepresentante As System.Web.UI.WebControls.Label
    'Protected WithEvents lblInfoTelefono As System.Web.UI.WebControls.Label
    'Protected WithEvents lblInfoCelular As System.Web.UI.WebControls.Label
    'Protected WithEvents lblInfoMotivo As System.Web.UI.WebControls.Label
    'Protected WithEvents lblInfoFechaSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents lblTitulo As System.Web.UI.WebControls.Label
    'Protected WithEvents lblNovRepresentante As System.Web.UI.WebControls.Label
    'Protected WithEvents lblNovCedRepresentante As System.Web.UI.WebControls.Label
    'Protected WithEvents lblNovNombreComercial As System.Web.UI.WebControls.Label
    'Protected WithEvents lblNovRNC As System.Web.UI.WebControls.Label
    'Protected WithEvents lblNovFechaSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents lblNovTipoSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents lblNovNoSolicitud As System.Web.UI.WebControls.Label
    'Protected WithEvents pnlSolicitudNovedades As System.Web.UI.WebControls.Panel
    'Protected WithEvents lblNovRazonSocial As System.Web.UI.WebControls.Label
    'Protected WithEvents lblNovComentario As System.Web.UI.WebControls.Label
    'Protected WithEvents lblInfoComentario As System.Web.UI.WebControls.Label

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Protected Solicitud As SolicitudesEnLinea.Solicitudes

    Public Property NroSolicitud() As String
        Get
            Return Me.txtIdSolicitud.Text
        End Get
        Set(ByVal Value As String)
            Me.txtIdSolicitud.Text = Value
        End Set
    End Property

    Public Sub Mostrar()

        Me.lblTitulo.Visible = True

        Try
            Solicitud = New SolicitudesEnLinea.Solicitudes(CInt(Me.txtIdSolicitud.Text))

            Select Case Solicitud.IdTipoSolicitud

                Case 1

                Case 2
                    muestraPanelSolicitudGeneral()
                    pnlTelefonos.Visible = True
                    Me.pnlEmail.Visible = True
                    Me.pnlFax.Visible = True
                Case 3
                    pnlTelefonos.Visible = False
                    Me.pnlEmail.Visible = False
                    Me.pnlFax.Visible = False
                    muestraPanelSolicitudGeneral()
                Case 4
                    pnlTelefonos.Visible = False
                    Me.pnlEmail.Visible = False
                    Me.pnlFax.Visible = True
                    muestraPanelSolicitudGeneral()
                Case 5
                    muestrapanelSolicitudCancelacion()
                Case 6
                    muestrapanelSolicitudCancelacion()
                Case 7
                    muestraPanelSolicitudInformacionPublica()

                Case 8 ' Estado de cuenta via mail
                    muestraPanelSolicitudGeneral()
                    Me.pnlEmail.Visible = True
                    pnlTelefonos.Visible = False
                    Me.pnlFax.Visible = False

                Case 9 'Solicitud de informacion general
                    muestraPanelSolicitudInformacionGeneral()

                Case 12
                    muestraPanelNominaNovedades()
            End Select
        Catch ex As Exception

            If ex.Message <> "No se encontró la solicitud." Then
                Me.lblMensaje.Text = ex.Message
            End If

        End Try

    End Sub

    Protected Sub muestraPanelSolicitudGeneral()

        Me.lblIdSolicitud.Text = Solicitud.IdSolicitud
        Me.lblTipoSolicitud.Text = Solicitud.TipoSolicitud
        Me.lblRnc.Text = Solicitud.RNC
        Me.lblRazonSocial.Text = Solicitud.RazonSocial
        Me.lblNombreComercial.Text = Solicitud.NombreComercial
        Me.lblTelefono1.Text = Utils.FormatearTelefono(Solicitud.Telefono1)
        Me.lblTelefono2.Text = Utils.FormatearTelefono(Solicitud.Telefono2)
        Me.lblFax.Text = Utils.FormatearTelefono(Solicitud.Fax)
        Me.lblEstatus.Text = Solicitud.Status
        Me.lblCedulaRepresentante.Text = Utilitarios.Utils.FormatearCedula(Solicitud.Representante)
        Me.lblRepresentante.Text = Solicitud.RepresentanteNombre
        Me.lblEmailRepresentante.Text = Solicitud.EmailRepresentante
        Me.lblOperador.Text = Solicitud.OperadorNombre
        Me.txtComentarios.Text = Solicitud.Comentarios
        Me.lblFechaRegistro.Text = Solicitud.FechaRegistro


        'Si hay una fecha de finalzacion mostramos la info de cierre
        If Not Solicitud.FechaCierre = DateTime.MinValue Then
            muestraPanelFinalizacion()
        Else
            Me.pnlInfoCierre.Visible = False
        End If

        Me.pnlGeneral.Visible = True
        Me.pnlSolInformacion.Visible = False
        Me.pnlCancelacion.Visible = False
        Me.pnlSolicitudInformacionGeneral.Visible = False
        pnlSolicitudNovedades.Visible = False

    End Sub

    Protected Sub muestraPanelSolicitudInformacionPublica()

        lblSolicitanteIDSolicitud.Text = Solicitud.IdSolicitud
        lblSolicitanteTipoSolicitud.Text = Solicitud.TipoSolicitud
        lblSolicitante.Text = Solicitud.Solicitante
        lbSolicitantelCedula.Text = Utilitarios.Utils.FormatearCedula(Solicitud.SolicitanteCedula)
        lblSolicitanteDireccion.Text = Solicitud.SolicitanteDireccion
        lblSolicitanteTelefono.Text = Utils.FormatearTelefono(Solicitud.Telefono1)
        lblSolicitanteCelular.Text = Utils.FormatearTelefono(Solicitud.SolicitanteCelular)
        lblFax.Text = Utils.FormatearTelefono(Solicitud.SolicitanteFax)
        lblSolicitanteEmail.Text = Solicitud.SolicitanteEmail
        lblSolicitanteInstitucion.Text = Solicitud.SolicitanteInstitucion
        lblSolicitanteCargo.Text = Solicitud.SolicitanteCargo
        lblInfoSolicitada.Text = Solicitud.SolicitanteInformacion
        lblMotivoSolicitud.Text = Solicitud.SolicitanteMotivo
        lblSolicitanteAutoridad.Text = Solicitud.SolicitanteAutoridad
        lblSolicitanteMedio.Text = Solicitud.SolicitanteMedio
        lblSolicitanteLugar.Text = Solicitud.SolicitanteLugar
        txtSolicitanteComentario.Text = Solicitud.Comentarios
        lblSolicitanteFechaRegistro.Text = Solicitud.FechaRegistro

        pnlSolInformacion.Visible = True
        pnlSolicitudInformacionGeneral.Visible = False
        pnlCancelacion.Visible = False
        pnlGeneral.Visible = False
        pnlSolicitudNovedades.Visible = False

        'Si hay una fecha de finalzacion mostramos la info de cierre
        If Not Solicitud.FechaCierre = DateTime.MinValue Then
            muestraPanelFinalizacion()
        Else
            Me.pnlInfoCierre.Visible = False
        End If

    End Sub

    Protected Sub muestrapanelSolicitudCancelacion()

        Me.lblCancelacionIDSolicitud.Text = Solicitud.IdSolicitud
        Me.lblCancelacionSolicitud.Text = Solicitud.TipoSolicitud
        Me.lblCancelacionRazonSocial.Text = Solicitud.RazonSocial
        Me.lblCancelacionRNC.Text = Solicitud.Cancelacion.RNC
        Me.lblCancelacionTelefono.Text = Utils.FormatearTelefono(Solicitud.Cancelacion.Telefono)
        Me.lblCancelacionEmail.Text = Solicitud.Cancelacion.Email
        Me.lblCancelacionFax.Text = Utils.FormatearTelefono(Solicitud.Cancelacion.Fax)
        Me.lblCancelacionContacto.Text = Solicitud.Cancelacion.RepresentanteNombre
        Me.lblCancelacionCargo.Text = Solicitud.Cancelacion.Cargo
        Me.lblCancelacionRNCCancelar.Text = Solicitud.Cancelacion.RncCancelar
        Me.lblCancelacionMotivo.Text = Solicitud.Cancelacion.Motivo
        Me.txtComentarioCancelacion.Text = Solicitud.Cancelacion.Comentarios
        Me.lblCanFechaRegistro.Text = Solicitud.FechaRegistro

        If Solicitud.IdTipoSolicitud = 5 Then
            Me.pnlFacturas.Visible = True
            Me.dgFacturas.DataSource = SolicitudesEnLinea.structCancelacion.getDetalleFactura(Solicitud.IdSolicitud)
            Me.dgFacturas.DataBind()
            Me.dgFacturas.Visible = True
            Me.pnlRNCCancelar.Visible = False
        Else
            Me.pnlFacturas.Visible = False
            Me.pnlRNCCancelar.Visible = True
        End If

        Me.pnlSolInformacion.Visible = False
        Me.pnlGeneral.Visible = False
        Me.pnlCancelacion.Visible = True
        Me.pnlSolicitudInformacionGeneral.Visible = False
        pnlSolicitudNovedades.Visible = False

        'Si hay una fecha de finalzacion mostramos la info de cierre
        If Not Solicitud.FechaCierre = DateTime.MinValue Then
            muestraPanelFinalizacion()
        Else
            Me.pnlInfoCierre.Visible = False
        End If

    End Sub

    Protected Sub muestraPanelSolicitudInformacionGeneral()

        Me.lblInfoNroSolicitud.Text = Solicitud.IdSolicitud
        Me.lblInfoTipoSolicitud.Text = Solicitud.TipoSolicitud
        Me.lblInfoFechaSolicitud.Text = Solicitud.FechaRegistro
        Me.lblInfoCedRepresentante.Text = Utils.FormatearCedula(Solicitud.Representante)
        Me.lblInfoRepresentante.Text = Solicitud.RepresentanteNombre
        Me.lblInfoTelefono.Text = Utils.FormatearTelefono(Solicitud.Telefono1)
        Me.lblInfoCelular.Text = Utils.FormatearTelefono(Solicitud.Telefono2)
        Me.lblInfoMotivo.Text = Solicitud.SolicitanteMotivo
        Me.txtInfoComentario.Text = Solicitud.Comentarios

        Me.pnlSolInformacion.Visible = False
        Me.pnlGeneral.Visible = False
        Me.pnlCancelacion.Visible = False
        Me.pnlSolicitudInformacionGeneral.Visible = True
        pnlSolicitudNovedades.Visible = False

        'Si hay una fecha de finalzacion mostramos la info de cierre
        If Not Solicitud.FechaCierre = DateTime.MinValue Then
            muestraPanelFinalizacion()
        Else
            Me.pnlInfoCierre.Visible = False
        End If

    End Sub

    Protected Sub muestraPanelNominaNovedades()


        Me.lblNovNoSolicitud.Text = Solicitud.IdSolicitud
        Me.lblNovTipoSolicitud.Text = Solicitud.TipoSolicitud
        Me.lblNovFechaSolicitud.Text = Solicitud.FechaRegistro
        Me.lblNovRNC.Text = Solicitud.RNC
        Me.lblNovRazonSocial.Text = Solicitud.RazonSocial
        Me.lblNovNombreComercial.Text = Solicitud.NombreComercial
        Me.lblNovCedRepresentante.Text = Utils.FormatearCedula(Solicitud.Representante)
        Me.lblNovRepresentante.Text = Solicitud.RepresentanteNombre
        Me.txtNovComentario.Text = Solicitud.Comentarios

        Me.pnlSolicitudNovedades.Visible = True
        Me.pnlSolInformacion.Visible = False
        Me.pnlGeneral.Visible = False
        Me.pnlCancelacion.Visible = False
        Me.pnlSolicitudInformacionGeneral.Visible = False


        'Si hay una fecha de finalzacion mostramos la info de cierre
        If Not Solicitud.FechaCierre = DateTime.MinValue Then
            muestraPanelFinalizacion()
        Else
            Me.pnlInfoCierre.Visible = False
        End If

    End Sub

    Protected Sub muestraPanelFinalizacion()

        Me.lblFechaCierre.Text = Solicitud.FechaCierre
        Me.lblEntreadoA.Text = Solicitud.EntregadoA
        Me.lblFechaEntrega.Text = Solicitud.EntregadoA
        Me.pnlInfoCierre.Visible = True

    End Sub

End Class

