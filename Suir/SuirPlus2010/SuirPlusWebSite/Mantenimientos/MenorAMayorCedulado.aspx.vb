Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios
Imports SuirPlus.Ars.Consultas
Imports System.Windows.Forms

Partial Class Mantenimientos_MenorAMayorCedulado
    Inherits BasePage
    Dim id_eva As String
    Dim dtPadreGlobal As DataTable
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        id_eva = MenorACedulado
        cargarDatos()
    End Sub


    Private Sub cargarDatos()
        'llenar el gridview
        Dim dtPadre As DataTable
        Dim dtCoincidencias As DataTable
        dtPadre = Ars.Consultas.getMenorEvaluacionPadre(id_eva)
        dtCoincidencias = Ars.Consultas.getMenorEvaluacionHijo(id_eva)
        CargarPadre(dtPadre)
        If dtCoincidencias.Rows.Count > 0 Then
            'Me.lblTotalRegistros.Text = dtCoincidencias.Rows(0)
            Me.gvPadre.DataSource = dtCoincidencias
            Me.gvPadre.DataBind()
            Me.gvPadre.Visible = True
            'Me.lbl_error.Visible = False
        Else
            Me.gvPadre.Visible = False
            Me.gvPadre.DataSource = Nothing
            Me.gvPadre.DataBind()
            'Me.lbl_error.Visible = True
            'Me.lbl_error.Text = "No se encontro data."
        End If

        'dt = Nothing
        'setNavigation()

    End Sub
    Private Sub CargarPadre(ByVal dtPadre As DataTable)
        dtPadreGlobal = dtPadre
        lblNoDocumento.Text = dtPadre.Rows(0)(0)
        lblNombres.Text = dtPadre.Rows(0)(1)
        lblApellidos.Text = dtPadre.Rows(0)(2) + " " + dtPadre.Rows(0)(3)
        lblSexo.Text = dtPadre.Rows(0)(5)
        lblFechaN.Text = dtPadre.Rows(0)(4)
        lblMunicipioActa.Text = dtPadre.Rows(0)(6).ToString()
        lblAnoActa.Text = dtPadre.Rows(0)(7).ToString()
        lblNumeroActa.Text = dtPadre.Rows(0)(8).ToString()
        lblFolioActa.Text = dtPadre.Rows(0)(9).ToString()
        lblLibroActa.Text = dtPadre.Rows(0)(10).ToString()
        lblOficialia.Text = dtPadre.Rows(0)(11).ToString()
    End Sub

    Protected Sub gvPadre_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvPadre.RowCommand
        Dim Result As String
        If e.CommandName = "OK" Then
            'Result =
            Result = SuirPlus.Ars.Consultas.gestionarConcidencia(e.CommandArgument.ToString(), dtPadreGlobal.Rows(0)(0), e.CommandName, UsrNombreCompleto)
            'If Result = "1" Then
            Response.Redirect("EvaluacionVisual.aspx")
            'Else
            '    lblMensaje.Text = Result
            '    lblMensaje.Visible = True
            'End If
        ElseIf e.CommandName = "RE" Then
            'Result =
            Result = SuirPlus.Ars.Consultas.gestionarConcidencia(e.CommandArgument.ToString(), dtPadreGlobal.Rows(0)(0), e.CommandName, UsrNombreCompleto)
            'If Result = "-1" Then
            Response.Redirect("MenorAMayorCedulado.aspx")
            'Else
            '    lblMensaje.Text = Result
            '    lblMensaje.Visible = True
            'End If
        End If
    End Sub

    Protected Sub btnInsertarPadre_Click(sender As Object, e As EventArgs) Handles btnInsertarPadre.Click
        'Dim Result As String
        'Result =
        SuirPlus.Ars.Consultas.gestionarConcidencia(Nothing, dtPadreGlobal.Rows(0)(0), "IN", UsrNombreCompleto)
        'If Result = "0" Then
        Response.Redirect("EvaluacionVisual.aspx")
        'Else
        'lblMensaje.Text = Result
        'lblMensaje.Visible = True
        'End If
    End Sub
End Class
