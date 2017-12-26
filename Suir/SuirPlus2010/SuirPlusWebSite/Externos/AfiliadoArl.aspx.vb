Partial Class Externos_AfiliadoArl
    Inherits BasePage

    Protected empleado As SuirPlus.Empresas.Trabajador
    'Protected UcEmpleado As ucInfoEmpleado

    Private Property idCiudadano() As String
        Get
            Return CType(ViewState("idCiudadano"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("idCiudadano") = Value
        End Set
    End Property

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Put user code to initialize the page here
    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click

        Me.idCiudadano = Me.txtCedulaNSS.Text

        Try

            If idCiudadano.Length < 11 Then
                empleado = New SuirPlus.Empresas.Trabajador(Convert.ToInt32(idCiudadano))
            ElseIf idCiudadano.Length = 11 Then
                empleado = New SuirPlus.Empresas.Trabajador(SuirPlus.Empresas.Trabajador.TrabajadorDocumentoType.Cedula, idCiudadano)
            End If

        Catch ex As Exception
            Me.lblMsg.Text = "Cédula o NSS inválido"
            Me.pnlConsulta.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub

        End Try

        If empleado Is Nothing Or empleado.TipoDocumento <> "C" Then
            Me.lblMsg.Text = SuirPlus.Utilitarios.TSS.getErrorDescripcion(24)
            Exit Sub
        End If

        Me.pnlConsulta.Visible = True

        UcEmpleado.NombreEmpleado = empleado.Nombres + " " + empleado.PrimerApellido + " " + empleado.SegundoApellido
        UcEmpleado.NSS = empleado.NSS.ToString
        UcEmpleado.Cedula = empleado.Documento
        UcEmpleado.Sexo = empleado.Sexo
        UcEmpleado.FechaNacimiento = empleado.FechaNacimiento

        llenarDatagridAfiliadosActivos()
        llenarDatagridAfiliadosInactivos()


    End Sub

    Sub llenarDatagridAfiliadosActivos()
        Dim dt As New Data.DataTable
        dt = empleado.getEmpleadorAfiliadosActivos

        If dt.Rows.Count > 0 Then

            Me.gvAfiliacionActiva.DataSource = dt
            Me.gvAfiliacionActiva.DataBind()
            Me.gvAfiliacionActiva.Visible = True
            Me.lblNominaAct.Visible = True
        Else

            Me.gvAfiliacionActiva.Visible = False
            Me.lblNominaAct.Visible = False
        End If

    End Sub

    Sub llenarDatagridAfiliadosInactivos()
        Dim dt As New Data.DataTable
        dt = empleado.getEmpleadorAfiliadosInactivos

        If dt.Rows.Count > 0 Then

            Me.gvAfiliacionInctiva.DataSource = dt
            Me.gvAfiliacionInctiva.DataBind()
            Me.gvAfiliacionInctiva.Visible = True
            Me.lblNominaAnt.Visible = True
        Else

            Me.gvAfiliacionInctiva.Visible = False
            Me.lblNominaAnt.Visible = False
        End If
    End Sub


    Protected Sub gvAfiliacionActiva_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAfiliacionActiva.RowDataBound




        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim regPatronal As String = CType(e.Row.FindControl("lblRegistroPatronal"), Label).Text
            Dim idNomina As String = CType(e.Row.FindControl("lblNomina"), Label).Text
            Dim hl As System.Web.UI.WebControls.HyperLink = CType(e.Row.FindControl("hlnkNomActivo"), HyperLink)
            hl.Text = DataBinder.Eval(e.Row.DataItem, "NOMINA_DES").ToString


            hl.NavigateUrl = "javascript:modelesswin('AfiliadoDetalle.aspx?idEmp=" & Me.idCiudadano & "&patreg=" & regPatronal & "&nom=" & idNomina & "')"

        End If


    End Sub

    Protected Sub gvAfiliacionInctiva_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAfiliacionInctiva.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim regPatronal As String = CType(e.Row.FindControl("lblRegistroPatronal"), Label).Text
            Dim idNomina As String = CType(e.Row.FindControl("lblNomina"), Label).Text
            Dim h2 As System.Web.UI.WebControls.HyperLink = CType(e.Row.FindControl("hlnkNomInactivo"), HyperLink)
            h2.Text = DataBinder.Eval(e.Row.DataItem, "NOMINA_DES").ToString
            h2.NavigateUrl = "javascript:modelesswin('AfiliadoDetalle.aspx?idEmp=" & Me.idCiudadano & "&patreg=" & regPatronal & "&nom=" & idNomina & "')"
        End If

    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Response.Redirect("AfiliadoArl.aspx")
    End Sub

End Class

