Imports SuirPlus
Imports SuirPlus.Empresas
Imports System.IO

Partial Class Afiliacion_EnvioNovedadesRectroactivas
    Inherits BasePage

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        'Si no es la primera vez que se carga la pagina entonces escondemos algunos paneles
        If Not Page.IsPostBack Then
            ' llenarListaArchivo()
            Me.pnlCargaArchivo.Visible = True
            Me.pnlError.Visible = False
            Me.pnlEstatus.Visible = False
            Me.pnlRepresentantes.Visible = False
        End If
        Page.Form.Attributes.Add("enctype", "multipart/form-data")
    End Sub

    Protected Sub lnkBtnCargarArchivo_Click(sender As Object, e As System.EventArgs) Handles lnkBtnCargarArchivo.Click
        Dim data As Stream
        Dim ArchivoPosteado As Archivo
        Dim fileName As String = fuArchivo.FileName
        Dim resultado As String = String.Empty

        data = fuArchivo.PostedFile.InputStream

        If fileName = String.Empty Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = "Debe seleccionar el archivo a cargar."
            Return
        Else
            Me.lblMsg.Visible = False
            Me.lblMsg.Text = String.Empty

            gvRepresentantes.Columns(1).Visible = True

            For i As Integer = 0 To gvRepresentantes.Rows.Count - 1
                If CType(gvRepresentantes.Rows(i).FindControl("rbSelector"), CheckBox).Checked = True Then
                    resultado = gvRepresentantes.Rows(i).Cells(1).Text
                End If
            Next
          
            If resultado = String.Empty Then
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "Debe seleccionar al menos un Representante."
                Return
            End If

            gvRepresentantes.Columns(1).Visible = False


        End If

        Try

            ArchivoPosteado = New Archivo(fileName, data, Archivo.SuirArchivoType.AutodeterminacionRetroactiva, Me.getUsername, resultado, txtRncCedula.Text)
            data.Close()
            data.Dispose()

            'Utilizado para mostrar el popup
            Me.pnlEstatus.Visible = True
            Me.lblNombreArchivo.Text = ArchivoPosteado.NombreAchivo
            Me.lblNumeroArchivo.Text = ArchivoPosteado.Numero
            Me.lblFechaCarga.Text = Date.Now.ToString()
            Me.ModalPopupExtender1.Show()
            Me.pnlRepresentantes.Visible = False
            Me.gvRepresentantes.DataSource = ""
            Me.txtRncCedula.Text = ""



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

    Protected Sub txtRncCedula_TextChanged(sender As Object, e As System.EventArgs) Handles txtRncCedula.TextChanged
        Dim tmpEmp As New SuirPlus.Empresas.Empleador(Me.txtRncCedula.Text)

        ' Empleador no existe
        If tmpEmp.RazonSocial = String.Empty Then
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = "RNC o Cédula del empleador inválido"
            Me.lblMsg.ForeColor = Drawing.Color.Red
            Me.txtRncCedula.Text = String.Empty
            Me.txtRncCedula.Focus()
            Return
        Else
            pnlRepresentantes.Visible = True
            Dim getRepresentantesActivos = SuirPlus.Empresas.Representante.getRepresentanteListaActivos(tmpEmp.RegistroPatronal)
            If getRepresentantesActivos.Rows.Count > 0 Then
                gvRepresentantes.DataSource = getRepresentantesActivos
                gvRepresentantes.DataBind()
                gvRepresentantes.Columns(1).Visible = False

            End If
        End If

        If tmpEmp.StatusCobro = StatusCobrosType.Legal Then
            fuArchivo.Focus()
        Else
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = "Este empleador esta habilitado para enviar sus novedades rectroactivas"
            Me.lblMsg.ForeColor = Drawing.Color.Green
            Me.txtRncCedula.Text = String.Empty
            Me.txtRncCedula.Focus()
            Return
        End If

        Me.lblMsg.Text = String.Empty
        Me.lblMsg.Visible = False



    End Sub

    Private Sub btnEstatusCargaArchivo_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

        Me.pnlCargaArchivo.Visible = True

    End Sub

    Private Sub btnErrorCargaArchivo_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnErrorCargaArchivo.Click

        Me.pnlCargaArchivo.Visible = True
        Me.pnlError.Visible = False

    End Sub

    Public Function getUsername() As String
        If UsrImpersonandoUnRepresentante Then
            Return Me.UsrImpUserName
        Else
            Return Me.UsrUserName
        End If
    End Function

    Public Function getRNCEmpleador() As String
        Return Me.UsrRNC
    End Function

    

    Protected Sub rbSelector_CheckedChanged(sender As Object, e As System.EventArgs)
        'Clear the existing selected row 
        For Each oldrow As GridViewRow In gvRepresentantes.Rows
            DirectCast(oldrow.FindControl("rbSelector"), RadioButton).Checked = False
        Next

        'Set the new selected row
        Dim rb As RadioButton = DirectCast(sender, RadioButton)
        Dim row As GridViewRow = DirectCast(rb.NamingContainer, GridViewRow)
        DirectCast(row.FindControl("rbSelector"), RadioButton).Checked = True
    End Sub



End Class
