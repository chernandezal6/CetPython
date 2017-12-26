Imports SuirPlus
Imports System.Data

Partial Class Consultas_consPagosExcesosCiudadanos
    Inherits BasePage

    Public Rec As New SuirPlusEF.Repositories.CiudadanoRepository

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim msg As New DataTable
        Dim modulo As String
        modulo = "MSG_PAG_EX"
        msg = Finanzas.DevolucionAportes.getMsgPagosExceso(modulo)

        If msg.Rows.Count > 0 Then
            lblAviso.InnerText = msg.Rows(0)("FIELD3").ToString()
            lblAviso.Visible = True
        End If


        Dim ruta = HttpContext.Current.Request.Url.AbsolutePath
        ruta = ruta.Replace(".aspx", "")
        ucCaptcha1.capturarRuta = ruta
        ucCaptcha1.DataBind()
        ucCaptcha1.Visibilidad(False)
        BotonesBL.Visible = True

        AddHandler ucCaptcha1.RespuestaCaptchaClicked, AddressOf ucCaptcha1_RespuestaCaptchaClicked
        AddHandler ucCaptcha1.SalirCaptchaClicked, AddressOf ucCaptcha1_SalirCaptchaClicked
    End Sub

    Private Sub ucCaptcha1_SalirCaptchaClicked(sender As Object, e As EventArgs)
        Response.Redirect("consPagosExcesosCiudadanos.aspx")
    End Sub
    Private Sub ucCaptcha1_RespuestaCaptchaClicked(sender As Object, e As EventArgs)
        ContinuarPosValidacion()
    End Sub

    Protected Sub Btn_Buscar_Click(sender As Object, e As System.EventArgs) Handles Btn_Buscar.Click

        Try

            If Me.txtnodocumento.Text = String.Empty Then
                Me.lblError.Visible = True
                Me.lblError.Text = "<p  class=msg>La cédula es requerida</p>"
            ElseIf txtnodocumento.Text.Length < 11 Then
                Me.lblError.Visible = True
                Me.lblError.Text = "<p class=msg>La cédula es inválida, para más información puede comunicarse con una de <a href =http://www.tss.gov.do/contact_frame.htm class=msg> nuestras oficinas</a>.</p>"

            Else
                txtnodocumento.Enabled = False
                Me.lblError.Visible = False
                Me.lblError.Text = String.Empty

                Dim Ciudadano = Rec.GetByNroDocumento(txtnodocumento.Text, "C", Nothing)
                If Ciudadano Is Nothing Then
                    lblError.Text = "<p class=msg>La cédula no fue encontrada en nuestra base de datos.</p>"
                    lblError.Visible = True
                    txtnodocumento.Enabled = True
                    Return
                End If

                ucCaptcha1.Visibilidad(True)
                BotonesBL.Visible = False
                ucCaptcha1.Campo1 = Ciudadano.FechaNacimiento
                ucCaptcha1.Campo2 = Ciudadano.PrimerApellido

            End If
        Catch ex As Exception
            lblError.Text = "<p class=error>" + ex.Message + "</p>"
            lblError.Visible = True
        End Try
    End Sub

    Protected Function formateaCedula(ByVal Cedula As String) As String

        If Cedula = String.Empty Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormatearCedula(Cedula)
        End If

    End Function

    Protected Sub Btn_Limpiar_Click(sender As Object, e As System.EventArgs) Handles Btn_Limpiar.Click
        Response.Redirect("consPagosExcesosCiudadanos.aspx")
    End Sub
    Protected Sub gvPagoExcesoCiu_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPagoExcesoCiu.RowDataBound

        Dim Cuenta As Label = CType(e.Row.FindControl("lblCuenta"), Label)
        Dim Monto As Label = CType(e.Row.FindControl("lblMonto"), Label)
        Dim valor As Decimal = 0

        If e.Row.RowType = DataControlRowType.DataRow Then

            If Cuenta.Text = Nothing Then
                Cuenta.Text = "Cheque"

            Else
                Cuenta.Text = "Banreservas"
                valor = Convert.ToDecimal(Monto.Text)
            End If

            Monto.Text = FormatCurrency(Monto.Text)

        End If

    End Sub

    Public Sub LlenarDatosPagos(ByVal dt As DataTable)
        HttpContext.Current.Session("dtTest") = dt
    End Sub
    Public Sub ContinuarPosValidacion()

        Me.lblError.Visible = False
        Me.lblError.Text = String.Empty
        Dim dt As New DataTable
        Dim msg As New DataTable
        Dim modulo As String
        modulo = "MSG_PAG_EX"

        dt = Finanzas.DevolucionAportes.GetPagosExcesoCiudadano(txtnodocumento.Text)
        msg = Finanzas.DevolucionAportes.getMsgPagosExceso(modulo)

        If ucCaptcha1.IsValid Then

            If dt.Rows.Count <= 0 Then
                lblError.Text = "<p class=msg>No tiene reembolso pendiente.</p>"
                lblError.Visible = True

            ElseIf dt.Rows(0)("ESTATUS").ToString() = "CA" Then
                lblCedula.Text = formateaCedula(txtnodocumento.Text)
                lblNombre.Text = dt.Rows(0)("NOMBRES").ToString() + " " + dt.Rows(0)("PRIMER_APELLIDO").ToString()
                gvPagoExcesoCiu.DataSource = dt
                gvPagoExcesoCiu.DataBind()
                pnlInfo.Visible = True
                pnlPagos.Visible = True
            ElseIf (dt.Rows(0)("NRO_CUENTA").ToString() = String.Empty) Then
                If msg.Rows.Count > 0 Then
                    LblInfo.Text = msg.Rows(0)("FIELD2").ToString()
                    LblInfo.Visible = True
                End If
                lblCedula.Text = formateaCedula(txtnodocumento.Text)
                lblNombre.Text = dt.Rows(0)("NOMBRES").ToString() + " " + dt.Rows(0)("PRIMER_APELLIDO").ToString()
                gvPagoExcesoCiu.DataSource = dt
                gvPagoExcesoCiu.DataBind()
                pnlInfo.Visible = True
                pnlPagos.Visible = True
            ElseIf (dt.Rows(0)("NRO_CUENTA").ToString() <> String.Empty) Then
                If msg.Rows.Count > 0 Then
                    LblInfo.Text = msg.Rows(0)("FIELD1").ToString()
                    LblInfo.Visible = True
                End If
                lblCedula.Text = formateaCedula(txtnodocumento.Text)
                lblNombre.Text = dt.Rows(0)("NOMBRES").ToString() + " " + dt.Rows(0)("PRIMER_APELLIDO").ToString()
                gvPagoExcesoCiu.DataSource = dt
                gvPagoExcesoCiu.DataBind()
                pnlInfo.Visible = True
                pnlPagos.Visible = True
            Else
                lblError.Text = "<p class=msg>No tiene reembolso pendiente.</p>"
                lblError.Visible = True
            End If
            Btn_Buscar.Enabled = False
            txtnodocumento.Enabled = False
        Else
            lblError.Text = "<p class=msg>Las respuestas no satisfacen las preguntes realizadas, favor intente de nuevo</p>"
            lblError.Visible = True
            ucCaptcha1.Visibilidad(True)
            BotonesBL.Visible = False
            hdcontador.Value = hdcontador.Value + "1"
            If hdcontador.Value = "111" Then
                Dim Url = HttpContext.Current.Request.Url.AbsolutePath
                Response.Redirect(Url)
            End If
        End If
    End Sub
    Public Class DatosPagos
        Public ReadOnly Property Monto() As String
            Get
                Return HttpContext.Current.Session("monto")
            End Get
        End Property
        Public ReadOnly Property Nombres() As String
            Get
                Return HttpContext.Current.Session("nombres")
            End Get
        End Property
        Public ReadOnly Property Apellidos() As String
            Get
                Return HttpContext.Current.Session("primer_apellido")
            End Get

        End Property
        Public ReadOnly Property Documento() As String
            Get
                Return HttpContext.Current.Session("no_documento")
            End Get
        End Property
        Public ReadOnly Property Estatus() As String
            Get
                Return HttpContext.Current.Session("estatus")
            End Get
        End Property
        Public ReadOnly Property FechaNacimiento() As String
            Get
                Return HttpContext.Current.Session("fecha_nacimiento")
            End Get
        End Property

    End Class


End Class
