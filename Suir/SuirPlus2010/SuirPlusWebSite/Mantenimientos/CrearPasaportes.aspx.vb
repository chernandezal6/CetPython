Imports System.IO


Partial Class Mantenimientos_CrearPasaportes
    Inherits BasePage

    Protected imgStream As System.IO.Stream
    Protected imgLength As Integer

    Protected Sub btnGuardar_Click(sender As Object, e As System.EventArgs) Handles btnGuardar.Click
        ProcesarDocumento()
    End Sub

    Private Property NroSolicitud() As Integer
        Get
            Return ViewState("NroPasaporte")
        End Get
        Set(ByVal value As Integer)
            ViewState("NroPasaporte") = value
        End Set
    End Property

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            CargarSexo()
            CargarNacionalidad()
            LimpiarCampos()
            CargarRequisitos(NroSolicitud)
        End If
0:
        Page.Form.Attributes.Add("enctype", "multipart/form-data")
    End Sub

    Sub CargarSexo()
        ddlSexo.Items.Add(New ListItem("<--Seleccione-->", "-1"))
        ddlSexo.Items.Add(New ListItem("Masculino", "M"))
        ddlSexo.Items.Add(New ListItem("Femenino", "F"))
        Me.ddlSexo.SelectedValue = "-1"
    End Sub

    Sub ProcesarDocumento()
        lbl_error.CssClass = "error"
        Dim ret As String
        btnGuardar.Enabled = False

        Try
            Dim StringPasaporte As String = String.Empty
            Dim SegundoApellido As String = String.Empty



            If ddlTipoDocumento.SelectedValue = "-1" Then
                lbl_error.Text = "Debe seleccionar un tipo de documento"
                btnGuardar.Enabled = True

                Return

            ElseIf txtDocumento.Text = String.Empty Then
                lbl_error.Text = "Debe ingresar un Documento valido"
                btnGuardar.Enabled = True

                Return

            ElseIf txtDocumento.Text.Contains(" ") Then
                lbl_error.Text = "Documento no debe contener espacios"
                btnGuardar.Enabled = True
                Return


            ElseIf txtNombre.Text = String.Empty Then
                lbl_error.Text = "Debe ingresar los nombres"
                btnGuardar.Enabled = True
                Return

            ElseIf txtApellido.Text = String.Empty Then
                lbl_error.Text = "Debe ingresar el primer apellido"
                btnGuardar.Enabled = True
                Return


            ElseIf txtFechaNacimiento.Text = String.Empty Then
                lbl_error.Text = "Fecha de nacimiento es requerida"
                btnGuardar.Enabled = True
                Return

            ElseIf SuirPlus.Utilitarios.Utils.IsDateTimeValid(txtFechaNacimiento.Text) = False Then
                lbl_error.Text = "Fecha de nacimiento debe ser valida"
                btnGuardar.Enabled = True
                Return

            ElseIf Convert.ToDateTime(txtFechaNacimiento.Text) > DateTime.Now Then
                lbl_error.Text = "Fecha de nacimiento no debe ser futura"
                btnGuardar.Enabled = True
                Return

            ElseIf TextEmail.Text = String.Empty Then
                lbl_error.Text = "El correo electrónico es requerido"
                btnGuardar.Enabled = True
                Return

            ElseIf TextNumeroContacto.Text = String.Empty Then
                lbl_error.Text = "El número de contacto es requerido"
                btnGuardar.Enabled = True
                Return
            ElseIf TextNumeroContacto.Text.Length < 10 Then
                lbl_error.Text = "El número de contacto debe tener como mínimo 10 números"
                btnGuardar.Enabled = True
                Return

            ElseIf ddlNacionalidad.SelectedValue = "-1" Then
                lbl_error.Text = "Nacionalidad es requerida"
                btnGuardar.Enabled = True
                Return

            ElseIf ddlSexo.SelectedValue = "-1" Then
                lbl_error.Text = "Debe seleccionar el sexo para este Documento"
                btnGuardar.Enabled = True
                Return

            End If

            Dim i As Integer = 0
            For i = 0 To gvCargarArchivos.Rows.Count - 1

                Dim Obligatorio = gvCargarArchivos.Rows(i).Cells(1)

                If DirectCast(gvCargarArchivos.Rows(i).FindControl("upImagenes"), FileUpload).PostedFile.ContentLength <= 0 Then
                    If Obligatorio.Text = "S" Then
                        lbl_error.ForeColor = System.Drawing.Color.Red
                        lbl_error.Text = "Debe cargar los archivos obligatorios."
                        btnGuardar.Enabled = True
                        Return
                    End If
                End If
            Next



            ret = SuirPlus.Mantenimientos.Mantenimientos.CrearPasaporte(UsrRegistroPatronal, txtDocumento.Text, txtNombre.Text.ToUpper(), txtApellido.Text.ToUpper(), txtApellido2.Text, txtFechaNacimiento.Text, ddlSexo.SelectedValue, ddlNacionalidad.SelectedValue, UsrUserName, TextEmail.Text, TextNumeroContacto.Text, UsrUserName)

            If Split(ret, "|")(0) = "0" Then


                NroSolicitud = Convert.ToInt32(Split(ret, "|")(1))

                'Insertando la Documentacion
                Dim Numero As Integer = 0
                For Numero = 0 To gvCargarArchivos.Rows.Count - 1
                    Dim up = DirectCast(gvCargarArchivos.Rows(Numero).FindControl("upImagenes"), FileUpload)
                    Dim ID = DirectCast(gvCargarArchivos.Rows(Numero).Cells(2).FindControl("lbLRequisito"), Label)
                    If up.PostedFile.ContentLength > 0 Then
                        UploadDocumentacion(up, ID.Text)
                    End If
                Next

                'CargarPasaportes()
                lbl_error.Text = "Documento creado satisfactoriamente"
                lbl_error.CssClass = "subHeader"

            End If

            LimpiarCampos()
            btnGuardar.Enabled = True


        Catch ex As Exception
            lbl_error.Text = ex.Message.ToString()
            lbl_error.CssClass = "error"
        End Try

    End Sub

    Sub CargarNacionalidad()
        ddlNacionalidad.DataSource = SuirPlus.Utilitarios.TSS.get_Nacionalidades()
        ddlNacionalidad.DataTextField = "NACIONALIDAD_DES"
        ddlNacionalidad.DataValueField = "ID_NACIONALIDAD"
        ddlNacionalidad.DataBind()
        Me.ddlNacionalidad.Items.Add(New WebControls.ListItem("<--Seleccione-->", "-1"))
        Me.ddlNacionalidad.SelectedValue = "-1"
    End Sub

    Function ValidarImagen() As Boolean
        Dim resultado As Boolean = True

        Try
            'If Me.upImagenPasaporte.HasFile() Then
            '    imgStream = upImagenPasaporte.PostedFile.InputStream
            '    imgLength = upImagenPasaporte.PostedFile.ContentLength
            '    Dim imgContentType As String = upImagenPasaporte.PostedFile.ContentType

            '    If (imgContentType = "image/jpeg") Or (imgContentType = "image/jpg") Or (imgContentType = "image/tif") Or (imgContentType = "image/tiff") Or (imgContentType = "image/png") Then

            '        Dim imgSize As String = (imgLength / 1024)
            '        If imgSize > 500 Then
            '            lbl_error.Text = "Esta imagen no debe superar los 500KB"
            '            resultado = False
            '        End If
            '    Else
            '        lbl_error.Text = "La imagen debe ser de tipo TIF, PNG o JPG"
            '        resultado = False
            '    End If

            'End If

            Return resultado
        Catch ex As Exception
            Me.lbl_error.Visible = True
            Me.lbl_error.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Function

    Sub LimpiarCampos()

        txtApellido.Text = String.Empty
        txtApellido2.Text = String.Empty
        txtFechaNacimiento.Text = String.Empty
        txtNombre.Text = String.Empty
        txtDocumento.Text = String.Empty
        TextEmail.Text = String.Empty
        TextNumeroContacto.Text = String.Empty

        ddlNacionalidad.SelectedValue = "-1"
        ddlSexo.SelectedValue = "-1"

        btnGuardar.Enabled = True
    End Sub

    Private Function GetFileSize(byteCount As Double) As Boolean
        Dim size As String = "0 Bytes"
        If byteCount >= 3072000.0 Then
            size = String.Format("{0:##.##}", byteCount / 1048576.0) & " MB"
            lbl_error.ForeColor = System.Drawing.Color.Red
            lbl_error.Text = "El tamaño de archivo no puede superar un 3MB, su archivo es " + size

            Return True
        Else
            Return False
        End If
    End Function

    Public Sub UploadDocumentacion(Archivo As FileUpload, ID As Integer)

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

                Dim img = SuirPlus.Mantenimientos.Mantenimientos.CargarDocumentacion(NroSolicitud, ID, bytes, NombreArchivo, ContentType, UsrUserName)

                If img <> "OK" Then
                    Throw New Exception(img)
                End If

                lbl_error.ForeColor = System.Drawing.Color.Green
                lbl_error.Text = "Carga de archivo completada"

            End If

        Catch ex As Exception
            Throw ex
        End Try



    End Sub

    Public Sub CargarRequisitos(ByVal SolicitudID As String)
        Dim Requisitos = SuirPlus.Mantenimientos.Mantenimientos.getRequisitoPasaportes(SolicitudID)
        gvCargarArchivos.DataSource = Requisitos
        gvCargarArchivos.DataBind()
    End Sub

    Protected Sub gvCargarArchivos_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvCargarArchivos.RowCommand

        Dim Resultado1 = e.CommandArgument.ToString()
        Dim resultado2 = e.CommandName.ToString()

        ScriptManager.RegisterStartupScript(gvCargarArchivos, Me.GetType(), "temp", "<script language='javascript'>window.open('" + Application("servidor") + "Mantenimiento/VerImagenesSolicitud.aspx?idDoc=" + Resultado1 + "&req=" + resultado2 + "','_blank');</script>", False)

    End Sub
End Class
