
Partial Class Controles_ucNovedadesPendientesaCambiar
    Inherits System.Web.UI.UserControl

    Private v_RegistroPatronal As Integer
    Public Property RegistroPatronal() As Integer
        Get
            Return v_RegistroPatronal
        End Get
        Set(ByVal value As Integer)
            v_RegistroPatronal = value
        End Set
    End Property

    Private v_NSS As Integer
    Public Property NSS() As Integer
        Get
            Return v_NSS
        End Get
        Set(ByVal value As Integer)
            v_NSS = value
        End Set
    End Property

    Private v_usrUsername As String
    Public Property usrUsernameControl() As String
        Get
            Return v_usrUsername
        End Get
        Set(ByVal value As String)
            v_usrUsername = value
        End Set
    End Property

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        'Boton inhabilitado para aplicar la novedad
        btnAplicarNovedad.Visible = False
        lbMensaje.Text = String.Empty

        If Not IsPostBack Then
            CargarNovedadesPendientes()
        End If

    End Sub

    Sub CargarNovedadesPendientes()
        Try
            Dim GetData = SuirPlus.MDT.General.getNovedadesPendientesaCambio(RegistroPatronal)
            If GetData.Rows.Count > 0 Then
                gvNovedadesPendientes.DataSource = GetData
                gvNovedadesPendientes.DataBind()
                'gvNovedadesPendientes.Columns(1).Visible = False
                lbMensaje.Text = String.Empty
                btnAplicarNovedad.Visible = True
            Else
                lbMensaje.Text = "Este empleador no tiene novedades pendientes para aplicar."

            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub btnAplicarNovedad_Click(sender As Object, e As System.EventArgs) Handles btnAplicarNovedad.Click

        If gvNovedadesPendientes.Rows.Count > 0 Then
            If SuirPlus.MDT.General.AplicarNovedadesPendientesMDT(CInt(RegistroPatronal), usrUsernameControl).ToString() = "OK" Then
                gvNovedadesPendientes.DataSource = ""
                gvNovedadesPendientes.DataBind()

                lbMensaje.Text = "Novedades procesadas satisfactoriamente."
            Else
                lblMensajeError.Text = SuirPlus.MDT.General.AplicarNovedadesPendientesMDT(RegistroPatronal, usrUsernameControl).ToString()

            End If
        Else
            lbMensaje.Text = "No tiene novedades pendientes."
        End If
        'End If
    End Sub

    Public Function arrayToString(StringArray() As String)
        Dim str As String = "|"
        Dim Resultado As String = String.Empty
        For i As Integer = 0 To StringArray.Length - 1
            If StringArray(i) <> Nothing Then
                Resultado = Resultado + str + StringArray(i)
            End If
        Next
        Resultado = Resultado.TrimStart("|")
        Resultado = Resultado.TrimEnd("|")

        Return Resultado
    End Function

    Protected Sub gvNovedadesPendientes_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvNovedadesPendientes.RowCommand
        Dim IdNSS As String = Split(e.CommandArgument, "|")(0)
        Dim tipo_cambio As String = Split(e.CommandArgument, "|")(1)
        Dim fecha_cambio As String = Split(e.CommandArgument, "|")(2)


        Try
            If e.CommandName = "Borrar" Then
                If SuirPlus.MDT.General.EliminarNovedadesPendientesMDT2(CInt(RegistroPatronal), CInt(IdNSS), tipo_cambio, fecha_cambio).ToString() = "OK" Then
                    gvNovedadesPendientes.DataSource = ""
                    gvNovedadesPendientes.DataBind()

                    lbMensaje.Text = "Novedad eliminada."
                Else
                    lblMensajeError.Text = SuirPlus.MDT.General.EliminarNovedadesPendientesMDT2(CInt(RegistroPatronal), CInt(IdNSS), tipo_cambio, fecha_cambio).ToString()

                End If

                CargarNovedadesPendientes()
            End If
        Catch ex As Exception
            Me.lblMensajeError.Visible = True
            Me.lblMensajeError.Text = ex.Message
        End Try
    End Sub



End Class





