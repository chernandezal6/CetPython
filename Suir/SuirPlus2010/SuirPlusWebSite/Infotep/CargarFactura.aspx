<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CargarFactura.aspx.vb" Inherits="INFOTEP_CargarFactura" title="Untitled Page" %>
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

	</script>
    <table border="0" cellpadding="0" cellspacing="2" class="td-content" width="600">
        <tr>
            <td colspan="4" style="height: 12px">
                <table cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td>
                            <span class="header">REGISTO ACUERDOS DE PAGO INFOTEP</span></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="width: 16%; height: 12px">
                RNC o Cédula</td>
            <td align="left" colspan="3" style="height: 12px" valign="top">
                <asp:TextBox ID="txtRNC"  onKeyPress="checkNum()" runat="server" Width="176px"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="height: 12px">
                Periodo</td>
            <td colspan="3" style="height: 12px">
                <asp:TextBox ID="txtPeriodo" onKeyPress="checkNum()" runat="server" Width="176px"></asp:TextBox></td>
        </tr>
        <tr>
            <td>
                Monto</td>
            <td colspan="3">
                <asp:TextBox ID="txtMonto" onKeyPress="checkNum()" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="4" style="height: 7px">
                <asp:Button ID="btAgregar" runat="server" Text="Agregar" />
                &nbsp;
                <asp:Button ID="btLimpiar" runat="server" Text="Limpiar" /></td>
        </tr>
    </table>
    <asp:Label ID="lblmensaje" runat="server" CssClass="error"></asp:Label>
</asp:Content>

