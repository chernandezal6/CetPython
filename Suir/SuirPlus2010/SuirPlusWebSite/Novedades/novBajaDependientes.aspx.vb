Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios
Imports System.Data

Partial Class Novedades_novBajaDependientes
    Inherits BasePage

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    'Protected WithEvents ucSubEncabezado As UCSubEncabezadoEmp
    'Protected WithEvents lblTitulo1 As System.Web.UI.WebControls.Label
    'Protected WithEvents lblMsg As System.Web.UI.WebControls.Label
    'Protected WithEvents pnlNuevaInfoGeneral As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlInfoGeneral As System.Web.UI.WebControls.Panel
    'Protected WithEvents gvDependientes As System.Web.UI.WebControls.DataGrid
    'Protected WithEvents btnCancelar As System.Web.UI.WebControls.Button
    'Protected WithEvents pnlActDatosForm As System.Web.UI.WebControls.Panel
    'Protected WithEvents btnAplicar As System.Web.UI.WebControls.Button
    'Protected WithEvents gvNovedades As System.Web.UI.WebControls.DataGrid
    'Protected WithEvents Panel1 As System.Web.UI.WebControls.Panel
    'Protected WithEvents pnlPendiente As System.Web.UI.WebControls.Panel
    'Protected WithEvents btnBuscar As System.Web.UI.WebControls.Button
    'Protected WithEvents txtCedula As System.Web.UI.WebControls.TextBox
    'Protected WithEvents Button1 As System.Web.UI.WebControls.Button
    'Protected WithEvents imgRepBusca As System.Web.UI.WebControls.Image
    'Protected WithEvents RequiredFieldValidator1 As System.Web.UI.WebControls.RequiredFieldValidator
    'Protected WithEvents Label1 As System.Web.UI.WebControls.Label
    'Protected WithEvents lblEmpleadoNombres As System.Web.UI.WebControls.Label
    'Protected WithEvents Label2 As System.Web.UI.WebControls.Label
    'Protected WithEvents lblEmpleadoApellidos As System.Web.UI.WebControls.Label
    'Protected WithEvents TRNombres As System.Web.UI.HtmlControls.HtmlTableRow
    'Protected WithEvents TRApellidos As System.Web.UI.HtmlControls.HtmlTableRow
    'Protected WithEvents ddNomina As System.Web.UI.WebControls.DropDownList
    'Protected WithEvents Textbox1 As System.Web.UI.WebControls.TextBox
    'Protected WithEvents lblNombres As System.Web.UI.WebControls.Label
    'Protected WithEvents lblApellidos As System.Web.UI.WebControls.Label
    'Protected WithEvents lblNSS As System.Web.UI.WebControls.Label
    'Protected WithEvents TRNss As System.Web.UI.HtmlControls.HtmlTableRow
    'Protected WithEvents btnCancelaBusqueda As System.Web.UI.WebControls.Button
    'Protected WithEvents lblMsg2 As System.Web.UI.WebControls.Label
    'Protected WithEvents lblIdNssDependiente As System.Web.UI.WebControls.Label
    'Protected WithEvents lblIdNss As System.Web.UI.WebControls.Label


    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Private _dtDependientes As DataTable = Nothing
    Private _tmpDTdependientes As DataTable = Nothing

    'Propiedad utilizada para almacenar los dependientes temporalmente
    Private Property dtDependientes() As DataTable
        Get
            _dtDependientes = DirectCast(ViewState("dtDependientes"), DataTable)
            Return _dtDependientes
        End Get
        Set(ByVal Value As DataTable)
            ViewState("dtDependientes") = Value
        End Set
    End Property

    Private Property tmpDtDependientes() As DataTable
        Get
            _tmpDTdependientes = DirectCast(ViewState("tmpDTDependientes"), DataTable)
            Return _tmpDTdependientes
        End Get
        Set(ByVal Value As DataTable)
            ViewState("tmpDTDependientes") = Value
        End Set
    End Property

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not IsPostBack Then
            Me.iniForm()
        End If
        Me.lblMsg.Text = ""
        Me.lblMsg2.Text = ""
        Me.lblMsg.ForeColor = Drawing.Color.Red

    End Sub

    Private Sub iniForm()
        If Me.ddNomina.Items.Count > 0 Then Me.ddNomina.SelectedIndex = 0
        Me.pnlActDatosForm.Visible = False
        Me.pnlPendiente.Visible = False
        Me.btnBuscar.Enabled = True
        Me.btnCancelaBusqueda.Visible = False
        Me.lblEmpleadoNombres.Text = String.Empty
        Me.lblEmpleadoApellidos.Text = String.Empty
        Me.lblNSS.Text = String.Empty
        Me.TRNss.Visible = False
        Me.TRNombres.Visible = False
        Me.TRApellidos.Visible = False
        Me.pnlActDatosForm.Visible = False
        Me.imgRepBusca.Visible = False

        Dim dt As New DataTable
        Me.gvDependientes.DataSource = dt
        Me.gvDependientes.DataBind()

        'Me.gvNovedades.DataSource = dt
        'Me.gvNovedades.DataBind()

        Me.txtCedula.Text = String.Empty
        Me.dtDependientes = Nothing
        dt = Nothing
    End Sub

    Protected Overrides Sub OnPreRender(ByVal e As System.EventArgs)

        If Not IsPostBack() Then
            Me.cargarNominas()
            novedadesPendientes()
        End If

        For Each i As System.Web.UI.WebControls.GridViewRow In Me.gvDependientes.Rows

            CType(i.FindControl("iBtnBorrar"), ImageButton).Attributes.Add("onClick", "return confirm('Esta seguro que desea eliminar este dependiente?');")
        Next

    End Sub

    Private Sub cargarNominas()

        Dim tmpRep As SuirPlus.Empresas.Representante

        'Determinando el tipo de usuario logeado en el sistema
        'Si es Usuario
        'If Me.UsuarioActual.IDTipoUsuario = "1" Then
        '    tmpRep = New SuirPlus.Empresas.Representante(Me.ucSubEncabezado.RNC, Me.ucSubEncabezado.Documento)
        'Else
        '    tmpRep = CType(Me.UsuarioActual, SuirPlus.Empresas.Representante)
        'End If

        tmpRep = New SuirPlus.Empresas.Representante(Me.UsrRNC, Me.UsrCedula)

        Me.ddNomina.DataSource = tmpRep.getAccesos()
        Me.ddNomina.DataTextField = "nomina_des"
        Me.ddNomina.DataValueField = "id_nomina"
        Me.ddNomina.DataBind()
        tmpRep = Nothing

    End Sub

    Private Sub cargaDependientes()
        If Not Me.lblNSS.Text = String.Empty Then
            ' Cargando grid de dependientes
            Me.gvDependientes.DataSource = Me.tmpDtDependientes
            Me.gvDependientes.DataBind()
            Me.pnlActDatosForm.Visible = True
            Me.gvDependientes.Visible = True
        End If
        If Me.TieneDependientes() <= 0 Then
            If Not Me.lblNSS.Text = String.Empty Then
                Me.lblMsg2.Text = "Este Empleado no tiene dependientes Adicionales"
                Me.pnlActDatosForm.Visible = False
                Me.gvDependientes.Visible = False

            End If
        End If

    End Sub

    Protected Sub gvDependientes_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvDependientes.RowCommand

        If e.CommandName = "Borrar" Then

            Dim row As GridViewRow = CType(CType(e.CommandSource, Control).NamingContainer, GridViewRow)
            Dim idNssDep As Int32 = CInt(CType(row.FindControl("lblIdNssDep"), Label).Text)
            Dim msg As String = String.Empty

            'Verificamos si el dependiente es valido
            If SuirPlus.Empresas.Trabajador.isDependienteValido("SD", Me.UsrRegistroPatronal, CInt(Me.ddNomina.SelectedValue), CInt(Me.lblNSS.Text), idNssDep, msg) Then


                SuirPlus.Empresas.Trabajador.novedadBajaDependientes(Me.UsrRegistroPatronal, Me.ddNomina.SelectedValue, CInt(Me.lblNSS.Text), idNssDep, Me.UsrUserName, Me.GetIPAddress())
                Me.deleteDependienteRow(idNssDep)
            Else
                Me.lblMsg.Text = "Error al poner de baja este dependiente. " & msg
                Exit Sub
            End If
        End If
        Me.cargaDependientes()
        Me.novedadesPendientes()

    End Sub

    Private Sub novedadesPendientes()

        Try
            'Obteniendo novedades pendientes
            Dim tmpDataTable As DataTable

            'Determinando el tipo de usuario
            'Si es Usuario
            'If Me.UsuarioActual.IDTipoUsuario = "1" Then

            '    tmpDataTable = SuirPlus.Empresas.Trabajador.getMovimientos(Me.ucSubEncabezado.RegistroPatronal, "NV", "SD", "S", Me.ucSubEncabezado.RNC & Me.ucSubEncabezado.Documento)
            'Else

            '    tmpDataTable = SuirPlus.Empresas.Trabajador.getMovimientos(Me.ucSubEncabezado.RegistroPatronal, "NV", "SD", "S", Me.ucSubEncabezado.RNC & CType(Me.UsuarioActual, SuirPlus.Empresas.Representante).Cedula)
            'End If

            tmpDataTable = SuirPlus.Empresas.Trabajador.getMovimientos(Me.UsrRegistroPatronal, "NV", "SD", "S", Me.UsrRNC & Me.UsrCedula)
            UcGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, "NV", "SD", "S", Me.UsrRNC & Me.UsrCedula)

            If tmpDataTable.Rows.Count > 0 Then
                Me.pnlPendiente.Visible = True
                'Me.gvNovedades.Visible = True
                'Me.gvNovedades.DataSource = tmpDataTable
                'Me.gvNovedades.DataBind()
            Else
                Me.pnlPendiente.Visible = False
                'Me.gvNovedades.Visible = False
            End If
            tmpDataTable = Nothing
        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub gvNovedades_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) ' Handles gvNovedades.RowCommand

        If e.CommandName = "Borrar" Then

            Dim row As GridViewRow = CType(CType(e.CommandSource, Control).NamingContainer, GridViewRow)
            Dim idMov As Int32 = CType(row.FindControl("lblIdMov"), Label).Text.ToString()
            Dim idLinia As Int32 = CType(row.FindControl("lblIdLinia"), Label).Text.ToString()
            Dim IdNssDependiente As Int32 = CInt(CType(row.FindControl("lblIdNssDependiente"), Label).Text)



            Dim nombre As String = row.Cells(1).Text
            Dim cedula As String = row.Cells(2).Text
            'Dim fechaRegistro As String = row.Cells(6).Text

            SuirPlus.Empresas.Trabajador.borraNovedad(idMov, idLinia)

            'Insertamos el registro borrado del gridview de novedades al grid view de dependientes nuevamente
            'Si el titular tiene dependientes asignados
            If Not Me.lblNSS.Text = String.Empty Then
                Me.AddDependienteRow(IdNssDependiente, cedula, nombre) ', fechaRegistro)
            End If

        End If

        Me.novedadesPendientes()
        Me.cargaDependientes()
    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.iniForm()
    End Sub

    Private Sub btnAplicar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAplicar.Click
        If SuirPlus_Status = "REDUCIDO" Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = SuirPlusREDUCIDO
            Exit Sub
        End If

        'Aplicamos los movimientos para la empresa y el usuario actual
        Dim ret As String = SuirPlus.Empresas.Trabajador.aplicarMovimientos(Me.UsrRegistroPatronal, Me.UsrUserName)

        If ret = "Cambio Realizado" Then
            Me.pnlPendiente.Visible = False
            Me.lblMsg.ForeColor = Drawing.Color.Blue
            Me.lblMsg.Text = "Novedades aplicadas satisfactoriamente."
            Response.Redirect("NovedadesAplicadas.aspx?msg=Novedades aplicadas satisfactoriamente.")
            Me.novedadesPendientes()
        Else
            Me.lblMsg.ForeColor = Drawing.Color.Red
            Me.lblMsg.Text = "Novedades no aplicadas."
            Response.Redirect("NovedadesAplicadas.aspx?msg=Novedades no aplicadas.")
            Me.pnlPendiente.Visible = True
        End If

    End Sub

    Private Sub btnBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        If Me.txtCedula.Text <> String.Empty Then

            Dim tmpstr As String = Utilitarios.TSS.consultaCiudadano("C", Me.txtCedula.Text)
            Dim retStr As String() = Split(tmpstr, "|")
            Dim tmpTable As DataTable = Nothing
            Dim regPatronal As Integer = Me.UsrRegistroPatronal

            'El ciudadano fue encontrado
            If retStr(0) = "0" Then

                btnCancelaBusqueda.Visible = True
                'Presenta info de la persona
                Me.lblEmpleadoNombres.Text = Microsoft.VisualBasic.Strings.StrConv(retStr(1), VbStrConv.ProperCase)
                Me.lblEmpleadoApellidos.Text = Microsoft.VisualBasic.Strings.StrConv(retStr(2), VbStrConv.ProperCase)
                Me.lblNSS.Text = retStr(3)
                Me.TRNss.Visible = True
                Me.TRNombres.Visible = True
                Me.TRApellidos.Visible = True
                Me.btnBuscar.Enabled = False

                'Verificamos que el cuidadano sea un empleado
                tmpTable = Trabajador.getInfoTrabajador(regPatronal, ddNomina.SelectedValue, Integer.Parse(lblNSS.Text), Utils.getPeriodoActual())

                If tmpTable.Rows.Count > 0 Then
                    'Verificamos que el trabajador no esté de baja.
                    If tmpTable.Rows(0)("STATUS") = "A" Then
                        Me.imgRepBusca.ImageUrl = CType(Me.Page(), BasePage).urlImgOK
                        imgRepBusca.Visible = True
                        'Cargamos los dependiente y activamos los paneles
                        setDependientes()
                        Me.cargaDependientes()
                    Else
                        Me.lblMsg.Text = "El empleado no esta activo en esta nómina."
                    End If
                Else
                    Me.lblMsg.Text = "La persona especificada no es empleado de esta nómina o empresa."
                    Me.imgRepBusca.ImageUrl = CType(Me.Page(), BasePage).urlImgCancelar
                    imgRepBusca.Visible = True
                End If

            Else
                Me.lblMsg.Text = "No se encontró el empleado."
            End If

        End If

    End Sub

    Private Sub btnCancelaBusqueda_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelaBusqueda.Click
        Me.iniForm()
    End Sub

    Private Function TieneDependientes() As Integer
        Dim retorno As Integer = 0
        'Funcion que devuelve la cantidad de Dependientes
        If Not Me.lblNSS.Text = String.Empty Then
            Dim cantRegistros As Integer
            Dim dt As New DataTable
            'dt = SuirPlus.Empresas.Trabajador.getDependientes(Me.ucSubEncabezado.RegistroPatronal, Me.ddNomina.SelectedValue, Me.lblNSS.Text) 'Me.ucEmpleado.getNSS)
            dt = Me.tmpDtDependientes
            cantRegistros = dt.Rows.Count
            retorno = cantRegistros
        End If

        Return retorno

    End Function

    Private Function TienenovedadesPendientes() As Integer
        'Funcion que devuelve la cantidad de novedades pendientes
        'Obteniendo novedades pendientes
        Dim tmpDataTable As DataTable
        Dim cantRegistros As Integer

        'Determinando el tipo de usuario
        'Si es Usuario
        'If Me.UsuarioActual.IDTipoUsuario = "1" Then

        '    tmpDataTable = SuirPlus.Empresas.Trabajador.getMovimientos(Me.ucSubEncabezado.RegistroPatronal, "NV", "SD", "S", Me.ucSubEncabezado.RNC & Me.ucSubEncabezado.Documento)
        'Else

        '    tmpDataTable = SuirPlus.Empresas.Trabajador.getMovimientos(Me.ucSubEncabezado.RegistroPatronal, "NV", "SD", "S", Me.ucSubEncabezado.RNC & CType(Me.UsuarioActual, SuirPlus.Empresas.Representante).Cedula)
        'End If

        tmpDataTable = SuirPlus.Empresas.Trabajador.getMovimientos(Me.UsrRegistroPatronal, "NV", "SD", "S", Me.UsrRNC & Me.UsrCedula)

        cantRegistros = tmpDataTable.Rows.Count
        Return (cantRegistros)

    End Function

    Protected Sub setDependientes()

        Dim dt As New DataTable
        dt = SuirPlus.Empresas.Trabajador.getDependientes(Me.UsrRegistroPatronal, Me.ddNomina.SelectedValue, CInt(Me.lblNSS.Text))

        Me.dtDependientes = dt.Copy
        Me.dtDependientes.PrimaryKey = New DataColumn() {Me.dtDependientes.Columns("ID_NSS_DEPENDIENTE")}

        Me.tmpDtDependientes = dt.Copy
        Me.tmpDtDependientes.PrimaryKey = New DataColumn() {Me.tmpDtDependientes.Columns("ID_NSS_DEPENDIENTE")}

    End Sub

    Private Sub deleteDependienteRow(ByVal nss As Integer)

        Dim tmpRow As DataRow = tmpDtDependientes.Rows.Find(nss)
        If Not tmpRow Is Nothing Then
            tmpDtDependientes.Rows.Remove(tmpRow)
            tmpDtDependientes.AcceptChanges()
        End If

    End Sub

    Private Sub AddDependienteRow(ByVal nss As Integer, ByVal cedula As String, ByVal nombre As String) ', ByVal fechaRegistro As String)

        Try

            Dim tmpRow As DataRow = Me.tmpDtDependientes.NewRow
            tmpRow("ID_NSS_DEPENDIENTE") = nss
            tmpRow("DOCUMENTODEP") = cedula
            tmpRow("NOMBREDEP") = nombre
            ' tmpRow("FECHA_REGISTRO") = fechaRegistro



            Me.tmpDtDependientes.Rows.Add(tmpRow)
            Me.tmpDtDependientes.AcceptChanges()

        Catch ex As Exception
            Me.lblMsg.Text = ex.ToString
            Me.lblMsg.Visible = True
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub


End Class
