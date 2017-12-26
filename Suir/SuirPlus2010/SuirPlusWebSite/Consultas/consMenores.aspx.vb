Imports System
Imports System.Data
Imports SuirPlus

Partial Class Consultas_consMenores
    Inherits BasePage
    Private qsNss As String = String.Empty
    Private qsDoc As String = String.Empty


    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'If Not Page.IsPostBack Then
        If Not (String.IsNullOrEmpty(Request.QueryString("nss"))) Or Not (String.IsNullOrEmpty(Request.QueryString("NoDoc"))) Then
            If Not String.IsNullOrEmpty(Request.QueryString("nss")) Then
                qsNss = Request.QueryString("NSS").Replace("-", "")
                Me.txtNSS.Text = qsNss
            ElseIf Not String.IsNullOrEmpty(Request.QueryString("NoDoc")) Then
                qsDoc = Request.QueryString("NoDoc").Replace("-", "")
                Me.txtDocumento.Text = qsDoc
            End If

            CargaInfoMenor()
        End If
        'End If
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        If String.IsNullOrEmpty(Me.txtDocumento.Text) And String.IsNullOrEmpty(Me.txtNSS.Text) Then
            Me.divInfoMenor.Visible = False
            Me.divInfoActa.Visible = False
            Me.divInfoTitular.Visible = False
            Me.lblMsg.Text = "Introduzca un Parametro para Realizar la Busqueda."
            Exit Sub

        End If

        CargaInfoMenor()

    End Sub

    Protected Sub CargaInfoMenor()

        Dim dt As DataTable = Nothing

        Try

            'realizamos una consulta dinamicamente a ciudadanos por el criterio o parametro que se le pasa.
            dt = SuirPlus.Ars.Consultas.getMenores(Me.txtDocumento.Text, Me.txtNSS.Text)

            If dt.Rows.Count > 0 Then
                Me.divInfoMenor.Visible = True
                Me.divInfoActa.Visible = True
                Me.divInfoTitular.Visible = True

                'Datos del menor
                Me.lblNSS.Text = dt.Rows(0)("ID_NSS").ToString()
                Me.lblTipoDoc.Text = dt.Rows(0)("TIPODOC").ToString()
                Me.lblNoDocumento.Text = dt.Rows(0)("NO_DOCUMENTO").ToString()
                Me.lblNombresMenor.Text = dt.Rows(0)("NOMBRES_MENOR").ToString()
                Me.lblApellidosMenor.Text = dt.Rows(0)("APELLIDOS_MENOR").ToString()
                Me.lblFechaNac.Text = String.Format("{0:d}", dt.Rows(0)("FECHA_NACIMIENTO"))
                Me.lblIdARSREGISTRO.Text = dt.Rows(0)("ID_ARS_REGISTRO").ToString()
                Me.lblARSMenor.Text = dt.Rows(0)("ARS_REGISTRO").ToString()
                Me.lblFechaCarga.Text = String.Format("{0:d}", dt.Rows(0)("FECHA_CARGA"))
                Me.lblLoteNo.Text = dt.Rows(0)("LOTE_NO").ToString()
                Me.lblLote.Text = dt.Rows(0)("LOTE").ToString()
                Me.lblSecuenciaReg.Text = dt.Rows(0)("SECUENCIA_REGISTRO").ToString()
                Me.lblIdARSActual.Text = dt.Rows(0)("ID_ARS_ACT").ToString()
                Me.lblARSActual.Text = dt.Rows(0)("ARS_ACTUAL").ToString()
                Me.lblStatusActual.Text = dt.Rows(0)("STATUS_ACTUAL").ToString()
                Me.lblTipoAfiliacion.text = dt.Rows(0)("Tipo_Afiliacion").ToString()

                'Datos del acta del Menor
                Me.lblMunicipio.Text = dt.Rows(0)("MUNICIPIO_ACTA").ToString()
                Me.lblOficialia.Text = dt.Rows(0)("OFICIALIA_ACTA").ToString()
                Me.lblLibro.Text = dt.Rows(0)("LIBRO_ACTA").ToString()
                Me.lblFolio.Text = dt.Rows(0)("FOLIO_ACTA").ToString()
                Me.lblAno.Text = dt.Rows(0)("ANO_ACTA").ToString()
                Me.lblActaNo.Text = dt.Rows(0)("NUMERO_ACTA").ToString()

                'Datos del titular
                Me.lblNSSTitular.Text = dt.Rows(0)("NSS_TITULAR").ToString()
                Me.lblNombresTitular.Text = dt.Rows(0)("NOMBRES_TITULAR").ToString()
                Me.lblApellidosTitular.Text = dt.Rows(0)("APELLIDOS_TITULAR").ToString()
                If Not (dt.Rows(0)("CEDULA_TITULAR").ToString() = String.Empty) Then
                    Me.lblCedulaTitular.Text = SuirPlus.Utilitarios.Utils.FormatearCedula(dt.Rows(0)("CEDULA_TITULAR"))
                End If


            Else
                Me.divInfoMenor.Visible = False
                Me.divInfoActa.Visible = False
                Me.divInfoTitular.Visible = False
                Me.lblMsg.Text = "Este Ciudadano no Existe"
            End If

            dt = Nothing

        Catch ex As Exception
            Me.divInfoMenor.Visible = False
            Me.divInfoActa.Visible = False
            Me.divInfoTitular.Visible = False
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click

        Response.Redirect("consMenores.aspx")

    End Sub

    Protected Sub lnkVolver_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("consCiudadano.aspx") '?NoDocumento=" & Me.txtDocumento.Text & "&NSS=" & Me.txtNSS.Text)
    End Sub

End Class
