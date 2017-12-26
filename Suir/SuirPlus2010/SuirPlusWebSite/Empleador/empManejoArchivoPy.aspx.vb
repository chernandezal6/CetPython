Imports SuirPlus
Imports SuirPlus.Empresas
Imports System.IO
Imports System.Data


Partial Class Empleador_empManejoArchivoPy
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        'Si no es la primera vez que se carga la pagina entonces escondemos algunos paneles
        If Not Page.IsPostBack Then
            llenarListaArchivo()
            Me.pnlCargaArchivo.Visible = True
            Me.pnlError.Visible = False
            Me.pnlEstatus.Visible = False

            Dim proceso As New Operaciones.Proceso("88")

            Dim dt As DataTable = proceso.Getproceso()

            If dt.Rows.Count > 0 Then
                lblMensajeProceso.Text = dt.Rows(0)("LISTA_OK")
            End If

        End If

    End Sub

    Private Sub btnEstatusCargaArchivo_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

        Me.pnlCargaArchivo.Visible = True

    End Sub

    Private Sub btnErrorCargaArchivo_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnErrorCargaArchivo.Click

        Me.pnlCargaArchivo.Visible = True
        Me.pnlError.Visible = False

    End Sub

    Private Sub llenarListaArchivo()

        Dim dt As System.Data.DataTable = SuirPlus.Empresas.ManejoArchivoPython.tipoArchivoDataSource(Me.UsrUserName)

        Me.ddlProceso.DataSource = dt
        Me.ddlProceso.DataTextField = "TipoArchivo"
        Me.ddlProceso.DataValueField = "CodigoTipoArchivo"
        Me.ddlProceso.DataBind()
        Me.ddlProceso.Items.Insert(0, New ListItem("-- Seleccionar --", "0"))

        'Validando si la empresa puede pagar MDT
        Dim oEmpresa As New SuirPlus.Empresas.Empleador(Convert.ToInt32(Me.UsrRegistroPatronal))

        If oEmpresa.PagaMDT = False Then

            If Not IsNothing(ddlProceso.Items.FindByValue("T3")) Then
                ddlProceso.Items.Remove(ddlProceso.Items.FindByValue("T3"))
            End If

            If Not IsNothing(ddlProceso.Items.FindByValue("T4")) Then
                ddlProceso.Items.Remove(ddlProceso.Items.FindByValue("T4"))
            End If

        End If


    End Sub

    Public Function getTipoArchivo(ByVal nomenclatura As String) As Archivo.SuirArchivoType

        Select Case nomenclatura

            Case "AM"
                Return ManejoArchivoPython.SuirArchivoType.AutodeterminacionMensual
            Case "AR"
                Return ManejoArchivoPython.SuirArchivoType.AutodeterminacionRetroactiva
            Case "NV"
                Return ManejoArchivoPython.SuirArchivoType.NovedadesPeriodo
            Case "NA"
                Return ManejoArchivoPython.SuirArchivoType.NovedadesAtrasadas
            Case "RA"
                Return ManejoArchivoPython.SuirArchivoType.FacturaAuditoria
            Case "RC"
                Return ManejoArchivoPython.SuirArchivoType.CreditoFacturaAuditoria
            Case "REEP"
                Return ManejoArchivoPython.SuirArchivoType.Recaudacion
            Case "REAC"
                Return ManejoArchivoPython.SuirArchivoType.Aclaracion
            Case "CAT"
                Return ManejoArchivoPython.SuirArchivoType.CancelacionesAutorizaciones
            Case "RD"
                Return ManejoArchivoPython.SuirArchivoType.DependientesAdicionales
            Case "RT"
                Return ManejoArchivoPython.SuirArchivoType.Rectificativa
            Case "DF"
                Return ManejoArchivoPython.SuirArchivoType.DeclaracionFinalIR3
            Case "BO"
                Return ManejoArchivoPython.SuirArchivoType.Bonificacion
            Case "DA"
                Return ManejoArchivoPython.SuirArchivoType.DevolucionAportes
            Case "VS"
                Return ManejoArchivoPython.SuirArchivoType.ValidacionRegimenSubsidiado
            Case "T3"
                Return ManejoArchivoPython.SuirArchivoType.PlanillaDGT3
            Case "T4"
                Return ManejoArchivoPython.SuirArchivoType.PlanillaDGT4
            Case "EA"
                Return ManejoArchivoPython.SuirArchivoType.EstatusDefinitivoAuditoria
            Case "PN"
                Return ManejoArchivoPython.SuirArchivoType.NovedadesPensionados
            Case "PT"
                Return ManejoArchivoPython.SuirArchivoType.TraspasoPensionados
            Case "MO"
                Return ManejoArchivoPython.SuirArchivoType.MovimientoTrabajadores
            Case "PRE"
                Return ManejoArchivoPython.SuirArchivoType.PagoRetroactivoEnfermedadNoLaboral

        End Select

        Return String.Empty

    End Function

    ''' <summary>
    ''' Function utilizada para retornar el username del usuario logueado, si esta impersonando se envia el usuario representante de lo contrario envia el 
    ''' usuario original.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function getUsername() As String

        If UsrImpersonandoUnRepresentante Then
            Return Me.UsrImpUserName
        Else
            Return Me.UsrUserName
        End If

    End Function

    Public Function getNSS() As Integer

        Return Me.UsrNSS

    End Function

    Public Function getRNCEmpleador() As String

        Return Me.UsrRNC

    End Function

    Public Function getEmpleador() As Empresas.Empleador

        Dim emp As New Empresas.Empleador(Me.UsrRNC)
        Return emp

    End Function

    Public Function getARSUsuario() As String
        Dim usuario As New Seguridad.Usuario(Me.UsrUserName)
        usuario.Roles = New Seguridad.Autorizacion(Me.UsrUserName).getRoles().Split("|")

        'Si el usuario Pertenece a SENASA
        If usuario.IsInRole("277") Then
            Return "52"
            'Si el usuario Pertenece a SEMMA
        ElseIf usuario.IsInRole("278") Then
            Return "42"
            'Si el usuario Pertenece a ARS Salud Segura
        ElseIf usuario.IsInRole("296") Then
            Return "02"
            'Si el usuario Pertenece Secretaria de Hacienda
        ElseIf usuario.IsInRole("279") Then
            Return "98"
        End If

        Return String.Empty

    End Function

    Protected Sub lnkBtnCargarArchivo_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkBtnCargarArchivo.Click

        If SuirPlus_Status = "REDUCIDO" Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = SuirPlusREDUCIDO
            Exit Sub
        End If

        Dim data As Stream = Nothing
        Dim ArchivoPosteado As ManejoArchivoPython
        Dim fileName As String = fuArchivo.FileName 'para los casos de nombres con espacios que a phyton no le gusten(.Replace(" ", "_"))

        Try
            data = fuArchivo.PostedFile.InputStream

            If fileName = String.Empty Then
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "Debe seleccionar el archivo a cargar."
                Exit Sub
            Else
                Me.lblMsg.Visible = False
                Me.lblMsg.Text = String.Empty
            End If

            If (getTipoArchivo(Me.ddlProceso.SelectedValue.ToString) = Archivo.SuirArchivoType.NovedadesPensionados) Or (getTipoArchivo(Me.ddlProceso.SelectedValue.ToString) = Archivo.SuirArchivoType.TraspasoPensionados) Then
                ArchivoPosteado = New ManejoArchivoPython(fileName, data, getTipoArchivo(Me.ddlProceso.SelectedValue.ToString), Me.getUsername, Me.getARSUsuario, Me.GetIPAddress())
            Else
                ArchivoPosteado = New ManejoArchivoPython(fileName, data, getTipoArchivo(Me.ddlProceso.SelectedValue.ToString), Me.getUsername, getNSS, getRNCEmpleador(),UsrIDEntidadRecaudadora, GetIPAddress())
            End If
            data.Close()
            data.Dispose()

            'Utilizado para mostrar el popup
            Me.pnlEstatus.Visible = True
            Me.lblNombreArchivo.Text = ArchivoPosteado.NombreAchivo
            Me.lblNumeroArchivo.Text = ArchivoPosteado.Numero
            Me.lblFechaCarga.Text = Date.Now.ToString()
            Me.ModalPopupExtender1.Show()

        Catch ex As Exception
            data.Close()
            data.Dispose()
            Me.lblError.Text = ex.Message
            Me.pnlCargaArchivo.Visible = False
            Me.pnlError.Visible = True
            Me.pnlEstatus.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub

        End Try

    End Sub


End Class
