<%@ Control Language="VB" AutoEventWireup="false" CodeFile="adpucAcuerdoPago.ascx.vb" Inherits="Controles_Legal_ucAcuerdoPagoLeyFacilidades" %>

<style type="text/css">
    .style2
    {
        font-family: Verdana;
        color: black;
    }
    .style3
    {
        font-family: Verdana;
        font-weight: bold;
        color: black;
    }
    .style4
    {
        font-family: Verdana;
        font-size: 11px;
        color: black;
    }
    .style5
    {
        color: black;
        font-weight: bold;
    }
</style>

<asp:Panel ID="pnlInfo" runat="server">
</asp:Panel>
<table border="0" cellpadding="0" cellspacing="0" width="850">
    <tr>
        <td style="text-align: justify;font-family:verdana;font-size:11px; width: 894px;">
            <strong>Nro: AO-</strong><asp:Label ID="lblNroAcuerdo" runat="server" Text="_______"></asp:Label><br />
                <br />
            <strong>
                ACUERDO DE PAGO ORDINARIO PARA EMPLEADORES
                CON DEUDAS PENDIENTES CON EL SISTEMA DOMINICANO DE SEGURIDAD SOCIAL.</strong>
                <br />
            <br />
            <strong>ENTRE:</strong> De una parte, la <strong>TESORERÍA DE LA SEGURIDAD SOCIAL, </strong>
            RNC 401517078,
            entidad pública constituida en virtud de la Ley No. 87-01 que crea el Sistema Dominicano
            de Seguridad Social<strong> </strong>(en lo adelante SDSS), con domicilio en la avenida Tiradentes No. 33, sector Naco,
            de esta ciudad de Santo Domingo, Distrito Nacional, debidamente representada por
            el señor <strong> <asp:Label ID="lblFirmante1" runat="server"></asp:Label></strong>, <asp:Label ID="lblCargo1" runat="server"></asp:Label>, <asp:Label ID="lblDatosFirmante" runat="server" ></asp:Label>
            portador de la Cédula de Identidad y Electoral número <asp:Label ID="lblCedulaFirmante" runat="server"></asp:Label>, quien para
            los fines de este Contrato se denominará <strong>LA TESORERIA</strong> O <strong>LA TSS;</strong>
            <br />
            <br />
            Y de la otra parte,
            <asp:Label ID="lblRazonSocial" runat="server" Font-Bold="True" Font-Underline="False"></asp:Label>, RNC
            <asp:Label ID="lblRNC" runat="server" Font-Underline="False"></asp:Label>, sociedad
            comercial constituida de conformidad con las leyes de la República Dominicana y/o
            Empleador, con su domicilio social ubicado en la
            <asp:Label ID="lblDireccion" runat="server" Font-Bold="False"></asp:Label>,
            <asp:Label ID="lblProvincia" runat="server" Font-Bold="False"></asp:Label>, República
            Dominicana, debidamente representada por su
            <asp:Label ID="lblCargoRepresentante" runat="server"></asp:Label>, el (la) señor (a) <asp:Label
                ID="lblNombreRepresentante" runat="server" Font-Bold="True" Font-Underline="False"></asp:Label><strong>, </strong>
            <asp:Label ID="lblNacionalidad" runat="server"></asp:Label><strong>, mayor de edad</strong>,
            portador de&nbsp;
            <asp:Label ID="lblDescCedulaoPasaporte" runat="server" Text="la Cédula de Identidad y Electoral"></asp:Label>
            No.
            <asp:Label ID="lblNroCedulaoPasaporte" runat="server"></asp:Label>, quien en
                lo que sigue del presente Contrato se denominará LA EMPRESA Y/O EMPLEADOR;
            cuando este contrato se refiera conjuntamente a ambas partes serán denominadas 
                LAS PARTES.<br />
                <br />
            <strong>
                POR CUANTO: A que en fecha nueve (09) del mes mayo del año Dos Mil Uno (2001), el
                Poder Ejecutivo promulgó la Ley marcada con el número 87-01, que crea el Sistema
                Dominicano de Seguridad Social, la cual en su Artículo 28, otorga a la TESORERIA
                DE LA SEGURIDAD SOCIAL,</strong> la función de “Administrar el Sistema Único
            de Información, mantener los registros actualizados sobre los empleadores y sus
            afiliados y sobre los beneficiarios de los tres regimenes de financiamiento, recaudar
            distribuir y asignar los recursos del SDSS, ejecutar por cuenta del consejo Nacional
            de Seguridad Social (en lo adelante CNSS) el pago
            a todas las instituciones participantes, públicas, privadas y/o mixtas, garantizando regularidad,
            transparencia, seguridad, eficiencia e igualdad, detectar la mora, evasión y elusión
            combinando otras fuentes de información gubernamental o privada”.<br />
            <br />
            <span class="style3" lang="ES" 
                style="mso-fareast-font-family: &quot;Times New Roman&quot;; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
            POR CUANTO</span><span class="style2" lang="ES" 
                style="mso-fareast-font-family: &quot;Times New Roman&quot;; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA; mso-bidi-font-weight: bold">: 
            A que en fecha veintidós (22) del mes Junio del año Dos Mil Nueve (2009), el 
            Poder Ejecutivo promulgó la Ley marcada con el número 177-09, que otorga 
            competencia a los Inspectores de Trabajo al servicio de la Secretaria de Estado 
            de Trabajo a los fines de comprobar y levantar Actas de Infracción por las 
            violaciones penales cometidas por los empleadores por la no inscripción de sus 
            trabajadores y por la falta de pago de las cotizaciones al Sistema Dominicano de 
            Seguridad Social (SDSS)</span><br />
            <br />
            <strong>POR CUANTO: LA EMPRESA Y/O EMPLEADOR</strong>, se encuentra en atraso de los pagos de las
            Notificaciones de Pago resultantes de las cotizaciones y contribuciones de sus empleados
            al Sistema Dominicano de Seguridad Social, correspondientes a periodos
            comprendidos entre
            <asp:Label ID="lblPeriodoDesde" runat="server"></asp:Label>
            y
            <asp:Label ID="lblPeriodoHasta" runat="server"></asp:Label><strong>.<br />
            <br />
            POR TANTO</strong> y en el entendido de que el presente preámbulo forma parte integra del
            presente contrato, <strong>LAS PARTES<span style="text-decoration: underline">, de manera libre y voluntaria:&nbsp;<br />
            <br />
            </span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;HAN CONVENIDO Y PACTADO LO SIGUIENTE:
                <br />
            </strong>
            <br />
            <strong>
            PRIMERO: OBJETO. Que LA EMPRESA Y/O EMPLEADOR, SE COMPROMETE</strong> a pagar, a más tardar
            el tercer día laborable de cada mes, las cotizaciones atrasadas asignadas en cada
            cuota, por lo que la misma saldará su deuda total en un plazo no mayor de
            <asp:Label ID="lblNroMeses" runat="server" Font-Underline="True" Font-Bold="True"></asp:Label><strong>
            </strong>meses<strong>, </strong><span style="font-family: Arial">mediante la realización
                de los correspondientes pagos mensuales y consecutivos detallados como sigue:
                <br />
                <br />
                </span>
            <asp:GridView ID="gvCuotas" runat="server" AutoGenerateColumns="False" CellPadding="3">
                <Columns>
                    <asp:BoundField DataField="Cuota" HeaderText="Cuota">
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Referencias" HeaderText="Referencias" HtmlEncode="False">
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="FechaLimite" HeaderText="Fecha Limite de Pago" HtmlEncode="False" DataFormatString="{0:dd-MM-yy}">
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
                <br />
            <span style="font-family: Verdana"><span lang="ES-MX" style="mso-fareast-font-family: 'Times New Roman';
                mso-ansi-language: ES-MX; mso-fareast-language: EN-US; mso-bidi-language: AR-SA">
                <strong>
                SEGUNDO: RECARGOS E INTERESES.</strong> </span><span lang="ES-MX" style="mso-fareast-font-family: 'Times New Roman';
                    mso-ansi-language: ES-MX; mso-fareast-language: EN-US; mso-bidi-language: AR-SA">
                    Queda entendido que la concesión de este Acuerdo de Pago no paraliza la aplicación
                    de los recargos e intereses mensuales establecidos en la Ley 87-01 y sus normas
                    complementarias por lo que las cuotas del mismo incluirán los </span></span>
            <span lang="ES-DO" style="font-family: 'Arial','sans-serif'; mso-fareast-font-family: Batang;
                mso-ansi-language: ES-DO; mso-fareast-language: EN-US; mso-bidi-language: AR-SA">
                <span style="font-family: Verdana">recargos e intereses acumulados hasta la fecha efectiva del pago de cada cuota.</span><br />
                <br />
            </span><span style="font-family: Verdana"><strong>
                TERCERO: <u><span style="color: #000000">
                PAGO DE NOTIFICACION DE PAGO VIGENTE</span></u><span style="color: #000000">.
                </span>
            </strong>El presente acuerdo se hace reconociendo que
                LA TESORERIA<span lang="ES-MX"
                    style="mso-ansi-language: ES-MX"><strong><span style="color: #000000"> le permitirá a </span>
                    <b style="mso-bidi-font-weight: normal"><span style="color: #000000">LA EMPRESA Y/O
                        EMPLEADOR</span></b></strong><span style="color: #000000"><strong> </strong>el pago de la (s) notificación (es)
                            de pago
            que se generen en los meses que transcurran en el presente
            acuerdo, 
            conjuntamente con los pagos a realizar por las deudas atrasadas;</span></span><br />
            </span>
            <br />
            <span lang="ES-MX" style="font-family: Verdana; mso-fareast-font-family: 'Times New Roman';
                mso-ansi-language: ES-MX; mso-fareast-language: EN-US; mso-bidi-language: AR-SA">
                <strong>
            CUARTO: DETERMINACION DE DEUDA.</strong></span><span style="font-family: Verdana"><span lang="ES-MX" style="mso-fareast-font-family: 'Times New Roman'; mso-ansi-language: ES-MX; mso-fareast-language: EN-US;
                    mso-bidi-language: AR-SA"> <b style="mso-bidi-font-weight: normal">LA EMPRESA Y/O EMPLEADOR</b>
                    reconoce que los valores
            incluidos en el presente acuerdo han sido calculados de conformidad con las nóminas
            de pago debidamente actualizadas, por lo cual garantiza haber realizado todas las novedades correspondientes
            a dichas Nóminas que aparecen en el Sistema Único de Información y Recaudo (SUIR)
            de <b style="mso-bidi-font-weight: normal">
                        LA TESORERIA</b>, por lo que se compromete a no realizar ninguna modificación a los datos de
            las nóminas ni de las notificaciones de pago objeto del presente acuerdo;
                    <br />
                </span>
            <br />
            <span><strong>QUINTO: FUTURAS AUDITORIAS</strong><span
                style="color: #000000"><strong>.</strong>
                No obstante, </span><b style="mso-bidi-font-weight: normal">
                    <span style="color: #000000">LA EMPRESA Y/O EMPLEADOR</span></b><span> reconoce que
                        <strong>LA TESORERIA</strong>
                            tiene la facultad de realizar cualquier
            comprobación, a fin de verificar si las
                            plantillas de sus nóminas, que sirvieron de base para dichas notificaciones, son verdaderas y correctas,
            pudiendo llegar a determinar diferencias a pagar mediante Auditoria que podría ser
            realizada posteriormente, en cuyo caso realizarían nuevas
                            notificaciones de pago</span><span>&nbsp; que deberán ser pagadas de inmediato</span></span></span><span><span
                                style="font-family: Verdana"><span lang="ES-DO" style="mso-fareast-font-family: Batang;
                                    mso-ansi-language: ES-DO"><span style="color: #000000">;<br />
                                    </span></span>
            <br />
            <span class="style5" lang="ES" 
                style="mso-fareast-font-family: &quot;Times New Roman&quot;; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA">
            SEXTO: INCUMPLIMIENTO. LA EMPRESA Y/O EL EMPLEADOR</span><span class="style4" 
                lang="ES" 
                style="mso-fareast-font-family: &quot;Times New Roman&quot;; mso-ansi-language: ES; mso-fareast-language: ES; mso-bidi-language: AR-SA"> 
            se compromete a cumplir con los pagos mensuales, dentro de las fechas 
            previamente establecidas, ya que en caso de no realizarlos en cualquiera de las 
            fechas mas arriba descritas, el presente acuerdo de pago se considerará
            <b style="mso-bidi-font-weight:normal">INCUMPLIDO</b> y reconoce que <b>LA 
            TESORERIA</b> podrá iniciar un proceso penal tendente al cobro mediante el 
            apoderamiento de los Inspectores de Trabajo de la Secretaria de Estado de 
            Trabajo para la comprobación y el levantamiento del Acta de Infracción 
            correspondiente por las violaciones penales cometidas y el posterior 
            sometimiento por ante el <span style="mso-spacerun:yes">&nbsp;</span>Juzgado de Paz 
            correspondiente para la persecución del cobro integro de todas las 
            Notificaciones de Pago en atraso más los recargos e intereses generados hasta la 
            fecha de ejecución de la sentencia que intervenga en contra de EL EMPLEADOR, en 
            virtud de lo dispuesto por el Artículo 3 y la primera parte del Artículo 4 de la 
            ley 177-09 del 10 de junio del año 2009.</span></span></span><span lang="ES-MX" style="mso-fareast-font-family: 'Times New Roman'; mso-ansi-language: ES-MX;
                                mso-fareast-language: EN-US; mso-bidi-language: AR-SA"><br />
                                <span style="font-family: Verdana"><strong>
            <br />
            Párrafo:</strong> Si en el curso de la ejecución del presente acuerdo <strong>LA TESORERIA</strong> determinare por las fuentes de información establecidas
            en la Ley 87-01, que las informaciones iniciales proporcionadas por <strong>LA EMPRESA Y/O EMPLEADOR</strong> son incorrectas o incompletas se procederá a dejar sin
            efecto el presente acuerdo con las consecuencias establecidas en el presente articulo<br />
                                </span></span>
            <br />
            En la ciudad de Santo Domingo, Distrito Nacional, Capital de la República Dominicana,
            a los 
            <asp:Label ID="lblFechaDia" runat="server" Font-Bold="True" Font-Underline="True"></asp:Label>
            días del mes de
            <asp:Label ID="lblFechaMes" runat="server" Font-Bold="True" Font-Underline="True"></asp:Label>
            del año
            <asp:Label ID="lblFechaAno" runat="server" Font-Bold="True" Font-Underline="True"></asp:Label>.
            <br />
            <br />
            &nbsp; &nbsp;
            POR&nbsp;<br />
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<strong><br />
            </strong>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
            <br />
            &nbsp;<strong> &nbsp;</strong><br />
            <br />
            <table border="0" cellpadding="0" cellspacing="0" style="width: 850px; font-size: 11px;">
                <tr>
                    <td style="text-align: center">
            <asp:Label ID="lblRazonSocial2" runat="server" Font-Bold="True"></asp:Label>
            </td>
                    <td style="text-align: center">
                        <strong> Tesoreria de la Seguridad Social</strong></td>
                </tr>
                <tr>
                    <td style="text-align: center">
                        <br />
                        <br />
                        <br />
                        ______________________________________________
            <br />
            <asp:Label ID="lblNombreRep" runat="server" Font-Bold="True"></asp:Label><br />
            <asp:Label ID="lblCargo" runat="server" Font-Bold="True"></asp:Label><br />
            </td>
                    <td style="text-align: center">
                        <br />
                        <br />
                        ______________________________________________<br />
            <strong> <asp:Label ID="lblFirmante2" runat="server"></asp:Label> </strong>
            <br />
            <strong><asp:Label ID="lblCargoFirmante" runat="server"></asp:Label>
            </strong>
                    </td>
                </tr>
            </table>
            <br />
            <br />
            YO, _______________________________________________, Notario Público de los del Número
            para el Distrito Nacional, con Colegiatura Número _______,con Estudio ubicado en esta ciudad,
            CERTIFICO Y DOY FE: que las firmas que anteceden fueron puesta en mi presencia,
            libre y voluntariamente, por los señores 
            <asp:Label ID="lblNombreRep2" runat="server" Font-Bold="True"></asp:Label>
            y <strong><asp:Label ID="lblFirmante3" runat="server"></asp:Label></strong>, de generales que constan, quienes me han declarado que son las mismas que acostumbran
            a usar en todos sus actos públicos y privados.
            <br />
            <br />
            En la ciudad de Santo Domingo, Distrito Nacional, Capital de la República Dominicana,
            a los 
            <asp:Label ID="lblFechaDia2" runat="server"></asp:Label>
            días del mes de
            <asp:Label ID="lblFechaMes2" runat="server"></asp:Label>
            del año
            <asp:Label ID="lblFechaAno2" runat="server"></asp:Label>.&nbsp;
            <br />
            <br />
            <br />
            <div align="center">
            _________________________________________<br />
            <br />
            <strong>NOTARIO PUBLICO</strong></div></td>
    </tr>
    <tr>
        <td style="text-align: justify;font-family:verdana;font-size:11px; width: 894px;">
            &nbsp;</td>
    </tr>
</table>
<br />
<asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" Visible="False"></asp:Label>
