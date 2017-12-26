Imports System.Data

Partial Class Novedades_ucGridNovPendientes
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

            If tipoNov = "SD" Then
                Me.gvDependiente.DataSource = dtNovedades
                Me.gvDependiente.DataBind()
            ElseIf tipoNov = "IN" Or tipoNov = "SA" Or tipoNov = "AD" Then
                Me.gvNovedades.DataSource = dtNovedades
                Me.gvNovedades.DataBind()
            ElseIf tipoNov = "ID" Then
                Me.gvEmpleado.DataSource = dtNovedades
                Me.gvEmpleado.DataBind()
            ElseIf tipoNov = "RE" Or tipoNov = "PE" Or tipoNov = "LM" _
                    Or tipoNov = "NC" Or tipoNov = "MM" Or tipoNov = "ML" _
                    Or tipoNov = "CR" Or tipoNov = "CI" Or tipoNov = "CN" _
                    Or tipoNov = "CM" Or tipoNov = "CL" Or tipoNov = "CP" _
                    Or tipoNov = "BR" Or tipoNov = "BI" Or tipoNov = "BN" _
                    Or tipoNov = "BM" Or tipoNov = "BL" Or tipoNov = "BP" _
                    Or tipoNov = "RT" Or tipoNov = "EC" Or tipoNov = "CC" _
                    Or tipoNov = "CT" Or tipoNov = "CE" Then
                dtNovedades = SuirPlus.Empresas.Trabajador.getMovimientosSFS(idRegPat)
                gvLactancia.DataSource = Nothing
                ViewState("count") = Nothing
                Me.gvLactancia.DataBind()
                Me.gvLactancia.DataSource = dtNovedades
                Me.gvLactancia.DataBind()
                ViewState("count") = gvLactancia.Rows.Count

                If dtNovedades.Rows.Count < 1 Then
                    lblMensaje.Text = "No hay novedades pendientes por aplicar."
                End If
            End If

            ViewState("CountReg") = dtNovedades.Rows.Count

            ViewState("idRegPat") = idRegPat
            ViewState("tipoMov") = tipoMov
            ViewState("tipoNov") = tipoNov
            ViewState("Cat") = Cat
            ViewState("user") = user

        Catch ex As Exception
            'ViewState("CountReg") = 0
            lblMensaje.Text = ex.Message
            lblMensaje.Text = "No hay novedades pendientes por aplicar."
        End Try
    End Sub

    Protected Function isDecimal(ByVal valor As String) As Boolean
        Return Regex.IsMatch(valor, "^\d+(\.\d\d)?$")
    End Function

    Public Function formatPeriodo(ByVal periodo As String) As String
        Return Microsoft.VisualBasic.Right(periodo, 2) + "-" + Microsoft.VisualBasic.Left(periodo, 4)
    End Function
#End Region

    Public ReadOnly Property CantidadRecords() As Integer
        Get
            If Not ViewState("count") Is Nothing Then
                Return CType(ViewState("count"), Integer)
            Else
                Return 0
            End If
        End Get
    End Property


    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        For Each i As System.Web.UI.WebControls.GridViewRow In Me.gvLactancia.Rows
            CType(i.FindControl("iBtnBorrar"), ImageButton).Attributes.Add("onClick", "return confirm('Esta seguro que desea eliminar esta novedad?');")
        Next

        For Each i As System.Web.UI.WebControls.GridViewRow In Me.gvEmpleado.Rows
            CType(i.FindControl("iBtnBorrar2"), ImageButton).Attributes.Add("onClick", "return confirm('Esta seguro que desea eliminar esta novedad?');")
        Next

    End Sub

    Protected Sub gvNovedades_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles _
    gvNovedades.RowCommand

        Dim Row As GridViewRow = CType(CType(e.CommandSource, Control).NamingContainer, GridViewRow)

        Dim idMov As Int32 = CType(Row.FindControl("lblIdMov"), Label).Text.ToString()
        Dim idLinia As Int32 = CType(Row.FindControl("lblIdLinia"), Label).Text.ToString()

        SuirPlus.Empresas.Trabajador.borraNovedad(idMov, idLinia)


    End Sub

    Protected Sub gvLatancia_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles _
  gvLactancia.RowCommand

        Dim Row As GridViewRow = CType(CType(e.CommandSource, Control).NamingContainer, GridViewRow)

        Dim idMov As Int32 = CType(Row.FindControl("lblIdMov"), Label).Text.ToString()
        Dim idLinia As Int32 = CType(Row.FindControl("lblIdLinia"), Label).Text.ToString()

        Try
            SuirPlus.Empresas.Trabajador.borraNovedad(idMov, idLinia)

            If Not ViewState("idRegPat") Is Nothing _
                    And Not ViewState("tipoMov") Is Nothing _
                    And Not ViewState("tipoNov") Is Nothing _
                    And Not ViewState("Cat") Is Nothing _
                    And Not ViewState("user") Is Nothing Then

                bindNovedades(DirectCast(ViewState("idRegPat"), Integer), _
                              ViewState("tipoMov").ToString, _
                              ViewState("tipoNov").ToString, _
                              ViewState("Cat").ToString, _
                             ViewState("user").ToString)
            End If
        Catch ex As Exception
            lblMensaje.Text = ex.Message
        End Try
    End Sub

    Protected Sub gvEmpleado_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles _
   gvEmpleado.RowCommand

        Dim Row As GridViewRow = CType(CType(e.CommandSource, Control).NamingContainer, GridViewRow)

        Dim idMov As Int32 = CType(Row.FindControl("lblIdMov"), Label).Text.ToString()
        Dim idLinia As Int32 = CType(Row.FindControl("lblIdLinia"), Label).Text.ToString()

        SuirPlus.Empresas.Trabajador.borraNovedad(idMov, idLinia)

        gvEmpleado.DataBind()
    End Sub

    Protected Sub gvDependiente_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles _
    gvDependiente.RowCommand
        Dim Row As GridViewRow = CType(CType(e.CommandSource, Control).NamingContainer, GridViewRow)

        Dim idMov As Int32 = CType(Row.FindControl("lblIdMov"), Label).Text.ToString()
        Dim idLinia As Int32 = CType(Row.FindControl("lblIdLinia"), Label).Text.ToString()

        SuirPlus.Empresas.Trabajador.borraNovedad(idMov, idLinia)

        gvDependiente.DataBind()
    End Sub


End Class
