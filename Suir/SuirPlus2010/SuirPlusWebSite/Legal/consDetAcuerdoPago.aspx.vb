Imports SuirPlus.Utilitarios
Imports SuirPlus
Partial Class Legal_consDetAcuerdoPago
    Inherits BasePage
    Dim idAcuerdo As Integer
    Dim tipo As String = String.Empty
    Dim tipoAcuerdo As Integer
    Dim regPatronal As String = String.Empty


    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Me.Request("Id") = String.Empty Then
            idAcuerdo = Request("Id")
            tipo = Request("Tipo")
            tipoAcuerdo = Request("TipoAcuerdo")

            Me.lblIdAcuerdo.Visible = True
            Me.lblIdAcuerdo.Text = idAcuerdo
            Me.Session("tipo") = tipo
            If tipo = "CI" Then
                If Not Me.IsInPermiso("161") Then
                    Me.lblMsg.Text = "Usted no tiene los permisos necesarios para ver esta pagina."
                    Exit Sub
                End If
                Me.pnlCI.Visible = True
            ElseIf tipo = "TS" Then
                If Not Me.IsInPermiso("162") Then
                    Me.lblMsg.Text = "Usted no tiene los permisos necesarios para ver esta pagina."
                    Exit Sub
                End If
                Me.pnlTS.Visible = True
            ElseIf tipo = "CB" Then
                If Not Me.IsInPermiso("163") Then
                    Me.lblMsg.Text = "Usted no tiene los permisos necesarios para ver esta pagina."
                    Exit Sub
                End If
                Me.pnlCB.Visible = True
            Else
                Me.pnlCI.Visible = False
                Me.pnlTS.Visible = False
                Me.pnlCB.Visible = False
            End If

            bindGridView()
            bindInfo()

        End If

    End Sub

    Protected Sub bindGridView()
        Dim dt As New Data.DataTable
        Dim ds As New AcuerdoPago
        Dim UltimaCuota As Integer = 0
        Try
            Dim dt2 As New Data.DataTable
            dt2 = Legal.AcuerdosDePago.getDetAcuerdoPagoFechaLimite(idAcuerdo, tipoAcuerdo)

            If dt2.Rows.Count > 0 Then
                Me.gvDetAcuerdoPago2.DataSource = dt2
                Me.gvDetAcuerdoPago2.DataBind()

                'dt = SuirPlus.Legal.AcuerdosDePago.getDetAcuerdoPago(idAcuerdo)

                'If dt.Rows.Count > 0 Then
                '    UltimaCuota = dt.Compute("max(Cuota)", String.Empty)
                '    ds.CuotasOrganizadas.Rows.Clear()

                '    For i As Integer = 1 To UltimaCuota
                '        ds.CuotasOrganizadas.AddCuotasOrganizadasRow(i, "", 0, DateTime.Now())
                '    Next

                '    Dim Cuota As Integer = 0
                '    Dim Total As Double = 0
                '    Dim Ref As String

                '    For Each rw As System.Data.DataRow In dt.Rows

                '        Cuota = Convert.ToInt16(rw("Cuota").ToString())
                '        Ref = rw("id_referencia").ToString()

                '        If Cuota = 0 Then Cuota = 1

                '        ds.CuotasOrganizadas.Rows(Cuota - 1)("Referencias") = ds.CuotasOrganizadas.Rows(Cuota - 1)("Referencias") & SuirPlus.Utilitarios.Utils.FormateaReferencia(Ref) & ", "

                '    Next

                '    Me.gvDetAcuerdoPago.DataSource = ds.CuotasOrganizadas
                '    Me.gvDetAcuerdoPago.DataBind()

            Else
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existe detalle para este acuerdo de pago"
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try


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
                ' Me.lblfechaTermino.Text = String.Format("{0:d}", Legal.FechaTerm)
                Me.lblstatus.Text = Legal.Status
                Me.lblEstadoCivil.Text = Legal.EstadoCivil
                Me.lblDireccion.Text = Legal.Direccion
                Me.lblNacionalidad.Text = Legal.Nacionalidad
                Me.lblPeriodoIni.Text = Utils.FormateaPeriodo(Legal.PeriodoIni)
                Me.lblPeriodoFin.Text = Utils.FormateaPeriodo(Legal.PeriodoFin)
                Me.lblTel1.Text = Utils.FormatearTelefono(Legal.Telefono1)
                Me.lblTel2.Text = Utils.FormatearTelefono(Legal.Telefono2)

                regPatronal = Legal.RegPatronal
                Me.Session("rncAcuerdoPago") = Legal.RNC

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

    Protected Sub btnVerificado_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVerificado.Click
        Try
            Me.txtComentario.Text = "Acuerdo de pago verificado por Control Interno"

            Legal.AcuerdosDePago.cambiarStatusAcuerdoPago(CInt(Me.idAcuerdo), tipoAcuerdo, 2, CInt(regPatronal), "Acuerdo de Pago", 1, Me.txtComentario.Text, Me.UsrUserName)
            Me.lblMsg.Visible = True
            Me.lblMsg.CssClass = "subHeader"
            Me.lblMsg.Text = "Acuerdo de pago verificado."
            Me.btnVolver.Visible = True
            Me.pnlInfo.Visible = False
        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub btnRechazarCI_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRechazarCI.Click

        If (Me.txtComentario.Visible = False) Or (Me.txtComentario.Text = String.Empty) Then
            Me.lblTituloComent.Visible = True
            Me.lblComentErr.Visible = True
            Me.txtComentario.Visible = True
            Exit Sub
        End If

        Try
            Legal.AcuerdosDePago.cambiarStatusAcuerdoPago(CInt(Me.idAcuerdo), tipoAcuerdo, 5, CInt(regPatronal), "Acuerdo de Pago Rechazado", 1, Me.txtComentario.Text, Me.UsrUserName)
            Me.lblMsg.Visible = True
            Me.lblMsg.CssClass = "subHeader"
            Me.lblMsg.Text = "Acuerdo de pago rechazado."
            Me.btnVolver.Visible = True
            Me.pnlInfo.Visible = False
        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub btnRegresarCI_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRegresarCI.Click
        Response.Redirect("consAcuerdosPagoCI.aspx")
    End Sub

    Protected Sub btnAprobado_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAprobado.Click
        Me.txtComentario.Text = "Acuerdo de pago aprobado por el Tesorero"
        Try
            Legal.AcuerdosDePago.cambiarStatusAcuerdoPago(CInt(Me.idAcuerdo), tipoAcuerdo, 3, CInt(regPatronal), "Acuerdo de Pago", 1, Me.txtComentario.Text, Me.UsrUserName)
            Me.lblMsg.Visible = True
            Me.lblMsg.CssClass = "subHeader"
            Me.lblMsg.Text = "Acuerdo de pago aprobado."
            Me.btnVolver.Visible = True
            Me.pnlInfo.Visible = False
        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub btnRechazarTS_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRechazarTS.Click
        'Regresar a Control Interno

        Try
            Legal.AcuerdosDePago.cambiarStatusAcuerdoPago(CInt(Me.idAcuerdo), tipoAcuerdo, 1, Nothing, Nothing, Nothing, Nothing, Me.UsrUserName)
            Me.lblMsg.Visible = True
            Me.lblMsg.CssClass = "subHeader"
            Me.lblMsg.Text = "Acuerdo de pago regresado a control interno."
            Me.btnVolver.Visible = True
            Me.pnlInfo.Visible = False
        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub btnRegresarTS_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRegresarTS.Click
        Response.Redirect("consAcuerdosPagoTS.aspx")
    End Sub

    Protected Sub btnContactado_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnContactado.Click

        Try
            Legal.AcuerdosDePago.cambiarStatusAcuerdoPago(CInt(Me.idAcuerdo), tipoAcuerdo, 4, CInt(regPatronal), "Acuerdo de Pago", 1, Me.txtComentario.Text, Me.UsrUserName)
            Me.lblMsg.Visible = True
            Me.lblMsg.CssClass = "subHeader"
            Me.lblMsg.Text = "Empleador contactado."
            Me.btnVolver.Visible = True
            Me.pnlInfo.Visible = False
        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub btnVolverCB_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVolverCB.Click
        Response.Redirect("consAcuerdosPagoCB.aspx")

    End Sub

    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVolver.Click

        If Session("tipo") = "CI" Then
            Response.Redirect("consAcuerdosPagoCI.aspx")
        ElseIf Session("tipo") = "TS" Then
            Response.Redirect("consAcuerdosPagoTS.aspx")
        ElseIf Session("tipo") = "CB" Then
            Response.Redirect("consAcuerdosPagoCB.aspx")
        End If

    End Sub

    Protected Sub lnkVerSolicitud_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkVerSolicitud.Click
        Try

            Me.UcImagen._RNC = Session("rncAcuerdoPago")
            Me.UcImagen._MostrarData()
        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub lnkVerAcuerdo_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkVerAcuerdo.Click
        'Dim ImgAcuerdo As Byte()
        'Try
        '    ImgAcuerdo = SuirPlus.Legal.AcuerdosDePago.getImagenAcuerdoPago(Me.idAcuerdo)

        '    If ImgAcuerdo IsNot Nothing Then
        Response.Redirect("verImagenAcuerdoPago.aspx?idAcuerdo=" & Me.idAcuerdo & "&tipoAcuerdo=" & tipoAcuerdo)
        '    Else
        'Throw New Exception("No existe la imagen de este acuerdo de pago")
        '    End If

        'Catch ex As Exception
        '    Me.lblMsg.Visible = True
        '    Me.lblMsg.Text = ex.Message
        '    SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        'End Try
    End Sub
End Class
