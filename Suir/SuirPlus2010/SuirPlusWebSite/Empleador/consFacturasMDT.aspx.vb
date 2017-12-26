
Partial Class Empleador_consFacturasMDT
    Inherits BasePage

    Public Numero As String


    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load
        Dim sec As String = ""
        sec = Request("sec")
        sec = Trim(sec)
        sec = sec.ToLower

        Dim nro As String = ""
        nro = Request("nro")
        nro = Trim(nro)
        nro = nro.ToLower

        Numero = nro



        Select Case sec
            Case "encabezado"
                ucPlanillasMDTencabezado1.Visible = True
                ucPlanillasMDTencabezado1.NroReferencia = nro
                ucPlanillasMDTencabezado1.MostrarEncabezado()
                If ucPlanillasMDTencabezado1.EstatusValor = "Pagada" Then

                    btnPagar.Visible = False
                Else
                    btnPagar.Visible = True

                End If



            Case "detalle"
                ucPlanillasMDTdetalle1.Visible = True
                ucPlanillasMDTdetalle1.NroReferencia = nro

                ucPlanillasMDTdetalle1.DataBind()
                btnPagar.Visible = False



        End Select


    End Sub

    Protected Sub btnPagar_Click(sender As Object, e As System.EventArgs) Handles btnPagar.Click


        If ucPlanillasMDTencabezado1.TipoFactura = "Pre-Calculo" Then

            If SuirPlus.Empresas.Facturacion.FacturaSS.errorReferenciaPreCalculo(Numero) <> "0" Then
                lblError.Text = SuirPlus.Empresas.Facturacion.FacturaSS.errorReferenciaPreCalculo(Numero)
            End If

        Else
            Response.Redirect(Application("servidor") + "mdt/pagosPlanillasMDT.aspx?nro=" + ucPlanillasMDTencabezado1.NroReferencia + "")
            Me.btnPagar.Text = Application("servidor") + "mdt/pagosPlanillasMDT.aspx?nro=" + ucPlanillasMDTencabezado1.NroReferencia + ""

        End If




    End Sub


End Class
