<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consARS.aspx.vb" Inherits="Consultas_consARS" title="Consulta de ARS por Periodo" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script language="javascript" type="text/javascript">
	function checkNum()
	    {
            var carCode = event.keyCode;
            
            if ((carCode < 48) || (carCode > 57))
                {
                    event.cancelBubble = true	
                    event.returnValue = false;	
                 }
            }
            function Limpiar() {

                window.location = "ConsArs.aspx";

            }
         </script>
    <div class="header">Consulta de ARS Por Periodo</div><br>
    <table cellpadding="1" cellspacing="0" class="td-content" style="width: 400px">
        <tr>
            <td style="height:5px;" colspan="2">
                <asp:Label ID="lblMsg" runat="server" CssClass="error" EnableViewState="False"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">Nro. Documento:</td>
            <td><asp:TextBox ID="txtDocumento" onKeyPress="checkNum()" runat="server" 
                    MaxLength="11" EnableViewState="False" /></td>                          
        </tr>
        <tr>
            <td align="right">
                NSS:</td>
            <td>
                <asp:TextBox ID="txtNSS" runat="server"  onKeyPress="checkNum()" MaxLength="9" EnableViewState="False"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtNSS"
                    CssClass="error" ErrorMessage="RegularExpressionValidator" ValidationExpression="^(\d{9})$" ValidationGroup="Ciudadano" Enabled="False">NSS Inválido</asp:RegularExpressionValidator></td>
        </tr>
        <tr>
            <td align="right">
            </td>
            <td>
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" ValidationGroup="Ciudadano" />
                    <INPUT type="button" value="Limpiar" onClick="location.href='ConsArs.aspx'"/>

                </td>
        </tr>
        </table>
    <br />
    <div id="divConsecutivas" class="labelData" style="width: 400px" runat="server"
        visible="False">
        Cantidad de Cotizaciones en el SFS continuas:&nbsp;
        <asp:Label ID="lblConsecutivos" runat="server"></asp:Label>
        <br />
        Nombre del afiliado:&nbsp;
        <asp:Label ID="lblNombreAfiliado" runat="server"></asp:Label>
    </div>
    <br />
    <asp:Panel ID="Panel1" runat="server">
        <ajaxToolkit:TabContainer ID="tc1" runat="server">
            <ajaxToolkit:TabPanel ID="tpbase" runat="server" HeaderText="Resultados">
                <ContentTemplate>
                
                <asp:Literal runat="server" ID="ojk" Text="0 Resultados"></asp:Literal>
                </ContentTemplate>
            </ajaxToolkit:TabPanel>
        </ajaxToolkit:TabContainer>
    </asp:Panel>       
</asp:Content>

