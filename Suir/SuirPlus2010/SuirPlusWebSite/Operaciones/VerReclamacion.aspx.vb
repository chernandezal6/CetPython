Imports SuirPlus
Imports System.Data
Partial Class Operaciones_VerReclamacion
    Inherits System.Web.UI.Page
    Protected NroRec As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            NroRec = Request.QueryString("NoRec")

            If NroRec Is Nothing Or NroRec = String.Empty Then
                Return
            End If

            cargar()

        End If
    End Sub

    Private Sub cargar()

        Dim dt As New DataTable

        dt = SolicitudesEnLinea.Reclamaciones.getSolicitud(NroRec)

        If dt.Rows.Count > 0 Then
            Dim RncCedula As String = String.Empty
            Dim Cedula As String = String.Empty
            Dim IDCertificacion As String = IIf(IsDBNull(dt.Rows(0)("ID_TIPO_CERTIFICACION")), String.Empty, dt.Rows(0)("ID_TIPO_CERTIFICACION").ToString())


            If dt.Rows(0)("ID_TIPO_SOLICITUD").ToString() = "23" And IDCertificacion = "7" Or IDCertificacion = "3" Or IDCertificacion = "A" Or _
            IDCertificacion = "B" Or IDCertificacion = "9" Or IDCertificacion = "10" Then
                Cedula = dt.Rows(0)("CEDULA").ToString()
            ElseIf dt.Rows(0)("ID_TIPO_SOLICITUD").ToString() = "23" Then
                Cedula = dt.Rows(0)("CEDULA").ToString()
                RncCedula = dt.Rows(0)("RNC").ToString()
            Else
                RncCedula = IIf(IsDBNull(dt.Rows(0)("RNC")), dt.Rows(0)("CEDULA").ToString(), dt.Rows(0)("RNC").ToString())
            End If

            'Llenando los datos del ciudadano
            If Not String.IsNullOrEmpty(Cedula) Then
                Dim tmpstr As String = SuirPlus.Utilitarios.TSS.consultaCiudadano("C", dt.Rows(0)("CEDULA").ToString())

                If Split(tmpstr, "|")(0) = "0" Then
                    lblNombre.Text = Split(tmpstr, "|")(1) & " " & Split(tmpstr, "|")(2)
                    lblNSS.Text = Split(tmpstr, "|")(3)
                    lblCedulaCiudadano.Text = Utilitarios.Utils.FormatearCedula(dt.Rows(0)("CEDULA").ToString())
                    tblCiudadano.Visible = True
                    tblEmpleador.Visible = False
                End If

            End If
            
            'Llenando los datos del empleador
            If Not String.IsNullOrEmpty(RncCedula) Then
                Dim em As New Empresas.Empleador(RncCedula)
                If Not em.RazonSocial = Nothing Then
                    Me.lblRazonSocial.Text = em.RazonSocial
                    Me.lblEmail.Text = em.Email
                    Me.lblContacto.Text = String.Empty
                    Me.lblCargo.Text = String.Empty
                    Me.lblTelefono.Text = Utilitarios.Utils.FormatearTelefono(em.Telefono1)
                    Me.lblExt.Text = em.Ext1
                    Me.lblFax.Text = Utilitarios.Utils.FormatearTelefono(em.Fax)
                    tblEmpleador.Visible = True
                End If
            End If


            If dt.Rows(0)("ID_TIPO_SOLICITUD").ToString() = "23" Then
                lblCertificacion.Text = "Tipo de Certificación: <strong>" & dt.Rows(0)("tipo_certificacion_des").ToString() & "</strong>"
            End If


            If dt.Rows(0)("ID_TIPO_SOLICITUD").ToString() = "24" Or dt.Rows(0)("ID_TIPO_SOLICITUD").ToString() = "20" Or dt.Rows(0)("ID_TIPO_SOLICITUD").ToString() = "21" Then

                Dim dtDetalle As New DataTable

                dtDetalle = SolicitudesEnLinea.Reclamaciones.getDetalleSolicitud(NroRec)

                If dtDetalle.Rows.Count > 0 Then
                    gvNotPagadas.DataSource = dtDetalle
                    gvNotPagadas.DataBind()
                End If

                lblDetalleNP.Visible = True
            End If

            lblMotivo.Text = dt.Rows(0)("COMENTARIOS").ToString()

            'Cargamos el slogan de Gobierno
            Dim certconfig As New SuirPlus.Config.Configuracion(Config.ModuloEnum.Certificaciones)
            Me.lblEslogan.Text = certconfig.Field4
            Me.lblNoReclamacion.Text = NroRec
            Me.lblTipoReclamacion.Text = dt.Rows(0)("TipoSolicitud").ToString()
        End If


    End Sub
End Class
