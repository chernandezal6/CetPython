Imports System.Data
Imports SuirPlus.MDT
Imports SuirPlus
Imports SuirPlus.Utilitarios.Utils


Partial Class MDT_consPlanillasMDT
    Inherits BasePage


    Public Property pageNum() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNum.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNum.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNum.Text = value
        End Set
    End Property

    Public Property PageSize() As Int16
        Get
            If String.IsNullOrEmpty(Me.lblPageSize.Text) Then
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSize.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSize.Text = value
        End Set
    End Property

    Public Prueba As String
    Public salario As String
     

    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            BindCarteraMDT()
            Session.Remove("_planilla")
            Session.Remove("_periodo")
            'Session.Remove("_status")
            'Session.Remove("_referencia")
            'Session.Remove("_nss")

        End If
        pageNum = 1
        PageSize = BasePage.PageSize
    End Sub

    Protected Sub BindCarteraMDT()
        Dim dtDCarteraMDT As New DataTable
        Try
            dtDCarteraMDT = General.getCarteraMDT(UsrRegistroPatronal)

            If dtDCarteraMDT.Rows.Count > 0 Then
                'llenamos el grid y los labels'

                Me.gvPlanillasMDT.DataSource = dtDCarteraMDT
                Me.gvPlanillasMDT.DataBind()
                divNovedades.Visible = True
            Else
                lblError.Text = "No existen registros para esta busqueda"
            End If
            dtDCarteraMDT = Nothing
            

        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message
        End Try
    End Sub

    Protected Sub BindDetCarteraMDT(regPatronal As Integer, tipoPlanilla As String, periodo As Integer)
        Dim dtDetCarteraMDT As New DataTable

        Try
            dtDetCarteraMDT = General.getDetCartera_MDT(regPatronal, tipoPlanilla, periodo, Me.pageNum, Me.PageSize)

            If dtDetCarteraMDT.Rows.Count > 0 Then
                'llenamos el grid y los labels'
              
                Me.lblTotalRegistros.Text = dtDetCarteraMDT.Rows(0)("RECORDCOUNT")
                Me.gvDetPlanillaMDT.DataSource = dtDetCarteraMDT
                Me.gvDetPlanillaMDT.DataBind()
                'Me.imgMDT.Visible = False
                divDetNov.Visible = True
                divInfoPlanilla.Visible = True

                Me.lblPlanilla.Text = dtDetCarteraMDT.Rows(0)("TIPO").ToString()
                Me.lblPeriodo.Text = Me.formateaPeriodo(dtDetCarteraMDT.Rows(0)("PERIODO_FACTURA").ToString())
                salario = String.Format("RD$", (dtDetCarteraMDT.Rows(0)("salario_mdt").ToString()))
                'Me.lblSalario.text = String.Format("RD$", Convert.ToDateTime(dtDetCarteraMDT.Rows(0)("salario_mdt").ToString()))
                ''Me.LblFecha.Text = String.Format("{0:d}", Convert.ToDateTime(dtDetCarteraMDT.Rows(0)("ULT_FECHA_ACT").ToString()))
                ''Me.formateaPeriodo(lblPeriodo.Text)
                LnkBtvolver.Visible = True
           
            End If

            setNavigation()
            dtDetCarteraMDT = Nothing
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub BindInactivarCartera( nss As Integer , periodo As Integer , planilla As String, regPatronal As Integer, nroReferencia As String, status As String)
        Dim dtd As String = General.InactivarCartera(nss, periodo, planilla, regPatronal, nroReferencia, status)

        If Split(dtd, "|")(0) = "0" Then
            Me.lblError.Text = "El registro fue borrado satisfactoriamente."
            If CInt(lblTotalRegistros.Text) = 1 Then
                divDetNov.Visible = False
                divInfoPlanilla.Visible = False
            End If
        Else
            Me.lblError.Visible = True
            Me.lblError.Text = Split(dtd, "|")(1)

        End If


    End Sub

    Protected Sub gvPlanillasMDT_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvPlanillasMDT.RowCommand

        Dim planilla As String = Split(e.CommandArgument, "|")(0)
        Dim periodo As String = Split(e.CommandArgument, "|")(1)


        Session("_planilla") = planilla
        Session("_periodo") = periodo
        Try
            If e.CommandName = "VerDetalle" Then

                BindDetCarteraMDT(CInt(UsrRegistroPatronal), Session("_planilla"), CInt(Session("_periodo")))
                divNovedades.Visible = False

            End If
        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message
        End Try

    End Sub

    Private Sub setNavigation()

        Dim totalRecords As Integer = 0

        If IsNumeric(Me.lblTotalRegistros.Text) Then
            totalRecords = CInt(Me.lblTotalRegistros.Text)
        End If

        Dim totalPages As Double = Math.Ceiling(Convert.ToDouble(totalRecords) / PageSize)

        If totalRecords = 1 Or totalPages = 0 Then
            totalPages = 1
        End If

        If PageSize > totalRecords Then
            PageSize = Int16.Parse(totalPages)
        End If

        Me.lblCurrentPage.Text = pageNum
        Me.lblTotalPages.Text = totalPages

        If pageNum = 1 Then
            Me.btnLnkFirstPage.Enabled = False
            Me.btnLnkPreviousPage.Enabled = False
        Else
            Me.btnLnkFirstPage.Enabled = True
            Me.btnLnkPreviousPage.Enabled = True
        End If

        If pageNum = totalPages Then
            Me.btnLnkNextPage.Enabled = False
            Me.btnLnkLastPage.Enabled = False
        Else
            Me.btnLnkNextPage.Enabled = True
            Me.btnLnkLastPage.Enabled = True
        End If

    End Sub

    Protected Sub NavigationLink_Click(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First"
                pageNum = 1
            Case "Last"
                pageNum = Convert.ToInt32(lblTotalPages.Text)
            Case "Next"
                pageNum = Convert.ToInt32(lblCurrentPage.Text) + 1
            Case "Prev"
                pageNum = Convert.ToInt32(lblCurrentPage.Text) - 1
        End Select

        'Aqui ponemos el metodo que cargara la informacion'
        BindDetCarteraMDT(CInt(UsrRegistroPatronal), Session("_planilla"), Session("_periodo"))
    End Sub

    Protected Sub LnkBtvolver_Click(sender As Object, e As System.EventArgs) Handles LnkBtvolver.Click
        divDetNov.Visible = False
        divInfoPlanilla.Visible = False
        'Me.imgMDT.Visible = True
        divNovedades.Visible = True
        BindCarteraMDT()



    End Sub

    Protected Sub ucExportarExcel1_ExportaExcel(sender As Object, e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel

        Dim dt = General.getDetCartera_MDT(CInt(UsrRegistroPatronal), Session("_planilla"), CInt(Session("_periodo")), 1, 9999)

        dt.Columns.RemoveAt(0)
        dt.Columns.RemoveAt(0)
        dt.Columns.RemoveAt(0)
        dt.Columns.RemoveAt(0)

        dt.Columns.RemoveAt(0)
        'dt.Columns.RemoveAt(14)
        'dt.Columns.RemoveAt(13)
        'dt.Columns.RemoveAt(17)

        ucExportarExcel1.FileName = "Listado_de_Planillas.xls"
        ucExportarExcel1.DataSource = dt
    End Sub


    Protected Function formateaPeriodo(ByVal Periodo As Object) As String
        If Not IsDBNull(Periodo) Then
            Return Utilitarios.Utils.FormateaPeriodo(Periodo)
        Else
            Return String.Empty
        End If
    End Function

    Protected Function formateaReferencia(ByVal nroReferencia As Object) As String
        If Not IsDBNull(nroReferencia) Then
            Return Utilitarios.Utils.FormateaReferencia(nroReferencia)
        Else
            Return String.Empty
        End If
    End Function


    Protected Sub gvDetPlanillaMDT_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvDetPlanillaMDT.RowCommand
       
        Dim status As String = Split(e.CommandArgument, "|")(0)
        Dim NroReferencia As String = Split(e.CommandArgument, "|")(1)

        Dim nss As Integer = Split(e.CommandArgument, "|")(2)

        Try
            If e.CommandName = "Borrar" Then


                BindInactivarCartera(nss, Session("_periodo"), Session("_planilla"), CInt(UsrRegistroPatronal), NroReferencia, status)


            End If

            BindDetCarteraMDT(CInt(UsrRegistroPatronal), Session("_planilla"), Session("_periodo"))

        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message
        End Try
    End Sub

 
    Protected Sub gvdetPlanillasMDT_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDetPlanillaMDT.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            salario = CType(e.Row.FindControl("lblSalario"), Label).Text
        End If
    End Sub
    Public Function formateaSalario(ByVal salario As String) As String
        Dim salFormatear As Double
        Dim res As String

        If Not IsNumeric(salario) Then
            Return salario
        Else
            salFormatear = CDbl(salario)
            res = String.Format("{0:c}", salFormatear)
            Return res
        End If



    End Function
End Class
