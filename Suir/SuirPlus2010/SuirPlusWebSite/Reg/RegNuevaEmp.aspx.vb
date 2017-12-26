Imports System.IO
Partial Class Reg_RegNuevaEmp
    Inherits RegistroEmpresaSeguridad

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        'Validación de manera normal
        If Session("UserName") <> Nothing Then
            If ValidarCargaArchivo.Value <> "0" Then
                CargarRequisitos(EmpSeleccionada.Value, idsolicitudServer.Value)
            End If
        Else
            Response.Redirect("LoginPage.aspx")
        End If

        'Cuando se produsca un PostBack
        If Not IsPostBack Then
            If Session("UserName") <> Nothing Then
                hdUsuario.Value = Session("UserName")
            Else
                Response.Redirect("LoginPage.aspx")
            End If
        End If
    End Sub

    Public Sub CargarRequisitos(ByVal EmpresaID As String, ByVal SolicitudID As String)
        Dim Valor = 0
        If EmpresaID <> "" Or EmpresaID <> String.Empty Then
            Valor = Convert.ToInt32(EmpresaID)
        End If
        Dim Requisitos = SuirPlus.SolicitudesEnLinea.Solicitudes.MostrarRequisitosRegEmpresas(Valor, SolicitudID)
        gvCargaArchivo.DataSource = Requisitos
        gvCargaArchivo.DataBind()
    End Sub

    Protected Sub btnMostrarRequisitos_Click(sender As Object, e As EventArgs)
        CargarRequisitos(EmpSeleccionada.Value, CodsolicitudServer.Value)
    End Sub

    Public Sub CargarRequisitoParaEditar(ByVal SolicitudID As String)
        'Dim Valor = 0
        'If EmpresaID <> "" Or EmpresaID <> String.Empty Then
        '    Valor = Convert.ToInt32(EmpresaID)
        'End If
        Dim Requisitos = SuirPlus.SolicitudesEnLinea.Solicitudes.GetEditDoc(SolicitudID)
        gvCargarArchivosEditar.DataSource = Requisitos
        gvCargarArchivosEditar.DataBind()
    End Sub

    Protected Sub btnCargarEditados_Click(sender As Object, e As EventArgs)
        CargarRequisitoParaEditar(idsolicitudServer.Value)
    End Sub

    Protected Sub gvCargarArchivosEditar_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvCargarArchivosEditar.RowCommand

        Dim Resultado1 = e.CommandArgument.ToString()
        Dim resultado2 = e.CommandName.ToString()

        'Response.Write("<script>")
        'Response.Write("window.open('" + Application("servidor") + "Reg/VerImagenesSolicitud.aspx?idDoc=" + Resultado1 + "&req=" + resultado2 + "','_blank')")
        'Response.Write("</script>")

        ScriptManager.RegisterStartupScript(gvCargarArchivosEditar, Me.GetType(), "temp", "<script language='javascript'>window.open('" + Application("servidor") + "Reg/VerImagenesSolicitud.aspx?idDoc=" + Resultado1 + "&req=" + resultado2 + "','_blank');</script>", False)

    End Sub
End Class



