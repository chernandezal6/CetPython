Imports System.Data
Imports SuirPlus
Partial Class Legal_ReimprimirAcuerdoPago
    Inherits BasePage
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        Try
            Dim RegPat As Integer
            Dim IDRegPat As Nullable(Of Integer) = Nothing
            Dim IDAcuerdo As Nullable(Of Integer) = Nothing
            Dim TipoAcuerdo As Nullable(Of SuirPlus.Legal.eTiposAcuerdos) = Nothing
            Dim vec() As String

            'Validamos el tipo de acuerdo
            If Not String.IsNullOrEmpty(Me.txtAcuerdo.Text) Then
                vec = Legal.AcuerdosDePago.ValidateTipoAcuerdo(txtAcuerdo.Text).Split("|")
                IDAcuerdo = vec(0)
                TipoAcuerdo = CInt(vec(1))
            End If
            If Not txtAcuerdo.Text.Contains("AE-") And Not txtAcuerdo.Text.Contains("AO-") Then
                lblMensaje.Text = "Digite un acuerdo de pago válido"
                Me.pnlAcuerdo.Visible = False
                Exit Sub
            End If

            Dim Emp As DataTable
            'Obtengo el registro patronal por el RNC o por el ID del Acuerdo de pago
            If Not Me.txtRNC.Text = String.Empty Then
                Emp = Empresas.Empleador.getEmpleadorDatos(Me.txtRNC.Text)
                IDRegPat = Convert.ToInt32(Emp.Rows(0)("id_registro_patronal"))
            ElseIf Not Me.txtAcuerdo.Text = String.Empty Then
                Try
                    'Si el número de acuerdo no existe la instancia de acuerdo de pago da error "No Table at Position 0"
                    Dim Acuerdo As Legal.AcuerdosDePago = New Legal.AcuerdosDePago(IDAcuerdo, TipoAcuerdo)
                    Emp = Empresas.Empleador.getEmpleadorDatos(Acuerdo.RNC)
                    IDAcuerdo = Convert.ToInt32(Acuerdo.idAcuerdo)
                Catch ex As Exception
                    Me.lblMensaje.Text = "No Existe información para mostrar que cumpla con el criterio especificado."
                    SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                    Return
                End Try
            Else
                Return
            End If

            If Emp.Rows.Count <= 0 Then
                Me.lblMensaje.Text = "No Existe información para mostrar que cumpla con el criterio especificado."
                Return
            End If

            RegPat = Emp.Rows(0)("id_registro_patronal")
            Me.txtRazonSocial.Text = Emp.Rows(0)("Razon_Social")
            Me.TxtNombreComercial.Text = Emp.Rows(0)("Nombre_Comercial")
            Me.txtTelefono.Text = Utilitarios.Utils.FormatearTelefono(Emp.Rows(0)("Telefono_1"))

            Dim dt As DataTable = Legal.AcuerdosDePago.getAcuerdosPorEmpleador(IDRegPat, IDAcuerdo, TipoAcuerdo)
            Me.gvAcuerdos.DataSource = dt
            Me.gvAcuerdos.DataBind()
            Me.pnlAcuerdo.Visible = True

        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub
    Protected Sub gvAcuerdos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        Dim vec() As String
        vec = e.CommandArgument.ToString().Split("|")
        'Si el tipo es de Ley
        If CInt(vec(1)) = 2 Then
            Response.Redirect("ImprimirAcuerdoPagoPopUp.aspx?idAcuerdoPago=" & CInt(vec(0)))
            'Si el tipo es ordinario
        ElseIf CInt(vec(1)) = 3 Then

            Response.Redirect("adpImprimirAcuerdoPagoPopUp.aspx?idAcuerdoPago=" & CInt(vec(0)) & "&tipoAcuerdo=" & CInt(vec(1)))
            'Si el tipo es embajadas
        ElseIf CInt(vec(1)) = 4 Then
            Response.Redirect("adpImprimirAcuerdoPagoPopUp.aspx?idAcuerdoPago=" & CInt(vec(0)) & "&tipoAcuerdo=" & CInt(vec(1)))
        End If
    End Sub
    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.pnlAcuerdo.Visible = False
        Me.lblMensaje.Text = String.Empty
        Me.txtRNC.Text = String.Empty
        Me.txtAcuerdo.Text = String.Empty
        Me.txtRNC.Focus()
    End Sub

End Class
