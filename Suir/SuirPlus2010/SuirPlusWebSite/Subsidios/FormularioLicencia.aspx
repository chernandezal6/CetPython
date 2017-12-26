<%@ Page Language="VB" AutoEventWireup="false" CodeFile="FormularioLicencia.aspx.vb"
    EnableTheming="false" Inherits="Subsidios_FormularioLicencia" %>
<head id="Head1" runat="server" />
<style type="text/css">
    .style2
    {
        width: 30px;
    }
    .style3
    {
        height: 0px;
        width: 30px; 
    }
    .style4
    {
        width: 45px;
    }
    .style5
    {
        height: 0px;
        width: 45px;
    }
    .style6
    {
        width: 44px;
    }
    .style7
    {
        height: 0px;
        width: 44px;
    }
    .style8
    {
        width: 163px;
    }
    .style9
    {
        width: 66%;
    }
    .style10
    {
        width: 32%;
    }
    .style11
    {
        width: 34%;
    }
    .checkStyle
    {
        font-size: 10px;
        height: 14px;
        width: 17px;
    }
</style>
<form id="form1" runat="server">
<table width="750px">
    <tr>
        <td align="left" style="text-align: left; width: 30%;">
            <span id="lblFechaEmision" style="font-style: italic">
                <asp:label id="lblFechaEmision" runat="server" style="font-style: italic"></asp:label>
            </span>
        </td>
        <td align="center" style="text-align: center;">
            <span id="lblNumeroFormulario" style="font-weight: 700; font-size: x-large;">
                <asp:label id="lblNumeroFormulario" runat="server" style="font-weight: 700; font-size: medium;"></asp:label>
            </span>
        </td>
    </tr>
</table>
<table border="1" cellspacing="0" cellpadding="0" frame="box" width="665px">
    <tr>
        <td bgcolor="#F0F0F0" style="text-align: center; height: 21px;" valign="top">
            <span style="font-weight: 600; font-size: 15px">SUPERINTENDENCIA DE SALUD Y RIESGOS
                LABORALES
                <br />
                FORMULARIO DE SOLICITUD DE SUBSIDIOS POR LICENCIA PRE Y POST NATAL</span>
            <br />
            <input id="Checkbox1" type="checkbox" style="font-size: 12px" onclick="return false;">Licencia
                Pre-Natal</input>
            &nbsp;&nbsp;&nbsp;
            <input id="Checkbox2" type="checkbox" style="font-size: 12px" onclick="return false;">Licencia
                Post-Natal</input>
        </td>
    </tr>
    <tr>
        <td bgcolor="#F0F0F0" valign="top" style="height: 17px">
            &nbsp; <span style="font-size: larger"> <b>1. IDENTIFICACION TRABAJADORA AFILIADA</b></span></b><br />
        </td>
    </tr>
    <tr>
        <td valign="top" height="25px;">
            <table style="width: 100%; height: 25px;" border="1" cellspacing="0" cellpadding="0"
                frame="void">
                <tr style="font-size: 12px">
                    <td valign="top" width="66%">
                        &nbsp;Número de Cédula: &nbsp;<span id="lblCedulaAfiliado" style="font-size: 11px;
                            font-weight: 700;"></span>
                        <asp:label id="lblCedulaAfiliado" runat="server" style="font-size: 11px; font-weight: 700;"></asp:label>
                        <br />
                    </td>
                    <td valign="top" width="40%">
                        &nbsp; NSS:
                        <asp:label id="lblNSS" runat="server" style="font-size: 11px; font-weight: 700;"></asp:label>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td valign="top" style="height: 25px">
            &nbsp; <span style="font-size: 12px">Nombres y Apellidos: </span>
            <asp:label id="lblNombreAfiliado" runat="server" style="font-size: 11px; font-weight: 700;"></asp:label>
        </td>
    </tr>
    <tr>
        <td border="0" cellspacing="0" cellpadding="0">
            <div id="divAmbulatoria">
                <table border="1" cellspacing="0" cellpadding="0" width="100%" frame="void">
                    <tr>
                        <td bgcolor="#F0F0F0" valign="top" style="height: 19px;">
                            &nbsp;<span style="font-size: larger"><b> 2. IDENTIFICACION DEL MEDICO TRATANTE Y LA PSS</b></span><br />
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" style="width: 100%; height: 31px;">
                            <table style="width: 100%;" border="1" cellspacing="0" cellpadding="0" frame="void">
                                <tr style="font-size: 12px; height: 31px;">
                                    <td valign="top" class="style9">
                                        &nbsp;Número de Cédula(*):
                                        <br />
                                        <br />
                                    </td>
                                    <td valign="top" style="width: 40%">
                                        &nbsp; Número de Exequatur:<span id="lblExequatur" style="font-style: italic"></span>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" style="width: 550px; height: 31px;">
                            &nbsp; <span style="font-size: 12px">Nombre del Médico: <span id="lblNombreMedico"
                                style="font-style: italic">
                                <br />
                            </span></span>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" style="width: 100%; height: 45px;">
                            <span style="font-size: 12px">&nbsp;Dirección Consultorio(*): <span id="lblDireccionConsultorio"
                                style="font-style: italic"></span></span>
                            <br />
                            <br />
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" width="100%" height="31px;">
                            <table border="1" cellpadding="0" cellspacing="0" frame="void" width="100%" style="height: 31px;">
                                <tr>
                                    <td valign="top" class="style11">
                                        &nbsp;<span style="font-size: 12px">Teléfono Consultorio(*):</span>&nbsp;<br />
                                        <br />
                                    </td>
                                    <td valign="top" class="style10">
                                        &nbsp;<span style="font-size: 12px">&nbsp;Celular: <span id="lblCelularMedico" style="font-style: italic">
                                        </span></span>
                                        <br />
                                        <br />
                                    </td>
                                    <td valign="top" style="width: 40%;">
                                        &nbsp;<span style="font-size: 12px">&nbsp;Email: <span id="lblEmailMedico" style="font-style: italic">
                                        </span></span>
                                        <br />
                                        <br />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="divHospitalizacion">
                <table border="1" cellpadding="0" cellspacing="0" width="100%" frame="above">
                    <tr>
                        <td style="width: 550px; height: 31px;" valign="top">
                            <span style="font-size: 12px">&nbsp;Nombre de la PSS(*): <span id="lblNombrePSS" style="font-style: italic">
                                <br />
                            </span></span>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 550px; height: 47px;" valign="top">
                            &nbsp;<span style="font-size: 12px">Dirección de la PSS(*):</span> <span id="lblDireccionPSS"
                                style="font-style: italic"></span>&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" width="100%">
                            <table border="1" cellpadding="0" cellspacing="0" frame="void" width="100%" style="height: 31px;">
                                <tr>
                                    <td valign="top" class="style11">
                                        &nbsp;<span style="font-size: 12px">Teléfono de la PSS(*):
                                            <br />
                                        </span>
                                        <br />
                                    </td>
                                    <td valign="top" class="style10">
                                        &nbsp;<span style="font-size: 12px">&nbsp;Número de Fax: <span id="lblFaxPSS" style="font-style: italic">
                                        </span></span>
                                    </td>
                                    <td valign="top" width="40%">
                                        <span style="font-size: 12px">&nbsp;Email: <span id="lblEmailPSS" style="font-style: italic">
                                        </span></span>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
    <tr>
        <td bgcolor="#F0F0F0" valign="top" style="height: 19px;">
            <b style="font-size: larger">&nbsp; 3. DETALLE DE LA LICENCIA </b>&nbsp;<br />
        </td>
    </tr>
    <tr>
        <td colspan="2" style="height: 47px;" valign="top">
            &nbsp;<span style="font-size: 12px">Diagnóstico Principal:&nbsp;<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            </b></span>
        </td>
    </tr>
    <tr>
        <td valign="top" style="height: 31px;">
            <table border="1" cellpadding="0" cellspacing="0" frame="void" style="width: 100%;
                height: 31px;">
                <tr>
                    <td valign="top" class="style11">
                        <span style="font-size: 12px">&nbsp;Fecha de inicio de Licencia(*) :</span> &nbsp;
                        <br />
                        <br />
                    </td>
                    <td valign="top" class="style10">
                        <span style="font-size: 12px">&nbsp;Fecha de Diagnóstico: <span id="lblFaxPSS0" style="font-style: italic">
                        </span></span>
                    </td>
                    <td valign="top" width="60%" style="width: 100%">
                        <span style="font-size: 12px">&nbsp;Tiempo de Licencia:</span>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td bgcolor="#F0F0F0" valign="top" style="height: 19px;">
            <b style="font-size: larger">&nbsp; 4. DETALLE DEL(LOS) NACIMIENTO(S)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                (</b><span style="font-size: larger"><em><strong>Requerido si es Licencia Post Natal</strong></em></span><b
                    style="font-size: larger">)</b>
        </td>
    </tr>
    <tr>
        <td>
            <table border="1" cellpadding="0" cellspacing="0" frame="void" style="width: 100%;
                height: 31px;">
                <tr>
                    <td valign="top" class="style9">
                        <span style="font-size: 12px">&nbsp;Fecha de inicio de Licencia(*) :</span> &nbsp;
                        <br />
                        <br />
                    </td>
                    <td valign="top" width="60%" style="width: 100%">
                        <span style="font-size: 12px">&nbsp;Fecha de Nacimiento:</span>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td valign="top" style="height: 31px;">
            <table border="1" cellpadding="0" cellspacing="0" frame="void" style="width: 100%;
                height: 31px;">
                <tr>
                    <td valign="top" class="style2">
                        <span style="font-size: 12px; font-weight: 700;">&nbsp;Sexo</span>
                    </td>
                    <td valign="top" class="style4">
                        <span style="font-size: 12px; font-weight: 700;">&nbsp;NUI</span>
                    </td>
                    <td valign="top" class="style6">
                        <span style="font-size: 12px; font-weight: 700;">&nbsp;NSS</span>
                    </td>
                    <td valign="top" class="style8">
                        <span style="font-size: 12px; font-weight: 700;">&nbsp;Nombre(s)</span>
                    </td>
                    <td valign="top" valign="top" style="width: 150px">
                        <span style="font-size: 12px; font-weight: 700;">&nbsp;Apellidos</span>
                    </td>
                </tr>
                <tr>
                    <td valign="top" class="style3">
                        <input id="Checkbox3" type="checkbox" class="checkStyle" onclick="return false;" />
                        F</br>
                        <input id="Checkbox4" type="checkbox" class="checkStyle" onclick="return false;" />
                        M
                    </td>
                    <td valign="top" class="style5">
                        &nbsp;
                    </td>
                    <td valign="top" class="style7">
                        &nbsp;
                    </td>
                    <td valign="top" class="style8">
                        &nbsp;
                    </td>
                    <td valign="top" valign="top" style="height: 31px; width: 150px;">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td valign="top" class="style3">
                        <input id="Checkbox5" type="checkbox" class="checkStyle" onclick="return false;" />
                        F </br>
                        <input id="Checkbox6" type="checkbox" class="checkStyle" onclick="return false;" />
                        M
                    </td>
                    <td valign="top" class="style5">
                        &nbsp;
                    </td>
                    <td valign="top" class="style7">
                        &nbsp;
                    </td>
                    <td valign="top" class="style8">
                        &nbsp;
                    </td>
                    <td valign="top" valign="top" style="height: 31px; width: 150px;">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td valign="top" class="style3">
                        <input id="Checkbox7" type="checkbox" class="checkStyle" onclick="return false;" />
                        F </br>
                        <input id="Checkbox8" type="checkbox" class="checkStyle" onclick="return false;" />
                        M
                    </td>
                    <td valign="top" class="style5">
                        &nbsp;
                    </td>
                    <td valign="top" class="style7">
                        &nbsp;
                    </td>
                    <td valign="top" class="style8">
                        &nbsp;
                    </td>
                    <td valign="top" valign="top" style="height: 31px; width: 150px;">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td valign="top" class="style3">
                        <input id="Checkbox9" type="checkbox" class="checkStyle" onclick="return false;" />
                        F </br>
                        <input id="Checkbox10" type="checkbox" class="checkStyle" onclick="return false;" />
                        M
                    </td>
                    <td valign="top" class="style5">
                        &nbsp;
                    </td>
                    <td valign="top" class="style7">
                        &nbsp;
                    </td>
                    <td valign="top" class="style8">
                        &nbsp;
                    </td>
                    <td valign="top" valign="top" style="height: 31px; width: 150px;">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td valign="top" class="style3">
                        <input id="Checkbox11" type="checkbox" class="checkStyle" onclick="return false;" />
                        F </br>
                        <input id="Checkbox12" type="checkbox" class="checkStyle" onclick="return false;" />
                        M
                    </td>
                    <td valign="top" class="style5">
                        &nbsp;
                    </td>
                    <td valign="top" class="style7">
                        &nbsp;
                    </td>
                    <td valign="top" class="style8">
                        &nbsp;
                    </td>
                    <td valign="top" valign="top" style="height: 31px; width: 150px;">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td valign="top" class="style3">
                        <input id="Checkbox13" type="checkbox" class="checkStyle" onclick="return false;" />
                        F </br>
                        <input id="Checkbox14" type="checkbox" class="checkStyle" onclick="return false;" />
                        M
                    </td>
                    <td valign="top" class="style5">
                        &nbsp;
                    </td>
                    <td valign="top" class="style7">
                        &nbsp;
                    </td>
                    <td valign="top" class="style8">
                        &nbsp;
                    </td>
                    <td valign="top" valign="top" style="height: 31px; width: 150px;">
                        &nbsp;
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td valign="top">
            <table border="1" cellpadding="0" cellspacing="0" frame="void" style="width: 100%">
                <tr>
                    <td style="height: 68px; text-align: center;" valign="top" width="%">
                        <br />
                        <br />
                        ________________________________________________________________
                        <br />
                        <span style="font-size: 12px">Firma y Sello del Médico Tratante(*)</span>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
(*)Nota: Los campos marcados con asterisco son obligatorios &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;<asp:label id="lblHash" runat="server" style="font-size: 11px; font-weight: 700;"></asp:label><br /><br />

Al presentar esta solicitud debidamente completada, firmada y sellada, tanto el empleador como el trabajador (a), 
<br />
declaran, bajo la fe del juramento,que las informaciones suministradas son veraces y que se ha dado fiel 
cumplimiento 
<br />
a los requisitos establecidos  por la Ley 87-01,  Reglamentos y Resoluciones vigentes, 
para la entrega 
<br />
de los subsidios del Régimen Contributivo del Seguro Familiar de Salud (SFS).
</form>
 <body onload="javascript: print();">