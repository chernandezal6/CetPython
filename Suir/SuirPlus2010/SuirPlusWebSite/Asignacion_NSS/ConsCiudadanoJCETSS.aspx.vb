
Imports System.Data
Imports SuirPlus
Imports SuirPlusEF.GenericModels
Imports SuirPlusEF.Repositories

Partial Class Asignacion_NSS_ConsCiudadanoJCETSS
    Inherits BasePage

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        Response.Redirect("ConsCiudadanoJCETSS.aspx")
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        Try
            lblMsg.Visible = False
            lblMsg.Text = String.Empty
            fsCiudadano.Visible = True
            fsJCE.Visible = True
            validarDocumento()
            buscarTSS()
            buscarJCE()
        Catch ex As Exception
            fsCiudadano.Visible = False
            fsJCE.Visible = False
            lblMsg.Visible = True
            lblMsg.Text = ex.Message
        End Try

    End Sub

    Protected Sub validarDocumento()
        Try
            If String.IsNullOrEmpty(txtNoDocumento.Text) = True Then
                Throw New Exception("El número de documento es requerido")
            ElseIf txtNoDocumento.Text.Length <> 11 Then
                Throw New Exception("El número de documento es inválido")
            ElseIf Not IsNumeric(txtNoDocumento.Text) Then
                Throw New Exception("El número de documento debe ser numérico")
            ElseIf txtNoDocumento.Text.StartsWith("88") Then
                Throw New Exception("El número de documento no pertenece a un ciudadano cedulado")
            End If
        Catch ex As Exception
            Throw ex
        End Try

    End Sub

    Protected Sub buscarTSS()
        Try
            Dim repCiudadano As New CiudadanoRepository()
            If (txtNoDocumento.Text <> "") And (ddlTipoDocumento.SelectedValue = "C" Or ddlTipoDocumento.SelectedValue = "U") Then
                Dim ciu As DataTable = Utilitarios.TSS.getCiudadanoAsigNSS(ddlTipoDocumento.SelectedValue, txtNoDocumento.Text)
                If ciu.Rows.Count > 0 Then
                    If (ciu.Rows(0)("NO_DOCUMENTO") <> String.Empty) Then
                        lblCedula.Text = Utilitarios.Utils.FormatearCedula(ciu.Rows(0)("NO_DOCUMENTO"))
                    End If
                    lblNombres.Text = ciu.Rows(0)("NOMBRES").ToString()
                    lblPrimerApellido.Text = ciu.Rows(0)("PRIMER_APELLIDO").ToString()
                    lblSegundoApellido.Text = ciu.Rows(0)("SEGUNDO_APELLIDO").ToString()
                    If (ciu.Rows(0)("FECHA_NACIMIENTO") <> Date.MinValue) Then
                        Dim fecha As String = ciu.Rows(0)("FECHA_NACIMIENTO").ToString()
                        lblFechaNacimiento.Text = CDate(fecha).ToString("dd/MM/yyyy")
                    End If
                    lblSexo.Text = ciu.Rows(0)("SEXO").ToString()
                    lblOficialia.Text = ciu.Rows(0)("OFICIALIA_ACTA").ToString()
                    lblLibro.Text = ciu.Rows(0)("LIBRO_ACTA").ToString()
                    lblTipoLibro.Text = ciu.Rows(0)("TIPO_LIBRO_ACTA").ToString()
                    lblFolio.Text = ciu.Rows(0)("FOLIO_ACTA").ToString()
                    lblNroActa.Text = ciu.Rows(0)("NUMERO_ACTA").ToString()
                    lblAno.Text = ciu.Rows(0)("ANO_ACTA").ToString()
                    lblMunicipio.Text = ciu.Rows(0)("MUNICIPIO_ACTA").ToString()
                    lblNacionalidad.Text = ciu.Rows(0)("NACIONALIDAD_DES").ToString()
                    lblEstadoCivil.Text = ciu.Rows(0)("ESTADO_CIVIL").ToString()
                    lblCausaInhabilidad.Text = ciu.Rows(0)("CANCELACION_DES").ToString()
                    lblTipoCausa.Text = ciu.Rows(0)("TIPO_CAUSA").ToString()
                    lblEstatus.Text = ciu.Rows(0)("STATUS").ToString()
                    lblMadreNombres.Text = ciu.Rows(0)("NOMBRE_MADRE").ToString()
                    lblPadreNombre.Text = ciu.Rows(0)("NOMBRE_PADRE").ToString()

                    pnlInfoTSS.Visible = True
                    divmsgTSS.Visible = False
                Else
                    pnlInfoTSS.Visible = False
                    lblmsgTSS.Text = "El ciudadano NO existe en TSS"
                    divmsgTSS.Visible = True
                End If

            Else
                Throw New Exception("Ambos valores son requeridos")
            End If

        Catch ex As Exception
            lblMsg.Text = ex.Message
            lblMsg.Visible = True
            fsCiudadano.Visible = False
            fsJCE.Visible = False
        End Try
    End Sub

    Protected Sub buscarJCE()
        Try
            Dim sr As New SuirPlusEF.Framework.ServiceResult()
            If (txtNoDocumento.Text <> "") And (ddlTipoDocumento.SelectedValue = "C" Or ddlTipoDocumento.SelectedValue = "U") Then
                If ddlTipoDocumento.SelectedValue = "C" Then
                    'buscamos en ws-cedulados JCE
                    Dim documento As New DocumentoCedula(txtNoDocumento.Text)
                    Dim wsCedModel As New WebServiceCedulaModel()
                    Dim ws As New SuirPlusEF.Service.WebServiceCedula()
                    Dim repInhabilidad As New SuirPlusEF.Repositories.InhabilidadRepository()
                    Dim Inhabilidad As New SuirPlusEF.Models.InhabilidadJCE()

                    Try
                        sr = ws.ConsultaByCedula(documento, wsCedModel)
                    Catch ex As Exception
                        pnlInfoJCE.Visible = False
                        divmsgJCE.Visible = True
                        lblmsgJCE.Text = "Error al consumir el webservice de cedulados de la JCE."
                        Return
                    End Try

                    If wsCedModel.Success.ToUpper() = "TRUE" Then
                        If (wsCedModel.Cedula <> String.Empty) Then
                            lblCedula2.Text = Utilitarios.Utils.FormatearCedula(wsCedModel.Cedula)
                        End If
                        lblNombres2.Text = wsCedModel.Nombres
                        lblPrimerApellido2.Text = wsCedModel.Apellido1
                        lblSegundoApellido2.Text = wsCedModel.Apellido2
                        lblFechaNacimiento2.Text = wsCedModel.FechaNacimiento
                        lblSexo2.Text = wsCedModel.Sexo
                        lblOficialia2.Text = wsCedModel.OficialiaActa
                        lblLibro2.Text = wsCedModel.NoLibro
                        lblTipoLibro2.Text = wsCedModel.TipoLibroActa
                        lblFolio2.Text = wsCedModel.NoFolio
                        lblNroActa2.Text = wsCedModel.NoActa
                        lblAno2.Text = wsCedModel.AnoActa
                        lblMunicipio2.Text = wsCedModel.MunicipioActa
                        lblNacionalidad2.Text = wsCedModel.CodNacionalidad
                        lblEstadoCivil2.Text = wsCedModel.EstadoCivil
                        If wsCedModel.CodCausa <> String.Empty Then
                            Inhabilidad = repInhabilidad.GetByIdInhabilidad(wsCedModel.CodCausa)
                            lblCausaInhabilidad2.Text = Inhabilidad.Descripcion
                        End If
                        lblTipoCausa2.Text = wsCedModel.TipoCausa
                        lblEstatus2.Text = wsCedModel.Estatus
                        lblMadreNombres2.Text = wsCedModel.NombreMadre + " " + wsCedModel.Apellido1Madre
                        lblPadreNombre2.Text = wsCedModel.NombrePadre + " " + wsCedModel.Apellido1Padre

                        pnlInfoJCE.Visible = True
                        divmsgJCE.Visible = False
                    Else
                        pnlInfoJCE.Visible = False
                        divmsgJCE.Visible = True
                        lblmsgJCE.Text = "El ciudadano NO existe en JCE"
                        Return
                    End If

                ElseIf ddlTipoDocumento.SelectedValue = "U" Then
                    'buscamos en ws-NUI JCE
                    Dim documento As New DocumentoNUI(txtNoDocumento.Text)
                    Dim wsNUIModel As New WebServiceNUIModel()
                    Dim ws As New SuirPlusEF.Service.WebServiceNUI()
                    Try
                        sr = ws.ConsultaByNUI(documento, wsNUIModel)
                    Catch ex As Exception
                        pnlInfoJCE.Visible = False
                        divmsgJCE.Visible = True
                        lblmsgJCE.Text = "Error al consumir el webservice de los NUI de la JCE."
                        Return
                    End Try

                    If wsNUIModel.ConsultaValida.ToUpper() = "TRUE" Then
                        lblCedula2.Text = wsNUIModel.NUICompleto.NumeroConGuiones
                        lblNombres2.Text = wsNUIModel.Nombre
                        lblPrimerApellido2.Text = wsNUIModel.PrimerApellido
                        lblSegundoApellido2.Text = wsNUIModel.SegundoApellido
                        lblFechaNacimiento2.Text = wsNUIModel.FechaEvento
                        lblSexo2.Text = wsNUIModel.Sexo
                        lblOficialia2.Text = wsNUIModel.Oficialia
                        lblLibro2.Text = wsNUIModel.NoLibro
                        lblTipoLibro2.Text = wsNUIModel.idTipoLibro
                        lblFolio2.Text = wsNUIModel.NoFolio
                        lblNroActa2.Text = wsNUIModel.NoActa
                        lblAno2.Text = wsNUIModel.Ano
                        lblMunicipio2.Text = wsNUIModel.Municipio
                        lblMadreNombres2.Text = wsNUIModel.CedulaMadre
                        lblPadreNombre2.Text = wsNUIModel.CedulaPadre

                        pnlInfoJCE.Visible = True
                        divmsgJCE.Visible = False
                    Else
                        pnlInfoJCE.Visible = False
                        divmsgJCE.Visible = True
                        lblmsgJCE.Text = "El ciudadano NO existe en JCE"
                        Return
                    End If
                End If
            Else
                Throw New Exception("Ambos valores son requeridos")
            End If

        Catch ex As Exception
            lblMsg.Text = ex.Message
            lblMsg.Visible = True
            fsCiudadano.Visible = False
            fsJCE.Visible = False
        End Try
    End Sub

    Private Sub ddlTipoDocumento_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlTipoDocumento.SelectedIndexChanged
        txtNoDocumento.Focus()
        lblMsg.Text = String.Empty
        fsCiudadano.Visible = False
        fsJCE.Visible = False
    End Sub
End Class
