Imports SuirPlus
Imports SuirPlus.Empresas
Imports System.IO


Partial Class Empleador_empManejoArchivo
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load
       
        'Si no es la primera vez que se carga la pagina entonces escondemos algunos paneles
        If Not Page.IsPostBack Then
            llenarListaArchivo()
            Me.pnlCargaArchivo.Visible = True
            Me.pnlError.Visible = False
            Me.pnlEstatus.Visible = False



            If SuirPlus.Empresas.Archivo.isEmpleadorEnLegal(UsrRNC) = True Then
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = SuirPlus.Utilitarios.TSS.getErrorDescripcion("242")
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

        Dim dt As System.Data.DataTable = SuirPlus.Empresas.Archivo.tipoArchivoDataSource(Me.UsrUserName)
       
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
                Return Archivo.SuirArchivoType.AutodeterminacionMensual
            Case "AR"
                Return Archivo.SuirArchivoType.AutodeterminacionRetroactiva
            Case "NV"
                Return Archivo.SuirArchivoType.NovedadesPeriodo
            Case "NA"
                Return Archivo.SuirArchivoType.NovedadesAtrasadas
            Case "RA"
                Return Archivo.SuirArchivoType.FacturaAuditoria
            Case "RC"
                Return Archivo.SuirArchivoType.CreditoFacturaAuditoria
            Case "REEP"
                Return Archivo.SuirArchivoType.Recaudacion
            Case "REAC"
                Return Archivo.SuirArchivoType.Aclaracion
            Case "CAT"
                Return Archivo.SuirArchivoType.CancelacionesAutorizaciones
            Case "RD"
                Return Archivo.SuirArchivoType.DependientesAdicionales
            Case "RT"
                Return Archivo.SuirArchivoType.Rectificativa
            Case "DF"
                Return Archivo.SuirArchivoType.DeclaracionFinalIR3
            Case "BO"
                Return Archivo.SuirArchivoType.Bonificacion
            Case "DA"
                Return Archivo.SuirArchivoType.DevolucionAportes
            Case "VS"
                Return Archivo.SuirArchivoType.ValidacionRegimenSubsidiado
            Case "T3"
                Return Archivo.SuirArchivoType.PlanillaDGT3
            Case "T4"
                Return Archivo.SuirArchivoType.PlanillaDGT4
            Case "EA"
                Return Archivo.SuirArchivoType.EstatusDefinitivoAuditoria
            Case "MO"
                Return Archivo.SuirArchivoType.MovimientoTrabajadores
            Case "PRE"
                Return Archivo.SuirArchivoType.PagoRetroactivoEnfermedadNoLaboral
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

    'Para archivos PRE, se hace desde aqui porque es necesario el registro patronal del usuario logueado en cuestion.
    Public Function VerfificarPagaDiscapacidad() As Boolean

        Dim paga_discapacidad As String

        paga_discapacidad = SuirPlus.Empresas.Archivo.isPagaDiscapacidad(UsrRegistroPatronal)

        If paga_discapacidad = "true" Then
            Return True
        Else
            Return False
        End If
    End Function

    Protected Sub lnkBtnCargarArchivo_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkBtnCargarArchivo.Click

        If SuirPlus_Status = "REDUCIDO" Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = SuirPlusREDUCIDO
            Exit Sub
        End If


        Dim data As Stream = Nothing
        Dim ArchivoPosteado As Archivo
        Dim fileName As String = fuArchivo.FileName
        Dim TipoArchivoSel As String = Me.ddlProceso.SelectedValue.ToString


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

            If TipoArchivoSel = "PRE" Then
                If VerfificarPagaDiscapacidad() = False Then
                    Me.lblMsg.Visible = True
                    Me.lblMsg.Text = "Usuario no autorizado a enviar este archivo para la entidad especificada."
                    Exit Sub
                End If

            End If


            ArchivoPosteado = New Archivo(fileName, data, getTipoArchivo(Me.ddlProceso.SelectedValue.ToString), Me.getUsername, getNSS, getRNCEmpleador(), GetIPAddress())
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
