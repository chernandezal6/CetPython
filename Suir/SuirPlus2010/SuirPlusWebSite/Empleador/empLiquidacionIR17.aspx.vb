Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.Facturacion
Imports SuirPlus.Utilitarios

Partial Class Empleador_empLiquidacionIR17
    Inherits System.Web.UI.Page

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not IsPostBack Then

            Dim ir As SuirPlus.Empresas.Facturacion.DeclaracionIR17

            Try
                ir = New SuirPlus.Empresas.Facturacion.DeclaracionIR17(Request("rp"), Request("p"))

                Me.cargarForm(ir)
            Catch ex As Exception
                Response.Write("Deraclaración IR-17 invalida..." & ex.ToString())
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                Return
            End Try

        End If
        Dim Script As String = "<script language='javascript'>window.print()</script>"
        Me.ClientScript.RegisterStartupScript(Me.GetType(), "Onload", Script)
    End Sub

    Private Sub cargarForm(ByVal ir As DeclaracionIR17)

        'Seteando encabezado
        Me.lblPeriodo.Text = Utils.FormateaPeriodo(ir.Periodo)
        Me.lblReferencia.Text = ir.IdReferenciaFormat

        'Seteando info del Empleador
        Dim EmpleadorDGII As New Empleador(ir.RegistroPatronal)

        Me.lblRazonSocial.Text = EmpleadorDGII.RazonSocial
        Me.lblCedulaRNC.Text = Utils.FormatearRNCCedula(EmpleadorDGII.RNCCedula)
        Me.lblDireccion.Text = StrConv(EmpleadorDGII.Direccion, VbStrConv.ProperCase)
        Me.lblAdministracionLocal.Text = StrConv(EmpleadorDGII.AdministradoraLocal, VbStrConv.ProperCase)
        Me.lblTelefono.Text = Utils.FormatearTelefono(EmpleadorDGII.Telefono1)
        Me.lblFechaEmision.Text = CDate(ir.Fecha).ToShortDateString
        Me.lblFechaLimite.Text = CDate(ir.FechaLimite).ToShortDateString


        Dim alquilerValue As Integer = DeclaracionIR17.getParametro(60)
        Dim HpsiValue As Integer = DeclaracionIR17.getParametro(61)
        Dim PremiosValue As Integer = DeclaracionIR17.getParametro(62)
        Dim TTPValue As Integer = DeclaracionIR17.getParametro(63)
        Dim DividendosValue As Integer = DeclaracionIR17.getParametro(64)
        Dim IICEValue As Integer = DeclaracionIR17.getParametro(65)
        Dim RemesasValue As Integer = DeclaracionIR17.getParametro(66)
        Dim RPPPValue As Integer = DeclaracionIR17.getParametro(67)
        Dim OtrasRentasValue As Integer = DeclaracionIR17.getParametro(68)
        Dim RetComValue As Integer = DeclaracionIR17.getParametro(69)
        Dim OtrasRetValue As Integer = DeclaracionIR17.getParametro(70)


        'Cargando detalle de la declaracion
        Me.lblAlquileres.Text = FormatNumber(ir.Alquileres / (alquilerValue / 100))
        Me.lblHpsi.Text = FormatNumber(ir.HonorariosServicios / (HpsiValue / 100))
        Me.lblPremios.Text = FormatNumber(ir.Premios / (PremiosValue / 100))
        Me.lblTTP.Text = FormatNumber(ir.TransferenciaTitulos / (TTPValue / 100))
        Me.lblDividendos.Text = FormatNumber(ir.Dividendos / (DividendosValue / 100))
        Me.lblIICE.Text = FormatNumber(ir.InteresesExterior / (IICEValue / 100))
        Me.lblRemesasExt.Text = FormatNumber(ir.RemesasExterior / (RemesasValue / 100))
        Me.lblRPPP.Text = FormatNumber(ir.ProvedorEstado / (RPPPValue / 100))
        Me.lblOtrasRentas.Text = FormatNumber(ir.OtrasRentas / (OtrasRentasValue / 100))
        Me.lblRetComp.Text = FormatNumber(ir.RetribucionesComplementarias / (RetComValue / 100))
        Me.lblOtrasRet.Text = FormatNumber(ir.OtrasRetenciones / (OtrasRetValue / 100))

        Me.lblAlquileresI.Text = FormatNumber(ir.Alquileres)
        Me.lblHpsiI.Text = FormatNumber(ir.HonorariosServicios)
        Me.lblPremiosI.Text = FormatNumber(ir.Premios)
        Me.lblTTPI.Text = FormatNumber(ir.TransferenciaTitulos)
        Me.lblDividendosI.Text = FormatNumber(ir.Dividendos)
        Me.lblIICEI.Text = FormatNumber(ir.InteresesExterior)
        Me.lblRemesasExtI.Text = FormatNumber(ir.RemesasExterior)
        Me.lblRPPPI.Text = FormatNumber(ir.ProvedorEstado)
        Me.lblOtrasRentasI.Text = FormatNumber(ir.OtrasRentas)
        Me.lblOtrasRetI.Text = FormatNumber(ir.OtrasRetenciones)
        Me.lblRetCompI.Text = FormatNumber(ir.RetribucionesComplementarias)

        Me.lblTotalORetenciones.Text = FormatNumber(ir.Alquileres + ir.HonorariosServicios + ir.Premios + ir.TransferenciaTitulos + ir.Dividendos + ir.InteresesExterior + ir.RemesasExterior + ir.ProvedorEstado + ir.OtrasRentas + ir.OtrasRetenciones)
        Me.lblImpuesto.Text = FormatNumber(ir.Alquileres + ir.HonorariosServicios + ir.Premios + ir.TransferenciaTitulos + ir.Dividendos + ir.InteresesExterior + ir.RemesasExterior + ir.ProvedorEstado + ir.OtrasRentas + ir.OtrasRetenciones + ir.RetribucionesComplementarias)

        Dim tmpSF As Double = SuirPlus.Empresas.Facturacion.DeclaracionIR17.getSaldoFavor(ir.RegistroPatronal, ir.Periodo)

        Me.lblSCA.Text = FormatNumber(tmpSF)
        Me.lblSFA.Text = FormatNumber(ir.SaldoFavorAnterior)
        Me.lblTORI.Text = FormatNumber(ir.PagosComputables)

        Dim tmpNeto As Double = (ir.Alquileres + ir.HonorariosServicios + ir.Premios + ir.TransferenciaTitulos + ir.Dividendos + ir.InteresesExterior + ir.RemesasExterior + ir.ProvedorEstado + ir.OtrasRentas + ir.OtrasRetenciones + ir.RetribucionesComplementarias) - (tmpSF + ir.SaldoFavorAnterior + ir.PagosComputables)

        'Si es mayor que cero se asume como monto a pagar
        If tmpNeto > 0 Then
            Me.lblMP.Text = "RD$ " + FormatNumber(Math.Round(tmpNeto, 0))
            Me.lblNuevoSaldoFavor.Text = FormatNumber(0)
        Else 'De lo contrario es un nuevo saldo a favor
            Me.lblMP.Text = "RD$ " + FormatNumber(0)
            Me.lblNuevoSaldoFavor.Text = FormatNumber(Math.Round(tmpNeto * -1, 0))
        End If

        'Cargando Tsas
        Me.lblTazaAlq.Text = alquilerValue.ToString() & "%"
        Me.lblTasaHSI.Text = HpsiValue.ToString() & "%"
        Me.lblTasaPremios.Text = PremiosValue.ToString() & "%"
        Me.lblTasaTTP.Text = TTPValue.ToString() & "%"
        Me.lblTasaDiv.Text = DividendosValue.ToString() & "%"
        Me.lblTasaIICE.Text = IICEValue.ToString() & "%"
        Me.lblTasaRE.Text = RemesasValue.ToString() & "%"
        Me.lblTasaRPAE.Text = RPPPValue.ToString() & "%"
        Me.lblTasaORentas.Text = OtrasRentasValue.ToString() & "%"
        Me.lblTasaRC.Text = RetComValue.ToString() & "%"
        Me.lblTasaOtrasRet.Text = OtrasRetValue.ToString() & "%"

    End Sub

End Class
