Imports System.Data
Imports SuirPlus
Partial Class Legal_ConfirmarDatosAcuerdoDePago
    Inherits BasePage
    Friend mystDC As SuirPlus.Legal.structDatosContrato
    Friend dsCuotas As AcuerdoPago

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Me.LlenarInfoAcuerdo()

    End Sub

    Private Sub LlenarInfoAcuerdo()

        mystDC = New SuirPlus.Legal.structDatosContrato
        mystDC.RazonSocial = Session("acpRazonSocial")
        mystDC.NroCedulaoPasaporte = Session("acpRepresentanteLegalDoc")

        If mystDC.NroCedulaoPasaporte.Length = 11 Then
            mystDC.TipoDocumentoRepresentante = "C"
        Else
            mystDC.TipoDocumentoRepresentante = "P"
        End If

        mystDC.NombreRepresentante = Session("acpRepresentanteLegalnombre")
        mystDC.CargoRepresentante = Session("acpCargo")
        mystDC.Direccion = Session("acpDireccion")
        mystDC.Nacionalidad = Session("acpNacionalidad")
        mystDC.EstadoCivil = Session("acpEstadoCivil")
        mystDC.RNC = Session("acpRNC")

        Me.dsCuotas = Session("acpAcuerdoPago")

        mystDC.PeriodoIni = Replace(dsCuotas.Cuotas.Rows(0).Item("Periodo"), "-", "")
        mystDC.PeriodoFin = Replace(dsCuotas.Cuotas.Rows(dsCuotas.Cuotas.Rows.Count - 1).Item("Periodo"), "-", "")

        Me.UcAcuerdoPagoLeyFacilidades1._dsAcuerdoPago = Me.dsCuotas
        Me.UcAcuerdoPagoLeyFacilidades1._DatosContrato = mystDC
        Me.UcAcuerdoPagoLeyFacilidades1._MostrarData()



    End Sub

    Protected Sub btCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btCancelar.Click
        Response.Redirect("SolicitarAcuerdoPago.aspx")
    End Sub

    Protected Sub btGenerar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btGenerar.Click

        Dim RegPat As Integer
        Dim idAcuerdoPago As String = String.Empty
        Dim result As String = String.Empty

        Try
            RegPat = Utilitarios.TSS.getRegistroPatronal(Session("acpRNC"))

            idAcuerdoPago = Legal.AcuerdosDePago.CrearAcuerdoPago(RegPat, SuirPlus.Legal.eTiposAcuerdos.Ley189, Me.mystDC, Me.UsrUserName)

            If Not IsNumeric(idAcuerdoPago) Then

                result = idAcuerdoPago.Split("|")(1)
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = result
                Exit Sub

            End If

            Dim rw As AcuerdoPago.CuotasRow

            For Each rw In Me.dsCuotas.Cuotas.Rows
                Legal.AcuerdosDePago.CrearCuota(idAcuerdoPago, SuirPlus.Legal.eTiposAcuerdos.Ley189, rw.Cuota, rw.Referencia)
            Next

            Legal.AcuerdosDePago.setFechasLimitesPago(idAcuerdoPago, SuirPlus.Legal.eTiposAcuerdos.Ley189)

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Throw New Exception(ex.ToString)

        End Try

        Response.Redirect("ImprimirAcuerdoPago.aspx?idAcuerdoPago=" & idAcuerdoPago)


    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        'Atributo agregado para desabilitar el button una vez se la haya dado click.
        Me.btGenerar.Attributes.Add("onclick", "this.disabled=true;")

    End Sub

End Class
