Imports System.Data
Imports SuirPlus
Partial Class adpSolicitarAcuerdoPago
    Inherits BasePage
    Friend mystDC As SuirPlus.Legal.structDatosContrato
    Friend dsCuotas As AcuerdoPago
    Public tipoAcuerdo As String = String.Empty
    Public TipoAcuerdoCrear As Legal.eTiposAcuerdos


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Me.LlenarInfoAcuerdo()

    End Sub

    Private Sub LlenarInfoAcuerdo()

        tipoAcuerdo = Request.QueryString("TipoAcuerdo")
        Try
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
            mystDC.Provincia = Session("provincia_des")
            mystDC.Nacionalidad = Session("acpNacionalidad")
            mystDC.EstadoCivil = " "
            mystDC.RNC = Session("acpRNC")

            Me.dsCuotas = Session("acpAcuerdoPago")

            'mystDC.PeriodoIni = Replace(dsCuotas.Cuotas.Rows(1).Item("Periodo"), "-", "").Substring(2, 4) & Replace(dsCuotas.Cuotas.Rows(1).Item("Periodo"), "-", "").Substring(0, 2)
            'mystDC.PeriodoFin = Replace(dsCuotas.Cuotas.Rows(dsCuotas.Cuotas.Rows.Count - 1).Item("Periodo"), "-", "").Substring(2, 4) & Replace(dsCuotas.Cuotas.Rows(dsCuotas.Cuotas.Rows.Count - 1).Item("Periodo"), "-", "").Substring(0, 2)
            'If dsCuotas.Cuotas.Rows.Count > 1 Then
            '    mystDC.PeriodoIni = Replace(dsCuotas.Cuotas.Rows(1).Item("Periodo"), "-", "").Substring(2, 4) & Replace(dsCuotas.Cuotas.Rows(1).Item("Periodo"), "-", "").Substring(0, 2)

            '    mystDC.PeriodoFin = Replace(dsCuotas.Cuotas.Rows(0).Item("Periodo"), "-", "").Substring(2, 4) & Replace(dsCuotas.Cuotas.Rows(0).Item("Periodo"), "-", "").Substring(0, 2)
            'Else
            '    mystDC.PeriodoIni = Replace(dsCuotas.Cuotas.Rows(0).Item("Periodo"), "-", "").Substring(2, 4) & Replace(dsCuotas.Cuotas.Rows(0).Item("Periodo"), "-", "").Substring(0, 2)

            '    mystDC.PeriodoFin = Replace(dsCuotas.Cuotas.Rows(0).Item("Periodo"), "-", "").Substring(2, 4) & Replace(dsCuotas.Cuotas.Rows(0).Item("Periodo"), "-", "").Substring(0, 2)
            'End If

            mystDC.PeriodoIni = dsCuotas.Cuotas.Compute("Min(Periodo)", "")
            mystDC.PeriodoIni = Replace(mystDC.PeriodoIni, "-", "")

            mystDC.PeriodoFin = dsCuotas.Cuotas.Compute("Max(Periodo)", "")
            mystDC.PeriodoFin = Replace(mystDC.PeriodoFin, "-", "")

            If tipoAcuerdo = "Ordinario" Then
                Me.AdpucAcuerdoPago1._dsAcuerdoPago = Me.dsCuotas
                Me.AdpucAcuerdoPago1._DatosContrato = mystDC
                Me.AdpucAcuerdoPago1._MostrarData()
                Me.ucAcuerdoPagoEmbajadas1.Visible = False

            Else
                Me.AdpucAcuerdoPago1.Visible = False
                Me.ucAcuerdoPagoEmbajadas1._dsAcuerdoPago = Me.dsCuotas
                Me.ucAcuerdoPagoEmbajadas1._DatosContrato = mystDC
                Me.ucAcuerdoPagoEmbajadas1._MostrarData()
            End If

        Catch ex As Exception
            Throw ex
        End Try

    End Sub
    Protected Sub btCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btCancelar.Click
        Response.Redirect("adpSolicitarAcuerdoPago.aspx")
    End Sub

    Protected Sub btGenerar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btGenerar.Click

        tipoAcuerdo = Request.QueryString("TipoAcuerdo")

        If tipoAcuerdo = "Ordinario" Then
            TipoAcuerdoCrear = Legal.eTiposAcuerdos.Ordinario
        Else
            TipoAcuerdoCrear = Legal.eTiposAcuerdos.Embajadas
        End If

        Dim RegPat As Integer = Utilitarios.TSS.getRegistroPatronal(Session("acpRNC"))

        Dim idAcuerdoPago As String = Legal.AcuerdosDePago.CrearAcuerdoPago(RegPat, TipoAcuerdoCrear, Me.mystDC, Me.UsrUserName)

        Dim a() As String = Split(idAcuerdoPago, "|")

        If Not IsNumeric(idAcuerdoPago) Then
            Me.AdpucAcuerdoPago1.Mensaje = a(1).ToString()


            'Response.Write(idAcuerdoPago)

            Exit Sub

        End If

        Dim rw As AcuerdoPago.CuotasRow

        For Each rw In Me.dsCuotas.Cuotas.Rows
            Legal.AcuerdosDePago.CrearCuota(idAcuerdoPago, TipoAcuerdoCrear, rw.Cuota, rw.Referencia)
        Next

        SuirPlus.Legal.AcuerdosDePago.setFechasLimitesPago(idAcuerdoPago, TipoAcuerdoCrear)

        Response.Redirect("adpImprimirAcuerdoPago.aspx?idAcuerdoPago=" & idAcuerdoPago & "&tipoAcuerdo=" & tipoAcuerdo)

    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        'Atributo agregado para desabilitar el button una vez se la haya dado click.
        Me.btGenerar.Attributes.Add("onclick", "this.disabled=true;")

    End Sub

    Protected Sub AdpucAcuerdoPago1_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles AdpucAcuerdoPago1.Load
    End Sub
End Class
