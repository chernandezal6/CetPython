Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Legal
Imports System.Data
Partial Class Legal_subirDocumento
    Inherits BasePage
    Protected Property idRegPatronal() As Integer
        Get
            If ViewState("regPatronal") Is Nothing Then
                Return 0
            Else
                Return CInt(ViewState("regPatronal"))
            End If
        End Get
        Set(ByVal value As Integer)
            ViewState("regPatronal") = value
        End Set
    End Property
    Protected Property idAcuerdo() As Integer
        Get
            If Session("idAcuerdo") Is Nothing Then
                Return 0
            Else
                Return CInt(Session("idAcuerdo"))
            End If
        End Get
        Set(ByVal value As Integer)
            Session("idAcuerdo") = value
        End Set
    End Property
    Protected Property tipo() As Integer

        Get
            If Session("tipoAcuerdo") Is Nothing Then
                Return 0
            Else
                Return CInt(Session("tipoAcuerdo"))
            End If
        End Get
        Set(ByVal value As Integer)
            Session("tipoAcuerdo") = value
        End Set
    End Property
    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click

        Dim dt As DataTable = Nothing
        Dim emp As Empleador

        Try
            If Page.IsValid Then
                emp = New Empleador(Me.txtRnc.Text)
                Me.idRegPatronal = emp.RegistroPatronal
                Me.lblRazonSocial.Text = emp.RazonSocial
                Me.lblNombreComercial.Text = emp.NombreComercial
                dt = AcuerdosDePago.getAcuerdosPorEmpleador(eTiposAcuerdos.Todos, emp.RegistroPatronal)
                If dt.Rows.Count > 0 Then
                    Me.gvAcuerdos.DataSource = dt
                    Me.gvAcuerdos.DataBind()
                Else
                    Me.gvAcuerdos.DataSource = Nothing
                    Me.gvAcuerdos.DataBind()
                End If
            End If
            Me.pnlAcuerdos.Visible = True
            Me.pnlDetAcuerdo.Visible = False
        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            Me.upError.Update()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub
    Protected Sub gvAcuerdos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvAcuerdos.RowCommand

        If e.CommandName = "Subir" Then
            Dim vec() As String

            vec = e.CommandArgument.ToString().Split("|")
            Me.idAcuerdo = CInt(vec(0))
            Me.tipo = CInt(vec(1))

            Session("idAcuerdo") = Me.idAcuerdo
            Session("tipoAcuerdo") = Me.tipo

            Try
                Dim acuerdo As New AcuerdosDePago(Me.idAcuerdo, Me.tipo)
                Me.lblTipoAcuerdo.Text = acuerdo.TipoAcuerdo
                Me.lblEstatus.Text = acuerdo.Status
                Me.lblFechaRegistro.Text = String.Format("{0:d}", acuerdo.FechaReg)
                Me.lblCuotas.Text = acuerdo.Cuotas
                Me.pnlDetAcuerdo.Visible = True
                Me.gvAcuerdos.Visible = False
            Catch ex As Exception
                Me.lblMsg.Text = ex.Message
                Me.upError.Update()
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If

    End Sub
    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click

        Me.txtRnc.Text = String.Empty
        Me.pnlDetAcuerdo.Visible = False
        Me.gvAcuerdos.Visible = True
        Me.pnlAcuerdos.Visible = False
        Session("idAcuerdo") = Nothing
        Session("tipoAcuerdo") = Nothing

    End Sub
    Protected Sub Page_Disposed(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Disposed

        'Blaquemos nuestro objetos de session.
        Session("idAcuerdo") = Nothing
        Session("tipoAcuerdo") = Nothing

    End Sub

End Class
