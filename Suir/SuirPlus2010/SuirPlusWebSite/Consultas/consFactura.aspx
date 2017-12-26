<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consFactura.aspx.vb" Inherits="Consultas_consFactura" title="Notificaciones por Nro. de Referencia" %>
<%@ Register Src="../Controles/UCInfoPagoRef.ascx" TagName="UCInfoPagoRef" TagPrefix="uc5" %>
<%@ Register Src="../Controles/ucLiquidacionInfotepEnc.ascx" TagName="ucLiquidacionInfotepEnc" TagPrefix="uc4" %>
<%@ Register Src="../Controles/ucIR17Encabezado.ascx" TagName="ucIR17Encabezado" TagPrefix="uc3" %>
<%@ Register Src="../Controles/ucLiquidacionISREncabezado.ascx" TagName="ucLiquidacionISREncabezado" TagPrefix="uc2" %>
<%@ Register Src="../Controles/ucNotificacionTSSEncabezado.ascx" TagName="ucNotificacionTSSEncabezado" TagPrefix="uc1" %>
<%@ Register src="../Controles/ucPlanillasMDTencabezado.ascx" tagname="ucPlanillasMDTencabezado" tagprefix="uc6" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script language="vb" runat="server">
        Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
            Me.PermisoRequerido = 61
        End Sub
	</script>
	
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
         
     function Sel()
     {
            if ((document.aspnetForm.ctl00$MainContent$txtReferencia.value.length) < 10)
            {
                document.aspnetForm.ctl00$MainContent$drpTipoConsulta.options[1].selected = true;
            }
            else
            {
                document.aspnetForm.ctl00$MainContent$drpTipoConsulta.options[0].selected = true;
            }
     }
	</script>

    <asp:updatepanel runat="server" id="updPanel">
        <contenttemplate>
	        <asp:label id="lblTitulo" Runat="server" CssClass="header">Notificaciones por Nro. de Referencia</asp:label>
	        <br />
            <br />
            <table class="tblWithImagen" style="BORDER-COLLAPSE: collapse" cellspacing="1" cellpadding="1">
                <tr>
                    <td rowspan="4" >
                        <img src="../images/calcfactura.jpg"  alt="" />
                     </td>
                    <td><br />&nbsp;
                        <asp:dropdownlist id="drpTipoConsulta" runat="server" CssClass="dropDowns">
				        <asp:ListItem Value="R">Nro. Referencia</asp:ListItem>
				        <asp:ListItem Value="A">Nro. Autorización</asp:ListItem></asp:dropdownlist></td>
                    <td><br />
			            &nbsp;<asp:TextBox onKeyPress="checkNum()" OnKeyUp="Sel()" onChange="Sel()" id="txtReferencia" runat="server" MaxLength="16"></asp:TextBox></td>
                </tr>
                <tr>
                    <td style="text-align: right" colspan="2" >
                        &nbsp;</td>
                </tr>
                <tr>
                    <td style="text-align: center" colspan="2" >
			            <asp:Button id="btBuscar" runat="server" Text="Buscar"></asp:Button>&nbsp;&nbsp;&nbsp;
			            <asp:Button id="btLimpiar" runat="server" Text="Limpiar" EnableViewState="False" CausesValidation="False"></asp:Button></td>
                </tr>
                <tr>

                    <td colspan="2" style="text-align: center; height: 18px;">
				        <asp:RequiredFieldValidator id="RequiredFieldValidator" runat="server" Display="Dynamic" ErrorMessage="Nro. de Referencia y/o Autorizacion es requerido."
					        ControlToValidate="txtReferencia" Font-Bold="True"></asp:RequiredFieldValidator><br />
				        <asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" Display="Dynamic" ValidationExpression="0*[1-9][0-9]*"
					        ErrorMessage="Referencia y/o Autorización Inválida" ControlToValidate="txtReferencia" Font-Bold="True"></asp:regularexpressionvalidator><asp:label CssClass="error" id="lblMensaje" runat="server" EnableViewState="False" />&nbsp;
                    </td>
                </tr>
            </table>
            <br />
            <uc1:ucNotificacionTSSEncabezado ID="ucNotTSS" runat="server" Visible="false" />
            <uc2:ucLiquidacionISREncabezado ID="ucLiqISR" runat="server" Visible="False" />    
            <uc3:ucIR17Encabezado ID="UcIR17Encabezado" runat="server" Visible="false" />
            <uc4:ucLiquidacionInfotepEnc ID="ucLiqInfotep" runat="server" Visible="false" />
            <uc6:ucPlanillasMDTencabezado ID="ucPlanillasMDT" runat="server" Visible="false" />
            <uc5:UCInfoPagoRef ID="ucInfoPago" runat="server" Visible="false" />    
        </contenttemplate>
    </asp:updatepanel>    
</asp:Content>