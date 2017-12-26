Imports System.Data
Imports SuirPlus


Partial Class Novedades_novRegDependientes
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

    Private Const CrLf As String = Microsoft.VisualBasic.vbCrLf
    Private Const Tab As String = Microsoft.VisualBasic.vbTab
    Dim tmpDT As Data.DataTable = Nothing
    Dim idnss As String = String.Empty

    Protected Property NSS() As Integer
        Get
            If ViewState("NSS") = Nothing Then
                ViewState("NSS") = 0
            End If
            Return CInt(ViewState("NSS"))
        End Get
        Set(ByVal value As Integer)
            ViewState("NSS") = value
        End Set
    End Property

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not IsPostBack Then
            Me.SetFocus(Me.txtCedula)
        End If

    End Sub

    Private Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.PreRender

        'Mostramos si hay novedades pendiente, lo hacemos en el prerender porque el control UCencabezado ya esta instanaciado
        If Not IsPostBack Then
            cargarNominas()

        End If

        novedadesPendientes()

    End Sub

    Private Sub btnBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        If Me.txtCedula.Text <> String.Empty Then
            If ddNomina.SelectedValue = String.Empty Then
                Me.lblMsg.Text = "Debes seleccionar una nómina válida."
                Exit Sub
            End If

            Dim tmpstr As String = SuirPlus.Utilitarios.TSS.consultaCiudadano("C", Me.txtCedula.Text)
            Dim retStr As String() = Split(tmpstr, "|")
            Dim tmpTable As Data.DataTable = Nothing
            Dim regPatronal As Integer = Me.UsrRegistroPatronal

            'El ciudadano fue encontrado
            If retStr(0) = "0" Then

                btnCancelaBusqueda.Visible = True

                'Presenta info de la persona
                Me.lblEmpleadoNombres.Text = Microsoft.VisualBasic.Strings.StrConv(retStr(1), VbStrConv.ProperCase)
                Me.lblEmpleadoApellidos.Text = Microsoft.VisualBasic.Strings.StrConv(retStr(2), VbStrConv.ProperCase)

                Me.NSS = retStr(3)

                Me.TRNombres.Visible = True
                Me.TRApellidos.Visible = True
                Me.btnBuscar.Enabled = False

                If ddNomina.SelectedValue = "" Then
                    Me.lblMsg.Text = "Debe seleccionar una nómina."
                    Exit Sub
                End If

                If Me.NSS = 0 Then
                    Me.lblMsg.Text = "El NSS del Ciudadado es inválido."
                    Exit Sub
                End If

                'Verificamos que el cuidadano sea un empleado
                tmpTable = SuirPlus.Empresas.Trabajador.getInfoTrabajador(regPatronal, CInt(ddNomina.SelectedValue), NSS, SuirPlus.Utilitarios.Utils.getPeriodoActual())

                If tmpTable.Rows.Count > 0 Then
                    'Verificamos que el trabajado no esté de baja.
                    If tmpTable.Rows(0)("STATUS") = "A" Then
                        Me.imgRepBusca.ImageUrl = CType(Me.Page(), BasePage).urlImgOK
                        imgRepBusca.Visible = True
                        muestraPeriodo()
                        Me.ddNomina.Enabled = False
                        Me.pnlActDatosForm.Visible = True
                        'Colocamos el focus al txtdocumento
                        Me.SetFocus(Me.txtDoumento)
                        Me.divAgregarDep.Visible = False
                    Else
                        Me.lblMsg.Text = "El empleado no esta activo en esta nómina."
                    End If
                Else
                    Me.lblMsg.Text = "<br/> La persona especificada no es empleado de esta nómina o empresa."
                    Me.imgRepBusca.ImageUrl = CType(Me.Page(), BasePage).urlImgCancelar
                    imgRepBusca.Visible = True
                End If

            Else
                Me.lblMsg.Text = "No se encontró el empleado."
            End If

            tmpTable = Nothing
        End If
    End Sub

    Private Sub btnCancelaBusqueda_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelaBusqueda.Click

        initFormBusqueda()

    End Sub

    Private Sub btnAplicar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAplicar.Click

        If SuirPlus_Status = "REDUCIDO" Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = SuirPlusREDUCIDO
            Exit Sub
        End If

        Try
            Dim ret As String = SuirPlus.Empresas.Trabajador.aplicarMovimientos(Me.UsrRegistroPatronal, Me.UsrUserName)
            If ret = "Cambio Realizado" Then
                Me.lblMsg.ForeColor = Drawing.Color.Blue
                Me.lblMsg.Font.Bold = True
                Me.lblMsg.Text = "<br/>Novedades aplicadas satisfactoriamente.<br/>"
                Response.Redirect("NovedadesAplicadas.aspx?msg=Novedades aplicadas satisfactoriamente.")
            Else
                Me.lblMsg.Text = "<br/>" & ret & "<br/>"
                Response.Redirect("NovedadesAplicadas.aspx?msg=Error: " & ret)
            End If
            Me.novedadesPendientes()
        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub btnValidar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnValidar.Click
        'Validamos que no este en blanco la cedula o el nss
        If Not Me.txtDoumento.Text = String.Empty Then

            If Me.ddlTipoDoc.SelectedValue = "C" And Not Me.txtDoumento.Text.Length.Equals(11) Then
                Me.lblMsg2.Text = "Cédula Inválida"
                Me.lblMsg2.Visible = True
                Exit Sub
            End If

            Try
                'Verificamos como vamos a buscar el ciudadano
                If Me.ddlTipoDoc.SelectedValue.ToString() = "C" Then
                    tmpDT = SuirPlus.Utilitarios.TSS.getConsultaNss(Me.txtDoumento.Text, Nothing, Nothing, Nothing, Nothing, 1, 15)
                Else
                    tmpDT = SuirPlus.Utilitarios.TSS.getConsultaNss(Nothing, Me.txtDoumento.Text, Nothing, Nothing, Nothing, 1, 15)
                End If
            Catch exF As SuirPlus.Exepciones.DataNoFoundException
                Me.lblMsg2.Text = "Ciudadano no encontrado."
                tmpDT = Nothing
                Exit Sub
            Catch ex As Exception
                Me.lblMsg2.Text = ex.Message
                tmpDT = Nothing
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                Exit Sub
            End Try

            If tmpDT.Rows.Count > 0 Then
                Dim msg As String = String.Empty
                Session("idnss") = Nothing
                Me.lblNombreDep.Text = String.Empty

                'obtenemos los datos del nuevo dependiente

                Me.lblNombreDep.Text = tmpDT.Rows(0)("Nombres") & " " & tmpDT.Rows(0)("Apellidos")
                Session("idnss") = tmpDT.Rows(0)("ID_NSS")

                'Verificamos si el dependiente es valido
                If SuirPlus.Empresas.Trabajador.isDependienteValido("ID", Me.UsrRegistroPatronal, CInt(Me.ddNomina.SelectedValue), CInt(Me.NSS), CInt(tmpDT.Rows(0)("ID_NSS")), msg) Then

                    Dim result As String = String.Empty
                    Me.divAgregarDep.Visible = True
                Else
                    'Mostramos el mensaje.
                    Me.lblMsg2.Text = msg
                    Me.lblMsg2.Visible = True
                    Me.divAgregarDep.Visible = False
                End If

            Else
                Me.lblMsg2.Text = "NSS o Cédula Inválido"
                Me.lblMsg2.Visible = True
            End If


        End If

    End Sub

#Region "Metodos y funciones privadas"

    Private Sub novedadesPendientes()

        Try

            'Obteniendo novedades pendientes
            Dim tmpDataTable As Data.DataTable

            tmpDataTable = SuirPlus.Empresas.Trabajador.getMovimientos(Me.UsrRegistroPatronal, "NV", "ID", "I", Me.UsrRNC & Me.UsrCedula)
            UcGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, "NV", "ID", "I", Me.UsrRNC & Me.UsrCedula)

            If tmpDataTable.Rows.Count > 0 Then
                Me.pnlNovedadesDet.Visible = True
                Me.lblPendientes.Visible = True
                pnlPendiente.Visible = True
                Me.btnAplicar.Visible = True
            Else
                Me.pnlNovedadesDet.Visible = True
                Me.lblPendientes.Visible = False
                pnlPendiente.Visible = False
                Me.btnAplicar.Visible = False
            End If

            tmpDataTable = Nothing
        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub cargarNominas()

        Dim tmpRep As SuirPlus.Empresas.Representante

        tmpRep = New SuirPlus.Empresas.Representante(Me.UsrRNC, Me.UsrCedula)

        'Colocamos el datatable en un DataView para filtrar las filas y que no se muestren las nominas de pensionados.
        Dim tmpDV As Data.DataView = tmpRep.getAccesos.DefaultView
        'Comentado porque se solicitó que se incluyan las nominas de pensionados, 20/05/2010
        'tmpDV.RowFilter = "TIPO_NOMINA <> 'P'"

        Me.ddNomina.DataSource = tmpDV
        Me.ddNomina.DataTextField = "nomina_des"
        Me.ddNomina.DataValueField = "id_nomina"
        Me.ddNomina.DataBind()
        tmpRep = Nothing

    End Sub

    Private Sub muestraPeriodo()

        Dim tmpPeriodo As String = SuirPlus.Empresas.Trabajador.getPeriodo(Me.UsrRegistroPatronal, CInt(Me.ddNomina.SelectedValue))
        Me.lblPeriodo.Text = Me.formateaPeriodo(tmpPeriodo)

    End Sub

    Protected Function formateaPeriodo(ByVal Periodo As String) As String

        If Not Periodo = String.Empty Then
            Return SuirPlus.Utilitarios.Utils.FormateaPeriodo(Periodo)
        End If

        Return String.Empty

    End Function

    Protected Function formateaCedula(ByVal cedula As String) As String

        If Not cedula = String.Empty Then
            Return SuirPlus.Utilitarios.Utils.FormatearCedula(cedula)
        End If

        Return String.Empty

    End Function

    'Metodo utilizado para inicializar los controles afectados en la busqueda de un trabajador.
    Private Sub initFormBusqueda()

        Me.btnBuscar.Enabled = True
        Me.ddNomina.Enabled = True
        Me.btnCancelaBusqueda.Visible = False
        Me.lblEmpleadoNombres.Text = String.Empty
        Me.lblEmpleadoApellidos.Text = String.Empty
        Me.lblNSS.Text = String.Empty
        Me.TRNombres.Visible = False
        Me.TRApellidos.Visible = False
        Me.pnlActDatosForm.Visible = False
        Me.imgRepBusca.Visible = False
        novedadesPendientes()
        Me.txtDoumento.Text = String.Empty
        Me.txtCedula.Text = String.Empty
        Me.txtCedula.Focus()

    End Sub

#End Region

    Protected Sub btnAgregar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAgregar.Click
        'Validamos que no este en blanco la cedula o el nss
        If Not Me.txtDoumento.Text = String.Empty Then

            If Me.ddlTipoDoc.SelectedValue = "C" And Not Me.txtDoumento.Text.Length.Equals(11) Then
                Me.lblMsg2.Text = "Cédula Inválida"
                Me.lblMsg2.Visible = True
                Exit Sub
            End If

            Dim tmpDT As Data.DataTable = Nothing

            Try
                'Verificamos como vamos a buscar el ciudadano
                If Me.ddlTipoDoc.SelectedValue.ToString() = "C" Then
                    tmpDT = SuirPlus.Utilitarios.TSS.getConsultaNss(Me.txtDoumento.Text, Nothing, Nothing, Nothing, Nothing, 1, 15)
                Else
                    tmpDT = SuirPlus.Utilitarios.TSS.getConsultaNss(Nothing, Me.txtDoumento.Text, Nothing, Nothing, Nothing, 1, 15)
                End If
            Catch exF As SuirPlus.Exepciones.DataNoFoundException
                Me.lblMsg2.Text = "Ciudadano no encontrado."
                tmpDT = Nothing
                Exit Sub
            Catch ex As Exception
                Me.lblMsg2.Text = ex.Message
                tmpDT = Nothing
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                Exit Sub
            End Try

            If tmpDT.Rows.Count > 0 Then

                Dim msg As String = String.Empty

                'Verificamos si el dependiente es valido
                'If SuirPlus.Empresas.Trabajador.isDependienteValido("ID", Me.UsrRegistroPatronal, CInt(Me.ddNomina.SelectedValue), CInt(Me.NSS), CInt(tmpDT.Rows(0)("ID_NSS")), msg) Then

                Dim result As String = String.Empty

                'Agregamos el dependiente
                result = SuirPlus.Empresas.Trabajador.novedadIngresoDependientes(Me.UsrRegistroPatronal, CInt(ddNomina.SelectedValue), CInt(Me.NSS), CInt(tmpDT.Rows(0)("ID_NSS")), Me.UsrUserName, Me.GetIPAddress())
                If result <> "0" Then
                    Me.lblMsg2.Text = result.Split("|")(1)
                    Me.lblMsg2.Visible = True
                    Exit Sub
                End If

                UcGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, CInt(ddNomina.SelectedValue), CInt(Me.NSS), CInt(tmpDT.Rows(0)("ID_NSS")), Me.UsrUserName)

                novedadesPendientes()
                Me.txtDoumento.Text = String.Empty
                Me.SetFocus(Me.txtDoumento)
                Me.divAgregarDep.Visible = False
                'Else
                '    'Mostramos el mensaje.
                '    Me.lblMsg2.Text = msg
                '    Me.lblMsg2.Visible = True
                '    Me.divAgregarDep.Visible = True
                'End If

            Else
                Me.lblMsg2.Text = "NSS o Cédula Inválido"
                Me.lblMsg2.Visible = True
            End If

            tmpDT = Nothing
        End If
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.divAgregarDep.Visible = False
        Me.txtDoumento.Text = String.Empty
    End Sub

End Class