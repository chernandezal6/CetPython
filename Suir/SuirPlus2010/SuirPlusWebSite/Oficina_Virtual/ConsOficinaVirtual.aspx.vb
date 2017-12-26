Imports System.Windows.Forms
Imports System.Data
Imports SuirPlus

Partial Class Oficina_Virtual_ConsOficinaVirtual
    'Inherits System.Web.UI.Page
    Inherits SeguridadOFV
    Dim Nro_documento As String = String.Empty
    Dim Tipo As String = String.Empty
    Dim Valor As String = String.Empty
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        Nro_documento = UserNoDocument
        If UserNoDocument <> Nothing Then
        Else
            Response.Redirect("LoginOficinaVirtual.aspx")
        End If
        'If Not Page.IsPostBack Then
        '    If UserNameOFV <> Nothing Then
        '        If Nro_documento <> Nothing And Request.QueryString("tipo") <> String.Empty Then
        '            Tipo = Request.QueryString("tipo")
        '            CaseConsulta(Nro_documento, Tipo)
        '        End If
        '    Else
        '        Response.Redirect("LoginOficinaVirtual.aspx")
        '    End If
        'End If
    End Sub
    Private Sub CaseConsulta(ByVal Documento As String, ByVal Tipo As String)
        'Dim infoDT As DataTable
        'Select Case Tipo
        '    Case "CIU"
        '        'Me.Titulo.InnerText = Nro_documento + " | " + "Estoy llegando a la consulta de ciudadano!"
        '        infoDT = SuirPlus.Utilitarios.TSS.getCiudadano(Nro_documento + "", "", "", "", "", "", "", "", "", "", "")
        '        If infoDT.Rows.Count > 0 Then
        '            lblNombre.Text = infoDT.Rows(0)("NOMBRES").ToString()
        '            lblApellido.Text = infoDT.Rows(0)("PRIMER_APELLIDO").ToString()
        '            lblFechaNac.Text = String.Format("{0:d}", CDate(infoDT.Rows(0)("FECHA_NACIMIENTO").ToString()))
        '            lblNSS.Text = infoDT.Rows(0)("ID_NSS").ToString()
        '            infoTitulo.Visible = False
        '            ' DesplegarData(infoDT)
        '        Else
        '        End If
        '    Case "NFA"
        '        infoDT = SuirPlus.Ars.Consultas.consultaAfilado(Nro_documento, Valor, "", "", "", "", "")
        '        gvNucleoFamiliar.DataSource = infoDT
        '        gvNucleoFamiliar.DataBind()
        '        infoLibre.Visible = False
        '        infoTitulo.Visible = True
        '        Titulo.InnerText = "Núcleo Familiar"
        '    Case Else
        '        'Me.Titulo.InnerText = Nro_documento + " | " + "Estoy llegando al default!"
        'End Select
    End Sub
    'Protected Sub btnRegresar_Click(sender As Object, e As EventArgs) Handles btnRegresar.Click
    '    Response.Redirect("OficinaVirtual.aspx", True)
    '    'Response.Redirect("OficinaVirtual.aspx?nro_documento=" + Request.QueryString("nro_documento"), True)
    'End Sub
End Class
