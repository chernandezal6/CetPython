<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucAcuerdoPagoEmbajadas.ascx.vb" Inherits="Controles_ucAcuerdoPagoEmbajadas" %>
<asp:Panel ID="pnlInfo" runat="server">
<table border="0" cellpadding="0" cellspacing="0" width="850">
    <tr>
        <td style="text-align: justify;font-family:verdana;font-size:11px;">
          <br />
            <strong>Nro: AE-
                <asp:Label ID="lblNroAcuerdo" runat="server" Text="_______"></asp:Label><br />
                <br />
                ACUERDO DE PAGO PARA EMBAJADAS CON DEUDAS PENDIENTES CON EL SISTEMA DOMINICANO DE SEGURIDAD SOCIAL.
                <br />
            </strong>
            <br />
            <strong>ENTRE:</strong> De una parte, la <strong>TESORERÍA DE LA SEGURIDAD SOCIAL, </strong>
            RNC 401517078,
            entidad pública constituida en virtud de la Ley No. 87-01 que crea el Sistema Dominicano
            de Seguridad Social<strong> </strong>(en lo adelante SDSS), con domicilio en la avenida Tiradentes No. 33, sector Naco,
            de esta ciudad de Santo Domingo, Distrito Nacional, debidamente representada por
            el señor <strong>
                <asp:Label ID="lblFirmante1" runat="server"></asp:Label></strong>,
            <asp:Label ID="lblCargo1" runat="server"></asp:Label>
            , <asp:Label ID="lblDatosFirmante" runat="server" ></asp:Label>
            portador de la Cédula de Identidad y Electoral número  <asp:Label ID="lblCedulaFirmante" runat="server"></asp:Label>, quien para
            los fines de este Contrato se denominará <strong>LA TESORERIA</strong> O <strong>LA
                TSS</strong>;
            <br />
            <br />
            Y de la otra parte,
            <asp:Label ID="lblRazonSocial" runat="server" Font-Bold="True"></asp:Label>, RNC
            <asp:Label ID="lblRNC" runat="server"></asp:Label>,
           
          <%--  <asp:Label ID="lblDireccion" runat="server" Font-Bold="False"></asp:Label>, República
            Dominicana,--%> debidamente representado por  el jefe de la misión, 
            <asp:Label ID="lblCargoRepresentante" runat="server"></asp:Label> <asp:Label
                ID="lblNombreRepresentante" runat="server" Font-Bold="True"></asp:Label><strong>, </strong>
            <asp:Label ID="lblNacionalidad" runat="server"></asp:Label><strong>, mayor de edad,
            </strong>
            <asp:Label ID="lblEstadoCivil" runat="server"></asp:Label><strong> portador de&nbsp;
            </strong>
            <asp:Label ID="lblDescCedulaoPasaporte" runat="server" Text="la Cédula de Identidad y Electoral"></asp:Label><strong>
               &nbsp;   No.</strong>&nbsp;
            <asp:Label ID="lblNroCedulaoPasaporte" runat="server"></asp:Label><strong> con su domicilio social
            ubicado en <asp:Label ID="lblDireccion" runat="server" Font-Bold="False"></asp:Label>, <%--<asp:Label ID="LblProvincia" runat="server" Font-Bold="False"></asp:Label>,--%> República
            Dominicana, quien en
                lo que sigue del presente Contrato se denominará LA EMBAJADA</strong>;
            cuando este contrato se refiera conjuntamente a ambas partes serán denominadas <strong>
                LAS PARTES.<br />
                <br />
                POR CUANTO: A que en fecha nueve (09) del mes mayo del año Dos Mil Uno (2001), el
                Poder Ejecutivo promulgó la Ley marcada con el número 87-01, que crea el Sistema
                Dominicano de Seguridad Social, la cual en su Artículo 28, otorga a la TESORERIA
                DE LA SEGURIDAD SOCIAL</strong>, la función de “Administrar el Sistema Único
            de Información, mantener los registros actualizados sobre los empleadores y sus
            afiliados y sobre los beneficiarios de los tres regimenes de financiamiento, recaudar
            distribuir y asignar los recursos del SDSS, ejecutar por cuenta del consejo Nacional
            de Seguridad Social (en lo adelante CNSS) el pago
            a todas las instituciones participantes, públicas, privadas y/o mixtas, garantizando regularidad,
            transparencia, seguridad, eficiencia e igualdad, detectar la mora, evasión y elusión
            combinando otras fuentes de información gubernamental o privada”.<br />
            <br />
             
                POR CUANTO: A que en fecha veintidós (22) del mes de junio del año Dos Mil Nueve (2009), el
                Poder Ejecutivo promulgó la Ley marcada con el número 177-09, que otorga competencia a los
                Inspectores de Trabajo al servicio de la Secretaria de Estado de Trabajo a los fines de 
                comprobar y levantar Actas de Infracción por las violaciones penales cometidas por la
                no inscripción de sus trabajadores y por la falta de pago de las cotizaciones al 
                Sistema Dominicano de Seguridad Social (SSDS).<br />
            <br />

            <strong>POR CUANTO: LA EMBAJADA</strong>, se encuentra en atraso de los pagos de las
            Notificaciones de Pago resultantes de las cotizaciones y contribuciones de sus empleados
            al Sistema Dominicano de Seguridad Social, correspondientes a periodos
            comprendidos entre
            <asp:Label ID="lblPeriodoDesde" runat="server"></asp:Label>
            y
            <asp:Label ID="lblPeriodoHasta" runat="server"></asp:Label>.<br />
            
            <br />
           
            <br />
            <strong>HAN CONVENIDO Y PACTADO LO SIGUIENTE:
                <br />
            </strong>
            <br />
           <strong> PRIMERO: OBJETO. Que LA EMBAJADA, SE COMPROMETE</strong> a pagar, a más tardar
            el tercer día laborable de cada mes, las cotizaciones atrasadas asignadas en cada
            cuota, por lo que la misma saldará en un plazo no mayor de
            <asp:Label ID="lblNroMeses" runat="server"></asp:Label><strong> meses, mediante la realización
                de los correspondientes pagos mensuales y consecutivos detallados como sigue:
                <br />
                <br />
            </strong>
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
            <strong>
                SEGUNDO: RECARGOS E INTERESES. </strong>Queda entendido que la concesión de este Acuerdo de Pago no
                paraliza la aplicación de los recargos e intereses mensuales establecidos en la Ley 87-01 y sus normas
                complementarias por lo que las cuotas del mismo incluirán los recargos e intereses acumulados hasta la
                fecha del pago de cada cuota.
                <br />
                <br />
            <strong>
                TERCERO: PAGO DE NOTIFICACION DE PAGO VIGENTE.</strong> el presente acuerdo se hace reconociendo que
                LA TESORERIA le permitirá a LA EMBAJADA el pago de la(s) notificacion(es) de pago
            que se generen en los meses que transcurran en el presente
            acuerdo, conjuntamente con los pagos a realizar por las deudas atrasadas;
            <br />
            <br />
            <strong>
            CUARTO: DETERMINACION DE DEUDA.</strong> Que LA EMBAJADA reconoce que los valores
            incluidos en el presente acuerdo han sido calculados de conformidad con las nóminas
            de pago debidamente actualizadas, por lo cual garantiza haber realizado todas las novedades correspondientes
            a dichas Nóminas que aparecen en el Sistema Único de Información y Recaudo (SUIR)
            de <strong> LA TESORERIA</strong>, por lo que se compromete a no realizar ninguna modificación a los datos de
            las nóminas ni de las notificaciones de pago objeto del presente acuerdo;
            <br />
            <br />
            <strong>QUINTO: FUTURAS AUDITORIAS</strong>. Que no obstante, LA EMBAJADA
            reconoce que <strong>LA TESORERIA </strong>tiene la facultad de realizar cualquier
            comprobación, a fin de verificar si las plantillas de sus nóminas, que sirvieron de base para dichas notificaciones son verdaderas y correctas,
            pudiendo llegar a determinar diferencias a pagar mediante Auditoria que podría ser
            realizada posteriormente, en cuyo caso realizarían nuevas notificaciones de pago que deberán ser pagadas de inmediato.
            <br />
            <br />
            <strong>
            SEXTO: Nada de lo previsto en el presente acuerdo constituye o deberá interpretarse como 
            una renuncia, ya sea tácita o expresa, a los privilegios e inmunidades conferidos a LA EMBAJADA
            conforme a la Convención de Viena sobre Relaciones Diplomáticas. </strong>
            <br />
            <br />
            
            <br />
            En la ciudad de Santo Domingo, Distrito Nacional, Capital de la República Dominicana,
            a los 
            <asp:Label ID="lblFechaDia" runat="server"></asp:Label>
            días del mes de
            <asp:Label ID="lblFechaMes" runat="server"></asp:Label>
            del año
            <asp:Label ID="lblFechaAno" runat="server"></asp:Label>.
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
            para el Distrito Nacional, con Colegiatura Número _______, portador de la cédula
            de identidad y electoral número _____________________________________, con Estudio ubicado en esta ciudad,
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
            <br />
            <div align="center">
            _________________________________________<br />
            <br />
            <strong>NOTARIO PUBLICO</strong></div></td>
    </tr>
</table>
</asp:Panel>
<br />
<asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" Visible="False"></asp:Label>
