
Partial Class Controles_UCDependientesAdicionales
    Inherits System.Web.UI.UserControl

    Protected registroPatronal As String
    Protected idNomina As String
    Dim viewCCC As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Con esto consigo mejorar el rendimiento de la pagina, ya que no se llaman el o los
        'métodos para llenar el o los datagrids, que es donde se degrada el rendimiento.
        'Gregorio Herrera, 24/07/2007
        If Me.Visible = False Then
            Return
        End If

        registroPatronal = Request("reg")
        idNomina = Request("nom")
        viewCCC = Request("viewCCC")

        Dim index As Integer = -1

        If Request("index") <> String.Empty Then
            index = CInt(Request("index"))
        End If

        If index > -1 Then
            Me.dgNominas.SelectedIndex = index
        End If

        If Not Page.IsPostBack Then
            Me.CargarNonimas()
        End If

        If viewCCC = "DetDep" Then
            Me.ctrlDetalleDependiente.RegistroPatronal = Me.registroPatronal
            Me.ctrlDetalleDependiente.IdNomina = Me.idNomina
            'Me.ctrlDetalleDependiente.ShowNomina = False
            Me.ctrlDetalleDependiente.DataBind()
            Me.ctrlDetalleDependiente.Visible = True
            Me.pnlDepAdicionales.Visible = False
            Me.pnlDetDepAdicionales.Visible = True
        Else

            Me.pnlDepAdicionales.Visible = True
            Me.pnlDetDepAdicionales.Visible = False
        End If

    End Sub

    Protected Sub CargarNonimas()
        'Carga el listado de las nóminas de un empleador.
        Dim dt As Data.DataTable = SuirPlus.Empresas.Representante.getNominasRepDependientes(getIDNSS, getRegPatronal)

        If dt.Rows.Count > 0 Then
            Me.dgNominas.DataSource = dt
            Me.dgNominas.DataBind()
            trHeader.Visible = True
        Else
            trHeader.Visible = False
        End If







    End Sub

    Private Function getIDNSS() As Integer

        Return CType(Me.Page, BasePage).UsrNSS

    End Function

    Private Function getUserRepresentante() As String

        Return CType(Me.Page, BasePage).UsrUserName

    End Function

    Private Function getRegPatronal() As Integer
        Return CInt(CType(Me.Page, BasePage).UsrRegistroPatronal)
    End Function

    Protected Sub dgNominas_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgNominas.RowDataBound

        If (e.Row.RowType = DataControlRowType.DataRow) Then

            Dim regPatronal As String = CType(e.Row.FindControl("lblRegistroPatronal"), Label).Text
            Dim idNomina As String = CType(e.Row.FindControl("lblNomina"), Label).Text
            Dim hl As System.Web.UI.WebControls.HyperLink = CType(e.Row.FindControl("hlkDetalle"), HyperLink)
            hl.NavigateUrl = "../Empleador/consNomina.aspx?reg=" & regPatronal & "&nom=" & idNomina & "&index=" & e.Row.RowIndex & "&viewCCC=DetDep"


            'se deshabilita el linkbutton de ver el detalle si no tiene registros
            If e.Row.Cells(3).Text = 0 Then
                hl.Enabled = False

            Else
                hl.Enabled = True

            End If
        End If

    End Sub


End Class
