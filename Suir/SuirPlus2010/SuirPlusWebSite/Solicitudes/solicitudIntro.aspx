<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="solicitudIntro.aspx.vb" Inherits="Solicitudes_solicitudIntro" title="Solicitudes - TSS" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
					<br />
	                  <div class="header" >
                          <span style="font-size: 23px">
                          <span style="font-size: 26px"><strong>
                              <br />
                          </strong>
                          </span>
                          </span>
                      </div>
                   
    <table border="1" cellpadding="0" cellspacing="0">
        <tr>
            <td align="center" colspan="3">
                              <asp:Label ID="Label4" runat="server" Text="Solicitud de servicios" style="font-size: 20pt; color: #006699; font-family: Verdana" Font-Bold="True" Font-Size="11pt"></asp:Label></td>
        </tr>
        <tr >
            <td align="center">
                <strong><span style="font-size: 14pt; color: #006699; font-family: Verdana">
                <asp:Label ID="Label1" runat="server" Text="SOLICITUDES"></asp:Label></span></strong></td>
            <td align="center">
                <strong><span style="font-size: 14pt; color: #006699; font-family: Verdana">
                    <asp:Label ID="Label2" runat="server" Text="CONSULTAS"></asp:Label></span></strong></td>
            <td align="center">
                <strong><span style="font-size: 14pt; color: #006699; font-family: Verdana">
                    <asp:Label ID="Label3" runat="server" aText="OTROS">OTROS</asp:Label></span></strong></td>
        </tr>
        <tr>
            <td style="width: 111px; height: 16px;">
                        <asp:LinkButton ID="lnkRegEmpresa" runat="server" Width="181px" Font-Bold="True" Font-Italic="False" ForeColor="#006699" CssClass="subHeader">Registro de Empresa</asp:LinkButton></td>
            <td style="width: 130px; height: 16px;">
                        <asp:LinkButton ID="lkConsulSolicitud" runat="server" ForeColor="#006699" Width="218px" CssClass="subHeader">Consulta de Solicitud por número</asp:LinkButton></td>
            <td style="width: 110px; height: 16px;">
                        <asp:LinkButton ID="lnkCalcAporte" runat="server"  Width="181px" ForeColor="#006699" CssClass="subHeader">Cálculo de Aportes</asp:LinkButton></td>
        </tr>
        <tr>
            <td style="width: 111px; height: 14px;">
            <asp:LinkButton ID="lkRecClave" runat="server" Width="219px" ForeColor="#006699" CssClass="subHeader">Recuperación de Clave de Acceso</asp:LinkButton></td>
            <td style="width: 130px; height: 14px;">
            <asp:LinkButton ID="lkConslRNC" runat="server" Width="202px" ForeColor="#006699" CssClass="subHeader">Consulta de Solicitud por RNC</asp:LinkButton></td>
            <td style="width: 110px; height: 14px;">
        <asp:LinkButton ID="lkPreguntasF" runat="server" ForeColor="#006699" CssClass="subHeader" Width="167px">Preguntas Frecuentes</asp:LinkButton></td>
        </tr>
        <tr>
            <td style="width: 111px; height: 16px;">
                        <asp:LinkButton ID="lkNomina" runat="server" Width="218px" ForeColor="#006699" CssClass="subHeader">Registro de Nómina o Novedades</asp:LinkButton></td>
            <td style="width: 130px; height: 16px;">
                        <asp:LinkButton ID="lkNSS" runat="server" ForeColor="#006699" CssClass="subHeader">Consulta de NSS</asp:LinkButton></td>
            <td style="width: 110px; height: 16px;">
                        <asp:LinkButton ID="lkDirectorio" runat="server" Width="264px" ForeColor="#006699" CssClass="subHeader">Directorio del Sistema de Seguridad Social</asp:LinkButton></td>
        </tr>
        <tr>
            <td style="width: 111px; height: 14px;">
                        <asp:LinkButton ID="LkMail" runat="server" Width="188px" ForeColor="#006699" CssClass="subHeader">Recibir su Factura por Mail</asp:LinkButton></td>
            <td style="width: 130px; height: 14px;">
                        <asp:LinkButton ID="lkAfiliado" runat="server" Width="312px" ForeColor="#006699" CssClass="subHeader">Consulta de Afiliación al Seguro Familiar de Salud</asp:LinkButton></td>
            <td style="width: 110px; height: 14px;">
                        <asp:LinkButton ID="lkOficina" runat="server" ForeColor="#006699" CssClass="subHeader">Oficinas de la TSS</asp:LinkButton></td>
        </tr>
        <tr>
            <td style="width: 111px; height: 18px;">
                        <asp:LinkButton ID="lkEstadoCuenta" runat="server" ForeColor="#006699" CssClass="subHeader">Estado de Cuenta</asp:LinkButton></td>
            <td style="width: 130px; height: 18px;">
                        <asp:LinkButton ID="lnkConsultaSP" runat="server" Width="280px" ForeColor="#006699" CssClass="subHeader">Consulta Salud Pensionados</asp:LinkButton>
            </td>
            <td style="width: 110px; height: 18px;">
                        <asp:LinkButton ID="lkGlosario" runat="server" Width="280px" ForeColor="#006699" CssClass="subHeader">Glosario de Términos de la Seguridad Social</asp:LinkButton></td>
        </tr>
        <tr>
            <td style="width: 111px; height: 16px;">
                        <asp:LinkButton ID="lkSolicitud" runat="server" ForeColor="#006699" CssClass="subHeader">Solicitud General</asp:LinkButton></td>
            <td style="width: 130px; height: 16px;" ForeColor="#006699">
                        <asp:LinkButton ID="lnkConsultaAFP" runat="server" Width="280px" 
                    ForeColor="#006699" CssClass="subHeader">Consulta AFP</asp:LinkButton>
            </td>
            <td style="width: 110px; height: 16px;" ForeColor="#006699">
                &nbsp;</td>
        </tr>
        <tr>
            <td style="width: 111px; height: 18px;">
                        <asp:LinkButton ID="lkInfoPublica" runat="server" ForeColor="#006699" CssClass="subHeader" Width="140px">Información Pública</asp:LinkButton></td>
            <td style="width: 130px; height: 18px;" ForeColor="#006699">
                &nbsp;</td>
            <td style="width: 110px; height: 18px;" ForeColor="#006699">
                &nbsp;</td>
        </tr>
    </table>
    <br />
    <br />
        
      
</asp:Content>

