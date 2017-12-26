Imports System.Data
Imports SuirPlus
Imports SuirPlus.Empresas



Partial Class Consultas_consLotes
    Inherits BasePage

    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load
        divDetalleLotes.Visible = False

        'divInfoARS.Visible = False
        If Page.IsPostBack Then

            divDetalleLotes.Visible = True

        End If
        pageNum = 1
        PageSize = BasePage.PageSize
    End Sub


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


    Protected Sub BindInfoLotes()

        Dim dtInfoLotes As New DataTable
        'Dim Ars As String
        Try
            dtInfoLotes = Empresas.Consultas.getInfoLote(txtNumLote.Text, txtNumDetalle.Text, Me.pageNum, Me.PageSize)

            If dtInfoLotes.Rows.Count > 0 Then

                If LblARS.Text = "" Then
                    LblARS.Visible = True
                    LblARS.Text = dtInfoLotes.Rows(0)("ars_des").ToString()
                    tdArs.Visible = True
                End If

                'llenamos el grid y los labels'
                'Utilitarios.Utils.FormatearFecha(dtInfoLotes.Rows(0)("RecibidoEn").ToString()
                Me.divInfoLote.Visible = False
                Me.lblTotalRegistros.Text = dtInfoLotes.Rows(0)("RECORDCOUNT")
                Me.gvInfoLotes.DataSource = dtInfoLotes
                Me.gvInfoLotes.DataBind()
                divDetalleLotes.Visible = True
                'LnkBtvolver.Visible = True
                setNavigation()
            Else
                divDetalleLotes.Visible = False
                Me.LblError.Visible = True
                LblError.Text = "No existen registros para esta busqueda"
            End If
            dtInfoLotes = Nothing

        Catch ex As Exception
            Me.LblError.Visible = True
            Me.LblError.Text = ex.Message
        End Try

    End Sub


    Protected Sub BindInfoAsignacion(numlote As String, numRegistro As String)

        Dim dtInfoAsignacion As New DataTable
        Try
            dtInfoAsignacion = Empresas.Consultas.getInfoAsignacion(numlote, numRegistro)

            If dtInfoAsignacion.Rows.Count > 0 Then
             
                Me.divInfoLote.Visible = True
                Me.lblNumLote.Text = dtInfoAsignacion.Rows(0)("lote").ToString()
                Me.lblNumRegistro.Text = dtInfoAsignacion.Rows(0)("id_registro").ToString()
                Me.LblNombreARS.Text = dtInfoAsignacion.Rows(0)("ars_des").ToString()
                Me.LblNombres.Text = dtInfoAsignacion.Rows(0)("nombres").ToString()
                Me.LblApellidos.Text = dtInfoAsignacion.Rows(0)("Apellidos").ToString()
                Me.LblEstadoCivil.Text = dtInfoAsignacion.Rows(0)("estado_civil").ToString()
                Me.LblFechaNac.Text = dtInfoAsignacion.Rows(0)("fecha_nacimiento").ToString()
                Me.LblNroDoc.Text = dtInfoAsignacion.Rows(0)("no_documento").ToString()
                Me.LblNombrePadre.Text = dtInfoAsignacion.Rows(0)("nombre_padre").ToString()
                Me.lblNombreMadre.Text = dtInfoAsignacion.Rows(0)("nombre_madre").ToString()
                Me.lblMunicipio.Text = dtInfoAsignacion.Rows(0)("municipio_acta").ToString()
                Me.lblOficialia.Text = dtInfoAsignacion.Rows(0)("oficialia_acta").ToString()
                Me.lblProvincia.Text = dtInfoAsignacion.Rows(0)("id_provincia").ToString()
                Me.lblLibro.Text = dtInfoAsignacion.Rows(0)("libro_acta").ToString()
                Me.lblAno.Text = dtInfoAsignacion.Rows(0)("ano_acta").ToString()
                Me.lblNroActa.Text = dtInfoAsignacion.Rows(0)("numero_acta").ToString()
                Me.lblFolio.Text = dtInfoAsignacion.Rows(0)("folio_acta").ToString()
                Me.LblEstatus.Text = dtInfoAsignacion.Rows(0)("status").ToString()
                Me.LblNSS.Text = dtInfoAsignacion.Rows(0)("nss").ToString()
                Me.LblExtranjero.Text = dtInfoAsignacion.Rows(0)("extranjero").ToString()
                Me.lblNacionalidad.Text = dtInfoAsignacion.Rows(0)("id_nacionalidad").ToString()

                If dtInfoAsignacion.Rows(0)("tipo_documento").ToString() = "P" Then
                    Me.LblCodTitular.Text = dtInfoAsignacion.Rows(0)("no_documento_titular").ToString()
                Else
                    Me.LblCodTitular.Text = formateaDocumento(dtInfoAsignacion.Rows(0)("no_documento_titular").ToString())

                End If

                Me.LblNombreTitular.Text = dtInfoAsignacion.Rows(0)("nombres_titular").ToString()
                Me.LblApellidosTitular.Text = dtInfoAsignacion.Rows(0)("Apellidos_titular").ToString()
                Me.lblProvinciaDes.Text = dtInfoAsignacion.Rows(0)("PROVINCIA_DES").ToString()
                Me.lblMunicipioDes.Text = dtInfoAsignacion.Rows(0)("MUNICIPIO_DES").ToString()
                Me.LblMotivoError.Text = dtInfoAsignacion.Rows(0)("Desc_Error").ToString()
                Me.LblNSSDuplicidad.Text = dtInfoAsignacion.Rows(0)("nss_duplicidad").ToString()
            Else
                Me.divInfoLote.Visible = False
                Me.LblError.Visible = True
                LblError.Text = "No existen registros para esta busqueda."
            End If
            dtInfoAsignacion = Nothing

        Catch ex As Exception
            Me.LblError.Visible = True
            Me.LblError.Text = ex.Message
        End Try

    End Sub

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

        'Aqui ponemos el metodo que cargara la informacion'
        BindInfoLotes()

    End Sub

    Protected Sub gvInfoLotes_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvInfoLotes.RowCommand

        Dim numLote As String = Split(e.CommandArgument, "|")(0)
        Dim idRegistro As String = Split(e.CommandArgument, "|")(1)

        Try
            If e.CommandName = "VerActa" Then
                Response.Redirect("VerActa.aspx?idLote=" + numLote + "&idRegistro=" + idRegistro)

            End If
        Catch ex As Exception
            Me.LblError.Visible = True
            Me.LblError.Text = ex.Message
        End Try

    End Sub


    Protected Sub gvInfoDetalleLotes_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvInfoLotes.RowCommand

        Dim numLote As String = Split(e.CommandArgument, "|")(0)
        Dim idRegistro As String = Split(e.CommandArgument, "|")(1)

        Try
            If e.CommandName = "VerMas" Then
                BindInfoAsignacion(numLote, idRegistro)
               
            End If
        Catch ex As Exception
            Me.LblError.Visible = True
            Me.LblError.Text = ex.Message
        End Try

    End Sub
    

    Protected Sub btnBuscar_Click(sender As Object, e As System.EventArgs) Handles btnBuscar.Click
        tdArs.Visible = False
        LblARS.Visible = False
        divDetalleLotes.Visible = False
        Me.divInfoLote.Visible = False


        If txtNumLote.Text <> "" Then
            BindInfoLotes()
        Else
            Me.divDetalleLotes.Visible = False
            Me.divInfoLote.Visible = False
            Me.LblError.Visible = True
            Me.LblError.Text = "Debe ingresar el numero de lote"

        End If

    End Sub

    Protected Sub BtnLimpiar_Click(sender As Object, e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("consLotes.aspx")
    End Sub


    Public Function formateaDocumento(ByVal documento As String) As String

        'Si el documento que se envia no tiene 11 digitos asumimos que es un pasaporte.
        If documento.Length <> 11 Then
            Return documento
        End If

        Return SuirPlus.Utilitarios.Utils.FormatearCedula(documento)

    End Function

    Protected Sub gvInfoLotes_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvInfoLotes.RowDataBound
        If e.Row.Cells(0).Text = "Cambios de Datos" Then
            CType(e.Row.FindControl("btnlnkVerMas"), LinkButton).Visible = False
        End If

    End Sub
End Class
