Imports System.Data
Imports SuirPlus

Partial Class Controles_Legal_ucAcuerdoPagoLeyFacilidades
    Inherits System.Web.UI.UserControl

    Public Property _NroAcuerdoDePago() As Double
        Get
            Return myNroAcuerdoDePago
        End Get
        Set(ByVal value As Double)
            Me.myNroAcuerdoDePago = value
        End Set

    End Property
    Public Property _DatosContrato() As SuirPlus.Legal.structDatosContrato
        Get
            Return myDC
        End Get
        Set(ByVal value As SuirPlus.Legal.structDatosContrato)
            Me.myDC = value
        End Set
    End Property
    Public Property _dsAcuerdoPago() As AcuerdoPago
        Get
            Return myDS
        End Get
        Set(ByVal value As AcuerdoPago)
            Me.myDS = value
        End Set
    End Property

    Private myNroAcuerdoDePago As Int32 = 0
    Private myDC As SuirPlus.Legal.structDatosContrato
    Private myDS As New AcuerdoPago
    Private myDtFechas As DataTable

    Public Sub _MostrarData()
        Try
            Me.pnlInfo.Visible = True
            Me.lblMensaje.Visible = False

            If Me.myNroAcuerdoDePago <> 0 Then

                'Llenar la estructura
                Dim acP As New SuirPlus.Legal.AcuerdosDePago(Me.myNroAcuerdoDePago, SuirPlus.Legal.eTiposAcuerdos.Ley189)

                myDC.CargoRepresentante = acP.Cargo
                myDC.Direccion = acP.Direccion
                myDC.EstadoCivil = acP.EstadoCivil
                myDC.Nacionalidad = acP.Nacionalidad
                myDC.NombreRepresentante = acP.Nombres
                myDC.NroCedulaoPasaporte = acP.NoDocumento
                myDC.PeriodoFin = acP.PeriodoFin
                myDC.PeriodoIni = acP.PeriodoIni
                myDC.RazonSocial = acP.RazonSocial
                myDC.TipoDocumentoRepresentante = acP.TipoDocumento
                myDC.RNC = acP.RNC

                'Llenar el ds
                Dim dt As DataTable
                dt = SuirPlus.Legal.AcuerdosDePago.getDetAcuerdoPago(acP.idAcuerdo, SuirPlus.Legal.eTiposAcuerdos.Ley189)

                For Each fila As System.Data.DataRow In dt.Rows
                    myDS.Cuotas.AddCuotasRow(fila.Item(1), fila.Item(2), "", "", 0, DateTime.Now())
                Next

                Me.lblNroAcuerdo.Text = acP.idAcuerdo
            End If

            Me.LlenarGrid()

            Me.lblRazonSocial.Text = myDC.RazonSocial
            Me.lblRazonSocial2.Text = myDC.RazonSocial
            Me.lblNroCedulaoPasaporte.Text = myDC.NroCedulaoPasaporte
            Me.lblNombreRepresentante.Text = myDC.NombreRepresentante
            Me.lblCargoRepresentante.Text = myDC.CargoRepresentante
            Me.lblDireccion.Text = myDC.Direccion
            Me.lblNacionalidad.Text = myDC.Nacionalidad
            Me.lblEstadoCivil.Text = myDC.EstadoCivil
            Me.lblNombreRep.Text = myDC.NombreRepresentante
            Me.lblNombreRep2.Text = myDC.NombreRepresentante
            Me.lblCargo.Text = myDC.CargoRepresentante

            Me.lblRNC.Text = myDC.RNC

            Me.lblPeriodoDesde.Text = myDC.PeriodoIni
            Me.lblPeriodoHasta.Text = myDC.PeriodoFin

            Me.lblFechaDia.Text = Now.Day
            Me.lblFechaMes.Text = SuirPlus.Utilitarios.Utils.getMes(Now.Month)
            Me.lblFechaAno.Text = Now.Year

            Me.lblFechaDia2.Text = Now.Day
            Me.lblFechaMes2.Text = SuirPlus.Utilitarios.Utils.getMes(Now.Month)
            Me.lblFechaAno2.Text = Now.Year

            Dim documento As String = String.Empty

            If (myDC.TipoDocumentoRepresentante = "Pasaporte") Or (myDC.TipoDocumentoRepresentante = "P") Then
                documento = "P"
            End If

            If documento = "P" Then 'If myDC.TipoDocumentoRepresentante = "P" Then
                Me.lblDescCedulaoPasaporte.Text = "el Pasaporte"
            Else
                Me.lblDescCedulaoPasaporte.Text = "la Cédula de Identidad y Electoral"
            End If


            Dim arch As New SuirPlus.Config.Configuracion(Config.ModuloEnum.AcuerdoPago)
            Me.lblFirmante1.Text = arch.Field1
            Me.lblCargo1.Text = arch.Field3
            Me.lblFirmante2.Text = arch.Field1
            Me.lblFirmante3.Text = arch.Field1

            'Me.lblFirmante1.Text = ConfigurationManager.AppSettings("apFirmante")
            'Me.lblFirmante2.Text = ConfigurationManager.AppSettings("apFirmante")
            'Me.lblFirmante3.Text = ConfigurationManager.AppSettings("apFirmante")

            Me.lblCargoFirmante.Text = arch.Field3
            Me.lblCedulaFirmante.Text = arch.Field4
            Me.lblDatosFirmante.Text = arch.Field2

            'Me.lblCargoFirmante.Text = ConfigurationManager.AppSettings("apCargo")
            'Me.lblCedulaFirmante.Text = ConfigurationManager.AppSettings("apCedula")
            'Me.lblDatosFirmante.Text = ConfigurationManager.AppSettings("apDatos")

        Catch ex As Exception
            Me.pnlInfo.Visible = False
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
            Exit Sub

        End Try
    End Sub

    Private Sub LlenarGrid()
        Try

            Me.ProcesarCuotas(myDS)

            If Me.myNroAcuerdoDePago <> 0 Then

                Me.gvCuotas.DataSource = SuirPlus.Legal.AcuerdosDePago.getDetAcuerdoPagoFechaLimite(Me.myNroAcuerdoDePago, SuirPlus.Legal.eTiposAcuerdos.Ley189)
                Me.gvCuotas.DataBind()

            Else
                Me.gvCuotas.DataSource = myDS.CuotasOrganizadas
                Me.gvCuotas.DataBind()

            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub ProcesarCuotas(ByRef ds As AcuerdoPago)

        Try
            ' Buscar el valor maximo de la Cuota
            Dim UltimaCuota As Integer = 0
            ' UltimaCuota = ds.Cuotas.Compute("max(Cuota)", String.Empty).ToString

            Dim cuotas As String = String.Empty
            cuotas = ds.Cuotas.Compute("max(Cuota)", String.Empty).ToString


            If cuotas <> String.Empty Then

                UltimaCuota = ds.Cuotas.Compute("max(Cuota)", String.Empty)

                Me.lblNroMeses.Text = UltimaCuota

                ' Armar el ds vacio con las cuotas
                ds.CuotasOrganizadas.Rows.Clear()

                For i As Integer = 1 To UltimaCuota
                    ds.CuotasOrganizadas.AddCuotasOrganizadasRow(i, "", 0, DateTime.Now())
                Next

                Dim Cuota As Integer = 0
                Dim CuotaOrganizada As Integer = 0
                Dim Total As Double = 0
                Dim Periodo As String
                Dim Ref As String
                Dim ii As Integer = 0

                Me.getFechasLimitePago(UltimaCuota)

                For Each rw As DataRow In ds.Cuotas.Rows

                    Cuota = Convert.ToInt16(rw("Cuota").ToString())
                    Ref = rw("Referencia").ToString()
                    Periodo = rw("Periodo").ToString()
                    Total = Convert.ToDouble(rw("Total").ToString())

                    If Cuota = 0 Then Cuota = 1

                    CuotaOrganizada = Cuota - 1

                    ds.CuotasOrganizadas.Rows(CuotaOrganizada)("Monto") = ds.CuotasOrganizadas.Rows(CuotaOrganizada)("Monto") + Total
                    ds.CuotasOrganizadas.Rows(CuotaOrganizada)("Referencias") = ds.CuotasOrganizadas.Rows(CuotaOrganizada)("Referencias") & SuirPlus.Utilitarios.Utils.FormateaReferencia(Ref) & ", "
                    ds.CuotasOrganizadas.Rows(CuotaOrganizada)("FechaLimite") = Me.getFechaLimitePago(CuotaOrganizada)

                    ds.Cuotas.Rows(ii)("FechaLimite") = Me.getFechaLimitePago(CuotaOrganizada)

                    ii = ii + 1

                Next

            Else
                Throw New Exception("Este Acuerdo de pago no tiene cuotas generadas")
            End If
        Catch ex As Exception
            Throw New Exception(ex.ToString())
        End Try
    End Sub


    Private Function getFechaLimitePago(ByVal Cuota As Integer) As DateTime
        Try

            Dim dtFecha As String = Me.myDtFechas.Rows(Cuota)(1).ToString()
            Dim formatoFecha As New System.Globalization.DateTimeFormatInfo()
            formatoFecha.ShortDatePattern = "dd/MM/yyyy"

            dtFecha = SuirPlus.Utilitarios.Utils.CambiarMesFecha(dtFecha)

            Dim fechaFormateada As DateTime = Convert.ToDateTime(dtFecha, formatoFecha)

            Return fechaFormateada.ToString()

        Catch ex As Exception
            Throw New Exception(ex.ToString())
        End Try

    End Function

    Private Sub getFechasLimitePago(ByVal UltimaCuota As Integer)
        Me.myDtFechas = SuirPlus.Legal.AcuerdosDePago.getFechasLimitePago(UltimaCuota)
    End Sub

End Class
