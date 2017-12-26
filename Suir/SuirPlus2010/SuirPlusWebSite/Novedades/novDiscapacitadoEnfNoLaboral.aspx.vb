Imports System.Data
Imports SuirPlus

Partial Class Novedades_novDiscapacitadoEnfNoLaboral
    Inherits BasePage

    Public Event CiudadanoEncontrado(ByVal sender As Object, ByVal e As EventArgs)
    Public Event BusquedaCancelada(ByVal sender As Object, ByVal e As EventArgs)
    Private myEmp As Empresas.Empleador


    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
    End Sub

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub
    Protected Sub btnAceptar_Click(sender As Object, e As EventArgs) Handles btnAceptar.Click
        If SuirPlus_Status = "REDUCIDO" Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = SuirPlusREDUCIDO
            Exit Sub
        End If

        If Me.PersoNss.Value = Nothing Then
            Me.lblMsg.ForeColor = Drawing.Color.Red
            Me.lblMsg.Text = "La cedula debe ser válida "
            Return
        Else
            Me.lblMsg.Text = String.Empty
        End If

        'Validando el SalarioSS
        If String.IsNullOrEmpty(Me.txtSalario.Text) Then
            Me.txtSalario.Text = "0.00"
        Else
            If Not isDecimal(Me.txtSalario.Text) Then
                Me.lblMsg.Text = "El valor del salario Seg. Social es inválido."
                Exit Sub
            End If
        End If

        'validando los periodos
        If ddlPeriodoDesde.SelectedValue > ddlPeriodoHasta.SelectedValue Then
            Me.lblMsg.Text = "El periodo desde no debe ser mayor al periodo hasta."
            Exit Sub
        End If

        Dim fechaIngreso = Now.Date

        Dim ret As String = String.Empty
        ' Dim tmpIdNomina As String = Me.ddNomina.SelectedValue
        Try

            'For Each item In generarPeriodos(Now().Year).Rows
            '    If item(0).ToString() >= ddlPeriodoDesde.SelectedValue And item(0).ToString() <= ddlPeriodoHasta.SelectedValue Then
            '        ret = SuirPlus.Empresas.Trabajador.novedadEnfNoLaboral(Me.UsrRegistroPatronal, ddlNominas.SelectedValue, Me.PersoNss.Value, Me.txtSalario.Text, "0.00", "0.00", "0.00", "", "0.00", "0.00", fechaIngreso, item(0).ToString(), "0.00", "0.00", Me.UsrUserName, 1, Me.GetIPAddress())
            '    End If
            'Next

            Dim PeriodoDesde = ddlPeriodoDesde.SelectedValue.Replace("-", "")
            Dim PeriodoHasta = ddlPeriodoHasta.SelectedValue.Replace("-", "")


            ret = SuirPlus.Empresas.Trabajador.novedadEnfNoLaboral(Me.UsrRegistroPatronal, ddlNominas.SelectedValue, Me.PersoNss.Value, Me.txtSalario.Text, "0.00", "0.00", "0.00", "", "0.00", "0.00", fechaIngreso, PeriodoDesde, PeriodoHasta, "0.00", "0.00", Me.UsrUserName, 1, Me.GetIPAddress())
        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub
        End Try

        If Split(ret, "|")(0) = "0" Then
            Me.lblMsg.ForeColor = Drawing.Color.Blue
            Me.lblMsg.Text = "El ingreso fue registrado satisfactoriamente."
            Me.novedadesPendientes()
            Me.iniForm()
            Response.Redirect("novDiscapacitadoEnfNoLaboral.aspx")


            'Me.ddNomina.SelectedValue = tmpIdNomina
        Else
            Me.lblMsg.ForeColor = Drawing.Color.Red
            Me.lblMsg.Text = Split(ret, "|")(1)
            Me.novedadesPendientes()
        End If


    End Sub

    Protected Sub btnRepBuscar_Click(sender As Object, e As EventArgs) Handles btnRepBuscar.Click
        Me.txtRepDocumento.Text = UCase(Trim(Me.txtRepDocumento.Text + ""))
        Me.consultaPersona("C", Me.txtRepDocumento.Text)


    End Sub
    Public Sub consultaPersona(ByVal tipoDoc As String, ByVal doc As String)

        If Me.txtRepDocumento.Text = "" Then
            Me.setRepError("Debe ingresar el número de documento.")
            Return
        End If

        'Buscando ciudadano
        Dim tmpstr As String = SuirPlus.Utilitarios.TSS.consultaCiudadano("C", Me.txtRepDocumento.Text)
        Dim retStr As String() = Split(tmpstr, "|")

        'El ciudadano fue encontrado
        If retStr(0) = "0" Then
            'Presenta info de la persona
            Me.setInfoPersona(retStr(1), retStr(2), retStr(3))
            Me.lblRepError.Text = String.Empty

        Else 'Si no fue encontrado permite agregarlo
            Me.setRepError("La persona no fue encontrada.")
        End If

    End Sub
    Private Sub setNuevaPersona()


        Me.btnRepBuscar.Enabled = False
        Me.txtRepDocumento.ReadOnly = True

    End Sub
    Private Sub setRepError(ByVal msg As String)
        Me.lblRepError.Text = msg
    End Sub
    Private Sub setInfoPersona(ByVal nombres As String, ByVal apellidos As String, ByVal nss As String)


        Me.lblNombres.Text = nombres
        Me.lblApellidos.Text = apellidos
        Me.PersoNss.Value = nss


        Me.btnRepBuscar.Enabled = False
        Me.txtRepDocumento.ReadOnly = True

        'Dispara el evento  CiudadanoEncontrado
        RaiseEvent CiudadanoEncontrado(Me, Nothing)


    End Sub

    Protected Sub btnRepCancelar_Click(sender As Object, e As EventArgs) Handles btnRepCancelar.Click
        Me.iniForm()

        'Dispara el evento  BusquedaCancelada
        RaiseEvent BusquedaCancelada(Me, Nothing)

        txtRepDocumento.Text = String.Empty
        txtSalario.Text = String.Empty
        lblMsg.Text = String.Empty
        lblRepError.Text = String.Empty

        CargarPeriodo()
    End Sub

    Public Sub iniForm()

        Me.lblNombres.Text = String.Empty
        Me.lblApellidos.Text = String.Empty

        'Me.ddRepTipoDoc.Enabled = True
        Me.txtRepDocumento.Text = ""
        Me.txtRepDocumento.ReadOnly = False
        Me.txtSalario.Text = String.Empty
        Me.PersoNss.Value = String.Empty
        Me.btnRepBuscar.Enabled = True
        Me.PersoNss.Dispose()


    End Sub
    

    Protected Sub CargarPeriodo()
        ddlPeriodoDesde.DataSource = generarPeriodos(Now().Year)
        ddlPeriodoDesde.DataTextField = "Periodo"
        ddlPeriodoDesde.DataValueField = "Periodo"
        ddlPeriodoDesde.DataBind()

        ddlPeriodoHasta.DataSource = generarPeriodos(Now().Year)
        ddlPeriodoHasta.DataTextField = "Periodo"
        ddlPeriodoHasta.DataValueField = "Periodo"
        ddlPeriodoHasta.DataBind()

    End Sub
    Protected Function generarPeriodos(ByVal ano As String) As DataTable

        Session.Remove("UltimoPeriodo")
        Dim i As Integer = 0
        Dim n As Integer = 0
        Dim contador As Integer = 0
        Dim mes As String = String.Empty
        Dim m As Integer
        Dim Periodo As String = String.Empty
        Dim anoPeriodo As Integer
        Dim arrAnoPeriodo() As Integer = Nothing
        Dim Cantidad = Year(Date.Now) - 2003
        ReDim arrAnoPeriodo(Cantidad)


        ' creamos el DataTable.
        Dim dt As New DataTable
        ' creamos la columna en el DataTable.
        dt.Columns.Add("Periodo", GetType(String))

        If ano <> String.Empty Then
            'asignamos de valores el arreglo
            For n = 2003 To Convert.ToInt32(ano) Step 1
                arrAnoPeriodo(contador) = n
                contador = contador + 1

            Next
            'arrAnoPeriodo(0) = ano
            'arrAnoPeriodo(1) = ano - 1
            'arrAnoPeriodo(2) = ano - 2
            'arrAnoPeriodo(3) = ano - 3
            'arrAnoPeriodo(4) = 2003


            'recorremos el arreglo y concatenamos los doce periodo correpondientes por cada ano
            For Each anoPeriodo In arrAnoPeriodo
                ano = anoPeriodo
                'identificamos los periodos transcurridos del ano en curso
                If ano = Now().Year Then
                    m = Now().Month
                Else
                    m = 12
                End If

                For i = 1 To m
                    If i < 10 Then
                        If i = 1 And ano = "2003" Then
                            i = 6
                        End If
                        mes = "0" & i
                    Else
                        mes = i
                    End If
                    Periodo = ano & "-" & mes
                    'llenamos el datatable anteriormente declarado, para guardar los periodos generados
                    dt.Rows.Add(Periodo)
                    dt.DefaultView.Sort = "Periodo Desc"
                Next
            Next

        End If

        Session("UltimoPeriodo") = Periodo
        Return dt
    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles MyBase.Load, Me.Load

        If Not IsPostBack Then
            Me.iniForm()
            CargarPeriodo()
            novedadesPendientes()
            buscarNominas()


            'Validando si puede registrar novedades
            Dim resultado = SuirPlus.Empresas.Trabajador.PuedeRegistrarNovedades(Me.UsrRegistroPatronal)
            If resultado <> "0" Then
                PantallaInteractiva.Visible = False
                lblMsg.Text = "<a class='label-Resaltado error' href='/empleador/empManejoArchivopy.aspx'>" & resultado & "</a>"
            End If

        End If

       Dim empresa As New Empresas.Empleador(Me.UsrRNC)

        If empresa.PagoDiscapacidad = String.Empty Or empresa.PagoDiscapacidad = "N" Then
            Response.Redirect("/Empleador/consNotificaciones.aspx")
        End If



    End Sub


    Private Sub btnAplicar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAplicar.Click

        Dim ret As String = SuirPlus.Empresas.Trabajador.aplicarMovimientos(Me.UsrRegistroPatronal, Me.UsrUserName)
        Me.lblMsg.ForeColor = Drawing.Color.Blue
        Me.lblMsg.Text = "Novedades aplicadas satisfactoriamente."
        Me.novedadesPendientes()

        Response.Redirect("NovedadesAplicadas.aspx?msg=" & Me.lblMsg.Text)



    End Sub
    Private Sub novedadesPendientes()
        Try
            'Obteniendo novedades pendientes
            Dim tmpDataTable As Data.DataTable


            'Determinando el tipo de usuario
            'Si es Usuario
            tmpDataTable = SuirPlus.Empresas.Trabajador.getMovimientos(Me.UsrRegistroPatronal, "PRE", "IN", "I", Me.UsrRNC & Me.UsrCedula)


            bindNovedades(Me.UsrRegistroPatronal, "PRE", "IN", "I", Me.UsrRNC & Me.UsrCedula)


            If tmpDataTable.Rows.Count > 0 Then
                Me.pnlPendiente.Visible = True
                Me.lblPendientes.Visible = True
                Me.btnAplicar.Visible = True
                Me.tbpendiente.Visible = True

            Else
                Me.pnlPendiente.Visible = False
                Me.lblPendientes.Visible = False
                Me.btnAplicar.Visible = False
                Me.tbpendiente.Visible = False

            End If

            tmpDataTable = Nothing
        Catch ex As Exception
            Me.lblMsg.Text = ex.ToString
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Overrides Sub OnPreRender(ByVal e As System.EventArgs)
        If Not IsPostBack() Then
            buscarNominas()
            novedadesPendientes()
        End If

    End Sub

    Private Sub buscarNominas()

        Me.ddlNominas.DataSource = SuirPlus.Empresas.Nomina.getNominaPorTipoYRegPat(UsrRegistroPatronal, "L")
        Me.ddlNominas.DataTextField = "NOMINA_DES"
        Me.ddlNominas.DataValueField = "ID_NOMINA"
        Me.ddlNominas.DataBind()

    End Sub

#Region "Grid"
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


    Public Sub gvNovedades_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles _
    gvNovedades.RowCommand


        Dim Row As GridViewRow = CType(CType(e.CommandSource, Control).NamingContainer, GridViewRow)

        Dim idMov As Int32 = CType(Row.FindControl("lblIdMov"), Label).Text.ToString()
        Dim idLinia As Int32 = CType(Row.FindControl("lblIdLinia"), Label).Text.ToString()

        SuirPlus.Empresas.Trabajador.borraNovedad(idMov, idLinia)
        Response.Redirect("novDiscapacitadoEnfNoLaboral.aspx")

    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        For Each i As System.Web.UI.WebControls.GridViewRow In Me.gvNovedades.Rows
            CType(i.FindControl("iBtnBorrar"), ImageButton).Attributes.Add("onClick", "return confirm('Esta seguro que desea eliminar esta novedad?');")
        Next

    End Sub



#End Region
End Class
