<%@ Control Language="VB" AutoEventWireup="false" CodeFile="UCSubEncabezadoEmp.ascx.vb" Inherits="Controles_UCSubEncabezadoEmp" %>

<table class="td-content" id="Table1" 
    border="0" align="center">
	<tr>
		<td style="HEIGHT: 21px" align="right" nowrap="nowrap">Empleador Actual&nbsp;
		</td>
		<td class="labelData" style="HEIGHT: 21px" nowrap="nowrap"><asp:label id="lblRazonSocial" runat="server"></asp:label></td>
		
		<td>&nbsp;&nbsp;</td>
		<td style="HEIGHT: 21px" align="right" nowrap="nowrap">RNC / Cédula&nbsp;
		</td>
		<td class="labelData" style="HEIGHT: 21px" nowrap="nowrap"><asp:label id="lblRncCedula" runat="server"></asp:label></td>
        <td>&nbsp;&nbsp;</td>
        <td class="labelData" rowspan="2" nowrap="nowrap" align="right">
				<asp:Button id="btnTerminarSession" runat="server" Text="Terminar Sesión de Representante" CausesValidation="False"></asp:Button></td>
	</tr>
	<!-- Panel de informacion del representante -->
	<asp:panel id="pnlInfoRep" Runat="server">
		<tr>
			<td align="right" nowrap="nowrap">Representante&nbsp;
			</td>
			<td class="labelData" nowrap="nowrap">
				<asp:Label id="lblNombreRep" runat="server"></asp:Label></td>
			<td>&nbsp;&nbsp;</td>	
			<td align="right" nowrap="nowrap">Cédula&nbsp;
			</td>
			<td class="labelData" nowrap="nowrap">
				<asp:Label id="lblCedula" runat="server"></asp:Label></td>
			<td>&nbsp;&nbsp;</td>	
		</tr>
	</asp:panel>
	<!-- Fin del panel de informacion del representante -->
</table>

