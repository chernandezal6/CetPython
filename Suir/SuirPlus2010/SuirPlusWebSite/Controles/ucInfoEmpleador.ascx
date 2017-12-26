<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucInfoEmpleador.ascx.vb" Inherits="Controles_ucInfoEmpleador" %>
<TABLE class="td-content" id="Table2" cellSpacing="0" cellPadding="0" width="550">
    <tr>
        <td align="right" style="width: 91px; height: 12px">
            RNC:</td>
        <td style="height: 12px">
            <asp:label id="lblRNC" runat="server" cssclass="labelData"></asp:label></td>
        <td style="width: 87px; height: 12px" align="right">
            Registro Patronal:</td>
        <td style="height: 12px">
            <asp:label id="lblRegPatronal" Runat="server" CssClass="labelData"></asp:label></td>
    </tr>
	<TR>
		<TD align="right">Razón Social:</TD>
		<TD colspan="3"><asp:label id="lblRazonSocial" runat="server" cssclass="labelData"></asp:label></TD>
	</TR>
	<TR>
		<TD style="width: 91px" align="right">Nombre Comercial:</TD>
		<TD colspan="3"><asp:label id="lblNombreComercial" runat="server" cssclass="labelData"></asp:label></TD>
	</TR>
</TABLE>
