Imports SuirPlus
Imports SuirPlus.Empresas
Imports System.IO

Partial Class Afiliacion_ManejoArchivo
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        'Si no es la primera vez que se carga la pagina entonces escondemos algunos paneles
        If Not Page.IsPostBack Then
            llenarListaArchivo()
            Me.pnlCargaArchivo.Visible = True
            Me.pnlError.Visible = False
            Me.pnlEstatus.Visible = False
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

        Me.ddlProceso.DataSource = SuirPlus.Empresas.Archivo.tipoArchivoDataSource(Me.UsrUserName)
        Me.ddlProceso.DataTextField = "TipoArchivo"
        Me.ddlProceso.DataValueField = "CodigoTipoArchivo"
        Me.ddlProceso.DataBind()
        Me.ddlProceso.Items.Insert(0, New ListItem("-- Seleccionar --", "0"))
        Me.ddlProceso.SelectedValue = "PN"
    End Sub

    Public Function getTipoArchivo(ByVal nomenclatura As String) As Archivo.SuirArchivoType
        Dim Result As String = String.Empty

        Select Case nomenclatura

            Case "PN"
                Return Archivo.SuirArchivoType.NovedadesPensionados
            Case "PT"
                Return Archivo.SuirArchivoType.TraspasoPensionados
           
        End Select

        Return Result

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
            Return "2"
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


        Dim data As Stream
        Dim ArchivoPosteado As Archivo
        Dim fileName As String = fuArchivo.FileName

        data = fuArchivo.PostedFile.InputStream

        If fileName = String.Empty Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = "Debe seleccionar el archivo a cargar."
            Exit Sub
        Else
            Me.lblMsg.Visible = False
            Me.lblMsg.Text = String.Empty
        End If

        Try

            ArchivoPosteado = New Archivo(fileName, data, getTipoArchivo(Me.ddlProceso.SelectedValue.ToString), Me.getUsername, Me.getARSUsuario, Me.GetIPAddress())
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
