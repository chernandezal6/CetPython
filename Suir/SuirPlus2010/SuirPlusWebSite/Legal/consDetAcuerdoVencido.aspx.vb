Imports SuirPlus.Utilitarios
Imports SuirPlus
Partial Class Legal_consDetAcuerdosVencidos
    Inherits BasePage
    Dim idAcuerdo As Integer
    Dim cuota As Integer
    Dim tipoAcuerdo As Integer
    Dim regPatronal As String = String.Empty
    Dim nombres As String = String.Empty
    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not (Me.Request("Id") = String.Empty) And Not (Me.Request("cuota") = String.Empty And Not (Me.Request("tipo") = String.Empty)) Then
            idAcuerdo = Request("Id")
            cuota = Request("cuota")
            tipoAcuerdo = Request("tipo")
            Me.lblIdAcuerdo.Visible = True
            Me.lblCuota.Visible = True
            Me.lblIdAcuerdo.Text = idAcuerdo
            Me.lblCuota.Text = cuota

            bindGridView()
            bindInfo()
        End If
    End Sub
    Protected Sub bindGridView()
        Dim dt As New Data.DataTable
        Try
            dt = Legal.AcuerdosDePago.getDetAcuerdoVencido(idAcuerdo, tipoAcuerdo)
            If dt.Rows.Count > 0 Then
                Me.gvDetAcuerdosVencidos.DataSource = dt
                Me.gvDetAcuerdosVencidos.DataBind()
                Me.pnlDetalle.Visible = True
                Me.lblTotal.Text = String.Format("{0:c}", dt.Rows(0)("TOTAL"))
            Else
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existen registros"
            End If
        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btncancelar.Click
        LimpiarCRMRegistros()
        Response.Redirect("consAcuerdosVencidos.aspx")
    End Sub

    Protected Sub bindInfo()
         Dim dtInfo As New Data.DataTable
        Try

            Dim Legal As New Legal.AcuerdosDePago(Me.idAcuerdo, tipoAcuerdo)

            If Not Legal.RNC = String.Empty Then
                Me.lblTipoDoc.Text = Legal.TipoDocumento
                If Me.lblTipoDoc.Text = "Cédula" Then
                    Me.lblNroDoc.Text = Utils.FormatearCedula(Legal.NoDocumento)
                Else
                    Me.lblNroDoc.Text = Legal.NoDocumento
                End If
                Me.lblNombres.Text = Legal.Nombres
                Me.lblRNC.Text = Legal.RNC
                Me.lblRazonSocial.Text = Legal.RazonSocial
                Me.lbltipoAcuerdo.Text = Legal.TipoAcuerdo
                Me.lblFechaReg.Text = String.Format("{0:d}", Legal.FechaReg)
                Me.lblfechaTermino.Text = String.Format("{0:d}", Legal.FechaTerm)
                Me.lblstatus.Text = Legal.Status
                Me.lblEstadoCivil.Text = Legal.EstadoCivil
                Me.lblDireccion.Text = Legal.Direccion
                Me.lblNacionalidad.Text = Legal.Nacionalidad
                Me.lblPeriodoIni.Text = Utils.FormateaPeriodo(Legal.PeriodoIni)
                Me.lblPeriodoFin.Text = Utils.FormateaPeriodo(Legal.PeriodoFin)
                Me.lblTel1.Text = Utils.FormatearTelefono(Legal.Telefono1)
                Me.lblTel2.Text = Utils.FormatearTelefono(Legal.Telefono2)

                regPatronal = Legal.RegPatronal
            Else
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existen registros"
            End If
        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub btnContactado_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnContactado.Click
        Try
            bindInfo()
            Dim str As String = Empresas.CRM.insertaRegistroCRM(CInt(regPatronal), "NOTIFICADO POR COBROS", 1, 0, _
                                Me.txtContacto.Text, Me.txtDescripcion.Text, Me.UsrUserName, Nothing, Nothing, Nothing)

            If Split(str, "|")(0) = "0" Then
                Me.lblMsg.Visible = True
                Me.lblMsg.CssClass = "subHeader"
                Me.lblMsg.Text = "El Registro CRM #" + Split(str, "|")(1).ToString() + " fue insertado satisfactoriamente."
                Me.btnVolver.Visible = True

                LimpiarCRMRegistros()
            Else
                Me.lblMsg.Visible = True
                Me.lblMsg.CssClass = "error"
                Me.lblMsg.Text = "Error insertando CRM: " + Split(str, "|")(1).ToString()
                Exit Sub

            End If
        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.CssClass = "error"
            Me.lblMsg.Text = ex.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub
    Protected Sub LimpiarCRMRegistros()
        Me.gvDetAcuerdosVencidos.DataSource = Nothing
        Me.gvDetAcuerdosVencidos.DataBind()
        Me.txtContacto.Text = String.Empty
        Me.txtDescripcion.Text = String.Empty
        Me.pnlDetalle.Visible = False

    End Sub
    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVolver.Click
        LimpiarCRMRegistros()
        Response.Redirect("consAcuerdosVencidos.aspx")
    End Sub
    Protected Function formateaReferencia(ByVal Ref As Object) As Object

        If Not Ref Is DBNull.Value Then

            Return Utilitarios.Utils.FormateaReferencia(Ref.ToString)

        End If

        Return Ref
    End Function
End Class
