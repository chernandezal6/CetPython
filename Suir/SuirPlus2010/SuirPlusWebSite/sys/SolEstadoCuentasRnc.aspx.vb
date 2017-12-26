Imports System.Data
Imports SuirPlus
Imports SuirPlus.SolicitudesEnLinea
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios

Partial Class sys_SolEstadoCuentasRnc
    Inherits BasePage

    Private totalNot As Double = 0
    Private totalLiq As Double = 0
    Private totalIR As Double = 0
    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Put user code to initialize the page here
    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Me.btnConsultar.Visible = False

        Me.lblError.Visible = False

        If Me.ValidarInfo() = True Then

            Me.pnlInfo.Visible = True
            Me.pnlEstadoCuenta.Visible = True
            Me.pnlSeleccion.Visible = True

            Me.MostrarHeader()

            Me.MostrarGrid()

            'Me.SeleccionarServicio()

        Else
            Me.btnConsultar.Visible = True

            Me.lblError.Visible = True
            Me.lblError.Text = "Error con el RNC o Representante"
        End If

    End Sub

    'Public Sub SeleccionarServicio()
    '    Me.pnlEstadoCuenta.Visible = True
    '    Me.pnlSeleccion.Visible = True


    'End Sub

    Public Sub EnviarPorFax()
        Me.pnlEmail.Visible = False

        Me.pnlFax.Visible = True

        Dim emp As New SuirPlus.Empresas.Empleador(Me.txtRnc.Text)
        Me.ctrlFax.PhoneNumber = emp.Fax



    End Sub

    Public Sub EnviarPorEmail()
        Me.pnlFax.Visible = False
        Me.pnlEmail.Visible = True
    End Sub

    Public Sub EnviarSolPorFax()
        Dim NumeroSolicitud As String
        Dim valor1 As String
        Dim valor2 As String
        'Dim validaRep As String
        Dim Res As String()

        Dim Comentario As String
        Comentario = "Solicitado por www.tss.gov.do"

        Dim emp As New SuirPlus.Empresas.Empleador(Me.txtRnc.Text)

        If Replace(emp.Fax, "-", "") = Replace(Me.ctrlFax.PhoneNumber, "-", "") Then
            Comentario = "Solicitado por www.tss.gov.do"
        Else
            Me.ActualizarFax()

        End If

        Try
            NumeroSolicitud = SuirPlus.SolicitudesEnLinea.Solicitudes.crearSolicitud(4, 0, Me.txtRnc.Text, Me.txtCedula.Text, "", "F: " & Comentario)

            Res = NumeroSolicitud.Split("|")
            valor1 = Res(0)
            valor2 = Res(1)

            If valor1 = "0" Then

                Response.Redirect("SolicitudCreada.aspx?tipo=F&fax=" & Me.ctrlFax.PhoneNumber & "&id=" & valor2)

            Else

                Me.lblError.Visible = True
                Me.lblError.Text = valor2

            End If
        Catch ex As Exception
            Response.Redirect("error.aspx?errMsg=" & ex.ToString())
        End Try
    End Sub

    Public Sub EnviarSolPorEmail()
        Dim NumeroSolicitud As String
        Dim valor1 As String
        Dim valor2 As String
        'Dim validaRep As String
        Dim Res As String()

        Dim Comentario As String
        Comentario = "Solicitado por www.tss.gov.do"

        Dim emp As New SuirPlus.Empresas.Empleador(Me.txtRnc.Text)

        If (Me.lblCorreoActual.Text = Nothing) And (Me.txtNuevoCorreo.Text = Nothing) And (Me.txtConfirmacion.Text = Nothing) Then
            Me.lblError.Visible = True
            Me.lblError.Text = "Debe Agregar un nuevo email y confirmarlo"
            Exit Sub
        Else
            Me.lblError.Visible = False
        End If

        If (Me.lblCorreoActual.Text = Nothing) And (Me.txtNuevoCorreo.Text <> Me.txtConfirmacion.Text) Then
            Me.lblError.Visible = True
            Me.lblError.Text = "El nuevo correo debe ser identico en la confirmación"
            Exit Sub
        Else
            Me.lblError.Visible = False
        End If
        If (Me.lblCorreoActual.Text = Nothing) And (Me.txtNuevoCorreo.Text <> Nothing) And (Me.txtConfirmacion.Text <> Nothing) Then
            Me.ActualizarEmail()
        End If

        If (Me.lblCorreoActual.Text <> Nothing) And (Me.txtNuevoCorreo.Text = Nothing) And (Me.txtConfirmacion.Text = Nothing) Then
            Comentario = "Solicitado por www.tss.gov.do"

        ElseIf (Me.lblCorreoActual.Text <> Nothing) And (Me.txtNuevoCorreo.Text = Me.txtConfirmacion.Text) And (Me.txtConfirmacion.Text <> Me.lblCorreoActual.Text) Then
            Me.ActualizarEmail()
        End If

        Try
            NumeroSolicitud = SuirPlus.SolicitudesEnLinea.Solicitudes.crearSolicitud(4, 0, Me.txtRnc.Text, Me.txtCedula.Text, "", "E: " & Comentario)

            Res = NumeroSolicitud.Split("|")
            valor1 = Res(0)
            valor2 = Res(1)

            If valor1 = "0" Then
                Response.Redirect("SolicitudCreada.aspx?tipo=Em&Email=" & Me.lblCorreoActual.Text & "&id=" & valor2)

            Else

                Me.lblError.Visible = True
                Me.lblError.Text = valor2

            End If
        Catch ex As Exception
            Response.Redirect("error.aspx?errMsg=" & ex.ToString())
        End Try
    End Sub

    Private Sub ActualizarEmail()
        Try

            Dim rep As New SuirPlus.Empresas.Representante(Me.txtRnc.Text, Me.txtCedula.Text)
            rep.FacturaXEmail = "S"
            rep.Email = Me.txtNuevoCorreo.Text
            rep.GuardarCambios(Me.txtRnc.Text & Me.txtCedula.Text)

            Me.lblCorreoActual.Text = rep.email

        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try
    End Sub

    Private Sub ActualizarFax()
        Try
            'actualizamos el fax del empleador
            Dim emp As New SuirPlus.Empresas.Empleador(Me.txtRnc.Text)
            If Replace(emp.Fax, "-", "") <> Replace(Me.ctrlFax.PhoneNumber, "-", "") Then
                emp.Fax = Me.ctrlFax.PhoneNumber.Replace("-", "")
                emp.GuardarCambios(Me.txtRnc.Text & Me.txtCedula.Text)

            End If

        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try
    End Sub

    Public Function ValidarInfo() As Boolean

        Return SuirPlus.SolicitudesEnLinea.Solicitudes.isRepresentanteEnEmpresa(Me.txtRnc.Text, Me.txtCedula.Text)

    End Function

    Public Sub MostrarHeader()

        Try

            Dim emp As New SuirPlus.Empresas.Empleador(Me.txtRnc.Text)
            Dim rep As New SuirPlus.Empresas.Representante(Me.txtRnc.Text, Me.txtCedula.Text)


            Me.lblNombreComercial.Text = emp.NombreComercial
            Me.lblNombreComercial.Visible = True
            Me.lblRazonSocial.Text = emp.RazonSocial
            Me.lblRazonSocial.Visible = True
            Me.lblRepresentante.Text = rep.NombreCompleto
            Me.lblCorreoActual.Text = rep.Email

            Me.lblRepresentante.Visible = True
            Me.pnlEstadoCuenta.Visible = True

        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try

    End Sub

    Public Sub MostrarGrid()

        ' Me.pnlEstadoCuenta.Visible = True
        'Me.pnlInfo.Visible = True

        Dim dtTSS As DataTable = SuirPlus.Empresas.Facturacion.Factura.getNotificacionesPendientePago(SuirPlus.Empresas.Facturacion.Factura.eConcepto.SDSS, Me.txtRnc.Text)
        Dim dtISR As DataTable = SuirPlus.Empresas.Facturacion.Factura.getNotificacionesPendientePago(SuirPlus.Empresas.Facturacion.Factura.eConcepto.ISR, Me.txtRnc.Text)
        Dim dtIR17 As DataTable = SuirPlus.Empresas.Facturacion.Factura.getNotificacionesPendientePago(SuirPlus.Empresas.Facturacion.Factura.eConcepto.IR17, Me.txtRnc.Text)

        Me.dgTSS.Visible = True
        Me.dgTSS.DataSource = dtTSS
        Me.dgTSS.DataBind()


        Me.dgDGII.Visible = True
        Me.dgDGII.DataSource = dtISR
        Me.dgDGII.DataBind()

        Me.dgIR17.Visible = True
        Me.dgIR17.DataSource = dtIR17
        Me.dgIR17.DataBind()

    End Sub

    Protected Sub dgTSS_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgTSS.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Try
                totalNot += Convert.ToDecimal("0" + Trim(Replace(Replace(e.Row.Cells(3).Text, ",", ""), "RD$", "")))
            Catch ex As Exception
            End Try
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(2).Text = "Total: "
            e.Row.Cells(2).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(2).Font.Bold = True
            e.Row.Cells(3).Text = String.Format("{0:c}", totalNot)
            e.Row.Cells(3).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(3).Font.Bold = True
        End If
    End Sub

    Protected Sub dgDGII_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgDGII.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Try
                totalLiq += Convert.ToDecimal("0" + Trim(Replace(Replace(e.Row.Cells(3).Text, ",", ""), "RD$", "")))
            Catch ex As Exception
            End Try
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(2).Text = "Total: "
            e.Row.Cells(2).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(2).Font.Bold = True
            e.Row.Cells(3).Text = String.Format("{0:c}", totalLiq)
            e.Row.Cells(3).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(3).Font.Bold = True
        End If
    End Sub

    Protected Sub dgIR17_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgIR17.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Try
                totalIR = Convert.ToDecimal("0" + Trim(Replace(Replace(e.Row.Cells(3).Text, ",", ""), "RD$", "")))
            Catch ex As Exception
            End Try
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(2).Text = "Total: "
            e.Row.Cells(2).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(2).Font.Bold = True
            e.Row.Cells(3).Text = String.Format("{0:c}", totalIR)
            e.Row.Cells(3).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(3).Font.Bold = True
        End If
    End Sub

    Private Sub btEmail_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btEmail.Click
        Me.btFax.Enabled = False
        Me.pnlEstadoCuenta.Visible = False
        Me.EnviarPorEmail()
    End Sub

    Private Sub btFax_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btFax.Click
        Me.btEmail.Enabled = False
        Me.pnlEstadoCuenta.Visible = False
        Me.EnviarPorFax()
    End Sub

    Private Sub btActFax_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btActFax.Click
        If Me.ctrlFax.PhoneNumber <> String.Empty Then
            Me.EnviarSolPorFax()
        Else
            Me.lblError.Visible = True
            Me.lblError.Text = "El número de fax es requerido"
            Exit Sub
        End If
    End Sub

    Private Sub btActEmail_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btActEmail.Click
        Me.EnviarSolPorEmail()
    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.btnConsultar.Visible = True
        Response.Redirect("SolEstadoCuentasRnc.aspx")
    End Sub

    Private Sub btnCancelarFax_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelarFax.Click
        Me.lblError.Visible = False

        Me.btEmail.Enabled = True
        Me.btFax.Enabled = True
        Me.pnlFax.Visible = False
        Me.pnlEstadoCuenta.Visible = True
    End Sub

    Private Sub btnCancelarEmail_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelarEmail.Click
        Me.lblError.Visible = False

        Me.btFax.Enabled = True
        Me.btEmail.Enabled = True
        Me.pnlEmail.Visible = False
        Me.pnlEstadoCuenta.Visible = True

        Me.txtNuevoCorreo.Text = String.Empty

        Me.txtConfirmacion.Text = String.Empty
    End Sub
End Class
