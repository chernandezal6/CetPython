Imports SuirPlus
Imports SuirPlus.Empresas

Partial Class Controles_UCNominas
    Inherits System.Web.UI.UserControl

    Protected registroPatronal As String
    Protected idNomina As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Con esto consigo mejorar el rendimiento de la pagina, ya que no se llaman el o los
        'métodos para llenar el o los datagrids, que es donde se degrada el rendimiento.
        'Gregorio Herrera, 24/07/2007
        If Me.Visible = False Then
            Return
        End If

        If Not Page.IsPostBack Then
            CargarNonimas(Me.getRegPatronal)
        End If

        registroPatronal = Request("reg")
        idNomina = Request("nom")
        Dim index As Integer = -1

        If Request("index") <> String.Empty Then
            index = CInt(Request("index"))
        End If

        If index > -1 Then
            Me.gvNominas.SelectedIndex = index
        End If

        If registroPatronal <> String.Empty And idNomina <> String.Empty Then
            ctrlDetalle.RegistroPatronal = registroPatronal
            ctrlDetalle.IdNomina = idNomina
            ctrlDetalle.DataBind()
            Me.pnlNominasEnc.Visible = False

        Else
            Me.ctrlDetalle.Visible = False
            Me.pnlNominasEnc.Visible = True

        End If

    End Sub

    Sub CargarNonimas(ByVal IdRegistroPatronal As Integer)
        'Carga el listado de las nóminas de un empleador.
        Dim dt As Data.DataTable = Representante.getNominasRep(getIDNSS, IdRegistroPatronal)

        If dt.Rows.Count > 0 Then
            Me.gvNominas.DataSource = dt
            Me.gvNominas.DataBind()
            trHeader.Visible = True
        Else
            trHeader.Visible = False
        End If


    End Sub

    'Funcion utilizada para obtener el NSS del representante que esta loeguado.
    Private Function getIDNSS() As Integer

        Return CType(Me.Page, BasePage).UsrNSS

    End Function

    Private Function getRegPatronal() As Integer
        Return CInt(CType(Me.Page, BasePage).UsrRegistroPatronal)
    End Function

    Private Function getUserRepresentante() As String

        Return CType(Me.Page, BasePage).UsrUserName

    End Function

    Protected Sub gvNominas_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNominas.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim regPatronal As String = CType(e.Row.FindControl("lblRegistroPatronal"), Label).Text
            Dim idNomina As String = CType(e.Row.FindControl("lblNomina"), Label).Text
            Dim hl As System.Web.UI.WebControls.HyperLink = CType(e.Row.FindControl("hlkDetalle"), HyperLink)
            hl.NavigateUrl = "~/Empleador/consNomina.aspx?reg=" & regPatronal & "&nom=" & idNomina & "&index=" & e.Row.RowIndex & "&viewCCC=DetNom"
            'se deshabilita el linkbutton de ver el detalle si no tiene registros
            If e.Row.Cells(3).Text = 0 Then
                e.Row.Cells(5).Enabled = False
            Else
                e.Row.Cells(5).Enabled = True

            End If


        End If
    End Sub

End Class
