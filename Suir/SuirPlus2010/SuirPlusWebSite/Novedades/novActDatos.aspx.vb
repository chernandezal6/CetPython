Imports SuirPlus.Mantenimientos.TipoIngreso
Partial Class Novedades_novActDatos
    Inherits BasePage

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub


    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Private Sub iniForm()

        If Me.ddNomina.Items.Count >= 0 Then Me.ddNomina.SelectedIndex = 0
        Me.ucEmpleado.iniForm()
        Me.ucFechaAplicacion.dateValue = Now.Date
        Me.pnlActualizaSalario.Visible = False
        Me.UpdCiudadano.Update()

        'Formateamos los texbox

        'Me.txtAporteVoluntario.Text = "0.00"
        'Me.txtOtrasRemuneraciones.Text = "0.00"
        'Me.txtSalarioISR.Text = "0.00"
        'Me.txtSalarioINF.Text = "0.00"
        'Me.txtRemuneracionesOtroEmp.Text = "0.00"
        'Me.txtSaldoFavor.Text = "0.00"
        'Me.txtIngresoExento.Text = "0.00"
        'Me.txtAgenteRetencionISR.Text = ""


    End Sub

    Private Sub On_BusquedaCancelada(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ucEmpleado.BusquedaCancelada

        'Si cancelan la busqueda del empleado, se apaga el panel de actualizacion de datos.
        Me.iniForm()

    End Sub

    Private Sub On_CiudadanoEncontrado(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ucEmpleado.CiudadanoEncontrado

        Dim tmpTable As Data.DataTable = SuirPlus.Empresas.Trabajador.getInfoTrabajador(Me.UsrRegistroPatronal, Me.ddNomina.SelectedValue, Integer.Parse(Me.ucEmpleado.getNSS), SuirPlus.Utilitarios.Utils.getPeriodoActual())

        'Si se encuentra el empleado, se cargan los datos
        If tmpTable.Rows.Count > 0 Then

            If tmpTable.Rows(0)("STATUS") = "A" Then
                'Cargando datos del empleado

                'Labels
                Try
                    Me.lblAgenteRetencionISR.Text = tmpTable.Rows(0)("RNC_O_CEDULA").ToString

                    Me.txtAgenteRetencionISR.Text = tmpTable.Rows(0)("RNC_O_CEDULA").ToString

                Catch ex As Exception
                    Me.lblAgenteRetencionISR.Text = ""
                    Me.txtAgenteRetencionISR.Text = ""
                    SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                End Try

                Me.lblAporteVoluntario.Text = FormatNumber(tmpTable.Rows(0)("APORTE_VOLUNTARIO").ToString)
                Me.lblOtrasRemuneraciones.Text = FormatNumber(tmpTable.Rows(0)("OTROS_INGRESOS_ISR").ToString)
                Me.lblRemuneracionesOtroEmp.Text = FormatNumber(tmpTable.Rows(0)("REMUNERACION_ISR_OTROS").ToString)
                Me.lblSalarioISR.Text = FormatNumber(tmpTable.Rows(0)("SALARIO_ISR").ToString)
                Me.lblSalarioINF.Text = FormatNumber(tmpTable.Rows(0)("SALARIO_INFOTEP").ToString)
                Me.lblSalarioSS.Text = FormatNumber(tmpTable.Rows(0)("SALARIO_SS").ToString)
                Me.lblSaldoFavor.Text = tmpTable.Rows(0)("SALDO_FAVOR_ISR").ToString
                Dim tmpPeriodo As String = SuirPlus.Empresas.Trabajador.getPeriodo(Me.UsrRegistroPatronal, SuirPlus.Utilitarios.Utils.getPeriodoActual())
                Me.lblPeriodo.Text = Microsoft.VisualBasic.Right(tmpPeriodo, 2) + "-" + Microsoft.VisualBasic.Left(tmpPeriodo, 4)
                Me.lblIngresoExento.Text = tmpTable.Rows(0)("INGRESOS_EXENTOS").ToString
                Me.lblTipoIngreso.Text = tmpTable.Rows(0)("TipoIngreso").ToString
                Me.ddTipoIngreso.Text = tmpTable.Rows(0)("CodIngreso").ToString

                'TextBoxs
                Me.txtAporteVoluntario.Text = tmpTable.Rows(0)("APORTE_VOLUNTARIO").ToString
                Me.txtOtrasRemuneraciones.Text = tmpTable.Rows(0)("OTROS_INGRESOS_ISR").ToString
                Me.txtRemuneracionesOtroEmp.Text = tmpTable.Rows(0)("REMUNERACION_ISR_OTROS").ToString
                Me.txtSalarioISR.Text = tmpTable.Rows(0)("SALARIO_ISR").ToString
                Me.txtSalarioINF.Text = tmpTable.Rows(0)("SALARIO_INFOTEP").ToString
                Me.txtSalarioSS.Text = tmpTable.Rows(0)("SALARIO_SS").ToString
                Me.txtSaldoFavor.Text = tmpTable.Rows(0)("SALDO_FAVOR_ISR").ToString
                Me.txtIngresoExento.Text = tmpTable.Rows(0)("SALDO_FAVOR_ISR").ToString
                Me.txtIngresoExento.Text = tmpTable.Rows(0)("INGRESOS_EXENTOS").ToString

                'Mostrando panel de informacion de empleado
                Me.pnlActualizaSalario.Visible = True
                Me.UpdCiudadano.Update()
                Me.ucEmpleado.updatePanelCiudadano()
            Else 'Si el empleado fue encontrado pero en estatus B, dezpliega mensaje

                Me.lblMensaje.Text = "Este empleado no está activo en esta nómina."
                Me.pnlActualizaSalario.Visible = False
                Me.UpdCiudadano.Update()

            End If

        Else 'Si no se encuentra el empleado, se dezpliega un mensaje

            Me.lblMensaje.Text = "Este empleado no fué encontrado en esta nómina."
            Me.ucEmpleado.updatePanelCiudadano()
            Me.UpdCiudadano.Update()
        End If

    End Sub

    Private Sub novedadesPendientes()

        Try

            'Obteniendo novedades pendientes
            Dim tmpDataTable As Data.DataTable

            'Determinando el tipo de usuario
            'Si es Usuario
            tmpDataTable = SuirPlus.Empresas.Trabajador.getMovimientos(Me.UsrRegistroPatronal, "NV", "AD", "A", Me.UsrRNC & Me.UsrCedula)
            UcGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, "NV", "AD", "A", Me.UsrRNC & Me.UsrCedula)

            If tmpDataTable.Rows.Count > 0 Then
                Me.pnlPendiente.Visible = True
                Me.lblPendientes.Visible = True
                Me.btnAplicar.Visible = True
            Else
                Me.pnlPendiente.Visible = False
                Me.lblPendientes.Visible = False
                Me.btnAplicar.Visible = False
            End If

            tmpDataTable = Nothing
        Catch ex As Exception
            Response.Write(ex)
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub cargarNominas()

        Dim tmpRep As SuirPlus.Empresas.Representante

        'Determinando el tipo de usuario logeado en el sistema
        'Si es Usuario
        tmpRep = New SuirPlus.Empresas.Representante(Me.UsrRNC, Me.UsrCedula)

        Me.ddNomina.DataSource = tmpRep.getAccesos()
        Me.ddNomina.DataTextField = "nomina_des"
        Me.ddNomina.DataValueField = "id_nomina"
        Me.ddNomina.DataBind()
        tmpRep = Nothing

    End Sub
    Private Sub cargarTiposIngreso()

        Me.ddTipoIngreso.DataSource = getTiposIngreso()
        Me.ddTipoIngreso.DataTextField = "Descripcion"
        Me.ddTipoIngreso.DataValueField = "cod_ingreso"
        Me.ddTipoIngreso.DataBind()

    End Sub
    Private Sub btnAceptar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        If SuirPlus_Status = "REDUCIDO" Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = SuirPlusREDUCIDO
            Exit Sub
        End If

        'Validando que hayan nominas en el DropDown
        If Me.ddNomina.Items.Count = 0 Then
            Me.lblMsg.Text = "Usted no tiene nóminas asignadas."
            Return
        End If

        'Validando que ingresen un ciudadano valido
        If Me.ucEmpleado.getNSS = "" Then
            Me.lblMsg.Text = "Debe seleccionar un individuo."
            Return
        End If

        'Validando los aportes y descuento
        If String.IsNullOrEmpty(Me.txtAporteVoluntario.Text) Then
            Me.txtAporteVoluntario.Text = 0.0
        Else
            If Not isDecimal(Me.txtAporteVoluntario.Text) Then
                Me.lblMsg.Text = "El valor en el aporte voluntario es inválido."
                Exit Sub
            End If
        End If

        'Salario ISR
        If String.IsNullOrEmpty(Me.txtSalarioISR.Text) Then
            'Si dejan el salario ISR en 0 que tome el la SS
            Me.txtSalarioISR.Text = Me.txtSalarioSS.Text
        Else
            If Not isDecimal(txtSalarioISR.Text) Then
                Me.lblMsg.Text = "El valor del Salario ISR es inválido."
                Exit Sub
            Else
                If Double.Parse(Me.txtSalarioISR.Text) = 0.0 Then
                    Me.txtSalarioISR.Text = Me.txtSalarioSS.Text
                End If
            End If
        End If


        'Salario INFOTEP
        If String.IsNullOrEmpty(Me.txtSalarioINF.Text) Then
            'Si dejan el salario INFOTEP en 0 que tome el la SS
            Me.txtSalarioINF.Text = Me.txtSalarioSS.Text
        Else
            If Not isDecimal(txtSalarioINF.Text) Then
                Me.lblMsg.Text = "El valor del Salario INFOTEP es inválido."
                Exit Sub
            Else
                If Double.Parse(Me.txtSalarioINF.Text) = 0.0 Then
                    Me.txtSalarioINF.Text = Me.txtSalarioSS.Text
                End If
            End If
        End If

        'Otras Remuneraciones
        If String.IsNullOrEmpty(Me.txtOtrasRemuneraciones.Text) Then
            Me.txtOtrasRemuneraciones.Text = 0.0
        Else
            If Not isDecimal(Me.txtOtrasRemuneraciones.Text) Then
                Me.lblMsg.Text = "El valor de Otras Remuneraciones es inválido."
                Exit Sub
            End If
        End If

        'Saldo a Favor
        If String.IsNullOrEmpty(Me.txtSaldoFavor.Text) Then
            Me.txtSaldoFavor.Text = 0.0
        Else
            If Not isDecimal(Me.txtSaldoFavor.Text) Then
                Me.lblMsg.Text = "El valor del Saldo a Favor es inválido."
                Exit Sub
            End If
        End If

        'Ingreso Exento
        If String.IsNullOrEmpty(Me.txtIngresoExento.Text) Then
            Me.txtIngresoExento.Text = 0.0
        Else
            If Not isDecimal(Me.txtIngresoExento.Text) Then
                Me.lblMsg.Text = "El valor del Ingreso Exento es inválido."
                Exit Sub
            End If
        End If

        'Remuneracion OTros empleadores
        If String.IsNullOrEmpty(Me.txtRemuneracionesOtroEmp.Text) Then
            Me.txtRemuneracionesOtroEmp.Text = 0.0
        Else
            If Not isDecimal(Me.txtRemuneracionesOtroEmp.Text) Then
                Me.lblMsg.Text = "El valor de Remuneraciones Otros Empleadores es inválido."
                Exit Sub
            End If
        End If

        If Not ucFechaAplicacion.isValid Then
            Me.lblMsg.Text = "La fecha de egreso es inválida"
            Exit Sub
        End If

        Dim ret As String = String.Empty
        Dim tmpIdNomina As String = Me.ddNomina.SelectedValue

        If Convert.ToDecimal(txtAporteVoluntario.Text) > 0 Then
        ElseIf Convert.ToDecimal(txtIngresoExento.Text) > 0 Then
        ElseIf Convert.ToDecimal(txtOtrasRemuneraciones.Text) > 0 Then
        ElseIf Convert.ToDecimal(txtRemuneracionesOtroEmp.Text) > 0 Then
        ElseIf Convert.ToDecimal(txtSalarioINF.Text) > 0 Then
        ElseIf Convert.ToDecimal(txtSalarioISR.Text) > 0 Then
        ElseIf Convert.ToDecimal(txtSalarioSS.Text) > 0 Then
        ElseIf Convert.ToDecimal(txtSaldoFavor.Text) > 0 Then
        Else
            Me.lblMsg.Text = "Al menos uno de los campos debe ser mayor que 0."
            Exit Sub
        End If


        Try
            ret = SuirPlus.Empresas.Trabajador.novedadActDatos(Me.UsrRegistroPatronal, Me.ddNomina.SelectedValue, Me.ucEmpleado.getNSS, Me.txtSalarioSS.Text, Me.txtAporteVoluntario.Text, Me.txtSalarioISR.Text, Me.txtSalarioINF.Text, Me.txtAgenteRetencionISR.Text, Me.txtOtrasRemuneraciones.Text, Me.txtRemuneracionesOtroEmp.Text, CDate(Me.ucFechaAplicacion.dateValue), Me.txtIngresoExento.Text, Me.txtSaldoFavor.Text, Me.UsrUserName, Me.ddTipoIngreso.SelectedValue, Me.GetIPAddress())
        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub
        End Try

        If Split(ret, "|")(0) = "0" Then
            Me.Response.Redirect("novActDatos.aspx")
            Me.lblMsg.ForeColor = Drawing.Color.Blue
            Me.lblMsg.Text = "La actualización de datos fue ingresada satisfactoriamente."
            Me.novedadesPendientes()
            Me.iniForm()
            Me.ddNomina.SelectedValue = tmpIdNomina

        Else
            Me.lblMsg.ForeColor = Drawing.Color.Red
            Me.lblMsg.Text = Split(ret, "|")(1)
            Me.novedadesPendientes()
        End If

    End Sub

    Protected Overrides Sub OnPreRender(ByVal e As System.EventArgs)
        If Not IsPostBack() Then
            cargarTiposIngreso()
            cargarNominas()
            novedadesPendientes()
        End If

        Try
            Dim tmpPeriodo As String = SuirPlus.Empresas.Trabajador.getPeriodo(Me.UsrRegistroPatronal, Integer.Parse(Me.ddNomina.SelectedValue))
            Me.lblPeriodo.Text = Microsoft.VisualBasic.Right(tmpPeriodo, 2) + "-" + Microsoft.VisualBasic.Left(tmpPeriodo, 4)

        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click

        Me.iniForm()

    End Sub

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not IsPostBack() Then
            Me.iniForm()

            'Validando si puede registrar novedades
            Dim resultado = SuirPlus.Empresas.Trabajador.PuedeRegistrarNovedades(Me.UsrRegistroPatronal)
            If resultado <> "0" Then
                table1.Visible = False
                lblMensaje.Text = "<a class='label-Resaltado error' href='/empleador/empManejoArchivopy.aspx'>" & resultado & "</a>"
            End If

        End If

        Me.lblMsg.Text = ""
        Me.lblMsg.ForeColor = Drawing.Color.Red
    End Sub

    Private Sub btnAplicar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAplicar.Click
        Dim ret As String = SuirPlus.Empresas.Trabajador.aplicarMovimientos(Me.UsrRegistroPatronal, Me.UsrUserName)
        Me.lblMsg.ForeColor = Drawing.Color.Blue
        Me.lblMsg.Text = "Novedades aplicadas satisfactoriamente."
        Me.novedadesPendientes()

        Response.Redirect("NovedadesAplicadas.aspx?msg=" & Me.lblMsg.Text)
    End Sub

    Private Sub ddNomina_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddNomina.SelectedIndexChanged

        Dim tmpPeriodo As String = SuirPlus.Empresas.Trabajador.getPeriodo(Me.UsrRegistroPatronal, Integer.Parse(Me.ddNomina.SelectedValue))
        Me.lblPeriodo.Text = Microsoft.VisualBasic.Right(tmpPeriodo, 2) + "-" + Microsoft.VisualBasic.Left(tmpPeriodo, 4)

    End Sub

    Protected Function isDecimal(ByVal valor As String) As Boolean

        Return Regex.IsMatch(valor, "^\d+(\.\d\d)?$")

    End Function

End Class