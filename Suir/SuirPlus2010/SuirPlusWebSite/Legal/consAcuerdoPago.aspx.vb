Imports SuirPlus
Imports System.Data
Partial Class Legal_consAcuerdoPago
    Inherits BasePage
    Dim Acuerdo As New DataTable

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then

            Dim StatusAcuerdo As System.Data.DataTable = Legal.AcuerdosDePago.getStatusAcuerdo()

            'Cargando el dropdownlist de status
            ddlStatus.DataSource = StatusAcuerdo
            ddlStatus.DataTextField = "Descripcion"
            ddlStatus.DataValueField = "Status"
            ddlStatus.DataBind()
            ddlStatus.Items.Insert(0, New ListItem("<--Todos-->", "0"))

        End If
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        Try
            Dim NroAcuerdo As Nullable(Of Integer) = Nothing
            Dim RegPat As Nullable(Of Integer) = Nothing
            Dim Status As Nullable(Of Integer) = Nothing
            Dim TipoAcuerdo As Nullable(Of SuirPlus.Legal.eTiposAcuerdos) = Nothing

            LimpiarBusquedaActual()


            'validamos que almenos uno de los parametros se pase
            If (Me.txtAcuerdo.Text = String.Empty) And (Me.txtRNC.Text = String.Empty) And (Me.txtRazonSocial.Text = String.Empty) And (Me.txtDesde.Text = String.Empty) And (Me.txtHasta.Text = String.Empty) And (Me.ddlStatus.SelectedValue = 0) Then
                Me.lblMensaje.Text = "Debe introducir almenos uno de los parametros."
                Me.pnlTaps.Visible = False
                Exit Sub
            End If


            'validamos que el numero de acuerdo de pago sea valido.
            If (txtAcuerdo.Text = "AO-") Then
                Me.lblMensaje.Text = "Digite un número de acuerdo de pago válido."
                Me.pnlTaps.Visible = False
                Exit Sub
            End If


            If Me.ddlStatus.SelectedValue <> "0" Then
                Status = Me.ddlStatus.SelectedValue
            End If

            If Not (txtAcuerdo.Text = String.Empty) Then
                Dim vec() As String
                'Validamos el tipo de acuerdo
                If Not String.IsNullOrEmpty(Me.txtAcuerdo.Text) Then
                    vec = Legal.AcuerdosDePago.ValidateTipoAcuerdo(txtAcuerdo.Text).Split("|")
                    NroAcuerdo = vec(0)
                    TipoAcuerdo = CInt(vec(1))
                End If

            End If

            If Not Me.txtRNC.Text = String.Empty Then
                Dim em As New Empresas.Empleador(Me.txtRNC.Text)
                RegPat = em.RegistroPatronal

            End If

            Acuerdo = Legal.AcuerdosDePago.getAcuerdosPago(NroAcuerdo, TipoAcuerdo, RegPat, Trim(Me.txtRazonSocial.Text), txtDesde.Text, txtHasta.Text, Status)

            If Acuerdo.Rows.Count > 0 Then
                Me.pnlTaps.Visible = True
                Me.gvData.DataSource = Acuerdo
                Me.gvData.DataBind()
                Me.pnlAcuerdos.Visible = True
                Me.tblData.Visible = True

                Dim rnc As String = Acuerdo.Rows(0)("Rnc_o_Cedula").ToString()
                Dim razonSocial As String = Acuerdo.Rows(0)("Razon_Social").ToString()
                Dim nombreComercial As String = Acuerdo.Rows(0)("Nombre_Comercial").ToString()
                Dim idAcuerdo As Integer = CInt(Acuerdo.Rows(0)("id_acuerdo").ToString())
                Dim tipoAP As Integer = CInt(Acuerdo.Rows(0)("tipo").ToString())
                Dim regPatronal As String = Acuerdo.Rows(0)("id_registro_patronal")

                If ((Me.txtAcuerdo.Text <> String.Empty) Or (Me.txtRNC.Text <> String.Empty) Or (Me.txtRazonSocial.Text <> String.Empty)) And ((Me.txtDesde.Text = String.Empty) And (Me.txtHasta.Text = String.Empty)) Then
                    CargarAcuerdo(rnc, razonSocial, nombreComercial, regPatronal, idAcuerdo, tipoAP)
                Else
                    If Acuerdo.Rows.Count = 1 Then
                        CargarAcuerdo(rnc, razonSocial, nombreComercial, regPatronal, idAcuerdo, tipoAP)
                    Else
                        Me.tpDetalleAP.Visible = False
                        Me.tpHistorialAP.Visible = False
                        Me.tpInfoBanco.Visible = False
                    End If
                End If

            Else

                Me.pnlAcuerdos.Visible = False
                Me.gvData.DataSource = Nothing
                Me.gvData.DataBind()
                Me.lblMensaje.Text = "No se encontró información para el criterio especificado. <br /> Trate nuevamente."
                Me.pnlInfoEmpleador.Visible = False
                Me.pnlRepresentantes.Visible = False
                Me.pnlTaps.Visible = False

            End If

        Catch ex As Exception

            Me.pnlInfoEmpleador.Visible = False
            Me.pnlRepresentantes.Visible = False
            Me.pnlAcuerdos.Visible = False
            Me.pnlTaps.Visible = False
            Me.lblMensaje.Text = ex.Message
            Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub CargarAcuerdo(ByVal rnc As String, ByVal razonSocial As String, ByVal nombreComercial As String, ByVal regPatronal As String, ByVal acuerdo As Integer, ByVal tipoAcuerdo As Integer)
        Try
            Me.pnlInfoEmpleador.Visible = True
            Me.lblRnc.Text = rnc
            Me.lblRazonSocial.Text = razonSocial
            Me.lblNombreComercial.Text = nombreComercial

            CargarRepresentantes(regPatronal)

            Me.BindDetalle(acuerdo, tipoAcuerdo)
            Me.BindHistorial(acuerdo, tipoAcuerdo)
            Me.InfoBanco(rnc)
            Me.tpDetalleAP.Visible = True
            Me.tpHistorialAP.Visible = True
            Me.tpInfoBanco.Visible = True
        Catch ex As Exception
            Throw ex
        End Try


    End Sub

    Protected Sub CargarRepresentantes(ByVal regPatronal As String)
        'Busqueda de representantes del Empleador'
        Dim dtRepresentante As DataTable = Empresas.Representante.getRepresentante(-1, CInt(regPatronal))

        If dtRepresentante.Rows.Count > 0 Then
            Me.pnlRepresentantes.Visible = True
            Me.gvRepresentantes.DataSource = dtRepresentante
            Me.gvRepresentantes.DataBind()
        Else
            Me.pnlRepresentantes.Visible = False
            Me.lblMensaje.Text = "No existe Representante para este Empleador"
        End If
    End Sub

    Protected Sub BindDetalle(ByVal idAcuerdo As Integer, ByVal Tipo As Integer)

        Dim dtDetCuotas As New DataTable
        dtDetCuotas = Legal.AcuerdosDePago.getCuotasAcuerdoPago(idAcuerdo, Tipo)

        If dtDetCuotas.Rows.Count > 0 Then
            Me.pnlDetalleAcuerdo.Visible = True
            Me.gvDetalleAcuerdo.DataSource = dtDetCuotas
            Me.gvDetalleAcuerdo.DataBind()
        Else
            Me.pnlDetalleAcuerdo.Visible = False
        End If


    End Sub

    Protected Sub gvDetalleAcuerdo_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDetalleAcuerdo.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.Cells(2).Text = "Vencida" Then
                e.Row.BackColor = Drawing.Color.LightGoldenrodYellow
            End If
        End If
    End Sub

    Protected Sub InfoEmpleador()

        If Not Me.txtRNC.Text = String.Empty Then
            Dim emp As New Empresas.Empleador(Me.txtRNC.Text)

            Me.pnlInfoEmpleador.Visible = True
            Me.lblRnc.Text = emp.RNCCedula
            Me.lblRazonSocial.Text = emp.RazonSocial
            Me.lblNombreComercial.Text = emp.NombreComercial
        Else
            Me.pnlInfoEmpleador.Visible = False

        End If
    End Sub

    Protected Sub BindHistorial(ByVal idAcuerdo As Integer, ByVal Tipo As Integer)

        Dim dtHistorialAcuerdo As New DataTable
        dtHistorialAcuerdo = Legal.AcuerdosDePago.getPasosAcuerdoPago(idAcuerdo, Tipo)

        If dtHistorialAcuerdo.Rows.Count > 0 Then
            Me.pnlHistorial.Visible = True
            Me.gvHistorial.DataSource = dtHistorialAcuerdo
            Me.gvHistorial.DataBind()
        End If

    End Sub

    Public Sub InfoBanco(ByVal rnc As String)

        Dim dt As DataTable

        dt = Empresas.Facturacion.Factura.getRefsDisponiblesParaPago(rnc, Empresas.Facturacion.Factura.eConcepto.SDSS, Nothing, Nothing)

        If dt.Rows.Count > 0 Then
            Me.pnlInfoBanco.Visible = True
            Me.gvInfoBanco.DataSource = dt
            Me.gvInfoBanco.DataBind()
        Else
            Me.pnlInfoBanco.Visible = False

        End If

    End Sub

    Protected Sub gvInfoBanco_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvInfoBanco.RowDataBound
        Dim PuedePagar As Label = CType(e.Row.FindControl("lblPuedePagar"), Label)
        Dim lbtnSi As LinkButton = CType(e.Row.FindControl("lnkBtnSi"), LinkButton)
        Dim lbtnNo As LinkButton = CType(e.Row.FindControl("lnkBtnNo"), LinkButton)

        If PuedePagar IsNot Nothing Then
            If PuedePagar.Text = "S" Then
                lbtnSi.Visible = True
                lbtnNo.Visible = False
            Else
                lbtnSi.Visible = False
                lbtnNo.Visible = True
            End If
        End If


    End Sub

    Protected Function formateaRNC(ByVal rnc As String) As String

        If rnc = String.Empty Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormatearRNCCedula(rnc)
        End If

    End Function

    Protected Function FormateaTelefono(ByVal telefono As String) As String

        If telefono <> String.Empty Then
            Return Utilitarios.Utils.FormatearTelefono(telefono)
        Else
            Return String.Empty
        End If

    End Function

    Protected Function ValidarNull(ByVal texto As Object) As String

        If IsDBNull(texto) Then
            Return String.Empty
        Else
            Return CStr(texto)
        End If
        Return String.Empty
    End Function

    Protected Function formateaNSS(ByVal nss As String) As String
        Return Utilitarios.Utils.FormatearNSS(nss)
    End Function

    Protected Function formateaPeriodo(ByVal Periodo As String) As String

        If Periodo = String.Empty Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormateaPeriodo(Periodo)
        End If

    End Function

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Limpiar()
    End Sub

    Protected Sub Limpiar()
        Me.txtAcuerdo.Text = String.Empty
        Me.txtRNC.Text = String.Empty
        Me.txtRazonSocial.Text = String.Empty
        Me.txtDesde.Text = String.Empty
        Me.txtHasta.Text = String.Empty
        Me.lblMensaje.Text = String.Empty
        Me.gvData.DataSource = Nothing
        Me.lblRnc.Text = String.Empty
        Me.lblRazonSocial.Text = String.Empty
        Me.lblNombreComercial.Text = String.Empty
        Me.pnlInfoEmpleador.Visible = False
        Me.gvData.DataBind()
        Me.gvRepresentantes.DataBind()
        Me.pnlRepresentantes.Visible = False
        Me.pnlAcuerdos.Visible = False
        Me.gvDetalleAcuerdo.DataSource = Nothing
        Me.gvDetalleAcuerdo.DataBind()
        Me.pnlDetalleAcuerdo.Visible = False
        Me.gvHistorial.DataSource = Nothing
        Me.gvHistorial.DataBind()
        Me.pnlHistorial.Visible = False

        Me.pnlTaps.Visible = False

    End Sub

    Protected Sub LimpiarBusquedaActual()

        Me.lblMensaje.Text = String.Empty
        Me.gvData.DataSource = Nothing
        Me.lblRnc.Text = String.Empty
        Me.lblRazonSocial.Text = String.Empty
        Me.lblNombreComercial.Text = String.Empty
        Me.pnlInfoEmpleador.Visible = False
        Me.gvData.DataBind()
        Me.gvRepresentantes.DataBind()
        Me.pnlRepresentantes.Visible = False
        Me.pnlAcuerdos.Visible = False
        Me.gvDetalleAcuerdo.DataSource = Nothing
        Me.gvDetalleAcuerdo.DataBind()
        Me.pnlDetalleAcuerdo.Visible = False
        Me.gvHistorial.DataSource = Nothing
        Me.gvHistorial.DataBind()
        Me.pnlHistorial.Visible = False

    End Sub

  
End Class