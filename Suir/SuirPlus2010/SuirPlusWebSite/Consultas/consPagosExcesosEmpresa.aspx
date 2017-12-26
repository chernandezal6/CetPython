<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consPagosExcesosEmpresa.aspx.vb" Inherits="Consultas_consPagosExcesosEmpresa" title="Consulta de reembolso por pagos en exceso" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
     <script type="text/javascript">

         if (top != self) top.location.replace(location.href); 
    
    </script>
    <img alt="Tesoreria de la Seguridad Social" 
        src="../images/logoTSShorizontal.gif" />
    <div class="header">Consulta de reembolso por pagos en exceso al empleador</div><br />
    
      
    <script language="javascript" type="text/javascript">
        function checkNum() {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false;
            }
        }

	</script>

    <table border="0" cellpadding="1" cellspacing="1" class="consultaTabla" style="font-size: 13pt;
        color: #006699; font-family: Verdana" width="370">
        <tr>
            <td>
                <table id="Table1" cellpadding="0" cellspacing="0" class="td-content">
                    <tr>
                        <td style="width: 455px">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td valign="top" style="text-align: center; width: 455px;" >
                            RNC:
                            (sin guiones)</td>
                    </tr>
                    <tr>
                        <td style="height: 12px; text-align: center; width: 455px;" valign="top">
                                <asp:TextBox onKeyPress="checkNum()" ID="txtnodocumento" runat="server" MaxLength="11"></asp:TextBox><asp:RegularExpressionValidator
                                ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtnodocumento"
                                Display="Dynamic" ErrorMessage="Debe ser numérico el valor" ValidationExpression="\d*"></asp:RegularExpressionValidator></td>
                    </tr>
                    <tr>
                        <td align="center" style="width: 455px"><br />
                            <asp:Button ID="btBuscarRef" runat="server" Enabled="True" EnableViewState="False"
                                Text="Buscar" />
                            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" /></td>
                    </tr>
                    <tr>
                        <td><br /></td>
                    </tr>
                    </table>
                <asp:Label ID="lblError" runat="server" CssClass="error" Font-Size="8pt" Visible="False"></asp:Label></td>
        </tr>
    </table>
 
    <br />
                <asp:Panel ID="pnlInfo" runat="server" Visible="False" Width="543px">
    <table border="0" cellpadding="0" cellspacing="0"  style="width:543px" class="td-content" runat="server" visible="true">
        <tr>
            <td colspan="2" id="TD1" runat="server">
                <asp:Label ID="Label8" runat="server" Text="Detalle" CssClass="subHeader" 
                    Font-Size="Small"></asp:Label>
                <br />               
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label5" runat="server" Text="RNC:" Font-Size="Small"></asp:Label></td>
            <td>
                &nbsp;
                <asp:Label ID="lblRNC" runat="server" Font-Bold="True" Font-Size="Small" 
                    CssClass="subHeader"></asp:Label></td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label6" runat="server" Text="Razon Social:" Font-Size="Small"></asp:Label></td>
            <td>
                &nbsp;
                <asp:Label ID="lblRazonSocial" runat="server" Font-Bold="True" Font-Size="Small" 
                    CssClass="subHeader"></asp:Label></td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label9" runat="server" Font-Size="Small" 
                    Text="Nombre Comercial:"></asp:Label>
            </td>
            <td>
                &nbsp;
                <asp:Label ID="lblNombreComercial" runat="server" CssClass="subHeader" Font-Bold="True" 
                    Font-Size="Small"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label11" runat="server" Font-Size="Small" 
                    Text="Monto Reembolso Empresa:"></asp:Label>
            </td>
            <td>
                &nbsp;
                <asp:Label ID="lblMontoEmpresa" runat="server" CssClass="subHeader" 
                    Font-Bold="True" Font-Size="Small"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label10" runat="server" Font-Size="Small" 
                    Text="Monto Reembolso Trabajadores:"></asp:Label>
            </td>
            <td>
                &nbsp;
                <asp:Label ID="lblMontoTrabajador" runat="server" CssClass="subHeader" Font-Bold="True" 
                    Font-Size="Small"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label12" runat="server" Font-Size="Small" 
                    Text="Total Reembolso:"></asp:Label>
            </td>
            <td>
                &nbsp;
                <asp:Label ID="lblTotal" runat="server" CssClass="subHeader" Font-Bold="True" 
                    Font-Size="Small"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
    </table>
                </asp:Panel>

</asp:Content>

