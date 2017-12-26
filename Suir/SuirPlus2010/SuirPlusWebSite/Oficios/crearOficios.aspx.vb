Imports System
Imports System.Data
Imports System.Linq
Imports System.Web.UI
Imports System.IO

Partial Class Oficios_crearOficios
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
    Public Property Marca() As Int32
        Get
            If ViewState("Marca") Is Nothing Then
                Return 0
            Else
                Return ViewState("Marca")
            End If
        End Get
        Set(value As Int32)
            ViewState("Marca") = value
        End Set
    End Property
    Private Property EstatusCobro() As String
        Get
            Return ViewState("StatusCobro")
        End Get
        Set(ByVal value As String)
            ViewState("StatusCobro") = value
        End Set
    End Property
    Private Property RegPat() As Nullable(Of Integer)
        Get
            Return ViewState("RegistroPatronal")
        End Get
        Set(ByVal value As Nullable(Of Integer))
            ViewState("RegistroPatronal") = value
        End Set
    End Property
    Private Property Oficio() As String
        Get
            Return ViewState("Oficio")
        End Get
        Set(ByVal value As String)
            ViewState("Oficio") = value
        End Set
    End Property

    Public idDocumentacion As Boolean = True

    'Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load
    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        ddlCantidadDocumentos.Attributes.Add("onChange", "ChangeDropDown()")
        If Not IsPostBack Then

            'BindPrimerGrid()
            'BindSegundoGrid()

            Me.iniForm()

            'Cargando dropdown de años
            Me.ddAnioPeriodo.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Seleccione un Año --", "-1"))
            For i As Integer = 2003 To Now.Date.Year

                Me.ddAnioPeriodo.Items.Add(New System.Web.UI.WebControls.ListItem(i.ToString, i.ToString))

            Next
            'Me.ddAnioPeriodo.AutoPostBack = True

            'Cargando dropdown de Periodos
            Me.ddAnioPeriodo2.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Seleccione un Año --", "-1"))
            For i As Integer = 2003 To Now.Date.Year

                Me.ddAnioPeriodo2.Items.Add(New System.Web.UI.WebControls.ListItem(i.ToString, i.ToString))

            Next
            'Me.ddAnioPeriodo.AutoPostBack = True


            'Cargando paneles
            Me.pnlForm.Visible = True
            Me.pnlRecibo.Visible = False
        Else
            If Not ddlCantidadDocumentos.SelectedValue = "" Then

                For i = 1 To Convert.ToInt32(ddlCantidadDocumentos.SelectedValue)
                    Dim mylabel = New Label
                    Dim MyTextBox As New TextBox
                    MyTextBox.ID = "txtDocumento" + i.ToString()
                    MyTextBox.CssClass = "sizeText"
                    MyTextBox.AutoPostBack = True
                    MyTextBox.MaxLength = 11
                    MyTextBox.Text = ""

                    AddHandler MyTextBox.TextChanged, AddressOf Text_TextChanged

                    tdDocumentos.Controls.Add(MyTextBox)
                    tdDocumentos.Controls.Add(New LiteralControl("</br>"))

                    mylabel.ID = "lbDocumentoInfo" + i.ToString()
                    mylabel.CssClass = "sizeText"
                    tdInformacionDocumento.Controls.Add(mylabel)
                    tdInformacionDocumento.Controls.Add(New LiteralControl("</br>"))

                Next


            End If

            If Not ddlCantidadAdjunto.SelectedValue = "" Then
                For i = 1 To Convert.ToInt32(ddlCantidadAdjunto.SelectedValue)
                    Dim InformacionAdjunta = New FileUpload
                    InformacionAdjunta.ID = "FileUp" + i.ToString()
                    InformacionAdjunta.Attributes.Add("onchange", "UploadValidate()")
                    tdCantidadAdjunto.Controls.Add(InformacionAdjunta)


                Next
            End If

        End If

        Me.lblMsg.Text = ""
        pageNum = 1
        PageSize = BasePage.PageSize
        Page.Form.Attributes.Add("enctype", "multipart/form-data")
    End Sub

    Private Sub iniForm()

        Me.pnlForm.Visible = True
        Me.trEmpleador.Visible = False
        Me.pnlFechas.Visible = False
        Me.pnlPeriodos.Visible = False
        Me.pnlRecibo.Visible = False
        Me.pnlMotivo.Visible = False
        Me.pnlRepresentantes.Visible = False
        Me.pnlNotificacionPago.Visible = False
        Me.tr_sector_salarial.Visible = False
        Me.PnlDocumentos.Visible = False
        Me.pnlDocumentacionAdjunta.Visible = False
        Me.pnlCargaArchivo.Visible = False
        Me.pnlCancelacionNSS.Visible = False
        Me.pnlMostrarNSS.Visible = False

        'Limpiando campos
        Dim oficioconf As New SuirPlus.Config.Configuracion(SuirPlus.Config.ModuloEnum.Oficios)

        Me.lblDestinatario.Text = oficioconf.Field1
        Me.lblRemitente.Text = Me.UsrNombreCompleto
        Me.txtRncCedula.Text = ""
        Me.txtRncCedula.ReadOnly = False
        Me.ddMesPeriodo.SelectedIndex = 0
        Me.ddAnioPeriodo.SelectedIndex = 0
        Me.ddAcciones.Enabled = True
        txtObservacion.Text = String.Empty
        Me.lblMsg.Text = ""

        'Cargando DropDown de Acciones
        Me.ddAcciones.DataValueField = "ID_ACCION"
        Me.ddAcciones.DataTextField = "ACCION_DES"

        Me.ddAcciones.DataSource = SuirPlus.Empresas.Oficio.getAcciones(-1)

        Me.ddAcciones.DataBind()
        Me.ddAcciones.Items.Insert(0, New ListItem(" -- Seleccione una acción -- ", "-1"))
        ' Ocultando filas de rangos de fechas

        'Cargando DropDown de los Sectores Salariales
        Me.ddSector_Salarial.DataValueField = "ID"
        Me.ddSector_Salarial.DataTextField = "DESCRIPCION"

        Me.ddSector_Salarial.DataSource = SuirPlus.Mantenimientos.SectoresSalariales.getSectoresSalariales()

        Me.ddSector_Salarial.DataBind()

        'Cargando DropDown oculto de seleccion de notificacion
        Me.ddSeleccion.DataTextField = "SELECCIONA_NOTIFICACIONES"
        Me.ddSeleccion.DataSource = SuirPlus.Empresas.Oficio.getAcciones(-1)
        Me.ddSeleccion.DataBind()
        Me.ddSeleccion.Items.Insert(0, New ListItem(" -- ", "-1"))

        'Limpiando motivos
        Me.rbMotivos.DataSource = Nothing
        Me.rbMotivos.DataBind()

        'Limpiando notificaciones
        Me.dlNotificaciones.DataSource = Nothing
        Me.dlNotificaciones.DataBind()
        'Resetear valores del dropDown de Periodos Años 
        ' Me.ddAnioPeriodo2.Items.Clear()

        'resetear valores de los documentos
        LimpiarObjetos()

    End Sub

    Private Sub ddAcciones_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ddAcciones.SelectedIndexChanged

        '***********************************************************
        Me.trEmpleador.Visible = True
        Me.txtRncCedula.Text = String.Empty
        Me.tr_sector_salarial.Visible = False
        Me.trPaginacion.Visible = False
        Me.trTodos.Visible = False
        ClearCancelacionNSS()

        gvRepresentantes.DataSource = Nothing
        gvRepresentantes.DataBind()

        Me.pnlMostrarNSS.Visible = False

        ' Me.trCiudadano.Visible = (Not Me.trEmpleador.Visible)
        '*************************************************************
        cargarMotivos()

        Select Case Me.ddAcciones.SelectedValue
            Case 1
                Me.pnlFechas.Visible = True
                PnlDocumentos.Visible = False
                pnlDocumentacionAdjunta.Visible = False
                Me.pnlPeriodos.Visible = False
                Me.pnlCancelacionNSS.Visible = False
                pnlCargaArchivo.Visible = False
            Case 9
                Me.pnlPeriodos.Visible = True
                Me.pnlFechas.Visible = False
                pnlDocumentacionAdjunta.Visible = True
                PnlDocumentos.Visible = True
                GenerarObjetos()
                Me.pnlCancelacionNSS.Visible = False
                pnlCargaArchivo.Visible = False
            Case 10

                Me.pnlPeriodos.Visible = True
                Me.pnlFechas.Visible = False
                PnlDocumentos.Visible = False
                pnlDocumentacionAdjunta.Visible = True

                GenerarObjetos()
                Me.pnlCancelacionNSS.Visible = False
                pnlCargaArchivo.Visible = False
            Case 11

                Me.pnlPeriodos.Visible = False
                Me.pnlFechas.Visible = False
                PnlDocumentos.Visible = False
                pnlDocumentacionAdjunta.Visible = True
                pnlRepresentantes.Visible = True
                GenerarObjetos()
                Me.pnlCancelacionNSS.Visible = False
                pnlCargaArchivo.Visible = False
            Case 12

                Me.pnlPeriodos.Visible = True
                Me.pnlCancelacionNSS.Visible = True
                Me.pnlFechas.Visible = False
                PnlDocumentos.Visible = False
                pnlDocumentacionAdjunta.Visible = True
                GenerarObjetos()
                pnlCargaArchivo.Visible = False
            Case 13
                pnlCargaArchivo.Visible = True
                Me.pnlPeriodos.Visible = False
                Me.pnlCancelacionNSS.Visible = False
                Me.pnlFechas.Visible = False
                PnlDocumentos.Visible = False
                pnlDocumentacionAdjunta.Visible = True
                GenerarObjetos()

            Case 14
                pnlCargaArchivo.Visible = False
                Me.pnlPeriodos.Visible = False
                Me.pnlCancelacionNSS.Visible = False
                Me.pnlFechas.Visible = False
                PnlDocumentos.Visible = False
                pnlDocumentacionAdjunta.Visible = True
                GenerarObjetos()

            Case 15
                pnlCargaArchivo.Visible = False
                Me.pnlPeriodos.Visible = False
                Me.pnlCancelacionNSS.Visible = False
                Me.pnlFechas.Visible = False
                PnlDocumentos.Visible = False
                pnlDocumentacionAdjunta.Visible = True
                GenerarObjetos()

            Case Else
                pnlCargaArchivo.Visible = False
                Me.pnlFechas.Visible = False
                Me.pnlPeriodos.Visible = False
                pnlDocumentacionAdjunta.Visible = False
                PnlDocumentos.Visible = False
                Me.pnlCancelacionNSS.Visible = False

        End Select

    End Sub

    Private Sub cargarMotivos()

        If Me.ddAcciones.SelectedValue <> "-1" Then

            'Cargando DataList de Motivos
            Me.rbMotivos.DataSource = SuirPlus.Empresas.Oficio.getMotivos(Me.ddAcciones.SelectedValue)
            Me.pnlMotivo.Visible = True
            Me.rbMotivos.DataBind()

            'LlenarNotificaciones()

        Else
            Me.rbMotivos.DataSource = Nothing
            Me.rbMotivos.DataBind()
            Me.pnlMotivo.Visible = False
        End If

    End Sub

    Private Function getTipoSeleccion() As Boolean

        Return (Me.ddSeleccion.Items(Me.ddAcciones.SelectedIndex).Text = "S")

    End Function

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        btnAceptar.Enabled = True
        LimpiarObjetos()
        Me.iniForm()

    End Sub

    Private Sub dlNotificaciones_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataListItemEventArgs) Handles dlNotificaciones.ItemDataBound

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            If getTipoSeleccion() Then
                CType(e.Item.FindControl("chkMarcado"), CheckBox).Checked = True
                CType(e.Item.FindControl("chkMarcado"), CheckBox).Enabled = False
            End If
        End If

    End Sub

    Private Sub btnAceptar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        If SuirPlus_Status = "REDUCIDO" Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = SuirPlusREDUCIDO
            Exit Sub
        End If

        btnAceptar.Enabled = False

        Dim periodo As Integer = 0
        Dim documentos(10) As String
        Dim resultado As String = ""
        Dim ErrorArchivo As String =""

        If idDocumentacion = False Then
            Return
        End If


        'Validando la seleccion de un motivo
        If Me.ddAcciones.SelectedValue = "-1" Then
            lblMsg.ForeColor = System.Drawing.Color.Red
            Me.lblMsg.Text = "Debe seleccionar una acción."
            btnAceptar.Enabled = True
            Return

        End If

        'Validamos que se haya digitado un NSS o un RNC
        If String.IsNullOrEmpty(Me.txtRncCedula.Text) Then
            Me.lblMsg.Text = "Debes digitar el RNC o NSS para poder procesar el oficio."
            Me.txtRncCedula.Focus()
            btnAceptar.Enabled = True
            Return
        End If


        If Me.ddAcciones.SelectedValue = "9" Or Me.ddAcciones.SelectedValue = "10" Or Me.ddAcciones.SelectedValue = "12" Then
            If Me.ddMesPeriodo2.SelectedValue <> "-1" And Me.ddAnioPeriodo2.SelectedValue <> "-1" Then
                periodo = Me.ddAnioPeriodo2.SelectedValue & Me.ddMesPeriodo2.SelectedValue
            Else
                Me.lblMsg.Text = "Debe seleccionar un período valido."
                btnAceptar.Enabled = True
                Return
            End If
        End If



        'Validando la seleccion de un motivo
        If Me.rbMotivos.SelectedIndex = -1 Then
            lblMsg.ForeColor = System.Drawing.Color.Red
            Me.lblMsg.Text = "Debe seleccionar el motivo del Oficio."
            btnAceptar.Enabled = True
            Return
        End If



        If Me.ddAcciones.SelectedValue = "9" Then

            If ddlCantidadDocumentos.SelectedValue = "-1" Then
                btnAceptar.Enabled = True
                lblMsg.ForeColor = System.Drawing.Color.Red
                Me.lblMsg.Text = "Debe ingresar al menos un Nro de Documento."

                Return
            End If

            If ddlCantidadAdjunto.SelectedValue = "-1" Then
                lblMsg.ForeColor = System.Drawing.Color.Red
                lblMsg.Text = "Debe de adjuntar al menos un archivo."
                btnAceptar.Enabled = True
                Return
            End If

        End If

        If Me.ddAcciones.SelectedValue = "10" Then

            If ddlCantidadAdjunto.SelectedValue = "-1" Then
                lblMsg.ForeColor = System.Drawing.Color.Red
                lblMsg.Text = "Debe de adjuntar al menos un archivo."
                btnAceptar.Enabled = True
                Return
            End If
        End If

        If Me.ddAcciones.SelectedValue = "11" Then
            If ddlCantidadAdjunto.SelectedValue = "-1" Then
                lblMsg.ForeColor = System.Drawing.Color.Red
                lblMsg.Text = "Debe de adjuntar al menos un archivo."
                btnAceptar.Enabled = True
                Return
            End If
        End If

        If Me.ddAcciones.SelectedValue = "13" Then
            If upCargaArchivo.HasFile = False Then

                lblMsg.ForeColor = System.Drawing.Color.Red
                lblMsg.Text = "Debe de cargar el archivo para habilitar los NSS."
                btnAceptar.Enabled = True
                Return
            End If
        End If


        If ddlCantidadAdjunto.SelectedValue <> "-1" Then
            Dim c As Control
            For Each c In tdCantidadAdjunto.Controls
                If TypeOf c Is FileUpload Then
                    Dim f As FileUpload = tdCantidadAdjunto.FindControl(c.ID)
                    If f.PostedFile.ContentLength <= 0 Then
                        lblMsg.ForeColor = System.Drawing.Color.Red
                        lblMsg.Text = "No debe adjuntar archivos vacios."
                        btnAceptar.Enabled = True
                        Return
                    End If
                End If
            Next
        End If

        'Si la accion es cancelacion de recargos valida que se ingrese el periodo
        If Me.ddAcciones.SelectedValue = "1" Then
            Try
                If Me.ddMesPeriodo.SelectedValue <> "-1" And Me.ddAnioPeriodo.SelectedValue <> "-1" Then
                    periodo = Me.ddAnioPeriodo.SelectedValue & Me.ddMesPeriodo.SelectedValue

                    'Validando que la fecha seleccionada no sea mayor 
                    'quel ultimo periodo de corrida de recargos
                    Dim tmpFechaPeriodo As New Date(Integer.Parse(Me.ddAnioPeriodo.SelectedValue), Integer.Parse(Me.ddMesPeriodo.SelectedValue), 1)
                    Dim tmpCrrRecargos As Date = SuirPlus.Utilitarios.TSS.getUltimoPeriodoRegargos()
                    If tmpFechaPeriodo >= tmpCrrRecargos Then
                        Me.lblMsg.Text = "El período seleccionado no puede ser mayor que la ultima fecha de corrida de recargos (" + tmpCrrRecargos.ToString("dd/MM/yyyy") + ")."
                        Return
                    End If
                Else
                    Me.lblMsg.Text = "Debe seleccionar el período de fin del proceso."
                    Return
                End If
            Catch ex As Exception
                Me.lblMsg.Text = "Error: " & ex.ToString()
            End Try

        ElseIf Me.ddAcciones.SelectedValue = "9" Then
            Dim i = 0
            Dim c As Control
            For Each c In tdDocumentos.Controls
                If TypeOf c Is TextBox Then
                    Dim InfoText As TextBox = tdDocumentos.FindControl(c.ID)
                    documentos(i) = InfoText.Text
                    If InfoText.Text = "" Then

                        Me.lblMsg.Text = "Debe ingresar al menos un número de documento."

                        Return
                    End If
                    i = i + 1
                End If
            Next
            resultado = arrayToString(documentos)

        ElseIf Me.ddAcciones.SelectedValue = "10" Then

        ElseIf Me.ddAcciones.SelectedValue = "11" Then

            gvRepresentantes.Columns(1).Visible = True

            Dim RepresentanteNSS(CInt(gvRepresentantes.Rows.Count)) As String

            For i As Integer = 0 To gvRepresentantes.Rows.Count - 1
                If CType(gvRepresentantes.Rows(i).FindControl("chkRepresentates"), CheckBox).Checked = True Then
                    RepresentanteNSS(i) = gvRepresentantes.Rows(i).Cells(1).Text
                End If
            Next

            For Each Filas As String In RepresentanteNSS
                If Filas <> Nothing Then
                    resultado = arrayToString(RepresentanteNSS)
                End If
            Next

            If resultado = String.Empty Then
                Me.lblMsg.Text = "Debe seleccionar al menos un Representante."
                Return
            End If
            gvRepresentantes.Columns(1).Visible = False

        ElseIf Me.ddAcciones.SelectedValue = "12" Then
            Dim CancelaNSS(CInt(gvSeleccion.Rows.Count)) As String

            For i As Integer = 0 To gvSeleccion.Rows.Count - 1
                CancelaNSS(i) = gvSeleccion.Rows(i).Cells(0).Text
            Next

            For Each Filas As String In CancelaNSS
                If Filas <> Nothing Then
                    resultado = arrayToString(CancelaNSS)
                End If
            Next

            If Marca <> 1 And resultado = String.Empty Then
                Me.lblMsg.Text = "Debe seleccionar al menos un empleado."
                btnAceptar.Enabled = True
                Return
            End If
        ElseIf Me.ddAcciones.SelectedValue = "13" Then
            'resultado = SuirPlus.Empresas.Archivo.ProcesarArchivoOficio(upCargaArchivo.FileName, upCargaArchivo.PostedFile.InputStream, GetIPAddress()).Replace(".txt", "")
            resultado = SuirPlus.Empresas.Archivo.ProcesarArchivoOficio(upCargaArchivo.FileName, upCargaArchivo.PostedFile.InputStream, GetIPAddress())
            ErrorArchivo = resultado

            While ErrorArchivo.IndexOf(".") <> -1
                ErrorArchivo = ErrorArchivo.Substring(ErrorArchivo.IndexOf(".") + 1)
            End While

        End If


        'Que no sea cancelación de acogencia a la ley 189-07, acuerdos de pago o cancelacion de NSS, estos oficios no trabajan con notificaciones
        If ("3,4,5,6,8,9,10,11,12,13,14,15").IndexOfAny(Me.ddAcciones.SelectedValue) = -1 Then


            'Validando que seleccionen al menos una notificacion
            Dim seleccionNot As Integer
            For Each i As System.Web.UI.WebControls.DataListItem In Me.dlNotificaciones.Items

                If CType(i.FindControl("chkMarcado"), CheckBox).Checked Then
                    seleccionNot = 1
                    Me.dlNotificaciones.SelectedIndex = i.ItemIndex

                    'Validando que si la accion es de cancelacion de recargo
                    'no permita la seleccion de notificacion que tengan recargo 0.00 ni que el tipo de factura sea "L"
                    If Me.ddAcciones.SelectedValue = "1" Then
                        If Double.Parse(CType(i.FindControl("lblRecargo"), Label).Text.Trim) = 0.0 Then
                            'Que tenga recargo
                            seleccionNot = 2
                            Exit For
                        ElseIf CType(i.FindControl("lblTipoFactura"), Label).Text = "Y" Then
                            'Que no sea tipo "L"
                            seleccionNot = 3
                            Exit For
                        End If
                    End If
                End If

            Next

            'Si no marcaron ninguna notificacion
            If seleccionNot = 0 Then

                Me.lblMsg.Text = "Debe seleccionar al Menos una Referencia de Pago."

                Return

                'Si es una cancelacion de recargos y la notifiacion no tiene recargo
            ElseIf seleccionNot = 2 Then

                Me.lblMsg.Text = "La Referencia de Pago Seleccionada no Tiene Recargos para Cancelar."

                Return

                'Si es una cancelacion de recargos y la notifiacion es tipo "L"
            ElseIf seleccionNot = 3 Then

                Me.lblMsg.Text = "Esta Referencia forma parte de un acuerdo de pago, no se puede modificar."

                Return
            End If
        End If

        'Insertando oficio
        Dim ret As String = SuirPlus.Empresas.Oficio.insertaOficio(Me.ddAcciones.SelectedValue, Me.rbMotivos.SelectedValue, Me.txtRncCedula.Text, Me.UsrUserName, Me.lblDestinatario.Text, Me.txtObservacion.Text, periodo, resultado, Convert.ToInt32(ddSector_Salarial.SelectedValue), "", ddlNominas.SelectedValue, Marca)

        If Split(ret, "|")(0) = "0" Then

            'Si la accion amerita insertar detalle
            If Not Me.getTipoSeleccion Then
                If Not ddAcciones.SelectedValue = "9" And Not ddAcciones.SelectedValue = "11" Then

                    'Insertando detalle
                    For Each i As System.Web.UI.WebControls.DataListItem In Me.dlNotificaciones.Items

                        If CType(i.FindControl("chkMarcado"), CheckBox).Checked Then
                            SuirPlus.Empresas.Oficio.insertaDetOficio(Split(ret, "|")(1), CType(i.FindControl("lblNotificacion"), Label).Text, CType(i.FindControl("lblMonto"), Label).Text, CType(i.FindControl("lblRecargo"), Label).Text, String.Empty)
                        End If

                    Next
                End If
            End If

            'Mostrando resultado final
            Me.pnlRecibo.Visible = True
            Me.pnlForm.Visible = False
            Oficio = Split(ret, "|")(1)
            Me.lblOficioNo.Text = Oficio


            'Insertando la Documentacion
            Dim c As Control
            For Each c In tdCantidadAdjunto.Controls
                If TypeOf c Is FileUpload Then
                    UploadDocumentacion(c)
                End If
            Next


            Me.lblRncCedula.Text = Me.txtRncCedula.Text
            Me.lblAccion.Text = Me.ddAcciones.SelectedItem.Text
            Me.lblGeneradoPor.Text = Me.UsrNombreCompleto
            Me.hlVerDocumento.NavigateUrl = "javascript:modelesswin('oficioDoc.aspx?codOficio=" + Split(ret, "|")(1) + "')"
            Me.ClientScript.RegisterStartupScript(Me.GetType, "", "<script language javascript>modelesswin('oficioDoc.aspx?codOficio=" + Split(ret, "|")(1) + "')</script>")

        Else
            If ddAcciones.SelectedValue = "13" And Split(ret, "|")(0) = "-1" Then
                pnlMostrarNSS.Visible = False
                If ret.Contains("ORA-06502") Then
                    Me.lblMsg.Text = "Archivo contiene error de estructura"
                    SuirPlus.Empresas.Oficio.MarcarArchivoConError(ErrorArchivo)
                    btnAceptar.Enabled = True
                    Return
                Else
                    Dim index = Split(ret, "||")(1).Replace("|", ",").Length
                    Dim arreglo = Split(ret, "||")(1).Replace("|", ",").Substring(0, index - 1).Split(",")

                    If index > 20 Then
                        pnlMostrarNSS.Visible = True
                        btnAceptar.Enabled = True
                        For Each item In arreglo
                            lstNSS.Items.Add(item)
                        Next
                        Return
                    Else
                        SuirPlus.Empresas.Oficio.MarcarArchivoConError(ErrorArchivo)
                        Me.lblMsg.Text = "Archivo con errores, los siguientes NSS no están cancelados o no existen " & Split(ret, "||")(1).Replace("|", ",").Substring(0, index - 1)
                        btnAceptar.Enabled = True
                        Return
                    End If
                End If


            Else
                Me.lblMsg.Text = Split(ret, "|")(1)
                btnAceptar.Enabled = True
                Return
            End If

        End If




    End Sub

    Private Sub lnkbtnNuevo_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lnkbtnNuevo.Click
        Me.iniForm()
    End Sub

    Protected Sub txtRncCedula_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtRncCedula.TextChanged
        'Buscando el empleador o el ciudadano
        Try
            Me.btnAceptar.Enabled = True
            Me.tr_sector_salarial.Visible = False

            'Limpiando el GRID
            gvRepresentantes.DataSource = Nothing
            gvRepresentantes.DataBind()


            Dim tmpEmp As New SuirPlus.Empresas.Empleador(Me.txtRncCedula.Text)

            ' Empleador no existe
            If tmpEmp.RazonSocial = String.Empty Then
                Me.lblMsg.Text = "RNC o Cédula del empleador inválido"
                Me.txtRncCedula.Text = String.Empty
                Me.txtRncCedula.Focus()
                Me.EstatusCobro = String.Empty
                Me.RegPat = Nothing
                'Limpiando el GRID
                gvRepresentantes.DataSource = Nothing
                gvRepresentantes.DataBind()

            Else


                Me.EstatusCobro = tmpEmp.StatusCobro
                Me.RegPat = tmpEmp.RegistroPatronal

                'Empleador en Estatus de Cobro no permitirle la Baja
                If Me.EstatusCobro = "L" And Me.ddAcciones.SelectedIndex = 2 Then
                    If Not tmpEmp.Estatus = "A" Then
                        btnAceptar.Enabled = False
                        Me.lblMsg.Text = "Este empleador no debe estar suspendido."
                        Return
                    End If

                    tmpEmp = Nothing
                    Me.lblMsg.Text = "No se puede dar de baja a este Empleador, verifique el estatus del mismo."
                    Me.txtRncCedula.Text = String.Empty
                    Me.txtRncCedula.Focus()
                    Me.btnAceptar.Enabled = False
                    Exit Sub
                ElseIf Me.ddAcciones.SelectedValue = 4 Then


                    If Not tmpEmp.Estatus = "A" Then
                        btnAceptar.Enabled = False
                        Me.lblMsg.Text = "Este empleador no debe estar suspendido."
                        Return
                    End If

                    'Validamos que tenga una acogencia a la ley de facilidades de pago 189-07 con estatus activa
                    tmpEmp = Nothing
                    If SuirPlus.Legal.LeyFacilidadesPago.getSolicitudFacilidadesPago(Nothing, Me.RegPat, Nothing, Nothing, Nothing, "A").Rows.Count <= 0 Then
                        Me.lblMsg.Text = "Este empleador no ha solicitado acogerse a la ley de facilidades de pago 189-07."
                        Me.txtRncCedula.Text = String.Empty
                        Me.txtRncCedula.Focus()
                        Me.btnAceptar.Enabled = False
                        Exit Sub
                        'Validamos que no tenga un acuerdo de pago vigente
                    ElseIf SuirPlus.Legal.AcuerdosDePago.getAcuerdosPago(Me.RegPat, Nothing).Rows.Count > 0 Then
                        Me.lblMsg.Text = "Este empleador tiene un acuerdo de pago vigente."
                        Me.txtRncCedula.Text = String.Empty
                        Me.txtRncCedula.Focus()
                        Me.btnAceptar.Enabled = False
                        Exit Sub
                    End If
                ElseIf Me.ddAcciones.SelectedValue = 5 Then
                    If Not tmpEmp.Estatus = "A" Then
                        btnAceptar.Enabled = False
                        Me.lblMsg.Text = "Este empleador no debe estar suspendido."
                        Return
                    End If

                    'Validamos que tenga un acuerdo de pago vigente
                    tmpEmp = Nothing
                    If SuirPlus.Legal.AcuerdosDePago.getAcuerdosPago(Me.RegPat, Nothing).Rows.Count <= 0 Then
                        Me.lblMsg.Text = "Este empleador no tiene acuerdo de vigente."
                        Me.txtRncCedula.Text = String.Empty
                        Me.txtRncCedula.Focus()
                        Me.btnAceptar.Enabled = False
                        Exit Sub
                    End If
                ElseIf Me.ddAcciones.SelectedValue = 6 Then
                    If Not tmpEmp.Estatus = "A" Then
                        btnAceptar.Enabled = False
                        Me.lblMsg.Text = "Este empleador no debe estar suspendido."
                        Return
                    End If

                    'Validamos que tenga un acuerdo de pago ordinario vigente
                    tmpEmp = Nothing
                    If SuirPlus.Legal.AcuerdosDePago.getAcuerdosPago(Me.RegPat, Nothing).Rows.Count <= 0 Then
                        Me.lblMsg.Text = "Este empleador no tiene acuerdo de pago vigente."
                        Me.txtRncCedula.Text = String.Empty
                        Me.txtRncCedula.Focus()
                        Me.btnAceptar.Enabled = False
                        Return
                    End If
                ElseIf Me.ddAcciones.SelectedValue = 8 Then
                    If tmpEmp.Estatus = "S" Then
                        btnAceptar.Enabled = False
                        Me.lblMsg.Text = "Este empleador no debe estar suspendido."
                        Return
                    ElseIf tmpEmp.Estatus = "A" Then
                        btnAceptar.Enabled = False
                        Me.lblMsg.Text = "Este empleador no debe estar activo."
                        Return
                    End If

                    'Esto es solo para oficios de Alta de empleadores
                    If tmpEmp.CodSector = -1 Then
                        ddSector_Salarial.SelectedIndex = 0
                    Else
                        ddSector_Salarial.SelectedValue = Convert.ToString(tmpEmp.CodSector)
                    End If
                    Me.tr_sector_salarial.Visible = True

                    tmpEmp = Nothing

                ElseIf Me.ddAcciones.SelectedValue = 9 Then
                    If Not tmpEmp.Estatus = "A" Then
                        btnAceptar.Enabled = False
                        Me.lblMsg.Text = "Este empleador no debe estar suspendido."
                        Return
                    End If
                ElseIf Me.ddAcciones.SelectedValue = 10 Then
                    If Not tmpEmp.Estatus = "A" Then
                        btnAceptar.Enabled = False
                        Me.lblMsg.Text = "Este empleador no debe estar suspendido."
                        Return
                    End If
                ElseIf Me.ddAcciones.SelectedValue = 11 Then
                    If tmpEmp.Estatus = "S" Then
                        pnlRepresentantes.Visible = True
                        Dim getRepresentantesActivos = SuirPlus.Empresas.Representante.getRepresentanteLista(tmpEmp.RegistroPatronal)
                        If getRepresentantesActivos.Rows.Count > 0 Then
                            gvRepresentantes.DataSource = getRepresentantesActivos
                            gvRepresentantes.DataBind()
                            gvRepresentantes.Columns(1).Visible = False

                        End If
                    Else
                        Me.lblMsg.Text = "El empleador debe estar con estatus suspendido para proceder."
                        btnAceptar.Enabled = False
                        Return
                    End If
                ElseIf Me.ddAcciones.SelectedValue = 12 Then
                    ClearCancelacionNSS()
                    CargarDropCancelacionNSS(txtRncCedula.Text)
                    pnlCancelacionNSS.Visible = True

                ElseIf Me.ddAcciones.SelectedValue = 14 Then
                    If Me.EstatusCobro = 0 Then
                        Me.lblMsg.Text = "Este empleador puede realizar envió de novedades retroactivas."
                        btnAceptar.Enabled = False
                        Return
                    End If

                End If

                If Me.ddAcciones.SelectedValue <> 9 And Me.ddAcciones.SelectedValue <> 10 And Me.ddAcciones.SelectedValue <> 11 And Me.ddAcciones.SelectedValue <> 12 Then
                    LlenarNotificaciones()
                End If

            End If
        Catch ex As Exception
            Me.lblMsg.Text = "RNC o Cédula del empleador inválido"
            Me.txtRncCedula.Text = String.Empty
            Me.txtRncCedula.Focus()
            Me.btnAceptar.Enabled = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString)
        End Try
    End Sub


    Private Sub LlenarNotificaciones()
        Dim dv As DataView
        Dim dt As New DataTable

        Me.pnlNotificacionPago.Visible = False
        Me.dlNotificaciones.DataSource = Nothing
        Me.dlNotificaciones.DataBind()

        Try
            'Cargamos nuestro datatable
            dt = SuirPlus.Empresas.Oficio.getFacturas(Me.txtRncCedula.Text)

            'Cargamos el dataview con el datatable
            dv = New DataView(dt)

            'Si es tipo 7 solo cargamos los tipo de facturas de auditoria
            If Me.ddAcciones.SelectedValue = 7 Then
                dv.RowFilter = "id_tipo_factura = 'U'"
                PnlDocumentos.Visible = False
                pnlDocumentacionAdjunta.Visible = False
            End If

            If Me.ddAcciones.SelectedValue = 9 Then
                GenerarObjetos()
                PnlDocumentos.Visible = True
                pnlDocumentacionAdjunta.Visible = True
            End If

            If Me.ddAcciones.SelectedValue = 10 Then
                GenerarObjetos()
                PnlDocumentos.Visible = False
                pnlFechas.Visible = False
                pnlDocumentacionAdjunta.Visible = True

            End If
            If Me.ddAcciones.SelectedValue = 11 Then
                GenerarObjetos()
                PnlDocumentos.Visible = False
                pnlDocumentacionAdjunta.Visible = True

            End If

            Me.dlNotificaciones.DataSource = dv
            Me.dlNotificaciones.DataBind()


            If Me.ddAcciones.SelectedValue >= 1 And Me.ddAcciones.SelectedValue < 3 Or Me.ddAcciones.SelectedValue = 7 Then
                Me.pnlNotificacionPago.Visible = True
                PnlDocumentos.Visible = False
                pnlDocumentacionAdjunta.Visible = False
            End If

            Me.btnAceptar.Enabled = True

        Catch ex As Exception

            Me.lblMsg.Text = Split(ex.Message, "|")(1)
            Me.pnlMotivo.Visible = False
            Me.pnlNotificacionPago.Visible = False
            pnlDocumentacionAdjunta.Visible = False

            Me.btnAceptar.Enabled = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub
    'Procedimiento para generar las cantidades en los dropdowns
    Sub GenerarObjetos()

        LimpiarObjetos()

        For index = 1 To 10
            ddlCantidadDocumentos.Items.Add(index)
        Next
        For index = 1 To 10
            ddlCantidadAdjunto.Items.Add(index)
        Next

        ddlCantidadDocumentos.Items.Insert(0, New ListItem("Seleccione una cantidad", "-1"))
        ddlCantidadAdjunto.Items.Insert(0, New ListItem("Seleccione una cantidad", "-1"))

        ddlCantidadDocumentos.SelectedValue = "-1"
        ddlCantidadAdjunto.SelectedValue = "-1"

    End Sub
    'Procedimiento para limpiar los valores de los dropdowns
    Sub LimpiarObjetos()
        ddlCantidadAdjunto.Items.Clear()
        ddlCantidadDocumentos.Items.Clear()
        Me.ddMesPeriodo2.SelectedValue = "-1"
        Me.ddAnioPeriodo2.SelectedValue = "-1"
        txtObservacion.Text = String.Empty
        lstNSS.Items.Clear()

    End Sub
    'Procedimiento para la carga de documentacion
    Public Sub UploadDocumentacion(Archivo As FileUpload)

        Try
            If Archivo.HasFile Then

                'Lectura del Archivo
                Dim Ruta As String = Archivo.PostedFile.FileName
                Dim NombreArchivo As String = Path.GetFileName(Ruta)
                Dim Extension As String = Path.GetExtension(NombreArchivo)
                Dim ContentType As String = String.Empty


                'Listado de Archivos
                Select Case Extension.ToLower()

                    Case ".doc"
                        ContentType = "application/vnd.ms-word"
                        Exit Select
                    Case ".docx"
                        ContentType = "application/vnd.ms-word"
                        Exit Select
                    Case ".xls"
                        ContentType = "application/vnd.ms-excel"
                        Exit Select
                    Case ".xlsx"
                        ContentType = "application/vnd.ms-excel"
                        Exit Select
                    Case ".jpg"
                        ContentType = "image/jpg"
                        Exit Select
                    Case ".png"
                        ContentType = "image/png"
                        Exit Select
                    Case ".gif"
                        ContentType = "image/gif"
                        Exit Select
                    Case ".tiff"
                        ContentType = "image/tiff"
                        Exit Select
                    Case ".tif"
                        ContentType = "image/tif"
                        Exit Select
                    Case ".pdf"
                        ContentType = "application/pdf"
                        Exit Select
                End Select


                Dim fs As Stream = Archivo.PostedFile.InputStream
                Dim br As New BinaryReader(fs)
                Dim bytes As Byte() = br.ReadBytes(fs.Length)

                'Carga de archivo
                If SuirPlus.Empresas.Oficio.CargarDocumentacion(Oficio, bytes, NombreArchivo, ContentType) <> "OK" Then
                    lblMsg.Text = SuirPlus.Empresas.Oficio.CargarDocumentacion(Oficio, bytes, NombreArchivo, ContentType).ToString()
                End If


                lblMsg.ForeColor = System.Drawing.Color.Green
                lblMsg.Text = "Carga de archivo completada"

            End If

        Catch ex As Exception
            Throw ex
        End Try



    End Sub
    'Procedimiento  para realizar la union de los Nro.Documentos.
    Public Function arrayToString(StringArray() As String)
        Dim str As String = "|"
        Dim Resultado As String = String.Empty
        For i As Integer = 0 To StringArray.Length - 1
            If StringArray(i) <> Nothing Then
                Resultado = Resultado + str + StringArray(i)
            End If
        Next

        If Resultado = Nothing Then
            lblMsg.ForeColor = System.Drawing.Color.Red
            lblMsg.Text = "Nro. de Documentos vacios."
        Else
            Resultado = Resultado.TrimStart("|")
            Resultado = Resultado.TrimEnd("|")
        End If

        Return Resultado

    End Function
    'Eventos de los Textbox
    Private Sub Text_TextChanged(sender As Object, e As System.EventArgs)
        'Dim txtBoxSender As TextBox = DirectCast(sender, TextBox)

        Dim Repetido As Boolean = False
        Dim Retorno As Boolean = False



        Dim c As Control
        For Each c In tdDocumentos.Controls()
            If TypeOf c Is TextBox Then

                Dim txtBoxSender As TextBox = tdDocumentos.FindControl(c.ID)
                Dim strTextBoxID As String = txtBoxSender.ID

                If strTextBoxID.Substring(0, 12) = "txtDocumento" Then
                    Dim tx As TextBox = tdDocumentos.FindControl(strTextBoxID)
                    Dim lb1 As Label = tdDocumentos.FindControl("lbDocumentoInfo" + strTextBoxID.Replace("txtDocumento", ""))

                    If tx.Text = String.Empty Then
                        lb1.Text = ""
                        Retorno = True

                    ElseIf ValidarCedulasRepetidas(txtBoxSender, tx) = True Then
                        lb1.Text = "Numero de documento no debe repetirse"
                        lb1.CssClass = "error"
                        Retorno = True

                    Else
                        Dim Resultado = SuirPlus.Utilitarios.TSS.getNombreEmpleado(txtRncCedula.Text, txtBoxSender.Text).ToString().Split("|")
                        If Resultado(0) <> "0" Then
                            lb1.Text = Resultado(1)
                            lb1.CssClass = "error"
                            Retorno = True
                        Else
                            lb1.Text = Resultado(1)
                            lb1.CssClass = "Label-Blue"

                        End If
                    End If

                End If

            End If
        Next

        If Retorno = True Then
            btnAceptar.Enabled = False

        Else
            btnAceptar.Enabled = True

        End If



    End Sub


    Private Function GetFileSize(byteCount As Double) As Boolean
        Dim size As String = "0 Bytes"
        If byteCount >= 3072000.0 Then
            size = String.Format("{0:##.##}", byteCount / 1048576.0) & " MB"
            lblMsg.ForeColor = System.Drawing.Color.Red
            lblMsg.Text = "El tamaño de archivo no puede superar un 3MB, su archivo es " + size
            Return True
        Else
            Return False
        End If
    End Function

    Private Function ValidarCedulasRepetidas(cedula1 As TextBox, cedula2 As TextBox) As Boolean
        Dim Comparador1 As TextBox = tdDocumentos.FindControl(cedula1.ID)
        'Validando Cedulas
        Dim c As Control
        For Each c In tdDocumentos.Controls()
            If TypeOf c Is TextBox Then
                cedula2 = tdDocumentos.FindControl(c.ID)
                If Comparador1.Text = cedula2.Text And Comparador1.ID <> cedula2.ID Then
                    Return True
                End If
            End If
        Next

        Return False
    End Function

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

        BindPrimerGrid()


    End Sub

    Private Sub BindPrimerGrid()
        Dim Info = SuirPlus.Empresas.Oficio.getEmpleadosActivos(txtRncCedula.Text, ddlNominas.SelectedValue, pageNum, PageSize)
        gvCancelacionNSS.DataSource = Info
        gvCancelacionNSS.DataBind()

        If Info.Rows.Count > 0 Then
            lblTotalRegistros.Text = Info.Rows(0)("RECORDCOUNT")
            trPaginacion.Visible = True
            trTodos.Visible = True
            setNavigation()
        End If
    End Sub

    Private Sub GetData()
        Dim dt As DataTable
        If ViewState("SelectedRecords") IsNot Nothing Then
            dt = DirectCast(ViewState("SelectedRecords"), DataTable)
        Else
            dt = CreateDataTable()
        End If
        Dim chkAll As CheckBox = DirectCast(gvCancelacionNSS.HeaderRow.Cells(0).FindControl("chkAll"), CheckBox)
        For i As Integer = 0 To gvCancelacionNSS.Rows.Count - 1
            If chkAll.Checked Then
                dt = AddRow(gvCancelacionNSS.Rows(i), dt)
            Else
                Dim chk As CheckBox = DirectCast(gvCancelacionNSS.Rows(i) _
                                     .Cells(0).FindControl("chk"), CheckBox)
                If chk.Checked Then
                    dt = AddRow(gvCancelacionNSS.Rows(i), dt)
                Else
                    dt = RemoveRow(gvCancelacionNSS.Rows(i), dt)
                End If
            End If
        Next
        ViewState("SelectedRecords") = dt
    End Sub

    Private Function CreateDataTable() As DataTable
        Dim dt As New DataTable()
        dt.Columns.Add("ID_NSS")
        dt.Columns.Add("NOMBRES")
        dt.Columns.Add("APELLIDOS")

        dt.AcceptChanges()
        Return dt
    End Function

    Private Function AddRow(ByVal gvRow As GridViewRow, ByVal dt As DataTable) As DataTable
        Dim dr As DataRow() = dt.Select("ID_NSS = '" _
                                        & gvRow.Cells(1).Text & "'")
        If dr.Length <= 0 Then
            dt.Rows.Add()
            dt.Rows(dt.Rows.Count - 1)("ID_NSS") = gvRow.Cells(1).Text
            dt.Rows(dt.Rows.Count - 1)("NOMBRES") = gvRow.Cells(2).Text
            dt.Rows(dt.Rows.Count - 1)("APELLIDOS") = gvRow.Cells(3).Text

            dt.AcceptChanges()
        End If
        Return dt
    End Function

    Private Function RemoveRow(ByVal gvRow As GridViewRow, ByVal dt As DataTable) As DataTable
        Dim dr As DataRow() = dt.Select("ID_NSS = '" _
                                        & gvRow.Cells(1).Text & "'")
        If dr.Length > 0 Then
            dt.Rows.Remove(dr(0))
            dt.AcceptChanges()
        End If
        Return dt
    End Function

    Protected Sub OnPaging(ByVal sender As Object, ByVal e As GridViewPageEventArgs)
        GetData()
        BindPrimerGrid()
        SetData()
    End Sub

    Protected Sub CheckBox_CheckChanged(ByVal sender As Object, ByVal e As EventArgs)
        GetData()
        BindSegundoGrid()
        SetData()
    End Sub

    Private Sub BindSegundoGrid()
        Dim dt As DataTable = DirectCast(ViewState("SelectedRecords"), DataTable)
        gvSeleccion.DataSource = dt
        gvSeleccion.DataBind()
    End Sub

    Private Sub SetData()
        Dim chkAll As CheckBox = DirectCast(gvCancelacionNSS.HeaderRow.Cells(0).FindControl("chkAll"), CheckBox)
        chkAll.Checked = True
        If ViewState("SelectedRecords") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("SelectedRecords"), DataTable)
            For i As Integer = 0 To gvCancelacionNSS.Rows.Count - 1
                Dim chk As CheckBox = DirectCast(gvCancelacionNSS.Rows(i).Cells(0).FindControl("chk"), CheckBox)
                If chk IsNot Nothing Then
                    Dim dr As DataRow() = dt.[Select]("ID_NSS = '" & gvCancelacionNSS.Rows(i).Cells(1).Text & "'")
                    chk.Checked = dr.Length > 0
                    If Not chk.Checked Then
                        chkAll.Checked = False
                    End If
                End If
            Next
        End If
    End Sub

    Private Sub CargarDropCancelacionNSS(ByVal RncCedula As String)
        ddlNominas.DataSource = SuirPlus.Empresas.Oficio.ListarNominas(RncCedula)
        ddlNominas.DataTextField = "NOMINA_DES"
        ddlNominas.DataValueField = "ID_NOMINA"
        ddlNominas.DataBind()

        ddlNominas.Items.Insert(0, New ListItem("Seleccione una cantidad", "-1"))

        ddlNominas.SelectedValue = "-1"
    End Sub

    Protected Sub ddlNominas_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlNominas.SelectedIndexChanged
        BindPrimerGrid()

    End Sub

    Sub ClearCancelacionNSS()
        ddlNominas.DataSource = ""
        ddlNominas.DataBind()
        gvCancelacionNSS.DataSource = ""
        gvCancelacionNSS.DataBind()
        gvSeleccion.DataSource = ""
        gvSeleccion.DataBind()
    End Sub

    Protected Sub chkTodos_CheckedChanged(sender As Object, e As EventArgs) Handles chkTodos.CheckedChanged
        If chkTodos.Checked = True Then
            Marca = 1
            gvCancelacionNSS.Visible = False
            gvSeleccion.Visible = False
            trPaginacion.Visible = False
        Else
            Marca = 0
            gvCancelacionNSS.Visible = True
            gvSeleccion.Visible = True
            trPaginacion.Visible = True
        End If

    End Sub

End Class
