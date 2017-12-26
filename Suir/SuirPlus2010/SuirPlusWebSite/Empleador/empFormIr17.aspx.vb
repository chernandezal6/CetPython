Imports SuirPlus.Empresas.Facturacion

Partial Class Empleador_empFormIr17
    Inherits System.Web.UI.Page 'BasePage

    Public RegPat As New Int32
    Public UsrName As String

    Protected Sub Page_InitComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.InitComplete
        Dim script As String = "<script language='javascript' type='text/javascript'>" + vbNewLine + _
       "function calc(){" + vbNewLine + _
       "document.getElementById('" + txtAlquileresI.ClientID + "').value = roundNum(document.getElementById('" + txtAlquileres.ClientID + "').value * " + (DeclaracionIR17.getParametro(60) / 100).ToString() + ");" + vbNewLine + _
       "document.getElementById('" + txtHpsiI.ClientID + "').value = roundNum(document.getElementById('" + txtHpsi.ClientID + "').value * " + (DeclaracionIR17.getParametro(61) / 100).ToString() + ")" + vbNewLine + _
       "document.getElementById('" + txtPremiosI.ClientID + "').value = roundNum(document.getElementById('" + txtPremios.ClientID + "').value * " + (DeclaracionIR17.getParametro(62) / 100).ToString() + ")" + vbNewLine + _
       "document.getElementById('" + txtTTPI.ClientID + "').value = roundNum(document.getElementById('" + txtTTP.ClientID + "').value * " + (DeclaracionIR17.getParametro(63) / 100).ToString() + ")" + vbNewLine + _
       "document.getElementById('" + txtDividendosI.ClientID + "').value = roundNum(document.getElementById('" + txtDividendos.ClientID + "').value * " + (DeclaracionIR17.getParametro(64) / 100).ToString() + ")" + vbNewLine + _
       "document.getElementById('" + txtIICEI.ClientID + "').value = roundNum(document.getElementById('" + txtIICE.ClientID + "').value * " + (DeclaracionIR17.getParametro(65) / 100).ToString() + ")" + vbNewLine + _
       "document.getElementById('" + txtRemesasExtI.ClientID + "').value = roundNum(document.getElementById('" + txtRemesasExt.ClientID + "').value * " + (DeclaracionIR17.getParametro(66) / 100).ToString() + ")" + vbNewLine + _
       "document.getElementById('" + txtRPPPI.ClientID + "').value = roundNum(document.getElementById('" + txtRPPP.ClientID + "').value * " + (DeclaracionIR17.getParametro(67) / 100).ToString() + ")" + vbNewLine + _
       "document.getElementById('" + txtOtrasRentastImp.ClientID + "').value = roundNum(document.getElementById('" + txtOtrasRentas.ClientID + "').value * " + (DeclaracionIR17.getParametro(68) / 100).ToString() + ")" + vbNewLine + _
       "document.getElementById('" + txtOtrasRetImp.ClientID + "').value = roundNum(document.getElementById('" + txtOtrasRet.ClientID + "').value * " + (DeclaracionIR17.getParametro(70) / 100).ToString() + ")" + vbNewLine + _
       "" + vbNewLine + _
       "document.getElementById('" + txtTotalORetenciones.ClientID + "').value = roundNum(parseFloat(document.getElementById('" + txtAlquileresI.ClientID + "').value) + " + _
       "parseFloat(document.getElementById('" + txtHpsiI.ClientID + "').value) + " + "parseFloat(document.getElementById('" + txtPremiosI.ClientID + "').value) + " + vbNewLine + _
       "parseFloat(document.getElementById('" + txtTTPI.ClientID + "').value) + " + "parseFloat(document.getElementById('" + txtDividendosI.ClientID + "').value) + " + vbNewLine + _
       "parseFloat(document.getElementById('" + txtIICEI.ClientID + "').value) + " + "parseFloat(document.getElementById('" + txtRemesasExtI.ClientID + "').value) + " + vbNewLine + _
       "parseFloat(document.getElementById('" + txtRPPPI.ClientID + "').value) + " + "parseFloat(document.getElementById('" + txtOtrasRentastImp.ClientID + "').value) + parseFloat(document.getElementById('" + txtOtrasRetImp.ClientID + "').value));" + vbNewLine + _
       "" + vbNewLine + _
       "document.getElementById('" + txtRetCompI.ClientID + "').value = roundNum(parseFloat(document.getElementById('" + txtRetComp.ClientID + "').value * " + (DeclaracionIR17.getParametro(69) / 100).ToString() + "));" + vbNewLine + _
       "document.getElementById('" + txtImpuesto.ClientID + "').value = roundNum(parseFloat(document.getElementById('" + txtTotalORetenciones.ClientID + "').value) + " + "parseFloat(document.getElementById('" + txtRetCompI.ClientID + "').value" + "));" + vbNewLine + _
       "" + vbNewLine + _
       "var tmpVal = parseFloat(document.getElementById('" + txtImpuesto.ClientID + "').value) - parseFloat(document.getElementById('" + txtSCA.ClientID + "').value) - " + vbNewLine + _
       "parseFloat(document.getElementById('" + txtSFA.ClientID + "').value) - parseFloat(document.getElementById('" + txtTORI.ClientID + "').value);" + vbNewLine + _
       "" + vbNewLine + _
       "if (tmpVal < 0) {" + vbNewLine + _
       "document.getElementById('" + txtNuevoSaldoFavor.ClientID + "').value = roundNum(parseFloat(tmpVal * -1));" + vbNewLine + _
       "document.getElementById('" + txtMP.ClientID + "').value = 0.00;" + vbNewLine + _
       "}" + vbNewLine + _
       "else{" + vbNewLine + _
       "document.getElementById('" + txtMP.ClientID + "').value = roundNum(tmpVal);" + vbNewLine + _
       "document.getElementById('" + txtNuevoSaldoFavor.ClientID + "').value = 0.00;" + vbNewLine + _
       "}" + vbNewLine + _
       "}" + vbNewLine + _
       "</script>"

        Me.ClientScript.RegisterStartupScript(Me.GetType(), "calc", script)
    End Sub

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        Me.RegPat = HttpContext.Current.Session("UsrRegistroPatronal")
        Me.UsrName = HttpContext.Current.Session("UsrUserName")


        If RegPat = 0 Then
            RegPat = HttpContext.Current.Session("ImpRegistroPatronal")
        End If

        If Not IsPostBack Then
            Me.iniForm()
            Me.validaForm()
        End If

        'Si le graban o actualizan, que salga el popup de impresion automaticamente
        If Not IsPostBack And Request("r") = "true" And DeclaracionIR17.isTieneDeclaracionVigente(Me.RegPat) Then

            'Verificamos si ya el script esta registrado, de lo contrario lo agregamos.
            Dim popupScript As String = "<script language=""javascript"">"
            'popupScript += "window.showModalDialog('empLiquidacionIR17.aspx?rp=" & Me.RegPat & "&p=" & SuirPlus.Utilitarios.Utils.getPeriodoAnterior(SuirPlus.Utilitarios.Utils.getPeriodoActual) & "', 'Argumento1', " + "'dialogHeight: 670px; dialogWidth: 580px; dialogTop: 200px; dialogLeft: 300px; edge: Raised; center: No; help: No; resizable: No; status: No;')"
            popupScript += "newwindow = window.open('empLiquidacionIR17.aspx?rp=" & Me.RegPat & "&p=" & SuirPlus.Utilitarios.Utils.getPeriodoAnterior(SuirPlus.Utilitarios.Utils.getPeriodoActual) & "', 'Argumento1', " + "'height: 670px; width: 580px; top: 200px; left: 300px;');"
            popupScript += "newwindow.print();"
            popupScript += "</script>"
            Me.ClientScript.RegisterStartupScript(Me.GetType(), "PopupScript", popupScript)

        End If

    End Sub

    Private Sub iniForm()

        Dim tmpstr As String = SuirPlus.Empresas.Facturacion.DeclaracionIR17.getSaldoFavor(Me.RegPat, SuirPlus.Utilitarios.Utils.getPeriodoAnterior(SuirPlus.Utilitarios.Utils.getPeriodoActual))
        Dim retStr As String() = Split(tmpstr, "|")

        If retStr(0) = "0" Then
            Me.txtSCA.Text = FormatNumber(SuirPlus.Empresas.Facturacion.DeclaracionIR17.getSaldoFavor(Me.RegPat, SuirPlus.Utilitarios.Utils.getPeriodoAnterior(SuirPlus.Utilitarios.Utils.getPeriodoActual)))
        Else
            Me.txtSCA.Text = "0.00"
        End If

        Me.txtAlquileres.Attributes.Add("onfocus", "maskFocus(this)")
        Me.txtAlquileres.Attributes.Add("onblur", "wrapBlur(this)")
        Me.txtAlquileres.Attributes.Add("onkeydown", "return CheckKeyCode()")

        Me.txtHpsi.Attributes.Add("onfocus", "maskFocus(this)")
        Me.txtHpsi.Attributes.Add("onblur", "wrapBlur(this)")
        Me.txtHpsi.Attributes.Add("onkeydown", "return CheckKeyCode()")

        Me.txtPremios.Attributes.Add("onfocus", "maskFocus(this)")
        Me.txtPremios.Attributes.Add("onblur", "wrapBlur(this)")
        Me.txtPremios.Attributes.Add("onkeydown", "return CheckKeyCode()")

        Me.txtTTP.Attributes.Add("onfocus", "maskFocus(this)")
        Me.txtTTP.Attributes.Add("onblur", "wrapBlur(this)")
        Me.txtTTP.Attributes.Add("onkeydown", "return CheckKeyCode()")

        Me.txtDividendos.Attributes.Add("onfocus", "maskFocus(this)")
        Me.txtDividendos.Attributes.Add("onblur", "wrapBlur(this)")
        Me.txtDividendos.Attributes.Add("onkeydown", "return CheckKeyCode()")

        Me.txtIICE.Attributes.Add("onfocus", "maskFocus(this)")
        Me.txtIICE.Attributes.Add("onblur", "wrapBlur(this)")
        Me.txtIICE.Attributes.Add("onkeydown", "return CheckKeyCode()")

        Me.txtRemesasExt.Attributes.Add("onfocus", "maskFocus(this)")
        Me.txtRemesasExt.Attributes.Add("onblur", "wrapBlur(this)")
        Me.txtRemesasExt.Attributes.Add("onkeydown", "return CheckKeyCode()")

        Me.txtRPPP.Attributes.Add("onfocus", "maskFocus(this)")
        Me.txtRPPP.Attributes.Add("onblur", "wrapBlur(this)")
        Me.txtRPPP.Attributes.Add("onkeydown", "return CheckKeyCode()")

        Me.txtOtrasRentas.Attributes.Add("onfocus", "maskFocus(this)")
        Me.txtOtrasRentas.Attributes.Add("onblur", "wrapBlur(this)")
        Me.txtOtrasRentas.Attributes.Add("onkeydown", "return CheckKeyCode()")

        Me.txtOtrasRet.Attributes.Add("onfocus", "maskFocus(this)")
        Me.txtOtrasRet.Attributes.Add("onblur", "wrapBlur(this)")
        Me.txtOtrasRet.Attributes.Add("onkeydown", "return CheckKeyCode()")

        Me.txtRetComp.Attributes.Add("onfocus", "maskFocus(this)")
        Me.txtRetComp.Attributes.Add("onblur", "wrapBlur(this)")
        Me.txtRetComp.Attributes.Add("onkeydown", "return CheckKeyCode()")

        Me.txtTORI.Attributes.Add("onfocus", "maskFocus(this)")
        Me.txtTORI.Attributes.Add("onblur", "wrapBlur(this)")
        Me.txtTORI.Attributes.Add("onkeydown", "return CheckKeyCode()")

        Me.txtSFA.Attributes.Add("onfocus", "maskFocus(this)")
        Me.txtSFA.Attributes.Add("onblur", "wrapBlur(this)")
        Me.txtSFA.Attributes.Add("onkeydown", "return CheckKeyCode()")


        'Cargamos las tasas
        Me.lblTazaAlq.Text = DeclaracionIR17.getParametro(60) & "%"
        Me.lblTasaHSI.Text = DeclaracionIR17.getParametro(61) & "%"
        Me.lblTasaPremios.Text = DeclaracionIR17.getParametro(62) & "%"
        Me.lblTasaTTP.Text = DeclaracionIR17.getParametro(63) & "%"
        Me.lblTasaDiv.Text = DeclaracionIR17.getParametro(64) & "%"
        Me.lblTasaIICE.Text = DeclaracionIR17.getParametro(65) & "%"
        Me.lblTasaRE.Text = DeclaracionIR17.getParametro(66) & "%"
        Me.lblTasaRPAE.Text = DeclaracionIR17.getParametro(67) & "%"
        Me.lblTasaOtrasRentas.Text = DeclaracionIR17.getParametro(68) & "%"
        Me.lblTasaRC.Text = DeclaracionIR17.getParametro(69) & "%"
        Me.lblTasaOtrasRet.Text = DeclaracionIR17.getParametro(70) & "%"

    End Sub

    Private Sub validaForm()

        'Cargando fecha limite
        Me.lblFechaLimite.Text = DeclaracionIR17.getFechaLimite().ToString("dd/MM/yyyy")

        'En caso de que el empleador haya declarado el IR17
        If DeclaracionIR17.isTieneDeclaracionVigente(Me.RegPat) Then
            'Abilitando modo de edicion
            Me.setEditMode()
            Me.setDeclaracionVigente()

        Else 'En caso de que no haya declarado el IR17

            'Abilitando modo de ingreso de declaracion
            Me.setNewMode()

        End If

    End Sub

    Private Sub resetForm()

        txtAlquileres.Text = "0.00"
        txtAlquileresI.Text = "0.00"
        txtHpsi.Text = "0.00"
        txtHpsiI.Text = "0.00"
        txtPremios.Text = "0.00"
        txtPremiosI.Text = "0.00"
        txtTTP.Text = "0.00"
        txtTTPI.Text = "0.00"
        txtDividendos.Text = "0.00"
        txtDividendosI.Text = "0.00"
        txtIICE.Text = "0.00"
        txtIICEI.Text = "0.00"
        txtRemesasExt.Text = "0.00"
        txtRemesasExtI.Text = "0.00"
        txtRPPP.Text = "0.00"
        txtRPPPI.Text = "0.00"
        txtOtrasRentas.Text = "0.00"
        txtOtrasRentastImp.Text = "0.00"
        txtOtrasRet.Text = "0.00"
        txtOtrasRetImp.Text = "0.00"
        txtRetComp.Text = "0.00"
        txtRetCompI.Text = "0.00"
        txtTORI.Text = "0.00"
        txtImpuesto.Text = "0.00"
        txtSCA.Text = SuirPlus.Empresas.Facturacion.DeclaracionIR17.getSaldoFavor(Me.RegPat, SuirPlus.Utilitarios.Utils.getPeriodoActual)
        txtSFA.Text = "0.00"
        txtMP.Text = "0.00"

        Me.ClientScript.RegisterStartupScript(Me.GetType(), "calculo1", "<script language='javascript' type='text/javascript'> calc() </script>")


    End Sub

    Private Sub setDeclaracionVigente()

        If DeclaracionIR17.isTieneDeclaracionVigente(Me.RegPat) Then

            Dim dc As New DeclaracionIR17(Me.RegPat, SuirPlus.Utilitarios.Utils.getPeriodoAnterior(SuirPlus.Utilitarios.Utils.getPeriodoActual))

            'Setiando label de declaracion
            Me.lblDeclaracionVigente.Text = "Este período fue declarado en fecha: <b> " & dc.Fecha.ToString("dd/MM/yyyy") & "</b>"

            'Valores calculados
            Me.txtAlquileres.Text = dc.Alquileres / (DeclaracionIR17.getParametro(60) / 100)
            Me.txtHpsi.Text = dc.HonorariosServicios / (DeclaracionIR17.getParametro(61) / 100)
            Me.txtPremios.Text = dc.Premios / (DeclaracionIR17.getParametro(62) / 100)
            Me.txtTTP.Text = dc.TransferenciaTitulos / (DeclaracionIR17.getParametro(63) / 100)
            Me.txtDividendos.Text = dc.Dividendos / (DeclaracionIR17.getParametro(64) / 100)
            Me.txtIICE.Text = dc.InteresesExterior / (DeclaracionIR17.getParametro(65) / 100)
            Me.txtRemesasExt.Text = dc.RemesasExterior / (DeclaracionIR17.getParametro(66) / 100)
            Me.txtRPPP.Text = dc.ProvedorEstado / (DeclaracionIR17.getParametro(67) / 100)
            Me.txtOtrasRentas.Text = dc.OtrasRentas / (DeclaracionIR17.getParametro(68) / 100)
            Me.txtRetComp.Text = dc.RetribucionesComplementarias / (DeclaracionIR17.getParametro(69) / 100)
            Me.txtOtrasRet.Text = dc.OtrasRetenciones / (DeclaracionIR17.getParametro(70) / 100)
            Me.txtTORI.Text = dc.PagosComputables
            Me.txtSFA.Text = dc.SaldoFavorAnterior

            'LLamando script de calculo <Client Side>
            Me.ClientScript.RegisterStartupScript(Me.GetType(), "calulo", "<script language='javascript' type='text/javascript'>calc();</script>")

            'Si el estatus no es de vigente no permite acutalizacion de la declaracion
            If dc.Status = "VI" Or dc.Status = "EX" Then
                If dc.NoAutorizacion > 0 And dc.Status = "VI" Then
                    Me.setDisableMode()
                    Me.lblPagaAutorizada.Visible = True
                Else
                    Me.lblPagaAutorizada.Visible = False
                End If

            Else
                Me.setDisableMode()
                Me.lblPagaAutorizada.Visible = True
            End If

        Else
            If Not SuirPlus.Empresas.Facturacion.DeclaracionIR17.isTiempoParaHacerDeclaracion Then

                'Letrero
                Me.lblDeclaracionVigente.ForeColor = Drawing.Color.Red
                Me.lblDeclaracionVigente.Text = "Este periodo no fue declarado."

            End If
        End If

    End Sub

    Private Sub setEditMode()

        Me.btnEdit.Visible = True
        Me.btnNew.Visible = False
        lkbtnImprimir.Visible = True

    End Sub

    Private Sub setNewMode()

        Me.btnEdit.Visible = False
        Me.btnNew.Visible = True
        Me.lkbtnImprimir.Visible = False

    End Sub

    Private Sub setDisableMode()

        Me.btnEdit.Visible = False
        Me.btnNew.Visible = False

        'Bloquear lo campos 
        Me.txtAlquileres.Enabled = False
        Me.txtHpsi.Enabled = False
        Me.txtPremios.Enabled = False
        Me.txtTTP.Enabled = False
        Me.txtDividendos.Enabled = False
        Me.txtIICE.Enabled = False
        Me.txtOtrasRentas.Enabled = False
        Me.txtRemesasExt.Enabled = False
        Me.txtRetComp.Enabled = False
        Me.txtRPPP.Enabled = False
        Me.txtSCA.Enabled = False
        Me.txtSFA.Enabled = False
        Me.txtTORI.Enabled = False
    End Sub

    Private Sub btnNew_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNew.Click

        Dim Regpatr As Int32

        Regpatr = Me.RegPat

        If Regpatr = 0 Then
            Regpatr = HttpContext.Current.Session("ImpRegistroPatronal")
        End If

        Dim res As String
        res = SuirPlus.Empresas.Facturacion.DeclaracionIR17.NuevaDeclaracion(Regpatr, _
                                                                        SuirPlus.Utilitarios.Utils.getPeriodoAnterior(SuirPlus.Utilitarios.Utils.getPeriodoActual), _
                                                                        (getValor(txtAlquileres.Text) * (DeclaracionIR17.getParametro(60) / 100)), _
                                                                        (getValor(txtHpsi.Text) * (DeclaracionIR17.getParametro(61) / 100)), _
                                                                        (getValor(txtPremios.Text) * (DeclaracionIR17.getParametro(62) / 100)), _
                                                                        (getValor(txtTTP.Text) * (DeclaracionIR17.getParametro(63) / 100)), _
                                                                        (getValor(txtDividendos.Text) * (DeclaracionIR17.getParametro(64) / 100)), _
                                                                        (getValor(txtIICE.Text) * (DeclaracionIR17.getParametro(65) / 100)), _
                                                                        (getValor(txtRemesasExt.Text) * (DeclaracionIR17.getParametro(66) / 100)), _
                                                                        (getValor(txtRPPP.Text) * (DeclaracionIR17.getParametro(67) / 100)), _
                                                                        (getValor(txtOtrasRentas.Text) * (DeclaracionIR17.getParametro(68) / 100)), _
                                                                        (getValor(Me.txtOtrasRet.Text) * (DeclaracionIR17.getParametro(70) / 100)), _
                                                                        (getValor(txtRetComp.Text) * (DeclaracionIR17.getParametro(69) / 100)), _
                                                                        getValor(txtTORI.Text), _
                                                                        getValor(txtSFA.Text), _
                                                                        Me.UsrName)

        If Left(res, 1) = "0" Then
            Response.Redirect("empFormIr17.aspx?r=true&m=" & res)
        Else


            Me.lblMensajeError.Visible = True
            Me.lblMensajeError.Text = "RegPat:" & Regpatr & "<br>" & res

        End If


    End Sub

    Private Sub btnEdit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnEdit.Click

        Dim dc As New DeclaracionIR17(Me.RegPat, SuirPlus.Utilitarios.Utils.getPeriodoAnterior(SuirPlus.Utilitarios.Utils.getPeriodoActual))

        'Valores calculados
        dc.Alquileres = (getValor(txtAlquileres.Text) * (DeclaracionIR17.getParametro(60) / 100))
        dc.HonorariosServicios = (getValor(txtHpsi.Text) * (DeclaracionIR17.getParametro(61) / 100))
        dc.Premios = (getValor(txtPremios.Text) * (DeclaracionIR17.getParametro(62) / 100))
        dc.TransferenciaTitulos = (getValor(txtTTP.Text) * (DeclaracionIR17.getParametro(63) / 100))
        dc.Dividendos = (getValor(txtDividendos.Text) * (DeclaracionIR17.getParametro(64) / 100))
        dc.InteresesExterior = (getValor(txtIICE.Text) * (DeclaracionIR17.getParametro(65) / 100))
        dc.RemesasExterior = (getValor(txtRemesasExt.Text) * (DeclaracionIR17.getParametro(66) / 100))
        dc.ProvedorEstado = (getValor(txtRPPP.Text) * (DeclaracionIR17.getParametro(67) / 100))
        dc.OtrasRentas = (getValor(txtOtrasRentas.Text) * (DeclaracionIR17.getParametro(68) / 100))
        dc.OtrasRetenciones = (getValor(txtOtrasRet.Text) * (DeclaracionIR17.getParametro(70) / 100))
        dc.RetribucionesComplementarias = (getValor(txtRetComp.Text) * (DeclaracionIR17.getParametro(69) / 100))

        dc.PagosComputables = getValor(txtTORI.Text)
        dc.SaldoFavorAnterior = getValor(txtSFA.Text)

        Response.Write(dc.GuardarCambios(Me.UsrName))
        ''Return
        Response.Redirect("empFormIr17.aspx?r=true")
    End Sub

    Private Sub lkbtnImprimir_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lkbtnImprimir.Click

        Dim popupScript As String = "<script language=""javascript"">"
        'popupScript += "window.showModalDialog('empLiquidacionIR17.aspx?rp=" & Me.RegPat & "&p=" & SuirPlus.Utilitarios.Utils.getPeriodoAnterior(SuirPlus.Utilitarios.Utils.getPeriodoActual) & "', 'Argumento1', " + "'dialogHeight: 670px; dialogWidth: 580px; scroll:no; dialogTop: 200px; dialogLeft: 300px; edge: Raised; center: No; help: No; resizable: No; status: No;');"
        popupScript += "newwindow = window.open('empLiquidacionIR17.aspx?rp=" & Me.RegPat & "&p=" & SuirPlus.Utilitarios.Utils.getPeriodoAnterior(SuirPlus.Utilitarios.Utils.getPeriodoActual) & "', 'Argumento1', " + "'height: 670px; width: 580px; top: 200px; left: 300px;');"
        popupScript += "newwindow.print();"
        popupScript += "</script>"
        Me.ClientScript.RegisterStartupScript(Me.GetType(), "PopupScript", popupScript)

    End Sub

    Private Function getValor(ByVal val As String) As Decimal

        If val.Trim = "" Then Return 0

        Try
            Return Decimal.Parse(val)
        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Return 0
        End Try

    End Function

End Class
