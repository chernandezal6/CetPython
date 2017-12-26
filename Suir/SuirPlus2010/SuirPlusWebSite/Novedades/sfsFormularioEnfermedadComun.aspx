<%@ Page Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false" CodeFile="sfsFormularioEnfermedadComun.aspx.vb" Inherits="Novedades_sfsFormularioEnfermedadComun" title="Formulario de Solicitud de Subsidio por Enfermedad Comun" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <body onload="javascript: print();">
    <table width="750px" >
        <tr>
            <td align="left" style="text-align: left; width: 30%;">
                <asp:Label ID="lblFechaEmision" runat="server" style="font-style: italic" ></asp:Label>
            </td>
            
            <td align="center" style="text-align: center; ">

                <asp:Label ID="lblNumeroFormulario" runat="server" style="font-weight: 700; font-size: x-large;" ></asp:Label>
            </td>
                    
        </tr>
    </table>
    <table border="1" cellSpacing="0" cellPadding="0" frame="box" width="665px" >
        <tr>
            <td bgcolor="#F0F0F0" style="text-align: center; height: 21px;" valign="top" 
                colspan="2">
                &nbsp;&nbsp;
                <span style="font-weight: 700; font-size: 19px">SUPERINTENDENCIA DE SALUD Y RIESGOS LABORALES <br />
                FORMULARIO DE SOLICITUD DE SUBSIDIO POR ENFERMEDAD COMUN</span>
                <br />
                <asp:CheckBox ID="ckPrimeraSolicitud" runat="server" Text="Primera Solicitud" 
                    onClick="return false;"/>
                &nbsp;&nbsp;&nbsp;
                <asp:CheckBox ID="ckRenovacion" runat="server" Text="Renovación" onClick="return false;" />
            </td>
        </tr>
        <tr>
            <td colspan="2" bgcolor="#F0F0F0" valign="top" style="height: 17px">
               &nbsp; <b><span style="font-size: larger">IDENTIFICACION TRABAJADOR(A) AFILIADO(A)</b></span></b><br />
            </td>
        </tr>
        <tr>
            <td colspan="2" valign="top" height="31px;">
                <table style="width:100%; height: 31px;" border="1" cellSpacing="0" cellPadding="0" 
                    frame="void" >
                             <tr style="font-size: 12px">
                        <td valign="top" width="30%">
                             &nbsp;Número de Cédula: &nbsp;<asp:Label ID="lblCedulaAfiliado" runat="server" 
                        style="font-size: 11px; font-weight: 700;" ></asp:Label>   
                             <br />
                        </td>
                        <td valign="top" width="30%">
                        &nbsp;NSS: &nbsp;<asp:Label ID="lblNSS" runat="server" 
                        style="font-size: 11px; font-weight: 700;" ></asp:Label>   
                             <br />
                        </td>
                         <td valign="top" width="40%">
                             &nbsp;
                             Sexo:&nbsp;<asp:CheckBox ID="ckM" runat="server" Text="M" 
                                 onClick="return false;" />
                               &nbsp;
                            <asp:CheckBox ID="ckF" runat="server" Text="F" onClick="return false;" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td colspan="2" valign="top" style="height: 31px">
                &nbsp;
            <span style="font-size: 12px" >Nombres y Apellidos:
                <asp:Label ID="lblNombreAfiliado" runat="server" style="font-weight: 700;" ></asp:Label>   
                
                </span>
            </td>
        </tr>
        <tr>
            <td colspan="2" border="0" cellSpacing="0" cellPadding="0">
                <div id="divAmbulatoria" runat="server">
                <table border="1" cellSpacing="0" cellPadding="0" width="100%" frame="void">
                    <tr>
                        <td bgcolor="#F0F0F0" valign="top" style="height: 19px;">
                       &nbsp; IDENTIFICACION DEL MEDICO TRATANTE Y LA PSS</b><br />
                        </td>
                    </tr>
                     <tr>
                        <td valign="top" style="width: 100%; height: 31px;">
                <table style="width:100%;" border="1" cellSpacing="0" cellPadding="0" 
                    frame="void" >
                             <tr style="font-size: 12px; height: 31px;">
                                 <td valign="top" style="width: 60%">
                                     &nbsp;Número de Cédula(*):</td>
                                 <td valign="top" style="width: 40%">
                                     &nbsp;
                                     Número de Exequatur:<asp:Label ID="lblExequatur" runat="server" style="font-style: italic" ></asp:Label>   
                        </td>
                    </tr>
                </table>
                        </td>
                    </tr>
                     <tr>
                        <td valign="top" style="width: 550px; height: 31px;">
                            &nbsp;
                        <span style="font-size: 12px" >Nombre del Médico:
                            <asp:Label ID="lblNombreMedico" runat="server" style="font-style: italic" ></asp:Label>   
                        </span>
                            <br />
                            <br />
                        </td>
                    </tr>
                     <tr>
                        <td valign="top" style="width: 100%; height: 45px;">
                            <span style="font-size: 12px" >&nbsp;Dirección Consultorio(*):
                                                                                            <asp:Label ID="lblDireccionConsultorio" runat="server" style="font-style: italic" ></asp:Label>   
                            </span>
                            <br /><br />
                        </td>
                    </tr>
                     <tr>
                        <td valign="top" width="100%" height="31px;">
                            <table border="1" cellpadding="0" cellspacing="0" frame="void" width="100%" 
                                style="height: 31px;">
                                <tr>
                                    <td valign="top" style="width: 30%; ">
                                        &nbsp;<span style="font-size: 12px" >Teléfono Consultorio(*):</span>&nbsp;<br /></td>
                                    <td valign="top" style="width: 30%">
                                        &nbsp;<span style="font-size: 12px" >&nbsp;Celular:
                                                <asp:Label ID="lblCelularMedico" runat="server" style="font-style: italic" ></asp:Label>   
                                            </span>
                                            <br /><br /></td>
                                    <td valign="top" style="width: 40%; " >
                                        &nbsp;<span style="font-size: 12px" >&nbsp;Email:
                                                <asp:Label ID="lblEmailMedico" runat="server" style="font-style: italic" ></asp:Label>   
                                            </span>
                                            <br /><br /></td>
                                </tr>
                            </table>
                         </td>
                      </tr>
                       </table>
                </div>
                  <div id="divHospitalizacion" runat="server">
                    <table border="1" cellpadding="0" cellspacing="0" width="100%" frame="above">
                      <tr>
                        <td style="width: 550px; height: 31px;" valign="top">
                         <span style="font-size: 12px" >&nbsp;Nombre de la PSS:
                            
                            <asp:Label ID="lblNombrePSS" runat="server" style="font-style: italic"></asp:Label>   
                            
                        </span><br />&nbsp;
                        </td>
                      </tr>
                      <tr>
                        <td style="width: 550px; height: 47px;" valign="top">
                            &nbsp;<span style="font-size: 12px" >Dirección de la PSS(*):
                                <asp:Label ID="lblDireccionPSS" runat="server" 
                                style="font-style: italic" ></asp:Label>   
                            
           &nbsp;
                        </td>
                      </tr>
                      <tr>
                        <td valign="top" width="100%">
                            <table border="1" cellpadding="0" cellspacing="0" frame="void" width="100%" 
                                style="height: 31px;">
                                <tr>
                                    <td valign="top" width="30%">
                                        &nbsp;<span style="font-size: 12px" >Teléfono de la PSS(*):
                                        <br />
                                    </span>
                                    <br /></td>
                                    <td valign="top" width="30%">
                                        &nbsp;<span style="font-size: 12px" >&nbsp;Número de Fax:
                                                <asp:Label ID="lblFaxPSS" runat="server" style="font-style: italic" ></asp:Label>   
                                            </span>
                                        <br />
                                                 </td>
                                    <td valign="top" width="40%">
                                        <span style="font-size: 12px" >&nbsp;Email:
                                                <asp:Label ID="lblEmailPSS" runat="server" style="font-style: italic" ></asp:Label>   
                                            </span>
                                    <br /></td>
                                </tr>
                            </table>
                        </td>
                      </tr>
                    </table>
                  </div>
            </td>
        </tr>
        <tr>
            <td colspan="2" bgcolor="#F0F0F0" valign="top" style="height: 19px;">
                <b style="font-size: larger">&nbsp; DATOS MEDICOS QUE DAN ORIGEN A LA DISCAPACIDAD 
                LABORAL
                     LABORAL
                </b> &nbsp;<br />
            </td>
                 </tr>
       <tr>
       <td colspan="2" style="height: 24px">
           &nbsp;<span style="font-size: 12px" >Tipo:&nbsp;<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </b></span>
           <asp:CheckBox ID="ckEnfermedadComun" runat="server" 
               Text="Enfermedad Común" style="font-size: 12px" onClick="return false;" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
           <asp:CheckBox ID="ckAccidenteNoLaboral" runat="server" style="font-size: 12px" 
               Text="Accidente No Laboral" onClick="return false;" />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
           <asp:CheckBox ID="ckDiscapacidadPorEmbarazo" runat="server" 
               style="font-size: 12px" Text="Discapacidad Por Embarazo" />
                </td>
       </tr>
       <tr>
       <td colspan="2" valign="top" style="height: 60px">
           &nbsp;<span style="font-size: 12px" >Diagnóstico principal(*):<b><br />
           <br />
           <br />
                </b></span></td>
       </tr>
       <tr>
       <td colspan="2" style="height: 65px" valign="top"> 
           <span style="font-size: 12px" >&nbsp;Signos y Síntomas: </span><br />&nbsp;<br />
           </td>
       </tr>
        <tr>
       <td colspan="2" valign="top" style="height: 58px">
           <span style="font-size: 12px" >&nbsp;Procedimientos Realizados: </span><br />
           <br />
           <br />
                </td>
        </tr>
        <tr>
       <td valign="middle" style="height: 24px; " width="70%">
           <span style="font-size: 12px" >&nbsp;Modalidad (Marque ambas si aplican las dos) &nbsp; </span>
           <asp:CheckBox ID="ckAmbulatoria" runat="server" Text="Ambulatoria" 
               style="font-size: 12px;" onClick="return false;" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:CheckBox ID="ckHospitalizacion" runat="server" 
               Text="Hospitalización" style="font-size: 12px;" onClick="return false;" />
                     </td>
                     <td style="width: 30%;" width="30%"><span style="font-size: 12px" >&nbsp;Código CIE-10:&nbsp;</span></td>
        </tr>
        <tr>
       <td colspan="2" valign="top" style="height: 31px;">
                            <table border="1" cellpadding="0" cellspacing="0" frame="void" 
                                style="width: 100%; height: 31px;">
                                <tr>
                                    <td valign="top" width="60%">
                                        <span style="font-size: 12px">&nbsp;Fecha de inicio de Licencia o Renovación Ambulatoria(*):</span></td>
                                    <td valign="top" width="40%">
                                        &nbsp;<span style="font-size: 12px" >&nbsp; Días Calendarios Ambulatorios:</span></td>
                                </tr>
                            </table>
                        </td>
        </tr>
        <tr>
       <td colspan="2" valign="top" style="height: 31px;">
                            <table border="1" cellpadding="0" cellspacing="0" frame="void" 
                                style="width: 100%; height: 31px;">
                                <tr>
                                    <td valign="top" width="60%">
                                        <span style="font-size: 12px" >&nbsp;Fecha de inicio de Licencia o Renovación Hospitalaria(*): o Renovación Hospitalaria(*):</span></td>
                                    <td valign="top" width="40%">
                                        &nbsp;<span style="font-size: 12px" >&nbsp; Días Calendarios de Hospitalización:</span></td>
                                </tr>
                            </table>
                        </td>
        </tr>
        <tr>
       <td colspan="2" valign="top">
                            <table border="1" cellpadding="0" cellspacing="0" frame="void" 
                                style="width: 100%">
                                <tr>
                                    <td style="height: 68px;" valign="top" width="%">
                                        <span style="font-size: 12px" >&nbsp;Fecha de Diagnóstico:&nbsp;</span></td>
                                    <td style="height: 68px;" valign="bottom" align="center" width="70%">
                                        <br />
                                        ________________________________________________________________    <br />
                                        <span style="font-size: 12px" >Firma y Sello del Médico Tratante(*)</span></td>
                                </tr>
                            </table>
                        </td>
        </tr>
       </table>
        (*)Nota: Los campos marcados con asterisco son obligatorios&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
        &nbsp;<asp:Label ID="lblHash" runat="server"  ></asp:Label>
        <br />
    <br />

    Al presentar esta solicitud debidamente completada, firmada y sellada, tanto el empleador como el trabajador (a), 
    <br />
    declaran, bajo la fe del juramento,que las informaciones suministradas son veraces y que se ha dado fiel 
    cumplimiento 
    <br />
    a los requisitos establecidos  por la Ley 87-01,  Reglamentos y Resoluciones vigentes, 
    para la entrega 
    <br />
    de los subsidios del Régimen Contributivo del Seguro Familiar de Salud (SFS).
        
</asp:Content>

