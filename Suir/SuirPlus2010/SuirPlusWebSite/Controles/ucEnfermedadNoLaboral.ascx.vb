Imports System.Data

Partial Class Controles_ucEnfermedadNoLaboral
    Inherits System.Web.UI.UserControl
    Public Property Mensaje() As String
        Get
            Return lblMensaje.Text
        End Get
        Set(ByVal Value As String)
            Me.lblMensaje.Text = Me.lblMensaje.Text
        End Set
    End Property
  
#Region "Funciones"
    Public Sub bindNovedades(ByVal idRegPat As Integer, ByVal tipoMov As String, ByVal tipoNov As String, ByVal Cat As String, ByVal user As String)
        Dim dtNovedades As DataTable
        Me.lblMensaje.Text = ""

        Try

            dtNovedades = SuirPlus.Empresas.Trabajador.getMovimientos(idRegPat, tipoMov, tipoNov, Cat, user)

            Me.gvNovedades.DataSource = dtNovedades
            Me.gvNovedades.DataBind()


            If gvNovedades.Rows.Count < 1 Then
                lblMensaje.Text = "No hay novedades pendientes por aplicar."
            End If


            ViewState("CountReg") = dtNovedades.Rows.Count

            ViewState("idRegPat") = idRegPat
            ViewState("tipoMov") = tipoMov
            ViewState("tipoNov") = tipoNov
            ViewState("Cat") = Cat
            ViewState("user") = user

        Catch ex As Exception

            lblMensaje.Text = ex.Message
            'lblMensaje.Text = "No hay novedades pendientes por aplicar."
        End Try
    End Sub
    Public ReadOnly Property CantidadRecords() As Integer
        Get
            If Not ViewState("count") Is Nothing Then
                Return CType(ViewState("count"), Integer)
            Else
                Return 0
            End If
        End Get
    End Property
    Protected Function isDecimal(ByVal valor As String) As Boolean
        Return Regex.IsMatch(valor, "^\d+(\.\d\d)?$")
    End Function

    Public Function formatPeriodo(ByVal periodo As String) As String
        Return Microsoft.VisualBasic.Right(periodo, 2) + "-" + Microsoft.VisualBasic.Left(periodo, 4)
    End Function
#End Region

    Public Sub gvNovedades_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles _
    gvNovedades.RowCommand


        Dim Row As GridViewRow = CType(CType(e.CommandSource, Control).NamingContainer, GridViewRow)

        Dim idMov As Int32 = CType(Row.FindControl("lblIdMov"), Label).Text.ToString()
        Dim idLinia As Int32 = CType(Row.FindControl("lblIdLinia"), Label).Text.ToString()

        SuirPlus.Empresas.Trabajador.borraNovedad(idMov, idLinia)

        udPanel.Update()
    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        For Each i As System.Web.UI.WebControls.GridViewRow In Me.gvNovedades.Rows
            CType(i.FindControl("iBtnBorrar"), ImageButton).Attributes.Add("onClick", "return confirm('Esta seguro que desea eliminar esta novedad?');")
        Next

    End Sub


End Class
