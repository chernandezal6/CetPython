<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsInicioEnfermedadComun.aspx.vb" Inherits="Novedades_sfsInicioEnfermedadComun" title="Inicio Enfermedad Comun" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<br />
<br />
<span class="header" >Licencia por Enfermedad Común</span>
<br />
<br />
<fieldset style="width:980px; " >
<legend class="header" style="font-size: 14px" align="left">Inicio</legend>
<br />
    <table width="60%">
        <tr>
            <td width="33%">
                <table class="td-content" style="margin-left: 10px; width: 300px">
                    <tr>
                    <td style="width: 117px">
                        <img alt="" src="../images/Medico1.jpg" /></td>
                        <td>
                            <br />
                            <asp:HyperLink ID="HyperLink1" runat="server" 
                                style="font-size: 14px; font-weight: bold; color:#016BA5; font-family: Arial" 
                                NavigateUrl="~/Novedades/sfsEnfermedadComun.aspx" Target="_self">
                            Registrar <br />
                            Padecimiento <br />
                            Nuevo
                            </asp:HyperLink>
                            <br />
                            <br />
                        </td>
                    </tr>
                </table>
                <span style="margin-left: 10px; font-size: 10px" class="header">Crear una solicitud en base a un padecimiento </span>
                <br />
                <span style="margin-left: 10px; font-size: 10px" class="header">nuevo para generar un Registro de Enfermedad  </span>
                <br />
                <span style="margin-left: 10px; font-size: 10px" class="header">Común con un nuevo número de formulario</span>
                <br />
                </td>
            <td width="33%">
                <table class="td-content" style="margin-left: 10px; width: 300px">
                    <tr>
                    <td style="width: 117px">
                        <img alt="" src="../images/Medico2.jpg" /></td>
                        <td>
                            <br />
                            <asp:HyperLink ID="HyperLink2" runat="server" 
                                style="font-size: 14px; font-weight: bold; color:#016BA5; font-family: Arial" 
                                NavigateUrl="~/Novedades/sfsEnfermedadComun.aspx" Target="_self">
                            Renovar <br />
                            Padecimiento <br />
                            Reportado
                            </asp:HyperLink>
                            <br />
                            <br />
                        </td>
                    </tr>
                </table>
               <span style="margin-left: 10px; font-size: 10px" class="header">Crear una solicitud en base a un padecimiento </span>
                <br />
                <span style="margin-left: 10px; font-size: 10px" class="header">existente para generar un Registro de Enfermedad  </span>
                <br />
                <span style="margin-left: 10px; font-size: 10px" class="header">Común con un nuevo número de formulario</span>
                <br />
                </td>
            <td width="33%">
                <table class="td-content" style="margin-left: 10px; width: 300px">
                    <tr>
                    <td style="width: 117px">
                        <img alt="" src="../images/Medico3.jpg" /></td>
                        <td>
                            <br />
                            <asp:HyperLink ID="HyperLink3" runat="server" 
                                style="font-size: 14px; font-weight: bold; color:#016BA5; font-family: Arial" 
                                NavigateUrl="~/Novedades/sfsEnfConvalidarPadecimiento.aspx" Target="_self">
                            Convalidar<br />
                            Padecimiento <br />
                            Existente
                            </asp:HyperLink>
                            <br />
                            <br />
                        </td>
                    </tr>
                </table>
                <span style="margin-left: 10px; font-size: 10px" class="header">Aplicar para el 
                Subsidio de Enfermedad Común</span><br />
                <span style="margin-left: 10px; font-size: 10px" class="header">en base a un 
                reporte generado en otro empleador</span><br />
                <span style="margin-left: 10px; font-size: 10px" class="header">para el mismo 
                trabajador</span>
                <br />
                </td>
        </tr>
    </table>
    </fieldset>
    <br />
    <br />
    <br />
    <br />
    
</asp:Content>

